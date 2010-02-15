Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:49410 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab0BOW5Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 17:57:16 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nh9sQ-00056W-KT
	for linux-media@vger.kernel.org; Mon, 15 Feb 2010 23:57:14 +0100
Received: from 80-218-69-65.dclient.hispeed.ch ([80.218.69.65])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 23:57:14 +0100
Received: from auslands-kv by 80-218-69-65.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2010 23:57:14 +0100
To: linux-media@vger.kernel.org
From: Michael <auslands-kv@gmx.de>
Subject: Re: cx23885
Date: Mon, 15 Feb 2010 23:56:52 +0100
Message-ID: <hlcjfi$unq$1@ger.gmane.org>
References: <hlbe6t$kc4$1@ger.gmane.org> <1266238446.3075.13.camel@palomino.walls.org> <hlbhck$uh9$1@ger.gmane.org> <4B795D1A.9040502@kernellabs.com> <hlbopr$v7s$1@ger.gmane.org> <4B79803B.4070302@kernellabs.com> <hlcbhu$4s3$1@ger.gmane.org> <4B79B437.5000004@kernellabs.com> <hlch5h$ogp$1@ger.gmane.org> <hlciur$tb0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2023037.sOSvq9BKCP"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart2023037.sOSvq9BKCP
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit

Well, this did not work. The cx23885 driver was not included in kernel 
2.6.21, so no diff. The diff of the 2.6.21 cx25840 is twice as big as the 
2.6.31 diff. :-(

If anybody can give me a hint, what to include in a patch and what was old 
stuff that has jsut changed in 2.6.31, I'd be grateful.

Attached is the diff of cx23885, the commell version against kernel 
2.6.31.4.

> 
> I'm downloading kernel 2.6.21 now and make a diff with these drivers.
> 

--nextPart2023037.sOSvq9BKCP
Content-Type: text/x-patch; name="cx23885-commell.diff"
Content-Transfer-Encoding: 8Bit
Content-Disposition: attachment; filename="cx23885-commell.diff"

diff -u cx23885/cimax2.c cx23885-commell/cimax2.c
--- cx23885/cimax2.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cimax2.c	2009-11-11 09:36:16.000000000 +0100
@@ -75,7 +75,6 @@
 	void *priv;
 };
 
-struct mutex gpio_mutex;/* Two CiMax's uses same GPIO lines */
 
 int netup_read_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 						u8 *buf, int len)
@@ -183,10 +182,11 @@
 	if (ret != 0)
 		return ret;
 
-	mutex_lock(&gpio_mutex);
+	mutex_lock(&dev->gpio_lock);
 
 	/* write addr */
 	cx_write(MC417_OEN, NETUP_EN_ALL);
+	msleep(2);
 	cx_write(MC417_RWD, NETUP_CTRL_OFF |
 				NETUP_ADLO | (0xff & addr));
 	cx_clear(MC417_RWD, NETUP_ADLO);
@@ -194,9 +194,10 @@
 				NETUP_ADHI | (0xff & (addr >> 8)));
 	cx_clear(MC417_RWD, NETUP_ADHI);
 
-	if (read) /* data in */
+	if (read) { /* data in */
 		cx_write(MC417_OEN, NETUP_EN_ALL | NETUP_DATA);
-	else /* data out */
+		msleep(2);
+	} else /* data out */
 		cx_write(MC417_RWD, NETUP_CTRL_OFF | data);
 
 	/* choose chip */
@@ -206,7 +207,7 @@
 	cx_clear(MC417_RWD, (read) ? NETUP_RD : NETUP_WR);
 	mem = netup_ci_get_mem(dev);
 
-	mutex_unlock(&gpio_mutex);
+	mutex_unlock(&dev->gpio_lock);
 
 	if (!read)
 		if (mem < 0)
@@ -295,10 +296,18 @@
 }
 
 /* work handler */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
+static void netup_read_ci_status(void *_state)
+#else
 static void netup_read_ci_status(struct work_struct *work)
+#endif
 {
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
+	struct netup_ci_state *state = _state;
+#else
 	struct netup_ci_state *state =
 			container_of(work, struct netup_ci_state, work);
+#endif
 	u8 buf[33];
 	int ret;
 
@@ -403,7 +412,6 @@
 	switch (port->nr) {
 	case 1:
 		state->ci_i2c_addr = 0x40;
-		mutex_init(&gpio_mutex);
 		break;
 	case 2:
 		state->ci_i2c_addr = 0x41;
@@ -442,7 +450,12 @@
 	if (0 != ret)
 		goto err;
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
+	INIT_WORK(&state->work, netup_read_ci_status, state);
+#else
 	INIT_WORK(&state->work, netup_read_ci_status);
+#endif
+	schedule_work(&state->work);
 
 	ci_dbg_print("%s: CI initialized!\n", __func__);
 
diff -u cx23885/cx23885-417.c cx23885-commell/cx23885-417.c
--- cx23885/cx23885-417.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885-417.c	2009-11-11 09:36:16.000000000 +0100
@@ -37,6 +37,7 @@
 #include <media/cx2341x.h>
 
 #include "cx23885.h"
+#include "cx23885-ioctl.h"
 
 #define CX23885_FIRM_IMAGE_SIZE 376836
 #define CX23885_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
@@ -318,7 +319,7 @@
 	}
 }
 
-static int mc417_register_write(struct cx23885_dev *dev, u16 address, u32 value)
+int mc417_register_write(struct cx23885_dev *dev, u16 address, u32 value)
 {
 	u32 regval;
 
@@ -382,7 +383,7 @@
 	return mc417_wait_ready(dev);
 }
 
-static int mc417_register_read(struct cx23885_dev *dev, u16 address, u32 *value)
+int mc417_register_read(struct cx23885_dev *dev, u16 address, u32 *value)
 {
 	int retval;
 	u32 regval;
@@ -630,6 +631,39 @@
 	return retval;
 }
 
+void mc417_gpio_set(struct cx23885_dev *dev, u32 mask)
+{
+	u32 val;
+
+	/* Set the gpio value */
+	mc417_register_read(dev, 0x900C, &val);
+	val |= (mask & 0x000ffff);
+	mc417_register_write(dev, 0x900C, val);
+}
+
+void mc417_gpio_clear(struct cx23885_dev *dev, u32 mask)
+{
+	u32 val;
+
+	/* Clear the gpio value */
+	mc417_register_read(dev, 0x900C, &val);
+	val &= ~(mask & 0x0000ffff);
+	mc417_register_write(dev, 0x900C, val);
+}
+
+void mc417_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
+{
+	u32 val;
+
+	/* Enable GPIO direction bits */
+	mc417_register_read(dev, 0x9020, &val);
+	if (asoutput)
+		val |= (mask & 0x0000ffff);
+	else
+		val &= ~(mask & 0x0000ffff);
+
+	mc417_register_write(dev, 0x9020, val);
+}
 /* ------------------------------------------------------------------ */
 
 /* MPEG encoder API */
@@ -955,25 +989,8 @@
 	retval |= mc417_register_write(dev, IVTV_REG_HW_BLOCKS,
 		IVTV_CMD_HW_BLOCKS_RST);
 
-	/* Restore GPIO settings, make sure EIO14 is enabled as an output. */
-	dprintk(2, "%s: GPIO output EIO 0-15 was = 0x%x\n",
-		__func__, gpio_output);
-	/* Power-up seems to have GPIOs AFU. This was causing digital side
-	 * to fail at power-up. Seems GPIOs should be set to 0x10ff0411 at
-	 * power-up.
-	 * gpio_output |= (1<<14);
-	 */
-	/* Note: GPIO14 is specific to the HVR1800 here */
-	gpio_output = 0x10ff0411 | (1<<14);
-	retval |= mc417_register_write(dev, 0x9020, gpio_output | (1<<14));
-	dprintk(2, "%s: GPIO output EIO 0-15 now = 0x%x\n",
-		__func__, gpio_output);
-
-	dprintk(1, "%s: GPIO value  EIO 0-15 was = 0x%x\n",
-		__func__, value);
-	value |= (1<<14);
-	dprintk(1, "%s: GPIO value  EIO 0-15 now = 0x%x\n",
-		__func__, value);
+	/* F/W power up disturbs the GPIOs, restore state */
+	retval |= mc417_register_write(dev, 0x9020, gpio_output);
 	retval |= mc417_register_write(dev, 0x900C, value);
 
 	retval |= mc417_register_read(dev, IVTV_REG_VPU, &value);
