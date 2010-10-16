Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35999 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab0JPOiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 10:38:18 -0400
Received: by vws2 with SMTP id 2so815901vws.19
        for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 07:38:17 -0700 (PDT)
Message-ID: <4CB9B8CF.1060503@gmail.com>
Date: Sat, 16 Oct 2010 11:38:07 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
MIME-Version: 1.0
To: "D. K." <user.vdr@gmail.com>
CC: linux-media@vger.kernel.org, alannisota@gmail.com
Subject: Re: [PATCH] gp8psk: Add support for the Genpix Skywalker-2
References: <4CB753F2.7080009@gmail.com>
In-Reply-To: <4CB753F2.7080009@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-10-2010 16:03, D. K. escreveu:
>  gp8psk: Add support for the Genpix Skywalker-2 per user requests.
> 
> Patched against v4l-dvb hg ab433502e041 tip.  Should patch fine
> against git as well.

No, it didn't apply at -git. It seems that the following patch already
added Skywalker-2.

Cheers,
Mauro

commit 458b634cd86968032171a4d6db5c89a772ff0348
Author: Alan Nisota <alannisota@gmail.com>
Date:   Sat Aug 18 17:52:35 2007 -0300

    V4L/DVB (6037): Updated GenPix USB driver
    
    There are now 4 different versions of the GENPIX USB adapter.  The
    newest 'Skywalker' models are fully self-contained, and need no
    additional hardware to be used.  A very reliable DVB-S card even without
    using any of the alternate modulatations (which this kernel module does
    not currently support)
    
    The following patch adds support for all 4 versions of the genpix
    adapter (www.genpix-electronics.com).
    
    Signed-off-by: Alan Nisota alannisota@gmail.com
    Signed-off-by: Patrick Boettcher <pb@linuxtv.org>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index a16be60..43bfe50 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -158,8 +158,11 @@
 #define USB_PID_WINFAST_DTV_DONGLE_COLD			0x6025
 #define USB_PID_WINFAST_DTV_DONGLE_WARM			0x6026
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P		0x6f00
-#define USB_PID_GENPIX_8PSK_COLD			0x0200
-#define USB_PID_GENPIX_8PSK_WARM			0x0201
+#define USB_PID_GENPIX_8PSK_REV_1_COLD			0x0200
+#define USB_PID_GENPIX_8PSK_REV_1_WARM			0x0201
+#define USB_PID_GENPIX_8PSK_REV_2			0x0202
+#define USB_PID_GENPIX_SKYWALKER_1			0x0203
+#define USB_PID_GENPIX_SKYWALKER_CW3K			0x0204
 #define USB_PID_SIGMATEK_DVB_110			0x6610
 #define USB_PID_MSI_DIGI_VOX_MINI_II			0x1513
 #define USB_PID_OPERA1_COLD				0x2830
