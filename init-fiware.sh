#!/bin/sh

echo "Waiting for Orion..."
sleep 20

echo "Cleaning subscriptions..."
ids=$(curl -s http://orion:1026/v2/subscriptions \
  -H "fiware-service: openiot" \
  -H "fiware-servicepath: /" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)

for id in $ids; do
  echo "Deleting subscription $id"
  curl -X DELETE http://orion:1026/v2/subscriptions/$id \
    -H "fiware-service: openiot" \
    -H "fiware-servicepath: /"
done

echo "Creating subscription 1..."
curl -iX POST http://orion:1026/v2/subscriptions \
  -H "Content-Type: application/json" \
  -H "fiware-service: openiot" \
  -H "fiware-servicepath: /" \
  -d '{
    "description": "Notify QuantumLeap",
    "subject": { "entities": [{"idPattern": ".*", "type": "SensorDevice"}] },
    "notification": {
      "http": { "url": "http://quantumleap:8668/v2/notify" },
      "attrs": [ "buttonBlue", "buttonRed" ],
      "metadata": ["dateModified"]
    }
}'

echo "Creating subscription 2..."
curl -iX POST http://orion:1026/v2/subscriptions \
  -H "Content-Type: application/json" \
  -H "fiware-service: openiot" \
  -H "fiware-servicepath: /" \
  -d '{
    "description": "Notify QuantumLeap - BottleDetectionJob",
    "subject": { "entities": [{"idPattern": ".*", "type": "BottleDetectionJob"}] },
    "notification": {
      "http": { "url": "http://quantumleap:8668/v2/notify" },
      "attrs": [ "jobId", "status", "bottleCount", "pickX", "pickY", "pickRotation", "error" ],
      "metadata": ["dateModified"]
    }
}'

echo "Creating subscription 3..."
curl -iX POST http://orion:1026/v2/subscriptions \
  -H "Content-Type: application/json" \
  -H "fiware-service: openiot" \
  -H "fiware-servicepath: /" \
  -d '{
    "description": "Notify QuantumLeap - Task Pack Bottle",
    "subject": { "entities": [{"id": "TaskPackBottle:operator-01", "type": "TaskPackBottle"}] },
    "notification": {
      "http": { "url": "http://quantumleap:8668/v2/notify" },
      "attrs": [ "stage" ],
      "metadata": ["dateModified"]
    }
}'