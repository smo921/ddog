# ddog

I spend a lot of time dealing with Datadog in various capacities.  Writing scripts and gluing
together API outputs to investigate the why's and what's of modern observability.

`ddog` is an effort to stop rewriting the same boiler plate API calls and focus on making Datadog fit
into the native Unix shell experience.  Similar to `ls`, `cat`, or `echo` as a way of sourcing
data to feed into shell pipelines.  `ddog` deals with the backend and returns the API results ready
for consumption by other cli tools like `jq`, `grep`, `sed`, and so on.

Like I mentioned.  I spend A LOT of time dealing with Datadog :)

# Usage

`ddog` can be used as a stand alone command, passing `ddog` input via the command line.  `ddog`
can also be run as a REPL, with support for piping results to other cli programs.  `ddog` can also
read command arguments from a file or STDIN.

## REPL
```
12:41 $ ddog
dd> get dashboard 3e7-ne8-zny | jq '.[].id'
"3e7-ne8-zny"
dd> get dashboard 3e7-ne8-zny | jq '.[].layout_type'
"ordered"
dd>
```

## Reading command arguments from a file
```
12:36 $ ddog -f ~/tmp/ids get dashboard | jq '.[].created_at'
"2019-02-15 18:16:24 +0000"
"2020-07-28 03:50:15 +0000"
"2021-06-24 19:47:07 +0000"
"2019-01-22 17:14:17 +0000"
```

## Reading command arguments from STDIN
```
12:37 $ cat tmp/event_dboards | awk -F'/' '{print $3}' | sort | uniq | head | ddog -f - get dashboard | jq  '.[].created_at'
"2020-07-28 03:50:15 +0000"
"2021-06-24 19:47:07 +0000"
"2019-02-15 18:16:24 +0000"
"2019-01-22 17:14:17 +0000"
"2021-03-25 00:03:11 +0000"
"2021-04-27 23:27:09 +0000"
"2019-09-04 07:18:36 +0000"
"2020-09-03 18:43:18 +0000"
"2020-03-11 14:35:03 +0000"
"2015-04-17 10:13:40 +0000"
```
