Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:44753 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3KCLjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 06:39:45 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVO00DXSR28WG10@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Sun, 03 Nov 2013 06:39:44 -0500 (EST)
Date: Sun, 03 Nov 2013 09:39:39 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: CrazyCat <crazycat69@narod.ru>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] dw2102: Geniatech T220 support
Message-id: <20131103093939.1eae1a06@samsung.com>
In-reply-to: <52756895.6060405@narod.ru>
References: <52756895.6060405@narod.ru>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 02 Nov 2013 23:03:17 +0200
CrazyCat <crazycat69@narod.ru> escreveu:

> Support for Geniatech T220 DVB-T/T2/C USB stick.
> 
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> index 6136a2c..12e00aa 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -2,7 +2,7 @@
>    *	DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB-C 3101,
>    *	TeVii S600, S630, S650, S660, S480, S421, S632
>    *	Prof 1100, 7500,
> - *	Geniatech SU3000 Cards
> + *	Geniatech SU3000, T220 Cards
>    * Copyright (C) 2008-2012 Igor M. Liplianin (liplianin@me.by)
>    *
>    *	This program is free software; you can redistribute it and/or modify it
> @@ -29,6 +29,8 @@
>   #include "stb6100.h"
>   #include "stb6100_proc.h"
>   #include "m88rs2000.h"
> +#include "tda18271.h"
> +#include "cxd2820r.h"
> 
>   #ifndef USB_PID_DW2102
>   #define USB_PID_DW2102 0x2102
> @@ -1025,6 +1027,16 @@ static struct ds3000_config su3000_ds3000_config = {
>   	.set_lock_led = dw210x_led_ctrl,
>   };
> 
> +static struct cxd2820r_config cxd2820r_config = {
> +	.i2c_address = 0x6c, /* (0xd8 >> 1) */
> +	.ts_mode = 0x38,
> +};
> +
> +static struct tda18271_config tda18271_config = {
> +	.output_opt = TDA18271_OUTPUT_LT_OFF,
> +	.gate = TDA18271_GATE_DIGITAL,
> +};
> +
>   static u8 m88rs2000_inittab[] = {
>   	DEMOD_WRITE, 0x9a, 0x30,
>   	DEMOD_WRITE, 0x00, 0x01,
> @@ -1294,6 +1306,49 @@ static int su3000_frontend_attach(struct dvb_usb_adapter *d)
>   	return -EIO;
>   }
> 
> +static int t220_frontend_attach(struct dvb_usb_adapter *d)
> +{
> +	u8 obuf[3] = { 0xe, 0x80, 0 };
> +	u8 ibuf[] = { 0 };
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	obuf[0] = 0xe;
> +	obuf[1] = 0x83;
> +	obuf[2] = 0;
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	msleep(100);
> +
> +	obuf[0] = 0xe;
> +	obuf[1] = 0x80;
> +	obuf[2] = 1;
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 3, ibuf, 1, 0) < 0)
> +		err("command 0x0e transfer failed.");
> +
> +	obuf[0] = 0x51;
> +
> +	if (dvb_usb_generic_rw(d->dev, obuf, 1, ibuf, 1, 0) < 0)
> +		err("command 0x51 transfer failed.");
> +
> +	d->fe_adap[0].fe = dvb_attach(cxd2820r_attach, &cxd2820r_config,
> +					&d->dev->i2c_adap, NULL);
> +	if (d->fe_adap[0].fe != NULL) {
> +		if (dvb_attach(tda18271_attach, d->fe_adap[0].fe, 0x60,
> +					&d->dev->i2c_adap, &tda18271_config)) {
> +			info("Attached TDA18271HD/CXD2820R!\n");
> +			return 0;
> +		}
> +	}
> +
> +	info("Failed to attach TDA18271HD/CXD2820R!\n");
> +	return -EIO;
> +}
> +
>   static int m88rs2000_frontend_attach(struct dvb_usb_adapter *d)
>   {
>   	u8 obuf[] = { 0x51 };
> @@ -1560,6 +1615,7 @@ enum dw2102_table_entry {
>   	TEVII_S632,
>   	TERRATEC_CINERGY_S2_R2,
>   	GOTVIEW_SAT_HD,
> +	GENIATECH_T220,
>   };
> 
>   static struct usb_device_id dw2102_table[] = {
> @@ -1582,6 +1638,7 @@ static struct usb_device_id dw2102_table[] = {
>   	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
>   	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
>   	[GOTVIEW_SAT_HD] = {USB_DEVICE(0x1FE1, USB_PID_GOTVIEW_SAT_HD)},
> +	[GENIATECH_T220] = {USB_DEVICE(0x1f4d, 0xD220)},
>   	{ }
>   };
> 
> @@ -2007,6 +2064,54 @@ static struct dvb_usb_device_properties su3000_properties = {
>   	}
>   };
> 
> +static struct dvb_usb_device_properties t220_properties = {
> +	.caps = DVB_USB_IS_AN_I2C_ADAPTER,
> +	.usb_ctrl = DEVICE_SPECIFIC,
> +	.size_of_priv = sizeof(struct su3000_state),
> +	.power_ctrl = su3000_power_ctrl,
> +	.num_adapters = 1,
> +	.identify_state	= su3000_identify_state,
> +	.i2c_algo = &su3000_i2c_algo,
> +
> +	.rc.legacy = {
> +		.rc_map_table = rc_map_su3000_table,
> +		.rc_map_size = ARRAY_SIZE(rc_map_su3000_table),
> +		.rc_interval = 150,
> +		.rc_query = dw2102_rc_query,
> +	},

While you're here, could you please port this driver to use the
RC core, instead of the legacy RC support?

Porting it to rc core is not hard (but, ideally, it should be done by
someone with a hardware to test).

I did such port, for example, on az6007 driver:

commit d3d076aaa7d8a028ae4617f57c14727b473f848d
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Sat Jan 21 12:20:30 2012 -0300

    [media] az6007: Convert IR to use the rc_core logic
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index a8aedb8..2288916 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -192,26 +192,16 @@ static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return az6007_write(d, 0xbc, onoff, 0, NULL, 0);
 }
 
-/* keys for the enclosed remote control */
-static struct rc_map_table rc_map_az6007_table[] = {
-	{0x0001, KEY_1},
-	{0x0002, KEY_2},
-};
-
 /* remote control stuff (does not work with my box) */
-static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
+static int az6007_rc_query(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *st = d->priv;
-	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
-	int i;
 	unsigned code = 0;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
-	if (st->data[1] == 0x44) {
-		*state = REMOTE_NO_KEY_PRESSED;
+	if (st->data[1] == 0x44)
 		return 0;
-	}
 
 	if ((st->data[1] ^ st->data[2]) == 0xff)
 		code = st->data[1];
@@ -224,16 +214,9 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 		code = code << 16 | st->data[3] << 8| st->data[4];
 
 	printk("remote query key: %04x\n", code);
-	print_hex_dump_bytes("Remote: ", DUMP_PREFIX_NONE, st->data, 10);
 
-	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
-		if (rc5_custom(&keymap[i]) == code) {
-			*event = keymap[i].keycode;
-			*state = REMOTE_KEY_PRESSED;
+	rc_keydown(d->rc_dev, code, st->data[5]);
 
-			return 0;
-		}
-	}
 	return 0;
 }
 
