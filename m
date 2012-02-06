Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:39981 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab2BFRGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2012 12:06:54 -0500
Received: by wgbgn7 with SMTP id gn7so3448916wgb.1
        for <linux-media@vger.kernel.org>; Mon, 06 Feb 2012 09:06:53 -0800 (PST)
Message-ID: <1328548004.2331.15.camel@tvbox>
Subject: Re: [PATCH 2/2] IT913X Version 1 and Version 2 keymaps
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Mon, 06 Feb 2012 17:06:44 +0000
In-Reply-To: <4F2FCAAD.3070706@iki.fi>
References: <1328135384.2552.20.camel@tvbox> <4F2FCAAD.3070706@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2012-02-06 at 14:42 +0200, Antti Palosaari wrote:
> On 02/02/2012 12:29 AM, Malcolm Priestley wrote:
> > IT913X V1 V2 keymaps
> >
> > Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
> >
> > ---
> >   drivers/media/rc/keymaps/Makefile       |    2 +
> >   drivers/media/rc/keymaps/rc-it913x-v1.c |   95 +++++++++++++++++++++++++++++++
> >   drivers/media/rc/keymaps/rc-it913x-v2.c |   94 ++++++++++++++++++++++++++++++
> >   include/media/rc-map.h                  |    2 +
> >   4 files changed, 193 insertions(+), 0 deletions(-)
> >   create mode 100644 drivers/media/rc/keymaps/rc-it913x-v1.c
> >   create mode 100644 drivers/media/rc/keymaps/rc-it913x-v2.c
> >
> > diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> > index 36e4d5e..9514d82 100644
> > --- a/drivers/media/rc/keymaps/Makefile
> > +++ b/drivers/media/rc/keymaps/Makefile
> > @@ -41,6 +41,8 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
> >   			rc-imon-mce.o \
> >   			rc-imon-pad.o \
> >   			rc-iodata-bctv7e.o \
> > +			rc-it913x-v1.o \
> > +			rc-it913x-v2.o \
> >   			rc-kaiomy.o \
> >   			rc-kworld-315u.o \
> >   			rc-kworld-plus-tv-analog.o \
> > diff --git a/drivers/media/rc/keymaps/rc-it913x-v1.c b/drivers/media/rc/keymaps/rc-it913x-v1.c
> > new file mode 100644
> > index 0000000..0ac775f
> > --- /dev/null
> > +++ b/drivers/media/rc/keymaps/rc-it913x-v1.c
> > @@ -0,0 +1,95 @@
> > +/* ITE Generic remotes Version 1
> > + *
> > + * Copyright (C) 2012 Malcolm Priestley (tvboxspy@gmail.com)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include<media/rc-map.h>
> > +#include<linux/module.h>
> > +
> > +
> > +static struct rc_map_table it913x_v1_rc[] = {
> > +	/* Type 1 */
> > +	{ 0x61d601, KEY_VIDEO },           /* Source */
> > +	{ 0x61d602, KEY_3 },
> > +	{ 0x61d603, KEY_POWER },           /* ShutDown */
> > +	{ 0x61d604, KEY_1 },
> > +	{ 0x61d605, KEY_5 },
> > +	{ 0x61d606, KEY_6 },
> > +	{ 0x61d607, KEY_CHANNELDOWN },     /* CH- */
> > +	{ 0x61d608, KEY_2 },
> > +	{ 0x61d609, KEY_CHANNELUP },       /* CH+ */
> > +	{ 0x61d60a, KEY_9 },
> > +	{ 0x61d60b, KEY_ZOOM },            /* Zoom */
> > +	{ 0x61d60c, KEY_7 },
> > +	{ 0x61d60d, KEY_8 },
> > +	{ 0x61d60e, KEY_VOLUMEUP },        /* Vol+ */
> > +	{ 0x61d60f, KEY_4 },
> > +	{ 0x61d610, KEY_ESC },             /* [back up arrow] */
> > +	{ 0x61d611, KEY_0 },
> > +	{ 0x61d612, KEY_OK },              /* [enter arrow] */
> > +	{ 0x61d613, KEY_VOLUMEDOWN },      /* Vol- */
> > +	{ 0x61d614, KEY_RECORD },          /* Rec */
> > +	{ 0x61d615, KEY_STOP },            /* Stop */
> > +	{ 0x61d616, KEY_PLAY },            /* Play */
> > +	{ 0x61d617, KEY_MUTE },            /* Mute */
> > +	{ 0x61d618, KEY_UP },
> > +	{ 0x61d619, KEY_DOWN },
> > +	{ 0x61d61a, KEY_LEFT },
> > +	{ 0x61d61b, KEY_RIGHT },
> > +	{ 0x61d61c, KEY_RED },
> > +	{ 0x61d61d, KEY_GREEN },
> > +	{ 0x61d61e, KEY_YELLOW },
> > +	{ 0x61d61f, KEY_BLUE },
> > +	{ 0x61d643, KEY_POWER2 },          /* [red power button] */
> 
> That remote is already there. Use existing remote instead of adding new 
> one with different name. It is RC_MAP_MSI_DIGIVOX_III
> 
The driver originally used this map.

