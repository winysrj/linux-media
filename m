Return-path: <mchehab@pedra>
Received: from imr-da03.mx.aol.com ([205.188.105.145]:33573 "EHLO
	imr-da03.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1EDQMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 12:12:48 -0400
Message-ID: <4DC179F6.1020905@netscape.net>
Date: Wed, 04 May 2011 13:08:22 -0300
From: =?windows-1252?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Help to make a driver. ISDB-Tb
References: <4DBC422F.10102@netscape.net> <4DBCB4EF.5070104@redhat.com> <4DBE0F74.80602@netscape.net> <4DBEAC3D.7040608@redhat.com>
In-Reply-To: <4DBEAC3D.7040608@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------050901080507000204040600"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------050901080507000204040600
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

Hi

El 02/05/11 10:06, Mauro Carvalho Chehab escribió:
> From this message:
> [ 14.288626] Frontend revision 255 is unknown - aborting.
>
> I suspect that the I2C gate needed to access the frontend is at the wrong state. That's why you're
> getting 0xff (255) value there.
I changed the value ".demod_address = 0x19" by ".demod_address = 0x10" 
and resolved

dmesg:
<6>[   10.639380] cx23885 driver version 0.0.2 loaded
<6>[   10.640125] cx23885 0000:02:00.0: PCI INT A -> GSI 19 (level, low) 
-> IRQ 19
<6>[   10.640310] CORE cx23885[0]: subsystem: 14f1:8502, board: Mygica 
X8507 [card=30,autodetected]
<6>[   12.533349] cx25840 5-0044: loaded v4l-cx23885-avcore-01.fw 
firmware (16382 bytes)
<6>[   12.542333] tuner 4-0061: chip found @ 0xc2 (cx23885[0])
<6>[   12.582949] xc5000 4-0061: creating new instance
<6>[   12.583643] xc5000: Successfully identified at address 0x61
<6>[   12.583645] xc5000: Firmware has not been loaded previously
<6>[   12.583727] cx23885[0]/0: registered device video1 [v4l2]
<6>[   12.589183] xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
<7>[   12.610081] xc5000: firmware read 12401 bytes.
<6>[   12.610083] xc5000: firmware uploading...
<6>[   13.982005] xc5000: firmware upload complete...
<6>[   14.604101] cx23885_dvb_register() allocating 1 frontend(s)
<6>[   14.604106] cx23885[0]: cx23885 based dvb card
<7>[   14.631169] mb86a20s: mb86a20s_attach:
<6>[   14.631656] Detected a Fujitsu mb86a20s frontend
<6>[   14.631726] xc5000 4-0061: attaching existing instance
<6>[   14.632425] xc5000: Successfully identified at address 0x61
<6>[   14.632427] xc5000: Firmware has been loaded previously
<6>[   14.632431] DVB: registering new adapter (cx23885[0])
<4>[   14.632434] DVB: registering adapter 1 frontend 0 (Fujitsu 
mb86A20s)...
<6>[   14.632811] cx23885_dev_checkrevision() Hardware revision = 0xb0
<6>[   14.632819] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, 
latency: 0, mmio: 0xfd600000
<7>[   14.632827] cx23885 0000:02:00.0: setting latency timer to 64
<7>[   14.632918] cx23885 0000:02:00.0: irq 44 for MSI/MSI-X

Attached list of changes I made.


Results:

Analog TV can be seen, but no sound.
If I use xawtv or VLC the image is in the middle of the screen and there 
are stripes, as if interference. If I use tvtime will look good.

Digital television: not tune any channels with w-scan or gnome-dvb-setup.
But with the latter, it captures 2 weak signals, but I can not know 
which is.
Under windows also capture 2 channel and I'm in a place where the signal 
is low.
I'll try to have more signal strength.

If I run dmesg after scan channels I get the following:

[ 3474.858537] mb86a20s: mb86a20s_set_frontend:
[ 3474.858541] mb86a20s: mb86a20s_set_frontend: Calling tuner set parameters
[ 3474.981157] mb86a20s: mb86a20s_read_status:
[ 3474.981649] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01
[ 3475.081746] mb86a20s: mb86a20s_read_status:
[ 3475.082241] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01
[ 3475.182336] mb86a20s: mb86a20s_read_status:
[ 3475.182829] mb86a20s: mb86a20s_read_status: val = 2, status = 0x01

When detected signal with gnome-dvb-setup, sometimes gives this warning:

Message from syslogd@linux at May 4 01:48:38 ...
kernel:[ 3359.202289] do_IRQ: 2.145 No irq handler for vector (irq -1)


Thank you very much,

Alfredo

-- 
Dona tu voz
http://www.voxforge.org/es


--------------050901080507000204040600
Content-Type: text/x-patch;
 name="cx23885.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885.diff"

--- usr/src/linux/drivers/media/video/cx23885/cx23885.h	2011-05-02 17:22:28.000000000 -0300
+++ home/alfredo/ISDB/Nuevo Driver/cx23885/cx23885.h	2011-05-01 17:15:05.000000000 -0300
@@ -85,6 +85,7 @@
 #define CX23885_BOARD_MYGICA_X8558PRO          27
 #define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
 #define CX23885_BOARD_GOTVIEW_X5_3D_HYBRID     29
+#define CX23885_BOARD_MYGICA_X8507             30
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002

--------------050901080507000204040600
Content-Type: text/x-patch;
 name="cx23885-cards.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885-cards.diff"

--- ../../../../../../usr/src/linux/drivers/media/video/cx23885/cx23885-cards.c	2011-05-02 17:22:28.000000000 -0300
+++ ../cx23885-cards.c	2011-05-02 16:59:45.000000000 -0300
@@ -237,6 +237,35 @@
 			},
 		},
 	},
