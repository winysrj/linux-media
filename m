Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:55825 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZEaWBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 18:01:07 -0400
Received: by fxm12 with SMTP id 12so5445420fxm.37
        for <linux-media@vger.kernel.org>; Sun, 31 May 2009 15:01:08 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Simon Kenyon <simon@koala.ie>
Subject: Re: [linux-dvb] SDMC DM1105N not being detected
Date: Mon, 1 Jun 2009 01:01:01 +0300
Cc: linux-media@vger.kernel.org
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <4A1C4AF1.6020200@koala.ie> <200905302000.32353.liplianin@me.by>
In-Reply-To: <200905302000.32353.liplianin@me.by>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_d4vIKzRJc0piL6Y"
Message-Id: <200906010101.01925.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_d4vIKzRJc0piL6Y
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 30 May 2009 20:00:32 Igor M. Liplianin wrote:
> On 26 May 2009 23:02:57 Simon Kenyon wrote:
> > Igor M. Liplianin wrote:
> > > The card is working with external LNB power supply, for example,
> > > through the loop out from another sat box. So, we need to know, which
> > > way to control LNB power on the board. Usually it is through GPIO pins.
> > > For example:
> > > Pins 112 and 111 for GPIO0, GPIO1. Also GPIO15 is at 65 pin.
> > > You can edit this lines in code:
> > > -*-*-*-*-*-*-*-*-*-*-*-*-
> > > /* GPIO's for LNB power control for Axess DM05 */
> > > #define DM05_LNB_MASK                           0xfffffffc  // GPIO
> > > control #define DM05_LNB_13V                            0x3fffd // GPIO
> > > value #define DM05_LNB_18V                            0x3fffc // GPIO
> > > value -*-*-*-*-*-*-*-*-*-*-*-*-
> > >
> > > BTW:
> > > Bit value 0 for GPIOCTL means output, 1 - input.
> > > Bit value for GPIOVAL - read/write.
> > > GPIO pins count is 18. Bits over 18 affect nothing.
> >
> > i will try to work out the correct values
> > when i have done so (or given up trying) i will let you know
> >
> > thank you very much for your help
> > --
> > simon
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Patch against latest v4l-dvb.
> Please, test it.
Patch version 2

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--Boundary-00=_d4vIKzRJc0piL6Y
Content-Type: text/x-diff;
  charset="koi8-r";
  name="11879_1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="11879_1.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1243803828 -10800
# Node ID 48737beb9517dbc995ad3abe2e8852f21608a9ab
# Parent  25bc0580359a71b2661ef0ac30e229b83ce84162
Add support for yet another SDMC DM1105 based DVB-S card.

From: Igor M. Liplianin <liplianin@me.by>

Add support for SDMC DM1105 based DVB-S cards with PCI ID 195d:1105

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r 25bc0580359a -r 48737beb9517 linux/drivers/media/dvb/dm1105/dm1105.c
--- a/linux/drivers/media/dvb/dm1105/dm1105.c	Fri May 29 17:03:31 2009 -0300
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c	Mon Jun 01 00:03:48 2009 +0300
@@ -51,6 +51,9 @@
 #ifndef PCI_VENDOR_ID_TRIGEM
 #define PCI_VENDOR_ID_TRIGEM	0x109f
 #endif
+#ifndef PCI_VENDOR_ID_AXESS
+#define PCI_VENDOR_ID_AXESS	0x195d
+#endif
 #ifndef PCI_DEVICE_ID_DM1105
 #define PCI_DEVICE_ID_DM1105	0x036f
 #endif
@@ -60,6 +63,9 @@
 #ifndef PCI_DEVICE_ID_DW2004
 #define PCI_DEVICE_ID_DW2004	0x2004
 #endif
+#ifndef PCI_DEVICE_ID_DM05
+#define PCI_DEVICE_ID_DM05	0x1105
+#endif
 /* ----------------------------------------------- */
 /* sdmc dm1105 registers */
 
@@ -150,6 +156,11 @@
 #define DM1105_LNB_13V				0x00010100
 #define DM1105_LNB_18V				0x00000100
 
+/* GPIO's for LNB power control for Axess DM05 */
+#define DM05_LNB_MASK				0x00000000
+#define DM05_LNB_13V				0x00020000
+#define DM05_LNB_18V				0x00030000
+
 static int ir_debug;
 module_param(ir_debug, int, 0644);
 MODULE_PARM_DESC(ir_debug, "enable debugging information for IR decoding");
@@ -316,15 +327,25 @@
 static int dm1105dvb_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 {
 	struct dm1105dvb *dm1105dvb = frontend_to_dm1105dvb(fe);
+	u32 lnb_mask, lnb_13v, lnb_18v;
 
-		if (voltage == SEC_VOLTAGE_18) {
-			outl(DM1105_LNB_MASK, dm_io_mem(DM1105_GPIOCTR));
-			outl(DM1105_LNB_18V, dm_io_mem(DM1105_GPIOVAL));
-		} else	{
-		/*LNB ON-13V by default!*/
-			outl(DM1105_LNB_MASK, dm_io_mem(DM1105_GPIOCTR));
-			outl(DM1105_LNB_13V, dm_io_mem(DM1105_GPIOVAL));
-		}
+	switch (dm1105dvb->pdev->subsystem_device) {
+	case PCI_DEVICE_ID_DM05:
+		lnb_mask = DM05_LNB_MASK;
+		lnb_13v = DM05_LNB_13V;
+		lnb_18v = DM05_LNB_18V;
+		break;
+	default:
+		lnb_mask = DM1105_LNB_MASK;
+		lnb_13v = DM1105_LNB_13V;
+		lnb_18v = DM1105_LNB_18V;
+	}
+
+	outl(lnb_mask, dm_io_mem(DM1105_GPIOCTR));
+	if (voltage == SEC_VOLTAGE_18)
+		outl(lnb_18v , dm_io_mem(DM1105_GPIOVAL));
+	else
+		outl(lnb_13v, dm_io_mem(DM1105_GPIOVAL));
 
 	return 0;
 }
