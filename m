Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01.ipfire.org ([178.63.73.247]:57048 "EHLO
	mail01.ipfire.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab2JYNLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 09:11:43 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Oct 2012 13:01:32 +0000
From: Arne Fitzenreiter <Arne.Fitzenreiter@ipfire.org>
To: <linux-media@vger.kernel.org>, <mchehab@redhat.com>
Subject: [PATCH] [media] fix tua6034 pll bandwich configuration
Message-ID: <d136f2fd53c39338e9d4c68caf39be40@mail01.ipfire.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit 80d8d4985f280dca3c395286d13b49f910a029e7 introduce a bug
that set the wrong bandwich bit on the tua6034 pll.

Signed-off-by: Arne Fitzenreiter <Arne.Fitzenreiter@ipfire.org>

diff -Naur a/drivers/media/dvb-frontends/dvb-pll.c 
b/drivers/media/dvb-frontends/dvb-pll.c
--- a/drivers/media/dvb-frontends/dvb-pll.c	2012-08-14 
05:45:22.000000000 +0200
+++ b/drivers/media/dvb-frontends/dvb-pll.c	2012-10-25 
14:06:42.123360189 +0200
@@ -247,7 +247,7 @@
 static void tua6034_bw(struct dvb_frontend *fe, u8 *buf)
 {
 	u32 bw = fe->dtv_property_cache.bandwidth_hz;
-	if (bw == 7000000)
+	if (bw != 7000000)
 		buf[3] |= 0x08;
 }