+	[CX23885_BOARD_MYGICA_X8507] = {
+		.name		= "Mygica X8507",
+		.tuner_type = TUNER_XC5000,
+		.tuner_addr = 0x61,
+		.porta		= CX23885_ANALOG_VIDEO,
+		.portb		= CX23885_MPEG_DVB,
+		.input		= {
+			{
+				.type   = CX23885_VMUX_TELEVISION,
+				.vmux   = CX25840_COMPOSITE2,
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
+	},
 	[CX23885_BOARD_MAGICPRO_PROHDTVE2] = {
 		.name		= "Magic-Pro ProHDTV Extreme 2",
 		.tuner_type = TUNER_XC5000,
@@ -494,6 +523,10 @@
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
@@ -955,6 +988,16 @@
 		cx23885_gpio_set(dev, GPIO_0 | GPIO_1 | GPIO_2);
 		mdelay(100);
 		break;
+	case CX23885_BOARD_MYGICA_X8507:
+		/* GPIO-0 (0)Analog / (1)Digital TV */
+		/* GPIO-1 reset XC5000 */
+		/* GPIO-2 reset MB86A20S */
+		cx23885_gpio_enable(dev, GPIO_0 | GPIO_1 | GPIO_2, 1);
+		cx23885_gpio_clear(dev, GPIO_1 | GPIO_2);
+		mdelay(100);
+		cx23885_gpio_set(dev, GPIO_0 | GPIO_1 | GPIO_2);
+		mdelay(100);
+		break;
 	case CX23885_BOARD_MYGICA_X8558PRO:
 		/* GPIO-0 reset first ATBM8830 */
 		/* GPIO-1 reset second ATBM8830 */
@@ -1220,6 +1263,7 @@
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
 	case CX23885_BOARD_MYGICA_X8506:
+	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -1274,6 +1318,7 @@
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_MYGICA_X8506:
+	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:

--------------050901080507000204040600
Content-Type: text/x-patch;
 name="cx23885-dvb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885-dvb.diff"

--- ../../../../../../usr/src/linux/drivers/media/video/cx23885/cx23885-dvb.c	2011-05-02 17:22:28.000000000 -0300
+++ ../cx23885-dvb.c	2011-05-03 18:56:18.000000000 -0300
@@ -58,6 +58,7 @@
 #include "atbm8830.h"
 #include "ds3000.h"
 #include "cx23885-f300.h"
+#include "mb86a20s.h"
 
 static unsigned int debug;
 
@@ -460,6 +461,16 @@
 	.if_khz = 5380,
 };
 
+static struct mb86a20s_config mygica_x8507_mb86a20s_config = {
+	.demod_address = 0x10,
+	.is_serial = true,
+};
+
+static struct xc5000_config mygica_x8507_xc5000_config = {
+	.i2c_address = 0x61,
+	.if_khz = 5380,
+};
+
 static int cx23885_dvb_set_frontend(struct dvb_frontend *fe,
 				    struct dvb_frontend_parameters *param)
 {
@@ -480,6 +491,7 @@
 		}
 		break;
 	case CX23885_BOARD_MYGICA_X8506:
+	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 		/* Select Digital TV */
 		cx23885_gpio_set(dev, GPIO_0);
@@ -912,6 +924,19 @@
 				&mygica_x8506_xc5000_config);
 		}
 		break;
+	case CX23885_BOARD_MYGICA_X8507:
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
+		fe0->dvb.frontend = dvb_attach(mb86a20s_attach,
+			&mygica_x8507_mb86a20s_config,
+			&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(xc5000_attach,
+				fe0->dvb.frontend,
+				&i2c_bus2->i2c_adap,
+				&mygica_x8507_xc5000_config);
+		}
+		break;
 	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 		i2c_bus = &dev->i2c_bus[0];
 		i2c_bus2 = &dev->i2c_bus[1];

--------------050901080507000204040600
Content-Type: text/x-patch;
 name="cx23885-video.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="cx23885-video.diff"

--- ../../../../../../usr/src/linux/drivers/media/video/cx23885/cx23885-video.c	2011-05-02 17:22:28.000000000 -0300
+++ ../cx23885-video.c	2011-04-29 14:07:33.000000000 -0300
@@ -409,6 +409,13 @@
 			cx23885_gpio_clear(dev, GPIO_0);
 	}
 
+	if (dev->board == CX23885_BOARD_MYGICA_X8507 ||
+		dev->board == CX23885_BOARD_MAGICPRO_PROHDTVE2) {
+		/* Select Analog TV */
+		if (INPUT(input)->type == CX23885_VMUX_TELEVISION)
+			cx23885_gpio_clear(dev, GPIO_0);
+	}
+
 	/* Tell the internal A/V decoder */
 	v4l2_subdev_call(dev->sd_cx25840, video, s_routing,
 			INPUT(input)->vmux, 0, 0);

--------------050901080507000204040600--
