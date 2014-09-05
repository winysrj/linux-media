Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:39413 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbaIEC4K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 22:56:10 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBE00K1NQTKU1A0@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Sep 2014 22:56:08 -0400 (EDT)
Date: Thu, 04 Sep 2014 23:56:03 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Olliver Schinagl <oliver@schinagl.nl>, linux-media@vger.kernel.org,
	Jonathan McCrohan <jmccrohan@gmail.com>
Subject: Added channel parsers for DVB-S2 and DVB-T2 at libdvbv5 and found some
 issues at dtv-scan-tables
Message-id: <20140904235603.31973b7f.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver,

I added some improvements at libdvbv5 to parse the DVB-T2 and DVB-S2 lines
at dtv-scan-tables.

It can now successully parse all correct files there. The patches for
it are already merged upstream at:
	http://git.linuxtv.org/cgit.cgi/v4l-utils.git/

I also added there the Makefile from Jonathan that adds support
for converting from DVBv3 to DVBv5, and added myself some logic
there to convert back from DVBv5 into DVBv3 format.

With that, we can compare and check if everything is being properly
parsed on both ways.

My hope is to remove the DVBv3 files, keeping everything stored at the
DVBv5 format, adding a target to generate the DVBv3 format for the
ones that need it.

While doing that, I noticed that there are some troubles at some of
the existing tables.

I fixed most of them and added on my experimental dtv-scan-tables:
	http://git.linuxtv.org/cgit.cgi/mchehab/dtv-scan-tables.git/

The errors I found are:

1) The dvb-t/ca-AB-Calgary file has an invalid line:
	http://git.linuxtv.org/cgit.cgi/mchehab/dtv-scan-tables.git/commit/?id=b3eeab8ff0f87f0dd7207ff80aaed4e098052bab

2) One FEC on dvb-t/sk-Bratislava is marked as 2/1 (very likely
   instead of 1/2):
	http://git.linuxtv.org/cgit.cgi/mchehab/dtv-scan-tables.git/commit/?id=795628c5ea7b4f99e932b5b243b6ee3a8ebecf0c

3) The dvb-s/Astra-31.5E file has two extra parameters for a DVB-S 
   stream:
	http://git.linuxtv.org/cgit.cgi/mchehab/dtv-scan-tables.git/commit/?id=9b6ba6016d092ce823a60b2eb537dd3ac2efa825

4) Most of the DVB-T2 lines put the PLP at the end, but one of them put
   it, together with another field (system ID?), at the beginning:
	http://git.linuxtv.org/cgit.cgi/mchehab/dtv-scan-tables.git/commit/?id=3c3cd4befd73a5e7fc906224082d197d6b510ea3 

With regards to this extra "system ID" with is always 1 on this file,
I'm assuming that this is bogus. Anyway, dvb-format-tool won't
keep it (see dvb-t/ug-All diff):

-T2 538000000 8MHz AUTO AUTO     AUTO  32k 1/16 AUTO 1 1
-T2 586000000 8MHz AUTO AUTO     AUTO  32k 1/16 AUTO 9 1
+T2 538000000 8MHz AUTO AUTO AUTO 32k 1/16 AUTO 1
+T2 586000000 8MHz AUTO AUTO AUTO 32k 1/16 AUTO 9

There is still one remaining issue affecting two DVB-S files: 
dvb-s/Hotbird-13.0E and dvb-s/Atlantic-Bird-3-5.0W.

There, the DVB-S2 have one (or two) fields that are not part of
the DVBv5 API:

One extra field at Hotbird 13E:


# EUTELSAT SkyPlex, Hotbird 13E
# std freq pol sr fec rolloff mod is_id pls_code pls_mode

S2 11432000 V 27500000 2/3 AUTO 8PSK 1 8
S2 11432000 V 27500000 2/3 AUTO 8PSK 2 8

And two extra fields at Atlantic Bird 3:

# Atlantic Bird 3 @ 5.0W
# std freq pol sr fec rolloff mod is_id pls_code pls_mode

S2 11012000 V 30000000 AUTO AUTO 8PSK 2 16416
S2 11012000 V 30000000 AUTO AUTO 8PSK 3 16416
...

As those parameters don't exist at DVBv5 API, nor at libdvbv5,
a conversion on those files will lose them.

While it shouldn't be hard to add it to libdvbv5, letting it to
parse back and forth, I'm not sure if this is the best way to
proceed, as I'm not sure if they're useful and what program
uses it, if any.

Comments?

Regards,
Mauro


---

As reference, those are the diffs between the original and the parsed
files, after removing all comments with this small script:

$ for i in atsc/* dvb-?/*; do echo $i; perl -ne 's/\s*#.*//; print $_;' <$i >a && mv a $i; done