diff --git a/drivers/media/dvb/dvb-usb/gp8psk-fe.c b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
index 6ccbdc9..e37142d 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
@@ -1,7 +1,8 @@
 /* DVB USB compliant Linux driver for the
- *  - GENPIX 8pks/qpsk USB2.0 DVB-S module
+ *  - GENPIX 8pks/qpsk/DCII USB2.0 DVB-S module
  *
- * Copyright (C) 2006 Alan Nisota (alannisota@gmail.com)
+ * Copyright (C) 2006,2007 Alan Nisota (alannisota@gmail.com)
+ * Copyright (C) 2006,2007 Genpix Electronics (genpix@genpix-electronics.com)
  *
  * Thanks to GENPIX for the sample code used to implement this module.
  *
@@ -17,27 +18,39 @@
 
 struct gp8psk_fe_state {
 	struct dvb_frontend fe;
-
 	struct dvb_usb_device *d;
-
+	u8 lock;
 	u16 snr;
-
-	unsigned long next_snr_check;
+	unsigned long next_status_check;
+	unsigned long status_check_interval;
 };
 
+static int gp8psk_fe_update_status(struct gp8psk_fe_state *st)
+{
+	u8 buf[6];
+	if (time_after(jiffies,st->next_status_check)) {
+		gp8psk_usb_in_op(st->d, GET_SIGNAL_LOCK, 0,0,&st->lock,1);
+		gp8psk_usb_in_op(st->d, GET_SIGNAL_STRENGTH, 0,0,buf,6);
+		st->snr = (buf[1]) << 8 | buf[0];
+		st->next_status_check = jiffies + (st->status_check_interval*HZ)/1000;
+	}
+	return 0;
+}
+
 static int gp8psk_fe_read_status(struct dvb_frontend* fe, fe_status_t *status)
 {
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
-	u8 lock;
+	gp8psk_fe_update_status(st);
 
-	if (gp8psk_usb_in_op(st->d, GET_SIGNAL_LOCK, 0, 0, &lock,1))
-		return -EINVAL;
-
-	if (lock)
+	if (st->lock)
 		*status = FE_HAS_LOCK | FE_HAS_SYNC | FE_HAS_VITERBI | FE_HAS_SIGNAL | FE_HAS_CARRIER;
 	else
 		*status = 0;
 
+	if (*status & FE_HAS_LOCK)
+		st->status_check_interval = 1000;
+	else
+		st->status_check_interval = 100;
 	return 0;
 }
 
@@ -60,33 +73,29 @@ static int gp8psk_fe_read_unc_blocks(struct dvb_frontend* fe, u32 *unc)
 static int gp8psk_fe_read_snr(struct dvb_frontend* fe, u16 *snr)
 {
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
-	u8 buf[2];
-
-	if (time_after(jiffies,st->next_snr_check)) {
-		gp8psk_usb_in_op(st->d,GET_SIGNAL_STRENGTH,0,0,buf,2);
-		*snr = (int)(buf[1]) << 8 | buf[0];
-		/* snr is reported in dBu*256 */
-		/* snr / 38.4 ~= 100% strength */
-		/* snr * 17 returns 100% strength as 65535 */
-		if (*snr <= 3855)
-			*snr = (*snr<<4) + *snr; // snr * 17
-		else
-			*snr = 65535;
-		st->next_snr_check = jiffies + (10*HZ)/1000;
-	} else {
-		*snr = st->snr;
-	}
+	gp8psk_fe_update_status(st);
+	/* snr is reported in dBu*256 */
+	*snr = st->snr;
 	return 0;
 }
 
 static int gp8psk_fe_read_signal_strength(struct dvb_frontend* fe, u16 *strength)
 {
-	return gp8psk_fe_read_snr(fe, strength);
+	struct gp8psk_fe_state *st = fe->demodulator_priv;
+	gp8psk_fe_update_status(st);
+	/* snr is reported in dBu*256 */
+	/* snr / 38.4 ~= 100% strength */
+	/* snr * 17 returns 100% strength as 65535 */
+	if (st->snr > 0xf00)
+		*strength = 0xffff;
+	else
+		*strength = (st->snr << 4) + st->snr; /* snr*17 */
+	return 0;
 }
 
 static int gp8psk_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings *tune)
 {
-	tune->min_delay_ms = 800;
+	tune->min_delay_ms = 200;
 	return 0;
 }
 
@@ -124,7 +133,9 @@ static int gp8psk_fe_set_frontend(struct dvb_frontend* fe,
 
 	gp8psk_usb_out_op(state->d,TUNE_8PSK,0,0,cmd,10);
 
-	state->next_snr_check = jiffies;
+	state->lock = 0;
+	state->next_status_check = jiffies;
+	state->status_check_interval = 200;
 
 	return 0;
 }
@@ -190,6 +201,12 @@ static int gp8psk_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t volt
 	return 0;
 }
 
