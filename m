Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55421 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbbK3U1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/11] cx23885: add support for ViewCast 260e and 460e.
Date: Mon, 30 Nov 2015 21:27:20 +0100
Message-Id: <1448915241-415-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add support for these two new cards.

Based upon Devin's initial patch made for an older kernel which I
cleaned up and rebased. Thanks to Kernel Labs for that work.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/Kconfig         |   1 +
 drivers/media/pci/cx23885/cx23885-cards.c | 114 ++++++++++++++++++++++++++++++
 drivers/media/pci/cx23885/cx23885-core.c  |  10 +++
 drivers/media/pci/cx23885/cx23885-i2c.c   |   2 +
 drivers/media/pci/cx23885/cx23885-video.c |   4 +-
 drivers/media/pci/cx23885/cx23885.h       |   2 +
 6 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
index 2e1b88c..3435bba 100644
--- a/drivers/media/pci/cx23885/Kconfig
+++ b/drivers/media/pci/cx23885/Kconfig
@@ -10,6 +10,7 @@ config VIDEO_CX23885
 	select VIDEOBUF2_DMA_SG
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
+	select VIDEO_CS3308
 	select DVB_DIB7000P if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DRXK if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_S5H1409 if MEDIA_SUBDRV_AUTOSELECT
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 99ac201..310ee76 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -715,6 +715,56 @@ struct cx23885_board cx23885_boards[] = {
 		.portb		= CX23885_MPEG_DVB,
 		.portc		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_VIEWCAST_260E] = {
+		.name		= "ViewCast 260e",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.force_bff	= 1,
+		.input          = {{
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   = CX25840_VIN6_CH1,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   = CX25840_VIN7_CH3 |
+					CX25840_VIN5_CH1 |
+					CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_COMPONENT,
+			.vmux   = CX25840_VIN7_CH3 |
+					CX25840_VIN6_CH2 |
+					CX25840_VIN5_CH1 |
+					CX25840_COMPONENT_ON,
+			.amux   = CX25840_AUDIO7,
+		} },
+	},
+	[CX23885_BOARD_VIEWCAST_460E] = {
+		.name		= "ViewCast 460e",
+		.porta		= CX23885_ANALOG_VIDEO,
+		.force_bff	= 1,
+		.input          = {{
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   = CX25840_VIN4_CH1,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   = CX25840_VIN7_CH3 |
+					CX25840_VIN6_CH1 |
+					CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_COMPONENT,
+			.vmux   = CX25840_VIN7_CH3 |
+					CX25840_VIN6_CH1 |
+					CX25840_VIN5_CH2 |
+					CX25840_COMPONENT_ON,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_COMPOSITE2,
+			.vmux   = CX25840_VIN6_CH1,
+			.amux   = CX25840_AUDIO7,
+		} },
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -1002,6 +1052,14 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x0070,
 		.subdevice = 0xf038,
 		.card      = CX23885_BOARD_HAUPPAUGE_HVR5525,
+	}, {
+		.subvendor = 0x1576,
+		.subdevice = 0x0260,
+		.card      = CX23885_BOARD_VIEWCAST_260E,
+	}, {
+		.subvendor = 0x1576,
+		.subdevice = 0x0460,
+		.card      = CX23885_BOARD_VIEWCAST_460E,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -1034,6 +1092,28 @@ void cx23885_card_list(struct cx23885_dev *dev)
 		       dev->name, i, cx23885_boards[i].name);
 }
 
+static void viewcast_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
+{
+	u32 sn;
+
+	/* The serial number record begins with tag 0x59 */
+	if (*(eeprom_data + 0x00) != 0x59) {
+		pr_info("%s() eeprom records are undefined, no serial number\n",
+			__func__);
+		return;
+	}
+
+	sn =	(*(eeprom_data + 0x06) << 24) |
+		(*(eeprom_data + 0x05) << 16) |
+		(*(eeprom_data + 0x04) << 8) |
+		(*(eeprom_data + 0x03));
+
+	pr_info("%s: card '%s' sn# MM%d\n",
+		dev->name,
+		cx23885_boards[dev->board].name,
+		sn);
+}
+
 static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 {
 	struct tveeprom tv;
@@ -1671,6 +1751,12 @@ void cx23885_gpio_setup(struct cx23885_dev *dev)
 		cx23885_gpio_set(dev, GPIO_8 | GPIO_9);
 		msleep(100);
 		break;
+	case CX23885_BOARD_VIEWCAST_260E:
+	case CX23885_BOARD_VIEWCAST_460E:
+		/* For documentation purposes, it's worth noting that this
+		 * card does not have any GPIO's connected to subcomponents.
+		 */
+		break;
 	}
 }
 
