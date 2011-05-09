Return-path: <mchehab@gaivota>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:43720 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab1EITyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 15:54:15 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 10/16] tm6000: move from tm6000_set_reg to tm6000_set_reg_mask
Date: Mon,  9 May 2011 21:53:58 +0200
Message-Id: <1304970844-20955-10-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
References: <1304970844-20955-1-git-send-email-stefan.ringel@arcor.de>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Stefan Ringel <stefan.ringel@arcor.de>

move from tm6000_set_reg to tm6000_set_reg_mask



Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-core.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 259cf80..1ac8409 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -268,19 +268,18 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 	struct v4l2_frequency f;
 
 	if (dev->dev_type == TM6010) {
-		/* Enable video */
-
+		/* Enable video and audio */
 		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF,
 							0x60, 0x60);
+		/* Disable TS input */
 		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
 							0x00, 0x40);
-		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
-
 	} else {
 		/* Enables soft reset */
 		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
 
 		if (dev->scaler)
+			/* Disable Hfilter and Enable TS Drop err */
 			tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x20);
 		else	/* Enable Hfilter and disable TS Drop err */
 			tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0x80);
@@ -343,21 +342,16 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
 int tm6000_init_digital_mode(struct tm6000_core *dev)
 {
 	if (dev->dev_type == TM6010) {
-		int val;
-		u8 buf[2];
-
-		/* digital init */
-		val = tm6000_get_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, 0);
-		val &= ~0x60;
-		tm6000_set_reg(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF, val);
-		val = tm6000_get_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, 0);
-		val |= 0x40;
-		tm6000_set_reg(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE, val);
+		/* Disable video and audio */
+		tm6000_set_reg_mask(dev, TM6010_REQ07_RCC_ACTIVE_VIDEO_IF,
+				0x00, 0x60);
+		/* Enable TS input */
+		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
+				0x40, 0x40);
+		/* all power down, but not the digital data port */
 		tm6000_set_reg(dev, TM6010_REQ07_RFE_POWER_DOWN, 0x28);
 		tm6000_set_reg(dev, TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xfc);
 		tm6000_set_reg(dev, TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0xff);
-		tm6000_read_write_usb(dev, 0xc0, 0x0e, 0x00c2, 0x0008, buf, 2);
-		printk(KERN_INFO"buf %#x %#x\n", buf[0], buf[1]);
 	} else  {
 		tm6000_set_reg(dev, TM6010_REQ07_RFF_SOFT_RESET, 0x08);
 		tm6000_set_reg(dev, TM6010_REQ07_RFF_SOFT_RESET, 0x00);
-- 
1.7.4.2