@@ -1191,6 +1208,13 @@
 	if (i == ARRAY_SIZE(cx23885_tvnorms))
 		return -EINVAL;
 	dev->encodernorm = cx23885_tvnorms[i];
+#if 0
+	/* Notify the video decoder and other i2c clients.
+	 * This will likely need to be enabled for non NTSC
+	 * formats.
+	 */
+	call_all(dev, core, s_std, id);
+#endif
 	return 0;
 }
 
@@ -1708,6 +1732,11 @@
 	.vidioc_log_status	 = vidioc_log_status,
 	.vidioc_querymenu	 = vidioc_querymenu,
 	.vidioc_queryctrl	 = vidioc_queryctrl,
+	.vidioc_g_chip_ident	 = cx23885_g_chip_ident,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_register	 = cx23885_g_register,
+	.vidioc_s_register	 = cx23885_s_register,
+#endif
 };
 
 static struct video_device cx23885_mpeg_template = {
@@ -1788,9 +1817,6 @@
 		return err;
 	}
 
-	/* Initialize MC417 registers */
-	cx23885_mc417_init(dev);
-
 	printk(KERN_INFO "%s: registered device video%d [mpeg]\n",
 	       dev->name, dev->v4l_device->num);
 
diff -u cx23885/cx23885-cards.c cx23885-commell/cx23885-cards.c
--- cx23885/cx23885-cards.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885-cards.c	2009-11-11 09:36:16.000000000 +0100
@@ -25,9 +25,11 @@
 #include <linux/delay.h>
 #include <media/cx25840.h>
 
+#include "compat.h"
 #include "cx23885.h"
 #include "tuner-xc2028.h"
 #include "netup-init.h"
+#include "cx23888-ir.h"
 
 /* ------------------------------------------------------------------ */
 /* board config info                                                  */
@@ -201,6 +203,42 @@
 		.name		= "Mygica X8506 DMB-TH",
 		.portb		= CX23885_MPEG_DVB,
 	},
+	[CX23885_BOARD_MAGICPRO_PROHDTVE2] = {
+		.name		= "Magic-Pro ProHDTV Extreme 2",
+		.portb		= CX23885_MPEG_DVB,
+	},
+	[CX23885_BOARD_HAUPPAUGE_HVR1850] = {
+		.name		= "Hauppauge WinTV-HVR1850",
+		.portb		= CX23885_MPEG_ENCODER,
+		.portc		= CX23885_MPEG_DVB,
+	},
+	[CX23885_BOARD_COMPRO_VIDEOMATE_E800] = {
+		.name		= "Compro VideoMate E800",
+		.portc		= CX23885_MPEG_DVB,
+	},
+	[CX23885_BOARD_MPX885] = {
+	    .name       = "MPX-885",
+        .porta      = CX23885_ANALOG_VIDEO,
+        .portb      = CX23885_MPEG_ENCODER,
+        .portc      = CX23885_MPEG_DVB,
+        .input          = {{
+            .type   = CX23885_VMUX_COMPOSITE1,
+            .vmux   = CX25840_VIN1_CH1,
+            .gpio0  = 0,
+        }, {
+            .type   = CX23885_VMUX_COMPOSITE2,
+            .vmux   = CX25840_VIN2_CH1,
+            .gpio0  = 0,
+        }, {
+            .type   = CX23885_VMUX_COMPOSITE3,
+            .vmux   = CX25840_VIN3_CH1,
+            .gpio0  = 0,
+        }, {
+            .type   = CX23885_VMUX_COMPOSITE4,
+            .vmux   = CX25840_VIN4_CH1,
+            .gpio0  = 0,
+        } },
+    },
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -324,7 +362,23 @@
 		.subvendor = 0x14f1,
 		.subdevice = 0x8651,
 		.card      = CX23885_BOARD_MYGICA_X8506,
-	},
+	}, {
+		.subvendor = 0x14f1,
+		.subdevice = 0x8657,
+		.card      = CX23885_BOARD_MAGICPRO_PROHDTVE2,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0x8541,
+		.card      = CX23885_BOARD_HAUPPAUGE_HVR1850,
+	}, {
+		.subvendor = 0x1858,
+		.subdevice = 0xe800,
+		.card      = CX23885_BOARD_COMPRO_VIDEOMATE_E800,
+	}, {
+	    .subvendor = 0x0,
+        .subdevice = 0x0,
+        .card      = CX23885_BOARD_MPX885,
+    },
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
 
@@ -483,8 +537,13 @@
 		/* WinTV-HVR1700 (PCIe, OEM, No IR, full height)
 		 * DVB-T and MPEG2 HW Encoder */
 		break;
+	case 85021:
+		/* WinTV-HVR1850 (PCIe, OEM, RCA in, IR, FM,
+			Dual channel ATSC and MPEG2 HW Encoder */
+		break;
 	default:
-		printk(KERN_WARNING "%s: warning: unknown hauppauge model #%d\n",
+		printk(KERN_WARNING "%s: warning: "
+			"unknown hauppauge model #%d\n",
 			dev->name, tv.model);
 		break;
 	}
@@ -514,6 +573,7 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		/* Tuner Reset Command */
 		bitmask = 0x04;
 		break;
@@ -574,13 +634,23 @@
 		/* CX23417 GPIO's */
 		/* EIO15 Zilog Reset */
 		/* EIO14 S5H1409/CX24227 Reset */
+		mc417_gpio_enable(dev, GPIO_15 | GPIO_14, 1);
+
+		/* Put the demod into reset and protect the eeprom */
+		mc417_gpio_clear(dev, GPIO_15 | GPIO_14);
+		mdelay(100);
+
+		/* Bring the demod and blaster out of reset */
+		mc417_gpio_set(dev, GPIO_15 | GPIO_14);
+		mdelay(100);
 
 		/* Force the TDA8295A into reset and back */
-		cx_set(GP0_IO, 0x00040004);
+		cx23885_gpio_enable(dev, GPIO_2, 1);
+		cx23885_gpio_set(dev, GPIO_2);
 		mdelay(20);
-		cx_clear(GP0_IO, 0x00000004);
+		cx23885_gpio_clear(dev, GPIO_2);
 		mdelay(20);
-		cx_set(GP0_IO, 0x00040004);
+		cx23885_gpio_set(dev, GPIO_2);
 		mdelay(20);
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1200:
@@ -655,6 +725,7 @@
 		break;
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		/* GPIO-2  xc3028 tuner reset */
 
 		/* The following GPIO's are on the internal AVCore (cx25840) */
@@ -715,19 +786,82 @@
 		cx23885_gpio_set(dev, GPIO_9);
 		break;
 	case CX23885_BOARD_MYGICA_X8506:
+	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 		/* GPIO-1 reset XC5000 */
-		/* GPIO-2 reset LGS8GL5 */
+		/* GPIO-2 reset LGS8GL5 / LGS8G75 */
 		cx_set(GP0_IO, 0x00060000);
 		cx_clear(GP0_IO, 0x00000006);
 		mdelay(100);
 		cx_set(GP0_IO, 0x00060006);
 		mdelay(100);
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR1850:
+		/* GPIO-0 656_CLK */
+		/* GPIO-1 656_D0 */
+		/* GPIO-2 Wake# */
+		/* GPIO-3-10 cx23417 data0-7 */
+		/* GPIO-11-14 cx23417 addr0-3 */
+		/* GPIO-15-18 cx23417 READY, CS, RD, WR */
+		/* GPIO-19 IR_RX */
+		/* GPIO-20 C_IR_TX */
+		/* GPIO-21 I2S DAT */
+		/* GPIO-22 I2S WCLK */
+		/* GPIO-23 I2S BCLK */
+		/* ALT GPIO: EXP GPIO LATCH */
+
+		/* CX23417 GPIO's */
+		/* GPIO-14 S5H1411/CX24228 Reset */
+		/* GPIO-13 EEPROM write protect */
+		mc417_gpio_enable(dev, GPIO_14 | GPIO_13, 1);
+
+		/* Put the demod into reset and protect the eeprom */
+		mc417_gpio_clear(dev, GPIO_14 | GPIO_13);
+		mdelay(100);
+
+		/* Bring the demod out of reset */
+		mc417_gpio_set(dev, GPIO_14);
+		mdelay(100);
+
+		/* CX24228 GPIO */
+		/* Connected to IF / Mux */
+		break;
+    case CX23885_BOARD_MPX885:
+		/* GPIO-0 656_CLK */
+		/* GPIO-1 656_D0 */
+		/* GPIO-2 8295A Reset */
+		/* GPIO-3-10 cx23417 data0-7 */
+		/* GPIO-11-14 cx23417 addr0-3 */
+		/* GPIO-15-18 cx23417 READY, CS, RD, WR */
+		/* GPIO-19 IR_RX */
+
+		/* CX23417 GPIO's */
+		/* EIO15 Zilog Reset */
+		/* EIO14 S5H1409/CX24227 Reset */
+		mc417_gpio_enable(dev, GPIO_15 | GPIO_14, 1);
+
+		/* Put the demod into reset and protect the eeprom */
+		mc417_gpio_clear(dev, GPIO_15 | GPIO_14);
+		mdelay(100);
+
+		/* Bring the demod and blaster out of reset */
+		mc417_gpio_set(dev, GPIO_15 | GPIO_14);
+		mdelay(100);
+
+		/* Force the TDA8295A into reset and back */
+		cx23885_gpio_enable(dev, GPIO_2, 1);
+		cx23885_gpio_set(dev, GPIO_2);
+		mdelay(20);
+		cx23885_gpio_clear(dev, GPIO_2);
+		mdelay(20);
+		cx23885_gpio_set(dev, GPIO_2);
+		mdelay(20);
+		break;
 	}
 }
 
 int cx23885_ir_init(struct cx23885_dev *dev)
 {
+	int ret = 0;
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
@@ -741,12 +875,43 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
 		/* FIXME: Implement me */
 		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR1850:
+		ret = cx23888_ir_probe(dev);
+		if (ret)
+			break;
+		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_888_IR);
+		dev->pci_irqmask |= PCI_MSK_IR;
+		break;
 	case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
 		request_module("ir-kbd-i2c");
 		break;
