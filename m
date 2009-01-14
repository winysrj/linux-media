Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:30658 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927AbZANR4n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Jan 2009 12:56:43 -0500
Message-ID: <496E2758.70403@iki.fi>
Date: Wed, 14 Jan 2009 19:56:40 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>, linux-media@vger.kernel.org,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Initial tuning file update for fi-*
Content-Type: multipart/mixed;
 boundary="------------080708090001070406040207"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080708090001070406040207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Updates for Finland.

Antti
-- 
http://palosaari.fi/

--------------080708090001070406040207
Content-Type: text/plain;
 name="fi-update_2009-01-14.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fi-update_2009-01-14.patch"

diff -r b59999438d50 util/scan/dvb-t/fi-Parikkala
--- a/util/scan/dvb-t/fi-Parikkala	Wed Jan 14 18:42:07 2009 +0100
+++ b/util/scan/dvb-t/fi-Parikkala	Wed Jan 14 19:53:14 2009 +0200
@@ -2,3 +2,4 @@
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 554000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
 T 778000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 626000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
diff -r b59999438d50 util/scan/dvb-t/fi-Rautjarvi_Simpele
--- a/util/scan/dvb-t/fi-Rautjarvi_Simpele	Wed Jan 14 18:42:07 2009 +0100
+++ b/util/scan/dvb-t/fi-Rautjarvi_Simpele	Wed Jan 14 19:53:14 2009 +0200
@@ -1,4 +1,4 @@
 # automatically generated from http://www.digitv.fi/sivu.asp?path=1;8224;9519
 # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
 T 610000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 530000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE

--------------080708090001070406040207--
