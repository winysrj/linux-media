Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:51277 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932551AbcBWIcf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2016 03:32:35 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: linux-media <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH v3] TW686x frame grabber driver
References: <m3lh6lqej3.fsf@t19.piap.pl>
Date: Tue, 23 Feb 2016 09:32:32 +0100
In-Reply-To: <m3lh6lqej3.fsf@t19.piap.pl> ("Krzysztof \=\?utf-8\?Q\?Ha\=C5\=82as\?\=
 \=\?utf-8\?Q\?a\=22's\?\= message of
	"Tue, 16 Feb 2016 08:51:12 +0100")
Message-ID: <m3bn77q127.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> A driver for Intersil/Techwell TW686x-based PCIe frame grabbers.

The v3 TW686x patch was missing a few small changes (attached).
Will post complete v4 patch.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland

--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -260,6 +260,10 @@ static void setup_dma_cfg(struct tw686x_video_channel *vc)
 	reg_write(vc->dev, VIDEO_SIZE[vc->ch], (1 << 31) | (field_height << 16)
 		  | field_width);
 	reg = reg_read(vc->dev, VIDEO_CONTROL1);
+	if (vc->video_standard & V4L2_STD_625_50)
+		reg |= 1 << (vc->ch + 13);
+	else
+		reg &= ~(1 << (vc->ch + 13));
 	reg_write(vc->dev, VIDEO_CONTROL1, reg);
 }
 
@@ -569,8 +573,8 @@ static int video_thread(void *arg)
 
 			/* handle channel events */
 			if ((request & 0x01000000) |
-			    (reg_read(dev, VIDEO_FIFO_STATUS) & 0x01010001) |
-			    (reg_read(dev, VIDEO_PARSER_STATUS) & 0x00000101)) {
+			    (reg_read(dev, VIDEO_FIFO_STATUS) & (0x01010001 << ch)) |
+			    (reg_read(dev, VIDEO_PARSER_STATUS) & (0x00000101 << ch))) {
 				/* DMA Errors - reset channel */
 				u32 reg;
 
@@ -667,6 +671,7 @@ int tw686x_video_init(struct tw686x_dev *dev)
 	if (err)
 		return err;
 
+	reg_write(dev, VIDEO_CONTROL1, 0); /* NTSC, disable scaler */
 	reg_write(dev, PHASE_REF, 0x00001518); /* Scatter-gather DMA mode */
 
 	/* setup required SG table sizes */
