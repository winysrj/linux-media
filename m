Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-da02.mx.aol.com ([205.188.105.144]:49922 "EHLO
	imr-da02.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1J1UJQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Oct 2011 16:09:16 -0400
Message-ID: <4EAB097C.40000@netscape.net>
Date: Fri, 28 Oct 2011 16:58:52 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: liplianin@me.by, mchehab@infradead.org, stoth@linuxtv.org
Subject: cx23885-alsa + Mygica X8507
Content-Type: multipart/mixed;
 boundary="------------040504000604040606070900"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040504000604040606070900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi

For 15 days "alsa cx23885 cleaner" worked well with my Mygica X8507 card 
and with the 3.0.2 kernel in OpenSuSE 11.4.

Please if you are going to add "cx23885-alsa" to kernel, add Mygica 
X8507 card.

Best regards,

Alfredo


-- 
Dona tu voz
http://www.voxforge.org/es


--------------040504000604040606070900
Content-Type: text/plain;
 name="cx23885.h.diff3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885.h.diff3"

--- /home/alfredo/ISDB/Nuevo Driver/alsa_suport_12_oct_2011/Para_Video4Linux/Kernel/cx23885.h	2011-10-28 16:13:26.011668530 -0300
+++ /home/alfredo/ISDB/Nuevo Driver/alsa_suport_12_oct_2011/Para_Video4Linux/Mi_kernel_para_V4L/cx23885.h	2011-10-17 16:09:23.000000000 -0300
@@ -86,8 +86,9 @@
 #define CX23885_BOARD_GOTVIEW_X5_3D_HYBRID     29
 #define CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF 30
 #define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000 31
 #define CX23885_BOARD_MPX885                   32
+#define CX23885_BOARD_MYGICA_X8507             33
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
 #define GPIO_2 0x00000004

--------------040504000604040606070900
Content-Type: text/plain;
 name="cx23885-cards.c.diff3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885-cards.c.diff3"

--- /home/alfredo/ISDB/Nuevo Driver/alsa_suport_12_oct_2011/Para_Video4Linux/Kernel/cx23885-cards.c	2011-10-28 16:11:22.579672203 -0300
+++ /home/alfredo/ISDB/Nuevo Driver/alsa_suport_12_oct_2011/Para_Video4Linux/Mi_kernel_para_V4L/cx23885-cards.c	2011-10-28 15:12:10.147777939 -0300
@@ -302,8 +302,39 @@
 					CX25840_VIN7_CH3,
 			},
 		},
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
+
+		},
+	},
 	[CX23885_BOARD_MAGICPRO_PROHDTVE2] = {
 		.name		= "Magic-Pro ProHDTV Extreme 2",
 		.tuner_type = TUNER_XC5000,
 		.tuner_addr = 0x61,
@@ -606,8 +637,12 @@
 		.subdevice = 0x8651,
 		.card      = CX23885_BOARD_MYGICA_X8506,
 	}, {
 		.subvendor = 0x14f1,
+		.subdevice = 0x8502,
+		.card      = CX23885_BOARD_MYGICA_X8507,
+	}, {
+		.subvendor = 0x14f1,
 		.subdevice = 0x8657,
 		.card      = CX23885_BOARD_MAGICPRO_PROHDTVE2,
 	}, {
 		.subvendor = 0x0070,
@@ -1067,11 +1102,12 @@
 		cx23885_gpio_set(dev, GPIO_9);
 		break;
 	case CX23885_BOARD_MYGICA_X8506:
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
+	case CX23885_BOARD_MYGICA_X8507:
 		/* GPIO-0 (0)Analog / (1)Digital TV */
 		/* GPIO-1 reset XC5000 */
-		/* GPIO-2 reset LGS8GL5 / LGS8G75 */
+		/* GPIO-2 reset LGS8GL5 / LGS8G75 / MB86A20S */
 		cx23885_gpio_enable(dev, GPIO_0 | GPIO_1 | GPIO_2, 1);
 		cx23885_gpio_clear(dev, GPIO_1 | GPIO_2);
 		mdelay(100);
 		cx23885_gpio_set(dev, GPIO_0 | GPIO_1 | GPIO_2);
@@ -1461,8 +1497,9 @@
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1270:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_MYGICA_X8506:
+	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
 	case CX23885_BOARD_GOTVIEW_X5_3D_HYBRID:

--------------040504000604040606070900
Content-Type: text/plain;
 name="cx23885-video.c.diff3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885-video.c.diff3"

--- /home/alfredo/ISDB/Nuevo Driver/alsa_suport_12_oct_2011/Para_Video4Linux/Kernel/cx23885-video.c	2011-10-28 16:13:03.741669193 -0300
+++ /home/alfredo/ISDB/Nuevo Driver/alsa_suport_12_oct_2011/Para_Video4Linux/Mi_kernel_para_V4L/cx23885-video.c	2011-10-17 16:17:09.000000000 -0300
@@ -491,9 +491,10 @@
 		INPUT(input)->gpio2, INPUT(input)->gpio3);
 	dev->input = input;
 
 	if (dev->board == CX23885_BOARD_MYGICA_X8506 ||
-		dev->board == CX23885_BOARD_MAGICPRO_PROHDTVE2) {
+		dev->board == CX23885_BOARD_MAGICPRO_PROHDTVE2 ||
+		dev->board == CX23885_BOARD_MYGICA_X8507) {
 		/* Select Analog TV */
 		if (INPUT(input)->type == CX23885_VMUX_TELEVISION)
 			cx23885_gpio_clear(dev, GPIO_0);
 	}

--------------040504000604040606070900--