--- dvb-s/Atlantic-Bird-3-5.0W	2014-09-04 23:48:54.359100590 -0300
+++ dvbv3/dvb-s/Atlantic-Bird-3-5.0W	2014-09-04 23:49:02.740096400 -0300
@@ -1,33 +1,30 @@
-
-
-
-S2 11012000 V 30000000 AUTO AUTO 8PSK 2 16416
-S2 11012000 V 30000000 AUTO AUTO 8PSK 3 16416
-S2 11012000 V 30000000 AUTO AUTO 8PSK 11 16416
-S2 11179000 V 30000000 AUTO AUTO 8PSK 4 16416
-S2 11179000 V 30000000 AUTO AUTO 8PSK 5 16416
-S2 11179000 V 30000000 AUTO AUTO 8PSK 12 16416
-S2 11637000 V 30000000 AUTO AUTO 8PSK 1 16416
-S2 11637000 V 30000000 AUTO AUTO 8PSK 2 16416
-S2 11637000 V 30000000 AUTO AUTO 8PSK 3 16416
-S2 11637000 V 30000000 AUTO AUTO 8PSK 4 16416
-S2 11637000 V 30000000 AUTO AUTO 8PSK 5 16416
-S2 11637000 V 30000000 AUTO AUTO 8PSK 6 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 7 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 8 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 9 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 10 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 11 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 12 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 13 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 14 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 15 16416
-S2 11675000 H 30000000 AUTO AUTO 8PSK 16 16416
-S2 12585000 H 27500000 AUTO AUTO 8PSK 1 8
-S2 12585000 H 27500000 AUTO AUTO 8PSK 2 8
-S2 12606000 V 29900000 AUTO AUTO 8PSK 1 8
-S2 12606000 V 29900000 AUTO AUTO 8PSK 2 8
-S2 12648000 V 29500000 AUTO AUTO 8PSK 1 121212 1
-S2 12648000 V 29500000 AUTO AUTO 8PSK 2 121212 1
-S2 12669000 H 30080000 AUTO AUTO 8PSK 1 8
-S2 12669000 H 30080000 AUTO AUTO 8PSK 2 8
+S2 11012000 V 30000000 AUTO AUTO 8PSK 2
+S2 11012000 V 30000000 AUTO AUTO 8PSK 3
+S2 11012000 V 30000000 AUTO AUTO 8PSK 11
+S2 11179000 V 30000000 AUTO AUTO 8PSK 4
+S2 11179000 V 30000000 AUTO AUTO 8PSK 5
+S2 11179000 V 30000000 AUTO AUTO 8PSK 12
+S2 11637000 V 30000000 AUTO AUTO 8PSK 1
+S2 11637000 V 30000000 AUTO AUTO 8PSK 2
+S2 11637000 V 30000000 AUTO AUTO 8PSK 3
+S2 11637000 V 30000000 AUTO AUTO 8PSK 4
+S2 11637000 V 30000000 AUTO AUTO 8PSK 5
+S2 11637000 V 30000000 AUTO AUTO 8PSK 6
+S2 11675000 H 30000000 AUTO AUTO 8PSK 7
+S2 11675000 H 30000000 AUTO AUTO 8PSK 8
+S2 11675000 H 30000000 AUTO AUTO 8PSK 9
+S2 11675000 H 30000000 AUTO AUTO 8PSK 10
+S2 11675000 H 30000000 AUTO AUTO 8PSK 11
+S2 11675000 H 30000000 AUTO AUTO 8PSK 12
+S2 11675000 H 30000000 AUTO AUTO 8PSK 13
+S2 11675000 H 30000000 AUTO AUTO 8PSK 14
+S2 11675000 H 30000000 AUTO AUTO 8PSK 15
+S2 11675000 H 30000000 AUTO AUTO 8PSK 16
+S2 12585000 H 27500000 AUTO AUTO 8PSK 1
+S2 12585000 H 27500000 AUTO AUTO 8PSK 2
+S2 12606000 V 29900000 AUTO AUTO 8PSK 1
+S2 12606000 V 29900000 AUTO AUTO 8PSK 2
+S2 12648000 V 29500000 AUTO AUTO 8PSK 1
+S2 12648000 V 29500000 AUTO AUTO 8PSK 2
+S2 12669000 H 30080000 AUTO AUTO 8PSK 1
+S2 12669000 H 30080000 AUTO AUTO 8PSK 2
--- dvb-s/Hotbird-13.0E	2014-09-04 23:48:54.464100537 -0300
+++ dvbv3/dvb-s/Hotbird-13.0E	2014-09-04 23:49:02.789096375 -0300
@@ -34,8 +31,8 @@ S 11355000 V 27500000 3/4
-S2 11432000 V 27500000 2/3 AUTO 8PSK 1 8
-S2 11432000 V 27500000 2/3 AUTO 8PSK 2 8
+S2 11432000 V 27500000 2/3 AUTO 8PSK 1
+S2 11432000 V 27500000 2/3 AUTO 8PSK 2
@@ -85,8 +82,8 @@ S 12418000 V 27500000 3/4
-S2 12539000 H 27500000 2/3 AUTO 8PSK 1 8
-S2 12539000 H 27500000 2/3 AUTO 8PSK 2 8
+S2 12539000 H 27500000 2/3 AUTO 8PSK 1
+S2 12539000 H 27500000 2/3 AUTO 8PSK 2
--- dvb-t/au-Darwin	2014-09-04 23:48:54.760100389 -0300
+++ dvbv3/dvb-t/au-Darwin	2014-09-04 23:49:02.974096283 -0300
@@ -1,11 +1,5 @@
-
-
-
-
-
-
-T 564625000 7Mhz 3/4 NONE QAM64 8k 1/16 NONE
+T 564625000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
--- dvb-t/ug-All	2014-09-04 23:48:57.480099029 -0300
+++ dvbv3/dvb-t/ug-All	2014-09-04 23:49:03.357096092 -0300
@@ -1,11 +1,3 @@
-
-
-
-
-
-
-
-
-T2 538000000 8MHz AUTO AUTO     AUTO  32k 1/16 AUTO 1 1
-T2 586000000 8MHz AUTO AUTO     AUTO  32k 1/16 AUTO 9 1
+T2 538000000 8MHz AUTO AUTO AUTO 32k 1/16 AUTO 1
+T2 586000000 8MHz AUTO AUTO AUTO 32k 1/16 AUTO 9

