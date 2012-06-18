Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:35294 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2FREUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 00:20:07 -0400
Received: from shed.thedillows.org ([IPv6:2001:470:8:bf8::2])
	by matrix.voodoobox.net (8.13.8/8.13.8) with ESMTP id q5I4K6Va024508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:20:07 -0400
Received: from [192.168.0.10] (obelisk.thedillows.org [192.168.0.10])
	by shed.thedillows.org (8.14.4/8.14.4) with ESMTP id q5I4K6ck030937
	for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 00:20:06 -0400
Message-ID: <1339993206.32360.43.camel@obelisk.thedillows.org>
Subject: [PATCH 2/2][media] cx231xx: use TRANSFER_TYPE enum for cleanup
From: David Dillow <dave@thedillows.org>
To: linux-media@vger.kernel.org
Date: Mon, 18 Jun 2012 00:20:06 -0400
In-Reply-To: <1339992819.32360.36.camel@obelisk.thedillows.org>
References: <1339992819.32360.36.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most calls to cx231xx_capture_start() already use the values from
TRANSFER_TYPE, but cx231xx_capture_start() and
cx231xx_initialize_stream_xfer() were hand coding the values.
Use the named values (81 is never passed in), and simplify
cx231xx_capture_start(), as the switch statements were identical and
pcb_config->config_num is a u8, so any non-zero config got the same
result.

Signed-off-by: David Dillow <dave@thedillows.org>
--
This may not be strictly necessary for audio to work, and has only been
tested on my HVR-850 (2040:b140). I don't know if there are devices out
there that break if we enter HANC.

diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/video/cx231xx/cx231xx-avcore.c
index b085a3c..447148e 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -89,7 +89,7 @@ void initGPIO(struct cx231xx *dev)
 	verve_read_byte(dev, 0x07, &val);
 	cx231xx_info(" verve_read_byte address0x07=0x%x\n", val);
 
-	cx231xx_capture_start(dev, 1, 2);
+	cx231xx_capture_start(dev, 1, Vbi);
 
 	cx231xx_mode_register(dev, EP_MODE_SET, 0x0500FE00);
 	cx231xx_mode_register(dev, GBULK_BIT_EN, 0xFFFDFFFF);
@@ -99,7 +99,7 @@ void uninitGPIO(struct cx231xx *dev)
 {
 	u8 value[4] = { 0, 0, 0, 0 };
 
-	cx231xx_capture_start(dev, 0, 2);
+	cx231xx_capture_start(dev, 0, Vbi);
 	verve_write_byte(dev, 0x07, 0x14);
 	cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
 			0x68, value, 4);
@@ -2516,29 +2516,29 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 
 	if (dev->udev->speed == USB_SPEED_HIGH) {
 		switch (media_type) {
-		case 81: /* audio */
+		case Audio:
 			cx231xx_info("%s: Audio enter HANC\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x9300);
 			break;
 
-		case 2:	/* vbi */
+		case Vbi:
 			cx231xx_info("%s: set vanc registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x300);
 			break;
 
-		case 3:	/* sliced cc */
+		case Sliced_cc:
 			cx231xx_info("%s: set hanc registers\n", __func__);
 			status =
 			    cx231xx_mode_register(dev, TS_MODE_REG, 0x1300);
 			break;
 
-		case 0:	/* video */
+		case Raw_Video:
 			cx231xx_info("%s: set video registers\n", __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
 			break;
 
-		case 4:	/* ts1 */
+		case TS1_serial_mode:
 			cx231xx_info("%s: set ts1 registers", __func__);
 
 		if (dev->board.has_417) {
@@ -2569,7 +2569,7 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 		}
 			break;
 
-		case 6:	/* ts1 parallel mode */
+		case TS1_parallel_mode:
 			cx231xx_info("%s: set ts1 parallel mode registers\n",
 				     __func__);
 			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x100);
@@ -2592,52 +2592,28 @@ int cx231xx_capture_start(struct cx231xx *dev, int start, u8 media_type)
 	/* get EP for media type */
 	pcb_config = (struct pcb_config *)&dev->current_pcb_config;
 
-	if (pcb_config->config_num == 1) {
+	if (pcb_config->config_num) {
 		switch (media_type) {
-		case 0:	/* Video */
+		case Raw_Video:
 			ep_mask = ENABLE_EP4;	/* ep4  [00:1000] */
 			break;
-		case 1:	/* Audio */
+		case Audio:
 			ep_mask = ENABLE_EP3;	/* ep3  [00:0100] */
 			break;
-		case 2:	/* Vbi */
+		case Vbi:
 			ep_mask = ENABLE_EP5;	/* ep5 [01:0000] */
 			break;
-		case 3:	/* Sliced_cc */
+		case Sliced_cc:
 			ep_mask = ENABLE_EP6;	/* ep6 [10:0000] */
 			break;
-		case 4:	/* ts1 */
-		case 6:	/* ts1 parallel mode */
+		case TS1_serial_mode:
+		case TS1_parallel_mode:
 			ep_mask = ENABLE_EP1;	/* ep1 [00:0001] */
 			break;
-		case 5:	/* ts2 */
+		case TS2:
 			ep_mask = ENABLE_EP2;	/* ep2 [00:0010] */
 			break;
 		}
-
-	} else if (pcb_config->config_num > 1) {
-		switch (media_type) {
-		case 0:	/* Video */
-			ep_mask = ENABLE_EP4;	/* ep4  [00:1000] */
-			break;
-		case 1:	/* Audio */
-			ep_mask = ENABLE_EP3;	/* ep3  [00:0100] */
-			break;
-		case 2:	/* Vbi */
-			ep_mask = ENABLE_EP5;	/* ep5 [01:0000] */
-			break;
-		case 3:	/* Sliced_cc */
-			ep_mask = ENABLE_EP6;	/* ep6 [10:0000] */
-			break;
-		case 4:	/* ts1 */
-		case 6:	/* ts1 parallel mode */
-			ep_mask = ENABLE_EP1;	/* ep1 [00:0001] */
-			break;
-		case 5:	/* ts2 */
-			ep_mask = ENABLE_EP2;	/* ep2 [00:0010] */
-			break;
-		}
-
 	}
 
 	if (start) {


