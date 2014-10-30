Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43002 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161345AbaJ3WoR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 18:44:17 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] cx231xx: remove direct register PWR_CTL_EN modification that switches port3
Date: Thu, 30 Oct 2014 23:43:55 +0100
Message-Id: <1414709035-7729-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <20141030182706.09265d37@recife.lan>
References: <20141030182706.09265d37@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The only remaining place that modifies the relevant bit is in function
cx231xx_set_Colibri_For_LowIF

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-avcore.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index b56bc87..781908b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -2270,7 +2270,6 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 	case POLARIS_AVMODE_ANALOGT_TV:
 
 		tmp |= PWR_DEMOD_EN;
-		tmp |= (I2C_DEMOD_EN);
 		value[0] = (u8) tmp;
 		value[1] = (u8) (tmp >> 8);
 		value[2] = (u8) (tmp >> 16);
@@ -2366,7 +2365,7 @@ int cx231xx_set_power_mode(struct cx231xx *dev, enum AV_MODE mode)
 		}
 
 		tmp &= (~PWR_AV_MODE);
-		tmp |= POLARIS_AVMODE_DIGITAL | I2C_DEMOD_EN;
+		tmp |= POLARIS_AVMODE_DIGITAL;
 		value[0] = (u8) tmp;
 		value[1] = (u8) (tmp >> 8);
 		value[2] = (u8) (tmp >> 16);
-- 
2.1.2