+    case CX23885_BOARD_MPX885:
+        break;
 	}
 
-	return 0;
+	return ret;
+}
+
+void cx23885_ir_fini(struct cx23885_dev *dev)
+{
+	switch (dev->board) {
+	case CX23885_BOARD_HAUPPAUGE_HVR1850:
+		dev->pci_irqmask &= ~PCI_MSK_IR;
+		cx_clear(PCI_INT_MSK, PCI_MSK_IR);
+		cx23888_ir_remove(dev);
+		dev->sd_ir = NULL;
+		break;
+	}
+}
+
+void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
+{
+	switch (dev->board) {
+	case CX23885_BOARD_HAUPPAUGE_HVR1850:
+		if (dev->sd_ir && (dev->pci_irqmask & PCI_MSK_IR))
+			cx_set(PCI_INT_MSK, PCI_MSK_IR);
+		break;
+	}
 }
 
 void cx23885_card_setup(struct cx23885_dev *dev)
@@ -778,9 +943,14 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
+	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 		if (dev->i2c_bus[0].i2c_rc == 0)
 			hauppauge_eeprom(dev, eeprom+0xc0);
 		break;
+    case CX23885_BOARD_MPX885:
+		if (dev->i2c_bus[0].i2c_rc == 0)
+			hauppauge_eeprom(dev, eeprom+0xc0);
+        break;
 	}
 
 	switch (dev->board) {
@@ -827,10 +997,27 @@
 		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
 	case CX23885_BOARD_MYGICA_X8506:
+	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
 		ts1->gen_ctrl_val  = 0x5; /* Parallel */
 		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
 		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
 		break;
+    case CX23885_BOARD_MPX885:
+		/* Defaults for VID B - Analog encoder */
+		/* DREQ_POL, SMODE, PUNC_CLK, MCLK_POL Serial bus + punc clk */
+		ts1->gen_ctrl_val    = 0x10e;
+		ts1->ts_clk_en_val   = 0x1; /* Enable TS_CLK */
+		ts1->src_sel_val     = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+
+		/* APB_TSVALERR_POL (active low)*/
+		ts1->vld_misc_val    = 0x2000;
+		ts1->hw_sop_ctrl_val = (0x47 << 16 | 188 << 4 | 0xc);
+
+		/* Defaults for VID C */
+		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
+		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
+		ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
+        break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
@@ -844,6 +1031,8 @@
 	case CX23885_BOARD_HAUPPAUGE_HVR1275:
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 	case CX23885_BOARD_HAUPPAUGE_HVR1210:
+	case CX23885_BOARD_HAUPPAUGE_HVR1850:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 	default:
 		ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
 		ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -860,11 +1049,21 @@
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
 	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
+	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
-				"cx25840", "cx25840", 0x88 >> 1);
+				"cx25840", "cx25840", 0x88 >> 1, NULL);
 		v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
 		break;
+    case CX23885_BOARD_MPX885:
+        
+		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
+				&dev->i2c_bus[2].i2c_adap,
+				"cx25840", "cx25840", 0x88 >> 1, NULL);
+		v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
+		
+        break;
 	}
 
 	/* AUX-PLL 27MHz CLK */
diff -u cx23885/cx23885-core.c cx23885-commell/cx23885-core.c
--- cx23885/cx23885-core.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885-core.c	2009-11-11 09:36:16.000000000 +0100
@@ -28,10 +28,14 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include "compat.h"
 #include <asm/div64.h>
 
 #include "cx23885.h"
 #include "cimax2.h"
+#include "cx23888-ir.h"
+#include "cx23885-ir.h"
+#include "cx23885-input.h"
 
 MODULE_DESCRIPTION("Driver for cx23885 based TV cards");
 MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
@@ -713,12 +717,26 @@
 		dev->hwrevision = 0xa1;
 		break;
 	case 0x02:
-		/* CX23885-13Z */
+		/* CX23885-13Z/14Z */
 		dev->hwrevision = 0xb0;
 		break;
 	case 0x03:
-		/* CX23888-22Z */
-		dev->hwrevision = 0xc0;
+		if (dev->pci->device == 0x8880) {
+			/* CX23888-21Z/22Z */
+			dev->hwrevision = 0xc0;
+		} else {
+			/* CX23885-14Z */
+			dev->hwrevision = 0xa4;
+		}
+		break;
+	case 0x04:
+		if (dev->pci->device == 0x8880) {
+			/* CX23888-31Z */
+			dev->hwrevision = 0xd0;
+		} else {
+			/* CX23885-15Z, CX23888-31Z */
+			dev->hwrevision = 0xa5;
+		}
 		break;
 	case 0x0e:
 		/* CX23887-15Z */
@@ -739,11 +757,29 @@
 			__func__, dev->hwrevision);
 }
 
