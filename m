Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-ma03.mx.aol.com ([64.12.206.41]:59384 "EHLO
	imr-ma03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab1KIT3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2011 14:29:54 -0500
Received: from mtaout-ma06.r1000.mx.aol.com (mtaout-ma06.r1000.mx.aol.com [172.29.41.6])
	by imr-ma03.mx.aol.com (8.14.1/8.14.1) with ESMTP id pA9JTl0m029626
	for <linux-media@vger.kernel.org>; Wed, 9 Nov 2011 14:29:47 -0500
Received: from [192.168.1.36] (unknown [190.50.30.131])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-ma06.r1000.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id A46CFE00013D
	for <linux-media@vger.kernel.org>; Wed,  9 Nov 2011 14:29:46 -0500 (EST)
Message-ID: <4EBAD0BC.8030600@netscape.net>
Date: Wed, 09 Nov 2011 16:13:00 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Mygica X8507
Content-Type: multipart/mixed;
 boundary="------------060109040609000000070902"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060109040609000000070902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi

This patch supports card Mygica X8507 (analog part)

This controller is a copy of driver card Mygica X8506

This patch depends on patch cx23885-alsa 
<http://git.linuxtv.org/liplianin/media_tree.git/shortlog/refs/heads/cx23885-alsa-clean-2>

To do: FM, ISDB-t, remote control, audio for composite1, S-Video and 
componet

kernel version 3.1.0-3; OpenSuSE 11.4 64bit

Signed-off-by: Alfredo J. Delaiti <alfredodelaiti@netscape.net>

My apologies if I have once again committed an error sending the patch

Thanks,

Alfredo


-- 
Dona tu voz
http://www.voxforge.org/es


--------------060109040609000000070902
Content-Type: text/x-patch;
 name="cx23885-X8507.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885-X8507.diff"

diff -up1rN /usr/src/linux-media/drivers/media/video/cx23885/cx23885-cards.c /usr/src/linux/drivers/media/video/cx23885/cx23885-cards.c
--- /usr/src/linux-media/drivers/media/video/cx23885/cx23885-cards.c	2011-10-12 20:19:03.000000000 -0300
+++ /usr/src/linux/drivers/media/video/cx23885/cx23885-cards.c	2011-11-09 11:34:34.810810514 -0300
@@ -440,2 +440,32 @@ struct cx23885_board cx23885_boards[] =
 	},
+	[CX23885_BOARD_MYGICA_X8507] = {
+		.name		= "Mygica X8507",
+		.tuner_type = TUNER_XC5000,
+		.tuner_addr = 0x61,
+		.tuner_bus	= 1,
+		.porta		= CX23885_ANALOG_VIDEO,
+		.input		= {
+			{
+				.type   = CX23885_VMUX_TELEVISION,
+				.vmux   = CX25840_COMPOSITE2,
+				.amux   = CX25840_AUDIO8,
+			},
+			{
+				.type   = CX23885_VMUX_COMPOSITE1,
+				.vmux   = CX25840_COMPOSITE8,
+			},
+			{
+				.type   = CX23885_VMUX_SVIDEO,
+				.vmux   = CX25840_SVIDEO_LUMA3 |
+						CX25840_SVIDEO_CHROMA4,
+			},
+			{
+				.type   = CX23885_VMUX_COMPONENT,
+				.vmux   = CX25840_COMPONENT_ON |
+					CX25840_VIN1_CH1 |
+					CX25840_VIN6_CH2 |
+					CX25840_VIN7_CH3,
+			},
+		},
+	}
 };
@@ -639,2 +669,6 @@ struct cx23885_subid cx23885_subids[] =
 		.card      = CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF,
+	}, {
+		.subvendor = 0x14f1,
+		.subdevice = 0x8502,
+		.card      = CX23885_BOARD_MYGICA_X8507,
 	},
@@ -1070,2 +1104,3 @@ void cx23885_gpio_setup(struct cx23885_d
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
+	case CX23885_BOARD_MYGICA_X8507:
 		/* GPIO-0 (0)Analog / (1)Digital TV */
@@ -1470,2 +1505,3 @@ void cx23885_card_setup(struct cx23885_d
 	case CX23885_BOARD_MPX885:
+	case CX23885_BOARD_MYGICA_X8507:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
diff -up1rN /usr/src/linux-media/drivers/media/video/cx23885/cx23885.h /usr/src/linux/drivers/media/video/cx23885/cx23885.h
--- /usr/src/linux-media/drivers/media/video/cx23885/cx23885.h	2011-10-12 20:20:38.000000000 -0300
+++ /usr/src/linux/drivers/media/video/cx23885/cx23885.h	2011-11-09 11:20:13.838836142 -0300
@@ -89,2 +89,3 @@
 #define CX23885_BOARD_MPX885                   32
+#define CX23885_BOARD_MYGICA_X8507             33
 
diff -up1rN /usr/src/linux-media/drivers/media/video/cx23885/cx23885-video.c /usr/src/linux/drivers/media/video/cx23885/cx23885-video.c
--- /usr/src/linux-media/drivers/media/video/cx23885/cx23885-video.c	2011-10-12 20:20:33.000000000 -0300
+++ /usr/src/linux/drivers/media/video/cx23885/cx23885-video.c	2011-11-09 11:39:29.458801749 -0300
@@ -494,3 +494,4 @@ static int cx23885_video_mux(struct cx23
 	if (dev->board == CX23885_BOARD_MYGICA_X8506 ||
-		dev->board == CX23885_BOARD_MAGICPRO_PROHDTVE2) {
+		dev->board == CX23885_BOARD_MAGICPRO_PROHDTVE2 ||
+		dev->board == CX23885_BOARD_MYGICA_X8507) {
 		/* Select Analog TV */

--------------060109040609000000070902--
