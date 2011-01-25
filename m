Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:5269 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242Ab1AYAWw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jan 2011 19:22:52 -0500
Subject: Re: [PATCH 12/13] [media] rc/keymaps: Rename Hauppauge table as
 rc-hauppauge
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <20110124131847.59882afe@pedra>
References: <cover.1295882104.git.mchehab@redhat.com>
	 <20110124131847.59882afe@pedra>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 19:22:39 -0500
Message-ID: <1295914959.2420.38.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-01-24 at 13:18 -0200, Mauro Carvalho Chehab wrote:
> There are two "hauppauge-new" keymaps, one with protocol
> unknown, and the other with the protocol marked accordingly.
> However, both tables are miss-named.
> 
> Also, the old rc-hauppauge-new is broken, as it mixes
> three different controllers as if they were just one.
> 
> This patch solves half of the problem by renaming the
> correct keycode table as just rc-hauppauge. This table
> contains the codes for the four different types of
> remote controllers found on Hauppauge cards, properly
> mapped with their different addresses.

Are you sure about doing this?

The problem is that the old black Hauppauge remote is using the same
RC-5 address as a common RC-5 TV remote: address 0x00.

See the table at the bottom of:
	http://www.sbprojects.com/knowledge/ir/rc5.htm

IMO, RC-5 address 0x00 is not an address that every Hauppauge card
should be responding to by default.

I'm not too concerned with addresses 0x1d, 0x1e, and 0x1f colliding with
other consumer electronics remotes.

Regards,
Andy

> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  create mode 100644 drivers/media/rc/keymaps/rc-hauppauge.c
>  delete mode 100644 drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
> 
> diff --git a/drivers/media/dvb/siano/sms-cards.c b/drivers/media/dvb/siano/sms-cards.c
> index 25b43e5..af121db 100644
> --- a/drivers/media/dvb/siano/sms-cards.c
> +++ b/drivers/media/dvb/siano/sms-cards.c
> @@ -64,7 +64,7 @@ static struct sms_board sms_boards[] = {
>  		.type	= SMS_NOVA_B0,
>  		.fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
>  		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
> -		.rc_codes = RC_MAP_RC5_HAUPPAUGE_NEW,
> +		.rc_codes = RC_MAP_HAUPPAUGE,
>  		.board_cfg.leds_power = 26,
>  		.board_cfg.led0 = 27,
>  		.board_cfg.led1 = 28,
> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> index f0c8055..c79e192 100644
> --- a/drivers/media/rc/keymaps/Makefile
> +++ b/drivers/media/rc/keymaps/Makefile
> @@ -68,7 +68,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>  			rc-proteus-2309.o \
>  			rc-purpletv.o \
>  			rc-pv951.o \
> -			rc-rc5-hauppauge-new.o \
> +			rc-hauppauge.o \
>  			rc-rc5-tv.o \
>  			rc-rc6-mce.o \
>  			rc-real-audio-220-32-keys.o \
> diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
> new file mode 100644
> index 0000000..66e0498
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-hauppauge.c
> @@ -0,0 +1,241 @@
> +/* rc-hauppauge.h - Keytable for Hauppauge Remote Controllers
> + *
> + * keymap imported from ir-keymaps.c
> + *
> + * This map currently contains the code for four different RCs:
> + *	- New Hauppauge Gray;
> + *	- Old Hauppauge Gray (with a golden screen for media keys);
> + *	- Hauppauge Black;
> + *	- DSR-0112 remote bundled with Haupauge MiniStick.
> + *
> + * Copyright (c) 2010-2011 by Mauro Carvalho Chehab <mchehab@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <media/rc-map.h>
> +
> +/*
> + * Hauppauge:the newer, gray remotes (seems there are multiple
> + * slightly different versions), shipped with cx88+ivtv cards.
> + *
> + * This table contains the complete RC5 code, instead of just the data part
> + */
> +
> +static struct rc_map_table rc5_hauppauge_new[] = {
> +	/*
> +	 * Remote Controller Hauppauge Gray found on modern devices
> +	 * Keycodes start with address = 0x1e
> +	 */
> +
> +	{ 0x1e3b, KEY_SELECT },		/* GO / house symbol */
> +	{ 0x1e3d, KEY_POWER2 },		/* system power (green button) */
> +
> +	{ 0x1e1c, KEY_TV },
> +	{ 0x1e18, KEY_VIDEO },		/* Videos */
> +	{ 0x1e19, KEY_AUDIO },		/* Music */
> +	{ 0x1e1a, KEY_CAMERA },		/* Pictures */
> +
> +	{ 0x1e1b, KEY_EPG },		/* Guide */
> +	{ 0x1e0c, KEY_RADIO },
> +
> +	{ 0x1e14, KEY_UP },
> +	{ 0x1e15, KEY_DOWN },
> +	{ 0x1e16, KEY_LEFT },
> +	{ 0x1e17, KEY_RIGHT },
> +	{ 0x1e25, KEY_OK },		/* OK */
> +
> +	{ 0x1e1f, KEY_EXIT },		/* back/exit */
> +	{ 0x1e0d, KEY_MENU },
> +
> +	{ 0x1e10, KEY_VOLUMEUP },
> +	{ 0x1e11, KEY_VOLUMEDOWN },
> +
> +	{ 0x1e12, KEY_PREVIOUS },	/* previous channel */
> +	{ 0x1e0f, KEY_MUTE },
> +
> +	{ 0x1e20, KEY_CHANNELUP },	/* channel / program + */
> +	{ 0x1e21, KEY_CHANNELDOWN },	/* channel / program - */
> +
> +	{ 0x1e37, KEY_RECORD },		/* recording */
> +	{ 0x1e36, KEY_STOP },
> +
> +	{ 0x1e32, KEY_REWIND },		/* backward << */
> +	{ 0x1e35, KEY_PLAY },
> +	{ 0x1e34, KEY_FASTFORWARD },	/* forward >> */
> +
> +	{ 0x1e24, KEY_PREVIOUSSONG },	/* replay |< */
> +	{ 0x1e30, KEY_PAUSE },		/* pause */
> +	{ 0x1e1e, KEY_NEXTSONG },	/* skip >| */
> +
> +	{ 0x1e01, KEY_1 },
> +	{ 0x1e02, KEY_2 },
> +	{ 0x1e03, KEY_3 },
> +
> +	{ 0x1e04, KEY_4 },
> +	{ 0x1e05, KEY_5 },
> +	{ 0x1e06, KEY_6 },
> +
> +	{ 0x1e07, KEY_7 },
> +	{ 0x1e08, KEY_8 },
> +	{ 0x1e09, KEY_9 },
> +
> +	{ 0x1e0a, KEY_TEXT },		/* keypad asterisk as well */
> +	{ 0x1e00, KEY_0 },
> +	{ 0x1e0e, KEY_SUBTITLE },	/* also the Pound key (#) */
> +
> +	{ 0x1e0b, KEY_RED },		/* red button */
> +	{ 0x1e2e, KEY_GREEN },		/* green button */
> +	{ 0x1e38, KEY_YELLOW },		/* yellow key */
> +	{ 0x1e29, KEY_BLUE },		/* blue key */
> +
> +	/*
> +	 * Old Remote Controller Hauppauge Gray with a golden screen
> +	 * Keycodes start with address = 0x1f
> +	 */
> +	{ 0x1f3d, KEY_POWER2 },		/* system power (green button) */
> +	{ 0x1f3b, KEY_SELECT },		/* GO */
> +
> +	/* Keys 0 to 9 */
> +	{ 0x1f00, KEY_0 },
> +	{ 0x1f01, KEY_1 },
> +	{ 0x1f02, KEY_2 },
> +	{ 0x1f03, KEY_3 },
> +	{ 0x1f04, KEY_4 },
> +	{ 0x1f05, KEY_5 },
> +	{ 0x1f06, KEY_6 },
> +	{ 0x1f07, KEY_7 },
> +	{ 0x1f08, KEY_8 },
> +	{ 0x1f09, KEY_9 },
> +
> +	{ 0x1f1f, KEY_EXIT },		/* back/exit */
> +	{ 0x1f0d, KEY_MENU },
> +
> +	{ 0x1f10, KEY_VOLUMEUP },
> +	{ 0x1f11, KEY_VOLUMEDOWN },
> +	{ 0x1f20, KEY_CHANNELUP },	/* channel / program + */
> +	{ 0x1f21, KEY_CHANNELDOWN },	/* channel / program - */
> +	{ 0x1f25, KEY_ENTER },		/* OK */
> +
> +	{ 0x1f0b, KEY_RED },		/* red button */
> +	{ 0x1f2e, KEY_GREEN },		/* green button */
> +	{ 0x1f38, KEY_YELLOW },		/* yellow key */
> +	{ 0x1f29, KEY_BLUE },		/* blue key */
> +
> +	{ 0x1f0f, KEY_MUTE },
> +	{ 0x1f0c, KEY_RADIO },		/* There's no indicator on this key */
> +	{ 0x1f3c, KEY_ZOOM },		/* full */
> +
> +	{ 0x1f32, KEY_REWIND },		/* backward << */
> +	{ 0x1f35, KEY_PLAY },
> +	{ 0x1f34, KEY_FASTFORWARD },	/* forward >> */
> +
> +	{ 0x1f37, KEY_RECORD },		/* recording */
> +	{ 0x1f36, KEY_STOP },
> +	{ 0x1f30, KEY_PAUSE },		/* pause */
> +
> +	{ 0x1f24, KEY_PREVIOUSSONG },	/* replay |< */
> +	{ 0x1f1e, KEY_NEXTSONG },	/* skip >| */
> +
> +	/*
> +	 * Keycodes for DSR-0112 remote bundled with Haupauge MiniStick
> +	 * Keycodes start with address = 0x1d
> +	 */
> +	{ 0x1d00, KEY_0 },
> +	{ 0x1d01, KEY_1 },
> +	{ 0x1d02, KEY_2 },
> +	{ 0x1d03, KEY_3 },
> +	{ 0x1d04, KEY_4 },
> +	{ 0x1d05, KEY_5 },
> +	{ 0x1d06, KEY_6 },
> +	{ 0x1d07, KEY_7 },
> +	{ 0x1d08, KEY_8 },
> +	{ 0x1d09, KEY_9 },
> +	{ 0x1d0a, KEY_TEXT },
> +	{ 0x1d0d, KEY_MENU },
> +	{ 0x1d0f, KEY_MUTE },
> +	{ 0x1d10, KEY_VOLUMEUP },
> +	{ 0x1d11, KEY_VOLUMEDOWN },
> +	{ 0x1d12, KEY_PREVIOUS },        /* Prev.Ch .. ??? */
> +	{ 0x1d14, KEY_UP },
> +	{ 0x1d15, KEY_DOWN },
> +	{ 0x1d16, KEY_LEFT },
> +	{ 0x1d17, KEY_RIGHT },
> +	{ 0x1d1c, KEY_TV },
> +	{ 0x1d1e, KEY_NEXT },           /* >|             */
> +	{ 0x1d1f, KEY_EXIT },
> +	{ 0x1d20, KEY_CHANNELUP },
> +	{ 0x1d21, KEY_CHANNELDOWN },
> +	{ 0x1d24, KEY_LAST },           /* <|             */
> +	{ 0x1d25, KEY_OK },
> +	{ 0x1d30, KEY_PAUSE },
> +	{ 0x1d32, KEY_REWIND },
> +	{ 0x1d34, KEY_FASTFORWARD },
> +	{ 0x1d35, KEY_PLAY },
> +	{ 0x1d36, KEY_STOP },
> +	{ 0x1d37, KEY_RECORD },
> +	{ 0x1d3b, KEY_GOTO },
> +	{ 0x1d3d, KEY_POWER },
> +	{ 0x1d3f, KEY_HOME },
> +
> +	/*
> +	 * Keycodes for the old Black Remote Controller
> +	 * This one also uses RC-5 protocol
> +	 * Keycodes start with address = 0x00
> +	 */
> +	{ 0x001f, KEY_TV },
> +	{ 0x0020, KEY_CHANNELUP },
> +	{ 0x000c, KEY_RADIO },
> +
> +	{ 0x0011, KEY_VOLUMEDOWN },
> +	{ 0x002e, KEY_ZOOM },		/* full screen */
> +	{ 0x0010, KEY_VOLUMEUP },
> +
> +	{ 0x000d, KEY_MUTE },
> +	{ 0x0021, KEY_CHANNELDOWN },
> +	{ 0x0022, KEY_VIDEO },		/* source */
> +
> +	{ 0x0001, KEY_1 },
> +	{ 0x0002, KEY_2 },
> +	{ 0x0003, KEY_3 },
> +
> +	{ 0x0004, KEY_4 },
> +	{ 0x0005, KEY_5 },
> +	{ 0x0006, KEY_6 },
> +
> +	{ 0x0007, KEY_7 },
> +	{ 0x0008, KEY_8 },
> +	{ 0x0009, KEY_9 },
> +
> +	{ 0x001e, KEY_RED },	/* Reserved */
> +	{ 0x0000, KEY_0 },
> +	{ 0x0026, KEY_SLEEP },	/* Minimize */
> +};
> +
> +static struct rc_map_list rc5_hauppauge_new_map = {
> +	.map = {
> +		.scan    = rc5_hauppauge_new,
> +		.size    = ARRAY_SIZE(rc5_hauppauge_new),
> +		.rc_type = RC_TYPE_RC5,
> +		.name    = RC_MAP_HAUPPAUGE,
> +	}
> +};
> +
> +static int __init init_rc_map_rc5_hauppauge_new(void)
> +{
> +	return rc_map_register(&rc5_hauppauge_new_map);
> +}
> +
> +static void __exit exit_rc_map_rc5_hauppauge_new(void)
> +{
> +	rc_map_unregister(&rc5_hauppauge_new_map);
> +}
> +
> +module_init(init_rc_map_rc5_hauppauge_new)
> +module_exit(exit_rc_map_rc5_hauppauge_new)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
> deleted file mode 100644
> index cb312da..0000000
> --- a/drivers/media/rc/keymaps/rc-rc5-hauppauge-new.c
> +++ /dev/null
> @@ -1,235 +0,0 @@
> -/* rc5-hauppauge-new.h - Keytable for rc5_hauppauge_new Remote Controller
> - *
> - * keymap imported from ir-keymaps.c
> - *
> - * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#include <media/rc-map.h>
> -
> -/*
> - * Hauppauge:the newer, gray remotes (seems there are multiple
> - * slightly different versions), shipped with cx88+ivtv cards.
> - *
> - * This table contains the complete RC5 code, instead of just the data part
> - */
> -
> -static struct rc_map_table rc5_hauppauge_new[] = {
> -	/*
> -	 * Remote Controller Hauppauge Gray found on modern devices
> -	 * Keycodes start with address = 0x1e
> -	 */
> -
> -	{ 0x1e3b, KEY_SELECT },		/* GO / house symbol */
> -	{ 0x1e3d, KEY_POWER2 },		/* system power (green button) */
> -
> -	{ 0x1e1c, KEY_TV },
> -	{ 0x1e18, KEY_VIDEO },		/* Videos */
> -	{ 0x1e19, KEY_AUDIO },		/* Music */
> -	{ 0x1e1a, KEY_CAMERA },		/* Pictures */
> -
> -	{ 0x1e1b, KEY_EPG },		/* Guide */
> -	{ 0x1e0c, KEY_RADIO },
> -
> -	{ 0x1e14, KEY_UP },
> -	{ 0x1e15, KEY_DOWN },
> -	{ 0x1e16, KEY_LEFT },
> -	{ 0x1e17, KEY_RIGHT },
> -	{ 0x1e25, KEY_OK },		/* OK */
> -
> -	{ 0x1e1f, KEY_EXIT },		/* back/exit */
> -	{ 0x1e0d, KEY_MENU },
> -
> -	{ 0x1e10, KEY_VOLUMEUP },
> -	{ 0x1e11, KEY_VOLUMEDOWN },
> -
> -	{ 0x1e12, KEY_PREVIOUS },	/* previous channel */
> -	{ 0x1e0f, KEY_MUTE },
> -
> -	{ 0x1e20, KEY_CHANNELUP },	/* channel / program + */
> -	{ 0x1e21, KEY_CHANNELDOWN },	/* channel / program - */
> -
> -	{ 0x1e37, KEY_RECORD },		/* recording */
> -	{ 0x1e36, KEY_STOP },
> -
> -	{ 0x1e32, KEY_REWIND },		/* backward << */
> -	{ 0x1e35, KEY_PLAY },
> -	{ 0x1e34, KEY_FASTFORWARD },	/* forward >> */
> -
> -	{ 0x1e24, KEY_PREVIOUSSONG },	/* replay |< */
> -	{ 0x1e30, KEY_PAUSE },		/* pause */
> -	{ 0x1e1e, KEY_NEXTSONG },	/* skip >| */
> -
> -	{ 0x1e01, KEY_1 },
> -	{ 0x1e02, KEY_2 },
> -	{ 0x1e03, KEY_3 },
> -
> -	{ 0x1e04, KEY_4 },
> -	{ 0x1e05, KEY_5 },
> -	{ 0x1e06, KEY_6 },
> -
> -	{ 0x1e07, KEY_7 },
> -	{ 0x1e08, KEY_8 },
> -	{ 0x1e09, KEY_9 },
> -
> -	{ 0x1e0a, KEY_TEXT },		/* keypad asterisk as well */
> -	{ 0x1e00, KEY_0 },
> -	{ 0x1e0e, KEY_SUBTITLE },	/* also the Pound key (#) */
> -
> -	{ 0x1e0b, KEY_RED },		/* red button */
> -	{ 0x1e2e, KEY_GREEN },		/* green button */
> -	{ 0x1e38, KEY_YELLOW },		/* yellow key */
> -	{ 0x1e29, KEY_BLUE },		/* blue key */
> -
> -	/*
> -	 * Old Remote Controller Hauppauge Gray with a golden screen
> -	 * Keycodes start with address = 0x1f
> -	 */
> -	{ 0x1f3d, KEY_POWER2 },		/* system power (green button) */
> -	{ 0x1f3b, KEY_SELECT },		/* GO */
> -
> -	/* Keys 0 to 9 */
> -	{ 0x1f00, KEY_0 },
> -	{ 0x1f01, KEY_1 },
> -	{ 0x1f02, KEY_2 },
> -	{ 0x1f03, KEY_3 },
> -	{ 0x1f04, KEY_4 },
> -	{ 0x1f05, KEY_5 },
> -	{ 0x1f06, KEY_6 },
> -	{ 0x1f07, KEY_7 },
> -	{ 0x1f08, KEY_8 },
> -	{ 0x1f09, KEY_9 },
> -
> -	{ 0x1f1f, KEY_EXIT },		/* back/exit */
> -	{ 0x1f0d, KEY_MENU },
> -
> -	{ 0x1f10, KEY_VOLUMEUP },
> -	{ 0x1f11, KEY_VOLUMEDOWN },
> -	{ 0x1f20, KEY_CHANNELUP },	/* channel / program + */
> -	{ 0x1f21, KEY_CHANNELDOWN },	/* channel / program - */
> -	{ 0x1f25, KEY_ENTER },		/* OK */
> -
> -	{ 0x1f0b, KEY_RED },		/* red button */
> -	{ 0x1f2e, KEY_GREEN },		/* green button */
> -	{ 0x1f38, KEY_YELLOW },		/* yellow key */
> -	{ 0x1f29, KEY_BLUE },		/* blue key */
> -
> -	{ 0x1f0f, KEY_MUTE },
> -	{ 0x1f0c, KEY_RADIO },		/* There's no indicator on this key */
> -	{ 0x1f3c, KEY_ZOOM },		/* full */
> -
> -	{ 0x1f32, KEY_REWIND },		/* backward << */
> -	{ 0x1f35, KEY_PLAY },
> -	{ 0x1f34, KEY_FASTFORWARD },	/* forward >> */
> -
> -	{ 0x1f37, KEY_RECORD },		/* recording */
> -	{ 0x1f36, KEY_STOP },
> -	{ 0x1f30, KEY_PAUSE },		/* pause */
> -
> -	{ 0x1f24, KEY_PREVIOUSSONG },	/* replay |< */
> -	{ 0x1f1e, KEY_NEXTSONG },	/* skip >| */
> -
> -	/*
> -	 * Keycodes for DSR-0112 remote bundled with Haupauge MiniStick
> -	 * Keycodes start with address = 0x1d
> -	 */
> -	{ 0x1d00, KEY_0 },
> -	{ 0x1d01, KEY_1 },
> -	{ 0x1d02, KEY_2 },
> -	{ 0x1d03, KEY_3 },
> -	{ 0x1d04, KEY_4 },
> -	{ 0x1d05, KEY_5 },
> -	{ 0x1d06, KEY_6 },
> -	{ 0x1d07, KEY_7 },
> -	{ 0x1d08, KEY_8 },
> -	{ 0x1d09, KEY_9 },
> -	{ 0x1d0a, KEY_TEXT },
> -	{ 0x1d0d, KEY_MENU },
> -	{ 0x1d0f, KEY_MUTE },
> -	{ 0x1d10, KEY_VOLUMEUP },
> -	{ 0x1d11, KEY_VOLUMEDOWN },
> -	{ 0x1d12, KEY_PREVIOUS },        /* Prev.Ch .. ??? */
> -	{ 0x1d14, KEY_UP },
> -	{ 0x1d15, KEY_DOWN },
> -	{ 0x1d16, KEY_LEFT },
> -	{ 0x1d17, KEY_RIGHT },
> -	{ 0x1d1c, KEY_TV },
> -	{ 0x1d1e, KEY_NEXT },           /* >|             */
> -	{ 0x1d1f, KEY_EXIT },
> -	{ 0x1d20, KEY_CHANNELUP },
> -	{ 0x1d21, KEY_CHANNELDOWN },
> -	{ 0x1d24, KEY_LAST },           /* <|             */
> -	{ 0x1d25, KEY_OK },
> -	{ 0x1d30, KEY_PAUSE },
> -	{ 0x1d32, KEY_REWIND },
> -	{ 0x1d34, KEY_FASTFORWARD },
> -	{ 0x1d35, KEY_PLAY },
> -	{ 0x1d36, KEY_STOP },
> -	{ 0x1d37, KEY_RECORD },
> -	{ 0x1d3b, KEY_GOTO },
> -	{ 0x1d3d, KEY_POWER },
> -	{ 0x1d3f, KEY_HOME },
> -
> -	/*
> -	 * Keycodes for the old Black Remote Controller
> -	 * This one also uses RC-5 protocol
> -	 * Keycodes start with address = 0x00
> -	 */
> -	{ 0x001f, KEY_TV },
> -	{ 0x0020, KEY_CHANNELUP },
> -	{ 0x000c, KEY_RADIO },
> -
> -	{ 0x0011, KEY_VOLUMEDOWN },
> -	{ 0x002e, KEY_ZOOM },		/* full screen */
> -	{ 0x0010, KEY_VOLUMEUP },
> -
> -	{ 0x000d, KEY_MUTE },
> -	{ 0x0021, KEY_CHANNELDOWN },
> -	{ 0x0022, KEY_VIDEO },		/* source */
> -
> -	{ 0x0001, KEY_1 },
> -	{ 0x0002, KEY_2 },
> -	{ 0x0003, KEY_3 },
> -
> -	{ 0x0004, KEY_4 },
> -	{ 0x0005, KEY_5 },
> -	{ 0x0006, KEY_6 },
> -
> -	{ 0x0007, KEY_7 },
> -	{ 0x0008, KEY_8 },
> -	{ 0x0009, KEY_9 },
> -
> -	{ 0x001e, KEY_RED },	/* Reserved */
> -	{ 0x0000, KEY_0 },
> -	{ 0x0026, KEY_SLEEP },	/* Minimize */
> -};
> -
> -static struct rc_map_list rc5_hauppauge_new_map = {
> -	.map = {
> -		.scan    = rc5_hauppauge_new,
> -		.size    = ARRAY_SIZE(rc5_hauppauge_new),
> -		.rc_type = RC_TYPE_RC5,
> -		.name    = RC_MAP_RC5_HAUPPAUGE_NEW,
> -	}
> -};
> -
> -static int __init init_rc_map_rc5_hauppauge_new(void)
> -{
> -	return rc_map_register(&rc5_hauppauge_new_map);
> -}
> -
> -static void __exit exit_rc_map_rc5_hauppauge_new(void)
> -{
> -	rc_map_unregister(&rc5_hauppauge_new_map);
> -}
> -
> -module_init(init_rc_map_rc5_hauppauge_new)
> -module_exit(exit_rc_map_rc5_hauppauge_new)
> -
> -MODULE_LICENSE("GPL");
> -MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 079353e..55827b0 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -185,7 +185,7 @@ static const struct mceusb_model mceusb_model[] = {
>  		 * remotes, but we should have something handy,
>  		 * to allow testing it
>  		 */
> -		.rc_map = RC_MAP_RC5_HAUPPAUGE_NEW,
> +		.rc_map = RC_MAP_HAUPPAUGE,
>  		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
>  	},
>  	[CX_HYBRID_TV] = {
> diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
> index 199b996..e97cafd 100644
> --- a/drivers/media/video/cx23885/cx23885-input.c
> +++ b/drivers/media/video/cx23885/cx23885-input.c
> @@ -264,7 +264,7 @@ int cx23885_input_init(struct cx23885_dev *dev)
>  		driver_type = RC_DRIVER_IR_RAW;
>  		allowed_protos = RC_TYPE_ALL;
>  		/* The grey Hauppauge RC-5 remote */
> -		rc_map = RC_MAP_RC5_HAUPPAUGE_NEW;
> +		rc_map = RC_MAP_HAUPPAUGE;
>  		break;
>  	case CX23885_BOARD_TEVII_S470:
>  		/* Integrated CX23885 IR controller */
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 87f77a3..aa4f45e 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -911,7 +911,7 @@ struct em28xx_board em28xx_boards[] = {
>  		.mts_firmware   = 1,
>  		.has_dvb        = 1,
>  		.dvb_gpio       = hauppauge_wintv_hvr_900_digital,
> -		.ir_codes       = RC_MAP_RC5_HAUPPAUGE_NEW,
> +		.ir_codes       = RC_MAP_HAUPPAUGE,
>  		.decoder        = EM28XX_TVP5150,
>  		.input          = { {
>  			.type     = EM28XX_VMUX_TELEVISION,
> @@ -2430,7 +2430,7 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
>  		dev->init_data.name = "i2c IR (EM28XX Pinnacle PCTV)";
>  		break;
>  	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
> -		dev->init_data.ir_codes = RC_MAP_RC5_HAUPPAUGE_NEW;
> +		dev->init_data.ir_codes = RC_MAP_HAUPPAUGE;
>  		dev->init_data.get_key = em28xx_get_key_em_haup;
>  		dev->init_data.name = "i2c IR (EM2840 Hauppauge)";
>  		break;
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 4617117..9df0e90 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -125,7 +125,7 @@ void rc_map_init(void);
>  #define RC_MAP_PROTEUS_2309              "rc-proteus-2309"
>  #define RC_MAP_PURPLETV                  "rc-purpletv"
>  #define RC_MAP_PV951                     "rc-pv951"
> -#define RC_MAP_RC5_HAUPPAUGE_NEW         "rc-rc5-hauppauge-new"
> +#define RC_MAP_HAUPPAUGE                 "rc-rc5-hauppauge"
>  #define RC_MAP_RC5_TV                    "rc-rc5-tv"
>  #define RC_MAP_RC6_MCE                   "rc-rc6-mce"
>  #define RC_MAP_REAL_AUDIO_220_32_KEYS    "rc-real-audio-220-32-keys"