+/* Find the first v4l2_subdev member of the group id in hw */
+struct v4l2_subdev *cx23885_find_hw(struct cx23885_dev *dev, u32 hw)
+{
+	struct v4l2_subdev *result = NULL;
+	struct v4l2_subdev *sd;
+
+	spin_lock(&dev->v4l2_dev.lock);
+	v4l2_device_for_each_subdev(sd, &dev->v4l2_dev) {
+		if (sd->grp_id == hw) {
+			result = sd;
+			break;
+		}
+	}
+	spin_unlock(&dev->v4l2_dev.lock);
+	return result;
+}
+
 static int cx23885_dev_setup(struct cx23885_dev *dev)
 {
 	int i;
 
 	mutex_init(&dev->lock);
+	mutex_init(&dev->gpio_lock);
 
 	atomic_inc(&dev->refcount);
 
@@ -756,6 +792,7 @@
 
 	/* Configure the internal memory */
 	if (dev->pci->device == 0x8880) {
+		/* Could be 887 or 888, assume a default */
 		dev->bridge = CX23885_BRIDGE_887;
 		/* Apply a sensible clock frequency for the PCIe bridge */
 		dev->clk_freq = 25000000;
@@ -868,6 +905,14 @@
 	dprintk(1, "%s() radio_type = 0x%x radio_addr = 0x%x\n",
 		__func__, dev->radio_type, dev->radio_addr);
 
+	/* The cx23417 encoder has GPIO's that need to be initialised
+	 * before DVB, so that demodulators and tuners are out of
+	 * reset before DVB uses them.
+	 */
+	if ((cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER) ||
+		(cx23885_boards[dev->board].portc == CX23885_MPEG_ENCODER))
+			cx23885_mc417_init(dev);
+
 	/* init hardware */
 	cx23885_reset(dev);
 
@@ -1250,6 +1295,7 @@
 	switch (dev->bridge) {
 	case CX23885_BRIDGE_885:
 	case CX23885_BRIDGE_887:
+	case CX23885_BRIDGE_888:
 		/* enable irqs */
 		dprintk(1, "%s() enabling TS int's and DMA\n", __func__);
 		cx_set(port->reg_ts_int_msk,  port->ts_int_msk_val);
@@ -1292,6 +1338,12 @@
 		/* clear TS1_SOP_OE and TS1_OE_HI */
 		reg = reg & ~0xa;
 		cx_write(PAD_CTRL, reg);
+#if 0
+		/*
+		 * cx_write(CLK_DELAY, cx_read(CLK_DELAY) & ~0x80000011); ????
+		 * cx_write(ALT_PIN_OUT_SEL, 0x10100045); ?? need to undo this?
+		 */
+#endif
 		cx_write(port->reg_src_sel, 0);
 		cx_write(port->reg_gen_ctrl, 8);
 
@@ -1602,7 +1654,11 @@
 	return handled;
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
+static irqreturn_t cx23885_irq(int irq, void *dev_id, struct pt_regs *regs)
+#else
 static irqreturn_t cx23885_irq(int irq, void *dev_id)
+#endif
 {
 	struct cx23885_dev *dev = dev_id;
 	struct cx23885_tsport *ts1 = &dev->ts1;
@@ -1612,6 +1668,7 @@
 	u32 ts1_status, ts1_mask;
 	u32 ts2_status, ts2_mask;
 	int vida_count = 0, ts1_count = 0, ts2_count = 0, handled = 0;
+	bool ir_handled = false;
 
 	pci_status = cx_read(PCI_INT_STAT);
 	pci_mask = cx_read(PCI_INT_MSK);
@@ -1637,18 +1694,12 @@
 	dprintk(7, "ts2_status: 0x%08x  ts2_mask: 0x%08x count: 0x%x\n",
 		ts2_status, ts2_mask, ts2_count);
 
-	if ((pci_status & PCI_MSK_RISC_RD) ||
-	    (pci_status & PCI_MSK_RISC_WR) ||
-	    (pci_status & PCI_MSK_AL_RD) ||
-	    (pci_status & PCI_MSK_AL_WR) ||
-	    (pci_status & PCI_MSK_APB_DMA) ||
-	    (pci_status & PCI_MSK_VID_C) ||
-	    (pci_status & PCI_MSK_VID_B) ||
-	    (pci_status & PCI_MSK_VID_A) ||
-	    (pci_status & PCI_MSK_AUD_INT) ||
-	    (pci_status & PCI_MSK_AUD_EXT) ||
-	    (pci_status & PCI_MSK_GPIO0) ||
-	    (pci_status & PCI_MSK_GPIO1)) {
+	if (pci_status & (PCI_MSK_RISC_RD | PCI_MSK_RISC_WR |
+			  PCI_MSK_AL_RD   | PCI_MSK_AL_WR   | PCI_MSK_APB_DMA |
+			  PCI_MSK_VID_C   | PCI_MSK_VID_B   | PCI_MSK_VID_A   |
+			  PCI_MSK_AUD_INT | PCI_MSK_AUD_EXT |
+			  PCI_MSK_GPIO0   | PCI_MSK_GPIO1   |
+			  PCI_MSK_IR)) {
 
 		if (pci_status & PCI_MSK_RISC_RD)
 			dprintk(7, " (PCI_MSK_RISC_RD   0x%08x)\n",
@@ -1697,6 +1748,10 @@
 		if (pci_status & PCI_MSK_GPIO1)
 			dprintk(7, " (PCI_MSK_GPIO1     0x%08x)\n",
 				PCI_MSK_GPIO1);
+
+		if (pci_status & PCI_MSK_IR)
+			dprintk(7, " (PCI_MSK_IR        0x%08x)\n",
+				PCI_MSK_IR);
 	}
 
 	if (cx23885_boards[dev->board].cimax > 0 &&
@@ -1727,12 +1782,55 @@
 	if (vida_status)
 		handled += cx23885_video_irq(dev, vida_status);
 
+	if (pci_status & PCI_MSK_IR) {
+		v4l2_subdev_call(dev->sd_ir, ir, interrupt_service_routine,
+				 pci_status, &ir_handled);
+		if (ir_handled)
+			handled++;
+	}
+
 	if (handled)
 		cx_write(PCI_INT_STAT, pci_status);
 out:
 	return IRQ_RETVAL(handled);
 }
 
+static void cx23885_v4l2_dev_notify(struct v4l2_subdev *sd,
+				    unsigned int notification, void *arg)
+{
+	struct cx23885_dev *dev;
+
+	if (sd == NULL)
+		return;
+
+	dev = to_cx23885(sd->v4l2_dev);
+
+	switch (notification) {
+	case V4L2_SUBDEV_IR_RX_NOTIFY: /* Called in an IRQ context */
+		if (sd == dev->sd_ir)
+			cx23885_ir_rx_v4l2_dev_notify(sd, *(u32 *)arg);
+		break;
+	case V4L2_SUBDEV_IR_TX_NOTIFY: /* Called in an IRQ context */
+		if (sd == dev->sd_ir)
+			cx23885_ir_tx_v4l2_dev_notify(sd, *(u32 *)arg);
+		break;
+	}
+}
+
+static void cx23885_v4l2_dev_notify_init(struct cx23885_dev *dev)
+{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 20)
+	INIT_WORK(&dev->ir_rx_work, cx23885_ir_rx_work_handler);
+	INIT_WORK(&dev->ir_tx_work, cx23885_ir_tx_work_handler);
+#else
+	INIT_WORK(&dev->ir_rx_work, cx23885_ir_rx_work_handler,
+		  &dev->ir_rx_work);
+	INIT_WORK(&dev->ir_tx_work, cx23885_ir_tx_work_handler,
+		  &dev->ir_tx_work);
+#endif
+	dev->v4l2_dev.notify = cx23885_v4l2_dev_notify;
+}
+
 static inline int encoder_on_portb(struct cx23885_dev *dev)
 {
 	return cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER;
@@ -1829,6 +1927,9 @@
 	if (err < 0)
 		goto fail_free;
 
+	/* Prepare to handle notifications from subdevices */
+	cx23885_v4l2_dev_notify_init(dev);
+
 	/* pci init */
 	dev->pci = pci_dev;
 	if (pci_enable_device(pci_dev)) {
@@ -1871,6 +1972,14 @@
 		break;
 	}
 
+	/*
+	 * The CX2388[58] IR controller can start firing interrupts when
+	 * enabled, so these have to take place after the cx23885_irq() handler
+	 * is hooked up by the call to request_irq() above.
+	 */
+	cx23885_ir_pci_int_enable(dev);
+	cx23885_input_init(dev);
+
 	return 0;
 
 fail_irq:
@@ -1887,6 +1996,9 @@
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
 	struct cx23885_dev *dev = to_cx23885(v4l2_dev);
 
+	cx23885_input_fini(dev);
+	cx23885_ir_fini(dev);
+
 	cx23885_shutdown(dev);
 
 	pci_disable_device(pci_dev);
diff -u cx23885/cx23885-dvb.c cx23885-commell/cx23885-dvb.c
--- cx23885/cx23885-dvb.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885-dvb.c	2009-11-11 09:36:16.000000000 +0100
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/file.h>
 #include <linux/suspend.h>
+#include "compat.h"
 
 #include "cx23885.h"
 #include <media/v4l2-common.h>
@@ -255,15 +256,18 @@
 static struct tda18271_config hauppauge_tda18271_config = {
 	.std_map = &hauppauge_tda18271_std_map,
 	.gate    = TDA18271_GATE_ANALOG,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };
 
 static struct tda18271_config hauppauge_hvr1200_tuner_config = {
 	.std_map = &hauppauge_hvr1200_tda18271_std_map,
 	.gate    = TDA18271_GATE_ANALOG,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };
 
 static struct tda18271_config hauppauge_hvr1210_tuner_config = {
 	.gate    = TDA18271_GATE_DIGITAL,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };
 
 static struct tda18271_std_map hauppauge_hvr127x_std_map = {
@@ -275,6 +279,7 @@
 
 static struct tda18271_config hauppauge_hvr127x_config = {
 	.std_map = &hauppauge_hvr127x_std_map,
+	.output_opt = TDA18271_OUTPUT_LT_OFF,
 };
 
 static struct lgdt3305_config hauppauge_lgdt3305_config = {
@@ -396,7 +401,7 @@
 
 static struct stv0900_config netup_stv0900_config = {
 	.demod_address = 0x68,
-	.xtal = 27000000,
+	.xtal = 8000000,
 	.clkmode = 3,/* 0-CLKI, 2-XTALI, else AUTO */
 	.diseqc_mode = 2,/* 2/3 PWM */
 	.ts_config_regs = stv0900_ts_regs,
@@ -408,14 +413,14 @@
 
 static struct stv6110_config netup_stv6110_tunerconfig_a = {
 	.i2c_address = 0x60,
-	.mclk = 27000000,
-	.iq_wiring = 0,
+	.mclk = 16000000,
+	.clk_div = 1,
 };
 
 static struct stv6110_config netup_stv6110_tunerconfig_b = {
 	.i2c_address = 0x63,
-	.mclk = 27000000,
-	.iq_wiring = 1,
+	.mclk = 16000000,
+	.clk_div = 1,
 };
 
 static int tbs_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
@@ -483,10 +488,54 @@
 		}
 		break;
 	}
-	return (port->set_frontend_save) ?
-		port->set_frontend_save(fe, param) : -ENODEV;
+	return 0;
 }
 
+static int cx23885_dvb_fe_ioctl_override(struct dvb_frontend *fe,
+					 unsigned int cmd, void *parg,
+					 unsigned int stage)
+{
+	int err = 0;
+
+	switch (stage) {
+	case DVB_FE_IOCTL_PRE:
+
+		switch (cmd) {
+		case FE_SET_FRONTEND:
+			err = cx23885_dvb_set_frontend(fe,
+				(struct dvb_frontend_parameters *) parg);
+			break;
+		}
+		break;
+
+	case DVB_FE_IOCTL_POST:
+		/* no post-ioctl handling required */
+		break;
+	}
+	return err;
+};
+
+
+static struct lgs8gxx_config magicpro_prohdtve2_lgs8g75_config = {
+	.prod = LGS8GXX_PROD_LGS8G75,
+	.demod_address = 0x19,
+	.serial_ts = 0,
+	.ts_clk_pol = 1,
+	.ts_clk_gated = 1,
+	.if_clk_freq = 30400, /* 30.4 MHz */
+	.if_freq = 6500, /* 6.50 MHz */
+	.if_neg_center = 1,
+	.ext_adc = 0,
+	.adc_signed = 1,
+	.adc_vpp = 2, /* 1.6 Vpp */
+	.if_neg_edge = 1,
+};
+
+static struct xc5000_config magicpro_prohdtve2_xc5000_config = {
+	.i2c_address = 0x61,
+	.if_khz = 6500,
+};
+
 static int dvb_register(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
@@ -526,12 +575,6 @@
 				   0x60, &dev->i2c_bus[1].i2c_adap,
 				   &hauppauge_hvr127x_config);
 		}
-
-		/* FIXME: temporary hack */
-		/* define bridge override to set_frontend */
-		port->set_frontend_save = fe0->dvb.frontend->ops.set_frontend;
-		fe0->dvb.frontend->ops.set_frontend = cx23885_dvb_set_frontend;
-
 		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1255:
 		i2c_bus = &dev->i2c_bus[0];
@@ -574,6 +617,36 @@
 			break;
 		}
 		break;
+    case CX23885_BOARD_MPX885:
+		i2c_bus = &dev->i2c_bus[0];
+		switch (alt_tuner) {
+		case 1:
+			fe0->dvb.frontend =
+				dvb_attach(s5h1409_attach,
+					   &hauppauge_ezqam_config,
+					   &i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL) {
+				dvb_attach(tda829x_attach, fe0->dvb.frontend,
+					   &dev->i2c_bus[1].i2c_adap, 0x42,
+					   &tda829x_no_probe);
+				dvb_attach(tda18271_attach, fe0->dvb.frontend,
+					   0x60, &dev->i2c_bus[1].i2c_adap,
+					   &hauppauge_tda18271_config);
+			}
+			break;
+		case 0:
+		default:
+			fe0->dvb.frontend =
+				dvb_attach(s5h1409_attach,
+					   &hauppauge_generic_config,
+					   &i2c_bus->i2c_adap);
+			if (fe0->dvb.frontend != NULL)
+				dvb_attach(mt2131_attach, fe0->dvb.frontend,
+					   &i2c_bus->i2c_adap,
+					   &hauppauge_generic_tunerconfig, 0);
+			break;
+		}
+        break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 		i2c_bus = &dev->i2c_bus[0];
 		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
@@ -723,6 +796,7 @@
 	}
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_COMPRO_VIDEOMATE_E650F:
+	case CX23885_BOARD_COMPRO_VIDEOMATE_E800:
 		i2c_bus = &dev->i2c_bus[0];
 
 		fe0->dvb.frontend = dvb_attach(zl10353_attach,
@@ -833,6 +907,30 @@
 				&mygica_x8506_xc5000_config);
 		}
 		break;
+	case CX23885_BOARD_MAGICPRO_PROHDTVE2:
+		i2c_bus = &dev->i2c_bus[0];
+		i2c_bus2 = &dev->i2c_bus[1];
+		fe0->dvb.frontend = dvb_attach(lgs8gxx_attach,
+			&magicpro_prohdtve2_lgs8g75_config,
+			&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			dvb_attach(xc5000_attach,
+				fe0->dvb.frontend,
+				&i2c_bus2->i2c_adap,
+				&magicpro_prohdtve2_xc5000_config);
+		}
+		break;
+	case CX23885_BOARD_HAUPPAUGE_HVR1850:
+		i2c_bus = &dev->i2c_bus[0];
+		fe0->dvb.frontend = dvb_attach(s5h1411_attach,
+			&hcw_s5h1411_config,
+			&i2c_bus->i2c_adap);
+		if (fe0->dvb.frontend != NULL)
+			dvb_attach(tda18271_attach, fe0->dvb.frontend,
+				0x60, &dev->i2c_bus[0].i2c_adap,
+				&hauppauge_tda18271_config);
+		break;
+
 	default:
 		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
 			" isn't supported yet\n",
@@ -855,7 +953,8 @@
 
 	/* register everything */
 	ret = videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
-		&dev->pci->dev, adapter_nr, 0);
+					&dev->pci->dev, adapter_nr, 0,
+					cx23885_dvb_fe_ioctl_override);
 
 	/* init CI & MAC */
 	switch (dev->board) {
diff -u cx23885/cx23885.h cx23885-commell/cx23885.h
--- cx23885/cx23885.h	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885.h	2009-11-11 09:36:20.000000000 +0100
@@ -29,6 +29,7 @@
 #include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/videobuf-dvb.h>
+#include "compat.h"
 
 #include "btcx-risc.h"
 #include "cx23885-reg.h"
@@ -76,6 +77,10 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1255        20
 #define CX23885_BOARD_HAUPPAUGE_HVR1210        21
 #define CX23885_BOARD_MYGICA_X8506             22
+#define CX23885_BOARD_MAGICPRO_PROHDTVE2       23
+#define CX23885_BOARD_HAUPPAUGE_HVR1850        24
+#define CX23885_BOARD_COMPRO_VIDEOMATE_E800    25
+#define CX23885_BOARD_MPX885                26
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
@@ -87,6 +92,12 @@
 #define GPIO_7 0x00000080
 #define GPIO_8 0x00000100
 #define GPIO_9 0x00000200
+#define GPIO_10 0x00000400
+#define GPIO_11 0x00000800
+#define GPIO_12 0x00001000
+#define GPIO_13 0x00002000
+#define GPIO_14 0x00004000
+#define GPIO_15 0x00008000
 
 /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC */
 #define CX23885_NORMS (\
@@ -288,10 +299,6 @@
 	/* Allow a single tsport to have multiple frontends */
 	u32                        num_frontends;
 	void                       *port_priv;
-
-	/* FIXME: temporary hack */
-	int (*set_frontend_save) (struct dvb_frontend *,
-				  struct dvb_frontend_parameters *);
 };
 
 struct cx23885_dev {
@@ -317,6 +324,7 @@
 
 	int                        nr;
 	struct mutex               lock;
+	struct mutex               gpio_lock;
 
 	/* board details */
 	unsigned int               board;
@@ -331,6 +339,7 @@
 		CX23885_BRIDGE_UNDEFINED = 0,
 		CX23885_BRIDGE_885 = 885,
 		CX23885_BRIDGE_887 = 887,
+		CX23885_BRIDGE_888 = 888,
 	} bridge;
 
 	/* Analog video */
