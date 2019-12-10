#!/bin/bash
  
#cities=('bj' 'cd' 'cq' 'cs' 'dg' 'dl' 'fs' 'gz' 'hz' 'hf' 'jn' 'nj' 'qd' 'sh' 'sz' 'su' 'sy' 'tj' 'wh' 'xm' 'yt')
cities=('bj' 'cd' 'cq' 'cs' 'dg' 'dl' 'fs' 'sh' 'sz' 'gz')

start_time="$(date -u +%s)"

for city in "${cities[@]}"
do
        echo "crawling $city..."
        python3 ershou.py $city &
done

wait

end_time="$(date -u +%s)"
elapsed="$(($end_time-$start_time))"

echo "All crawlers finished in $elapsed seconds!"