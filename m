Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49385 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461Ab3KNXF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Nov 2013 18:05:28 -0500
Message-ID: <52855733.4040908@iki.fi>
Date: Fri, 15 Nov 2013 01:05:23 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: CrazyCat <crazycat69@narod.ru>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] dw2102: Use RC Core instead of the legacy RC.
References: <4651914.EnQWLY6Jr6@ubuntu> <20131114112644.38186408@samsung.com> <1802447.fR9vMPcSaY@ubuntu>
In-Reply-To: <1802447.fR9vMPcSaY@ubuntu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14.11.2013 22:45, CrazyCat wrote:
> On Thursday 14 November 2013 11:26:44 Mauro Carvalho Chehab wrote:
>> Type here is likely RC_TYPE_NEC. It seems, however, that the keycodes
>> have just the least-significant 8 bits.
>
> Geniatech HDStar (su3000) remote is RC5 (conflict with my Philips TV remote). But rc pulse decoded by Cypress FX2 firmware and send only one byte code.
> So i mark this remote as TYPE_UNKNOWN (like existing keymaps for DVBWorld, TeVii, TBS).

If you know whole RC5 code and that single reported byte is part of 
that, you should IMHO add correct keytable to Kernel and emulate those 
missing bytes. See for example how I implemented anysee.c.

regards
Antti