@@ -345,6 +354,16 @@
 	unsigned int               has_radio;
 	struct v4l2_subdev 	   *sd_cx25840;
 
+	/* Infrared */
+	struct v4l2_subdev         *sd_ir;
+	struct work_struct	   ir_rx_work;
+	unsigned long		   ir_rx_notifications;
+	struct work_struct	   ir_tx_work;
+	unsigned long		   ir_tx_notifications;
+
+	struct card_ir		   *ir_input;
+	atomic_t		   ir_input_stopping;
+
 	/* V4l */
 	u32                        freq;
 	struct video_device        *video_dev;
@@ -372,6 +391,13 @@
 #define call_all(dev, o, f, args...) \
 	v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
 
+#define CX23885_HW_888_IR (1 << 0)
+
+#define call_hw(dev, grpid, o, f, args...) \
+	v4l2_device_call_all(&dev->v4l2_dev, grpid, o, f, ##args)
+
+extern struct v4l2_subdev *cx23885_find_hw(struct cx23885_dev *dev, u32 hw);
+
 extern struct list_head cx23885_devlist;
 
 #define SRAM_CH01  0 /* Video A */
@@ -395,7 +421,7 @@
 	u32  cmds_start;
 	u32  ctrl_start;
 	u32  cdt;
-	u32  fifo_start;;
+	u32  fifo_start;
 	u32  fifo_size;
 	u32  ptr1_reg;
 	u32  ptr2_reg;
@@ -460,6 +486,8 @@
 	int command, int arg);
 extern void cx23885_card_list(struct cx23885_dev *dev);
 extern int  cx23885_ir_init(struct cx23885_dev *dev);