+static int gp8psk_fe_enable_high_lnb_voltage(struct dvb_frontend* fe, long onoff)
+{
+	struct gp8psk_fe_state* state = fe->demodulator_priv;
+	return gp8psk_usb_out_op(state->d, USE_EXTRA_VOLT, onoff, 0,NULL,0);
+}
+
 static int gp8psk_fe_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long sw_cmd)
 {
 	struct gp8psk_fe_state* state = fe->demodulator_priv;
@@ -235,10 +252,10 @@ success:
 
 static struct dvb_frontend_ops gp8psk_fe_ops = {
 	.info = {
-		.name			= "Genpix 8psk-USB DVB-S",
+		.name			= "Genpix 8psk-to-USB2 DVB-S",
 		.type			= FE_QPSK,
-		.frequency_min		= 950000,
-		.frequency_max		= 2150000,
+		.frequency_min		= 800000,
+		.frequency_max		= 2250000,
 		.frequency_stepsize	= 100,
 		.symbol_rate_min        = 1000000,
 		.symbol_rate_max        = 45000000,
@@ -269,4 +286,5 @@ static struct dvb_frontend_ops gp8psk_fe_ops = {
 	.set_tone = gp8psk_fe_set_tone,
 	.set_voltage = gp8psk_fe_set_voltage,
 	.dishnetwork_send_legacy_command = gp8psk_fe_send_legacy_dish_cmd,
+	.enable_high_lnb_voltage = gp8psk_fe_enable_high_lnb_voltage
 };
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.c b/drivers/media/dvb/dvb-usb/gp8psk.c
index 518d67f..92147ee 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk.c
@@ -1,7 +1,8 @@
 /* DVB USB compliant Linux driver for the
- *  - GENPIX 8pks/qpsk USB2.0 DVB-S module
+ *  - GENPIX 8pks/qpsk/DCII USB2.0 DVB-S module
  *
- * Copyright (C) 2006 Alan Nisota (alannisota@gmail.com)
+ * Copyright (C) 2006,2007 Alan Nisota (alannisota@gmail.com)
+ * Copyright (C) 2006,2007 Genpix Electronics (genpix@genpix-electronics.com)
  *
  * Thanks to GENPIX for the sample code used to implement this module.
  *
@@ -40,7 +41,7 @@ int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8
 	}
 
 	if (ret < 0 || ret != blen) {
-		warn("usb in operation failed.");
+		warn("usb in %d operation failed.", req);
 		ret = -EIO;
 	} else
 		ret = 0;
@@ -97,10 +98,10 @@ static int gp8psk_load_bcm4500fw(struct dvb_usb_device *d)
 	if (gp8psk_usb_out_op(d, LOAD_BCM4500,1,0,NULL, 0))
 		goto out_rel_fw;
 
-	info("downloaidng bcm4500 firmware from file '%s'",bcm4500_firmware);
+	info("downloading bcm4500 firmware from file '%s'",bcm4500_firmware);
 
 	ptr = fw->data;
-	buf = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buf = kmalloc(64, GFP_KERNEL | GFP_DMA);
 
 	while (ptr[0] != 0xff) {
 		u16 buflen = ptr[0] + 4;
@@ -129,25 +130,34 @@ out_rel_fw:
 static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 {
 	u8 status, buf;
+	int gp_product_id = le16_to_cpu(d->udev->descriptor.idProduct);
+
 	if (onoff) {
 		gp8psk_usb_in_op(d, GET_8PSK_CONFIG,0,0,&status,1);
-		if (! (status & 0x01))  /* started */
+		if (! (status & bm8pskStarted)) {  /* started */
+			if(gp_product_id == USB_PID_GENPIX_SKYWALKER_CW3K)
+				gp8psk_usb_out_op(d, CW3K_INIT, 1, 0, NULL, 0);
 			if (gp8psk_usb_in_op(d, BOOT_8PSK, 1, 0, &buf, 1))
 				return -EINVAL;
+		}
 
-		if (! (status & 0x02)) /* BCM4500 firmware loaded */
-			if(gp8psk_load_bcm4500fw(d))
-				return EINVAL;
+		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
+			if (! (status & bm8pskFW_Loaded)) /* BCM4500 firmware loaded */
+				if(gp8psk_load_bcm4500fw(d))
+					return EINVAL;
 
-		if (! (status & 0x04)) /* LNB Power */
+		if (! (status & bmIntersilOn)) /* LNB Power */
 			if (gp8psk_usb_in_op(d, START_INTERSIL, 1, 0,
 					&buf, 1))
 				return EINVAL;
 
-		/* Set DVB mode */
-		if(gp8psk_usb_out_op(d, SET_DVB_MODE, 1, 0, NULL, 0))
-			return -EINVAL;
-		gp8psk_usb_in_op(d, GET_8PSK_CONFIG,0,0,&status,1);
+		/* Set DVB mode to 1 */
+		if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
+			if (gp8psk_usb_out_op(d, SET_DVB_MODE, 1, 0, NULL, 0))
+				return EINVAL;
+		/* Abort possible TS (if previous tune crashed) */
+		if (gp8psk_usb_out_op(d, ARM_TRANSFER, 0, 0, NULL, 0))
+			return EINVAL;
 	} else {
 		/* Turn off LNB power */
 		if (gp8psk_usb_in_op(d, START_INTERSIL, 0, 0, &buf, 1))
@@ -155,11 +165,28 @@ static int gp8psk_power_ctrl(struct dvb_usb_device *d, int onoff)
 		/* Turn off 8psk power */
 		if (gp8psk_usb_in_op(d, BOOT_8PSK, 0, 0, &buf, 1))
 			return -EINVAL;
-
+		if(gp_product_id == USB_PID_GENPIX_SKYWALKER_CW3K)
+			gp8psk_usb_out_op(d, CW3K_INIT, 0, 0, NULL, 0);
 	}
 	return 0;
 }
 
+int gp8psk_bcm4500_reload(struct dvb_usb_device *d)
+{
+	u8 buf;
+	int gp_product_id = le16_to_cpu(d->udev->descriptor.idProduct);
+	/* Turn off 8psk power */
+	if (gp8psk_usb_in_op(d, BOOT_8PSK, 0, 0, &buf, 1))
+		return -EINVAL;
+	/* Turn On 8psk power */
+	if (gp8psk_usb_in_op(d, BOOT_8PSK, 1, 0, &buf, 1))
+		return -EINVAL;
+	/* load BCM4500 firmware */
+	if (gp_product_id == USB_PID_GENPIX_8PSK_REV_1_WARM)
+		if (gp8psk_load_bcm4500fw(d))
+			return EINVAL;
+	return 0;
+}
 
 static int gp8psk_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
@@ -177,12 +204,22 @@ static struct dvb_usb_device_properties gp8psk_properties;
 static int gp8psk_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	return dvb_usb_device_init(intf,&gp8psk_properties,THIS_MODULE,NULL);
+	int ret;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	ret =  dvb_usb_device_init(intf,&gp8psk_properties,THIS_MODULE,NULL);
+	if (ret == 0) {
+		info("found Genpix USB device pID = %x (hex)",
+			le16_to_cpu(udev->descriptor.idProduct));
+	}
+	return ret;
 }
 
 static struct usb_device_id gp8psk_usb_table [] = {
-	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_COLD) },
-	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_WARM) },
+	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_COLD) },
+	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_1_WARM) },
+	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_8PSK_REV_2) },
+	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_1) },
+	    { USB_DEVICE(USB_VID_GENPIX, USB_PID_GENPIX_SKYWALKER_CW3K) },
 	    { 0 },
 };
 MODULE_DEVICE_TABLE(usb, gp8psk_usb_table);
