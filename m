Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60884 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbbETITh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 04:19:37 -0400
Date: Wed, 20 May 2015 05:19:23 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] [media] rc: lirc is not a protocol or a keymap
Message-ID: <20150520051923.7cefe112@recife.lan>
In-Reply-To: <20150519203442.GB18036@hardeman.nu>
References: <cover.1426801061.git.sean@mess.org>
	<2a2f4281ba60988242c11bdf2fda3243e2dc4467.1426801061.git.sean@mess.org>
	<20150514135123.4ba85dc7@recife.lan>
	<20150519203442.GB18036@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 May 2015 22:34:42 +0200
David Härdeman <david@hardeman.nu> escreveu:

> On Thu, May 14, 2015 at 01:51:23PM -0300, Mauro Carvalho Chehab wrote:
> >Em Thu, 19 Mar 2015 21:50:15 +0000
> >Sean Young <sean@mess.org> escreveu:
> >
> >> Since the lirc bridge is not a decoder we can remove its protocol. The
> >> keymap existed only to select the protocol.
> >
> >This changes the userspace interface, as now it is possible to enable/disable
> >LIRC handling from a given IR via /proc interface.

I guess I meant to say: "as now it is not possible"

> I still like the general idea though. 

Yeah, LIRC is not actually a decoder, so it makes sense to have it
handled differently.

> If we expose the protocol in the
> set/get keymap ioctls, then we need to expose the protocol enum to
> userspace (in which point it will be set in stone)...removing lirc from
> that list before we do that is a worthwhile cleanup IMHO (I have a
> similar patch in my queue).
> 
> I think we should be able to at least not break userspace by still
> accepting (and ignoring) commands to enable/disable lirc.

Well, ignoring is not a good idea, as it still breaks userspace, but
on a more evil way. If one is using this feature, we'll be receiving
bug reports and fixes for it.

> 
> That lirc won't actually be disabled/enabled is (imho) a lesser
> problem...is there any genuine use case for disabling lirc on a
> per-device basis?

People do weird things sometimes. I won't doubt that someone would
be doing that.

In any case, keep supporting disabling LIRC is likely
simple, even if we don't map it internally as a protocol anymore.