+extern void cx23885_ir_pci_int_enable(struct cx23885_dev *dev);
+extern void cx23885_ir_fini(struct cx23885_dev *dev);
 extern void cx23885_gpio_setup(struct cx23885_dev *dev);
 extern void cx23885_card_setup(struct cx23885_dev *dev);
 extern void cx23885_card_setup_pre_i2c(struct cx23885_dev *dev);
@@ -504,6 +532,13 @@
 extern void cx23885_mc417_init(struct cx23885_dev *dev);
 extern int mc417_memory_read(struct cx23885_dev *dev, u32 address, u32 *value);
 extern int mc417_memory_write(struct cx23885_dev *dev, u32 address, u32 value);
+extern int mc417_register_read(struct cx23885_dev *dev,
+				u16 address, u32 *value);
+extern int mc417_register_write(struct cx23885_dev *dev,
+				u16 address, u32 value);
+extern void mc417_gpio_set(struct cx23885_dev *dev, u32 mask);
+extern void mc417_gpio_clear(struct cx23885_dev *dev, u32 mask);
+extern void mc417_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput);
 
 
 /* ----------------------------------------------------------- */
diff -u cx23885/cx23885-i2c.c cx23885-commell/cx23885-i2c.c
--- cx23885/cx23885-i2c.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885-i2c.c	2009-11-11 09:36:16.000000000 +0100
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <asm/io.h>
 
+#include "compat.h"
 #include "cx23885.h"
 
 #include <media/v4l2-common.h>
@@ -276,6 +277,9 @@
 static struct i2c_algorithm cx23885_i2c_algo_template = {
 	.master_xfer	= i2c_xfer,
 	.functionality	= cx23885_functionality,
+#ifdef NEED_ALGO_CONTROL
+	.algo_control = dummy_algo_control,
+#endif
 };
 
 /* ----------------------------------------------------------------------- */
@@ -283,8 +287,13 @@
 static struct i2c_adapter cx23885_i2c_adap_template = {
 	.name              = "cx23885",
 	.owner             = THIS_MODULE,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 31)
 	.id                = I2C_HW_B_CX23885,
+#endif
 	.algo              = &cx23885_i2c_algo_template,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
+	.class             = I2C_CLASS_TV_ANALOG,
+#endif
 };
 
 static struct i2c_client cx23885_i2c_client_template = {
@@ -357,6 +366,7 @@
 		printk(KERN_WARNING "%s: i2c bus %d register FAILED\n",
 			dev->name, bus->nr);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	/* Instantiate the IR receiver device, if present */
 	if (0 == bus->i2c_rc) {
 		struct i2c_board_info info;
@@ -369,6 +379,7 @@
 		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list);
 	}
 
+#endif
 	return bus->i2c_rc;
 }
 
Nur in cx23885-commell: cx23885-input.c.
Nur in cx23885-commell: cx23885-input.h.
Nur in cx23885-commell: cx23885-ioctl.c.
Nur in cx23885-commell: cx23885-ioctl.h.
Nur in cx23885-commell: cx23885-ir.c.
Nur in cx23885-commell: cx23885-ir.h.
Nur in cx23885: cx23885.mod.c.
diff -u cx23885/cx23885-reg.h cx23885-commell/cx23885-reg.h
--- cx23885/cx23885-reg.h	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885-reg.h	2009-11-11 09:36:20.000000000 +0100
@@ -212,8 +212,9 @@
 
 #define DEV_CNTRL2	0x00040000
 
-#define PCI_MSK_GPIO1   (1 << 24)
-#define PCI_MSK_GPIO0   (1 << 23)
+#define PCI_MSK_IR        (1 << 28)
+#define PCI_MSK_GPIO1     (1 << 24)
+#define PCI_MSK_GPIO0     (1 << 23)
 #define PCI_MSK_APB_DMA   (1 << 12)
 #define PCI_MSK_AL_WR     (1 << 11)
 #define PCI_MSK_AL_RD     (1 << 10)
diff -u cx23885/cx23885-vbi.c cx23885-commell/cx23885-vbi.c
--- cx23885/cx23885-vbi.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885-vbi.c	2009-11-11 09:36:16.000000000 +0100
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 
+#include "compat.h"
 #include "cx23885.h"
 
 static unsigned int vbibufs = 4;
@@ -85,6 +86,19 @@
 	return 0;
 }
 
+#if 0
+/* not (yet) used */
+static int cx23885_stop_vbi_dma(struct cx23885_dev *dev)
+{
+	/* stop dma */
+	cx_clear(VID_A_DMA_CTL, 0x00000022);
+
+	/* disable irqs */
+	cx_clear(PCI_INT_MSK, 0x000001);
+	cx_clear(VID_A_INT_MSK, 0x00000022);
+	return 0;
+}
+#endif
 
 static int cx23885_restart_vbi_queue(struct cx23885_dev    *dev,
 			     struct cx23885_dmaqueue *q)
diff -u cx23885/cx23885-video.c cx23885-commell/cx23885-video.c
--- cx23885/cx23885-video.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/cx23885-video.c	2009-11-11 09:36:16.000000000 +0100
@@ -29,12 +29,14 @@
 #include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include "compat.h"
 #include <linux/kthread.h>
 #include <asm/div64.h>
 
 #include "cx23885.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include "cx23885-ioctl.h"
 
 MODULE_DESCRIPTION("v4l2 driver module for cx23885 based TV cards");
 MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
@@ -80,51 +82,82 @@
 	{
 		.name     = "8 bpp, gray",
 		.fourcc   = V4L2_PIX_FMT_GREY,
+#if 0
+		.cxformat = ColorFormatY8,
+#endif
 		.depth    = 8,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "15 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_RGB555,
+#if 0
+		.cxformat = ColorFormatRGB15,
+#endif
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "15 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB555X,
+#if 0
+		.cxformat = ColorFormatRGB15 | ColorFormatBSWAP,
+#endif
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "16 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_RGB565,
+#if 0
+		.cxformat = ColorFormatRGB16,
+#endif
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "16 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB565X,
+#if 0
+		.cxformat = ColorFormatRGB16 | ColorFormatBSWAP,
+#endif
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "24 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_BGR24,
+#if 0
+		.cxformat = ColorFormatRGB24,
+#endif
 		.depth    = 24,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "32 bpp RGB, le",
 		.fourcc   = V4L2_PIX_FMT_BGR32,
+#if 0
+		.cxformat = ColorFormatRGB32,
+#endif
 		.depth    = 32,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "32 bpp RGB, be",
 		.fourcc   = V4L2_PIX_FMT_RGB32,
+#if 0
+		.cxformat = ColorFormatRGB32 | ColorFormatBSWAP |
+			ColorFormatWSWAP,
+#endif
 		.depth    = 32,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "4:2:2, packed, YUYV",
 		.fourcc   = V4L2_PIX_FMT_YUYV,
+#if 0
+		.cxformat = ColorFormatYUY2,
+#endif
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
 	}, {
 		.name     = "4:2:2, packed, UYVY",
 		.fourcc   = V4L2_PIX_FMT_UYVY,
+#if 0
+		.cxformat = ColorFormatYUY2 | ColorFormatBSWAP,
+#endif
 		.depth    = 16,
 		.flags    = FORMAT_FLAGS_PACKED,
 	},