@@ -213,12 +250,24 @@ static struct dvb_usb_device_properties gp8psk_properties = {
 
 	.generic_bulk_ctrl_endpoint = 0x01,
 
-	.num_device_descs = 1,
+	.num_device_descs = 4,
 	.devices = {
-		{ .name = "Genpix 8PSK-USB DVB-S USB2.0 receiver",
+		{ .name = "Genpix 8PSK-to-USB2 Rev.1 DVB-S receiver",
 		  .cold_ids = { &gp8psk_usb_table[0], NULL },
 		  .warm_ids = { &gp8psk_usb_table[1], NULL },
 		},
+		{ .name = "Genpix 8PSK-to-USB2 Rev.2 DVB-S receiver",
+		  .cold_ids = { NULL },
+		  .warm_ids = { &gp8psk_usb_table[2], NULL },
+		},
+		{ .name = "Genpix SkyWalker-1 DVB-S receiver",
+		  .cold_ids = { NULL },
+		  .warm_ids = { &gp8psk_usb_table[3], NULL },
+		},
+		{ .name = "Genpix SkyWalker-CW3K DVB-S receiver",
+		  .cold_ids = { NULL },
+		  .warm_ids = { &gp8psk_usb_table[4], NULL },
+		},
 		{ NULL },
 	}
 };
@@ -253,6 +302,6 @@ module_init(gp8psk_usb_module_init);
 module_exit(gp8psk_usb_module_exit);
 
 MODULE_AUTHOR("Alan Nisota <alannisota@gamil.com>");
-MODULE_DESCRIPTION("Driver for Genpix 8psk-USB DVB-S USB2.0");
-MODULE_VERSION("1.0");
+MODULE_DESCRIPTION("Driver for Genpix 8psk-to-USB2 DVB-S");
+MODULE_VERSION("1.1");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb/dvb-usb/gp8psk.h b/drivers/media/dvb/dvb-usb/gp8psk.h
index 3eba706..e83a575 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.h
+++ b/drivers/media/dvb/dvb-usb/gp8psk.h
@@ -1,7 +1,8 @@
 /* DVB USB compliant Linux driver for the
- *  - GENPIX 8pks/qpsk USB2.0 DVB-S module
+ *  - GENPIX 8pks/qpsk/DCII USB2.0 DVB-S module
  *
  * Copyright (C) 2006 Alan Nisota (alannisota@gmail.com)
+ * Copyright (C) 2006,2007 Alan Nisota (alannisota@gmail.com)
  *
  * Thanks to GENPIX for the sample code used to implement this module.
  *
@@ -30,21 +31,37 @@ extern int dvb_usb_gp8psk_debug;
 #define TH_COMMAND_IN                     0xC0
 #define TH_COMMAND_OUT                    0xC1
 
-/* command bytes */
-#define GET_8PSK_CONFIG                 0x80
+/* gp8psk commands */
+
+#define GET_8PSK_CONFIG                 0x80    /* in */
 #define SET_8PSK_CONFIG                 0x81
+#define I2C_WRITE			0x83
+#define I2C_READ			0x84
 #define ARM_TRANSFER                    0x85
 #define TUNE_8PSK                       0x86
-#define GET_SIGNAL_STRENGTH             0x87
+#define GET_SIGNAL_STRENGTH             0x87    /* in */
 #define LOAD_BCM4500                    0x88
-#define BOOT_8PSK                       0x89
-#define START_INTERSIL                  0x8A
+#define BOOT_8PSK                       0x89    /* in */
+#define START_INTERSIL                  0x8A    /* in */
 #define SET_LNB_VOLTAGE                 0x8B
 #define SET_22KHZ_TONE                  0x8C
 #define SEND_DISEQC_COMMAND             0x8D
 #define SET_DVB_MODE                    0x8E
 #define SET_DN_SWITCH                   0x8F
-#define GET_SIGNAL_LOCK                 0x90
+#define GET_SIGNAL_LOCK                 0x90    /* in */
+#define GET_SERIAL_NUMBER               0x93    /* in */
+#define USE_EXTRA_VOLT                  0x94
+#define CW3K_INIT			0x9d
+
+/* PSK_configuration bits */
+#define bm8pskStarted                   0x01
+#define bm8pskFW_Loaded                 0x02
+#define bmIntersilOn                    0x04
+#define bmDVBmode                       0x08
+#define bm22kHz                         0x10
+#define bmSEL18V                        0x20
+#define bmDCtuned                       0x40
+#define bmArmed                         0x80
 
 /* Satellite modulation modes */
 #define ADV_MOD_DVB_QPSK 0     /* DVB-S QPSK */
@@ -75,5 +92,6 @@ extern struct dvb_frontend * gp8psk_fe_attach(struct dvb_usb_device *d);
 extern int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen);
 extern int gp8psk_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 			     u16 index, u8 *b, int blen);
+extern int gp8psk_bcm4500_reload(struct dvb_usb_device *d);
 
 #endif

