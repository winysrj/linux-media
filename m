Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbbD2XG0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:26 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH 09/27] cx231xx: fix bad indenting
Date: Wed, 29 Apr 2015 20:05:54 -0300
Message-Id: <2090991bed3391cf2a494be25ad7221da43c0edd.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/cx231xx/cx231xx-avcore.c:1598 cx231xx_set_DIF_bandpass() warn: inconsistent indenting
drivers/media/usb/cx231xx/cx231xx-core.c:656 cx231xx_demod_reset() warn: inconsistent indenting
drivers/media/usb/cx231xx/cx231xx-core.c:659 cx231xx_demod_reset() warn: inconsistent indenting
drivers/media/usb/cx231xx/cx231xx-core.c:664 cx231xx_demod_reset() warn: inconsistent indenting
drivers/media/usb/cx231xx/cx231xx-core.c:669 cx231xx_demod_reset() warn: inconsistent indenting
drivers/media/usb/cx231xx/cx231xx-core.c:673 cx231xx_demod_reset() warn: inconsistent indenting
drivers/media/usb/cx231xx/cx231xx-417.c:1164 cx231xx_initialize_codec() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 983ea8339154..3096e291735c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1160,9 +1160,9 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 	}
 
 	cx231xx_enable656(dev);
-			/* stop mpeg capture */
-			cx231xx_api_cmd(dev, CX2341X_ENC_STOP_CAPTURE,
-				 3, 0, 1, 3, 4);
+
+	/* stop mpeg capture */
+	cx231xx_api_cmd(dev, CX2341X_ENC_STOP_CAPTURE, 3, 0, 1, 3, 4);
 
 	cx231xx_codec_settings(dev);
 	msleep(60);
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 39e887925e3d..491913778bcc 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -1595,31 +1595,31 @@ void cx231xx_set_DIF_bandpass(struct cx231xx *dev, u32 if_freq,
 		/*pll_freq_word = 0x3463497;*/
 		vid_blk_write_word(dev, DIF_PLL_FREQ_WORD,  pll_freq_word);
 
-	if (spectral_invert) {
-		if_freq -= 400000;
-		/* Enable Spectral Invert*/
-		vid_blk_read_word(dev, DIF_MISC_CTRL,
-					&dif_misc_ctrl_value);
-		dif_misc_ctrl_value = dif_misc_ctrl_value | 0x00200000;
-		vid_blk_write_word(dev, DIF_MISC_CTRL,
-					dif_misc_ctrl_value);
-	} else {
-		if_freq += 400000;
-		/* Disable Spectral Invert*/
-		vid_blk_read_word(dev, DIF_MISC_CTRL,
-					&dif_misc_ctrl_value);
-		dif_misc_ctrl_value = dif_misc_ctrl_value & 0xFFDFFFFF;
-		vid_blk_write_word(dev, DIF_MISC_CTRL,
-					dif_misc_ctrl_value);
-	}
+		if (spectral_invert) {
+			if_freq -= 400000;
+			/* Enable Spectral Invert*/
+			vid_blk_read_word(dev, DIF_MISC_CTRL,
+					  &dif_misc_ctrl_value);
+			dif_misc_ctrl_value = dif_misc_ctrl_value | 0x00200000;
+			vid_blk_write_word(dev, DIF_MISC_CTRL,
+					  dif_misc_ctrl_value);
+		} else {
+			if_freq += 400000;
+			/* Disable Spectral Invert*/
+			vid_blk_read_word(dev, DIF_MISC_CTRL,
+					  &dif_misc_ctrl_value);
+			dif_misc_ctrl_value = dif_misc_ctrl_value & 0xFFDFFFFF;
+			vid_blk_write_word(dev, DIF_MISC_CTRL,
+					  dif_misc_ctrl_value);
+		}
 
-	if_freq = (if_freq/100000)*100000;
+		if_freq = (if_freq / 100000) * 100000;
 
-	if (if_freq < 3000000)
-		if_freq = 3000000;
+		if (if_freq < 3000000)
+			if_freq = 3000000;
 
-	if (if_freq > 16000000)
-		if_freq = 16000000;
+		if (if_freq > 16000000)
+			if_freq = 16000000;
 	}
 
 	dev_dbg(dev->dev, "Enter IF=%zu\n", ARRAY_SIZE(Dif_set_array));
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index e42bde081cd7..a2fd49b6be83 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -653,22 +653,20 @@ int cx231xx_demod_reset(struct cx231xx *dev)
 
 	cx231xx_coredbg("Enter cx231xx_demod_reset()\n");
 
-		value[1] = (u8) 0x3;
-		status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-						PWR_CTL_EN, value, 4);
-			msleep(10);
-
-		value[1] = (u8) 0x0;
-		status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-						PWR_CTL_EN, value, 4);
-			msleep(10);
-
-		value[1] = (u8) 0x3;
-		status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-						PWR_CTL_EN, value, 4);
-			msleep(10);
-
-
+	value[1] = (u8) 0x3;
+	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+					PWR_CTL_EN, value, 4);
+	msleep(10);
+
+	value[1] = (u8) 0x0;
+	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+					PWR_CTL_EN, value, 4);
+	msleep(10);
+
+	value[1] = (u8) 0x3;
+	status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+					PWR_CTL_EN, value, 4);
+	msleep(10);
 
 	status = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER, PWR_CTL_EN,
 				 value, 4);
-- 
2.1.0