@@ -248,6 +281,9 @@
 	V4L2_CID_SATURATION,
 	V4L2_CID_HUE,
 	V4L2_CID_AUDIO_VOLUME,
+#if 0
+	V4L2_CID_AUDIO_BALANCE,
+#endif
 	V4L2_CID_AUDIO_MUTE,
 	0
 };
@@ -404,6 +440,10 @@
 	/* Tell the internal A/V decoder */
 	v4l2_subdev_call(dev->sd_cx25840, video, s_routing,
 			INPUT(input)->vmux, 0, 0);
+#if 0
+	/* Let the AVCore default */
+	v4l2_subdev_call(dev->sd_cx25840, audio, s_routing, 0, 0, 0);
+#endif
 
 	return 0;
 }
@@ -442,6 +482,22 @@
 	return 0;
 }
 
+#if 0
+#ifdef CONFIG_PM
+static int cx23885_stop_video_dma(struct cx23885_dev *dev)
+{
+	dprintk(1, "%s()\n", __func__);
+	/* stop dma */
+	cx_clear(VID_A_DMA_CTL, 0x11);
+
+	/* disable irqs */
+	cx_clear(PCI_INT_MSK, 0x000001);
+	cx_clear(VID_A_INT_MSK, 0x000011);
+
+	return 0;
+}
+#endif
+#endif
 
 static int cx23885_restart_video_queue(struct cx23885_dev *dev,
 			       struct cx23885_dmaqueue *q)
@@ -765,6 +821,20 @@
 
 	dprintk(1, "post videobuf_queue_init()\n");
 
+#if 0
+	if (fh->radio) {
+		int board = dev->board;
+		dprintk(1, "video_open: setting radio device\n");
+		cx_write(MO_GP3_IO, cx88_boards[board].radio.gpio3);
+		cx_write(MO_GP0_IO, cx88_boards[board].radio.gpio0);
+		cx_write(MO_GP1_IO, cx88_boards[board].radio.gpio1);
+		cx_write(MO_GP2_IO, cx88_boards[board].radio.gpio2);
+		dev->tvaudio = WW_FM;
+		cx23885_set_tvaudio(dev);
+		cx23885_set_stereo(dev, V4L2_TUNER_MODE_STEREO, 1);
+		call_all(dev, tuner, s_radio);
+	}
+#endif
 	unlock_kernel();
 
 	return 0;
@@ -860,6 +930,9 @@
 	}
 
 	videobuf_mmap_free(&fh->vidq);
+#if 0
+	videobuf_mmap_free(&fh->vbiq);
+#endif
 	file->private_data = NULL;
 	kfree(fh);
 
@@ -867,6 +940,9 @@
 	 * we want to use the mpeg encoder in another session to capture
 	 * tuner video. Closing this will result in no video to the encoder.
 	 */
+#if 0
+	call_all(dev, tuner, s_standby);
+#endif
 
 	return 0;
 }
@@ -894,6 +970,9 @@
 {
 	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)"
 		" (disabled - no action)\n", __func__);
+#if 1
+	call_all(dev, core, s_ctrl, ctl);
+#endif
 	return 0;
 }
 
@@ -1007,6 +1086,9 @@
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	cap->version = CX23885_VERSION_CODE;
 	cap->capabilities =
+#if 0
+		V4L2_CAP_VIDEO_OVERLAY |
+#endif
 		V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE     |
 		V4L2_CAP_STREAMING     |
@@ -1243,6 +1325,9 @@
 	t->type       = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM;
 	t->rangehigh  = 0xffffffffUL;
+#if 0
+	cx23885_get_stereo(dev, t);
+#endif
 	t->signal = 0xffff ; /* LOCKED */
 	return 0;
 }
@@ -1256,6 +1341,9 @@
 		return -EINVAL;
 	if (0 != t->index)
 		return -EINVAL;
+#if 0
+	cx23885_set_stereo(dev, t->audmode, 1);
+#endif
 	return 0;
 }
 
@@ -1312,34 +1400,105 @@
 		cx23885_set_freq(dev, f);
 }
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-static int vidioc_g_register(struct file *file, void *fh,
-				struct v4l2_dbg_register *reg)
+#if 0
+/* ----------------------------------------------------------- */
+/* RADIO ESPECIFIC IOCTLS                                      */
+/* ----------------------------------------------------------- */
+
+static int radio_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *cap)
+{
+	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+
+	strcpy(cap->driver, "cx23885");
+	strlcpy(cap->card, cx23885_boards[dev->board].name,
+		sizeof(cap->card));
+	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
+	cap->version = CX23885_VERSION_CODE;
+	cap->capabilities = V4L2_CAP_TUNER;
+	return 0;
+}
+
+static int radio_g_tuner(struct file *file, void *priv,
+				struct v4l2_tuner *t)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
+	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+
+	if (unlikely(t->index > 0))
+		return -EINVAL;
+
+	strcpy(t->name, "Radio");
+	t->type = V4L2_TUNER_RADIO;
+
+	call_all(dev, tuner, g_tuner, t);
+	return 0;
+}
 
-	if (!v4l2_chip_match_host(&reg->match))
+static int radio_enum_input(struct file *file, void *priv,
+				struct v4l2_input *i)
+{
+	if (i->index != 0)
 		return -EINVAL;
+	strcpy(i->name, "Radio");
+	i->type = V4L2_INPUT_TYPE_TUNER;
+
+	return 0;
+}
 
-	call_all(dev, core, g_register, reg);
+static int radio_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
+{
+	if (unlikely(a->index))
+		return -EINVAL;
 
+	memset(a, 0, sizeof(*a));
+	strcpy(a->name, "Radio");
 	return 0;
 }
 
-static int vidioc_s_register(struct file *file, void *fh,
-				struct v4l2_dbg_register *reg)
+/* FIXME: Should add a standard for radio */
+
+static int radio_s_tuner(struct file *file, void *priv,
+				struct v4l2_tuner *t)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
+	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
-	if (!v4l2_chip_match_host(&reg->match))
+	if (0 != t->index)
 		return -EINVAL;
 
-	call_all(dev, core, s_register, reg);
+	call_all(dev, tuner, s_tuner, t);
 
 	return 0;
 }
-#endif
 
+static int radio_s_audio(struct file *file, void *fh,
+			  struct v4l2_audio *a)
+{
+	return 0;
+}
+
+static int radio_s_input(struct file *file, void *fh, unsigned int i)
+{
+	return 0;
+}
+
+static int radio_queryctrl(struct file *file, void *priv,
+			    struct v4l2_queryctrl *c)
+{
+	int i;
+
+	if (c->id <  V4L2_CID_BASE ||
+		c->id >= V4L2_CID_LASTP1)
+		return -EINVAL;
+	if (c->id == V4L2_CID_AUDIO_MUTE) {
+		for (i = 0; i < CX23885_CTLS; i++)
+			if (cx23885_ctls[i].v.id == c->id)
+				break;
+		*c = cx23885_ctls[i].v;
+	} else
+		*c = no_ctl;
+	return 0;
+}
+#endif
 /* ----------------------------------------------------------- */
 
 static void cx23885_vid_timeout(unsigned long data)
@@ -1395,6 +1554,16 @@
 		spin_unlock(&dev->slock);
 		handled++;
 	}
+#if 0
+	/* risc1 vbi */
+	if (status & 0x08) {
+		spin_lock(&dev->slock);
+		count = cx_read(MO_VBI_GPCNT);
+		cx88_wakeup(core, &dev->vbiq, count);
+		spin_unlock(&dev->slock);
+		handled++;
+	}
+#endif
 	/* risc2 y */
 	if (status & 0x10) {
 		dprintk(2, "stopper video\n");
@@ -1403,6 +1572,16 @@
 		spin_unlock(&dev->slock);
 		handled++;
 	}
+#if 0
+	/* risc2 vbi */
+	if (status & 0x80) {
+		dprintk(2, "stopper vbi\n");
+		spin_lock(&dev->slock);
+		cx8800_restart_vbi_queue(dev, &dev->vbiq);
+		spin_unlock(&dev->slock);
+		handled++;
+	}
+#endif
 
 	return handled;
 }
