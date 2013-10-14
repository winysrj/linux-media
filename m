Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:49309 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3JNNeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Oct 2013 09:34:25 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MUN009NZV082740@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Oct 2013 09:34:23 -0400 (EDT)
Date: Mon, 14 Oct 2013 10:34:19 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David Jedelsky <david.jedelsky@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] az6027: Added remote control support
Message-id: <20131014103419.2026cc46@samsung.com>
In-reply-to: <1379276215-3030-1-git-send-email-david.jedelsky@gmail.com>
References: <1379276215-3030-1-git-send-email-david.jedelsky@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Sun, 15 Sep 2013 22:16:55 +0200
David Jedelsky <david.jedelsky@gmail.com> escreveu:

> Added remote control support and possibility to add more RC key tables.
> Added module parameter for key table selection or disabling the RC.
> Single RC key table is provided (for below mentioned TS35).
> 
> This patch was tested on TechniSat SkyStar 2 HD CI USB ID 14f7:0002
> with bundled remote control TS35.
> 
> Signed-off-by: David Jedelsky <david.jedelsky@gmail.com>
> ---
>  drivers/media/usb/dvb-usb/az6027.c |  108 +++++++++++++++++++++++++++++++++---
>  1 file changed, 99 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
> index ea2d5ee..5c76f7d 100644
> --- a/drivers/media/usb/dvb-usb/az6027.c
> +++ b/drivers/media/usb/dvb-usb/az6027.c
> @@ -23,8 +23,18 @@ int dvb_usb_az6027_debug;
>  module_param_named(debug, dvb_usb_az6027_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "set debugging level (1=info,xfer=2,rc=4 (or-able))." DVB_USB_DEBUG_STATUS);
>  
> +/* keymaps */
> +static int ir_keymap;
> +module_param_named(keymap, ir_keymap, int, 0644);
> +MODULE_PARM_DESC(keymap, "set keymap: 0=TS35(Skystar2)  other=none");
> +
>  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
> +struct rc_map_dvb_usb_table_table {
> +	struct rc_map_table *rc_keys;
> +	int rc_keys_size;
> +};
> +
>  struct az6027_device_state {
>  	struct dvb_ca_en50221 ca;
>  	struct mutex ca_mutex;
> @@ -385,16 +395,96 @@ static int az6027_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
>  	return ret;
>  }
>  
> -/* keys for the enclosed remote control */
> -static struct rc_map_table rc_map_az6027_table[] = {
> -	{ 0x01, KEY_1 },
> -	{ 0x02, KEY_2 },
> +/* Keys for the remote control TS35 - bundled with TechniSat SkyStar2 HD CI */
> +static struct rc_map_table rc_map_skystar2_ts35[] = {
> +	{ 0xf520, KEY_CHANNELUP },
> +	{ 0xf510, KEY_VOLUMEUP },
> +	{ 0xf521, KEY_CHANNELDOWN },
> +	{ 0xf511, KEY_VOLUMEDOWN },
> +	{ 0xf517, KEY_OK },
> +	{ 0xf50d, KEY_MUTE },
> +	{ 0xf538, KEY_VIDEO }, /* EXT */
> +	{ 0xf523, KEY_AB },
> +	{ 0xf50c, KEY_POWER },
> +	{ 0xf501, KEY_1 },
> +	{ 0xf502, KEY_2 },
> +	{ 0xf503, KEY_3 },
> +	{ 0xf513, KEY_TV },
> +	{ 0xf504, KEY_4 },
> +	{ 0xf505, KEY_5 },
> +	{ 0xf506, KEY_6 },
> +	{ 0xf50a, KEY_LIST }, /* -/-- */
> +	{ 0xf507, KEY_7 },
> +	{ 0xf508, KEY_8 },
> +	{ 0xf509, KEY_9 },
> +	{ 0xf500, KEY_0 },
> +	{ 0xf50f, KEY_INFO },
> +	{ 0xf512, KEY_MENU },
> +	{ 0xf52f, KEY_EPG }, /* (*) SFI */
> +	{ 0xf522, KEY_BACK },
> +	{ 0xf52b, KEY_RED },
> +	{ 0xf52c, KEY_GREEN },
> +	{ 0xf52d, KEY_YELLOW },
> +	{ 0xf52e, KEY_BLUE },
> +	{ 0xf536, KEY_PLAY }, /* confirm sign */
> +	{ 0xf53c, KEY_TEXT },
> +	{ 0xf529, KEY_STOP },
> +};
> +
> +static struct rc_map_dvb_usb_table_table keys_tables[] = {
> +	{ rc_map_skystar2_ts35, ARRAY_SIZE(rc_map_skystar2_ts35) },
>  };
>  
> -/* remote control stuff (does not work with my box) */
>  static int az6027_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>  {
> -	return 0;
> +	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
> +	int keymap_size = d->props.rc.legacy.rc_map_size;
> +	int ret;
> +	int i;
> +	u8 b[10];
> +	u8 req = 0xB4;
> +	u16 value = 5;
> +	u16 index = 0;
> +	int blen = 10;
> +
> +	*state = REMOTE_NO_KEY_PRESSED;
> +	ret = az6027_usb_in_op(d, req, value, index, b, blen);
> +	if (ret != 0) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +	ret = 0;
> +
> +	deb_rc("in: req. %02x, val: %04x, buffer: ", req, value);
> +	debug_dump(b, blen, deb_rc);
> +
> +	/* override keymap */
> +	if ((ir_keymap > 0) && (ir_keymap <= ARRAY_SIZE(keys_tables))) {
> +		keymap = keys_tables[ir_keymap - 1].rc_keys;
> +		keymap_size = keys_tables[ir_keymap - 1].rc_keys_size;
> +	} else if (ir_keymap > ARRAY_SIZE(keys_tables))
> +		goto out; /* RC disabled */
> +
> +	if (b[3] + b[4] == 0xff) {
> +		/* key pressed */
> +		for (i = 0; i < keymap_size; i++) {
> +			if (rc5_data(&keymap[i]) == b[3]) {
> +				*state = REMOTE_KEY_PRESSED;
> +				*event = keymap[i].keycode;
> +				break;
> +			}
> +		}
> +
> +		if ((*state) == REMOTE_KEY_PRESSED)
> +			deb_rc("%s: found rc key: %x, %x, event: %x\n",
> +					__func__, b[2], b[3], (*event));
> +		else
> +			deb_rc("%s: unknown rc key: %x, %x\n",
> +					__func__, b[2], b[3]);
> +	}
> +
> +out:
> +	return ret;
>  }
>  
>  /*
> @@ -1128,9 +1218,9 @@ static struct dvb_usb_device_properties az6027_properties = {
>  	.read_mac_address = az6027_read_mac_addr,
>   */
>  	.rc.legacy = {
> -		.rc_map_table     = rc_map_az6027_table,
> -		.rc_map_size      = ARRAY_SIZE(rc_map_az6027_table),
> -		.rc_interval      = 400,
> +		.rc_map_table     = rc_map_skystar2_ts35,
> +		.rc_map_size      = ARRAY_SIZE(rc_map_skystar2_ts35),
> +		.rc_interval      = 150,
>  		.rc_query         = az6027_rc_query,
>  	},
>  

Please don't use the RC legacy support anymore. We want to get rid of
it, and move all keycode tables to drivers/media/rc/keymaps/. That
makes easier to re-use the keytables, to move them to userspace, and to
use different keycode tables, by replacing them in runtime via ir-keytables
(part of v4l2-utils package).

So, could you please convert it to use the non-legacy RC support?

You can use the patch for az6007 as an example, as the driver is very
close to az6027.


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
You should create a keymap file under drivers/media/rc/keymaps/ that
points to the keyable for the TS35 remote controller.

Please notice that there's one small change required on the above patch,
due to changeset c003ab1bedf028:

You need to replace RC_TYPE_* to RC_BIT_*, as on this code snippet:


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
