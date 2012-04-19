Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab2DSSQk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 14:16:40 -0400
Message-ID: <4F905684.2010200@redhat.com>
Date: Thu, 19 Apr 2012 15:16:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/6] m88ds3103, dvbsky remote control key map.
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com> <201204152353469213327@gmail.com>
In-Reply-To: <201204152353469213327@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-04-2012 12:53, nibble.max escreveu:
> dvbsky remote control key map for pci/pcie card.
> 
> Signed-off-by: Max nibble <nibble.max@gmail.com>
> ---
>  drivers/media/rc/keymaps/Makefile    |    1 +
>  drivers/media/rc/keymaps/rc-dvbsky.c |   78 ++++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
>  create mode 100644 drivers/media/rc/keymaps/rc-dvbsky.c
> 
> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> index 49ce266..e6a882b 100644
> --- a/drivers/media/rc/keymaps/Makefile
> +++ b/drivers/media/rc/keymaps/Makefile
> @@ -26,6 +26,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>  			rc-dm1105-nec.o \
>  			rc-dntv-live-dvb-t.o \
>  			rc-dntv-live-dvbt-pro.o \
> +			rc-dvbsky.o \
>  			rc-em-terratec.o \
>  			rc-encore-enltv2.o \
>  			rc-encore-enltv.o \
> diff --git a/drivers/media/rc/keymaps/rc-dvbsky.c b/drivers/media/rc/keymaps/rc-dvbsky.c
> new file mode 100644
> index 0000000..2bd9977
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-dvbsky.c
> @@ -0,0 +1,78 @@
> +/* rc-dvbsky.c - Keytable for Dvbsky Remote Controllers
> + *
> + * keymap imported from ir-keymaps.c

No, you didn't import it from ir-keymaps.c ;) This is the old file where several
keymaps used to be stored.

> + *
> + *
> + * Copyright (c) 2010-2011 by Mauro Carvalho Chehab <mchehab@redhat.com>

Huh? I didn't wrote this keymap.

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <media/rc-map.h>
> +#include <linux/module.h>
> +/*
> + * This table contains the complete RC5 code, instead of just the data part
> + */
> +
> +static struct rc_map_table rc5_dvbsky[] = {
> +	{ 0x0000, KEY_0 },
> +	{ 0x0001, KEY_1 },
> +	{ 0x0002, KEY_2 },
> +	{ 0x0003, KEY_3 },
> +	{ 0x0004, KEY_4 },
> +	{ 0x0005, KEY_5 },
> +	{ 0x0006, KEY_6 },
> +	{ 0x0007, KEY_7 },
> +	{ 0x0008, KEY_8 },
> +	{ 0x0009, KEY_9 },	
> +	{ 0x000a, KEY_MUTE },
> +	{ 0x000d, KEY_OK },
> +	{ 0x000b, KEY_STOP },
> +	{ 0x000c, KEY_EXIT },	
> +	{ 0x000e, KEY_CAMERA }, /*Snap shot*/
> +	{ 0x000f, KEY_SUBTITLE }, /*PIP*/
> +	{ 0x0010, KEY_VOLUMEUP },
> +	{ 0x0011, KEY_VOLUMEDOWN },
> +	{ 0x0012, KEY_FAVORITES },
> +	{ 0x0013, KEY_LIST }, /*Info*/
> +	{ 0x0016, KEY_PAUSE },
> +	{ 0x0017, KEY_PLAY },
> +	{ 0x001f, KEY_RECORD },
> +	{ 0x0020, KEY_CHANNELDOWN },
> +	{ 0x0021, KEY_CHANNELUP },
> +	{ 0x0025, KEY_POWER2 },
> +	{ 0x0026, KEY_REWIND },
> +	{ 0x0027, KEY_FASTFORWARD },
> +	{ 0x0029, KEY_LAST },
> +	{ 0x002b, KEY_MENU },	
> +	{ 0x002c, KEY_EPG },
> +	{ 0x002d, KEY_ZOOM },	

Hmm... are you sure that your IR getkey function is right? 
There are a few RC-5 IR's that uses only 6 bits, but this is not
common. I suspect that your code is missing the higher bits.

It would be nice if you could test it with another RC5 IR, or
to test your RC-5 with some other IR receiver, in order to double
check it.

> +};
> +
> +static struct rc_map_list rc5_dvbsky_map = {
> +	.map = {
> +		.scan    = rc5_dvbsky,
> +		.size    = ARRAY_SIZE(rc5_dvbsky),
> +		.rc_type = RC_TYPE_RC5,
> +		.name    = RC_MAP_DVBSKY,
> +	}
> +};
> +
> +static int __init init_rc_map_rc5_dvbsky(void)
> +{
> +	return rc_map_register(&rc5_dvbsky_map);
> +}
> +
> +static void __exit exit_rc_map_rc5_dvbsky(void)
> +{
> +	rc_map_unregister(&rc5_dvbsky_map);
> +}
> +
> +module_init(init_rc_map_rc5_dvbsky)
> +module_exit(exit_rc_map_rc5_dvbsky)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");

Again, I didn't write it. You did ;)

Regards,
Mauro


