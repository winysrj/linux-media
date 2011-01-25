Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43737 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1AYUtr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 15:49:47 -0500
Message-ID: <4d3f3768.857a0e0a.122c.4791@mx.google.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Tue, 25 Jan 2011 22:05:00 +0200
Subject: [PATCH 6/9 v3] cx23885: implement tuner_bus parameter for cx23885_board structure.
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

There is two external I2C buses in cx23885 chip.
Currently, analog tuners supported for second I2C bus only
In NetUP Dual DVB-T/C CI RF card tuners connected to first bus
So, in order to support analog tuners sitting on first bus
we need modifications.

Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
---
 drivers/media/video/cx23885/cx23885-cards.c |    5 +++++
 drivers/media/video/cx23885/cx23885-core.c  |    5 +++--
 drivers/media/video/cx23885/cx23885-video.c |    7 ++++---
 drivers/media/video/cx23885/cx23885.h       |    2 ++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index a3fe26c..fb2045a 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -94,6 +94,7 @@ struct cx23885_board cx23885_boards[] = {
 		.portc		= CX23885_MPEG_DVB,
 		.tuner_type	= TUNER_PHILIPS_TDA8290,
 		.tuner_addr	= 0x42, /* 0x84 >> 1 */
+		.tuner_bus	= 1,
 		.input          = {{
 			.type   = CX23885_VMUX_TELEVISION,
 			.vmux   =	CX25840_VIN7_CH3 |
@@ -216,6 +217,7 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "Mygica X8506 DMB-TH",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
+		.tuner_bus	= 1,
 		.porta		= CX23885_ANALOG_VIDEO,
 		.portb		= CX23885_MPEG_DVB,
 		.input		= {
@@ -245,6 +247,7 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "Magic-Pro ProHDTV Extreme 2",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
+		.tuner_bus	= 1,
 		.porta		= CX23885_ANALOG_VIDEO,
 		.portb		= CX23885_MPEG_DVB,
 		.input		= {
@@ -293,6 +296,7 @@ struct cx23885_board cx23885_boards[] = {
 		.porta          = CX23885_ANALOG_VIDEO,
 		.tuner_type     = TUNER_XC2028,
 		.tuner_addr     = 0x61,
+		.tuner_bus	= 1,
 		.input          = {{
 			.type   = CX23885_VMUX_TELEVISION,
 			.vmux   = CX25840_VIN2_CH1 |
@@ -317,6 +321,7 @@ struct cx23885_board cx23885_boards[] = {
 		.name		= "GoTView X5 3D Hybrid",
 		.tuner_type	= TUNER_XC5000,
 		.tuner_addr	= 0x64,
+		.tuner_bus	= 1,
 		.porta		= CX23885_ANALOG_VIDEO,
 		.portb		= CX23885_MPEG_DVB,
 		.input          = {{
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 9ad4c9c..d621d76 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -970,11 +970,12 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	/* Assume some sensible defaults */
 	dev->tuner_type = cx23885_boards[dev->board].tuner_type;
 	dev->tuner_addr = cx23885_boards[dev->board].tuner_addr;
+	dev->tuner_bus = cx23885_boards[dev->board].tuner_bus;
 	dev->radio_type = cx23885_boards[dev->board].radio_type;
 	dev->radio_addr = cx23885_boards[dev->board].radio_addr;
 
-	dprintk(1, "%s() tuner_type = 0x%x tuner_addr = 0x%x\n",
-		__func__, dev->tuner_type, dev->tuner_addr);
+	dprintk(1, "%s() tuner_type = 0x%x tuner_addr = 0x%x tuner_bus = %d\n",
+		__func__, dev->tuner_type, dev->tuner_addr, dev->tuner_bus);
 	dprintk(1, "%s() radio_type = 0x%x radio_addr = 0x%x\n",
 		__func__, dev->radio_type, dev->radio_addr);
 
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 644fcb8..ee57f6b 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1468,16 +1468,17 @@ int cx23885_video_register(struct cx23885_dev *dev)
 
 	cx23885_irq_add_enable(dev, 0x01);
 
-	if (TUNER_ABSENT != dev->tuner_type) {
+	if ((TUNER_ABSENT != dev->tuner_type) &&
+			((dev->tuner_bus == 0) || (dev->tuner_bus == 1))) {
 		struct v4l2_subdev *sd = NULL;
 
 		if (dev->tuner_addr)
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_bus[1].i2c_adap,
+				&dev->i2c_bus[dev->tuner_bus].i2c_adap,
 				"tuner", dev->tuner_addr, NULL);
 		else
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_bus[1].i2c_adap,
+				&dev->i2c_bus[dev->tuner_bus].i2c_adap,
 				"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_TV));
 		if (sd) {
 			struct tuner_setup tun_setup;
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index 8b77fea..d8c76b0 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -209,6 +209,7 @@ struct cx23885_board {
 	unsigned int		radio_type;
 	unsigned char		tuner_addr;
 	unsigned char		radio_addr;
+	unsigned int		tuner_bus;
 
 	/* Vendors can and do run the PCIe bridge at different
 	 * clock rates, driven physically by crystals on the PCBs.
@@ -364,6 +365,7 @@ struct cx23885_dev {
 	v4l2_std_id                tvnorm;
 	unsigned int               tuner_type;
 	unsigned char              tuner_addr;
+	unsigned int               tuner_bus;
 	unsigned int               radio_type;
 	unsigned char              radio_addr;
 	unsigned int               has_radio;
-- 
1.7.1

