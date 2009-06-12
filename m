Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:42454 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266AbZFLJC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 05:02:56 -0400
Received: by bwz9 with SMTP id 9so1941300bwz.37
        for <linux-media@vger.kernel.org>; Fri, 12 Jun 2009 02:02:57 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Simon Kenyon <simon@koala.ie>
Subject: Re: [linux-dvb] SDMC DM1105N not being detected
Date: Fri, 12 Jun 2009 12:05:07 +0300
Cc: linux-media@vger.kernel.org
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <200906061157.16433.liplianin@me.by> <4A2AD39B.9010700@koala.ie>
In-Reply-To: <4A2AD39B.9010700@koala.ie>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EphMKI8omAGcY2G"
Message-Id: <200906121205.08345.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_EphMKI8omAGcY2G
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 6 June 2009 23:37:47 Simon Kenyon wrote:
> Igor M. Liplianin wrote:
> > On 5 June 2009 21:41:46 Simon Kenyon wrote:
> >> Simon Kenyon wrote:
> >>> Simon Kenyon wrote:
> >>>> the picture seems to be breaking up badly
> >>>> will revert to my version and see if that fixes it
> >>>
> >>> [sorry for the delay. i was away on business]
> >>>
> >>> i've checked and your original code, modified to compile and including
> >>> my changes to control the LNB works very well; the patch you posted
> >>> does not. i have swapped between the two and rebooted several times to
> >>> make sure.
> >>>
> >>> i will do a diff and see what the differences are
> >>>
> >>> regards
> >>> --
> >>> simon
> >>
> >> the main changes seem to be a reworking of the interrupt handling and
> >> some i2c changes
> >> --
> >> simon
> >
> > How fast is your system?
>
> reasonably fast
> it is a dual core AMD64 X2 running at 3.1GHz
>
>
Main change is to move demuxing from interrupt to work handler.
So I prepaired another patch, with separate work queue.
May be you find some time to test.

I wonder CPU usage and interrupts count(cat /proc/interrupts) while viewing DVB. 
I guess your card generates a lot of unnecessary(unknown ?) irq's.

Another idea is to increase dma buffer.

--Boundary-00=_EphMKI8omAGcY2G
Content-Type: text/x-diff;
  charset="koi8-r";
  name="11966.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="11966.patch"

# HG changeset patch
# User Igor M. Liplianin <liplianin@me.by>
# Date 1244794252 -10800
# Node ID cd2cbde46892c2ad8258dd3162c5585e542afd50
# Parent  bff77ec331161c660be7a60bf6139df000758480
Add support for yet another SDMC DM1105 based DVB-S card.

From: Igor M. Liplianin <liplianin@me.by>

Add support for SDMC DM1105 based DVB-S cards with PCI ID 195d:1105

Signed-off-by: Igor M. Liplianin <liplianin@me.by>

diff -r bff77ec33116 -r cd2cbde46892 linux/drivers/media/dvb/dm1105/dm1105.c
--- a/linux/drivers/media/dvb/dm1105/dm1105.c	Thu Jun 11 18:44:23 2009 -0300
+++ b/linux/drivers/media/dvb/dm1105/dm1105.c	Fri Jun 12 11:10:52 2009 +0300
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
@@ -188,6 +199,8 @@
 
 	/* irq */
 	struct work_struct work;
+	struct workqueue_struct *wq;
+	char wqn[16];
 
 	/* dma */
 	dma_addr_t dma_addr;
@@ -316,15 +329,25 @@
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
@@ -463,7 +486,7 @@
 	case (INTSTS_TSIRQ | INTSTS_IR):
 		dm1105dvb->nextwrp = inl(dm_io_mem(DM1105_WRP)) -
 					inl(dm_io_mem(DM1105_STADR));
-		schedule_work(&dm1105dvb->work);
+		queue_work(dm1105dvb->wq, &dm1105dvb->work);
 		break;
 	case INTSTS_IR:
 		dm1105dvb->ir.ir_command = inl(dm_io_mem(DM1105_IRCODE));
@@ -599,46 +622,44 @@
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
@@ -662,10 +683,17 @@
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
@@ -788,14 +816,22 @@
 #else
 	INIT_WORK(&dm1105dvb->work, dm1105_dmx_buffer);
 #endif
+	sprintf(dm1105dvb->wqn, "%s/%d", dvb_adapter->name, dvb_adapter->num);
+	dm1105dvb->wq = create_singlethread_workqueue(dm1105dvb->wqn);
+	if (!dm1105dvb->wq)
+		goto err_dvb_net;
 
 	ret = request_irq(pdev->irq, dm1105dvb_irq, IRQF_SHARED,
 						DRIVER_NAME, dm1105dvb);
 	if (ret < 0)
-		goto err_free_irq;
+		goto err_workqueue;
 
 	return 0;
 
+err_workqueue:
+	destroy_workqueue(dm1105dvb->wq);
+err_dvb_net:
+	dvb_net_release(&dm1105dvb->dvbnet);
 err_disconnect_frontend:
 	dmx->disconnect_frontend(dmx);
 err_remove_mem_frontend:
@@ -812,8 +848,6 @@
 	i2c_del_adapter(&dm1105dvb->i2c_adap);
 err_dm1105dvb_hw_exit:
 	dm1105dvb_hw_exit(dm1105dvb);
-err_free_irq:
-	free_irq(pdev->irq, dm1105dvb);
 err_pci_iounmap:
 	pci_iounmap(pdev, dm1105dvb->io_mem);
 err_pci_release_regions:
@@ -870,6 +904,11 @@
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

--Boundary-00=_EphMKI8omAGcY2G--