@@ -536,11 +519,12 @@ static struct dvb_usb_device_properties az6007_properties = {
 	.power_ctrl       = az6007_power_ctrl,
 	.read_mac_address = az6007_read_mac_addr,
 
-	.rc.legacy = {
-		.rc_map_table  = rc_map_az6007_table,
-		.rc_map_size  = ARRAY_SIZE(rc_map_az6007_table),
+	.rc.core = {
 		.rc_interval      = 400,
+		.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
+		.module_name	  = "az6007",
 		.rc_query         = az6007_rc_query,
+		.allowed_protos   = RC_TYPE_NEC,
 	},
 	.i2c_algo         = &az6007_i2c_algo,
 

On the above, RC_MAP_DIB0700_NEC_TABLE points to the key table name.
You may need to create a keymap file under drivers/media/rc/keymaps/ that
points to the keyables inside dw2102.

Please also notice that there's one small change required on the above,
due to changeset c003ab1bedf028: you need to replace RC_TYPE_* to RC_BIT_*,
as done on this code snippet:

--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -826,7 +826,7 @@ static int az6007_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
        pr_debug("Getting az6007 Remote Control properties\n");
 
-   rc->allowed_protos = RC_TYPE_NEC;
+ rc->allowed_protos = RC_BIT_NEC;
        rc->query          = az6007_rc_query;
        rc->interval       = 400;


Thanks
-- 

Cheers,
Mauro