@@ -1917,6 +2003,14 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		if (dev->i2c_bus[0].i2c_rc == 0)
 			hauppauge_eeprom(dev, eeprom+0xc0);
 		break;
+	case CX23885_BOARD_VIEWCAST_260E:
+	case CX23885_BOARD_VIEWCAST_460E:
+		dev->i2c_bus[1].i2c_client.addr = 0xa0 >> 1;
+		tveeprom_read(&dev->i2c_bus[1].i2c_client,
+			      eeprom, sizeof(eeprom));
+		if (dev->i2c_bus[0].i2c_rc == 0)
+			viewcast_eeprom(dev, eeprom);
+		break;
 	}
 
 	switch (dev->board) {
@@ -2120,6 +2214,8 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_DVBSKY_S950:
 	case CX23885_BOARD_DVBSKY_S952:
 	case CX23885_BOARD_DVBSKY_T982:
+	case CX23885_BOARD_VIEWCAST_260E:
+	case CX23885_BOARD_VIEWCAST_460E:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
 				"cx25840", 0x88 >> 1, NULL);
@@ -2130,6 +2226,24 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 		break;
 	}
 
+	switch (dev->board) {
+	case CX23885_BOARD_VIEWCAST_260E:
+		v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_bus[0].i2c_adap,
+				"cs3308", 0x82 >> 1, NULL);
+		break;
+	case CX23885_BOARD_VIEWCAST_460E:
+		/* This cs3308 controls the audio from the breakout cable */
+		v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_bus[0].i2c_adap,
+				"cs3308", 0x80 >> 1, NULL);
+		/* This cs3308 controls the audio from the onboard header */
+		v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_bus[0].i2c_adap,
+				"cs3308", 0x82 >> 1, NULL);
+		break;
+	}
+
 	/* AUX-PLL 27MHz CLK */
 	switch (dev->board) {
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index e8f8472..722781b 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -968,6 +968,16 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	call_all(dev, core, s_power, 0);
 	cx23885_ir_init(dev);
 
+	if (dev->board == CX23885_BOARD_VIEWCAST_460E) {
+		/*
+		 * GPIOs 9/8 are input detection bits for the breakout video
+		 * (gpio 8) and audio (gpio 9) cables. When they're attached,
+		 * this gpios are pulled high. Make sure these GPIOs are marked
+		 * as inputs.
+		 */
+		cx23885_gpio_enable(dev, 0x300, 0);
+	}
+
 	if (cx23885_boards[dev->board].porta == CX23885_ANALOG_VIDEO) {
 		if (cx23885_video_register(dev) < 0) {
 			printk(KERN_ERR "%s() Failed to register analog "
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index 1135ea3..ae061b3 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -279,6 +279,8 @@ static char *i2c_devs[128] = {
 	[0x10 >> 1] = "tda10048",
 	[0x12 >> 1] = "dib7000pc",
 	[0x1c >> 1] = "lgdt3303",
+	[0x80 >> 1] = "cs3308",
+	[0x82 >> 1] = "cs3308",
 	[0x86 >> 1] = "tda9887",
 	[0x32 >> 1] = "cx24227",
 	[0x88 >> 1] = "cx25837",
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ad4d7e6..064e5fb 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -263,7 +263,9 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
 		(dev->board == CX23885_BOARD_MYGICA_X8507) ||
-		(dev->board == CX23885_BOARD_AVERMEDIA_HC81R)) {
+		(dev->board == CX23885_BOARD_AVERMEDIA_HC81R) ||
+		(dev->board == CX23885_BOARD_VIEWCAST_260E) ||
+		(dev->board == CX23885_BOARD_VIEWCAST_460E)) {
 		/* Configure audio routing */
 		v4l2_subdev_call(dev->sd_cx25840, audio, s_routing,
 			INPUT(input)->amux, 0, 0);
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 9a8938b..b1a5409 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -101,6 +101,8 @@
 #define CX23885_BOARD_DVBSKY_T982              51
 #define CX23885_BOARD_HAUPPAUGE_HVR5525        52
 #define CX23885_BOARD_HAUPPAUGE_STARBURST      53
+#define CX23885_BOARD_VIEWCAST_260E            54
+#define CX23885_BOARD_VIEWCAST_460E            55
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
2.6.2

