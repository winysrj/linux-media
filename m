Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:34807 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbZCDKLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 05:11:20 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] Typo in lnbp21.c / changeset: 10800:ba740eb2348e
Date: Wed, 4 Mar 2009 11:11:14 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DPlrJE2YdkEFsko"
Message-Id: <200903041111.15083.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_DPlrJE2YdkEFsko
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there!

lnbp21 does show strange messages at depmod.

WARNING: Loop detected: /lib/modules/2.6.28-tuxonice-r1/v4l/lnbp21.ko which 
needs lnbp21.ko again!
WARNING: Module /lib/modules/2.6.28-tuxonice-r1/v4l/lnbp21.ko ignored, due to 
loop

So I had a look at latest change and noticed there was a typo in the function 
name, it should be lnbh24_attach, and not lnbp24_attach I guess.
The attached patch fixes this.

Regards
Matthias

--Boundary-00=_DPlrJE2YdkEFsko
Content-Type: text/x-diff;
  charset="utf-8";
  name="lnbp21-typo.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="lnbp21-typo.diff"

diff -r 8ebe62795b47 linux/drivers/media/dvb/frontends/lnbp21.c
--- a/linux/drivers/media/dvb/frontends/lnbp21.c	Tue Mar 03 23:05:45 2009 -0300
+++ b/linux/drivers/media/dvb/frontends/lnbp21.c	Wed Mar 04 10:34:57 2009 +0100
@@ -138,7 +138,7 @@
 	return fe;
 }
 
-struct dvb_frontend *lnbp24_attach(struct dvb_frontend *fe,
+struct dvb_frontend *lnbh24_attach(struct dvb_frontend *fe,
 				struct i2c_adapter *i2c, u8 override_set,
 				u8 override_clear, u8 i2c_addr)
 {

--Boundary-00=_DPlrJE2YdkEFsko--