>
>> You should also port the above keytables if they don't exist there yet,
>> or if the existing table have just the least-significant 8 bits, and if
>> this device can report the full NEC keycode.
>
> TBS, TeVii, DVBWorld (DM1105) RC keymas already present. So i use it.
>
> Tested with real TeVii S630, 660; Prof 7500; DW2104; Geniatech HDStar.
>
> But now  i implement separate rc_query routine for prof  (device send inverted key code).
>
> Signed-off-by: Evgeny Plehov <EvgenyPlehov@ukr.net>
> ---
>   drivers/media/rc/keymaps/Makefile    |    3 +-
>   drivers/media/rc/keymaps/rc-su3000.c |   77 ++++++++++
>   drivers/media/usb/dvb-usb/dw2102.c   |  277 +++++++---------------------------
>   include/media/rc-map.h               |    1 +
>   4 files changed, 133 insertions(+), 225 deletions(-)
>   create mode 100644 drivers/media/rc/keymaps/rc-su3000.c
>
> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> index b1cde8c..0b8c549 100644
> --- a/drivers/media/rc/keymaps/Makefile
> +++ b/drivers/media/rc/keymaps/Makefile
> @@ -98,4 +98,5 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>   			rc-videomate-s350.o \
>   			rc-videomate-tv-pvr.o \
>   			rc-winfast.o \
> -			rc-winfast-usbii-deluxe.o
> +			rc-winfast-usbii-deluxe.o \
> +			rc-su3000.o
> diff --git a/drivers/media/rc/keymaps/rc-su3000.c b/drivers/media/rc/keymaps/rc-su3000.c
> new file mode 100644
> index 0000000..8b14bdd
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-su3000.c
> @@ -0,0 +1,77 @@
> +/* tbs-nec.h - Keytable for tbs_nec Remote Controller
> + *
> + * keymap imported from ir-keymaps.c
> + *
> + * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <media/rc-map.h>
> +#include <linux/module.h>
> +
> +static struct rc_map_table su3000[] = {
> +	{ 0x25, KEY_POWER },	/* right-bottom Red */
> +	{ 0x0a, KEY_MUTE },	/* -/-- */
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +	{ 0x00, KEY_0 },
> +	{ 0x20, KEY_UP },	/* CH+ */
> +	{ 0x21, KEY_DOWN },	/* CH+ */
> +	{ 0x12, KEY_VOLUMEUP },	/* Brightness Up */
> +	{ 0x13, KEY_VOLUMEDOWN },/* Brightness Down */
> +	{ 0x1f, KEY_RECORD },
> +	{ 0x17, KEY_PLAY },
> +	{ 0x16, KEY_PAUSE },
> +	{ 0x0b, KEY_STOP },
> +	{ 0x27, KEY_FASTFORWARD },/* >> */
> +	{ 0x26, KEY_REWIND },	/* << */
> +	{ 0x0d, KEY_OK },	/* Mute */
> +	{ 0x11, KEY_LEFT },	/* VOL- */
> +	{ 0x10, KEY_RIGHT },	/* VOL+ */
> +	{ 0x29, KEY_BACK },	/* button under 9 */
> +	{ 0x2c, KEY_MENU },	/* TTX */
> +	{ 0x2b, KEY_EPG },	/* EPG */
> +	{ 0x1e, KEY_RED },	/* OSD */
> +	{ 0x0e, KEY_GREEN },	/* Window */
> +	{ 0x2d, KEY_YELLOW },	/* button under << */
> +	{ 0x0f, KEY_BLUE },	/* bottom yellow button */
> +	{ 0x14, KEY_AUDIO },	/* Snapshot */
> +	{ 0x38, KEY_TV },	/* TV/Radio */
> +	{ 0x0c, KEY_ESC }	/* upper Red button */
> +};
> +
> +static struct rc_map_list su3000_map = {
> +	.map = {
> +		.scan    = su3000,
> +		.size    = ARRAY_SIZE(su3000),
> +		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_SU3000,
> +	}
> +};
> +
> +static int __init init_rc_map_su3000(void)
> +{
> +	return rc_map_register(&su3000_map);
> +}
> +
> +static void __exit exit_rc_map_su3000(void)
> +{
> +	rc_map_unregister(&su3000_map);
> +}
> +
> +module_init(init_rc_map_su3000)
> +module_exit(exit_rc_map_su3000)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> index 12e00aa..5a4fa6d 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -109,11 +109,6 @@
>   		"Please see linux/Documentation/dvb/ for more details " \
>   		"on firmware-problems."
>
> -struct rc_map_dvb_usb_table_table {
> -	struct rc_map_table *rc_keys;
> -	int rc_keys_size;
> -};
> -
>   struct su3000_state {
>   	u8 initialized;
>   };
> @@ -128,12 +123,6 @@ module_param_named(debug, dvb_usb_dw2102_debug, int, 0644);
>   MODULE_PARM_DESC(debug, "set debugging level (1=info 2=xfer 4=rc(or-able))."
>   						DVB_USB_DEBUG_STATUS);
>
> -/* keymaps */
> -static int ir_keymap;
> -module_param_named(keymap, ir_keymap, int, 0644);
> -MODULE_PARM_DESC(keymap, "set keymap 0=default 1=dvbworld 2=tevii 3=tbs  ..."
> -			" 256=none");
> -
>   /* demod probe */
>   static int demod_probe = 1;
>   module_param_named(demod, demod_probe, int, 0644);
> @@ -1389,174 +1378,29 @@ static int dw3101_tuner_attach(struct dvb_usb_adapter *adap)
>   	return 0;
>   }
>
> -static struct rc_map_table rc_map_dw210x_table[] = {
> -	{ 0xf80a, KEY_POWER2 },		/*power*/
> -	{ 0xf80c, KEY_MUTE },		/*mute*/
> -	{ 0xf811, KEY_1 },
> -	{ 0xf812, KEY_2 },
> -	{ 0xf813, KEY_3 },
> -	{ 0xf814, KEY_4 },
> -	{ 0xf815, KEY_5 },
> -	{ 0xf816, KEY_6 },
> -	{ 0xf817, KEY_7 },
> -	{ 0xf818, KEY_8 },
> -	{ 0xf819, KEY_9 },
> -	{ 0xf810, KEY_0 },
> -	{ 0xf81c, KEY_CHANNELUP },	/*ch+*/
> -	{ 0xf80f, KEY_CHANNELDOWN },	/*ch-*/
> -	{ 0xf81a, KEY_VOLUMEUP },	/*vol+*/
> -	{ 0xf80e, KEY_VOLUMEDOWN },	/*vol-*/
> -	{ 0xf804, KEY_RECORD },		/*rec*/
> -	{ 0xf809, KEY_FAVORITES },	/*fav*/
> -	{ 0xf808, KEY_REWIND },		/*rewind*/
> -	{ 0xf807, KEY_FASTFORWARD },	/*fast*/
> -	{ 0xf80b, KEY_PAUSE },		/*pause*/
> -	{ 0xf802, KEY_ESC },		/*cancel*/
> -	{ 0xf803, KEY_TAB },		/*tab*/
> -	{ 0xf800, KEY_UP },		/*up*/
> -	{ 0xf81f, KEY_OK },		/*ok*/
> -	{ 0xf801, KEY_DOWN },		/*down*/
> -	{ 0xf805, KEY_CAMERA },		/*cap*/
> -	{ 0xf806, KEY_STOP },		/*stop*/
> -	{ 0xf840, KEY_ZOOM },		/*full*/
> -	{ 0xf81e, KEY_TV },		/*tvmode*/
> -	{ 0xf81b, KEY_LAST },		/*recall*/
> -};
> -
> -static struct rc_map_table rc_map_tevii_table[] = {
> -	{ 0xf80a, KEY_POWER },
> -	{ 0xf80c, KEY_MUTE },
> -	{ 0xf811, KEY_1 },
> -	{ 0xf812, KEY_2 },
> -	{ 0xf813, KEY_3 },
> -	{ 0xf814, KEY_4 },
> -	{ 0xf815, KEY_5 },
> -	{ 0xf816, KEY_6 },
> -	{ 0xf817, KEY_7 },
> -	{ 0xf818, KEY_8 },
> -	{ 0xf819, KEY_9 },
> -	{ 0xf810, KEY_0 },
> -	{ 0xf81c, KEY_MENU },
> -	{ 0xf80f, KEY_VOLUMEDOWN },
> -	{ 0xf81a, KEY_LAST },
> -	{ 0xf80e, KEY_OPEN },
> -	{ 0xf804, KEY_RECORD },
> -	{ 0xf809, KEY_VOLUMEUP },
> -	{ 0xf808, KEY_CHANNELUP },
> -	{ 0xf807, KEY_PVR },
> -	{ 0xf80b, KEY_TIME },
> -	{ 0xf802, KEY_RIGHT },
> -	{ 0xf803, KEY_LEFT },
> -	{ 0xf800, KEY_UP },
> -	{ 0xf81f, KEY_OK },
> -	{ 0xf801, KEY_DOWN },
> -	{ 0xf805, KEY_TUNER },
> -	{ 0xf806, KEY_CHANNELDOWN },
> -	{ 0xf840, KEY_PLAYPAUSE },
> -	{ 0xf81e, KEY_REWIND },
> -	{ 0xf81b, KEY_FAVORITES },
> -	{ 0xf81d, KEY_BACK },
> -	{ 0xf84d, KEY_FASTFORWARD },
> -	{ 0xf844, KEY_EPG },
> -	{ 0xf84c, KEY_INFO },
> -	{ 0xf841, KEY_AB },
> -	{ 0xf843, KEY_AUDIO },
> -	{ 0xf845, KEY_SUBTITLE },
> -	{ 0xf84a, KEY_LIST },
> -	{ 0xf846, KEY_F1 },
> -	{ 0xf847, KEY_F2 },
> -	{ 0xf85e, KEY_F3 },
> -	{ 0xf85c, KEY_F4 },
> -	{ 0xf852, KEY_F5 },
> -	{ 0xf85a, KEY_F6 },
> -	{ 0xf856, KEY_MODE },
> -	{ 0xf858, KEY_SWITCHVIDEOMODE },
> -};
> -
> -static struct rc_map_table rc_map_tbs_table[] = {
> -	{ 0xf884, KEY_POWER },
> -	{ 0xf894, KEY_MUTE },
> -	{ 0xf887, KEY_1 },
> -	{ 0xf886, KEY_2 },
> -	{ 0xf885, KEY_3 },
> -	{ 0xf88b, KEY_4 },
> -	{ 0xf88a, KEY_5 },
> -	{ 0xf889, KEY_6 },
> -	{ 0xf88f, KEY_7 },
> -	{ 0xf88e, KEY_8 },
> -	{ 0xf88d, KEY_9 },
> -	{ 0xf892, KEY_0 },
> -	{ 0xf896, KEY_CHANNELUP },
> -	{ 0xf891, KEY_CHANNELDOWN },
> -	{ 0xf893, KEY_VOLUMEUP },
> -	{ 0xf88c, KEY_VOLUMEDOWN },
> -	{ 0xf883, KEY_RECORD },
> -	{ 0xf898, KEY_PAUSE  },
> -	{ 0xf899, KEY_OK },
> -	{ 0xf89a, KEY_SHUFFLE },
> -	{ 0xf881, KEY_UP },
> -	{ 0xf890, KEY_LEFT },
> -	{ 0xf882, KEY_RIGHT },
> -	{ 0xf888, KEY_DOWN },
> -	{ 0xf895, KEY_FAVORITES },
> -	{ 0xf897, KEY_SUBTITLE },
> -	{ 0xf89d, KEY_ZOOM },
> -	{ 0xf89f, KEY_EXIT },
> -	{ 0xf89e, KEY_MENU },
> -	{ 0xf89c, KEY_EPG },
> -	{ 0xf880, KEY_PREVIOUS },
> -	{ 0xf89b, KEY_MODE }
> -};
> +static int dw2102_rc_query(struct dvb_usb_device *d)
> +{
> +	u8 key[2];
> +	struct i2c_msg msg = {
> +		.addr = DW2102_RC_QUERY,
> +		.flags = I2C_M_RD,
> +		.buf = key,
> +		.len = 2
> +	};
>
> -static struct rc_map_table rc_map_su3000_table[] = {
> -	{ 0x25, KEY_POWER },	/* right-bottom Red */
> -	{ 0x0a, KEY_MUTE },	/* -/-- */
> -	{ 0x01, KEY_1 },
> -	{ 0x02, KEY_2 },
> -	{ 0x03, KEY_3 },
> -	{ 0x04, KEY_4 },
> -	{ 0x05, KEY_5 },
> -	{ 0x06, KEY_6 },
> -	{ 0x07, KEY_7 },
> -	{ 0x08, KEY_8 },
> -	{ 0x09, KEY_9 },
> -	{ 0x00, KEY_0 },
> -	{ 0x20, KEY_UP },	/* CH+ */
> -	{ 0x21, KEY_DOWN },	/* CH+ */
> -	{ 0x12, KEY_VOLUMEUP },	/* Brightness Up */
> -	{ 0x13, KEY_VOLUMEDOWN },/* Brightness Down */
> -	{ 0x1f, KEY_RECORD },
> -	{ 0x17, KEY_PLAY },
> -	{ 0x16, KEY_PAUSE },
> -	{ 0x0b, KEY_STOP },
> -	{ 0x27, KEY_FASTFORWARD },/* >> */
> -	{ 0x26, KEY_REWIND },	/* << */
> -	{ 0x0d, KEY_OK },	/* Mute */
> -	{ 0x11, KEY_LEFT },	/* VOL- */
> -	{ 0x10, KEY_RIGHT },	/* VOL+ */
> -	{ 0x29, KEY_BACK },	/* button under 9 */
> -	{ 0x2c, KEY_MENU },	/* TTX */
> -	{ 0x2b, KEY_EPG },	/* EPG */
> -	{ 0x1e, KEY_RED },	/* OSD */
> -	{ 0x0e, KEY_GREEN },	/* Window */
> -	{ 0x2d, KEY_YELLOW },	/* button under << */
> -	{ 0x0f, KEY_BLUE },	/* bottom yellow button */
> -	{ 0x14, KEY_AUDIO },	/* Snapshot */
> -	{ 0x38, KEY_TV },	/* TV/Radio */
> -	{ 0x0c, KEY_ESC }	/* upper Red button */
> -};
> +	if (d->props.i2c_algo->master_xfer(&d->i2c_adap, &msg, 1) == 1) {
> +		if (msg.buf[0] != 0xff) {
> +			deb_rc("%s: rc code: %x, %x\n",
> +					__func__, key[0], key[1]);
> +			rc_keydown(d->rc_dev, key[0], 1);
> +		}
> +	}
>
> -static struct rc_map_dvb_usb_table_table keys_tables[] = {
> -	{ rc_map_dw210x_table, ARRAY_SIZE(rc_map_dw210x_table) },
> -	{ rc_map_tevii_table, ARRAY_SIZE(rc_map_tevii_table) },
> -	{ rc_map_tbs_table, ARRAY_SIZE(rc_map_tbs_table) },
> -	{ rc_map_su3000_table, ARRAY_SIZE(rc_map_su3000_table) },
> -};
> +	return 0;
> +}
>
> -static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
> +static int prof_rc_query(struct dvb_usb_device *d)
>   {
> -	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
> -	int keymap_size = d->props.rc.legacy.rc_map_size;
>   	u8 key[2];
>   	struct i2c_msg msg = {
>   		.addr = DW2102_RC_QUERY,
> @@ -1564,32 +1408,13 @@ static int dw2102_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
>   		.buf = key,
>   		.len = 2
>   	};
> -	int i;
> -	/* override keymap */
> -	if ((ir_keymap > 0) && (ir_keymap <= ARRAY_SIZE(keys_tables))) {
> -		keymap = keys_tables[ir_keymap - 1].rc_keys ;
> -		keymap_size = keys_tables[ir_keymap - 1].rc_keys_size;
> -	} else if (ir_keymap > ARRAY_SIZE(keys_tables))
> -		return 0; /* none */
> -
> -	*state = REMOTE_NO_KEY_PRESSED;
> -	if (d->props.i2c_algo->master_xfer(&d->i2c_adap, &msg, 1) == 1) {
> -		for (i = 0; i < keymap_size ; i++) {
> -			if (rc5_data(&keymap[i]) == msg.buf[0]) {
> -				*state = REMOTE_KEY_PRESSED;
> -				*event = keymap[i].keycode;
> -				break;
> -			}
> -
> -		}
>
> -		if ((*state) == REMOTE_KEY_PRESSED)
> -			deb_rc("%s: found rc key: %x, %x, event: %x\n",
> -					__func__, key[0], key[1], (*event));
> -		else if (key[0] != 0xff)
> -			deb_rc("%s: unknown rc key: %x, %x\n",
> +	if (d->props.i2c_algo->master_xfer(&d->i2c_adap, &msg, 1) == 1) {
> +		if (msg.buf[0] != 0xff) {
> +			deb_rc("%s: rc code: %x, %x\n",
>   					__func__, key[0], key[1]);
> -
> +			rc_keydown(d->rc_dev, key[0]^0xff, 1);
> +		}
>   	}
>
>   	return 0;
> @@ -1698,9 +1523,7 @@ static int dw2102_load_firmware(struct usb_device *dev,
>   		/* init registers */
>   		switch (dev->descriptor.idProduct) {
>   		case USB_PID_TEVII_S650:
> -			dw2104_properties.rc.legacy.rc_map_table = rc_map_tevii_table;
> -			dw2104_properties.rc.legacy.rc_map_size =
> -					ARRAY_SIZE(rc_map_tevii_table);
> +			dw2104_properties.rc.core.rc_codes = RC_MAP_TEVII_NEC;
>   		case USB_PID_DW2104:
>   			reset = 1;
>   			dw210x_op_rw(dev, 0xc4, 0x0000, 0, &reset, 1,
> @@ -1764,10 +1587,11 @@ static struct dvb_usb_device_properties dw2102_properties = {
>
>   	.i2c_algo = &dw2102_serit_i2c_algo,
>
> -	.rc.legacy = {
> -		.rc_map_table = rc_map_dw210x_table,
> -		.rc_map_size = ARRAY_SIZE(rc_map_dw210x_table),
> +	.rc.core = {
>   		.rc_interval = 150,
> +		.rc_codes = RC_MAP_DM1105_NEC,
> +		.module_name = "dw2102",
> +		.allowed_protos   = RC_TYPE_NEC,
>   		.rc_query = dw2102_rc_query,
>   	},
>
> @@ -1818,10 +1642,11 @@ static struct dvb_usb_device_properties dw2104_properties = {
>   	.no_reconnect = 1,
>
>   	.i2c_algo = &dw2104_i2c_algo,
> -	.rc.legacy = {
> -		.rc_map_table = rc_map_dw210x_table,
> -		.rc_map_size = ARRAY_SIZE(rc_map_dw210x_table),
> +	.rc.core = {
>   		.rc_interval = 150,
> +		.rc_codes = RC_MAP_DM1105_NEC,
> +		.module_name = "dw2102",
> +		.allowed_protos   = RC_TYPE_NEC,
>   		.rc_query = dw2102_rc_query,
>   	},
>
> @@ -1868,10 +1693,11 @@ static struct dvb_usb_device_properties dw3101_properties = {
>   	.no_reconnect = 1,
>
>   	.i2c_algo = &dw3101_i2c_algo,
> -	.rc.legacy = {
> -		.rc_map_table = rc_map_dw210x_table,
> -		.rc_map_size = ARRAY_SIZE(rc_map_dw210x_table),
> +	.rc.core = {
>   		.rc_interval = 150,
> +		.rc_codes = RC_MAP_DM1105_NEC,
> +		.module_name = "dw2102",
> +		.allowed_protos   = RC_TYPE_NEC,
>   		.rc_query = dw2102_rc_query,
>   	},
>
> @@ -1916,10 +1742,11 @@ static struct dvb_usb_device_properties s6x0_properties = {
>   	.no_reconnect = 1,
>
>   	.i2c_algo = &s6x0_i2c_algo,
> -	.rc.legacy = {
> -		.rc_map_table = rc_map_tevii_table,
> -		.rc_map_size = ARRAY_SIZE(rc_map_tevii_table),
> +	.rc.core = {
>   		.rc_interval = 150,
> +		.rc_codes = RC_MAP_TEVII_NEC,
> +		.module_name = "dw2102",
> +		.allowed_protos   = RC_TYPE_NEC,
>   		.rc_query = dw2102_rc_query,
>   	},
>
> @@ -2009,10 +1836,11 @@ static struct dvb_usb_device_properties su3000_properties = {
>   	.identify_state	= su3000_identify_state,
>   	.i2c_algo = &su3000_i2c_algo,
>
> -	.rc.legacy = {
> -		.rc_map_table = rc_map_su3000_table,
> -		.rc_map_size = ARRAY_SIZE(rc_map_su3000_table),
> +	.rc.core = {
>   		.rc_interval = 150,
> +		.rc_codes = RC_MAP_SU3000,
> +		.module_name = "dw2102",
> +		.allowed_protos   = RC_TYPE_NEC,
>   		.rc_query = dw2102_rc_query,
>   	},
>
> @@ -2073,10 +1901,11 @@ static struct dvb_usb_device_properties t220_properties = {
>   	.identify_state	= su3000_identify_state,
>   	.i2c_algo = &su3000_i2c_algo,
>
> -	.rc.legacy = {
> -		.rc_map_table = rc_map_su3000_table,
> -		.rc_map_size = ARRAY_SIZE(rc_map_su3000_table),
> +	.rc.core = {
>   		.rc_interval = 150,
> +		.rc_codes = RC_MAP_SU3000,
> +		.module_name = "dw2102",
> +		.allowed_protos   = RC_TYPE_NEC,
>   		.rc_query = dw2102_rc_query,
>   	},
>
> @@ -2123,8 +1952,8 @@ static int dw2102_probe(struct usb_interface *intf,
>   	/* fill only different fields */
>   	p1100->firmware = P1100_FIRMWARE;
>   	p1100->devices[0] = d1100;
> -	p1100->rc.legacy.rc_map_table = rc_map_tbs_table;
> -	p1100->rc.legacy.rc_map_size = ARRAY_SIZE(rc_map_tbs_table);
> +	p1100->rc.core.rc_query = prof_rc_query;
> +	p1100->rc.core.rc_codes = RC_MAP_TBS_NEC;
>   	p1100->adapter->fe[0].frontend_attach = stv0288_frontend_attach;
>
>   	s660 = kmemdup(&s6x0_properties,
> @@ -2149,8 +1978,8 @@ static int dw2102_probe(struct usb_interface *intf,
>   	}
>   	p7500->firmware = P7500_FIRMWARE;
>   	p7500->devices[0] = d7500;
> -	p7500->rc.legacy.rc_map_table = rc_map_tbs_table;
> -	p7500->rc.legacy.rc_map_size = ARRAY_SIZE(rc_map_tbs_table);
> +	p7500->rc.core.rc_query = prof_rc_query;
> +	p7500->rc.core.rc_codes = RC_MAP_TBS_NEC;
>   	p7500->adapter->fe[0].frontend_attach = prof_7500_frontend_attach;
>
>
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 6628f5d..a20ed97 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -193,6 +193,7 @@ void rc_map_init(void);
>   #define RC_MAP_VIDEOMATE_TV_PVR          "rc-videomate-tv-pvr"
>   #define RC_MAP_WINFAST                   "rc-winfast"
>   #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
> +#define RC_MAP_SU3000                    "rc-su3000"
>
>   /*
>    * Please, do not just append newer Remote Controller names at the end.
>


-- 
http://palosaari.fi/
