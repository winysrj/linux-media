Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50945 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1LSRZp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 12:25:45 -0500
Message-ID: <4EEF7395.6060201@iki.fi>
Date: Mon, 19 Dec 2011 19:25:41 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Christoph Pfister <christophpfister@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: [PATCH dvb-apps] DVB-H R.I.P.
Content-Type: multipart/mixed;
 boundary="------------010509060103030208080309"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010509060103030208080309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

It is R.I.P.

Finland is now switching from DVB-H to DVB-T2 in case of mobile 
transmission too. Some of the DVB-H transmitters are shut down already 
and all the rest are closed before 31.3.2012.

Mobile TV/Radio evolution have been rather interesting here, from DAB to 
DVB-H to DVB-T2. I really hope DVB-T2 will be big success finally.

1997-2005 DAB
2006-2011 DVB-H
2012-> DVB-T2


regards
Antti

-- 
http://palosaari.fi/

--------------010509060103030208080309
Content-Type: text/plain;
 name="dvb-h-rip.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dvb-h-rip.patch"

diff -r b68e7cff5b3a util/scan/dvb-h/README
--- a/util/scan/dvb-h/README	Mon Dec 19 19:14:09 2011 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,3 +0,0 @@
-These files are mainly for informational and experimental purposes.
-The DVB-H file format hasn't been specified in any way; currently it's just
-a copy of the DVB-T format.
diff -r b68e7cff5b3a util/scan/dvb-h/fi-Helsinki
--- a/util/scan/dvb-h/fi-Helsinki	Mon Dec 19 19:14:09 2011 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,2 +0,0 @@
-# H freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-H 586000000 8MHz 1/2 NONE QAM16 8k 1/8 NONE
diff -r b68e7cff5b3a util/scan/dvb-h/fi-Oulu
--- a/util/scan/dvb-h/fi-Oulu	Mon Dec 19 19:14:09 2011 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,2 +0,0 @@
-# H freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-H 498000000 8MHz 1/2 NONE QAM16 8k 1/8 NONE
diff -r b68e7cff5b3a util/scan/dvb-h/fi-Oulu-Nokia-devel
--- a/util/scan/dvb-h/fi-Oulu-Nokia-devel	Mon Dec 19 19:14:09 2011 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,4 +0,0 @@
-# Nokia Oulu delelopment network
-# Network Name 'Nokia Oulu'
-# H freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-H 690000000 8MHz 1/2 NONE QPSK 8k 1/8 NONE
diff -r b68e7cff5b3a util/scan/dvb-h/fi-Turku
--- a/util/scan/dvb-h/fi-Turku	Mon Dec 19 19:14:09 2011 +0200
+++ /dev/null	Thu Jan 01 00:00:00 1970 +0000
@@ -1,2 +0,0 @@
-# H freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
-H 498000000 8MHz 1/2 NONE QAM16 8k 1/8 NONE

--------------010509060103030208080309--