> 
> >
> >> 
> >> Signed-off-by: Sean Young <sean@mess.org>
> >> ---
> >>  drivers/media/rc/keymaps/Makefile  |  1 -
> >>  drivers/media/rc/keymaps/rc-lirc.c | 42 --------------------------------------
> >>  drivers/media/rc/rc-main.c         |  1 -
> >>  drivers/media/rc/st_rc.c           |  2 +-
> >>  include/media/rc-map.h             | 42 +++++++++++++++++---------------------
> >>  5 files changed, 20 insertions(+), 68 deletions(-)
> >>  delete mode 100644 drivers/media/rc/keymaps/rc-lirc.c
> >> 
> >> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> >> index abf6079..661cd25 100644
> >> --- a/drivers/media/rc/keymaps/Makefile
> >> +++ b/drivers/media/rc/keymaps/Makefile
> >> @@ -51,7 +51,6 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
> >>  			rc-kworld-pc150u.o \
> >>  			rc-kworld-plus-tv-analog.o \
> >>  			rc-leadtek-y04g0051.o \
> >> -			rc-lirc.o \
> >>  			rc-lme2510.o \
> >>  			rc-manli.o \
> >>  			rc-medion-x10.o \
> >> diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
> >> deleted file mode 100644
> >> index fbf08fa..0000000
> >> --- a/drivers/media/rc/keymaps/rc-lirc.c
> >> +++ /dev/null
> >> @@ -1,42 +0,0 @@
> >> -/* rc-lirc.c - Empty dummy keytable, for use when its preferred to pass
> >> - * all raw IR data to the lirc userspace decoder.
> >> - *
> >> - * Copyright (c) 2010 by Jarod Wilson <jarod@redhat.com>
> >> - *
> >> - * This program is free software; you can redistribute it and/or modify
> >> - * it under the terms of the GNU General Public License as published by
> >> - * the Free Software Foundation; either version 2 of the License, or
> >> - * (at your option) any later version.
> >> - */
> >> -
> >> -#include <media/rc-core.h>
> >> -#include <linux/module.h>
> >> -
> >> -static struct rc_map_table lirc[] = {
> >> -	{ },
> >> -};
> >> -
> >> -static struct rc_map_list lirc_map = {
> >> -	.map = {
> >> -		.scan    = lirc,
> >> -		.size    = ARRAY_SIZE(lirc),
> >> -		.rc_type = RC_TYPE_LIRC,
> >> -		.name    = RC_MAP_LIRC,
> >> -	}
> >> -};
> >> -
> >> -static int __init init_rc_map_lirc(void)
> >> -{
> >> -	return rc_map_register(&lirc_map);
> >> -}
> >> -
> >> -static void __exit exit_rc_map_lirc(void)
> >> -{
> >> -	rc_map_unregister(&lirc_map);
> >> -}
> >> -
> >> -module_init(init_rc_map_lirc)
> >> -module_exit(exit_rc_map_lirc)
> >> -
> >> -MODULE_LICENSE("GPL");
> >> -MODULE_AUTHOR("Jarod Wilson <jarod@redhat.com>");
> >> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> >> index 128909c..e717dc9 100644
> >> --- a/drivers/media/rc/rc-main.c
> >> +++ b/drivers/media/rc/rc-main.c
> >> @@ -797,7 +797,6 @@ static struct {
> >>  	{ RC_BIT_SANYO,		"sanyo"		},
> >>  	{ RC_BIT_SHARP,		"sharp"		},
> >>  	{ RC_BIT_MCE_KBD,	"mce_kbd"	},
> >> -	{ RC_BIT_LIRC,		"lirc"		},
> >>  	{ RC_BIT_XMP,		"xmp"		},
> >>  };
> >>  
> >> diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
> >> index 0e758ae..4834e78 100644
> >> --- a/drivers/media/rc/st_rc.c
> >> +++ b/drivers/media/rc/st_rc.c
> >> @@ -295,7 +295,7 @@ static int st_rc_probe(struct platform_device *pdev)
> >>  	rdev->open = st_rc_open;
> >>  	rdev->close = st_rc_close;
> >>  	rdev->driver_name = IR_ST_NAME;
> >> -	rdev->map_name = RC_MAP_LIRC;
> >> +	rdev->map_name = RC_MAP_EMPTY;
> >>  	rdev->input_name = "ST Remote Control Receiver";
> >>  
> >>  	/* enable wake via this device */
> >> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> >> index e7a1514..dfca14b 100644
> >> --- a/include/media/rc-map.h
> >> +++ b/include/media/rc-map.h
> >> @@ -14,30 +14,28 @@
> >>  enum rc_type {
> >>  	RC_TYPE_UNKNOWN		= 0,	/* Protocol not known */
> >>  	RC_TYPE_OTHER		= 1,	/* Protocol known but proprietary */
> >> -	RC_TYPE_LIRC		= 2,	/* Pass raw IR to lirc userspace */
> >> -	RC_TYPE_RC5		= 3,	/* Philips RC5 protocol */
> >> -	RC_TYPE_RC5X		= 4,	/* Philips RC5x protocol */
> >> -	RC_TYPE_RC5_SZ		= 5,	/* StreamZap variant of RC5 */
> >> -	RC_TYPE_JVC		= 6,	/* JVC protocol */
> >> -	RC_TYPE_SONY12		= 7,	/* Sony 12 bit protocol */
> >> -	RC_TYPE_SONY15		= 8,	/* Sony 15 bit protocol */
> >> -	RC_TYPE_SONY20		= 9,	/* Sony 20 bit protocol */
> >> -	RC_TYPE_NEC		= 10,	/* NEC protocol */
> >> -	RC_TYPE_SANYO		= 11,	/* Sanyo protocol */
> >> -	RC_TYPE_MCE_KBD		= 12,	/* RC6-ish MCE keyboard/mouse */
> >> -	RC_TYPE_RC6_0		= 13,	/* Philips RC6-0-16 protocol */
> >> -	RC_TYPE_RC6_6A_20	= 14,	/* Philips RC6-6A-20 protocol */
> >> -	RC_TYPE_RC6_6A_24	= 15,	/* Philips RC6-6A-24 protocol */
> >> -	RC_TYPE_RC6_6A_32	= 16,	/* Philips RC6-6A-32 protocol */
> >> -	RC_TYPE_RC6_MCE		= 17,	/* MCE (Philips RC6-6A-32 subtype) protocol */
> >> -	RC_TYPE_SHARP		= 18,	/* Sharp protocol */
> >> -	RC_TYPE_XMP		= 19,	/* XMP protocol */
> >> +	RC_TYPE_RC5		= 2,	/* Philips RC5 protocol */
> >> +	RC_TYPE_RC5X		= 3,	/* Philips RC5x protocol */
> >> +	RC_TYPE_RC5_SZ		= 4,	/* StreamZap variant of RC5 */
> >> +	RC_TYPE_JVC		= 5,	/* JVC protocol */
> >> +	RC_TYPE_SONY12		= 6,	/* Sony 12 bit protocol */
> >> +	RC_TYPE_SONY15		= 7,	/* Sony 15 bit protocol */
> >> +	RC_TYPE_SONY20		= 8,	/* Sony 20 bit protocol */
> >> +	RC_TYPE_NEC		= 9,	/* NEC protocol */
> >> +	RC_TYPE_SANYO		= 10,	/* Sanyo protocol */
> >> +	RC_TYPE_MCE_KBD		= 11,	/* RC6-ish MCE keyboard/mouse */
> >> +	RC_TYPE_RC6_0		= 12,	/* Philips RC6-0-16 protocol */
> >> +	RC_TYPE_RC6_6A_20	= 13,	/* Philips RC6-6A-20 protocol */
> >> +	RC_TYPE_RC6_6A_24	= 14,	/* Philips RC6-6A-24 protocol */
> >> +	RC_TYPE_RC6_6A_32	= 15,	/* Philips RC6-6A-32 protocol */
> >> +	RC_TYPE_RC6_MCE		= 16,	/* MCE (Philips RC6-6A-32 subtype) protocol */
> >> +	RC_TYPE_SHARP		= 17,	/* Sharp protocol */
> >> +	RC_TYPE_XMP		= 18,	/* XMP protocol */
> >>  };
> >>  
> >>  #define RC_BIT_NONE		0
> >>  #define RC_BIT_UNKNOWN		(1 << RC_TYPE_UNKNOWN)
> >>  #define RC_BIT_OTHER		(1 << RC_TYPE_OTHER)
> >> -#define RC_BIT_LIRC		(1 << RC_TYPE_LIRC)
> >>  #define RC_BIT_RC5		(1 << RC_TYPE_RC5)
> >>  #define RC_BIT_RC5X		(1 << RC_TYPE_RC5X)
> >>  #define RC_BIT_RC5_SZ		(1 << RC_TYPE_RC5_SZ)
> >> @@ -56,9 +54,8 @@ enum rc_type {
> >>  #define RC_BIT_SHARP		(1 << RC_TYPE_SHARP)
> >>  #define RC_BIT_XMP		(1 << RC_TYPE_XMP)
> >>  
> >> -#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_LIRC | \
> >> -			 RC_BIT_RC5 | RC_BIT_RC5X | RC_BIT_RC5_SZ | \
> >> -			 RC_BIT_JVC | \
> >> +#define RC_BIT_ALL	(RC_BIT_UNKNOWN | RC_BIT_OTHER | RC_BIT_RC5 | \
> >> +			 RC_BIT_RC5X | RC_BIT_RC5_SZ | RC_BIT_JVC | \
> >>  			 RC_BIT_SONY12 | RC_BIT_SONY15 | RC_BIT_SONY20 | \
> >>  			 RC_BIT_NEC | RC_BIT_SANYO | RC_BIT_MCE_KBD | \
> >>  			 RC_BIT_RC6_0 | RC_BIT_RC6_6A_20 | RC_BIT_RC6_6A_24 | \
> >> @@ -160,7 +157,6 @@ void rc_map_init(void);
> >>  #define RC_MAP_KWORLD_PC150U             "rc-kworld-pc150u"
> >>  #define RC_MAP_KWORLD_PLUS_TV_ANALOG     "rc-kworld-plus-tv-analog"
> >>  #define RC_MAP_LEADTEK_Y04G0051          "rc-leadtek-y04g0051"
> >> -#define RC_MAP_LIRC                      "rc-lirc"
> >>  #define RC_MAP_LME2510                   "rc-lme2510"
> >>  #define RC_MAP_MANLI                     "rc-manli"
> >>  #define RC_MAP_MEDION_X10                "rc-medion-x10"
> >
> 