@@ -599,46 +620,44 @@
 	int ret;
 
 	switch (dm1105dvb->pdev->subsystem_device) {
-	case PCI_DEVICE_ID_DW2002:
-		dm1105dvb->fe = dvb_attach(
-			stv0299_attach, &sharp_z0194a_config,
-			&dm1105dvb->i2c_adap);
-
-		if (dm1105dvb->fe) {
-			dm1105dvb->fe->ops.set_voltage =
-							dm1105dvb_set_voltage;
-			dvb_attach(dvb_pll_attach, dm1105dvb->fe, 0x60,
-					&dm1105dvb->i2c_adap, DVB_PLL_OPERA1);
-		}
-
-		if (!dm1105dvb->fe) {
-			dm1105dvb->fe = dvb_attach(
-				stv0288_attach, &earda_config,
-				&dm1105dvb->i2c_adap);
-			if (dm1105dvb->fe) {
-				dm1105dvb->fe->ops.set_voltage =
-							dm1105dvb_set_voltage;
-				dvb_attach(stb6000_attach, dm1105dvb->fe, 0x61,
-						&dm1105dvb->i2c_adap);
-			}
-		}
-
-		if (!dm1105dvb->fe) {
-			dm1105dvb->fe = dvb_attach(
-				si21xx_attach, &serit_config,
-				&dm1105dvb->i2c_adap);
-			if (dm1105dvb->fe)
-				dm1105dvb->fe->ops.set_voltage =
-							dm1105dvb_set_voltage;
-		}
-		break;
 	case PCI_DEVICE_ID_DW2004:
 		dm1105dvb->fe = dvb_attach(
 			cx24116_attach, &serit_sp2633_config,
 			&dm1105dvb->i2c_adap);
 		if (dm1105dvb->fe)
 			dm1105dvb->fe->ops.set_voltage = dm1105dvb_set_voltage;
+
 		break;
+	default:
+		dm1105dvb->fe = dvb_attach(
+			stv0299_attach, &sharp_z0194a_config,
+			&dm1105dvb->i2c_adap);
+		if (dm1105dvb->fe) {
+			dm1105dvb->fe->ops.set_voltage =
+							dm1105dvb_set_voltage;
+			dvb_attach(dvb_pll_attach, dm1105dvb->fe, 0x60,
+					&dm1105dvb->i2c_adap, DVB_PLL_OPERA1);
+			break;
+		}
+
+		dm1105dvb->fe = dvb_attach(
+			stv0288_attach, &earda_config,
+			&dm1105dvb->i2c_adap);
+		if (dm1105dvb->fe) {
+			dm1105dvb->fe->ops.set_voltage =
+						dm1105dvb_set_voltage;
+			dvb_attach(stb6000_attach, dm1105dvb->fe, 0x61,
+					&dm1105dvb->i2c_adap);
+			break;
+		}
+
+		dm1105dvb->fe = dvb_attach(
+			si21xx_attach, &serit_config,
+			&dm1105dvb->i2c_adap);
+		if (dm1105dvb->fe)
+			dm1105dvb->fe->ops.set_voltage =
+						dm1105dvb_set_voltage;
+
 	}
 
 	if (!dm1105dvb->fe) {
@@ -662,10 +681,17 @@
 	static u8 command[1] = { 0x28 };
 
 	struct i2c_msg msg[] = {
-		{ .addr = IIC_24C01_addr >> 1, .flags = 0,
-				.buf = command, .len = 1 },
-		{ .addr = IIC_24C01_addr >> 1, .flags = I2C_M_RD,
-				.buf = mac, .len = 6 },
+		{
+			.addr = IIC_24C01_addr >> 1,
+			.flags = 0,
+			.buf = command,
+			.len = 1
+		}, {
+			.addr = IIC_24C01_addr >> 1,
+			.flags = I2C_M_RD,
+			.buf = mac,
+			.len = 6
+		},
 	};
 
 	dm1105_i2c_xfer(&dm1105dvb->i2c_adap, msg , 2);
@@ -870,6 +896,11 @@
 		.subvendor = PCI_ANY_ID,
 		.subdevice = PCI_DEVICE_ID_DW2004,
 	}, {
+		.vendor = PCI_VENDOR_ID_AXESS,
+		.device = PCI_DEVICE_ID_DM05,
+		.subvendor = PCI_VENDOR_ID_AXESS,
+		.subdevice = PCI_DEVICE_ID_DM05,
+	}, {
 		/* empty */
 	},
 };

--Boundary-00=_d4vIKzRJc0piL6Y--
