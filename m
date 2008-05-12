Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sd-green-bigip-207.dreamhost.com ([208.97.132.207]
	helo=spunkymail-a6.g.dreamhost.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lists@dawes.za.net>) id 1JvVTC-0001Q8-86
	for linux-dvb@linuxtv.org; Mon, 12 May 2008 12:41:31 +0200
Received: from [192.168.201.100] (dsl-241-215-25.telkomadsl.co.za
	[41.241.215.25])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by spunkymail-a6.g.dreamhost.com (Postfix) with ESMTP id C86E7109F28
	for <linux-dvb@linuxtv.org>; Mon, 12 May 2008 03:41:17 -0700 (PDT)
Message-ID: <48281E7A.8010006@dawes.za.net>
Date: Mon, 12 May 2008 12:39:54 +0200
From: Rogan Dawes <lists@dawes.za.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------060001010501030501080801"
Subject: [linux-dvb] DVB-T South Africa
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------060001010501030501080801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi folks,

I am trying to get my FlyDVB Trio card working with the trial broadcasts
that are currently underway in South Africa (Johannesburg).

I have got the drivers loaded fine, and used "w_scan" as described on
the wiki to generate an initial tuning file (attached). From there I
used "scan" to construct a channels.conf file (also attached).

However, my problem arises is that there do not seem to be any audio or
video PIDs identified. It is possible that the broadcast is encrypted,
since I see many station names operated by MultiChoice (normally DVB-S
with CA).

I did try using dvbtraffic to see which PIDs were generating the most
data, but entering that as the video PID for an arbitrary station was
unsuccessful. Any ideas what I can try further? Unfortunately, our
"Department of Communications" has not been very communicative about
these trials, so I don't have any more information about how these
stations are being transmitted.

A snippet of dvbtraffic while "tzap RT" was running follows:

-PID--FREQ-----BANDWIDTH-BANDWIDTH-
0000     4 p/s     0 kb/s     7 kbit
0010     1 p/s     0 kb/s     2 kbit
0011    13 p/s     2 kb/s    20 kbit
0015     1 p/s     0 kb/s     2 kbit
0065     3 p/s     0 kb/s     5 kbit
0066     0 p/s     0 kb/s     1 kbit
006f     2 p/s     0 kb/s     4 kbit
0078   106 p/s    19 kb/s   159 kbit
0079     2 p/s     0 kb/s     4 kbit
0083     2 p/s     0 kb/s     4 kbit
008d     2 p/s     0 kb/s     4 kbit
0097     5 p/s     0 kb/s     8 kbit
0098     2 p/s     0 kb/s     4 kbit
00a0   291 p/s    53 kb/s   438 kbit
00a1     2 p/s     0 kb/s     4 kbit
00aa   345 p/s    63 kb/s   519 kbit
00ab     2 p/s     0 kb/s     4 kbit
00b4   381 p/s    69 kb/s   573 kbit
00b5     2 p/s     0 kb/s     4 kbit
00ba     2 p/s     0 kb/s     4 kbit
00bc   246 p/s    45 kb/s   371 kbit
00bd     2 p/s     0 kb/s     4 kbit
00be   400 p/s    73 kb/s   601 kbit
00bf     2 p/s     0 kb/s     4 kbit
00c8   382 p/s    70 kb/s   574 kbit
00c9     2 p/s     0 kb/s     4 kbit
00d2    59 p/s    10 kb/s    89 kbit
00d3     2 p/s     0 kb/s     4 kbit
00dc   435 p/s    79 kb/s   655 kbit
00dd     2 p/s     0 kb/s     4 kbit
0104   341 p/s    62 kb/s   513 kbit
0105     2 p/s     0 kb/s     4 kbit
0118   137 p/s    25 kb/s   206 kbit
0119     2 p/s     0 kb/s     4 kbit
012d     2 p/s     0 kb/s     4 kbit
0141     2 p/s     0 kb/s     4 kbit
014b     2 p/s     0 kb/s     4 kbit
1fff    93 p/s    17 kb/s   140 kbit
2000  3311 p/s   607 kb/s  4980 kbit

To my mind, these all seem *way* too low to be meaningful, right?

Is there anything else I can try?

Thanks

Rogan
P.S. Cc: appreciated, but I do read the list via GMANE as well occasionally.


--------------060001010501030501080801
Content-Type: text/plain;
 name="za-Johannesburg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="za-Johannesburg"

# file automatically generated by w_scan
# (http://wirbel.htpc-forum.de/w_scan/index2.html)
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 554000000 8MHz 1/2 1/2 QPSK 8k 1/4 NONE
T 586000000 8MHz 1/2 1/2 QPSK 8k 1/4 NONE


--------------060001010501030501080801
Content-Type: text/plain;
 name="channels.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="channels.conf"

Radio 2:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:14
RT:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:17
ActX:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:4
MM1:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:5
Hallmark:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:6
MNet:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:7
Discovery:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:8
ChO:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:9
MNet Series:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:10
SABC Africa:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:11
MM2:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:12
Radio1:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:21
Discovery Region:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:15
Radio3:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:23
eTV:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:16
esg:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1
Int Table:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:2
Radio4:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:24
MStar:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:3
SS Max:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:18
MMT Service:554000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:13
E! Entertaiment:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:5
Int Table:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:21
ESG Sagem:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:22
Supersport 1:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:1
SuperSport 2:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:2
SuperSport 3:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:3
MagicWorld:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:4
SABC 1:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:6
CNN:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:7
Channel O:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:9
MTV:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:10
Cartoon Network:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:11
ESG CBMS:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:23
Nat Geo:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_1_2:FEC_1_2:QPSK:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:8


--------------060001010501030501080801
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060001010501030501080801--
