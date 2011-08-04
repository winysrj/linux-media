Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52968 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1HDHOZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:25 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 09/21] [staging] tm6000: Rename active interface register.
Date: Thu,  4 Aug 2011 09:14:07 +0200
Message-Id: <1312442059-23935-10-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The register ACTIVE_VIDEO_IF register should be named ACTIVE_IF since it
controls more than just the video interface.
---
 drivers/staging/tm6000/tm6000-alsa.c |    4 ++--
 drivers/staging/tm6000/tm6000-core.c |   12 ++++++------
 drivers/staging/tm6000/tm6000-regs.h |    4 +++-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 768d713..35ad1f0 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -80,7 +80,7 @@ static int _tm6000_start_audio_dma(struct snd_tm6000_card *chip)
 	dprintk(1, "Starting audio DMA\n");
 
 	/* Enables audio */
-	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x40, 0x40);
+	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_IF, 0x40, 0x40);
 
 	tm6000_set_audio_bitrate(core, 48000);
 
@@ -98,7 +98,7 @@ static int _tm6000_stop_audio_dma(struct snd_tm6000_card *chip)
 	dprintk(1, "Stopping audio DMA\n");
 
 	/* Disables audio */
-	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0x00, 0x40);
+	tm6000_set_reg_mask(core, TM6010_REQ07_RCC_ACTIVE_IF, 0x00, 0x40);
 
 	return 0;
 }
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 2c156dd..2117f8e 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -184,11 +184,11 @@ void tm6000_set_fourcc_format(struct tm6000_core *dev)
 	if (dev->dev_type == TM6010) {
 		int val;
 
-		val = tm6000_get_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0) & 0xfc;
+		val = tm6000_get_reg(dev, TM6010_REQ07_RCC_ACTIVE_IF, 0) & 0xfc;
 		if (dev->fourcc == V4L2_PIX_FMT_UYVY)
-			tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
+			tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_IF, val);
 		else
-			tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val | 1);
+			tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_IF, val | 1);
 	} else {
 		if (dev->fourcc == V4L2_PIX_FMT_UYVY)
 			tm6000_set_reg(dev, TM6010_REQ07_RC1_TRESHOLD, 0xd0);
@@ -265,7 +265,7 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 
 	if (dev->dev_type == TM6010) {
 		/* Enable video and audio */
-		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF,
+		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_IF,
 							0x60, 0x60);
 		/* Disable TS input */
 		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
@@ -331,7 +331,7 @@ int tm6000_init_digital_mode(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
 		/* Disable video and audio */
-		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF,
+		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_IF,
 				0x00, 0x60);
 		/* Enable TS input */
 		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
@@ -459,7 +459,7 @@ static struct reg_init tm6010_init_tab[] = {
 	{ TM6010_REQ07_RC4_HSTART0, 0xa0 },
 	{ TM6010_REQ07_RC6_HEND0, 0x40 },
 	{ TM6010_REQ07_RCA_VEND0, 0x31 },
-	{ TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0xe1 },
+	{ TM6010_REQ07_RCC_ACTIVE_IF, 0xe1 },
 	{ TM6010_REQ07_RE0_DVIDEO_SOURCE, 0x03 },
 	{ TM6010_REQ07_RFE_POWER_DOWN, 0x7f },
 
diff --git a/drivers/staging/tm6000/tm6000-regs.h b/drivers/staging/tm6000/tm6000-regs.h
index 5375a83..6e4ef95 100644
--- a/drivers/staging/tm6000/tm6000-regs.h
+++ b/drivers/staging/tm6000/tm6000-regs.h
@@ -270,7 +270,9 @@ enum {
 #define TM6010_REQ07_RCA_VEND0				0x07, 0xca
 #define TM6010_REQ07_RCB_DELAY				0x07, 0xcb
 /* ONLY for TM6010 */
-#define TM6010_REQ07_RCC_ACTIVE_VIDEO_IF		0x07, 0xcc
+#define TM6010_REQ07_RCC_ACTIVE_IF			0x07, 0xcc
+#define TM6010_REQ07_RCC_ACTIVE_IF_VIDEO_ENABLE (1 << 5)
+#define TM6010_REQ07_RCC_ACTIVE_IF_AUDIO_ENABLE (1 << 6)
 #define TM6010_REQ07_RD0_USB_PERIPHERY_CONTROL		0x07, 0xd0
 #define TM6010_REQ07_RD1_ADDR_FOR_REQ1			0x07, 0xd1
 #define TM6010_REQ07_RD2_ADDR_FOR_REQ2			0x07, 0xd2
-- 
1.7.6