RC_MAP_MSI_DIGIVOX_III and RC_MAP_KWORLD_315U also are the same map.

> 
> > +	/* Type 2 - 20 buttons */
> > +	{ 0x807f0d, KEY_0 },
> > +	{ 0x807f04, KEY_1 },
> > +	{ 0x807f05, KEY_2 },
> > +	{ 0x807f06, KEY_3 },
> > +	{ 0x807f07, KEY_4 },
> > +	{ 0x807f08, KEY_5 },
> > +	{ 0x807f09, KEY_6 },
> > +	{ 0x807f0a, KEY_7 },
> > +	{ 0x807f1b, KEY_8 },
> > +	{ 0x807f1f, KEY_9 },
> > +	{ 0x807f12, KEY_POWER },
> > +	{ 0x807f01, KEY_MEDIA_REPEAT}, /* Recall */
> > +	{ 0x807f19, KEY_PAUSE }, /* Timeshift */
> > +	{ 0x807f1e, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
> > +	{ 0x807f03, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
> > +	{ 0x807f1a, KEY_CHANNELUP },
> > +	{ 0x807f02, KEY_CHANNELDOWN },
> > +	{ 0x807f0c, KEY_ZOOM },
> > +	{ 0x807f00, KEY_RECORD },
> > +	{ 0x807f0e, KEY_STOP },
> 
> That is NEC basic - 16 bit, not 24 bit. That remote seems to be here 
> also. It is RC_MAP_TERRATEC_SLIM_2. Use existing instead of define new.
> 

All ITE NEC remotes are 32bit with 0xff00 mask. However, they are
modified to 24 bit or 16 bit.

The both maps need to merged because they share the same product ID.


> > +};
> > +
> > +static struct rc_map_list it913x_v1_map = {
> > +	.map = {
> > +		.scan    = it913x_v1_rc,
> > +		.size    = ARRAY_SIZE(it913x_v1_rc),
> > +		.rc_type = RC_TYPE_NEC,
> > +		.name    = RC_MAP_IT913X_V1,
> > +	}
> > +};
> > +
> > +static int __init init_rc_it913x_v1_map(void)
> > +{
> > +	return rc_map_register(&it913x_v1_map);
> > +}
> > +
> > +static void __exit exit_rc_it913x_v1_map(void)
> > +{
> > +	rc_map_unregister(&it913x_v1_map);
> > +}
> > +
> > +module_init(init_rc_it913x_v1_map)
> > +module_exit(exit_rc_it913x_v1_map)
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
> > diff --git a/drivers/media/rc/keymaps/rc-it913x-v2.c b/drivers/media/rc/keymaps/rc-it913x-v2.c
> > new file mode 100644
> > index 0000000..28e376e
> > --- /dev/null
> > +++ b/drivers/media/rc/keymaps/rc-it913x-v2.c
> > @@ -0,0 +1,94 @@
> > +/* ITE Generic remotes Version 2
> > + *
> > + * Copyright (C) 2012 Malcolm Priestley (tvboxspy@gmail.com)
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include<media/rc-map.h>
> > +#include<linux/module.h>
> > +
> > +
> > +static struct rc_map_table it913x_v2_rc[] = {
> > +	/* Type 1 */
> > +	/* 9005 remote */
> > +	{ 0x807f12, KEY_POWER2 },	/* Power (RED POWER BUTTON)*/
> > +	{ 0x807f1a, KEY_VIDEO },	/* Source */
> > +	{ 0x807f1e, KEY_MUTE },		/* Mute */
> > +	{ 0x807f01, KEY_RECORD },	/* Record */
> > +	{ 0x807f02, KEY_CHANNELUP },	/* Channel+ */
> > +	{ 0x807f03, KEY_TIME },		/* TimeShift */
> > +	{ 0x807f04, KEY_VOLUMEUP },	/* Volume- */
> > +	{ 0x807f05, KEY_SCREEN },	/* FullScreen */
> > +	{ 0x807f06, KEY_VOLUMEDOWN },	/* Volume- */
> > +	{ 0x807f07, KEY_0 },		/* 0 */
> > +	{ 0x807f08, KEY_CHANNELDOWN },	/* Channel- */
> > +	{ 0x807f09, KEY_PREVIOUS },	/* Recall */
> > +	{ 0x807f0a, KEY_1 },		/* 1 */
> > +	{ 0x807f1b, KEY_2 },		/* 2 */
> > +	{ 0x807f1f, KEY_3 },		/* 3 */
> > +	{ 0x807f0c, KEY_4 },		/* 4 */
> > +	{ 0x807f0d, KEY_5 },		/* 5 */
> > +	{ 0x807f0e, KEY_6 },		/* 6 */
> > +	{ 0x807f00, KEY_7 },		/* 7 */
> > +	{ 0x807f0f, KEY_8 },		/* 8 */
> > +	{ 0x807f19, KEY_9 },		/* 9 */
> 
> That is also 16 bit NEC basic.
> 
This is a different map.

All the maps will soon need to be 32bit, HID type interfaces need the
32bit map uploaded.


Regards


Malcolm

> > +
> > +	/* Type 2 */
> > +	/* keys stereo, snapshot unassigned */
> > +	{ 0x866b00, KEY_0 },
> > +	{ 0x866b1b, KEY_1 },
> > +	{ 0x866b02, KEY_2 },
> > +	{ 0x866b03, KEY_3 },
> > +	{ 0x866b04, KEY_4 },
> > +	{ 0x866b05, KEY_5 },
> > +	{ 0x866b06, KEY_6 },
> > +	{ 0x866b07, KEY_7 },
> > +	{ 0x866b08, KEY_8 },
> > +	{ 0x866b09, KEY_9 },
> > +	{ 0x866b12, KEY_POWER },
> > +	{ 0x866b13, KEY_MUTE },
> > +	{ 0x866b0a, KEY_PREVIOUS }, /* Recall */
> > +	{ 0x866b1e, KEY_PAUSE },
> > +	{ 0x866b0c, KEY_VOLUMEUP },
> > +	{ 0x866b18, KEY_VOLUMEDOWN },
> > +	{ 0x866b0b, KEY_CHANNELUP },
> > +	{ 0x866b18, KEY_CHANNELDOWN },
> > +	{ 0x866b10, KEY_ZOOM },
> > +	{ 0x866b1d, KEY_RECORD },
> > +	{ 0x866b0e, KEY_STOP },
> > +	{ 0x866b11, KEY_EPG},
> > +	{ 0x866b1a, KEY_FASTFORWARD },
> > +	{ 0x866b0f, KEY_REWIND },
> > +	{ 0x866b1c, KEY_TV },
> > +	{ 0x866b1b, KEY_TEXT },
> > +
> > +};
> > +
> > +static struct rc_map_list it913x_v2_map = {
> > +	.map = {
> > +		.scan    = it913x_v2_rc,
> > +		.size    = ARRAY_SIZE(it913x_v2_rc),
> > +		.rc_type = RC_TYPE_NEC,
> > +		.name    = RC_MAP_IT913X_V2,
> > +	}
> > +};
> > +
> > +static int __init init_rc_it913x_v2_map(void)
> > +{
> > +	return rc_map_register(&it913x_v2_map);
> > +}
> > +
> > +static void __exit exit_rc_it913x_v2_map(void)
> > +{
> > +	rc_map_unregister(&it913x_v2_map);
> > +}
> > +
> > +module_init(init_rc_it913x_v2_map)
> > +module_exit(exit_rc_it913x_v2_map)
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Malcolm Priestley tvboxspy@gmail.com");
> > diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> > index f688bde..5b988d7 100644
> > --- a/include/media/rc-map.h
> > +++ b/include/media/rc-map.h
> > @@ -102,6 +102,8 @@ void rc_map_init(void);
> >   #define RC_MAP_IMON_MCE                  "rc-imon-mce"
> >   #define RC_MAP_IMON_PAD                  "rc-imon-pad"
> >   #define RC_MAP_IODATA_BCTV7E             "rc-iodata-bctv7e"
> > +#define RC_MAP_IT913X_V1                 "rc-it913x-v1"
> > +#define RC_MAP_IT913X_V2                 "rc-it913x-v2"
> >   #define RC_MAP_KAIOMY                    "rc-kaiomy"
> >   #define RC_MAP_KWORLD_315U               "rc-kworld-315u"
> >   #define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
> 
> 
> regards
> Antti
> 


