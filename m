Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:34657 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731Ab1DHTe3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Apr 2011 15:34:29 -0400
Message-ID: <4D9F6341.9020107@iki.fi>
Date: Fri, 08 Apr 2011 22:34:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Christoph Pfister <christophpfister@gmail.com>
Subject: update fi-dna initial tuning file
Content-Type: multipart/mixed;
 boundary="------------040708040305070607070201"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------040708040305070607070201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Moikka Christoph,

Merge attached patch.

Antti
-- 
http://palosaari.fi/

--------------040708040305070607070201
Content-Type: text/plain;
 name="2011-04-08-fi-dna.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2011-04-08-fi-dna.patch"

diff -r 59e55f42ab69 util/scan/dvb-c/fi-dna
--- a/util/scan/dvb-c/fi-dna	Wed Apr 06 06:50:51 2011 -0300
+++ b/util/scan/dvb-c/fi-dna	Fri Apr 08 22:32:15 2011 +0300
@@ -1,15 +1,24 @@
 # DNA network reference channels
+# updated 2011-04-08 Antti Palosaari <crope@iki.fi>
+# http://www.dna.fi/YKSITYISILLE/TV/KAAPELITV/Sivut/Taajuudet.aspx
+#
 # freq      sr      fec  mod
 C 154000000 6875000 NONE QAM128
 C 162000000 6875000 NONE QAM128
+C 162000000 6875000 NONE QAM256
 C 170000000 6875000 NONE QAM128
-C 232000000 6875000 NONE QAM128
-C 250000000 6875000 NONE QAM128
-C 258000000 6875000 NONE QAM128
-C 266000000 6875000 NONE QAM128
-C 274000000 6875000 NONE QAM128
-C 290000000 6875000 NONE QAM128
+C 226000000 6875000 NONE QAM128
+C 234000000 6875000 NONE QAM128
+C 242000000 6875000 NONE QAM128
+C 242000000 6875000 NONE QAM256
+C 250000000 6875000 NONE QAM256
+C 258000000 6875000 NONE QAM256
+C 266000000 6875000 NONE QAM256
+C 274000000 6875000 NONE QAM256
+C 282000000 6875000 NONE QAM256
+C 290000000 6875000 NONE QAM256
 C 298000000 6875000 NONE QAM128
+C 298000000 6875000 NONE QAM256
 C 306000000 6875000 NONE QAM128
 C 314000000 6875000 NONE QAM128
 C 322000000 6875000 NONE QAM128
@@ -18,8 +27,8 @@
 C 346000000 6875000 NONE QAM128
 C 354000000 6875000 NONE QAM128
 C 362000000 6875000 NONE QAM128
+C 362000000 6875000 NONE QAM256
 C 370000000 6875000 NONE QAM128
 C 378000000 6875000 NONE QAM128
+C 386000000 6875000 NONE QAM128
 C 394000000 6875000 NONE QAM128
-C 402000000 6875000 NONE QAM128
-C 450000000 6875000 NONE QAM128

--------------040708040305070607070201--
