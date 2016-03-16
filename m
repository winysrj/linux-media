Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:39787 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965207AbcCPMOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 08:14:42 -0400
From: Peter Rosin <peda@lysator.liu.se>
To: Antti Palosaari <crope@iki.fi>
Cc: Peter Rosin <peda@axentia.se>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Peter Rosin <peda@lysator.liu.se>
Subject: [PATCH] [media] m88ds3103: fix undefined division
Date: Wed, 16 Mar 2016 13:14:13 +0100
Message-Id: <1458130453-1421-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Rosin <peda@axentia.se>

s32tmp in the below code may be negative, and dev->mclk_khz is an
unsigned type.

	s32tmp = 0x10000 * (tuner_frequency - c->frequency);
	s32tmp = DIV_ROUND_CLOSEST(s32tmp, dev->mclk_khz);

This is undefined, as DIV_ROUND_CLOSEST is undefined for negative
dividends when the divisor is of unsigned type.

So, change mclk_khz to be signed (s32).

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/dvb-frontends/m88ds3103_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


Note, this was found by code inspection, I don't have the hardware,
I don't know what the consequences of a garbage result are at this
point in the code and the patch has only been build-tested. It looks
obvious enough though. It should probably go to stable as well...

Cheers,
Peter

diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
index eee8c22c51ec..651e005146b2 100644
--- a/drivers/media/dvb-frontends/m88ds3103_priv.h
+++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
@@ -46,7 +46,7 @@ struct m88ds3103_dev {
 	/* auto detect chip id to do different config */
 	u8 chip_id;
 	/* main mclk is calculated for M88RS6000 dynamically */
-	u32 mclk_khz;
+	s32 mclk_khz;
 	u64 post_bit_error;
 	u64 post_bit_count;
 };
-- 
2.1.4