@@ -1449,9 +1628,10 @@
 	.vidioc_s_tuner       = vidioc_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
+	.vidioc_g_chip_ident  = cx23885_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register    = vidioc_g_register,
-	.vidioc_s_register    = vidioc_s_register,
+	.vidioc_g_register    = cx23885_g_register,
+	.vidioc_s_register    = cx23885_s_register,
 #endif
 };
 
@@ -1472,12 +1652,52 @@
 	.ioctl         = video_ioctl2,
 };
 
+#if 0
+static const struct v4l2_ioctl_ops radio_ioctl_ops = {
+	.vidioc_querycap      = radio_querycap,
+	.vidioc_g_tuner       = radio_g_tuner,
+	.vidioc_enum_input    = radio_enum_input,
+	.vidioc_g_audio       = radio_g_audio,
+	.vidioc_s_tuner       = radio_s_tuner,
+	.vidioc_s_audio       = radio_s_audio,
+	.vidioc_s_input       = radio_s_input,
+	.vidioc_queryctrl     = radio_queryctrl,
+	.vidioc_g_ctrl        = vidioc_g_ctrl,
+	.vidioc_s_ctrl        = vidioc_s_ctrl,
+	.vidioc_g_frequency   = vidioc_g_frequency,
+	.vidioc_s_frequency   = vidioc_s_frequency,
+};
+
+static struct video_device cx23885_radio_template = {
+	.name                 = "cx23885-radio",
+	.fops                 = &radio_fops,
+	.ioctl_ops 	      = &radio_ioctl_ops,
+	.minor                = -1,
+};
+#endif
 
 void cx23885_video_unregister(struct cx23885_dev *dev)
 {
 	dprintk(1, "%s()\n", __func__);
 	cx_clear(PCI_INT_MSK, 1);
 
+#if 0
+	if (dev->radio_dev) {
+		if (-1 != dev->radio_dev->minor)
+			video_unregister_device(dev->radio_dev);
+		else
+			video_device_release(dev->radio_dev);
+		dev->radio_dev = NULL;
+	}
+	if (dev->vbi_dev) {
+		if (-1 != dev->vbi_dev->minor)
+			video_unregister_device(dev->vbi_dev);
+		else
+			video_device_release(dev->vbi_dev);
+		dev->vbi_dev = NULL;
+		btcx_riscmem_free(dev->pci, &dev->vbiq.stopper);
+	}
+#endif
 	if (dev->video_dev) {
 		if (-1 != dev->video_dev->minor)
 			video_unregister_device(dev->video_dev);
@@ -1513,6 +1733,16 @@
 		VID_A_DMA_CTL, 0x11, 0x00);
 
 	/* Don't enable VBI yet */
+#if 0
+	/* init vbi dma queues */
+	INIT_LIST_HEAD(&dev->vbiq.active);
+	INIT_LIST_HEAD(&dev->vbiq.queued);
+	dev->vbiq.timeout.function = cx23885_vbi_timeout;
+	dev->vbiq.timeout.data = (unsigned long)dev;
+	init_timer(&dev->vbiq.timeout);
+	cx23885_risc_stopper(dev->pci, &dev->vbiq.stopper,
+		VID_A_DMA_CTL, 0x88, 0x00);
+#endif
 	cx_set(PCI_INT_MSK, 1);
 
 	if (TUNER_ABSENT != dev->tuner_type) {
@@ -1521,11 +1751,11 @@
 		if (dev->tuner_addr)
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[1].i2c_adap,
-				"tuner", "tuner", dev->tuner_addr);
+				"tuner", "tuner", dev->tuner_addr, NULL);
 		else
-			sd = v4l2_i2c_new_probed_subdev(&dev->v4l2_dev,
+			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[1].i2c_adap,
-				"tuner", "tuner", v4l2_i2c_tuner_addrs(ADDRS_TV));
+				"tuner", "tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_TV));
 		if (sd) {
 			struct tuner_setup tun_setup;
 
@@ -1537,6 +1767,12 @@
 		}
 	}
 
+#if 0
+	if (cx23885_boards[dev->board].audio_chip == V4L2_IDENT_WM8775)
+		/* Must use v4l2_i2c_new_subdev instead of request_module
+		   once this is implemented for real. */
+		request_module("wm8775");
+#endif
 
 	/* register v4l devices */
 	dev->video_dev = cx23885_vdev_init(dev, dev->pci,
@@ -1550,6 +1786,33 @@
 	}
 	printk(KERN_INFO "%s/0: registered device video%d [v4l2]\n",
 	       dev->name, dev->video_dev->num);
+#if 0
+	dev->vbi_dev = cx23885_vdev_init(dev, dev->pci,
+		&cx23885_vbi_template, "vbi");
+	err = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
+				    vbi_nr[dev->nr]);
+	if (err < 0) {
+		printk(KERN_INFO "%s/0: can't register vbi device\n",
+			dev->name);
+		goto fail_unreg;
+	}
+	printk(KERN_INFO "%s/0: registered device vbi%d\n",
+	       dev->name, dev->vbi_dev->num);
+
+	if (dev->has_radio) {
+		dev->radio_dev = cx23885_vdev_init(dev, dev->pci,
+			&cx23885_radio_template, "radio");
+		err = video_register_device(dev->radio_dev, VFL_TYPE_RADIO,
+					    radio_nr[dev->nr]);
+		if (err < 0) {
+			printk(KERN_INFO "%s/0: can't register radio device\n",
+			       dev->name);
+			goto fail_unreg;
+		}
+		printk(KERN_INFO "%s/0: registered device radio%d\n",
+		       dev->name, dev->radio_dev->num);
+	}
+#endif
 	/* initial device configuration */
 	mutex_lock(&dev->lock);
 	cx23885_set_tvnorm(dev, dev->tvnorm);
Nur in cx23885-commell: cx23888-ir.c.
Nur in cx23885-commell: cx23888-ir.h.
diff -u cx23885/Makefile cx23885-commell/Makefile
--- cx23885/Makefile	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/Makefile	2009-10-25 08:18:46.000000000 +0100
@@ -1,5 +1,6 @@
 cx23885-objs	:= cx23885-cards.o cx23885-video.o cx23885-vbi.o \
 		    cx23885-core.o cx23885-i2c.o cx23885-dvb.o cx23885-417.o \
+		    cx23885-ioctl.o cx23885-ir.o cx23885-input.o cx23888-ir.o \
 		    netup-init.o cimax2.o netup-eeprom.o
 
 obj-$(CONFIG_VIDEO_CX23885) += cx23885.o
Nur in cx23885: modules.order.
diff -u cx23885/netup-eeprom.c cx23885-commell/netup-eeprom.c
--- cx23885/netup-eeprom.c	2010-02-15 23:22:38.000000000 +0100
+++ cx23885-commell/netup-eeprom.c	2009-11-11 09:36:16.000000000 +0100
@@ -97,11 +97,21 @@
 {
 	int i, j;
 
-	cinfo->rev =  netup_eeprom_read(i2c_adap, 13);
+	cinfo->rev =  netup_eeprom_read(i2c_adap, 63);
 
-	for (i = 0, j = 0; i < 6; i++, j++)
+	for (i = 64, j = 0; i < 70; i++, j++)
 		cinfo->port[0].mac[j] =  netup_eeprom_read(i2c_adap, i);
 
-	for (i = 6, j = 0; i < 12; i++, j++)
+	for (i = 70, j = 0; i < 76; i++, j++)
 		cinfo->port[1].mac[j] =  netup_eeprom_read(i2c_adap, i);
+#if 0
+	printk(KERN_INFO "NetUP Dual DVB-S2 CI card rev=0x%x MAC1=%02X:%02X:"
+	"%02X:%02X:%02X:%02X MAC2=%02X:%02X:%02X:%02X:%02X:%02X\n", cinfo->rev,
+		cinfo->port[0].mac[0], cinfo->port[0].mac[1],
+		cinfo->port[0].mac[2], cinfo->port[0].mac[3],
+		cinfo->port[0].mac[4], cinfo->port[0].mac[5],
+		cinfo->port[1].mac[0], cinfo->port[1].mac[1],
+		cinfo->port[1].mac[2], cinfo->port[1].mac[3],
+		cinfo->port[1].mac[4], cinfo->port[1].mac[5]);
+#endif
 };


--nextPart2023037.sOSvq9BKCP--


