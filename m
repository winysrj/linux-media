Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57558 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab2LFJkF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 04:40:05 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so2406053eaa.19
        for <linux-media@vger.kernel.org>; Thu, 06 Dec 2012 01:40:04 -0800 (PST)
Message-ID: <50C067F1.5010606@gmail.com>
Date: Thu, 06 Dec 2012 10:40:01 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: pfister@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: dvb-tools: scan_data/cz-all: 4th multiplex has FEC 3/4
Content-Type: multipart/mixed;
 boundary="------------040404010103010603030905"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040404010103010603030905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


-- 
js

--------------040404010103010603030905
Content-Type: text/x-patch;
 name="scan.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scan.patch"

# HG changeset patch
# User Jiri Slaby <jirislaby@gmail.com>
# Date 1354786687 -3600
# Node ID c72238053530a0ad8e446af2cce0cb8d14c9640a
# Parent  96025655e6e844af2bc69bd368f8d04a4e5bc58b
scan_data/cz-all: 4th multiplex has FEC 3/4

Not 2/3. This I inappropriatelly got from the website. But it is
wrong. 3/4 is definitely correct. Change that so that we can actually
tune that multiplex.

diff -r 96025655e6e8 -r c72238053530 util/scan/dvb-t/cz-All
--- a/util/scan/dvb-t/cz-All	Tue Jun 26 22:28:54 2012 +0200
+++ b/util/scan/dvb-t/cz-All	Thu Dec 06 10:38:07 2012 +0100
@@ -42,11 +42,11 @@
 T 778000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
 T 786000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
 # multiplex 4
-T 506000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 546000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 642000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 658000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 666000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 754000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 810000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
-T 818000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
+T 506000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 546000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 642000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 658000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 666000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 754000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 810000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
+T 818000000 8MHz 3/4 NONE QAM64 8k 1/8 NONE

--------------040404010103010603030905--
