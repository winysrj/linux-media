Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:54572 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3BOSh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 13:37:56 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so1529233eaa.9
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 10:37:54 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 1/4] em28xx: remove unused image quality control functions
Date: Fri, 15 Feb 2013 19:38:29 +0100
Message-Id: <1360953512-4133-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360953512-4133-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1360953512-4133-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx.h |   66 -------------------------------------
 1 Datei geändert, 66 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 5f0b2c5..6a9e3e1 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -744,72 +744,6 @@ static inline int em28xx_compression_disable(struct em28xx *dev)
 	return em28xx_write_reg(dev, EM28XX_R26_COMPR, 0x00);
 }
 
-static inline int em28xx_contrast_get(struct em28xx *dev)
-{
-	return em28xx_read_reg(dev, EM28XX_R20_YGAIN) & 0x1f;
-}
-
-static inline int em28xx_brightness_get(struct em28xx *dev)
-{
-	return em28xx_read_reg(dev, EM28XX_R21_YOFFSET);
-}
-
-static inline int em28xx_saturation_get(struct em28xx *dev)
-{
-	return em28xx_read_reg(dev, EM28XX_R22_UVGAIN) & 0x1f;
-}
-
-static inline int em28xx_u_balance_get(struct em28xx *dev)
-{
-	return em28xx_read_reg(dev, EM28XX_R23_UOFFSET);
-}
-
-static inline int em28xx_v_balance_get(struct em28xx *dev)
-{
-	return em28xx_read_reg(dev, EM28XX_R24_VOFFSET);
-}
-
-static inline int em28xx_gamma_get(struct em28xx *dev)
-{
-	return em28xx_read_reg(dev, EM28XX_R14_GAMMA) & 0x3f;
-}
-
-static inline int em28xx_contrast_set(struct em28xx *dev, s32 val)
-{
-	u8 tmp = (u8) val;
-	return em28xx_write_regs(dev, EM28XX_R20_YGAIN, &tmp, 1);
-}
-
-static inline int em28xx_brightness_set(struct em28xx *dev, s32 val)
-{
-	u8 tmp = (u8) val;
-	return em28xx_write_regs(dev, EM28XX_R21_YOFFSET, &tmp, 1);
-}
-
-static inline int em28xx_saturation_set(struct em28xx *dev, s32 val)
-{
-	u8 tmp = (u8) val;
-	return em28xx_write_regs(dev, EM28XX_R22_UVGAIN, &tmp, 1);
-}
-
-static inline int em28xx_u_balance_set(struct em28xx *dev, s32 val)
-{
-	u8 tmp = (u8) val;
-	return em28xx_write_regs(dev, EM28XX_R23_UOFFSET, &tmp, 1);
-}
-
-static inline int em28xx_v_balance_set(struct em28xx *dev, s32 val)
-{
-	u8 tmp = (u8) val;
-	return em28xx_write_regs(dev, EM28XX_R24_VOFFSET, &tmp, 1);
-}
-
-static inline int em28xx_gamma_set(struct em28xx *dev, s32 val)
-{
-	u8 tmp = (u8) val;
-	return em28xx_write_regs(dev, EM28XX_R14_GAMMA, &tmp, 1);
-}
-
 /*FIXME: maxw should be dependent of alt mode */
 static inline unsigned int norm_maxw(struct em28xx *dev)
 {
-- 
1.7.10.4

