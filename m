Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50438 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 08/14] it913x: fix tuner sleep power leak
Date: Sat,  9 Aug 2014 23:27:06 +0300
Message-Id: <1407616032-2722-9-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

IT913x tuner driver disables own clock, provided by demod core, as
very a first operation when tuner is put on *sleep*. That likely
causes failure of all the rest commands on sleep sequence, which
leads situation where tuner is not actually on sleep, but consuming
a lot of power.

I measured 102mA current consumption from the USB before change
and after change it was only 32mA. Used device was single tuner
IT9135 BX.

Second reason to remove that register from tuner driver is reason
it is simply on wrong driver (demod vs. tuner), breaking the
principle of correct driver.

Clock is now provided more correctly af9033 demod driver as a
config option.

Cc: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tuner_it913x.c      | 1 -
 drivers/media/tuners/tuner_it913x_priv.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/media/tuners/tuner_it913x.c b/drivers/media/tuners/tuner_it913x.c
index 3d83c42..3265d9a 100644
--- a/drivers/media/tuners/tuner_it913x.c
+++ b/drivers/media/tuners/tuner_it913x.c
@@ -202,7 +202,6 @@ static int it913x_init(struct dvb_frontend *fe)
 
 	/* Power Up Tuner - common all versions */
 	ret = it913x_wr_reg(state, PRO_DMOD, 0xec40, 0x1);
-	ret |= it913x_wr_reg(state, PRO_DMOD, 0xfba8, 0x0);
 	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec57, 0x0);
 	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec58, 0x0);
 
diff --git a/drivers/media/tuners/tuner_it913x_priv.h b/drivers/media/tuners/tuner_it913x_priv.h
index ce65210..8e85a61 100644
--- a/drivers/media/tuners/tuner_it913x_priv.h
+++ b/drivers/media/tuners/tuner_it913x_priv.h
@@ -38,7 +38,6 @@ struct it913xset {	u32 pro;
 
 /* Tuner setting scripts (still keeping it9137) */
 static struct it913xset it9137_tuner_off[] = {
-	{PRO_DMOD, 0xfba8, {0x01}, 0x01}, /* Tuner Clock Off  */
 	{PRO_DMOD, 0xec40, {0x00}, 0x01}, /* Power Down Tuner */
 	{PRO_DMOD, 0xec02, {0x3f, 0x1f, 0x3f, 0x3f}, 0x04},
 	{PRO_DMOD, 0xec06, {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-- 
http://palosaari.fi/

