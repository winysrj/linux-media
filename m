Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57353 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab0DJM12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Apr 2010 08:27:28 -0400
Subject: Re: [PATCH 08/26] V4L/DVB: Break Remote Controller keymaps into
 modules
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20100406151803.514759bf@pedra>
References: <cover.1270577768.git.mchehab@redhat.com>
	 <20100406151803.514759bf@pedra>
Content-Type: text/plain
Date: Sat, 10 Apr 2010 08:27:38 -0400
Message-Id: <1270902458.3034.49.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-04-06 at 15:18 -0300, Mauro Carvalho Chehab wrote:
> The original Remote Controller approach were very messy: a big file,
> that were part of ir-common kernel module, containing 64 different
> RC keymap tables, used by the V4L/DVB drivers.
> 
> Better to break each RC keymap table into a separate module,
> registering them into rc core on a process similar to the fs/nls tables.
> 
> As an userspace program is now in charge of loading those tables,
> adds an option to allow the complete removal of those tables from
> kernelspace.
> 
> Yet, on embedded devices like Set Top Boxes and TV sets, maybe the
> only available input device is the IR. So, we should keep allowing
> the usage of in-kernel tables, but a latter patch should change
> the default to 'n', after giving some time for distros to add
> the v4l-utils with the ir-keytable program, to allow the table
> load via userspace.

I know I'm probably late on commenting on this.

Although this is interesting, it seems like overkill.


1. How will this help move us to the "just works" case, if now userspace
has to help the kernel.  Every distro is likely just going to bundle a
script which loads them all into the kernel and forgets about them.

2. How is a driver, which knows the bundled remote, supposed to convey
to userspace "load this map by default for my IR receiver"?  Is that
covered in another portion of the patch?

3. If you're going to be so remote specific, why not add protocol
information in these regarding the remotes?  You can tell the core
everything to expect from this remote: raw vs. hardware decoder and the
RC-5/NEC/RC-6/JVC/whatever raw protocol decoder to use.  That gets us
closer to "just works" and avoids false input events from two of the raw
deoders both thinking they got a valid code.

4. /sbin/lsmod is now going to give a very long listing with lots of
noise.  When these things are registered with the core, is the module's
use count incremented when the core knows a driver is using one of them?

5. Each module is going to consume a page of vmalloc address space and
ram, and an addtional page of vmalloc address as a gap behind it.  These
maps are rather small in comparison.  Is it really worth all the page
table entries to load all these as individual modules?  Memory is cheap,
and small allocations can fill in fragmentation gaps in the vmalloc
address space, but page table entries are spent on better things.


I guess I'm not aware of what the return is here for the costs.

Regards,
Andy

> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  create mode 100644 drivers/media/IR/keymaps/Kconfig
>  create mode 100644 drivers/media/IR/keymaps/Makefile
>  create mode 100644 drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
>  create mode 100644 drivers/media/IR/keymaps/rc-apac-viewcomp.c
>  create mode 100644 drivers/media/IR/keymaps/rc-asus-pc39.c
>  create mode 100644 drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
>  create mode 100644 drivers/media/IR/keymaps/rc-avermedia-a16d.c
>  create mode 100644 drivers/media/IR/keymaps/rc-avermedia-cardbus.c
>  create mode 100644 drivers/media/IR/keymaps/rc-avermedia-dvbt.c
>  create mode 100644 drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
>  create mode 100644 drivers/media/IR/keymaps/rc-avermedia.c
>  create mode 100644 drivers/media/IR/keymaps/rc-avertv-303.c
>  create mode 100644 drivers/media/IR/keymaps/rc-behold-columbus.c
>  create mode 100644 drivers/media/IR/keymaps/rc-behold.c
>  create mode 100644 drivers/media/IR/keymaps/rc-budget-ci-old.c
>  create mode 100644 drivers/media/IR/keymaps/rc-cinergy-1400.c
>  create mode 100644 drivers/media/IR/keymaps/rc-cinergy.c
>  create mode 100644 drivers/media/IR/keymaps/rc-dm1105-nec.c
>  create mode 100644 drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
>  create mode 100644 drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
>  create mode 100644 drivers/media/IR/keymaps/rc-em-terratec.c
>  create mode 100644 drivers/media/IR/keymaps/rc-empty.c
>  create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
>  create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv.c
>  create mode 100644 drivers/media/IR/keymaps/rc-encore-enltv2.c
>  create mode 100644 drivers/media/IR/keymaps/rc-evga-indtube.c
>  create mode 100644 drivers/media/IR/keymaps/rc-eztv.c
>  create mode 100644 drivers/media/IR/keymaps/rc-flydvb.c
>  create mode 100644 drivers/media/IR/keymaps/rc-flyvideo.c
>  create mode 100644 drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
>  create mode 100644 drivers/media/IR/keymaps/rc-gadmei-rm008z.c
>  create mode 100644 drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
>  create mode 100644 drivers/media/IR/keymaps/rc-gotview7135.c
>  create mode 100644 drivers/media/IR/keymaps/rc-hauppauge-new.c
>  create mode 100644 drivers/media/IR/keymaps/rc-iodata-bctv7e.c
>  create mode 100644 drivers/media/IR/keymaps/rc-kaiomy.c
>  create mode 100644 drivers/media/IR/keymaps/rc-kworld-315u.c
>  create mode 100644 drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
>  create mode 100644 drivers/media/IR/keymaps/rc-manli.c
>  create mode 100644 drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
>  create mode 100644 drivers/media/IR/keymaps/rc-msi-tvanywhere.c
>  create mode 100644 drivers/media/IR/keymaps/rc-nebula.c
>  create mode 100644 drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
>  create mode 100644 drivers/media/IR/keymaps/rc-norwood.c
>  create mode 100644 drivers/media/IR/keymaps/rc-npgtech.c
>  create mode 100644 drivers/media/IR/keymaps/rc-pctv-sedna.c
>  create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-color.c
>  create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-grey.c
>  create mode 100644 drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
>  create mode 100644 drivers/media/IR/keymaps/rc-pixelview-new.c
>  create mode 100644 drivers/media/IR/keymaps/rc-pixelview.c
>  create mode 100644 drivers/media/IR/keymaps/rc-powercolor-real-angel.c
>  create mode 100644 drivers/media/IR/keymaps/rc-proteus-2309.c
>  create mode 100644 drivers/media/IR/keymaps/rc-purpletv.c
>  create mode 100644 drivers/media/IR/keymaps/rc-pv951.c
>  create mode 100644 drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
>  create mode 100644 drivers/media/IR/keymaps/rc-rc5-tv.c
>  create mode 100644 drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
>  create mode 100644 drivers/media/IR/keymaps/rc-tbs-nec.c
>  create mode 100644 drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
>  create mode 100644 drivers/media/IR/keymaps/rc-tevii-nec.c
>  create mode 100644 drivers/media/IR/keymaps/rc-tt-1500.c
>  create mode 100644 drivers/media/IR/keymaps/rc-videomate-s350.c
>  create mode 100644 drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
>  create mode 100644 drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
>  create mode 100644 drivers/media/IR/keymaps/rc-winfast.c
> 
> diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
> index de410d4..0c557b8 100644
> --- a/drivers/media/IR/Kconfig
> +++ b/drivers/media/IR/Kconfig
> @@ -8,6 +8,8 @@ config VIDEO_IR
>  	depends on IR_CORE
>  	default IR_CORE
>  
> +source "drivers/media/IR/keymaps/Kconfig"
> +
>  config IR_NEC_DECODER
>  	tristate "Enable IR raw decoder for NEC protocol"
>  	depends on IR_CORE
> diff --git a/drivers/media/IR/keymaps/Kconfig b/drivers/media/IR/keymaps/Kconfig
> new file mode 100644
> index 0000000..14b22f5
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/Kconfig
> @@ -0,0 +1,15 @@
> +config RC_MAP
> +	tristate "Compile Remote Controller keymap modules"
> +	depends on IR_CORE
> +	default y
> +
> +	---help---
> +	   This option enables the compilation of lots of Remote
> +	   Controller tables. They are short tables, but if you
> +	   don't use a remote controller, or prefer to load the
> +	   tables on userspace, you should disable it.
> +
> +	   The ir-keytable program, available at v4l-utils package
> +	   provide the tool and the same RC maps for load from
> +	   userspace. Its available at
> +			http://git.linuxtv.org/v4l-utils
> diff --git a/drivers/media/IR/keymaps/Makefile b/drivers/media/IR/keymaps/Makefile
> new file mode 100644
> index 0000000..937b7db
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/Makefile
> @@ -0,0 +1,64 @@
> +obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
> +			rc-apac-viewcomp.o \
> +			rc-asus-pc39.o \
> +			rc-ati-tv-wonder-hd-600.o \
> +			rc-avermedia-a16d.o \
> +			rc-avermedia.o \
> +			rc-avermedia-cardbus.o \
> +			rc-avermedia-dvbt.o \
> +			rc-avermedia-m135a-rm-jx.o \
> +			rc-avertv-303.o \
> +			rc-behold.o \
> +			rc-behold-columbus.o \
> +			rc-budget-ci-old.o \
> +			rc-cinergy-1400.o \
> +			rc-cinergy.o \
> +			rc-dm1105-nec.o \
> +			rc-dntv-live-dvb-t.o \
> +			rc-dntv-live-dvbt-pro.o \
> +			rc-empty.o \
> +			rc-em-terratec.o \
> +			rc-encore-enltv2.o \
> +			rc-encore-enltv.o \
> +			rc-encore-enltv-fm53.o \
> +			rc-evga-indtube.o \
> +			rc-eztv.o \
> +			rc-flydvb.o \
> +			rc-flyvideo.o \
> +			rc-fusionhdtv-mce.o \
> +			rc-gadmei-rm008z.o \
> +			rc-genius-tvgo-a11mce.o \
> +			rc-gotview7135.o \
> +			rc-hauppauge-new.o \
> +			rc-iodata-bctv7e.o \
> +			rc-kaiomy.o \
> +			rc-kworld-315u.o \
> +			rc-kworld-plus-tv-analog.o \
> +			rc-manli.o \
> +			rc-msi-tvanywhere.o \
> +			rc-msi-tvanywhere-plus.o \
> +			rc-nebula.o \
> +			rc-nec-terratec-cinergy-xs.o \
> +			rc-norwood.o \
> +			rc-npgtech.o \
> +			rc-pctv-sedna.o \
> +			rc-pinnacle-color.o \
> +			rc-pinnacle-grey.o \
> +			rc-pinnacle-pctv-hd.o \
> +			rc-pixelview.o \
> +			rc-pixelview-new.o \
> +			rc-powercolor-real-angel.o \
> +			rc-proteus-2309.o \
> +			rc-purpletv.o \
> +			rc-pv951.o \
> +			rc-rc5-hauppauge-new.o \
> +			rc-rc5-tv.o \
> +			rc-real-audio-220-32-keys.o \
> +			rc-tbs-nec.o \
> +			rc-terratec-cinergy-xs.o \
> +			rc-tevii-nec.o \
> +			rc-tt-1500.o \
> +			rc-videomate-s350.o \
> +			rc-videomate-tv-pvr.o \
> +			rc-winfast.o \
> +			rc-winfast-usbii-deluxe.o
> diff --git a/drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
> new file mode 100644
> index 0000000..b172831
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-adstech-dvb-t-pci.c
> @@ -0,0 +1,89 @@
> +/* adstech-dvb-t-pci.h - Keytable for adstech_dvb_t_pci Remote Controller
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
> +
> +/* ADS Tech Instant TV DVB-T PCI Remote */
> +
> +static struct ir_scancode adstech_dvb_t_pci[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x4d, KEY_0 },
> +	{ 0x57, KEY_1 },
> +	{ 0x4f, KEY_2 },
> +	{ 0x53, KEY_3 },
> +	{ 0x56, KEY_4 },
> +	{ 0x4e, KEY_5 },
> +	{ 0x5e, KEY_6 },
> +	{ 0x54, KEY_7 },
> +	{ 0x4c, KEY_8 },
> +	{ 0x5c, KEY_9 },
> +
> +	{ 0x5b, KEY_POWER },
> +	{ 0x5f, KEY_MUTE },
> +	{ 0x55, KEY_GOTO },
> +	{ 0x5d, KEY_SEARCH },
> +	{ 0x17, KEY_EPG },		/* Guide */
> +	{ 0x1f, KEY_MENU },
> +	{ 0x0f, KEY_UP },
> +	{ 0x46, KEY_DOWN },
> +	{ 0x16, KEY_LEFT },
> +	{ 0x1e, KEY_RIGHT },
> +	{ 0x0e, KEY_SELECT },		/* Enter */
> +	{ 0x5a, KEY_INFO },
> +	{ 0x52, KEY_EXIT },
> +	{ 0x59, KEY_PREVIOUS },
> +	{ 0x51, KEY_NEXT },
> +	{ 0x58, KEY_REWIND },
> +	{ 0x50, KEY_FORWARD },
> +	{ 0x44, KEY_PLAYPAUSE },
> +	{ 0x07, KEY_STOP },
> +	{ 0x1b, KEY_RECORD },
> +	{ 0x13, KEY_TUNER },		/* Live */
> +	{ 0x0a, KEY_A },
> +	{ 0x12, KEY_B },
> +	{ 0x03, KEY_PROG1 },		/* 1 */
> +	{ 0x01, KEY_PROG2 },		/* 2 */
> +	{ 0x00, KEY_PROG3 },		/* 3 */
> +	{ 0x06, KEY_DVD },
> +	{ 0x48, KEY_AUX },		/* Photo */
> +	{ 0x40, KEY_VIDEO },
> +	{ 0x19, KEY_AUDIO },		/* Music */
> +	{ 0x0b, KEY_CHANNELUP },
> +	{ 0x08, KEY_CHANNELDOWN },
> +	{ 0x15, KEY_VOLUMEUP },
> +	{ 0x1c, KEY_VOLUMEDOWN },
> +};
> +
> +static struct rc_keymap adstech_dvb_t_pci_map = {
> +	.map = {
> +		.scan    = adstech_dvb_t_pci,
> +		.size    = ARRAY_SIZE(adstech_dvb_t_pci),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_ADSTECH_DVB_T_PCI,
> +	}
> +};
> +
> +static int __init init_rc_map_adstech_dvb_t_pci(void)
> +{
> +	return ir_register_map(&adstech_dvb_t_pci_map);
> +}
> +
> +static void __exit exit_rc_map_adstech_dvb_t_pci(void)
> +{
> +	ir_unregister_map(&adstech_dvb_t_pci_map);
> +}
> +
> +module_init(init_rc_map_adstech_dvb_t_pci)
> +module_exit(exit_rc_map_adstech_dvb_t_pci)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-apac-viewcomp.c b/drivers/media/IR/keymaps/rc-apac-viewcomp.c
> new file mode 100644
> index 0000000..0ef2b56
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-apac-viewcomp.c
> @@ -0,0 +1,80 @@
> +/* apac-viewcomp.h - Keytable for apac_viewcomp Remote Controller
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
> +
> +/* Attila Kondoros <attila.kondoros@chello.hu> */
> +
> +static struct ir_scancode apac_viewcomp[] = {
> +
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
> +	{ 0x17, KEY_LAST },		/* +100 */
> +	{ 0x0a, KEY_LIST },		/* recall */
> +
> +
> +	{ 0x1c, KEY_TUNER },		/* TV/FM */
> +	{ 0x15, KEY_SEARCH },		/* scan */
> +	{ 0x12, KEY_POWER },		/* power */
> +	{ 0x1f, KEY_VOLUMEDOWN },	/* vol up */
> +	{ 0x1b, KEY_VOLUMEUP },		/* vol down */
> +	{ 0x1e, KEY_CHANNELDOWN },	/* chn up */
> +	{ 0x1a, KEY_CHANNELUP },	/* chn down */
> +
> +	{ 0x11, KEY_VIDEO },		/* video */
> +	{ 0x0f, KEY_ZOOM },		/* full screen */
> +	{ 0x13, KEY_MUTE },		/* mute/unmute */
> +	{ 0x10, KEY_TEXT },		/* min */
> +
> +	{ 0x0d, KEY_STOP },		/* freeze */
> +	{ 0x0e, KEY_RECORD },		/* record */
> +	{ 0x1d, KEY_PLAYPAUSE },	/* stop */
> +	{ 0x19, KEY_PLAY },		/* play */
> +
> +	{ 0x16, KEY_GOTO },		/* osd */
> +	{ 0x14, KEY_REFRESH },		/* default */
> +	{ 0x0c, KEY_KPPLUS },		/* fine tune >>>> */
> +	{ 0x18, KEY_KPMINUS },		/* fine tune <<<< */
> +};
> +
> +static struct rc_keymap apac_viewcomp_map = {
> +	.map = {
> +		.scan    = apac_viewcomp,
> +		.size    = ARRAY_SIZE(apac_viewcomp),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_APAC_VIEWCOMP,
> +	}
> +};
> +
> +static int __init init_rc_map_apac_viewcomp(void)
> +{
> +	return ir_register_map(&apac_viewcomp_map);
> +}
> +
> +static void __exit exit_rc_map_apac_viewcomp(void)
> +{
> +	ir_unregister_map(&apac_viewcomp_map);
> +}
> +
> +module_init(init_rc_map_apac_viewcomp)
> +module_exit(exit_rc_map_apac_viewcomp)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-asus-pc39.c b/drivers/media/IR/keymaps/rc-asus-pc39.c
> new file mode 100644
> index 0000000..2aa068c
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-asus-pc39.c
> @@ -0,0 +1,91 @@
> +/* asus-pc39.h - Keytable for asus_pc39 Remote Controller
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
> +
> +/*
> + * Marc Fargas <telenieko@telenieko.com>
> + * this is the remote control that comes with the asus p7131
> + * which has a label saying is "Model PC-39"
> + */
> +
> +static struct ir_scancode asus_pc39[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x15, KEY_0 },
> +	{ 0x29, KEY_1 },
> +	{ 0x2d, KEY_2 },
> +	{ 0x2b, KEY_3 },
> +	{ 0x09, KEY_4 },
> +	{ 0x0d, KEY_5 },
> +	{ 0x0b, KEY_6 },
> +	{ 0x31, KEY_7 },
> +	{ 0x35, KEY_8 },
> +	{ 0x33, KEY_9 },
> +
> +	{ 0x3e, KEY_RADIO },		/* radio */
> +	{ 0x03, KEY_MENU },		/* dvd/menu */
> +	{ 0x2a, KEY_VOLUMEUP },
> +	{ 0x19, KEY_VOLUMEDOWN },
> +	{ 0x37, KEY_UP },
> +	{ 0x3b, KEY_DOWN },
> +	{ 0x27, KEY_LEFT },
> +	{ 0x2f, KEY_RIGHT },
> +	{ 0x25, KEY_VIDEO },		/* video */
> +	{ 0x39, KEY_AUDIO },		/* music */
> +
> +	{ 0x21, KEY_TV },		/* tv */
> +	{ 0x1d, KEY_EXIT },		/* back */
> +	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
> +	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
> +	{ 0x1a, KEY_ENTER },		/* enter */
> +
> +	{ 0x06, KEY_PAUSE },		/* play/pause */
> +	{ 0x1e, KEY_PREVIOUS },		/* rew */
> +	{ 0x26, KEY_NEXT },		/* forward */
> +	{ 0x0e, KEY_REWIND },		/* backward << */
> +	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
> +	{ 0x36, KEY_STOP },
> +	{ 0x2e, KEY_RECORD },		/* recording */
> +	{ 0x16, KEY_POWER },		/* the button that reads "close" */
> +
> +	{ 0x11, KEY_ZOOM },		/* full screen */
> +	{ 0x13, KEY_MACRO },		/* recall */
> +	{ 0x23, KEY_HOME },		/* home */
> +	{ 0x05, KEY_PVR },		/* picture */
> +	{ 0x3d, KEY_MUTE },		/* mute */
> +	{ 0x01, KEY_DVD },		/* dvd */
> +};
> +
> +static struct rc_keymap asus_pc39_map = {
> +	.map = {
> +		.scan    = asus_pc39,
> +		.size    = ARRAY_SIZE(asus_pc39),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_ASUS_PC39,
> +	}
> +};
> +
> +static int __init init_rc_map_asus_pc39(void)
> +{
> +	return ir_register_map(&asus_pc39_map);
> +}
> +
> +static void __exit exit_rc_map_asus_pc39(void)
> +{
> +	ir_unregister_map(&asus_pc39_map);
> +}
> +
> +module_init(init_rc_map_asus_pc39)
> +module_exit(exit_rc_map_asus_pc39)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
> new file mode 100644
> index 0000000..8edfd29
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-ati-tv-wonder-hd-600.c
> @@ -0,0 +1,69 @@
> +/* ati-tv-wonder-hd-600.h - Keytable for ati_tv_wonder_hd_600 Remote Controller
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
> +
> +/* ATI TV Wonder HD 600 USB
> +   Devin Heitmueller <devin.heitmueller@gmail.com>
> + */
> +
> +static struct ir_scancode ati_tv_wonder_hd_600[] = {
> +	{ 0x00, KEY_RECORD},		/* Row 1 */
> +	{ 0x01, KEY_PLAYPAUSE},
> +	{ 0x02, KEY_STOP},
> +	{ 0x03, KEY_POWER},
> +	{ 0x04, KEY_PREVIOUS},	/* Row 2 */
> +	{ 0x05, KEY_REWIND},
> +	{ 0x06, KEY_FORWARD},
> +	{ 0x07, KEY_NEXT},
> +	{ 0x08, KEY_EPG},		/* Row 3 */
> +	{ 0x09, KEY_HOME},
> +	{ 0x0a, KEY_MENU},
> +	{ 0x0b, KEY_CHANNELUP},
> +	{ 0x0c, KEY_BACK},		/* Row 4 */
> +	{ 0x0d, KEY_UP},
> +	{ 0x0e, KEY_INFO},
> +	{ 0x0f, KEY_CHANNELDOWN},
> +	{ 0x10, KEY_LEFT},		/* Row 5 */
> +	{ 0x11, KEY_SELECT},
> +	{ 0x12, KEY_RIGHT},
> +	{ 0x13, KEY_VOLUMEUP},
> +	{ 0x14, KEY_LAST},		/* Row 6 */
> +	{ 0x15, KEY_DOWN},
> +	{ 0x16, KEY_MUTE},
> +	{ 0x17, KEY_VOLUMEDOWN},
> +};
> +
> +static struct rc_keymap ati_tv_wonder_hd_600_map = {
> +	.map = {
> +		.scan    = ati_tv_wonder_hd_600,
> +		.size    = ARRAY_SIZE(ati_tv_wonder_hd_600),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_ATI_TV_WONDER_HD_600,
> +	}
> +};
> +
> +static int __init init_rc_map_ati_tv_wonder_hd_600(void)
> +{
> +	return ir_register_map(&ati_tv_wonder_hd_600_map);
> +}
> +
> +static void __exit exit_rc_map_ati_tv_wonder_hd_600(void)
> +{
> +	ir_unregister_map(&ati_tv_wonder_hd_600_map);
> +}
> +
> +module_init(init_rc_map_ati_tv_wonder_hd_600)
> +module_exit(exit_rc_map_ati_tv_wonder_hd_600)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-avermedia-a16d.c b/drivers/media/IR/keymaps/rc-avermedia-a16d.c
> new file mode 100644
> index 0000000..12f0435
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-avermedia-a16d.c
> @@ -0,0 +1,75 @@
> +/* avermedia-a16d.h - Keytable for avermedia_a16d Remote Controller
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
> +
> +static struct ir_scancode avermedia_a16d[] = {
> +	{ 0x20, KEY_LIST},
> +	{ 0x00, KEY_POWER},
> +	{ 0x28, KEY_1},
> +	{ 0x18, KEY_2},
> +	{ 0x38, KEY_3},
> +	{ 0x24, KEY_4},
> +	{ 0x14, KEY_5},
> +	{ 0x34, KEY_6},
> +	{ 0x2c, KEY_7},
> +	{ 0x1c, KEY_8},
> +	{ 0x3c, KEY_9},
> +	{ 0x12, KEY_SUBTITLE},
> +	{ 0x22, KEY_0},
> +	{ 0x32, KEY_REWIND},
> +	{ 0x3a, KEY_SHUFFLE},
> +	{ 0x02, KEY_PRINT},
> +	{ 0x11, KEY_CHANNELDOWN},
> +	{ 0x31, KEY_CHANNELUP},
> +	{ 0x0c, KEY_ZOOM},
> +	{ 0x1e, KEY_VOLUMEDOWN},
> +	{ 0x3e, KEY_VOLUMEUP},
> +	{ 0x0a, KEY_MUTE},
> +	{ 0x04, KEY_AUDIO},
> +	{ 0x26, KEY_RECORD},
> +	{ 0x06, KEY_PLAY},
> +	{ 0x36, KEY_STOP},
> +	{ 0x16, KEY_PAUSE},
> +	{ 0x2e, KEY_REWIND},
> +	{ 0x0e, KEY_FASTFORWARD},
> +	{ 0x30, KEY_TEXT},
> +	{ 0x21, KEY_GREEN},
> +	{ 0x01, KEY_BLUE},
> +	{ 0x08, KEY_EPG},
> +	{ 0x2a, KEY_MENU},
> +};
> +
> +static struct rc_keymap avermedia_a16d_map = {
> +	.map = {
> +		.scan    = avermedia_a16d,
> +		.size    = ARRAY_SIZE(avermedia_a16d),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_AVERMEDIA_A16D,
> +	}
> +};
> +
> +static int __init init_rc_map_avermedia_a16d(void)
> +{
> +	return ir_register_map(&avermedia_a16d_map);
> +}
> +
> +static void __exit exit_rc_map_avermedia_a16d(void)
> +{
> +	ir_unregister_map(&avermedia_a16d_map);
> +}
> +
> +module_init(init_rc_map_avermedia_a16d)
> +module_exit(exit_rc_map_avermedia_a16d)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-avermedia-cardbus.c b/drivers/media/IR/keymaps/rc-avermedia-cardbus.c
> new file mode 100644
> index 0000000..2a945b0
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-avermedia-cardbus.c
> @@ -0,0 +1,97 @@
> +/* avermedia-cardbus.h - Keytable for avermedia_cardbus Remote Controller
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
> +
> +/* Oldrich Jedlicka <oldium.pro@seznam.cz> */
> +
> +static struct ir_scancode avermedia_cardbus[] = {
> +	{ 0x00, KEY_POWER },
> +	{ 0x01, KEY_TUNER },		/* TV/FM */
> +	{ 0x03, KEY_TEXT },		/* Teletext */
> +	{ 0x04, KEY_EPG },
> +	{ 0x05, KEY_1 },
> +	{ 0x06, KEY_2 },
> +	{ 0x07, KEY_3 },
> +	{ 0x08, KEY_AUDIO },
> +	{ 0x09, KEY_4 },
> +	{ 0x0a, KEY_5 },
> +	{ 0x0b, KEY_6 },
> +	{ 0x0c, KEY_ZOOM },		/* Full screen */
> +	{ 0x0d, KEY_7 },
> +	{ 0x0e, KEY_8 },
> +	{ 0x0f, KEY_9 },
> +	{ 0x10, KEY_PAGEUP },		/* 16-CH PREV */
> +	{ 0x11, KEY_0 },
> +	{ 0x12, KEY_INFO },
> +	{ 0x13, KEY_AGAIN },		/* CH RTN - channel return */
> +	{ 0x14, KEY_MUTE },
> +	{ 0x15, KEY_EDIT },		/* Autoscan */
> +	{ 0x17, KEY_SAVE },		/* Screenshot */
> +	{ 0x18, KEY_PLAYPAUSE },
> +	{ 0x19, KEY_RECORD },
> +	{ 0x1a, KEY_PLAY },
> +	{ 0x1b, KEY_STOP },
> +	{ 0x1c, KEY_FASTFORWARD },
> +	{ 0x1d, KEY_REWIND },
> +	{ 0x1e, KEY_VOLUMEDOWN },
> +	{ 0x1f, KEY_VOLUMEUP },
> +	{ 0x22, KEY_SLEEP },		/* Sleep */
> +	{ 0x23, KEY_ZOOM },		/* Aspect */
> +	{ 0x26, KEY_SCREEN },		/* Pos */
> +	{ 0x27, KEY_ANGLE },		/* Size */
> +	{ 0x28, KEY_SELECT },		/* Select */
> +	{ 0x29, KEY_BLUE },		/* Blue/Picture */
> +	{ 0x2a, KEY_BACKSPACE },	/* Back */
> +	{ 0x2b, KEY_MEDIA },		/* PIP (Picture-in-picture) */
> +	{ 0x2c, KEY_DOWN },
> +	{ 0x2e, KEY_DOT },
> +	{ 0x2f, KEY_TV },		/* Live TV */
> +	{ 0x32, KEY_LEFT },
> +	{ 0x33, KEY_CLEAR },		/* Clear */
> +	{ 0x35, KEY_RED },		/* Red/TV */
> +	{ 0x36, KEY_UP },
> +	{ 0x37, KEY_HOME },		/* Home */
> +	{ 0x39, KEY_GREEN },		/* Green/Video */
> +	{ 0x3d, KEY_YELLOW },		/* Yellow/Music */
> +	{ 0x3e, KEY_OK },		/* Ok */
> +	{ 0x3f, KEY_RIGHT },
> +	{ 0x40, KEY_NEXT },		/* Next */
> +	{ 0x41, KEY_PREVIOUS },		/* Previous */
> +	{ 0x42, KEY_CHANNELDOWN },	/* Channel down */
> +	{ 0x43, KEY_CHANNELUP },	/* Channel up */
> +};
> +
> +static struct rc_keymap avermedia_cardbus_map = {
> +	.map = {
> +		.scan    = avermedia_cardbus,
> +		.size    = ARRAY_SIZE(avermedia_cardbus),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_AVERMEDIA_CARDBUS,
> +	}
> +};
> +
> +static int __init init_rc_map_avermedia_cardbus(void)
> +{
> +	return ir_register_map(&avermedia_cardbus_map);
> +}
> +
> +static void __exit exit_rc_map_avermedia_cardbus(void)
> +{
> +	ir_unregister_map(&avermedia_cardbus_map);
> +}
> +
> +module_init(init_rc_map_avermedia_cardbus)
> +module_exit(exit_rc_map_avermedia_cardbus)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-avermedia-dvbt.c b/drivers/media/IR/keymaps/rc-avermedia-dvbt.c
> new file mode 100644
> index 0000000..39dde62
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-avermedia-dvbt.c
> @@ -0,0 +1,78 @@
> +/* avermedia-dvbt.h - Keytable for avermedia_dvbt Remote Controller
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
> +
> +/* Matt Jesson <dvb@jesson.eclipse.co.uk */
> +
> +static struct ir_scancode avermedia_dvbt[] = {
> +	{ 0x28, KEY_0 },		/* '0' / 'enter' */
> +	{ 0x22, KEY_1 },		/* '1' */
> +	{ 0x12, KEY_2 },		/* '2' / 'up arrow' */
> +	{ 0x32, KEY_3 },		/* '3' */
> +	{ 0x24, KEY_4 },		/* '4' / 'left arrow' */
> +	{ 0x14, KEY_5 },		/* '5' */
> +	{ 0x34, KEY_6 },		/* '6' / 'right arrow' */
> +	{ 0x26, KEY_7 },		/* '7' */
> +	{ 0x16, KEY_8 },		/* '8' / 'down arrow' */
> +	{ 0x36, KEY_9 },		/* '9' */
> +
> +	{ 0x20, KEY_LIST },		/* 'source' */
> +	{ 0x10, KEY_TEXT },		/* 'teletext' */
> +	{ 0x00, KEY_POWER },		/* 'power' */
> +	{ 0x04, KEY_AUDIO },		/* 'audio' */
> +	{ 0x06, KEY_ZOOM },		/* 'full screen' */
> +	{ 0x18, KEY_VIDEO },		/* 'display' */
> +	{ 0x38, KEY_SEARCH },		/* 'loop' */
> +	{ 0x08, KEY_INFO },		/* 'preview' */
> +	{ 0x2a, KEY_REWIND },		/* 'backward <<' */
> +	{ 0x1a, KEY_FASTFORWARD },	/* 'forward >>' */
> +	{ 0x3a, KEY_RECORD },		/* 'capture' */
> +	{ 0x0a, KEY_MUTE },		/* 'mute' */
> +	{ 0x2c, KEY_RECORD },		/* 'record' */
> +	{ 0x1c, KEY_PAUSE },		/* 'pause' */
> +	{ 0x3c, KEY_STOP },		/* 'stop' */
> +	{ 0x0c, KEY_PLAY },		/* 'play' */
> +	{ 0x2e, KEY_RED },		/* 'red' */
> +	{ 0x01, KEY_BLUE },		/* 'blue' / 'cancel' */
> +	{ 0x0e, KEY_YELLOW },		/* 'yellow' / 'ok' */
> +	{ 0x21, KEY_GREEN },		/* 'green' */
> +	{ 0x11, KEY_CHANNELDOWN },	/* 'channel -' */
> +	{ 0x31, KEY_CHANNELUP },	/* 'channel +' */
> +	{ 0x1e, KEY_VOLUMEDOWN },	/* 'volume -' */
> +	{ 0x3e, KEY_VOLUMEUP },		/* 'volume +' */
> +};
> +
> +static struct rc_keymap avermedia_dvbt_map = {
> +	.map = {
> +		.scan    = avermedia_dvbt,
> +		.size    = ARRAY_SIZE(avermedia_dvbt),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_AVERMEDIA_DVBT,
> +	}
> +};
> +
> +static int __init init_rc_map_avermedia_dvbt(void)
> +{
> +	return ir_register_map(&avermedia_dvbt_map);
> +}
> +
> +static void __exit exit_rc_map_avermedia_dvbt(void)
> +{
> +	ir_unregister_map(&avermedia_dvbt_map);
> +}
> +
> +module_init(init_rc_map_avermedia_dvbt)
> +module_exit(exit_rc_map_avermedia_dvbt)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c b/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
> new file mode 100644
> index 0000000..101e7ea
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-avermedia-m135a-rm-jx.c
> @@ -0,0 +1,90 @@
> +/* avermedia-m135a-rm-jx.h - Keytable for avermedia_m135a_rm_jx Remote Controller
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
> +
> +/*
> + * Avermedia M135A with IR model RM-JX
> + * The same codes exist on both Positivo (BR) and original IR
> + * Mauro Carvalho Chehab <mchehab@infradead.org>
> + */
> +
> +static struct ir_scancode avermedia_m135a_rm_jx[] = {
> +	{ 0x0200, KEY_POWER2 },
> +	{ 0x022e, KEY_DOT },		/* '.' */
> +	{ 0x0201, KEY_MODE },		/* TV/FM or SOURCE */
> +
> +	{ 0x0205, KEY_1 },
> +	{ 0x0206, KEY_2 },
> +	{ 0x0207, KEY_3 },
> +	{ 0x0209, KEY_4 },
> +	{ 0x020a, KEY_5 },
> +	{ 0x020b, KEY_6 },
> +	{ 0x020d, KEY_7 },
> +	{ 0x020e, KEY_8 },
> +	{ 0x020f, KEY_9 },
> +	{ 0x0211, KEY_0 },
> +
> +	{ 0x0213, KEY_RIGHT },		/* -> or L */
> +	{ 0x0212, KEY_LEFT },		/* <- or R */
> +
> +	{ 0x0217, KEY_SLEEP },		/* Capturar Imagem or Snapshot */
> +	{ 0x0210, KEY_SHUFFLE },	/* Amostra or 16 chan prev */
> +
> +	{ 0x0303, KEY_CHANNELUP },
> +	{ 0x0302, KEY_CHANNELDOWN },
> +	{ 0x021f, KEY_VOLUMEUP },
> +	{ 0x021e, KEY_VOLUMEDOWN },
> +	{ 0x020c, KEY_ENTER },		/* Full Screen */
> +
> +	{ 0x0214, KEY_MUTE },
> +	{ 0x0208, KEY_AUDIO },
> +
> +	{ 0x0203, KEY_TEXT },		/* Teletext */
> +	{ 0x0204, KEY_EPG },
> +	{ 0x022b, KEY_TV2 },		/* TV2 or PIP */
> +
> +	{ 0x021d, KEY_RED },
> +	{ 0x021c, KEY_YELLOW },
> +	{ 0x0301, KEY_GREEN },
> +	{ 0x0300, KEY_BLUE },
> +
> +	{ 0x021a, KEY_PLAYPAUSE },
> +	{ 0x0219, KEY_RECORD },
> +	{ 0x0218, KEY_PLAY },
> +	{ 0x021b, KEY_STOP },
> +};
> +
> +static struct rc_keymap avermedia_m135a_rm_jx_map = {
> +	.map = {
> +		.scan    = avermedia_m135a_rm_jx,
> +		.size    = ARRAY_SIZE(avermedia_m135a_rm_jx),
> +		.ir_type = IR_TYPE_NEC,
> +		.name    = RC_MAP_AVERMEDIA_M135A_RM_JX,
> +	}
> +};
> +
> +static int __init init_rc_map_avermedia_m135a_rm_jx(void)
> +{
> +	return ir_register_map(&avermedia_m135a_rm_jx_map);
> +}
> +
> +static void __exit exit_rc_map_avermedia_m135a_rm_jx(void)
> +{
> +	ir_unregister_map(&avermedia_m135a_rm_jx_map);
> +}
> +
> +module_init(init_rc_map_avermedia_m135a_rm_jx)
> +module_exit(exit_rc_map_avermedia_m135a_rm_jx)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-avermedia.c b/drivers/media/IR/keymaps/rc-avermedia.c
> new file mode 100644
> index 0000000..21effd5
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-avermedia.c
> @@ -0,0 +1,86 @@
> +/* avermedia.h - Keytable for avermedia Remote Controller
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
> +
> +/* Alex Hermann <gaaf@gmx.net> */
> +
> +static struct ir_scancode avermedia[] = {
> +	{ 0x28, KEY_1 },
> +	{ 0x18, KEY_2 },
> +	{ 0x38, KEY_3 },
> +	{ 0x24, KEY_4 },
> +	{ 0x14, KEY_5 },
> +	{ 0x34, KEY_6 },
> +	{ 0x2c, KEY_7 },
> +	{ 0x1c, KEY_8 },
> +	{ 0x3c, KEY_9 },
> +	{ 0x22, KEY_0 },
> +
> +	{ 0x20, KEY_TV },		/* TV/FM */
> +	{ 0x10, KEY_CD },		/* CD */
> +	{ 0x30, KEY_TEXT },		/* TELETEXT */
> +	{ 0x00, KEY_POWER },		/* POWER */
> +
> +	{ 0x08, KEY_VIDEO },		/* VIDEO */
> +	{ 0x04, KEY_AUDIO },		/* AUDIO */
> +	{ 0x0c, KEY_ZOOM },		/* FULL SCREEN */
> +
> +	{ 0x12, KEY_SUBTITLE },		/* DISPLAY */
> +	{ 0x32, KEY_REWIND },		/* LOOP	*/
> +	{ 0x02, KEY_PRINT },		/* PREVIEW */
> +
> +	{ 0x2a, KEY_SEARCH },		/* AUTOSCAN */
> +	{ 0x1a, KEY_SLEEP },		/* FREEZE */
> +	{ 0x3a, KEY_CAMERA },		/* SNAPSHOT */
> +	{ 0x0a, KEY_MUTE },		/* MUTE */
> +
> +	{ 0x26, KEY_RECORD },		/* RECORD */
> +	{ 0x16, KEY_PAUSE },		/* PAUSE */
> +	{ 0x36, KEY_STOP },		/* STOP */
> +	{ 0x06, KEY_PLAY },		/* PLAY */
> +
> +	{ 0x2e, KEY_RED },		/* RED */
> +	{ 0x21, KEY_GREEN },		/* GREEN */
> +	{ 0x0e, KEY_YELLOW },		/* YELLOW */
> +	{ 0x01, KEY_BLUE },		/* BLUE */
> +
> +	{ 0x1e, KEY_VOLUMEDOWN },	/* VOLUME- */
> +	{ 0x3e, KEY_VOLUMEUP },		/* VOLUME+ */
> +	{ 0x11, KEY_CHANNELDOWN },	/* CHANNEL/PAGE- */
> +	{ 0x31, KEY_CHANNELUP }		/* CHANNEL/PAGE+ */
> +};
> +
> +static struct rc_keymap avermedia_map = {
> +	.map = {
> +		.scan    = avermedia,
> +		.size    = ARRAY_SIZE(avermedia),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_AVERMEDIA,
> +	}
> +};
> +
> +static int __init init_rc_map_avermedia(void)
> +{
> +	return ir_register_map(&avermedia_map);
> +}
> +
> +static void __exit exit_rc_map_avermedia(void)
> +{
> +	ir_unregister_map(&avermedia_map);
> +}
> +
> +module_init(init_rc_map_avermedia)
> +module_exit(exit_rc_map_avermedia)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-avertv-303.c b/drivers/media/IR/keymaps/rc-avertv-303.c
> new file mode 100644
> index 0000000..971c59d
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-avertv-303.c
> @@ -0,0 +1,85 @@
> +/* avertv-303.h - Keytable for avertv_303 Remote Controller
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
> +
> +/* AVERTV STUDIO 303 Remote */
> +
> +static struct ir_scancode avertv_303[] = {
> +	{ 0x2a, KEY_1 },
> +	{ 0x32, KEY_2 },
> +	{ 0x3a, KEY_3 },
> +	{ 0x4a, KEY_4 },
> +	{ 0x52, KEY_5 },
> +	{ 0x5a, KEY_6 },
> +	{ 0x6a, KEY_7 },
> +	{ 0x72, KEY_8 },
> +	{ 0x7a, KEY_9 },
> +	{ 0x0e, KEY_0 },
> +
> +	{ 0x02, KEY_POWER },
> +	{ 0x22, KEY_VIDEO },
> +	{ 0x42, KEY_AUDIO },
> +	{ 0x62, KEY_ZOOM },
> +	{ 0x0a, KEY_TV },
> +	{ 0x12, KEY_CD },
> +	{ 0x1a, KEY_TEXT },
> +
> +	{ 0x16, KEY_SUBTITLE },
> +	{ 0x1e, KEY_REWIND },
> +	{ 0x06, KEY_PRINT },
> +
> +	{ 0x2e, KEY_SEARCH },
> +	{ 0x36, KEY_SLEEP },
> +	{ 0x3e, KEY_SHUFFLE },
> +	{ 0x26, KEY_MUTE },
> +
> +	{ 0x4e, KEY_RECORD },
> +	{ 0x56, KEY_PAUSE },
> +	{ 0x5e, KEY_STOP },
> +	{ 0x46, KEY_PLAY },
> +
> +	{ 0x6e, KEY_RED },
> +	{ 0x0b, KEY_GREEN },
> +	{ 0x66, KEY_YELLOW },
> +	{ 0x03, KEY_BLUE },
> +
> +	{ 0x76, KEY_LEFT },
> +	{ 0x7e, KEY_RIGHT },
> +	{ 0x13, KEY_DOWN },
> +	{ 0x1b, KEY_UP },
> +};
> +
> +static struct rc_keymap avertv_303_map = {
> +	.map = {
> +		.scan    = avertv_303,
> +		.size    = ARRAY_SIZE(avertv_303),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_AVERTV_303,
> +	}
> +};
> +
> +static int __init init_rc_map_avertv_303(void)
> +{
> +	return ir_register_map(&avertv_303_map);
> +}
> +
> +static void __exit exit_rc_map_avertv_303(void)
> +{
> +	ir_unregister_map(&avertv_303_map);
> +}
> +
> +module_init(init_rc_map_avertv_303)
> +module_exit(exit_rc_map_avertv_303)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-behold-columbus.c b/drivers/media/IR/keymaps/rc-behold-columbus.c
> new file mode 100644
> index 0000000..9f56c98
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-behold-columbus.c
> @@ -0,0 +1,108 @@
> +/* behold-columbus.h - Keytable for behold_columbus Remote Controller
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
> +
> +/* Beholder Intl. Ltd. 2008
> + * Dmitry Belimov d.belimov@google.com
> + * Keytable is used by BeholdTV Columbus
> + * The "ascii-art picture" below (in comments, first row
> + * is the keycode in hex, and subsequent row(s) shows
> + * the button labels (several variants when appropriate)
> + * helps to descide which keycodes to assign to the buttons.
> + */
> +
> +static struct ir_scancode behold_columbus[] = {
> +
> +	/*  0x13   0x11   0x1C   0x12  *
> +	 *  Mute  Source  TV/FM  Power *
> +	 *                             */
> +
> +	{ 0x13, KEY_MUTE },
> +	{ 0x11, KEY_PROPS },
> +	{ 0x1C, KEY_TUNER },	/* KEY_TV/KEY_RADIO	*/
> +	{ 0x12, KEY_POWER },
> +
> +	/*  0x01    0x02    0x03  0x0D    *
> +	 *   1       2       3   Stereo   *
> +	 *                        	  *
> +	 *  0x04    0x05    0x06  0x19    *
> +	 *   4       5       6   Snapshot *
> +	 *                        	  *
> +	 *  0x07    0x08    0x09  0x10    *
> +	 *   7       8       9    Zoom 	  *
> +	 *                                */
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x0D, KEY_SETUP },	  /* Setup key */
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x19, KEY_CAMERA },	/* Snapshot key */
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +	{ 0x10, KEY_ZOOM },
> +
> +	/*  0x0A    0x00    0x0B       0x0C   *
> +	 * RECALL    0    ChannelUp  VolumeUp *
> +	 *                                    */
> +	{ 0x0A, KEY_AGAIN },
> +	{ 0x00, KEY_0 },
> +	{ 0x0B, KEY_CHANNELUP },
> +	{ 0x0C, KEY_VOLUMEUP },
> +
> +	/*   0x1B      0x1D      0x15        0x18     *
> +	 * Timeshift  Record  ChannelDown  VolumeDown *
> +	 *                                            */
> +
> +	{ 0x1B, KEY_TIME },
> +	{ 0x1D, KEY_RECORD },
> +	{ 0x15, KEY_CHANNELDOWN },
> +	{ 0x18, KEY_VOLUMEDOWN },
> +
> +	/*   0x0E   0x1E     0x0F     0x1A  *
> +	 *   Stop   Pause  Previouse  Next  *
> +	 *                                  */
> +
> +	{ 0x0E, KEY_STOP },
> +	{ 0x1E, KEY_PAUSE },
> +	{ 0x0F, KEY_PREVIOUS },
> +	{ 0x1A, KEY_NEXT },
> +
> +};
> +
> +static struct rc_keymap behold_columbus_map = {
> +	.map = {
> +		.scan    = behold_columbus,
> +		.size    = ARRAY_SIZE(behold_columbus),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_BEHOLD_COLUMBUS,
> +	}
> +};
> +
> +static int __init init_rc_map_behold_columbus(void)
> +{
> +	return ir_register_map(&behold_columbus_map);
> +}
> +
> +static void __exit exit_rc_map_behold_columbus(void)
> +{
> +	ir_unregister_map(&behold_columbus_map);
> +}
> +
> +module_init(init_rc_map_behold_columbus)
> +module_exit(exit_rc_map_behold_columbus)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-behold.c b/drivers/media/IR/keymaps/rc-behold.c
> new file mode 100644
> index 0000000..abc140b
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-behold.c
> @@ -0,0 +1,141 @@
> +/* behold.h - Keytable for behold Remote Controller
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
> +
> +/*
> + * Igor Kuznetsov <igk72@ya.ru>
> + * Andrey J. Melnikov <temnota@kmv.ru>
> + *
> + * Keytable is used by BeholdTV 60x series, M6 series at
> + * least, and probably other cards too.
> + * The "ascii-art picture" below (in comments, first row
> + * is the keycode in hex, and subsequent row(s) shows
> + * the button labels (several variants when appropriate)
> + * helps to descide which keycodes to assign to the buttons.
> + */
> +
> +static struct ir_scancode behold[] = {
> +
> +	/*  0x1c            0x12  *
> +	 *  TV/FM          POWER  *
> +	 *                        */
> +	{ 0x1c, KEY_TUNER },	/* XXX KEY_TV / KEY_RADIO */
> +	{ 0x12, KEY_POWER },
> +
> +	/*  0x01    0x02    0x03  *
> +	 *   1       2       3    *
> +	 *                        *
> +	 *  0x04    0x05    0x06  *
> +	 *   4       5       6    *
> +	 *                        *
> +	 *  0x07    0x08    0x09  *
> +	 *   7       8       9    *
> +	 *                        */
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	/*  0x0a    0x00    0x17  *
> +	 * RECALL    0      MODE  *
> +	 *                        */
> +	{ 0x0a, KEY_AGAIN },
> +	{ 0x00, KEY_0 },
> +	{ 0x17, KEY_MODE },
> +
> +	/*  0x14          0x10    *
> +	 * ASPECT      FULLSCREEN *
> +	 *                        */
> +	{ 0x14, KEY_SCREEN },
> +	{ 0x10, KEY_ZOOM },
> +
> +	/*          0x0b          *
> +	 *           Up           *
> +	 *                        *
> +	 *  0x18    0x16    0x0c  *
> +	 *  Left     Ok     Right *
> +	 *                        *
> +	 *         0x015          *
> +	 *         Down           *
> +	 *                        */
> +	{ 0x0b, KEY_CHANNELUP },
> +	{ 0x18, KEY_VOLUMEDOWN },
> +	{ 0x16, KEY_OK },		/* XXX KEY_ENTER */
> +	{ 0x0c, KEY_VOLUMEUP },
> +	{ 0x15, KEY_CHANNELDOWN },
> +
> +	/*  0x11            0x0d  *
> +	 *  MUTE            INFO  *
> +	 *                        */
> +	{ 0x11, KEY_MUTE },
> +	{ 0x0d, KEY_INFO },
> +
> +	/*  0x0f    0x1b    0x1a  *
> +	 * RECORD PLAY/PAUSE STOP *
> +	 *                        *
> +	 *  0x0e    0x1f    0x1e  *
> +	 *TELETEXT  AUDIO  SOURCE *
> +	 *           RED   YELLOW *
> +	 *                        */
> +	{ 0x0f, KEY_RECORD },
> +	{ 0x1b, KEY_PLAYPAUSE },
> +	{ 0x1a, KEY_STOP },
> +	{ 0x0e, KEY_TEXT },
> +	{ 0x1f, KEY_RED },	/*XXX KEY_AUDIO	*/
> +	{ 0x1e, KEY_YELLOW },	/*XXX KEY_SOURCE	*/
> +
> +	/*  0x1d   0x13     0x19  *
> +	 * SLEEP  PREVIEW   DVB   *
> +	 *         GREEN    BLUE  *
> +	 *                        */
> +	{ 0x1d, KEY_SLEEP },
> +	{ 0x13, KEY_GREEN },
> +	{ 0x19, KEY_BLUE },	/* XXX KEY_SAT	*/
> +
> +	/*  0x58           0x5c   *
> +	 * FREEZE        SNAPSHOT *
> +	 *                        */
> +	{ 0x58, KEY_SLOW },
> +	{ 0x5c, KEY_CAMERA },
> +
> +};
> +
> +static struct rc_keymap behold_map = {
> +	.map = {
> +		.scan    = behold,
> +		.size    = ARRAY_SIZE(behold),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_BEHOLD,
> +	}
> +};
> +
> +static int __init init_rc_map_behold(void)
> +{
> +	return ir_register_map(&behold_map);
> +}
> +
> +static void __exit exit_rc_map_behold(void)
> +{
> +	ir_unregister_map(&behold_map);
> +}
> +
> +module_init(init_rc_map_behold)
> +module_exit(exit_rc_map_behold)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-budget-ci-old.c b/drivers/media/IR/keymaps/rc-budget-ci-old.c
> new file mode 100644
> index 0000000..64c2ac9
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-budget-ci-old.c
> @@ -0,0 +1,92 @@
> +/* budget-ci-old.h - Keytable for budget_ci_old Remote Controller
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
> +
> +/* From reading the following remotes:
> + * Zenith Universal 7 / TV Mode 807 / VCR Mode 837
> + * Hauppauge (from NOVA-CI-s box product)
> + * This is a "middle of the road" approach, differences are noted
> + */
> +
> +static struct ir_scancode budget_ci_old[] = {
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +	{ 0x0a, KEY_ENTER },
> +	{ 0x0b, KEY_RED },
> +	{ 0x0c, KEY_POWER },		/* RADIO on Hauppauge */
> +	{ 0x0d, KEY_MUTE },
> +	{ 0x0f, KEY_A },		/* TV on Hauppauge */
> +	{ 0x10, KEY_VOLUMEUP },
> +	{ 0x11, KEY_VOLUMEDOWN },
> +	{ 0x14, KEY_B },
> +	{ 0x1c, KEY_UP },
> +	{ 0x1d, KEY_DOWN },
> +	{ 0x1e, KEY_OPTION },		/* RESERVED on Hauppauge */
> +	{ 0x1f, KEY_BREAK },
> +	{ 0x20, KEY_CHANNELUP },
> +	{ 0x21, KEY_CHANNELDOWN },
> +	{ 0x22, KEY_PREVIOUS },		/* Prev Ch on Zenith, SOURCE on Hauppauge */
> +	{ 0x24, KEY_RESTART },
> +	{ 0x25, KEY_OK },
> +	{ 0x26, KEY_CYCLEWINDOWS },	/* MINIMIZE on Hauppauge */
> +	{ 0x28, KEY_ENTER },		/* VCR mode on Zenith */
> +	{ 0x29, KEY_PAUSE },
> +	{ 0x2b, KEY_RIGHT },
> +	{ 0x2c, KEY_LEFT },
> +	{ 0x2e, KEY_MENU },		/* FULL SCREEN on Hauppauge */
> +	{ 0x30, KEY_SLOW },
> +	{ 0x31, KEY_PREVIOUS },		/* VCR mode on Zenith */
> +	{ 0x32, KEY_REWIND },
> +	{ 0x34, KEY_FASTFORWARD },
> +	{ 0x35, KEY_PLAY },
> +	{ 0x36, KEY_STOP },
> +	{ 0x37, KEY_RECORD },
> +	{ 0x38, KEY_TUNER },		/* TV/VCR on Zenith */
> +	{ 0x3a, KEY_C },
> +	{ 0x3c, KEY_EXIT },
> +	{ 0x3d, KEY_POWER2 },
> +	{ 0x3e, KEY_TUNER },
> +};
> +
> +static struct rc_keymap budget_ci_old_map = {
> +	.map = {
> +		.scan    = budget_ci_old,
> +		.size    = ARRAY_SIZE(budget_ci_old),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_BUDGET_CI_OLD,
> +	}
> +};
> +
> +static int __init init_rc_map_budget_ci_old(void)
> +{
> +	return ir_register_map(&budget_ci_old_map);
> +}
> +
> +static void __exit exit_rc_map_budget_ci_old(void)
> +{
> +	ir_unregister_map(&budget_ci_old_map);
> +}
> +
> +module_init(init_rc_map_budget_ci_old)
> +module_exit(exit_rc_map_budget_ci_old)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-cinergy-1400.c b/drivers/media/IR/keymaps/rc-cinergy-1400.c
> new file mode 100644
> index 0000000..074f2c2
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-cinergy-1400.c
> @@ -0,0 +1,84 @@
> +/* cinergy-1400.h - Keytable for cinergy_1400 Remote Controller
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
> +
> +/* Cinergy 1400 DVB-T */
> +
> +static struct ir_scancode cinergy_1400[] = {
> +	{ 0x01, KEY_POWER },
> +	{ 0x02, KEY_1 },
> +	{ 0x03, KEY_2 },
> +	{ 0x04, KEY_3 },
> +	{ 0x05, KEY_4 },
> +	{ 0x06, KEY_5 },
> +	{ 0x07, KEY_6 },
> +	{ 0x08, KEY_7 },
> +	{ 0x09, KEY_8 },
> +	{ 0x0a, KEY_9 },
> +	{ 0x0c, KEY_0 },
> +
> +	{ 0x0b, KEY_VIDEO },
> +	{ 0x0d, KEY_REFRESH },
> +	{ 0x0e, KEY_SELECT },
> +	{ 0x0f, KEY_EPG },
> +	{ 0x10, KEY_UP },
> +	{ 0x11, KEY_LEFT },
> +	{ 0x12, KEY_OK },
> +	{ 0x13, KEY_RIGHT },
> +	{ 0x14, KEY_DOWN },
> +	{ 0x15, KEY_TEXT },
> +	{ 0x16, KEY_INFO },
> +
> +	{ 0x17, KEY_RED },
> +	{ 0x18, KEY_GREEN },
> +	{ 0x19, KEY_YELLOW },
> +	{ 0x1a, KEY_BLUE },
> +
> +	{ 0x1b, KEY_CHANNELUP },
> +	{ 0x1c, KEY_VOLUMEUP },
> +	{ 0x1d, KEY_MUTE },
> +	{ 0x1e, KEY_VOLUMEDOWN },
> +	{ 0x1f, KEY_CHANNELDOWN },
> +
> +	{ 0x40, KEY_PAUSE },
> +	{ 0x4c, KEY_PLAY },
> +	{ 0x58, KEY_RECORD },
> +	{ 0x54, KEY_PREVIOUS },
> +	{ 0x48, KEY_STOP },
> +	{ 0x5c, KEY_NEXT },
> +};
> +
> +static struct rc_keymap cinergy_1400_map = {
> +	.map = {
> +		.scan    = cinergy_1400,
> +		.size    = ARRAY_SIZE(cinergy_1400),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_CINERGY_1400,
> +	}
> +};
> +
> +static int __init init_rc_map_cinergy_1400(void)
> +{
> +	return ir_register_map(&cinergy_1400_map);
> +}
> +
> +static void __exit exit_rc_map_cinergy_1400(void)
> +{
> +	ir_unregister_map(&cinergy_1400_map);
> +}
> +
> +module_init(init_rc_map_cinergy_1400)
> +module_exit(exit_rc_map_cinergy_1400)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-cinergy.c b/drivers/media/IR/keymaps/rc-cinergy.c
> new file mode 100644
> index 0000000..cf84c3d
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-cinergy.c
> @@ -0,0 +1,78 @@
> +/* cinergy.h - Keytable for cinergy Remote Controller
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
> +
> +static struct ir_scancode cinergy[] = {
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	{ 0x0a, KEY_POWER },
> +	{ 0x0b, KEY_PROG1 },		/* app */
> +	{ 0x0c, KEY_ZOOM },		/* zoom/fullscreen */
> +	{ 0x0d, KEY_CHANNELUP },	/* channel */
> +	{ 0x0e, KEY_CHANNELDOWN },	/* channel- */
> +	{ 0x0f, KEY_VOLUMEUP },
> +	{ 0x10, KEY_VOLUMEDOWN },
> +	{ 0x11, KEY_TUNER },		/* AV */
> +	{ 0x12, KEY_NUMLOCK },		/* -/-- */
> +	{ 0x13, KEY_AUDIO },		/* audio */
> +	{ 0x14, KEY_MUTE },
> +	{ 0x15, KEY_UP },
> +	{ 0x16, KEY_DOWN },
> +	{ 0x17, KEY_LEFT },
> +	{ 0x18, KEY_RIGHT },
> +	{ 0x19, BTN_LEFT, },
> +	{ 0x1a, BTN_RIGHT, },
> +	{ 0x1b, KEY_WWW },		/* text */
> +	{ 0x1c, KEY_REWIND },
> +	{ 0x1d, KEY_FORWARD },
> +	{ 0x1e, KEY_RECORD },
> +	{ 0x1f, KEY_PLAY },
> +	{ 0x20, KEY_PREVIOUSSONG },
> +	{ 0x21, KEY_NEXTSONG },
> +	{ 0x22, KEY_PAUSE },
> +	{ 0x23, KEY_STOP },
> +};
> +
> +static struct rc_keymap cinergy_map = {
> +	.map = {
> +		.scan    = cinergy,
> +		.size    = ARRAY_SIZE(cinergy),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_CINERGY,
> +	}
> +};
> +
> +static int __init init_rc_map_cinergy(void)
> +{
> +	return ir_register_map(&cinergy_map);
> +}
> +
> +static void __exit exit_rc_map_cinergy(void)
> +{
> +	ir_unregister_map(&cinergy_map);
> +}
> +
> +module_init(init_rc_map_cinergy)
> +module_exit(exit_rc_map_cinergy)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-dm1105-nec.c b/drivers/media/IR/keymaps/rc-dm1105-nec.c
> new file mode 100644
> index 0000000..90684d0
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-dm1105-nec.c
> @@ -0,0 +1,76 @@
> +/* dm1105-nec.h - Keytable for dm1105_nec Remote Controller
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
> +
> +/* DVBWorld remotes
> +   Igor M. Liplianin <liplianin@me.by>
> + */
> +
> +static struct ir_scancode dm1105_nec[] = {
> +	{ 0x0a, KEY_POWER2},		/* power */
> +	{ 0x0c, KEY_MUTE},		/* mute */
> +	{ 0x11, KEY_1},
> +	{ 0x12, KEY_2},
> +	{ 0x13, KEY_3},
> +	{ 0x14, KEY_4},
> +	{ 0x15, KEY_5},
> +	{ 0x16, KEY_6},
> +	{ 0x17, KEY_7},
> +	{ 0x18, KEY_8},
> +	{ 0x19, KEY_9},
> +	{ 0x10, KEY_0},
> +	{ 0x1c, KEY_CHANNELUP},		/* ch+ */
> +	{ 0x0f, KEY_CHANNELDOWN},	/* ch- */
> +	{ 0x1a, KEY_VOLUMEUP},		/* vol+ */
> +	{ 0x0e, KEY_VOLUMEDOWN},	/* vol- */
> +	{ 0x04, KEY_RECORD},		/* rec */
> +	{ 0x09, KEY_CHANNEL},		/* fav */
> +	{ 0x08, KEY_BACKSPACE},		/* rewind */
> +	{ 0x07, KEY_FASTFORWARD},	/* fast */
> +	{ 0x0b, KEY_PAUSE},		/* pause */
> +	{ 0x02, KEY_ESC},		/* cancel */
> +	{ 0x03, KEY_TAB},		/* tab */
> +	{ 0x00, KEY_UP},		/* up */
> +	{ 0x1f, KEY_ENTER},		/* ok */
> +	{ 0x01, KEY_DOWN},		/* down */
> +	{ 0x05, KEY_RECORD},		/* cap */
> +	{ 0x06, KEY_STOP},		/* stop */
> +	{ 0x40, KEY_ZOOM},		/* full */
> +	{ 0x1e, KEY_TV},		/* tvmode */
> +	{ 0x1b, KEY_B},			/* recall */
> +};
> +
> +static struct rc_keymap dm1105_nec_map = {
> +	.map = {
> +		.scan    = dm1105_nec,
> +		.size    = ARRAY_SIZE(dm1105_nec),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_DM1105_NEC,
> +	}
> +};
> +
> +static int __init init_rc_map_dm1105_nec(void)
> +{
> +	return ir_register_map(&dm1105_nec_map);
> +}
> +
> +static void __exit exit_rc_map_dm1105_nec(void)
> +{
> +	ir_unregister_map(&dm1105_nec_map);
> +}
> +
> +module_init(init_rc_map_dm1105_nec)
> +module_exit(exit_rc_map_dm1105_nec)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
> new file mode 100644
> index 0000000..8a4027a
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-dntv-live-dvb-t.c
> @@ -0,0 +1,78 @@
> +/* dntv-live-dvb-t.h - Keytable for dntv_live_dvb_t Remote Controller
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
> +
> +/* DigitalNow DNTV Live DVB-T Remote */
> +
> +static struct ir_scancode dntv_live_dvb_t[] = {
> +	{ 0x00, KEY_ESC },		/* 'go up a level?' */
> +	/* Keys 0 to 9 */
> +	{ 0x0a, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	{ 0x0b, KEY_TUNER },		/* tv/fm */
> +	{ 0x0c, KEY_SEARCH },		/* scan */
> +	{ 0x0d, KEY_STOP },
> +	{ 0x0e, KEY_PAUSE },
> +	{ 0x0f, KEY_LIST },		/* source */
> +
> +	{ 0x10, KEY_MUTE },
> +	{ 0x11, KEY_REWIND },		/* backward << */
> +	{ 0x12, KEY_POWER },
> +	{ 0x13, KEY_CAMERA },		/* snap */
> +	{ 0x14, KEY_AUDIO },		/* stereo */
> +	{ 0x15, KEY_CLEAR },		/* reset */
> +	{ 0x16, KEY_PLAY },
> +	{ 0x17, KEY_ENTER },
> +	{ 0x18, KEY_ZOOM },		/* full screen */
> +	{ 0x19, KEY_FASTFORWARD },	/* forward >> */
> +	{ 0x1a, KEY_CHANNELUP },
> +	{ 0x1b, KEY_VOLUMEUP },
> +	{ 0x1c, KEY_INFO },		/* preview */
> +	{ 0x1d, KEY_RECORD },		/* record */
> +	{ 0x1e, KEY_CHANNELDOWN },
> +	{ 0x1f, KEY_VOLUMEDOWN },
> +};
> +
> +static struct rc_keymap dntv_live_dvb_t_map = {
> +	.map = {
> +		.scan    = dntv_live_dvb_t,
> +		.size    = ARRAY_SIZE(dntv_live_dvb_t),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_DNTV_LIVE_DVB_T,
> +	}
> +};
> +
> +static int __init init_rc_map_dntv_live_dvb_t(void)
> +{
> +	return ir_register_map(&dntv_live_dvb_t_map);
> +}
> +
> +static void __exit exit_rc_map_dntv_live_dvb_t(void)
> +{
> +	ir_unregister_map(&dntv_live_dvb_t_map);
> +}
> +
> +module_init(init_rc_map_dntv_live_dvb_t)
> +module_exit(exit_rc_map_dntv_live_dvb_t)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
> new file mode 100644
> index 0000000..6f4d607
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-dntv-live-dvbt-pro.c
> @@ -0,0 +1,97 @@
> +/* dntv-live-dvbt-pro.h - Keytable for dntv_live_dvbt_pro Remote Controller
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
> +
> +/* DigitalNow DNTV Live! DVB-T Pro Remote */
> +
> +static struct ir_scancode dntv_live_dvbt_pro[] = {
> +	{ 0x16, KEY_POWER },
> +	{ 0x5b, KEY_HOME },
> +
> +	{ 0x55, KEY_TV },		/* live tv */
> +	{ 0x58, KEY_TUNER },		/* digital Radio */
> +	{ 0x5a, KEY_RADIO },		/* FM radio */
> +	{ 0x59, KEY_DVD },		/* dvd menu */
> +	{ 0x03, KEY_1 },
> +	{ 0x01, KEY_2 },
> +	{ 0x06, KEY_3 },
> +	{ 0x09, KEY_4 },
> +	{ 0x1d, KEY_5 },
> +	{ 0x1f, KEY_6 },
> +	{ 0x0d, KEY_7 },
> +	{ 0x19, KEY_8 },
> +	{ 0x1b, KEY_9 },
> +	{ 0x0c, KEY_CANCEL },
> +	{ 0x15, KEY_0 },
> +	{ 0x4a, KEY_CLEAR },
> +	{ 0x13, KEY_BACK },
> +	{ 0x00, KEY_TAB },
> +	{ 0x4b, KEY_UP },
> +	{ 0x4e, KEY_LEFT },
> +	{ 0x4f, KEY_OK },
> +	{ 0x52, KEY_RIGHT },
> +	{ 0x51, KEY_DOWN },
> +	{ 0x1e, KEY_VOLUMEUP },
> +	{ 0x0a, KEY_VOLUMEDOWN },
> +	{ 0x02, KEY_CHANNELDOWN },
> +	{ 0x05, KEY_CHANNELUP },
> +	{ 0x11, KEY_RECORD },
> +	{ 0x14, KEY_PLAY },
> +	{ 0x4c, KEY_PAUSE },
> +	{ 0x1a, KEY_STOP },
> +	{ 0x40, KEY_REWIND },
> +	{ 0x12, KEY_FASTFORWARD },
> +	{ 0x41, KEY_PREVIOUSSONG },	/* replay |< */
> +	{ 0x42, KEY_NEXTSONG },		/* skip >| */
> +	{ 0x54, KEY_CAMERA },		/* capture */
> +	{ 0x50, KEY_LANGUAGE },		/* sap */
> +	{ 0x47, KEY_TV2 },		/* pip */
> +	{ 0x4d, KEY_SCREEN },
> +	{ 0x43, KEY_SUBTITLE },
> +	{ 0x10, KEY_MUTE },
> +	{ 0x49, KEY_AUDIO },		/* l/r */
> +	{ 0x07, KEY_SLEEP },
> +	{ 0x08, KEY_VIDEO },		/* a/v */
> +	{ 0x0e, KEY_PREVIOUS },		/* recall */
> +	{ 0x45, KEY_ZOOM },		/* zoom + */
> +	{ 0x46, KEY_ANGLE },		/* zoom - */
> +	{ 0x56, KEY_RED },
> +	{ 0x57, KEY_GREEN },
> +	{ 0x5c, KEY_YELLOW },
> +	{ 0x5d, KEY_BLUE },
> +};
> +
> +static struct rc_keymap dntv_live_dvbt_pro_map = {
> +	.map = {
> +		.scan    = dntv_live_dvbt_pro,
> +		.size    = ARRAY_SIZE(dntv_live_dvbt_pro),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_DNTV_LIVE_DVBT_PRO,
> +	}
> +};
> +
> +static int __init init_rc_map_dntv_live_dvbt_pro(void)
> +{
> +	return ir_register_map(&dntv_live_dvbt_pro_map);
> +}
> +
> +static void __exit exit_rc_map_dntv_live_dvbt_pro(void)
> +{
> +	ir_unregister_map(&dntv_live_dvbt_pro_map);
> +}
> +
> +module_init(init_rc_map_dntv_live_dvbt_pro)
> +module_exit(exit_rc_map_dntv_live_dvbt_pro)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-em-terratec.c b/drivers/media/IR/keymaps/rc-em-terratec.c
> new file mode 100644
> index 0000000..3130c9c
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-em-terratec.c
> @@ -0,0 +1,69 @@
> +/* em-terratec.h - Keytable for em_terratec Remote Controller
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
> +
> +static struct ir_scancode em_terratec[] = {
> +	{ 0x01, KEY_CHANNEL },
> +	{ 0x02, KEY_SELECT },
> +	{ 0x03, KEY_MUTE },
> +	{ 0x04, KEY_POWER },
> +	{ 0x05, KEY_1 },
> +	{ 0x06, KEY_2 },
> +	{ 0x07, KEY_3 },
> +	{ 0x08, KEY_CHANNELUP },
> +	{ 0x09, KEY_4 },
> +	{ 0x0a, KEY_5 },
> +	{ 0x0b, KEY_6 },
> +	{ 0x0c, KEY_CHANNELDOWN },
> +	{ 0x0d, KEY_7 },
> +	{ 0x0e, KEY_8 },
> +	{ 0x0f, KEY_9 },
> +	{ 0x10, KEY_VOLUMEUP },
> +	{ 0x11, KEY_0 },
> +	{ 0x12, KEY_MENU },
> +	{ 0x13, KEY_PRINT },
> +	{ 0x14, KEY_VOLUMEDOWN },
> +	{ 0x16, KEY_PAUSE },
> +	{ 0x18, KEY_RECORD },
> +	{ 0x19, KEY_REWIND },
> +	{ 0x1a, KEY_PLAY },
> +	{ 0x1b, KEY_FORWARD },
> +	{ 0x1c, KEY_BACKSPACE },
> +	{ 0x1e, KEY_STOP },
> +	{ 0x40, KEY_ZOOM },
> +};
> +
> +static struct rc_keymap em_terratec_map = {
> +	.map = {
> +		.scan    = em_terratec,
> +		.size    = ARRAY_SIZE(em_terratec),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_EM_TERRATEC,
> +	}
> +};
> +
> +static int __init init_rc_map_em_terratec(void)
> +{
> +	return ir_register_map(&em_terratec_map);
> +}
> +
> +static void __exit exit_rc_map_em_terratec(void)
> +{
> +	ir_unregister_map(&em_terratec_map);
> +}
> +
> +module_init(init_rc_map_em_terratec)
> +module_exit(exit_rc_map_em_terratec)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-empty.c b/drivers/media/IR/keymaps/rc-empty.c
> new file mode 100644
> index 0000000..3b338d8
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-empty.c
> @@ -0,0 +1,44 @@
> +/* empty.h - Keytable for empty Remote Controller
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
> +
> +/* empty keytable, can be used as placeholder for not-yet created keytables */
> +
> +static struct ir_scancode empty[] = {
> +	{ 0x2a, KEY_COFFEE },
> +};
> +
> +static struct rc_keymap empty_map = {
> +	.map = {
> +		.scan    = empty,
> +		.size    = ARRAY_SIZE(empty),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_EMPTY,
> +	}
> +};
> +
> +static int __init init_rc_map_empty(void)
> +{
> +	return ir_register_map(&empty_map);
> +}
> +
> +static void __exit exit_rc_map_empty(void)
> +{
> +	ir_unregister_map(&empty_map);
> +}
> +
> +module_init(init_rc_map_empty)
> +module_exit(exit_rc_map_empty)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-encore-enltv-fm53.c b/drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
> new file mode 100644
> index 0000000..4b81696
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-encore-enltv-fm53.c
> @@ -0,0 +1,81 @@
> +/* encore-enltv-fm53.h - Keytable for encore_enltv_fm53 Remote Controller
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
> +
> +/* Encore ENLTV-FM v5.3
> +   Mauro Carvalho Chehab <mchehab@infradead.org>
> + */
> +
> +static struct ir_scancode encore_enltv_fm53[] = {
> +	{ 0x10, KEY_POWER2},
> +	{ 0x06, KEY_MUTE},
> +
> +	{ 0x09, KEY_1},
> +	{ 0x1d, KEY_2},
> +	{ 0x1f, KEY_3},
> +	{ 0x19, KEY_4},
> +	{ 0x1b, KEY_5},
> +	{ 0x11, KEY_6},
> +	{ 0x17, KEY_7},
> +	{ 0x12, KEY_8},
> +	{ 0x16, KEY_9},
> +	{ 0x48, KEY_0},
> +
> +	{ 0x04, KEY_LIST},		/* -/-- */
> +	{ 0x40, KEY_LAST},		/* recall */
> +
> +	{ 0x02, KEY_MODE},		/* TV/AV */
> +	{ 0x05, KEY_CAMERA},		/* SNAPSHOT */
> +
> +	{ 0x4c, KEY_CHANNELUP},		/* UP */
> +	{ 0x00, KEY_CHANNELDOWN},	/* DOWN */
> +	{ 0x0d, KEY_VOLUMEUP},		/* RIGHT */
> +	{ 0x15, KEY_VOLUMEDOWN},	/* LEFT */
> +	{ 0x49, KEY_ENTER},		/* OK */
> +
> +	{ 0x54, KEY_RECORD},
> +	{ 0x4d, KEY_PLAY},		/* pause */
> +
> +	{ 0x1e, KEY_MENU},		/* video setting */
> +	{ 0x0e, KEY_RIGHT},		/* <- */
> +	{ 0x1a, KEY_LEFT},		/* -> */
> +
> +	{ 0x0a, KEY_CLEAR},		/* video default */
> +	{ 0x0c, KEY_ZOOM},		/* hide pannel */
> +	{ 0x47, KEY_SLEEP},		/* shutdown */
> +};
> +
> +static struct rc_keymap encore_enltv_fm53_map = {
> +	.map = {
> +		.scan    = encore_enltv_fm53,
> +		.size    = ARRAY_SIZE(encore_enltv_fm53),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_ENCORE_ENLTV_FM53,
> +	}
> +};
> +
> +static int __init init_rc_map_encore_enltv_fm53(void)
> +{
> +	return ir_register_map(&encore_enltv_fm53_map);
> +}
> +
> +static void __exit exit_rc_map_encore_enltv_fm53(void)
> +{
> +	ir_unregister_map(&encore_enltv_fm53_map);
> +}
> +
> +module_init(init_rc_map_encore_enltv_fm53)
> +module_exit(exit_rc_map_encore_enltv_fm53)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-encore-enltv.c b/drivers/media/IR/keymaps/rc-encore-enltv.c
> new file mode 100644
> index 0000000..9fabffd
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-encore-enltv.c
> @@ -0,0 +1,112 @@
> +/* encore-enltv.h - Keytable for encore_enltv Remote Controller
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
> +
> +/* Encore ENLTV-FM  - black plastic, white front cover with white glowing buttons
> +    Juan Pablo Sormani <sorman@gmail.com> */
> +
> +static struct ir_scancode encore_enltv[] = {
> +
> +	/* Power button does nothing, neither in Windows app,
> +	 although it sends data (used for BIOS wakeup?) */
> +	{ 0x0d, KEY_MUTE },
> +
> +	{ 0x1e, KEY_TV },
> +	{ 0x00, KEY_VIDEO },
> +	{ 0x01, KEY_AUDIO },		/* music */
> +	{ 0x02, KEY_MHP },		/* picture */
> +
> +	{ 0x1f, KEY_1 },
> +	{ 0x03, KEY_2 },
> +	{ 0x04, KEY_3 },
> +	{ 0x05, KEY_4 },
> +	{ 0x1c, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x1d, KEY_9 },
> +	{ 0x0a, KEY_0 },
> +
> +	{ 0x09, KEY_LIST },		/* -/-- */
> +	{ 0x0b, KEY_LAST },		/* recall */
> +
> +	{ 0x14, KEY_HOME },		/* win start menu */
> +	{ 0x15, KEY_EXIT },		/* exit */
> +	{ 0x16, KEY_CHANNELUP },	/* UP */
> +	{ 0x12, KEY_CHANNELDOWN },	/* DOWN */
> +	{ 0x0c, KEY_VOLUMEUP },		/* RIGHT */
> +	{ 0x17, KEY_VOLUMEDOWN },	/* LEFT */
> +
> +	{ 0x18, KEY_ENTER },		/* OK */
> +
> +	{ 0x0e, KEY_ESC },
> +	{ 0x13, KEY_CYCLEWINDOWS },	/* desktop */
> +	{ 0x11, KEY_TAB },
> +	{ 0x19, KEY_SWITCHVIDEOMODE },	/* switch */
> +
> +	{ 0x1a, KEY_MENU },
> +	{ 0x1b, KEY_ZOOM },		/* fullscreen */
> +	{ 0x44, KEY_TIME },		/* time shift */
> +	{ 0x40, KEY_MODE },		/* source */
> +
> +	{ 0x5a, KEY_RECORD },
> +	{ 0x42, KEY_PLAY },		/* play/pause */
> +	{ 0x45, KEY_STOP },
> +	{ 0x43, KEY_CAMERA },		/* camera icon */
> +
> +	{ 0x48, KEY_REWIND },
> +	{ 0x4a, KEY_FASTFORWARD },
> +	{ 0x49, KEY_PREVIOUS },
> +	{ 0x4b, KEY_NEXT },
> +
> +	{ 0x4c, KEY_FAVORITES },	/* tv wall */
> +	{ 0x4d, KEY_SOUND },		/* DVD sound */
> +	{ 0x4e, KEY_LANGUAGE },		/* DVD lang */
> +	{ 0x4f, KEY_TEXT },		/* DVD text */
> +
> +	{ 0x50, KEY_SLEEP },		/* shutdown */
> +	{ 0x51, KEY_MODE },		/* stereo > main */
> +	{ 0x52, KEY_SELECT },		/* stereo > sap */
> +	{ 0x53, KEY_PROG1 },		/* teletext */
> +
> +
> +	{ 0x59, KEY_RED },		/* AP1 */
> +	{ 0x41, KEY_GREEN },		/* AP2 */
> +	{ 0x47, KEY_YELLOW },		/* AP3 */
> +	{ 0x57, KEY_BLUE },		/* AP4 */
> +};
> +
> +static struct rc_keymap encore_enltv_map = {
> +	.map = {
> +		.scan    = encore_enltv,
> +		.size    = ARRAY_SIZE(encore_enltv),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_ENCORE_ENLTV,
> +	}
> +};
> +
> +static int __init init_rc_map_encore_enltv(void)
> +{
> +	return ir_register_map(&encore_enltv_map);
> +}
> +
> +static void __exit exit_rc_map_encore_enltv(void)
> +{
> +	ir_unregister_map(&encore_enltv_map);
> +}
> +
> +module_init(init_rc_map_encore_enltv)
> +module_exit(exit_rc_map_encore_enltv)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-encore-enltv2.c b/drivers/media/IR/keymaps/rc-encore-enltv2.c
> new file mode 100644
> index 0000000..efefd51
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-encore-enltv2.c
> @@ -0,0 +1,90 @@
> +/* encore-enltv2.h - Keytable for encore_enltv2 Remote Controller
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
> +
> +/* Encore ENLTV2-FM  - silver plastic - "Wand Media" written at the botton
> +    Mauro Carvalho Chehab <mchehab@infradead.org> */
> +
> +static struct ir_scancode encore_enltv2[] = {
> +	{ 0x4c, KEY_POWER2 },
> +	{ 0x4a, KEY_TUNER },
> +	{ 0x40, KEY_1 },
> +	{ 0x60, KEY_2 },
> +	{ 0x50, KEY_3 },
> +	{ 0x70, KEY_4 },
> +	{ 0x48, KEY_5 },
> +	{ 0x68, KEY_6 },
> +	{ 0x58, KEY_7 },
> +	{ 0x78, KEY_8 },
> +	{ 0x44, KEY_9 },
> +	{ 0x54, KEY_0 },
> +
> +	{ 0x64, KEY_LAST },		/* +100 */
> +	{ 0x4e, KEY_AGAIN },		/* Recall */
> +
> +	{ 0x6c, KEY_SWITCHVIDEOMODE },	/* Video Source */
> +	{ 0x5e, KEY_MENU },
> +	{ 0x56, KEY_SCREEN },
> +	{ 0x7a, KEY_SETUP },
> +
> +	{ 0x46, KEY_MUTE },
> +	{ 0x5c, KEY_MODE },		/* Stereo */
> +	{ 0x74, KEY_INFO },
> +	{ 0x7c, KEY_CLEAR },
> +
> +	{ 0x55, KEY_UP },
> +	{ 0x49, KEY_DOWN },
> +	{ 0x7e, KEY_LEFT },
> +	{ 0x59, KEY_RIGHT },
> +	{ 0x6a, KEY_ENTER },
> +
> +	{ 0x42, KEY_VOLUMEUP },
> +	{ 0x62, KEY_VOLUMEDOWN },
> +	{ 0x52, KEY_CHANNELUP },
> +	{ 0x72, KEY_CHANNELDOWN },
> +
> +	{ 0x41, KEY_RECORD },
> +	{ 0x51, KEY_CAMERA },		/* Snapshot */
> +	{ 0x75, KEY_TIME },		/* Timeshift */
> +	{ 0x71, KEY_TV2 },		/* PIP */
> +
> +	{ 0x45, KEY_REWIND },
> +	{ 0x6f, KEY_PAUSE },
> +	{ 0x7d, KEY_FORWARD },
> +	{ 0x79, KEY_STOP },
> +};
> +
> +static struct rc_keymap encore_enltv2_map = {
> +	.map = {
> +		.scan    = encore_enltv2,
> +		.size    = ARRAY_SIZE(encore_enltv2),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_ENCORE_ENLTV2,
> +	}
> +};
> +
> +static int __init init_rc_map_encore_enltv2(void)
> +{
> +	return ir_register_map(&encore_enltv2_map);
> +}
> +
> +static void __exit exit_rc_map_encore_enltv2(void)
> +{
> +	ir_unregister_map(&encore_enltv2_map);
> +}
> +
> +module_init(init_rc_map_encore_enltv2)
> +module_exit(exit_rc_map_encore_enltv2)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-evga-indtube.c b/drivers/media/IR/keymaps/rc-evga-indtube.c
> new file mode 100644
> index 0000000..3f3fb13
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-evga-indtube.c
> @@ -0,0 +1,61 @@
> +/* evga-indtube.h - Keytable for evga_indtube Remote Controller
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
> +
> +/* EVGA inDtube
> +   Devin Heitmueller <devin.heitmueller@gmail.com>
> + */
> +
> +static struct ir_scancode evga_indtube[] = {
> +	{ 0x12, KEY_POWER},
> +	{ 0x02, KEY_MODE},	/* TV */
> +	{ 0x14, KEY_MUTE},
> +	{ 0x1a, KEY_CHANNELUP},
> +	{ 0x16, KEY_TV2},	/* PIP */
> +	{ 0x1d, KEY_VOLUMEUP},
> +	{ 0x05, KEY_CHANNELDOWN},
> +	{ 0x0f, KEY_PLAYPAUSE},
> +	{ 0x19, KEY_VOLUMEDOWN},
> +	{ 0x1c, KEY_REWIND},
> +	{ 0x0d, KEY_RECORD},
> +	{ 0x18, KEY_FORWARD},
> +	{ 0x1e, KEY_PREVIOUS},
> +	{ 0x1b, KEY_STOP},
> +	{ 0x1f, KEY_NEXT},
> +	{ 0x13, KEY_CAMERA},
> +};
> +
> +static struct rc_keymap evga_indtube_map = {
> +	.map = {
> +		.scan    = evga_indtube,
> +		.size    = ARRAY_SIZE(evga_indtube),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_EVGA_INDTUBE,
> +	}
> +};
> +
> +static int __init init_rc_map_evga_indtube(void)
> +{
> +	return ir_register_map(&evga_indtube_map);
> +}
> +
> +static void __exit exit_rc_map_evga_indtube(void)
> +{
> +	ir_unregister_map(&evga_indtube_map);
> +}
> +
> +module_init(init_rc_map_evga_indtube)
> +module_exit(exit_rc_map_evga_indtube)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-eztv.c b/drivers/media/IR/keymaps/rc-eztv.c
> new file mode 100644
> index 0000000..660907a
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-eztv.c
> @@ -0,0 +1,96 @@
> +/* eztv.h - Keytable for eztv Remote Controller
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
> +
> +/* Alfons Geser <a.geser@cox.net>
> + * updates from Job D. R. Borges <jobdrb@ig.com.br> */
> +
> +static struct ir_scancode eztv[] = {
> +	{ 0x12, KEY_POWER },
> +	{ 0x01, KEY_TV },	/* DVR */
> +	{ 0x15, KEY_DVD },	/* DVD */
> +	{ 0x17, KEY_AUDIO },	/* music */
> +				/* DVR mode / DVD mode / music mode */
> +
> +	{ 0x1b, KEY_MUTE },	/* mute */
> +	{ 0x02, KEY_LANGUAGE },	/* MTS/SAP / audio / autoseek */
> +	{ 0x1e, KEY_SUBTITLE },	/* closed captioning / subtitle / seek */
> +	{ 0x16, KEY_ZOOM },	/* full screen */
> +	{ 0x1c, KEY_VIDEO },	/* video source / eject / delall */
> +	{ 0x1d, KEY_RESTART },	/* playback / angle / del */
> +	{ 0x2f, KEY_SEARCH },	/* scan / menu / playlist */
> +	{ 0x30, KEY_CHANNEL },	/* CH surfing / bookmark / memo */
> +
> +	{ 0x31, KEY_HELP },	/* help */
> +	{ 0x32, KEY_MODE },	/* num/memo */
> +	{ 0x33, KEY_ESC },	/* cancel */
> +
> +	{ 0x0c, KEY_UP },	/* up */
> +	{ 0x10, KEY_DOWN },	/* down */
> +	{ 0x08, KEY_LEFT },	/* left */
> +	{ 0x04, KEY_RIGHT },	/* right */
> +	{ 0x03, KEY_SELECT },	/* select */
> +
> +	{ 0x1f, KEY_REWIND },	/* rewind */
> +	{ 0x20, KEY_PLAYPAUSE },/* play/pause */
> +	{ 0x29, KEY_FORWARD },	/* forward */
> +	{ 0x14, KEY_AGAIN },	/* repeat */
> +	{ 0x2b, KEY_RECORD },	/* recording */
> +	{ 0x2c, KEY_STOP },	/* stop */
> +	{ 0x2d, KEY_PLAY },	/* play */
> +	{ 0x2e, KEY_CAMERA },	/* snapshot / shuffle */
> +
> +	{ 0x00, KEY_0 },
> +	{ 0x05, KEY_1 },
> +	{ 0x06, KEY_2 },
> +	{ 0x07, KEY_3 },
> +	{ 0x09, KEY_4 },
> +	{ 0x0a, KEY_5 },
> +	{ 0x0b, KEY_6 },
> +	{ 0x0d, KEY_7 },
> +	{ 0x0e, KEY_8 },
> +	{ 0x0f, KEY_9 },
> +
> +	{ 0x2a, KEY_VOLUMEUP },
> +	{ 0x11, KEY_VOLUMEDOWN },
> +	{ 0x18, KEY_CHANNELUP },/* CH.tracking up */
> +	{ 0x19, KEY_CHANNELDOWN },/* CH.tracking down */
> +
> +	{ 0x13, KEY_ENTER },	/* enter */
> +	{ 0x21, KEY_DOT },	/* . (decimal dot) */
> +};
> +
> +static struct rc_keymap eztv_map = {
> +	.map = {
> +		.scan    = eztv,
> +		.size    = ARRAY_SIZE(eztv),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_EZTV,
> +	}
> +};
> +
> +static int __init init_rc_map_eztv(void)
> +{
> +	return ir_register_map(&eztv_map);
> +}
> +
> +static void __exit exit_rc_map_eztv(void)
> +{
> +	ir_unregister_map(&eztv_map);
> +}
> +
> +module_init(init_rc_map_eztv)
> +module_exit(exit_rc_map_eztv)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-flydvb.c b/drivers/media/IR/keymaps/rc-flydvb.c
> new file mode 100644
> index 0000000..a173c81
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-flydvb.c
> @@ -0,0 +1,77 @@
> +/* flydvb.h - Keytable for flydvb Remote Controller
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
> +
> +static struct ir_scancode flydvb[] = {
> +	{ 0x01, KEY_ZOOM },		/* Full Screen */
> +	{ 0x00, KEY_POWER },		/* Power */
> +
> +	{ 0x03, KEY_1 },
> +	{ 0x04, KEY_2 },
> +	{ 0x05, KEY_3 },
> +	{ 0x07, KEY_4 },
> +	{ 0x08, KEY_5 },
> +	{ 0x09, KEY_6 },
> +	{ 0x0b, KEY_7 },
> +	{ 0x0c, KEY_8 },
> +	{ 0x0d, KEY_9 },
> +	{ 0x06, KEY_AGAIN },		/* Recall */
> +	{ 0x0f, KEY_0 },
> +	{ 0x10, KEY_MUTE },		/* Mute */
> +	{ 0x02, KEY_RADIO },		/* TV/Radio */
> +	{ 0x1b, KEY_LANGUAGE },		/* SAP (Second Audio Program) */
> +
> +	{ 0x14, KEY_VOLUMEUP },		/* VOL+ */
> +	{ 0x17, KEY_VOLUMEDOWN },	/* VOL- */
> +	{ 0x12, KEY_CHANNELUP },	/* CH+ */
> +	{ 0x13, KEY_CHANNELDOWN },	/* CH- */
> +	{ 0x1d, KEY_ENTER },		/* Enter */
> +
> +	{ 0x1a, KEY_MODE },		/* PIP */
> +	{ 0x18, KEY_TUNER },		/* Source */
> +
> +	{ 0x1e, KEY_RECORD },		/* Record/Pause */
> +	{ 0x15, KEY_ANGLE },		/* Swap (no label on key) */
> +	{ 0x1c, KEY_PAUSE },		/* Timeshift/Pause */
> +	{ 0x19, KEY_BACK },		/* Rewind << */
> +	{ 0x0a, KEY_PLAYPAUSE },	/* Play/Pause */
> +	{ 0x1f, KEY_FORWARD },		/* Forward >> */
> +	{ 0x16, KEY_PREVIOUS },		/* Back |<< */
> +	{ 0x11, KEY_STOP },		/* Stop */
> +	{ 0x0e, KEY_NEXT },		/* End >>| */
> +};
> +
> +static struct rc_keymap flydvb_map = {
> +	.map = {
> +		.scan    = flydvb,
> +		.size    = ARRAY_SIZE(flydvb),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_FLYDVB,
> +	}
> +};
> +
> +static int __init init_rc_map_flydvb(void)
> +{
> +	return ir_register_map(&flydvb_map);
> +}
> +
> +static void __exit exit_rc_map_flydvb(void)
> +{
> +	ir_unregister_map(&flydvb_map);
> +}
> +
> +module_init(init_rc_map_flydvb)
> +module_exit(exit_rc_map_flydvb)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-flyvideo.c b/drivers/media/IR/keymaps/rc-flyvideo.c
> new file mode 100644
> index 0000000..9c73043
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-flyvideo.c
> @@ -0,0 +1,70 @@
> +/* flyvideo.h - Keytable for flyvideo Remote Controller
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
> +
> +static struct ir_scancode flyvideo[] = {
> +	{ 0x0f, KEY_0 },
> +	{ 0x03, KEY_1 },
> +	{ 0x04, KEY_2 },
> +	{ 0x05, KEY_3 },
> +	{ 0x07, KEY_4 },
> +	{ 0x08, KEY_5 },
> +	{ 0x09, KEY_6 },
> +	{ 0x0b, KEY_7 },
> +	{ 0x0c, KEY_8 },
> +	{ 0x0d, KEY_9 },
> +
> +	{ 0x0e, KEY_MODE },	/* Air/Cable */
> +	{ 0x11, KEY_VIDEO },	/* Video */
> +	{ 0x15, KEY_AUDIO },	/* Audio */
> +	{ 0x00, KEY_POWER },	/* Power */
> +	{ 0x18, KEY_TUNER },	/* AV Source */
> +	{ 0x02, KEY_ZOOM },	/* Fullscreen */
> +	{ 0x1a, KEY_LANGUAGE },	/* Stereo */
> +	{ 0x1b, KEY_MUTE },	/* Mute */
> +	{ 0x14, KEY_VOLUMEUP },	/* Volume + */
> +	{ 0x17, KEY_VOLUMEDOWN },/* Volume - */
> +	{ 0x12, KEY_CHANNELUP },/* Channel + */
> +	{ 0x13, KEY_CHANNELDOWN },/* Channel - */
> +	{ 0x06, KEY_AGAIN },	/* Recall */
> +	{ 0x10, KEY_ENTER },	/* Enter */
> +
> +	{ 0x19, KEY_BACK },	/* Rewind  ( <<< ) */
> +	{ 0x1f, KEY_FORWARD },	/* Forward ( >>> ) */
> +	{ 0x0a, KEY_ANGLE },	/* no label, may be used as the PAUSE button */
> +};
> +
> +static struct rc_keymap flyvideo_map = {
> +	.map = {
> +		.scan    = flyvideo,
> +		.size    = ARRAY_SIZE(flyvideo),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_FLYVIDEO,
> +	}
> +};
> +
> +static int __init init_rc_map_flyvideo(void)
> +{
> +	return ir_register_map(&flyvideo_map);
> +}
> +
> +static void __exit exit_rc_map_flyvideo(void)
> +{
> +	ir_unregister_map(&flyvideo_map);
> +}
> +
> +module_init(init_rc_map_flyvideo)
> +module_exit(exit_rc_map_flyvideo)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-fusionhdtv-mce.c b/drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
> new file mode 100644
> index 0000000..cdb1038
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-fusionhdtv-mce.c
> @@ -0,0 +1,98 @@
> +/* fusionhdtv-mce.h - Keytable for fusionhdtv_mce Remote Controller
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
> +
> +/* DViCO FUSION HDTV MCE remote */
> +
> +static struct ir_scancode fusionhdtv_mce[] = {
> +
> +	{ 0x0b, KEY_1 },
> +	{ 0x17, KEY_2 },
> +	{ 0x1b, KEY_3 },
> +	{ 0x07, KEY_4 },
> +	{ 0x50, KEY_5 },
> +	{ 0x54, KEY_6 },
> +	{ 0x48, KEY_7 },
> +	{ 0x4c, KEY_8 },
> +	{ 0x58, KEY_9 },
> +	{ 0x03, KEY_0 },
> +
> +	{ 0x5e, KEY_OK },
> +	{ 0x51, KEY_UP },
> +	{ 0x53, KEY_DOWN },
> +	{ 0x5b, KEY_LEFT },
> +	{ 0x5f, KEY_RIGHT },
> +
> +	{ 0x02, KEY_TV },		/* Labeled DTV on remote */
> +	{ 0x0e, KEY_MP3 },
> +	{ 0x1a, KEY_DVD },
> +	{ 0x1e, KEY_FAVORITES },	/* Labeled CPF on remote */
> +	{ 0x16, KEY_SETUP },
> +	{ 0x46, KEY_POWER2 },		/* TV On/Off button on remote */
> +	{ 0x0a, KEY_EPG },		/* Labeled Guide on remote */
> +
> +	{ 0x49, KEY_BACK },
> +	{ 0x59, KEY_INFO },		/* Labeled MORE on remote */
> +	{ 0x4d, KEY_MENU },		/* Labeled DVDMENU on remote */
> +	{ 0x55, KEY_CYCLEWINDOWS },	/* Labeled ALT-TAB on remote */
> +
> +	{ 0x0f, KEY_PREVIOUSSONG },	/* Labeled |<< REPLAY on remote */
> +	{ 0x12, KEY_NEXTSONG },		/* Labeled >>| SKIP on remote */
> +	{ 0x42, KEY_ENTER },		/* Labeled START with a green
> +					   MS windows logo on remote */
> +
> +	{ 0x15, KEY_VOLUMEUP },
> +	{ 0x05, KEY_VOLUMEDOWN },
> +	{ 0x11, KEY_CHANNELUP },
> +	{ 0x09, KEY_CHANNELDOWN },
> +
> +	{ 0x52, KEY_CAMERA },
> +	{ 0x5a, KEY_TUNER },
> +	{ 0x19, KEY_OPEN },
> +
> +	{ 0x13, KEY_MODE },		/* 4:3 16:9 select */
> +	{ 0x1f, KEY_ZOOM },
> +
> +	{ 0x43, KEY_REWIND },
> +	{ 0x47, KEY_PLAYPAUSE },
> +	{ 0x4f, KEY_FASTFORWARD },
> +	{ 0x57, KEY_MUTE },
> +	{ 0x0d, KEY_STOP },
> +	{ 0x01, KEY_RECORD },
> +	{ 0x4e, KEY_POWER },
> +};
> +
> +static struct rc_keymap fusionhdtv_mce_map = {
> +	.map = {
> +		.scan    = fusionhdtv_mce,
> +		.size    = ARRAY_SIZE(fusionhdtv_mce),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_FUSIONHDTV_MCE,
> +	}
> +};
> +
> +static int __init init_rc_map_fusionhdtv_mce(void)
> +{
> +	return ir_register_map(&fusionhdtv_mce_map);
> +}
> +
> +static void __exit exit_rc_map_fusionhdtv_mce(void)
> +{
> +	ir_unregister_map(&fusionhdtv_mce_map);
> +}
> +
> +module_init(init_rc_map_fusionhdtv_mce)
> +module_exit(exit_rc_map_fusionhdtv_mce)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-gadmei-rm008z.c b/drivers/media/IR/keymaps/rc-gadmei-rm008z.c
> new file mode 100644
> index 0000000..c16c0d1
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-gadmei-rm008z.c
> @@ -0,0 +1,81 @@
> +/* gadmei-rm008z.h - Keytable for gadmei_rm008z Remote Controller
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
> +
> +/* GADMEI UTV330+ RM008Z remote
> +   Shine Liu <shinel@foxmail.com>
> + */
> +
> +static struct ir_scancode gadmei_rm008z[] = {
> +	{ 0x14, KEY_POWER2},		/* POWER OFF */
> +	{ 0x0c, KEY_MUTE},		/* MUTE */
> +
> +	{ 0x18, KEY_TV},		/* TV */
> +	{ 0x0e, KEY_VIDEO},		/* AV */
> +	{ 0x0b, KEY_AUDIO},		/* SV */
> +	{ 0x0f, KEY_RADIO},		/* FM */
> +
> +	{ 0x00, KEY_1},
> +	{ 0x01, KEY_2},
> +	{ 0x02, KEY_3},
> +	{ 0x03, KEY_4},
> +	{ 0x04, KEY_5},
> +	{ 0x05, KEY_6},
> +	{ 0x06, KEY_7},
> +	{ 0x07, KEY_8},
> +	{ 0x08, KEY_9},
> +	{ 0x09, KEY_0},
> +	{ 0x0a, KEY_INFO},		/* OSD */
> +	{ 0x1c, KEY_BACKSPACE},		/* LAST */
> +
> +	{ 0x0d, KEY_PLAY},		/* PLAY */
> +	{ 0x1e, KEY_CAMERA},		/* SNAPSHOT */
> +	{ 0x1a, KEY_RECORD},		/* RECORD */
> +	{ 0x17, KEY_STOP},		/* STOP */
> +
> +	{ 0x1f, KEY_UP},		/* UP */
> +	{ 0x44, KEY_DOWN},		/* DOWN */
> +	{ 0x46, KEY_TAB},		/* BACK */
> +	{ 0x4a, KEY_ZOOM},		/* FULLSECREEN */
> +
> +	{ 0x10, KEY_VOLUMEUP},		/* VOLUMEUP */
> +	{ 0x11, KEY_VOLUMEDOWN},	/* VOLUMEDOWN */
> +	{ 0x12, KEY_CHANNELUP},		/* CHANNELUP */
> +	{ 0x13, KEY_CHANNELDOWN},	/* CHANNELDOWN */
> +	{ 0x15, KEY_ENTER},		/* OK */
> +};
> +
> +static struct rc_keymap gadmei_rm008z_map = {
> +	.map = {
> +		.scan    = gadmei_rm008z,
> +		.size    = ARRAY_SIZE(gadmei_rm008z),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_GADMEI_RM008Z,
> +	}
> +};
> +
> +static int __init init_rc_map_gadmei_rm008z(void)
> +{
> +	return ir_register_map(&gadmei_rm008z_map);
> +}
> +
> +static void __exit exit_rc_map_gadmei_rm008z(void)
> +{
> +	ir_unregister_map(&gadmei_rm008z_map);
> +}
> +
> +module_init(init_rc_map_gadmei_rm008z)
> +module_exit(exit_rc_map_gadmei_rm008z)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
> new file mode 100644
> index 0000000..89f8e38
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-genius-tvgo-a11mce.c
> @@ -0,0 +1,84 @@
> +/* genius-tvgo-a11mce.h - Keytable for genius_tvgo_a11mce Remote Controller
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
> +
> +/*
> + * Remote control for the Genius TVGO A11MCE
> + * Adrian Pardini <pardo.bsso@gmail.com>
> + */
> +
> +static struct ir_scancode genius_tvgo_a11mce[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x48, KEY_0 },
> +	{ 0x09, KEY_1 },
> +	{ 0x1d, KEY_2 },
> +	{ 0x1f, KEY_3 },
> +	{ 0x19, KEY_4 },
> +	{ 0x1b, KEY_5 },
> +	{ 0x11, KEY_6 },
> +	{ 0x17, KEY_7 },
> +	{ 0x12, KEY_8 },
> +	{ 0x16, KEY_9 },
> +
> +	{ 0x54, KEY_RECORD },		/* recording */
> +	{ 0x06, KEY_MUTE },		/* mute */
> +	{ 0x10, KEY_POWER },
> +	{ 0x40, KEY_LAST },		/* recall */
> +	{ 0x4c, KEY_CHANNELUP },	/* channel / program + */
> +	{ 0x00, KEY_CHANNELDOWN },	/* channel / program - */
> +	{ 0x0d, KEY_VOLUMEUP },
> +	{ 0x15, KEY_VOLUMEDOWN },
> +	{ 0x4d, KEY_OK },		/* also labeled as Pause */
> +	{ 0x1c, KEY_ZOOM },		/* full screen and Stop*/
> +	{ 0x02, KEY_MODE },		/* AV Source or Rewind*/
> +	{ 0x04, KEY_LIST },		/* -/-- */
> +	/* small arrows above numbers */
> +	{ 0x1a, KEY_NEXT },		/* also Fast Forward */
> +	{ 0x0e, KEY_PREVIOUS },		/* also Rewind */
> +	/* these are in a rather non standard layout and have
> +	an alternate name written */
> +	{ 0x1e, KEY_UP },		/* Video Setting */
> +	{ 0x0a, KEY_DOWN },		/* Video Default */
> +	{ 0x05, KEY_CAMERA },		/* Snapshot */
> +	{ 0x0c, KEY_RIGHT },		/* Hide Panel */
> +	/* Four buttons without label */
> +	{ 0x49, KEY_RED },
> +	{ 0x0b, KEY_GREEN },
> +	{ 0x13, KEY_YELLOW },
> +	{ 0x50, KEY_BLUE },
> +};
> +
> +static struct rc_keymap genius_tvgo_a11mce_map = {
> +	.map = {
> +		.scan    = genius_tvgo_a11mce,
> +		.size    = ARRAY_SIZE(genius_tvgo_a11mce),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_GENIUS_TVGO_A11MCE,
> +	}
> +};
> +
> +static int __init init_rc_map_genius_tvgo_a11mce(void)
> +{
> +	return ir_register_map(&genius_tvgo_a11mce_map);
> +}
> +
> +static void __exit exit_rc_map_genius_tvgo_a11mce(void)
> +{
> +	ir_unregister_map(&genius_tvgo_a11mce_map);
> +}
> +
> +module_init(init_rc_map_genius_tvgo_a11mce)
> +module_exit(exit_rc_map_genius_tvgo_a11mce)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-gotview7135.c b/drivers/media/IR/keymaps/rc-gotview7135.c
> new file mode 100644
> index 0000000..52f025b
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-gotview7135.c
> @@ -0,0 +1,79 @@
> +/* gotview7135.h - Keytable for gotview7135 Remote Controller
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
> +
> +/* Mike Baikov <mike@baikov.com> */
> +
> +static struct ir_scancode gotview7135[] = {
> +
> +	{ 0x11, KEY_POWER },
> +	{ 0x35, KEY_TV },
> +	{ 0x1b, KEY_0 },
> +	{ 0x29, KEY_1 },
> +	{ 0x19, KEY_2 },
> +	{ 0x39, KEY_3 },
> +	{ 0x1f, KEY_4 },
> +	{ 0x2c, KEY_5 },
> +	{ 0x21, KEY_6 },
> +	{ 0x24, KEY_7 },
> +	{ 0x18, KEY_8 },
> +	{ 0x2b, KEY_9 },
> +	{ 0x3b, KEY_AGAIN },	/* LOOP */
> +	{ 0x06, KEY_AUDIO },
> +	{ 0x31, KEY_PRINT },	/* PREVIEW */
> +	{ 0x3e, KEY_VIDEO },
> +	{ 0x10, KEY_CHANNELUP },
> +	{ 0x20, KEY_CHANNELDOWN },
> +	{ 0x0c, KEY_VOLUMEDOWN },
> +	{ 0x28, KEY_VOLUMEUP },
> +	{ 0x08, KEY_MUTE },
> +	{ 0x26, KEY_SEARCH },	/* SCAN */
> +	{ 0x3f, KEY_CAMERA },	/* SNAPSHOT */
> +	{ 0x12, KEY_RECORD },
> +	{ 0x32, KEY_STOP },
> +	{ 0x3c, KEY_PLAY },
> +	{ 0x1d, KEY_REWIND },
> +	{ 0x2d, KEY_PAUSE },
> +	{ 0x0d, KEY_FORWARD },
> +	{ 0x05, KEY_ZOOM },	/*FULL*/
> +
> +	{ 0x2a, KEY_F21 },	/* LIVE TIMESHIFT */
> +	{ 0x0e, KEY_F22 },	/* MIN TIMESHIFT */
> +	{ 0x1e, KEY_TIME },	/* TIMESHIFT */
> +	{ 0x38, KEY_F24 },	/* NORMAL TIMESHIFT */
> +};
> +
> +static struct rc_keymap gotview7135_map = {
> +	.map = {
> +		.scan    = gotview7135,
> +		.size    = ARRAY_SIZE(gotview7135),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_GOTVIEW7135,
> +	}
> +};
> +
> +static int __init init_rc_map_gotview7135(void)
> +{
> +	return ir_register_map(&gotview7135_map);
> +}
> +
> +static void __exit exit_rc_map_gotview7135(void)
> +{
> +	ir_unregister_map(&gotview7135_map);
> +}
> +
> +module_init(init_rc_map_gotview7135)
> +module_exit(exit_rc_map_gotview7135)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-hauppauge-new.c b/drivers/media/IR/keymaps/rc-hauppauge-new.c
> new file mode 100644
> index 0000000..c6f8cd7
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-hauppauge-new.c
> @@ -0,0 +1,100 @@
> +/* hauppauge-new.h - Keytable for hauppauge_new Remote Controller
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
> +
> +/* Hauppauge: the newer, gray remotes (seems there are multiple
> + * slightly different versions), shipped with cx88+ivtv cards.
> + * almost rc5 coding, but some non-standard keys */
> +
> +static struct ir_scancode hauppauge_new[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	{ 0x0a, KEY_TEXT },		/* keypad asterisk as well */
> +	{ 0x0b, KEY_RED },		/* red button */
> +	{ 0x0c, KEY_RADIO },
> +	{ 0x0d, KEY_MENU },
> +	{ 0x0e, KEY_SUBTITLE },		/* also the # key */
> +	{ 0x0f, KEY_MUTE },
> +	{ 0x10, KEY_VOLUMEUP },
> +	{ 0x11, KEY_VOLUMEDOWN },
> +	{ 0x12, KEY_PREVIOUS },		/* previous channel */
> +	{ 0x14, KEY_UP },
> +	{ 0x15, KEY_DOWN },
> +	{ 0x16, KEY_LEFT },
> +	{ 0x17, KEY_RIGHT },
> +	{ 0x18, KEY_VIDEO },		/* Videos */
> +	{ 0x19, KEY_AUDIO },		/* Music */
> +	/* 0x1a: Pictures - presume this means
> +	   "Multimedia Home Platform" -
> +	   no "PICTURES" key in input.h
> +	 */
> +	{ 0x1a, KEY_MHP },
> +
> +	{ 0x1b, KEY_EPG },		/* Guide */
> +	{ 0x1c, KEY_TV },
> +	{ 0x1e, KEY_NEXTSONG },		/* skip >| */
> +	{ 0x1f, KEY_EXIT },		/* back/exit */
> +	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
> +	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
> +	{ 0x22, KEY_CHANNEL },		/* source (old black remote) */
> +	{ 0x24, KEY_PREVIOUSSONG },	/* replay |< */
> +	{ 0x25, KEY_ENTER },		/* OK */
> +	{ 0x26, KEY_SLEEP },		/* minimize (old black remote) */
> +	{ 0x29, KEY_BLUE },		/* blue key */
> +	{ 0x2e, KEY_GREEN },		/* green button */
> +	{ 0x30, KEY_PAUSE },		/* pause */
> +	{ 0x32, KEY_REWIND },		/* backward << */
> +	{ 0x34, KEY_FASTFORWARD },	/* forward >> */
> +	{ 0x35, KEY_PLAY },
> +	{ 0x36, KEY_STOP },
> +	{ 0x37, KEY_RECORD },		/* recording */
> +	{ 0x38, KEY_YELLOW },		/* yellow key */
> +	{ 0x3b, KEY_SELECT },		/* top right button */
> +	{ 0x3c, KEY_ZOOM },		/* full */
> +	{ 0x3d, KEY_POWER },		/* system power (green button) */
> +};
> +
> +static struct rc_keymap hauppauge_new_map = {
> +	.map = {
> +		.scan    = hauppauge_new,
> +		.size    = ARRAY_SIZE(hauppauge_new),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_HAUPPAUGE_NEW,
> +	}
> +};
> +
> +static int __init init_rc_map_hauppauge_new(void)
> +{
> +	return ir_register_map(&hauppauge_new_map);
> +}
> +
> +static void __exit exit_rc_map_hauppauge_new(void)
> +{
> +	ir_unregister_map(&hauppauge_new_map);
> +}
> +
> +module_init(init_rc_map_hauppauge_new)
> +module_exit(exit_rc_map_hauppauge_new)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-iodata-bctv7e.c b/drivers/media/IR/keymaps/rc-iodata-bctv7e.c
> new file mode 100644
> index 0000000..ef66002
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-iodata-bctv7e.c
> @@ -0,0 +1,88 @@
> +/* iodata-bctv7e.h - Keytable for iodata_bctv7e Remote Controller
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
> +
> +/* IO-DATA BCTV7E Remote */
> +
> +static struct ir_scancode iodata_bctv7e[] = {
> +	{ 0x40, KEY_TV },
> +	{ 0x20, KEY_RADIO },		/* FM */
> +	{ 0x60, KEY_EPG },
> +	{ 0x00, KEY_POWER },
> +
> +	/* Keys 0 to 9 */
> +	{ 0x44, KEY_0 },		/* 10 */
> +	{ 0x50, KEY_1 },
> +	{ 0x30, KEY_2 },
> +	{ 0x70, KEY_3 },
> +	{ 0x48, KEY_4 },
> +	{ 0x28, KEY_5 },
> +	{ 0x68, KEY_6 },
> +	{ 0x58, KEY_7 },
> +	{ 0x38, KEY_8 },
> +	{ 0x78, KEY_9 },
> +
> +	{ 0x10, KEY_L },		/* Live */
> +	{ 0x08, KEY_TIME },		/* Time Shift */
> +
> +	{ 0x18, KEY_PLAYPAUSE },	/* Play */
> +
> +	{ 0x24, KEY_ENTER },		/* 11 */
> +	{ 0x64, KEY_ESC },		/* 12 */
> +	{ 0x04, KEY_M },		/* Multi */
> +
> +	{ 0x54, KEY_VIDEO },
> +	{ 0x34, KEY_CHANNELUP },
> +	{ 0x74, KEY_VOLUMEUP },
> +	{ 0x14, KEY_MUTE },
> +
> +	{ 0x4c, KEY_VCR },		/* SVIDEO */
> +	{ 0x2c, KEY_CHANNELDOWN },
> +	{ 0x6c, KEY_VOLUMEDOWN },
> +	{ 0x0c, KEY_ZOOM },
> +
> +	{ 0x5c, KEY_PAUSE },
> +	{ 0x3c, KEY_RED },		/* || (red) */
> +	{ 0x7c, KEY_RECORD },		/* recording */
> +	{ 0x1c, KEY_STOP },
> +
> +	{ 0x41, KEY_REWIND },		/* backward << */
> +	{ 0x21, KEY_PLAY },
> +	{ 0x61, KEY_FASTFORWARD },	/* forward >> */
> +	{ 0x01, KEY_NEXT },		/* skip >| */
> +};
> +
> +static struct rc_keymap iodata_bctv7e_map = {
> +	.map = {
> +		.scan    = iodata_bctv7e,
> +		.size    = ARRAY_SIZE(iodata_bctv7e),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_IODATA_BCTV7E,
> +	}
> +};
> +
> +static int __init init_rc_map_iodata_bctv7e(void)
> +{
> +	return ir_register_map(&iodata_bctv7e_map);
> +}
> +
> +static void __exit exit_rc_map_iodata_bctv7e(void)
> +{
> +	ir_unregister_map(&iodata_bctv7e_map);
> +}
> +
> +module_init(init_rc_map_iodata_bctv7e)
> +module_exit(exit_rc_map_iodata_bctv7e)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-kaiomy.c b/drivers/media/IR/keymaps/rc-kaiomy.c
> new file mode 100644
> index 0000000..4c7883b
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-kaiomy.c
> @@ -0,0 +1,87 @@
> +/* kaiomy.h - Keytable for kaiomy Remote Controller
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
> +
> +/* Kaiomy TVnPC U2
> +   Mauro Carvalho Chehab <mchehab@infradead.org>
> + */
> +
> +static struct ir_scancode kaiomy[] = {
> +	{ 0x43, KEY_POWER2},
> +	{ 0x01, KEY_LIST},
> +	{ 0x0b, KEY_ZOOM},
> +	{ 0x03, KEY_POWER},
> +
> +	{ 0x04, KEY_1},
> +	{ 0x08, KEY_2},
> +	{ 0x02, KEY_3},
> +
> +	{ 0x0f, KEY_4},
> +	{ 0x05, KEY_5},
> +	{ 0x06, KEY_6},
> +
> +	{ 0x0c, KEY_7},
> +	{ 0x0d, KEY_8},
> +	{ 0x0a, KEY_9},
> +
> +	{ 0x11, KEY_0},
> +
> +	{ 0x09, KEY_CHANNELUP},
> +	{ 0x07, KEY_CHANNELDOWN},
> +
> +	{ 0x0e, KEY_VOLUMEUP},
> +	{ 0x13, KEY_VOLUMEDOWN},
> +
> +	{ 0x10, KEY_HOME},
> +	{ 0x12, KEY_ENTER},
> +
> +	{ 0x14, KEY_RECORD},
> +	{ 0x15, KEY_STOP},
> +	{ 0x16, KEY_PLAY},
> +	{ 0x17, KEY_MUTE},
> +
> +	{ 0x18, KEY_UP},
> +	{ 0x19, KEY_DOWN},
> +	{ 0x1a, KEY_LEFT},
> +	{ 0x1b, KEY_RIGHT},
> +
> +	{ 0x1c, KEY_RED},
> +	{ 0x1d, KEY_GREEN},
> +	{ 0x1e, KEY_YELLOW},
> +	{ 0x1f, KEY_BLUE},
> +};
> +
> +static struct rc_keymap kaiomy_map = {
> +	.map = {
> +		.scan    = kaiomy,
> +		.size    = ARRAY_SIZE(kaiomy),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_KAIOMY,
> +	}
> +};
> +
> +static int __init init_rc_map_kaiomy(void)
> +{
> +	return ir_register_map(&kaiomy_map);
> +}
> +
> +static void __exit exit_rc_map_kaiomy(void)
> +{
> +	ir_unregister_map(&kaiomy_map);
> +}
> +
> +module_init(init_rc_map_kaiomy)
> +module_exit(exit_rc_map_kaiomy)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-kworld-315u.c b/drivers/media/IR/keymaps/rc-kworld-315u.c
> new file mode 100644
> index 0000000..618c817
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-kworld-315u.c
> @@ -0,0 +1,83 @@
> +/* kworld-315u.h - Keytable for kworld_315u Remote Controller
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
> +
> +/* Kworld 315U
> + */
> +
> +static struct ir_scancode kworld_315u[] = {
> +	{ 0x6143, KEY_POWER },
> +	{ 0x6101, KEY_TUNER },		/* source */
> +	{ 0x610b, KEY_ZOOM },
> +	{ 0x6103, KEY_POWER2 },		/* shutdown */
> +
> +	{ 0x6104, KEY_1 },
> +	{ 0x6108, KEY_2 },
> +	{ 0x6102, KEY_3 },
> +	{ 0x6109, KEY_CHANNELUP },
> +
> +	{ 0x610f, KEY_4 },
> +	{ 0x6105, KEY_5 },
> +	{ 0x6106, KEY_6 },
> +	{ 0x6107, KEY_CHANNELDOWN },
> +
> +	{ 0x610c, KEY_7 },
> +	{ 0x610d, KEY_8 },
> +	{ 0x610a, KEY_9 },
> +	{ 0x610e, KEY_VOLUMEUP },
> +
> +	{ 0x6110, KEY_LAST },
> +	{ 0x6111, KEY_0 },
> +	{ 0x6112, KEY_ENTER },
> +	{ 0x6113, KEY_VOLUMEDOWN },
> +
> +	{ 0x6114, KEY_RECORD },
> +	{ 0x6115, KEY_STOP },
> +	{ 0x6116, KEY_PLAY },
> +	{ 0x6117, KEY_MUTE },
> +
> +	{ 0x6118, KEY_UP },
> +	{ 0x6119, KEY_DOWN },
> +	{ 0x611a, KEY_LEFT },
> +	{ 0x611b, KEY_RIGHT },
> +
> +	{ 0x611c, KEY_RED },
> +	{ 0x611d, KEY_GREEN },
> +	{ 0x611e, KEY_YELLOW },
> +	{ 0x611f, KEY_BLUE },
> +};
> +
> +static struct rc_keymap kworld_315u_map = {
> +	.map = {
> +		.scan    = kworld_315u,
> +		.size    = ARRAY_SIZE(kworld_315u),
> +		.ir_type = IR_TYPE_NEC,
> +		.name    = RC_MAP_KWORLD_315U,
> +	}
> +};
> +
> +static int __init init_rc_map_kworld_315u(void)
> +{
> +	return ir_register_map(&kworld_315u_map);
> +}
> +
> +static void __exit exit_rc_map_kworld_315u(void)
> +{
> +	ir_unregister_map(&kworld_315u_map);
> +}
> +
> +module_init(init_rc_map_kworld_315u)
> +module_exit(exit_rc_map_kworld_315u)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
> new file mode 100644
> index 0000000..366732f
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-kworld-plus-tv-analog.c
> @@ -0,0 +1,99 @@
> +/* kworld-plus-tv-analog.h - Keytable for kworld_plus_tv_analog Remote Controller
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
> +
> +/* Kworld Plus TV Analog Lite PCI IR
> +   Mauro Carvalho Chehab <mchehab@infradead.org>
> + */
> +
> +static struct ir_scancode kworld_plus_tv_analog[] = {
> +	{ 0x0c, KEY_PROG1 },		/* Kworld key */
> +	{ 0x16, KEY_CLOSECD },		/* -> ) */
> +	{ 0x1d, KEY_POWER2 },
> +
> +	{ 0x00, KEY_1 },
> +	{ 0x01, KEY_2 },
> +	{ 0x02, KEY_3 },		/* Two keys have the same code: 3 and left */
> +	{ 0x03, KEY_4 },		/* Two keys have the same code: 3 and right */
> +	{ 0x04, KEY_5 },
> +	{ 0x05, KEY_6 },
> +	{ 0x06, KEY_7 },
> +	{ 0x07, KEY_8 },
> +	{ 0x08, KEY_9 },
> +	{ 0x0a, KEY_0 },
> +
> +	{ 0x09, KEY_AGAIN },
> +	{ 0x14, KEY_MUTE },
> +
> +	{ 0x20, KEY_UP },
> +	{ 0x21, KEY_DOWN },
> +	{ 0x0b, KEY_ENTER },
> +
> +	{ 0x10, KEY_CHANNELUP },
> +	{ 0x11, KEY_CHANNELDOWN },
> +
> +	/* Couldn't map key left/key right since those
> +	   conflict with '3' and '4' scancodes
> +	   I dunno what the original driver does
> +	 */
> +
> +	{ 0x13, KEY_VOLUMEUP },
> +	{ 0x12, KEY_VOLUMEDOWN },
> +
> +	/* The lower part of the IR
> +	   There are several duplicated keycodes there.
> +	   Most of them conflict with digits.
> +	   Add mappings just to the unused scancodes.
> +	   Somehow, the original driver has a way to know,
> +	   but this doesn't seem to be on some GPIO.
> +	   Also, it is not related to the time between keyup
> +	   and keydown.
> +	 */
> +	{ 0x19, KEY_TIME},		/* Timeshift */
> +	{ 0x1a, KEY_STOP},
> +	{ 0x1b, KEY_RECORD},
> +
> +	{ 0x22, KEY_TEXT},
> +
> +	{ 0x15, KEY_AUDIO},		/* ((*)) */
> +	{ 0x0f, KEY_ZOOM},
> +	{ 0x1c, KEY_CAMERA},		/* snapshot */
> +
> +	{ 0x18, KEY_RED},		/* B */
> +	{ 0x23, KEY_GREEN},		/* C */
> +};
> +
> +static struct rc_keymap kworld_plus_tv_analog_map = {
> +	.map = {
> +		.scan    = kworld_plus_tv_analog,
> +		.size    = ARRAY_SIZE(kworld_plus_tv_analog),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_KWORLD_PLUS_TV_ANALOG,
> +	}
> +};
> +
> +static int __init init_rc_map_kworld_plus_tv_analog(void)
> +{
> +	return ir_register_map(&kworld_plus_tv_analog_map);
> +}
> +
> +static void __exit exit_rc_map_kworld_plus_tv_analog(void)
> +{
> +	ir_unregister_map(&kworld_plus_tv_analog_map);
> +}
> +
> +module_init(init_rc_map_kworld_plus_tv_analog)
> +module_exit(exit_rc_map_kworld_plus_tv_analog)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-manli.c b/drivers/media/IR/keymaps/rc-manli.c
> new file mode 100644
> index 0000000..1e9fbfa
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-manli.c
> @@ -0,0 +1,135 @@
> +/* manli.h - Keytable for manli Remote Controller
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
> +
> +/* Michael Tokarev <mjt@tls.msk.ru>
> +   http://www.corpit.ru/mjt/beholdTV/remote_control.jpg
> +   keytable is used by MANLI MTV00[0x0c] and BeholdTV 40[13] at
> +   least, and probably other cards too.
> +   The "ascii-art picture" below (in comments, first row
> +   is the keycode in hex, and subsequent row(s) shows
> +   the button labels (several variants when appropriate)
> +   helps to descide which keycodes to assign to the buttons.
> + */
> +
> +static struct ir_scancode manli[] = {
> +
> +	/*  0x1c            0x12  *
> +	 * FUNCTION         POWER *
> +	 *   FM              (|)  *
> +	 *                        */
> +	{ 0x1c, KEY_RADIO },	/*XXX*/
> +	{ 0x12, KEY_POWER },
> +
> +	/*  0x01    0x02    0x03  *
> +	 *   1       2       3    *
> +	 *                        *
> +	 *  0x04    0x05    0x06  *
> +	 *   4       5       6    *
> +	 *                        *
> +	 *  0x07    0x08    0x09  *
> +	 *   7       8       9    *
> +	 *                        */
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	/*  0x0a    0x00    0x17  *
> +	 * RECALL    0      +100  *
> +	 *                  PLUS  *
> +	 *                        */
> +	{ 0x0a, KEY_AGAIN },	/*XXX KEY_REWIND? */
> +	{ 0x00, KEY_0 },
> +	{ 0x17, KEY_DIGITS },	/*XXX*/
> +
> +	/*  0x14            0x10  *
> +	 *  MENU            INFO  *
> +	 *  OSD                   */
> +	{ 0x14, KEY_MENU },
> +	{ 0x10, KEY_INFO },
> +
> +	/*          0x0b          *
> +	 *           Up           *
> +	 *                        *
> +	 *  0x18    0x16    0x0c  *
> +	 *  Left     Ok     Right *
> +	 *                        *
> +	 *         0x015          *
> +	 *         Down           *
> +	 *                        */
> +	{ 0x0b, KEY_UP },
> +	{ 0x18, KEY_LEFT },
> +	{ 0x16, KEY_OK },	/*XXX KEY_SELECT? KEY_ENTER? */
> +	{ 0x0c, KEY_RIGHT },
> +	{ 0x15, KEY_DOWN },
> +
> +	/*  0x11            0x0d  *
> +	 *  TV/AV           MODE  *
> +	 *  SOURCE         STEREO *
> +	 *                        */
> +	{ 0x11, KEY_TV },	/*XXX*/
> +	{ 0x0d, KEY_MODE },	/*XXX there's no KEY_STEREO	*/
> +
> +	/*  0x0f    0x1b    0x1a  *
> +	 *  AUDIO   Vol+    Chan+ *
> +	 *        TIMESHIFT???    *
> +	 *                        *
> +	 *  0x0e    0x1f    0x1e  *
> +	 *  SLEEP   Vol-    Chan- *
> +	 *                        */
> +	{ 0x0f, KEY_AUDIO },
> +	{ 0x1b, KEY_VOLUMEUP },
> +	{ 0x1a, KEY_CHANNELUP },
> +	{ 0x0e, KEY_TIME },
> +	{ 0x1f, KEY_VOLUMEDOWN },
> +	{ 0x1e, KEY_CHANNELDOWN },
> +
> +	/*         0x13     0x19  *
> +	 *         MUTE   SNAPSHOT*
> +	 *                        */
> +	{ 0x13, KEY_MUTE },
> +	{ 0x19, KEY_CAMERA },
> +
> +	/* 0x1d unused ? */
> +};
> +
> +static struct rc_keymap manli_map = {
> +	.map = {
> +		.scan    = manli,
> +		.size    = ARRAY_SIZE(manli),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_MANLI,
> +	}
> +};
> +
> +static int __init init_rc_map_manli(void)
> +{
> +	return ir_register_map(&manli_map);
> +}
> +
> +static void __exit exit_rc_map_manli(void)
> +{
> +	ir_unregister_map(&manli_map);
> +}
> +
> +module_init(init_rc_map_manli)
> +module_exit(exit_rc_map_manli)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
> new file mode 100644
> index 0000000..eb8e42c
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-msi-tvanywhere-plus.c
> @@ -0,0 +1,123 @@
> +/* msi-tvanywhere-plus.h - Keytable for msi_tvanywhere_plus Remote Controller
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
> +
> +/*
> +  Keycodes for remote on the MSI TV@nywhere Plus. The controller IC on the card
> +  is marked "KS003". The controller is I2C at address 0x30, but does not seem
> +  to respond to probes until a read is performed from a valid device.
> +  I don't know why...
> +
> +  Note: This remote may be of similar or identical design to the
> +  Pixelview remote (?).  The raw codes and duplicate button codes
> +  appear to be the same.
> +
> +  Henry Wong <henry@stuffedcow.net>
> +  Some changes to formatting and keycodes by Mark Schultz <n9xmj@yahoo.com>
> +*/
> +
> +static struct ir_scancode msi_tvanywhere_plus[] = {
> +
> +/*  ---- Remote Button Layout ----
> +
> +    POWER   SOURCE  SCAN    MUTE
> +    TV/FM   1       2       3
> +    |>      4       5       6
> +    <|      7       8       9
> +    ^^UP    0       +       RECALL
> +    vvDN    RECORD  STOP    PLAY
> +
> +	MINIMIZE          ZOOM
> +
> +		  CH+
> +      VOL-                   VOL+
> +		  CH-
> +
> +	SNAPSHOT           MTS
> +
> +     <<      FUNC    >>     RESET
> +*/
> +
> +	{ 0x01, KEY_1 },		/* 1 */
> +	{ 0x0b, KEY_2 },		/* 2 */
> +	{ 0x1b, KEY_3 },		/* 3 */
> +	{ 0x05, KEY_4 },		/* 4 */
> +	{ 0x09, KEY_5 },		/* 5 */
> +	{ 0x15, KEY_6 },		/* 6 */
> +	{ 0x06, KEY_7 },		/* 7 */
> +	{ 0x0a, KEY_8 },		/* 8 */
> +	{ 0x12, KEY_9 },		/* 9 */
> +	{ 0x02, KEY_0 },		/* 0 */
> +	{ 0x10, KEY_KPPLUS },		/* + */
> +	{ 0x13, KEY_AGAIN },		/* Recall */
> +
> +	{ 0x1e, KEY_POWER },		/* Power */
> +	{ 0x07, KEY_TUNER },		/* Source */
> +	{ 0x1c, KEY_SEARCH },		/* Scan */
> +	{ 0x18, KEY_MUTE },		/* Mute */
> +
> +	{ 0x03, KEY_RADIO },		/* TV/FM */
> +	/* The next four keys are duplicates that appear to send the
> +	   same IR code as Ch+, Ch-, >>, and << .  The raw code assigned
> +	   to them is the actual code + 0x20 - they will never be
> +	   detected as such unless some way is discovered to distinguish
> +	   these buttons from those that have the same code. */
> +	{ 0x3f, KEY_RIGHT },		/* |> and Ch+ */
> +	{ 0x37, KEY_LEFT },		/* <| and Ch- */
> +	{ 0x2c, KEY_UP },		/* ^^Up and >> */
> +	{ 0x24, KEY_DOWN },		/* vvDn and << */
> +
> +	{ 0x00, KEY_RECORD },		/* Record */
> +	{ 0x08, KEY_STOP },		/* Stop */
> +	{ 0x11, KEY_PLAY },		/* Play */
> +
> +	{ 0x0f, KEY_CLOSE },		/* Minimize */
> +	{ 0x19, KEY_ZOOM },		/* Zoom */
> +	{ 0x1a, KEY_CAMERA },		/* Snapshot */
> +	{ 0x0d, KEY_LANGUAGE },		/* MTS */
> +
> +	{ 0x14, KEY_VOLUMEDOWN },	/* Vol- */
> +	{ 0x16, KEY_VOLUMEUP },		/* Vol+ */
> +	{ 0x17, KEY_CHANNELDOWN },	/* Ch- */
> +	{ 0x1f, KEY_CHANNELUP },	/* Ch+ */
> +
> +	{ 0x04, KEY_REWIND },		/* << */
> +	{ 0x0e, KEY_MENU },		/* Function */
> +	{ 0x0c, KEY_FASTFORWARD },	/* >> */
> +	{ 0x1d, KEY_RESTART },		/* Reset */
> +};
> +
> +static struct rc_keymap msi_tvanywhere_plus_map = {
> +	.map = {
> +		.scan    = msi_tvanywhere_plus,
> +		.size    = ARRAY_SIZE(msi_tvanywhere_plus),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_MSI_TVANYWHERE_PLUS,
> +	}
> +};
> +
> +static int __init init_rc_map_msi_tvanywhere_plus(void)
> +{
> +	return ir_register_map(&msi_tvanywhere_plus_map);
> +}
> +
> +static void __exit exit_rc_map_msi_tvanywhere_plus(void)
> +{
> +	ir_unregister_map(&msi_tvanywhere_plus_map);
> +}
> +
> +module_init(init_rc_map_msi_tvanywhere_plus)
> +module_exit(exit_rc_map_msi_tvanywhere_plus)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-msi-tvanywhere.c b/drivers/media/IR/keymaps/rc-msi-tvanywhere.c
> new file mode 100644
> index 0000000..ef41185
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-msi-tvanywhere.c
> @@ -0,0 +1,69 @@
> +/* msi-tvanywhere.h - Keytable for msi_tvanywhere Remote Controller
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
> +
> +/* MSI TV@nywhere MASTER remote */
> +
> +static struct ir_scancode msi_tvanywhere[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	{ 0x0c, KEY_MUTE },
> +	{ 0x0f, KEY_SCREEN },		/* Full Screen */
> +	{ 0x10, KEY_FN },		/* Funtion */
> +	{ 0x11, KEY_TIME },		/* Time shift */
> +	{ 0x12, KEY_POWER },
> +	{ 0x13, KEY_MEDIA },		/* MTS */
> +	{ 0x14, KEY_SLOW },
> +	{ 0x16, KEY_REWIND },		/* backward << */
> +	{ 0x17, KEY_ENTER },		/* Return */
> +	{ 0x18, KEY_FASTFORWARD },	/* forward >> */
> +	{ 0x1a, KEY_CHANNELUP },
> +	{ 0x1b, KEY_VOLUMEUP },
> +	{ 0x1e, KEY_CHANNELDOWN },
> +	{ 0x1f, KEY_VOLUMEDOWN },
> +};
> +
> +static struct rc_keymap msi_tvanywhere_map = {
> +	.map = {
> +		.scan    = msi_tvanywhere,
> +		.size    = ARRAY_SIZE(msi_tvanywhere),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_MSI_TVANYWHERE,
> +	}
> +};
> +
> +static int __init init_rc_map_msi_tvanywhere(void)
> +{
> +	return ir_register_map(&msi_tvanywhere_map);
> +}
> +
> +static void __exit exit_rc_map_msi_tvanywhere(void)
> +{
> +	ir_unregister_map(&msi_tvanywhere_map);
> +}
> +
> +module_init(init_rc_map_msi_tvanywhere)
> +module_exit(exit_rc_map_msi_tvanywhere)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-nebula.c b/drivers/media/IR/keymaps/rc-nebula.c
> new file mode 100644
> index 0000000..ccc50eb
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-nebula.c
> @@ -0,0 +1,96 @@
> +/* nebula.h - Keytable for nebula Remote Controller
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
> +
> +static struct ir_scancode nebula[] = {
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +	{ 0x0a, KEY_TV },
> +	{ 0x0b, KEY_AUX },
> +	{ 0x0c, KEY_DVD },
> +	{ 0x0d, KEY_POWER },
> +	{ 0x0e, KEY_MHP },	/* labelled 'Picture' */
> +	{ 0x0f, KEY_AUDIO },
> +	{ 0x10, KEY_INFO },
> +	{ 0x11, KEY_F13 },	/* 16:9 */
> +	{ 0x12, KEY_F14 },	/* 14:9 */
> +	{ 0x13, KEY_EPG },
> +	{ 0x14, KEY_EXIT },
> +	{ 0x15, KEY_MENU },
> +	{ 0x16, KEY_UP },
> +	{ 0x17, KEY_DOWN },
> +	{ 0x18, KEY_LEFT },
> +	{ 0x19, KEY_RIGHT },
> +	{ 0x1a, KEY_ENTER },
> +	{ 0x1b, KEY_CHANNELUP },
> +	{ 0x1c, KEY_CHANNELDOWN },
> +	{ 0x1d, KEY_VOLUMEUP },
> +	{ 0x1e, KEY_VOLUMEDOWN },
> +	{ 0x1f, KEY_RED },
> +	{ 0x20, KEY_GREEN },
> +	{ 0x21, KEY_YELLOW },
> +	{ 0x22, KEY_BLUE },
> +	{ 0x23, KEY_SUBTITLE },
> +	{ 0x24, KEY_F15 },	/* AD */
> +	{ 0x25, KEY_TEXT },
> +	{ 0x26, KEY_MUTE },
> +	{ 0x27, KEY_REWIND },
> +	{ 0x28, KEY_STOP },
> +	{ 0x29, KEY_PLAY },
> +	{ 0x2a, KEY_FASTFORWARD },
> +	{ 0x2b, KEY_F16 },	/* chapter */
> +	{ 0x2c, KEY_PAUSE },
> +	{ 0x2d, KEY_PLAY },
> +	{ 0x2e, KEY_RECORD },
> +	{ 0x2f, KEY_F17 },	/* picture in picture */
> +	{ 0x30, KEY_KPPLUS },	/* zoom in */
> +	{ 0x31, KEY_KPMINUS },	/* zoom out */
> +	{ 0x32, KEY_F18 },	/* capture */
> +	{ 0x33, KEY_F19 },	/* web */
> +	{ 0x34, KEY_EMAIL },
> +	{ 0x35, KEY_PHONE },
> +	{ 0x36, KEY_PC },
> +};
> +
> +static struct rc_keymap nebula_map = {
> +	.map = {
> +		.scan    = nebula,
> +		.size    = ARRAY_SIZE(nebula),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_NEBULA,
> +	}
> +};
> +
> +static int __init init_rc_map_nebula(void)
> +{
> +	return ir_register_map(&nebula_map);
> +}
> +
> +static void __exit exit_rc_map_nebula(void)
> +{
> +	ir_unregister_map(&nebula_map);
> +}
> +
> +module_init(init_rc_map_nebula)
> +module_exit(exit_rc_map_nebula)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
> new file mode 100644
> index 0000000..e1b54d2
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c
> @@ -0,0 +1,105 @@
> +/* nec-terratec-cinergy-xs.h - Keytable for nec_terratec_cinergy_xs Remote Controller
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
> +
> +/* Terratec Cinergy Hybrid T USB XS FM
> +   Mauro Carvalho Chehab <mchehab@redhat.com>
> + */
> +
> +static struct ir_scancode nec_terratec_cinergy_xs[] = {
> +	{ 0x1441, KEY_HOME},
> +	{ 0x1401, KEY_POWER2},
> +
> +	{ 0x1442, KEY_MENU},		/* DVD menu */
> +	{ 0x1443, KEY_SUBTITLE},
> +	{ 0x1444, KEY_TEXT},		/* Teletext */
> +	{ 0x1445, KEY_DELETE},
> +
> +	{ 0x1402, KEY_1},
> +	{ 0x1403, KEY_2},
> +	{ 0x1404, KEY_3},
> +	{ 0x1405, KEY_4},
> +	{ 0x1406, KEY_5},
> +	{ 0x1407, KEY_6},
> +	{ 0x1408, KEY_7},
> +	{ 0x1409, KEY_8},
> +	{ 0x140a, KEY_9},
> +	{ 0x140c, KEY_0},
> +
> +	{ 0x140b, KEY_TUNER},		/* AV */
> +	{ 0x140d, KEY_MODE},		/* A.B */
> +
> +	{ 0x1446, KEY_TV},
> +	{ 0x1447, KEY_DVD},
> +	{ 0x1449, KEY_VIDEO},
> +	{ 0x144a, KEY_RADIO},		/* Music */
> +	{ 0x144b, KEY_CAMERA},		/* PIC */
> +
> +	{ 0x1410, KEY_UP},
> +	{ 0x1411, KEY_LEFT},
> +	{ 0x1412, KEY_OK},
> +	{ 0x1413, KEY_RIGHT},
> +	{ 0x1414, KEY_DOWN},
> +
> +	{ 0x140f, KEY_EPG},
> +	{ 0x1416, KEY_INFO},
> +	{ 0x144d, KEY_BACKSPACE},
> +
> +	{ 0x141c, KEY_VOLUMEUP},
> +	{ 0x141e, KEY_VOLUMEDOWN},
> +
> +	{ 0x144c, KEY_PLAY},
> +	{ 0x141d, KEY_MUTE},
> +
> +	{ 0x141b, KEY_CHANNELUP},
> +	{ 0x141f, KEY_CHANNELDOWN},
> +
> +	{ 0x1417, KEY_RED},
> +	{ 0x1418, KEY_GREEN},
> +	{ 0x1419, KEY_YELLOW},
> +	{ 0x141a, KEY_BLUE},
> +
> +	{ 0x1458, KEY_RECORD},
> +	{ 0x1448, KEY_STOP},
> +	{ 0x1440, KEY_PAUSE},
> +
> +	{ 0x1454, KEY_LAST},
> +	{ 0x144e, KEY_REWIND},
> +	{ 0x144f, KEY_FASTFORWARD},
> +	{ 0x145c, KEY_NEXT},
> +};
> +
> +static struct rc_keymap nec_terratec_cinergy_xs_map = {
> +	.map = {
> +		.scan    = nec_terratec_cinergy_xs,
> +		.size    = ARRAY_SIZE(nec_terratec_cinergy_xs),
> +		.ir_type = IR_TYPE_NEC,
> +		.name    = RC_MAP_NEC_TERRATEC_CINERGY_XS,
> +	}
> +};
> +
> +static int __init init_rc_map_nec_terratec_cinergy_xs(void)
> +{
> +	return ir_register_map(&nec_terratec_cinergy_xs_map);
> +}
> +
> +static void __exit exit_rc_map_nec_terratec_cinergy_xs(void)
> +{
> +	ir_unregister_map(&nec_terratec_cinergy_xs_map);
> +}
> +
> +module_init(init_rc_map_nec_terratec_cinergy_xs)
> +module_exit(exit_rc_map_nec_terratec_cinergy_xs)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-norwood.c b/drivers/media/IR/keymaps/rc-norwood.c
> new file mode 100644
> index 0000000..e5849a6
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-norwood.c
> @@ -0,0 +1,85 @@
> +/* norwood.h - Keytable for norwood Remote Controller
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
> +
> +/* Norwood Micro (non-Pro) TV Tuner
> +   By Peter Naulls <peter@chocky.org>
> +   Key comments are the functions given in the manual */
> +
> +static struct ir_scancode norwood[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x20, KEY_0 },
> +	{ 0x21, KEY_1 },
> +	{ 0x22, KEY_2 },
> +	{ 0x23, KEY_3 },
> +	{ 0x24, KEY_4 },
> +	{ 0x25, KEY_5 },
> +	{ 0x26, KEY_6 },
> +	{ 0x27, KEY_7 },
> +	{ 0x28, KEY_8 },
> +	{ 0x29, KEY_9 },
> +
> +	{ 0x78, KEY_TUNER },		/* Video Source        */
> +	{ 0x2c, KEY_EXIT },		/* Open/Close software */
> +	{ 0x2a, KEY_SELECT },		/* 2 Digit Select      */
> +	{ 0x69, KEY_AGAIN },		/* Recall              */
> +
> +	{ 0x32, KEY_BRIGHTNESSUP },	/* Brightness increase */
> +	{ 0x33, KEY_BRIGHTNESSDOWN },	/* Brightness decrease */
> +	{ 0x6b, KEY_KPPLUS },		/* (not named >>>>>)   */
> +	{ 0x6c, KEY_KPMINUS },		/* (not named <<<<<)   */
> +
> +	{ 0x2d, KEY_MUTE },		/* Mute                */
> +	{ 0x30, KEY_VOLUMEUP },		/* Volume up           */
> +	{ 0x31, KEY_VOLUMEDOWN },	/* Volume down         */
> +	{ 0x60, KEY_CHANNELUP },	/* Channel up          */
> +	{ 0x61, KEY_CHANNELDOWN },	/* Channel down        */
> +
> +	{ 0x3f, KEY_RECORD },		/* Record              */
> +	{ 0x37, KEY_PLAY },		/* Play                */
> +	{ 0x36, KEY_PAUSE },		/* Pause               */
> +	{ 0x2b, KEY_STOP },		/* Stop                */
> +	{ 0x67, KEY_FASTFORWARD },	/* Foward              */
> +	{ 0x66, KEY_REWIND },		/* Rewind              */
> +	{ 0x3e, KEY_SEARCH },		/* Auto Scan           */
> +	{ 0x2e, KEY_CAMERA },		/* Capture Video       */
> +	{ 0x6d, KEY_MENU },		/* Show/Hide Control   */
> +	{ 0x2f, KEY_ZOOM },		/* Full Screen         */
> +	{ 0x34, KEY_RADIO },		/* FM                  */
> +	{ 0x65, KEY_POWER },		/* Computer power      */
> +};
> +
> +static struct rc_keymap norwood_map = {
> +	.map = {
> +		.scan    = norwood,
> +		.size    = ARRAY_SIZE(norwood),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_NORWOOD,
> +	}
> +};
> +
> +static int __init init_rc_map_norwood(void)
> +{
> +	return ir_register_map(&norwood_map);
> +}
> +
> +static void __exit exit_rc_map_norwood(void)
> +{
> +	ir_unregister_map(&norwood_map);
> +}
> +
> +module_init(init_rc_map_norwood)
> +module_exit(exit_rc_map_norwood)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-npgtech.c b/drivers/media/IR/keymaps/rc-npgtech.c
> new file mode 100644
> index 0000000..b9ece1e
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-npgtech.c
> @@ -0,0 +1,80 @@
> +/* npgtech.h - Keytable for npgtech Remote Controller
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
> +
> +static struct ir_scancode npgtech[] = {
> +	{ 0x1d, KEY_SWITCHVIDEOMODE },	/* switch inputs */
> +	{ 0x2a, KEY_FRONT },
> +
> +	{ 0x3e, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x06, KEY_3 },
> +	{ 0x0a, KEY_4 },
> +	{ 0x0e, KEY_5 },
> +	{ 0x12, KEY_6 },
> +	{ 0x16, KEY_7 },
> +	{ 0x1a, KEY_8 },
> +	{ 0x1e, KEY_9 },
> +	{ 0x3a, KEY_0 },
> +	{ 0x22, KEY_NUMLOCK },		/* -/-- */
> +	{ 0x20, KEY_REFRESH },
> +
> +	{ 0x03, KEY_BRIGHTNESSDOWN },
> +	{ 0x28, KEY_AUDIO },
> +	{ 0x3c, KEY_CHANNELUP },
> +	{ 0x3f, KEY_VOLUMEDOWN },
> +	{ 0x2e, KEY_MUTE },
> +	{ 0x3b, KEY_VOLUMEUP },
> +	{ 0x00, KEY_CHANNELDOWN },
> +	{ 0x07, KEY_BRIGHTNESSUP },
> +	{ 0x2c, KEY_TEXT },
> +
> +	{ 0x37, KEY_RECORD },
> +	{ 0x17, KEY_PLAY },
> +	{ 0x13, KEY_PAUSE },
> +	{ 0x26, KEY_STOP },
> +	{ 0x18, KEY_FASTFORWARD },
> +	{ 0x14, KEY_REWIND },
> +	{ 0x33, KEY_ZOOM },
> +	{ 0x32, KEY_KEYBOARD },
> +	{ 0x30, KEY_GOTO },		/* Pointing arrow */
> +	{ 0x36, KEY_MACRO },		/* Maximize/Minimize (yellow) */
> +	{ 0x0b, KEY_RADIO },
> +	{ 0x10, KEY_POWER },
> +
> +};
> +
> +static struct rc_keymap npgtech_map = {
> +	.map = {
> +		.scan    = npgtech,
> +		.size    = ARRAY_SIZE(npgtech),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_NPGTECH,
> +	}
> +};
> +
> +static int __init init_rc_map_npgtech(void)
> +{
> +	return ir_register_map(&npgtech_map);
> +}
> +
> +static void __exit exit_rc_map_npgtech(void)
> +{
> +	ir_unregister_map(&npgtech_map);
> +}
> +
> +module_init(init_rc_map_npgtech)
> +module_exit(exit_rc_map_npgtech)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-pctv-sedna.c b/drivers/media/IR/keymaps/rc-pctv-sedna.c
> new file mode 100644
> index 0000000..4129bb4
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-pctv-sedna.c
> @@ -0,0 +1,80 @@
> +/* pctv-sedna.h - Keytable for pctv_sedna Remote Controller
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
> +
> +/* Mapping for the 28 key remote control as seen at
> +   http://www.sednacomputer.com/photo/cardbus-tv.jpg
> +   Pavel Mihaylov <bin@bash.info>
> +   Also for the remote bundled with Kozumi KTV-01C card */
> +
> +static struct ir_scancode pctv_sedna[] = {
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	{ 0x0a, KEY_AGAIN },	/* Recall */
> +	{ 0x0b, KEY_CHANNELUP },
> +	{ 0x0c, KEY_VOLUMEUP },
> +	{ 0x0d, KEY_MODE },	/* Stereo */
> +	{ 0x0e, KEY_STOP },
> +	{ 0x0f, KEY_PREVIOUSSONG },
> +	{ 0x10, KEY_ZOOM },
> +	{ 0x11, KEY_TUNER },	/* Source */
> +	{ 0x12, KEY_POWER },
> +	{ 0x13, KEY_MUTE },
> +	{ 0x15, KEY_CHANNELDOWN },
> +	{ 0x18, KEY_VOLUMEDOWN },
> +	{ 0x19, KEY_CAMERA },	/* Snapshot */
> +	{ 0x1a, KEY_NEXTSONG },
> +	{ 0x1b, KEY_TIME },	/* Time Shift */
> +	{ 0x1c, KEY_RADIO },	/* FM Radio */
> +	{ 0x1d, KEY_RECORD },
> +	{ 0x1e, KEY_PAUSE },
> +	/* additional codes for Kozumi's remote */
> +	{ 0x14, KEY_INFO },	/* OSD */
> +	{ 0x16, KEY_OK },	/* OK */
> +	{ 0x17, KEY_DIGITS },	/* Plus */
> +	{ 0x1f, KEY_PLAY },	/* Play */
> +};
> +
> +static struct rc_keymap pctv_sedna_map = {
> +	.map = {
> +		.scan    = pctv_sedna,
> +		.size    = ARRAY_SIZE(pctv_sedna),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PCTV_SEDNA,
> +	}
> +};
> +
> +static int __init init_rc_map_pctv_sedna(void)
> +{
> +	return ir_register_map(&pctv_sedna_map);
> +}
> +
> +static void __exit exit_rc_map_pctv_sedna(void)
> +{
> +	ir_unregister_map(&pctv_sedna_map);
> +}
> +
> +module_init(init_rc_map_pctv_sedna)
> +module_exit(exit_rc_map_pctv_sedna)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-pinnacle-color.c b/drivers/media/IR/keymaps/rc-pinnacle-color.c
> new file mode 100644
> index 0000000..326e023
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-pinnacle-color.c
> @@ -0,0 +1,94 @@
> +/* pinnacle-color.h - Keytable for pinnacle_color Remote Controller
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
> +
> +static struct ir_scancode pinnacle_color[] = {
> +	{ 0x59, KEY_MUTE },
> +	{ 0x4a, KEY_POWER },
> +
> +	{ 0x18, KEY_TEXT },
> +	{ 0x26, KEY_TV },
> +	{ 0x3d, KEY_PRINT },
> +
> +	{ 0x48, KEY_RED },
> +	{ 0x04, KEY_GREEN },
> +	{ 0x11, KEY_YELLOW },
> +	{ 0x00, KEY_BLUE },
> +
> +	{ 0x2d, KEY_VOLUMEUP },
> +	{ 0x1e, KEY_VOLUMEDOWN },
> +
> +	{ 0x49, KEY_MENU },
> +
> +	{ 0x16, KEY_CHANNELUP },
> +	{ 0x17, KEY_CHANNELDOWN },
> +
> +	{ 0x20, KEY_UP },
> +	{ 0x21, KEY_DOWN },
> +	{ 0x22, KEY_LEFT },
> +	{ 0x23, KEY_RIGHT },
> +	{ 0x0d, KEY_SELECT },
> +
> +	{ 0x08, KEY_BACK },
> +	{ 0x07, KEY_REFRESH },
> +
> +	{ 0x2f, KEY_ZOOM },
> +	{ 0x29, KEY_RECORD },
> +
> +	{ 0x4b, KEY_PAUSE },
> +	{ 0x4d, KEY_REWIND },
> +	{ 0x2e, KEY_PLAY },
> +	{ 0x4e, KEY_FORWARD },
> +	{ 0x53, KEY_PREVIOUS },
> +	{ 0x4c, KEY_STOP },
> +	{ 0x54, KEY_NEXT },
> +
> +	{ 0x69, KEY_0 },
> +	{ 0x6a, KEY_1 },
> +	{ 0x6b, KEY_2 },
> +	{ 0x6c, KEY_3 },
> +	{ 0x6d, KEY_4 },
> +	{ 0x6e, KEY_5 },
> +	{ 0x6f, KEY_6 },
> +	{ 0x70, KEY_7 },
> +	{ 0x71, KEY_8 },
> +	{ 0x72, KEY_9 },
> +
> +	{ 0x74, KEY_CHANNEL },
> +	{ 0x0a, KEY_BACKSPACE },
> +};
> +
> +static struct rc_keymap pinnacle_color_map = {
> +	.map = {
> +		.scan    = pinnacle_color,
> +		.size    = ARRAY_SIZE(pinnacle_color),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PINNACLE_COLOR,
> +	}
> +};
> +
> +static int __init init_rc_map_pinnacle_color(void)
> +{
> +	return ir_register_map(&pinnacle_color_map);
> +}
> +
> +static void __exit exit_rc_map_pinnacle_color(void)
> +{
> +	ir_unregister_map(&pinnacle_color_map);
> +}
> +
> +module_init(init_rc_map_pinnacle_color)
> +module_exit(exit_rc_map_pinnacle_color)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-pinnacle-grey.c b/drivers/media/IR/keymaps/rc-pinnacle-grey.c
> new file mode 100644
> index 0000000..14cb772
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-pinnacle-grey.c
> @@ -0,0 +1,89 @@
> +/* pinnacle-grey.h - Keytable for pinnacle_grey Remote Controller
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
> +
> +static struct ir_scancode pinnacle_grey[] = {
> +	{ 0x3a, KEY_0 },
> +	{ 0x31, KEY_1 },
> +	{ 0x32, KEY_2 },
> +	{ 0x33, KEY_3 },
> +	{ 0x34, KEY_4 },
> +	{ 0x35, KEY_5 },
> +	{ 0x36, KEY_6 },
> +	{ 0x37, KEY_7 },
> +	{ 0x38, KEY_8 },
> +	{ 0x39, KEY_9 },
> +
> +	{ 0x2f, KEY_POWER },
> +
> +	{ 0x2e, KEY_P },
> +	{ 0x1f, KEY_L },
> +	{ 0x2b, KEY_I },
> +
> +	{ 0x2d, KEY_SCREEN },
> +	{ 0x1e, KEY_ZOOM },
> +	{ 0x1b, KEY_VOLUMEUP },
> +	{ 0x0f, KEY_VOLUMEDOWN },
> +	{ 0x17, KEY_CHANNELUP },
> +	{ 0x1c, KEY_CHANNELDOWN },
> +	{ 0x25, KEY_INFO },
> +
> +	{ 0x3c, KEY_MUTE },
> +
> +	{ 0x3d, KEY_LEFT },
> +	{ 0x3b, KEY_RIGHT },
> +
> +	{ 0x3f, KEY_UP },
> +	{ 0x3e, KEY_DOWN },
> +	{ 0x1a, KEY_ENTER },
> +
> +	{ 0x1d, KEY_MENU },
> +	{ 0x19, KEY_AGAIN },
> +	{ 0x16, KEY_PREVIOUSSONG },
> +	{ 0x13, KEY_NEXTSONG },
> +	{ 0x15, KEY_PAUSE },
> +	{ 0x0e, KEY_REWIND },
> +	{ 0x0d, KEY_PLAY },
> +	{ 0x0b, KEY_STOP },
> +	{ 0x07, KEY_FORWARD },
> +	{ 0x27, KEY_RECORD },
> +	{ 0x26, KEY_TUNER },
> +	{ 0x29, KEY_TEXT },
> +	{ 0x2a, KEY_MEDIA },
> +	{ 0x18, KEY_EPG },
> +};
> +
> +static struct rc_keymap pinnacle_grey_map = {
> +	.map = {
> +		.scan    = pinnacle_grey,
> +		.size    = ARRAY_SIZE(pinnacle_grey),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PINNACLE_GREY,
> +	}
> +};
> +
> +static int __init init_rc_map_pinnacle_grey(void)
> +{
> +	return ir_register_map(&pinnacle_grey_map);
> +}
> +
> +static void __exit exit_rc_map_pinnacle_grey(void)
> +{
> +	ir_unregister_map(&pinnacle_grey_map);
> +}
> +
> +module_init(init_rc_map_pinnacle_grey)
> +module_exit(exit_rc_map_pinnacle_grey)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
> new file mode 100644
> index 0000000..835bf4e
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-pinnacle-pctv-hd.c
> @@ -0,0 +1,73 @@
> +/* pinnacle-pctv-hd.h - Keytable for pinnacle_pctv_hd Remote Controller
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
> +
> +/* Pinnacle PCTV HD 800i mini remote */
> +
> +static struct ir_scancode pinnacle_pctv_hd[] = {
> +
> +	{ 0x0f, KEY_1 },
> +	{ 0x15, KEY_2 },
> +	{ 0x10, KEY_3 },
> +	{ 0x18, KEY_4 },
> +	{ 0x1b, KEY_5 },
> +	{ 0x1e, KEY_6 },
> +	{ 0x11, KEY_7 },
> +	{ 0x21, KEY_8 },
> +	{ 0x12, KEY_9 },
> +	{ 0x27, KEY_0 },
> +
> +	{ 0x24, KEY_ZOOM },
> +	{ 0x2a, KEY_SUBTITLE },
> +
> +	{ 0x00, KEY_MUTE },
> +	{ 0x01, KEY_ENTER },	/* Pinnacle Logo */
> +	{ 0x39, KEY_POWER },
> +
> +	{ 0x03, KEY_VOLUMEUP },
> +	{ 0x09, KEY_VOLUMEDOWN },
> +	{ 0x06, KEY_CHANNELUP },
> +	{ 0x0c, KEY_CHANNELDOWN },
> +
> +	{ 0x2d, KEY_REWIND },
> +	{ 0x30, KEY_PLAYPAUSE },
> +	{ 0x33, KEY_FASTFORWARD },
> +	{ 0x3c, KEY_STOP },
> +	{ 0x36, KEY_RECORD },
> +	{ 0x3f, KEY_EPG },	/* Labeled "?" */
> +};
> +
> +static struct rc_keymap pinnacle_pctv_hd_map = {
> +	.map = {
> +		.scan    = pinnacle_pctv_hd,
> +		.size    = ARRAY_SIZE(pinnacle_pctv_hd),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PINNACLE_PCTV_HD,
> +	}
> +};
> +
> +static int __init init_rc_map_pinnacle_pctv_hd(void)
> +{
> +	return ir_register_map(&pinnacle_pctv_hd_map);
> +}
> +
> +static void __exit exit_rc_map_pinnacle_pctv_hd(void)
> +{
> +	ir_unregister_map(&pinnacle_pctv_hd_map);
> +}
> +
> +module_init(init_rc_map_pinnacle_pctv_hd)
> +module_exit(exit_rc_map_pinnacle_pctv_hd)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-pixelview-new.c b/drivers/media/IR/keymaps/rc-pixelview-new.c
> new file mode 100644
> index 0000000..7bbbbf5
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-pixelview-new.c
> @@ -0,0 +1,83 @@
> +/* pixelview-new.h - Keytable for pixelview_new Remote Controller
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
> +
> +/*
> +   Mauro Carvalho Chehab <mchehab@infradead.org>
> +   present on PV MPEG 8000GT
> + */
> +
> +static struct ir_scancode pixelview_new[] = {
> +	{ 0x3c, KEY_TIME },		/* Timeshift */
> +	{ 0x12, KEY_POWER },
> +
> +	{ 0x3d, KEY_1 },
> +	{ 0x38, KEY_2 },
> +	{ 0x18, KEY_3 },
> +	{ 0x35, KEY_4 },
> +	{ 0x39, KEY_5 },
> +	{ 0x15, KEY_6 },
> +	{ 0x36, KEY_7 },
> +	{ 0x3a, KEY_8 },
> +	{ 0x1e, KEY_9 },
> +	{ 0x3e, KEY_0 },
> +
> +	{ 0x1c, KEY_AGAIN },		/* LOOP	*/
> +	{ 0x3f, KEY_MEDIA },		/* Source */
> +	{ 0x1f, KEY_LAST },		/* +100 */
> +	{ 0x1b, KEY_MUTE },
> +
> +	{ 0x17, KEY_CHANNELDOWN },
> +	{ 0x16, KEY_CHANNELUP },
> +	{ 0x10, KEY_VOLUMEUP },
> +	{ 0x14, KEY_VOLUMEDOWN },
> +	{ 0x13, KEY_ZOOM },
> +
> +	{ 0x19, KEY_CAMERA },		/* SNAPSHOT */
> +	{ 0x1a, KEY_SEARCH },		/* scan */
> +
> +	{ 0x37, KEY_REWIND },		/* << */
> +	{ 0x32, KEY_RECORD },		/* o (red) */
> +	{ 0x33, KEY_FORWARD },		/* >> */
> +	{ 0x11, KEY_STOP },		/* square */
> +	{ 0x3b, KEY_PLAY },		/* > */
> +	{ 0x30, KEY_PLAYPAUSE },	/* || */
> +
> +	{ 0x31, KEY_TV },
> +	{ 0x34, KEY_RADIO },
> +};
> +
> +static struct rc_keymap pixelview_new_map = {
> +	.map = {
> +		.scan    = pixelview_new,
> +		.size    = ARRAY_SIZE(pixelview_new),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PIXELVIEW_NEW,
> +	}
> +};
> +
> +static int __init init_rc_map_pixelview_new(void)
> +{
> +	return ir_register_map(&pixelview_new_map);
> +}
> +
> +static void __exit exit_rc_map_pixelview_new(void)
> +{
> +	ir_unregister_map(&pixelview_new_map);
> +}
> +
> +module_init(init_rc_map_pixelview_new)
> +module_exit(exit_rc_map_pixelview_new)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-pixelview.c b/drivers/media/IR/keymaps/rc-pixelview.c
> new file mode 100644
> index 0000000..82ff12e
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-pixelview.c
> @@ -0,0 +1,82 @@
> +/* pixelview.h - Keytable for pixelview Remote Controller
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
> +
> +static struct ir_scancode pixelview[] = {
> +
> +	{ 0x1e, KEY_POWER },	/* power */
> +	{ 0x07, KEY_MEDIA },	/* source */
> +	{ 0x1c, KEY_SEARCH },	/* scan */
> +
> +
> +	{ 0x03, KEY_TUNER },		/* TV/FM */
> +
> +	{ 0x00, KEY_RECORD },
> +	{ 0x08, KEY_STOP },
> +	{ 0x11, KEY_PLAY },
> +
> +	{ 0x1a, KEY_PLAYPAUSE },	/* freeze */
> +	{ 0x19, KEY_ZOOM },		/* zoom */
> +	{ 0x0f, KEY_TEXT },		/* min */
> +
> +	{ 0x01, KEY_1 },
> +	{ 0x0b, KEY_2 },
> +	{ 0x1b, KEY_3 },
> +	{ 0x05, KEY_4 },
> +	{ 0x09, KEY_5 },
> +	{ 0x15, KEY_6 },
> +	{ 0x06, KEY_7 },
> +	{ 0x0a, KEY_8 },
> +	{ 0x12, KEY_9 },
> +	{ 0x02, KEY_0 },
> +	{ 0x10, KEY_LAST },		/* +100 */
> +	{ 0x13, KEY_LIST },		/* recall */
> +
> +	{ 0x1f, KEY_CHANNELUP },	/* chn down */
> +	{ 0x17, KEY_CHANNELDOWN },	/* chn up */
> +	{ 0x16, KEY_VOLUMEUP },		/* vol down */
> +	{ 0x14, KEY_VOLUMEDOWN },	/* vol up */
> +
> +	{ 0x04, KEY_KPMINUS },		/* <<< */
> +	{ 0x0e, KEY_SETUP },		/* function */
> +	{ 0x0c, KEY_KPPLUS },		/* >>> */
> +
> +	{ 0x0d, KEY_GOTO },		/* mts */
> +	{ 0x1d, KEY_REFRESH },		/* reset */
> +	{ 0x18, KEY_MUTE },		/* mute/unmute */
> +};
> +
> +static struct rc_keymap pixelview_map = {
> +	.map = {
> +		.scan    = pixelview,
> +		.size    = ARRAY_SIZE(pixelview),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PIXELVIEW,
> +	}
> +};
> +
> +static int __init init_rc_map_pixelview(void)
> +{
> +	return ir_register_map(&pixelview_map);
> +}
> +
> +static void __exit exit_rc_map_pixelview(void)
> +{
> +	ir_unregister_map(&pixelview_map);
> +}
> +
> +module_init(init_rc_map_pixelview)
> +module_exit(exit_rc_map_pixelview)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-powercolor-real-angel.c b/drivers/media/IR/keymaps/rc-powercolor-real-angel.c
> new file mode 100644
> index 0000000..7cef819
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-powercolor-real-angel.c
> @@ -0,0 +1,81 @@
> +/* powercolor-real-angel.h - Keytable for powercolor_real_angel Remote Controller
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
> +
> +/*
> + * Remote control for Powercolor Real Angel 330
> + * Daniel Fraga <fragabr@gmail.com>
> + */
> +
> +static struct ir_scancode powercolor_real_angel[] = {
> +	{ 0x38, KEY_SWITCHVIDEOMODE },	/* switch inputs */
> +	{ 0x0c, KEY_MEDIA },		/* Turn ON/OFF App */
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +	{ 0x0a, KEY_DIGITS },		/* single, double, tripple digit */
> +	{ 0x29, KEY_PREVIOUS },		/* previous channel */
> +	{ 0x12, KEY_BRIGHTNESSUP },
> +	{ 0x13, KEY_BRIGHTNESSDOWN },
> +	{ 0x2b, KEY_MODE },		/* stereo/mono */
> +	{ 0x2c, KEY_TEXT },		/* teletext */
> +	{ 0x20, KEY_CHANNELUP },	/* channel up */
> +	{ 0x21, KEY_CHANNELDOWN },	/* channel down */
> +	{ 0x10, KEY_VOLUMEUP },		/* volume up */
> +	{ 0x11, KEY_VOLUMEDOWN },	/* volume down */
> +	{ 0x0d, KEY_MUTE },
> +	{ 0x1f, KEY_RECORD },
> +	{ 0x17, KEY_PLAY },
> +	{ 0x16, KEY_PAUSE },
> +	{ 0x0b, KEY_STOP },
> +	{ 0x27, KEY_FASTFORWARD },
> +	{ 0x26, KEY_REWIND },
> +	{ 0x1e, KEY_SEARCH },		/* autoscan */
> +	{ 0x0e, KEY_CAMERA },		/* snapshot */
> +	{ 0x2d, KEY_SETUP },
> +	{ 0x0f, KEY_SCREEN },		/* full screen */
> +	{ 0x14, KEY_RADIO },		/* FM radio */
> +	{ 0x25, KEY_POWER },		/* power */
> +};
> +
> +static struct rc_keymap powercolor_real_angel_map = {
> +	.map = {
> +		.scan    = powercolor_real_angel,
> +		.size    = ARRAY_SIZE(powercolor_real_angel),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_POWERCOLOR_REAL_ANGEL,
> +	}
> +};
> +
> +static int __init init_rc_map_powercolor_real_angel(void)
> +{
> +	return ir_register_map(&powercolor_real_angel_map);
> +}
> +
> +static void __exit exit_rc_map_powercolor_real_angel(void)
> +{
> +	ir_unregister_map(&powercolor_real_angel_map);
> +}
> +
> +module_init(init_rc_map_powercolor_real_angel)
> +module_exit(exit_rc_map_powercolor_real_angel)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-proteus-2309.c b/drivers/media/IR/keymaps/rc-proteus-2309.c
> new file mode 100644
> index 0000000..22e92d3
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-proteus-2309.c
> @@ -0,0 +1,69 @@
> +/* proteus-2309.h - Keytable for proteus_2309 Remote Controller
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
> +
> +/* Michal Majchrowicz <mmajchrowicz@gmail.com> */
> +
> +static struct ir_scancode proteus_2309[] = {
> +	/* numeric */
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	{ 0x5c, KEY_POWER },		/* power       */
> +	{ 0x20, KEY_ZOOM },		/* full screen */
> +	{ 0x0f, KEY_BACKSPACE },	/* recall      */
> +	{ 0x1b, KEY_ENTER },		/* mute        */
> +	{ 0x41, KEY_RECORD },		/* record      */
> +	{ 0x43, KEY_STOP },		/* stop        */
> +	{ 0x16, KEY_S },
> +	{ 0x1a, KEY_POWER2 },		/* off         */
> +	{ 0x2e, KEY_RED },
> +	{ 0x1f, KEY_CHANNELDOWN },	/* channel -   */
> +	{ 0x1c, KEY_CHANNELUP },	/* channel +   */
> +	{ 0x10, KEY_VOLUMEDOWN },	/* volume -    */
> +	{ 0x1e, KEY_VOLUMEUP },		/* volume +    */
> +	{ 0x14, KEY_F1 },
> +};
> +
> +static struct rc_keymap proteus_2309_map = {
> +	.map = {
> +		.scan    = proteus_2309,
> +		.size    = ARRAY_SIZE(proteus_2309),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PROTEUS_2309,
> +	}
> +};
> +
> +static int __init init_rc_map_proteus_2309(void)
> +{
> +	return ir_register_map(&proteus_2309_map);
> +}
> +
> +static void __exit exit_rc_map_proteus_2309(void)
> +{
> +	ir_unregister_map(&proteus_2309_map);
> +}
> +
> +module_init(init_rc_map_proteus_2309)
> +module_exit(exit_rc_map_proteus_2309)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-purpletv.c b/drivers/media/IR/keymaps/rc-purpletv.c
> new file mode 100644
> index 0000000..4e20fc2
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-purpletv.c
> @@ -0,0 +1,81 @@
> +/* purpletv.h - Keytable for purpletv Remote Controller
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
> +
> +static struct ir_scancode purpletv[] = {
> +	{ 0x03, KEY_POWER },
> +	{ 0x6f, KEY_MUTE },
> +	{ 0x10, KEY_BACKSPACE },	/* Recall */
> +
> +	{ 0x11, KEY_0 },
> +	{ 0x04, KEY_1 },
> +	{ 0x05, KEY_2 },
> +	{ 0x06, KEY_3 },
> +	{ 0x08, KEY_4 },
> +	{ 0x09, KEY_5 },
> +	{ 0x0a, KEY_6 },
> +	{ 0x0c, KEY_7 },
> +	{ 0x0d, KEY_8 },
> +	{ 0x0e, KEY_9 },
> +	{ 0x12, KEY_DOT },	/* 100+ */
> +
> +	{ 0x07, KEY_VOLUMEUP },
> +	{ 0x0b, KEY_VOLUMEDOWN },
> +	{ 0x1a, KEY_KPPLUS },
> +	{ 0x18, KEY_KPMINUS },
> +	{ 0x15, KEY_UP },
> +	{ 0x1d, KEY_DOWN },
> +	{ 0x0f, KEY_CHANNELUP },
> +	{ 0x13, KEY_CHANNELDOWN },
> +	{ 0x48, KEY_ZOOM },
> +
> +	{ 0x1b, KEY_VIDEO },	/* Video source */
> +	{ 0x1f, KEY_CAMERA },	/* Snapshot */
> +	{ 0x49, KEY_LANGUAGE },	/* MTS Select */
> +	{ 0x19, KEY_SEARCH },	/* Auto Scan */
> +
> +	{ 0x4b, KEY_RECORD },
> +	{ 0x46, KEY_PLAY },
> +	{ 0x45, KEY_PAUSE },	/* Pause */
> +	{ 0x44, KEY_STOP },
> +	{ 0x43, KEY_TIME },	/* Time Shift */
> +	{ 0x17, KEY_CHANNEL },	/* SURF CH */
> +	{ 0x40, KEY_FORWARD },	/* Forward ? */
> +	{ 0x42, KEY_REWIND },	/* Backward ? */
> +
> +};
> +
> +static struct rc_keymap purpletv_map = {
> +	.map = {
> +		.scan    = purpletv,
> +		.size    = ARRAY_SIZE(purpletv),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PURPLETV,
> +	}
> +};
> +
> +static int __init init_rc_map_purpletv(void)
> +{
> +	return ir_register_map(&purpletv_map);
> +}
> +
> +static void __exit exit_rc_map_purpletv(void)
> +{
> +	ir_unregister_map(&purpletv_map);
> +}
> +
> +module_init(init_rc_map_purpletv)
> +module_exit(exit_rc_map_purpletv)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-pv951.c b/drivers/media/IR/keymaps/rc-pv951.c
> new file mode 100644
> index 0000000..36679e7
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-pv951.c
> @@ -0,0 +1,78 @@
> +/* pv951.h - Keytable for pv951 Remote Controller
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
> +
> +/* Mark Phalan <phalanm@o2.ie> */
> +
> +static struct ir_scancode pv951[] = {
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	{ 0x12, KEY_POWER },
> +	{ 0x10, KEY_MUTE },
> +	{ 0x1f, KEY_VOLUMEDOWN },
> +	{ 0x1b, KEY_VOLUMEUP },
> +	{ 0x1a, KEY_CHANNELUP },
> +	{ 0x1e, KEY_CHANNELDOWN },
> +	{ 0x0e, KEY_PAGEUP },
> +	{ 0x1d, KEY_PAGEDOWN },
> +	{ 0x13, KEY_SOUND },
> +
> +	{ 0x18, KEY_KPPLUSMINUS },	/* CH +/- */
> +	{ 0x16, KEY_SUBTITLE },		/* CC */
> +	{ 0x0d, KEY_TEXT },		/* TTX */
> +	{ 0x0b, KEY_TV },		/* AIR/CBL */
> +	{ 0x11, KEY_PC },		/* PC/TV */
> +	{ 0x17, KEY_OK },		/* CH RTN */
> +	{ 0x19, KEY_MODE },		/* FUNC */
> +	{ 0x0c, KEY_SEARCH },		/* AUTOSCAN */
> +
> +	/* Not sure what to do with these ones! */
> +	{ 0x0f, KEY_SELECT },		/* SOURCE */
> +	{ 0x0a, KEY_KPPLUS },		/* +100 */
> +	{ 0x14, KEY_EQUAL },		/* SYNC */
> +	{ 0x1c, KEY_MEDIA },		/* PC/TV */
> +};
> +
> +static struct rc_keymap pv951_map = {
> +	.map = {
> +		.scan    = pv951,
> +		.size    = ARRAY_SIZE(pv951),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_PV951,
> +	}
> +};
> +
> +static int __init init_rc_map_pv951(void)
> +{
> +	return ir_register_map(&pv951_map);
> +}
> +
> +static void __exit exit_rc_map_pv951(void)
> +{
> +	ir_unregister_map(&pv951_map);
> +}
> +
> +module_init(init_rc_map_pv951)
> +module_exit(exit_rc_map_pv951)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c b/drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
> new file mode 100644
> index 0000000..cc6b8f5
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-rc5-hauppauge-new.c
> @@ -0,0 +1,103 @@
> +/* rc5-hauppauge-new.h - Keytable for rc5_hauppauge_new Remote Controller
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
> +
> +/*
> + * Hauppauge:the newer, gray remotes (seems there are multiple
> + * slightly different versions), shipped with cx88+ivtv cards.
> + *
> + * This table contains the complete RC5 code, instead of just the data part
> + */
> +
> +static struct ir_scancode rc5_hauppauge_new[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x1e00, KEY_0 },
> +	{ 0x1e01, KEY_1 },
> +	{ 0x1e02, KEY_2 },
> +	{ 0x1e03, KEY_3 },
> +	{ 0x1e04, KEY_4 },
> +	{ 0x1e05, KEY_5 },
> +	{ 0x1e06, KEY_6 },
> +	{ 0x1e07, KEY_7 },
> +	{ 0x1e08, KEY_8 },
> +	{ 0x1e09, KEY_9 },
> +
> +	{ 0x1e0a, KEY_TEXT },		/* keypad asterisk as well */
> +	{ 0x1e0b, KEY_RED },		/* red button */
> +	{ 0x1e0c, KEY_RADIO },
> +	{ 0x1e0d, KEY_MENU },
> +	{ 0x1e0e, KEY_SUBTITLE },		/* also the # key */
> +	{ 0x1e0f, KEY_MUTE },
> +	{ 0x1e10, KEY_VOLUMEUP },
> +	{ 0x1e11, KEY_VOLUMEDOWN },
> +	{ 0x1e12, KEY_PREVIOUS },		/* previous channel */
> +	{ 0x1e14, KEY_UP },
> +	{ 0x1e15, KEY_DOWN },
> +	{ 0x1e16, KEY_LEFT },
> +	{ 0x1e17, KEY_RIGHT },
> +	{ 0x1e18, KEY_VIDEO },		/* Videos */
> +	{ 0x1e19, KEY_AUDIO },		/* Music */
> +	/* 0x1e1a: Pictures - presume this means
> +	   "Multimedia Home Platform" -
> +	   no "PICTURES" key in input.h
> +	 */
> +	{ 0x1e1a, KEY_MHP },
> +
> +	{ 0x1e1b, KEY_EPG },		/* Guide */
> +	{ 0x1e1c, KEY_TV },
> +	{ 0x1e1e, KEY_NEXTSONG },		/* skip >| */
> +	{ 0x1e1f, KEY_EXIT },		/* back/exit */
> +	{ 0x1e20, KEY_CHANNELUP },	/* channel / program + */
> +	{ 0x1e21, KEY_CHANNELDOWN },	/* channel / program - */
> +	{ 0x1e22, KEY_CHANNEL },		/* source (old black remote) */
> +	{ 0x1e24, KEY_PREVIOUSSONG },	/* replay |< */
> +	{ 0x1e25, KEY_ENTER },		/* OK */
> +	{ 0x1e26, KEY_SLEEP },		/* minimize (old black remote) */
> +	{ 0x1e29, KEY_BLUE },		/* blue key */
> +	{ 0x1e2e, KEY_GREEN },		/* green button */
> +	{ 0x1e30, KEY_PAUSE },		/* pause */
> +	{ 0x1e32, KEY_REWIND },		/* backward << */
> +	{ 0x1e34, KEY_FASTFORWARD },	/* forward >> */
> +	{ 0x1e35, KEY_PLAY },
> +	{ 0x1e36, KEY_STOP },
> +	{ 0x1e37, KEY_RECORD },		/* recording */
> +	{ 0x1e38, KEY_YELLOW },		/* yellow key */
> +	{ 0x1e3b, KEY_SELECT },		/* top right button */
> +	{ 0x1e3c, KEY_ZOOM },		/* full */
> +	{ 0x1e3d, KEY_POWER },		/* system power (green button) */
> +};
> +
> +static struct rc_keymap rc5_hauppauge_new_map = {
> +	.map = {
> +		.scan    = rc5_hauppauge_new,
> +		.size    = ARRAY_SIZE(rc5_hauppauge_new),
> +		.ir_type = IR_TYPE_RC5,
> +		.name    = RC_MAP_RC5_HAUPPAUGE_NEW,
> +	}
> +};
> +
> +static int __init init_rc_map_rc5_hauppauge_new(void)
> +{
> +	return ir_register_map(&rc5_hauppauge_new_map);
> +}
> +
> +static void __exit exit_rc_map_rc5_hauppauge_new(void)
> +{
> +	ir_unregister_map(&rc5_hauppauge_new_map);
> +}
> +
> +module_init(init_rc_map_rc5_hauppauge_new)
> +module_exit(exit_rc_map_rc5_hauppauge_new)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-rc5-tv.c b/drivers/media/IR/keymaps/rc-rc5-tv.c
> new file mode 100644
> index 0000000..73cce2f
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-rc5-tv.c
> @@ -0,0 +1,81 @@
> +/* rc5-tv.h - Keytable for rc5_tv Remote Controller
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
> +
> +/* generic RC5 keytable                                          */
> +/* see http://users.pandora.be/nenya/electronics/rc5/codes00.htm */
> +/* used by old (black) Hauppauge remotes                         */
> +
> +static struct ir_scancode rc5_tv[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x00, KEY_0 },
> +	{ 0x01, KEY_1 },
> +	{ 0x02, KEY_2 },
> +	{ 0x03, KEY_3 },
> +	{ 0x04, KEY_4 },
> +	{ 0x05, KEY_5 },
> +	{ 0x06, KEY_6 },
> +	{ 0x07, KEY_7 },
> +	{ 0x08, KEY_8 },
> +	{ 0x09, KEY_9 },
> +
> +	{ 0x0b, KEY_CHANNEL },		/* channel / program (japan: 11) */
> +	{ 0x0c, KEY_POWER },		/* standby */
> +	{ 0x0d, KEY_MUTE },		/* mute / demute */
> +	{ 0x0f, KEY_TV },		/* display */
> +	{ 0x10, KEY_VOLUMEUP },
> +	{ 0x11, KEY_VOLUMEDOWN },
> +	{ 0x12, KEY_BRIGHTNESSUP },
> +	{ 0x13, KEY_BRIGHTNESSDOWN },
> +	{ 0x1e, KEY_SEARCH },		/* search + */
> +	{ 0x20, KEY_CHANNELUP },	/* channel / program + */
> +	{ 0x21, KEY_CHANNELDOWN },	/* channel / program - */
> +	{ 0x22, KEY_CHANNEL },		/* alt / channel */
> +	{ 0x23, KEY_LANGUAGE },		/* 1st / 2nd language */
> +	{ 0x26, KEY_SLEEP },		/* sleeptimer */
> +	{ 0x2e, KEY_MENU },		/* 2nd controls (USA: menu) */
> +	{ 0x30, KEY_PAUSE },
> +	{ 0x32, KEY_REWIND },
> +	{ 0x33, KEY_GOTO },
> +	{ 0x35, KEY_PLAY },
> +	{ 0x36, KEY_STOP },
> +	{ 0x37, KEY_RECORD },		/* recording */
> +	{ 0x3c, KEY_TEXT },		/* teletext submode (Japan: 12) */
> +	{ 0x3d, KEY_SUSPEND },		/* system standby */
> +
> +};
> +
> +static struct rc_keymap rc5_tv_map = {
> +	.map = {
> +		.scan    = rc5_tv,
> +		.size    = ARRAY_SIZE(rc5_tv),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_RC5_TV,
> +	}
> +};
> +
> +static int __init init_rc_map_rc5_tv(void)
> +{
> +	return ir_register_map(&rc5_tv_map);
> +}
> +
> +static void __exit exit_rc_map_rc5_tv(void)
> +{
> +	ir_unregister_map(&rc5_tv_map);
> +}
> +
> +module_init(init_rc_map_rc5_tv)
> +module_exit(exit_rc_map_rc5_tv)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
> new file mode 100644
> index 0000000..ab1a6d2
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-real-audio-220-32-keys.c
> @@ -0,0 +1,78 @@
> +/* real-audio-220-32-keys.h - Keytable for real_audio_220_32_keys Remote Controller
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
> +
> +/* Zogis Real Audio 220 - 32 keys IR */
> +
> +static struct ir_scancode real_audio_220_32_keys[] = {
> +	{ 0x1c, KEY_RADIO},
> +	{ 0x12, KEY_POWER2},
> +
> +	{ 0x01, KEY_1},
> +	{ 0x02, KEY_2},
> +	{ 0x03, KEY_3},
> +	{ 0x04, KEY_4},
> +	{ 0x05, KEY_5},
> +	{ 0x06, KEY_6},
> +	{ 0x07, KEY_7},
> +	{ 0x08, KEY_8},
> +	{ 0x09, KEY_9},
> +	{ 0x00, KEY_0},
> +
> +	{ 0x0c, KEY_VOLUMEUP},
> +	{ 0x18, KEY_VOLUMEDOWN},
> +	{ 0x0b, KEY_CHANNELUP},
> +	{ 0x15, KEY_CHANNELDOWN},
> +	{ 0x16, KEY_ENTER},
> +
> +	{ 0x11, KEY_LIST},		/* Source */
> +	{ 0x0d, KEY_AUDIO},		/* stereo */
> +
> +	{ 0x0f, KEY_PREVIOUS},		/* Prev */
> +	{ 0x1b, KEY_TIME},		/* Timeshift */
> +	{ 0x1a, KEY_NEXT},		/* Next */
> +
> +	{ 0x0e, KEY_STOP},
> +	{ 0x1f, KEY_PLAY},
> +	{ 0x1e, KEY_PLAYPAUSE},		/* Pause */
> +
> +	{ 0x1d, KEY_RECORD},
> +	{ 0x13, KEY_MUTE},
> +	{ 0x19, KEY_CAMERA},		/* Snapshot */
> +
> +};
> +
> +static struct rc_keymap real_audio_220_32_keys_map = {
> +	.map = {
> +		.scan    = real_audio_220_32_keys,
> +		.size    = ARRAY_SIZE(real_audio_220_32_keys),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_REAL_AUDIO_220_32_KEYS,
> +	}
> +};
> +
> +static int __init init_rc_map_real_audio_220_32_keys(void)
> +{
> +	return ir_register_map(&real_audio_220_32_keys_map);
> +}
> +
> +static void __exit exit_rc_map_real_audio_220_32_keys(void)
> +{
> +	ir_unregister_map(&real_audio_220_32_keys_map);
> +}
> +
> +module_init(init_rc_map_real_audio_220_32_keys)
> +module_exit(exit_rc_map_real_audio_220_32_keys)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-tbs-nec.c b/drivers/media/IR/keymaps/rc-tbs-nec.c
> new file mode 100644
> index 0000000..3309631
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-tbs-nec.c
> @@ -0,0 +1,73 @@
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
> +
> +static struct ir_scancode tbs_nec[] = {
> +	{ 0x04, KEY_POWER2},	/*power*/
> +	{ 0x14, KEY_MUTE},	/*mute*/
> +	{ 0x07, KEY_1},
> +	{ 0x06, KEY_2},
> +	{ 0x05, KEY_3},
> +	{ 0x0b, KEY_4},
> +	{ 0x0a, KEY_5},
> +	{ 0x09, KEY_6},
> +	{ 0x0f, KEY_7},
> +	{ 0x0e, KEY_8},
> +	{ 0x0d, KEY_9},
> +	{ 0x12, KEY_0},
> +	{ 0x16, KEY_CHANNELUP},	/*ch+*/
> +	{ 0x11, KEY_CHANNELDOWN},/*ch-*/
> +	{ 0x13, KEY_VOLUMEUP},	/*vol+*/
> +	{ 0x0c, KEY_VOLUMEDOWN},/*vol-*/
> +	{ 0x03, KEY_RECORD},	/*rec*/
> +	{ 0x18, KEY_PAUSE},	/*pause*/
> +	{ 0x19, KEY_OK},	/*ok*/
> +	{ 0x1a, KEY_CAMERA},	/* snapshot */
> +	{ 0x01, KEY_UP},
> +	{ 0x10, KEY_LEFT},
> +	{ 0x02, KEY_RIGHT},
> +	{ 0x08, KEY_DOWN},
> +	{ 0x15, KEY_FAVORITES},
> +	{ 0x17, KEY_SUBTITLE},
> +	{ 0x1d, KEY_ZOOM},
> +	{ 0x1f, KEY_EXIT},
> +	{ 0x1e, KEY_MENU},
> +	{ 0x1c, KEY_EPG},
> +	{ 0x00, KEY_PREVIOUS},
> +	{ 0x1b, KEY_MODE},
> +};
> +
> +static struct rc_keymap tbs_nec_map = {
> +	.map = {
> +		.scan    = tbs_nec,
> +		.size    = ARRAY_SIZE(tbs_nec),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_TBS_NEC,
> +	}
> +};
> +
> +static int __init init_rc_map_tbs_nec(void)
> +{
> +	return ir_register_map(&tbs_nec_map);
> +}
> +
> +static void __exit exit_rc_map_tbs_nec(void)
> +{
> +	ir_unregister_map(&tbs_nec_map);
> +}
> +
> +module_init(init_rc_map_tbs_nec)
> +module_exit(exit_rc_map_tbs_nec)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
> new file mode 100644
> index 0000000..5326a0b
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-terratec-cinergy-xs.c
> @@ -0,0 +1,92 @@
> +/* terratec-cinergy-xs.h - Keytable for terratec_cinergy_xs Remote Controller
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
> +
> +/* Terratec Cinergy Hybrid T USB XS
> +   Devin Heitmueller <dheitmueller@linuxtv.org>
> + */
> +
> +static struct ir_scancode terratec_cinergy_xs[] = {
> +	{ 0x41, KEY_HOME},
> +	{ 0x01, KEY_POWER},
> +	{ 0x42, KEY_MENU},
> +	{ 0x02, KEY_1},
> +	{ 0x03, KEY_2},
> +	{ 0x04, KEY_3},
> +	{ 0x43, KEY_SUBTITLE},
> +	{ 0x05, KEY_4},
> +	{ 0x06, KEY_5},
> +	{ 0x07, KEY_6},
> +	{ 0x44, KEY_TEXT},
> +	{ 0x08, KEY_7},
> +	{ 0x09, KEY_8},
> +	{ 0x0a, KEY_9},
> +	{ 0x45, KEY_DELETE},
> +	{ 0x0b, KEY_TUNER},
> +	{ 0x0c, KEY_0},
> +	{ 0x0d, KEY_MODE},
> +	{ 0x46, KEY_TV},
> +	{ 0x47, KEY_DVD},
> +	{ 0x49, KEY_VIDEO},
> +	{ 0x4b, KEY_AUX},
> +	{ 0x10, KEY_UP},
> +	{ 0x11, KEY_LEFT},
> +	{ 0x12, KEY_OK},
> +	{ 0x13, KEY_RIGHT},
> +	{ 0x14, KEY_DOWN},
> +	{ 0x0f, KEY_EPG},
> +	{ 0x16, KEY_INFO},
> +	{ 0x4d, KEY_BACKSPACE},
> +	{ 0x1c, KEY_VOLUMEUP},
> +	{ 0x4c, KEY_PLAY},
> +	{ 0x1b, KEY_CHANNELUP},
> +	{ 0x1e, KEY_VOLUMEDOWN},
> +	{ 0x1d, KEY_MUTE},
> +	{ 0x1f, KEY_CHANNELDOWN},
> +	{ 0x17, KEY_RED},
> +	{ 0x18, KEY_GREEN},
> +	{ 0x19, KEY_YELLOW},
> +	{ 0x1a, KEY_BLUE},
> +	{ 0x58, KEY_RECORD},
> +	{ 0x48, KEY_STOP},
> +	{ 0x40, KEY_PAUSE},
> +	{ 0x54, KEY_LAST},
> +	{ 0x4e, KEY_REWIND},
> +	{ 0x4f, KEY_FASTFORWARD},
> +	{ 0x5c, KEY_NEXT},
> +};
> +
> +static struct rc_keymap terratec_cinergy_xs_map = {
> +	.map = {
> +		.scan    = terratec_cinergy_xs,
> +		.size    = ARRAY_SIZE(terratec_cinergy_xs),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_TERRATEC_CINERGY_XS,
> +	}
> +};
> +
> +static int __init init_rc_map_terratec_cinergy_xs(void)
> +{
> +	return ir_register_map(&terratec_cinergy_xs_map);
> +}
> +
> +static void __exit exit_rc_map_terratec_cinergy_xs(void)
> +{
> +	ir_unregister_map(&terratec_cinergy_xs_map);
> +}
> +
> +module_init(init_rc_map_terratec_cinergy_xs)
> +module_exit(exit_rc_map_terratec_cinergy_xs)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-tevii-nec.c b/drivers/media/IR/keymaps/rc-tevii-nec.c
> new file mode 100644
> index 0000000..e30d411
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-tevii-nec.c
> @@ -0,0 +1,88 @@
> +/* tevii-nec.h - Keytable for tevii_nec Remote Controller
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
> +
> +static struct ir_scancode tevii_nec[] = {
> +	{ 0x0a, KEY_POWER2},
> +	{ 0x0c, KEY_MUTE},
> +	{ 0x11, KEY_1},
> +	{ 0x12, KEY_2},
> +	{ 0x13, KEY_3},
> +	{ 0x14, KEY_4},
> +	{ 0x15, KEY_5},
> +	{ 0x16, KEY_6},
> +	{ 0x17, KEY_7},
> +	{ 0x18, KEY_8},
> +	{ 0x19, KEY_9},
> +	{ 0x10, KEY_0},
> +	{ 0x1c, KEY_MENU},
> +	{ 0x0f, KEY_VOLUMEDOWN},
> +	{ 0x1a, KEY_LAST},
> +	{ 0x0e, KEY_OPEN},
> +	{ 0x04, KEY_RECORD},
> +	{ 0x09, KEY_VOLUMEUP},
> +	{ 0x08, KEY_CHANNELUP},
> +	{ 0x07, KEY_PVR},
> +	{ 0x0b, KEY_TIME},
> +	{ 0x02, KEY_RIGHT},
> +	{ 0x03, KEY_LEFT},
> +	{ 0x00, KEY_UP},
> +	{ 0x1f, KEY_OK},
> +	{ 0x01, KEY_DOWN},
> +	{ 0x05, KEY_TUNER},
> +	{ 0x06, KEY_CHANNELDOWN},
> +	{ 0x40, KEY_PLAYPAUSE},
> +	{ 0x1e, KEY_REWIND},
> +	{ 0x1b, KEY_FAVORITES},
> +	{ 0x1d, KEY_BACK},
> +	{ 0x4d, KEY_FASTFORWARD},
> +	{ 0x44, KEY_EPG},
> +	{ 0x4c, KEY_INFO},
> +	{ 0x41, KEY_AB},
> +	{ 0x43, KEY_AUDIO},
> +	{ 0x45, KEY_SUBTITLE},
> +	{ 0x4a, KEY_LIST},
> +	{ 0x46, KEY_F1},
> +	{ 0x47, KEY_F2},
> +	{ 0x5e, KEY_F3},
> +	{ 0x5c, KEY_F4},
> +	{ 0x52, KEY_F5},
> +	{ 0x5a, KEY_F6},
> +	{ 0x56, KEY_MODE},
> +	{ 0x58, KEY_SWITCHVIDEOMODE},
> +};
> +
> +static struct rc_keymap tevii_nec_map = {
> +	.map = {
> +		.scan    = tevii_nec,
> +		.size    = ARRAY_SIZE(tevii_nec),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_TEVII_NEC,
> +	}
> +};
> +
> +static int __init init_rc_map_tevii_nec(void)
> +{
> +	return ir_register_map(&tevii_nec_map);
> +}
> +
> +static void __exit exit_rc_map_tevii_nec(void)
> +{
> +	ir_unregister_map(&tevii_nec_map);
> +}
> +
> +module_init(init_rc_map_tevii_nec)
> +module_exit(exit_rc_map_tevii_nec)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-tt-1500.c b/drivers/media/IR/keymaps/rc-tt-1500.c
> new file mode 100644
> index 0000000..bc88de0
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-tt-1500.c
> @@ -0,0 +1,82 @@
> +/* tt-1500.h - Keytable for tt_1500 Remote Controller
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
> +
> +/* for the Technotrend 1500 bundled remotes (grey and black): */
> +
> +static struct ir_scancode tt_1500[] = {
> +	{ 0x01, KEY_POWER },
> +	{ 0x02, KEY_SHUFFLE },		/* ? double-arrow key */
> +	{ 0x03, KEY_1 },
> +	{ 0x04, KEY_2 },
> +	{ 0x05, KEY_3 },
> +	{ 0x06, KEY_4 },
> +	{ 0x07, KEY_5 },
> +	{ 0x08, KEY_6 },
> +	{ 0x09, KEY_7 },
> +	{ 0x0a, KEY_8 },
> +	{ 0x0b, KEY_9 },
> +	{ 0x0c, KEY_0 },
> +	{ 0x0d, KEY_UP },
> +	{ 0x0e, KEY_LEFT },
> +	{ 0x0f, KEY_OK },
> +	{ 0x10, KEY_RIGHT },
> +	{ 0x11, KEY_DOWN },
> +	{ 0x12, KEY_INFO },
> +	{ 0x13, KEY_EXIT },
> +	{ 0x14, KEY_RED },
> +	{ 0x15, KEY_GREEN },
> +	{ 0x16, KEY_YELLOW },
> +	{ 0x17, KEY_BLUE },
> +	{ 0x18, KEY_MUTE },
> +	{ 0x19, KEY_TEXT },
> +	{ 0x1a, KEY_MODE },		/* ? TV/Radio */
> +	{ 0x21, KEY_OPTION },
> +	{ 0x22, KEY_EPG },
> +	{ 0x23, KEY_CHANNELUP },
> +	{ 0x24, KEY_CHANNELDOWN },
> +	{ 0x25, KEY_VOLUMEUP },
> +	{ 0x26, KEY_VOLUMEDOWN },
> +	{ 0x27, KEY_SETUP },
> +	{ 0x3a, KEY_RECORD },		/* these keys are only in the black remote */
> +	{ 0x3b, KEY_PLAY },
> +	{ 0x3c, KEY_STOP },
> +	{ 0x3d, KEY_REWIND },
> +	{ 0x3e, KEY_PAUSE },
> +	{ 0x3f, KEY_FORWARD },
> +};
> +
> +static struct rc_keymap tt_1500_map = {
> +	.map = {
> +		.scan    = tt_1500,
> +		.size    = ARRAY_SIZE(tt_1500),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_TT_1500,
> +	}
> +};
> +
> +static int __init init_rc_map_tt_1500(void)
> +{
> +	return ir_register_map(&tt_1500_map);
> +}
> +
> +static void __exit exit_rc_map_tt_1500(void)
> +{
> +	ir_unregister_map(&tt_1500_map);
> +}
> +
> +module_init(init_rc_map_tt_1500)
> +module_exit(exit_rc_map_tt_1500)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-videomate-s350.c b/drivers/media/IR/keymaps/rc-videomate-s350.c
> new file mode 100644
> index 0000000..4df7fcd
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-videomate-s350.c
> @@ -0,0 +1,85 @@
> +/* videomate-s350.h - Keytable for videomate_s350 Remote Controller
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
> +
> +static struct ir_scancode videomate_s350[] = {
> +	{ 0x00, KEY_TV},
> +	{ 0x01, KEY_DVD},
> +	{ 0x04, KEY_RECORD},
> +	{ 0x05, KEY_VIDEO},	/* TV/Video */
> +	{ 0x07, KEY_STOP},
> +	{ 0x08, KEY_PLAYPAUSE},
> +	{ 0x0a, KEY_REWIND},
> +	{ 0x0f, KEY_FASTFORWARD},
> +	{ 0x10, KEY_CHANNELUP},
> +	{ 0x12, KEY_VOLUMEUP},
> +	{ 0x13, KEY_CHANNELDOWN},
> +	{ 0x14, KEY_MUTE},
> +	{ 0x15, KEY_VOLUMEDOWN},
> +	{ 0x16, KEY_1},
> +	{ 0x17, KEY_2},
> +	{ 0x18, KEY_3},
> +	{ 0x19, KEY_4},
> +	{ 0x1a, KEY_5},
> +	{ 0x1b, KEY_6},
> +	{ 0x1c, KEY_7},
> +	{ 0x1d, KEY_8},
> +	{ 0x1e, KEY_9},
> +	{ 0x1f, KEY_0},
> +	{ 0x21, KEY_SLEEP},
> +	{ 0x24, KEY_ZOOM},
> +	{ 0x25, KEY_LAST},	/* Recall */
> +	{ 0x26, KEY_SUBTITLE},	/* CC */
> +	{ 0x27, KEY_LANGUAGE},	/* MTS */
> +	{ 0x29, KEY_CHANNEL},	/* SURF */
> +	{ 0x2b, KEY_A},
> +	{ 0x2c, KEY_B},
> +	{ 0x2f, KEY_CAMERA},	/* Snapshot */
> +	{ 0x23, KEY_RADIO},
> +	{ 0x02, KEY_PREVIOUSSONG},
> +	{ 0x06, KEY_NEXTSONG},
> +	{ 0x03, KEY_EPG},
> +	{ 0x09, KEY_SETUP},
> +	{ 0x22, KEY_BACKSPACE},
> +	{ 0x0c, KEY_UP},
> +	{ 0x0e, KEY_DOWN},
> +	{ 0x0b, KEY_LEFT},
> +	{ 0x0d, KEY_RIGHT},
> +	{ 0x11, KEY_ENTER},
> +	{ 0x20, KEY_TEXT},
> +};
> +
> +static struct rc_keymap videomate_s350_map = {
> +	.map = {
> +		.scan    = videomate_s350,
> +		.size    = ARRAY_SIZE(videomate_s350),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_VIDEOMATE_S350,
> +	}
> +};
> +
> +static int __init init_rc_map_videomate_s350(void)
> +{
> +	return ir_register_map(&videomate_s350_map);
> +}
> +
> +static void __exit exit_rc_map_videomate_s350(void)
> +{
> +	ir_unregister_map(&videomate_s350_map);
> +}
> +
> +module_init(init_rc_map_videomate_s350)
> +module_exit(exit_rc_map_videomate_s350)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-videomate-tv-pvr.c b/drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
> new file mode 100644
> index 0000000..776b0a6
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-videomate-tv-pvr.c
> @@ -0,0 +1,87 @@
> +/* videomate-tv-pvr.h - Keytable for videomate_tv_pvr Remote Controller
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
> +
> +static struct ir_scancode videomate_tv_pvr[] = {
> +	{ 0x14, KEY_MUTE },
> +	{ 0x24, KEY_ZOOM },
> +
> +	{ 0x01, KEY_DVD },
> +	{ 0x23, KEY_RADIO },
> +	{ 0x00, KEY_TV },
> +
> +	{ 0x0a, KEY_REWIND },
> +	{ 0x08, KEY_PLAYPAUSE },
> +	{ 0x0f, KEY_FORWARD },
> +
> +	{ 0x02, KEY_PREVIOUS },
> +	{ 0x07, KEY_STOP },
> +	{ 0x06, KEY_NEXT },
> +
> +	{ 0x0c, KEY_UP },
> +	{ 0x0e, KEY_DOWN },
> +	{ 0x0b, KEY_LEFT },
> +	{ 0x0d, KEY_RIGHT },
> +	{ 0x11, KEY_OK },
> +
> +	{ 0x03, KEY_MENU },
> +	{ 0x09, KEY_SETUP },
> +	{ 0x05, KEY_VIDEO },
> +	{ 0x22, KEY_CHANNEL },
> +
> +	{ 0x12, KEY_VOLUMEUP },
> +	{ 0x15, KEY_VOLUMEDOWN },
> +	{ 0x10, KEY_CHANNELUP },
> +	{ 0x13, KEY_CHANNELDOWN },
> +
> +	{ 0x04, KEY_RECORD },
> +
> +	{ 0x16, KEY_1 },
> +	{ 0x17, KEY_2 },
> +	{ 0x18, KEY_3 },
> +	{ 0x19, KEY_4 },
> +	{ 0x1a, KEY_5 },
> +	{ 0x1b, KEY_6 },
> +	{ 0x1c, KEY_7 },
> +	{ 0x1d, KEY_8 },
> +	{ 0x1e, KEY_9 },
> +	{ 0x1f, KEY_0 },
> +
> +	{ 0x20, KEY_LANGUAGE },
> +	{ 0x21, KEY_SLEEP },
> +};
> +
> +static struct rc_keymap videomate_tv_pvr_map = {
> +	.map = {
> +		.scan    = videomate_tv_pvr,
> +		.size    = ARRAY_SIZE(videomate_tv_pvr),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_VIDEOMATE_TV_PVR,
> +	}
> +};
> +
> +static int __init init_rc_map_videomate_tv_pvr(void)
> +{
> +	return ir_register_map(&videomate_tv_pvr_map);
> +}
> +
> +static void __exit exit_rc_map_videomate_tv_pvr(void)
> +{
> +	ir_unregister_map(&videomate_tv_pvr_map);
> +}
> +
> +module_init(init_rc_map_videomate_tv_pvr)
> +module_exit(exit_rc_map_videomate_tv_pvr)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
> new file mode 100644
> index 0000000..9d2d550
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-winfast-usbii-deluxe.c
> @@ -0,0 +1,82 @@
> +/* winfast-usbii-deluxe.h - Keytable for winfast_usbii_deluxe Remote Controller
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
> +
> +/* Leadtek Winfast TV USB II Deluxe remote
> +   Magnus Alm <magnus.alm@gmail.com>
> + */
> +
> +static struct ir_scancode winfast_usbii_deluxe[] = {
> +	{ 0x62, KEY_0},
> +	{ 0x75, KEY_1},
> +	{ 0x76, KEY_2},
> +	{ 0x77, KEY_3},
> +	{ 0x79, KEY_4},
> +	{ 0x7a, KEY_5},
> +	{ 0x7b, KEY_6},
> +	{ 0x7d, KEY_7},
> +	{ 0x7e, KEY_8},
> +	{ 0x7f, KEY_9},
> +
> +	{ 0x38, KEY_CAMERA},		/* SNAPSHOT */
> +	{ 0x37, KEY_RECORD},		/* RECORD */
> +	{ 0x35, KEY_TIME},		/* TIMESHIFT */
> +
> +	{ 0x74, KEY_VOLUMEUP},		/* VOLUMEUP */
> +	{ 0x78, KEY_VOLUMEDOWN},	/* VOLUMEDOWN */
> +	{ 0x64, KEY_MUTE},		/* MUTE */
> +
> +	{ 0x21, KEY_CHANNEL},		/* SURF */
> +	{ 0x7c, KEY_CHANNELUP},		/* CHANNELUP */
> +	{ 0x60, KEY_CHANNELDOWN},	/* CHANNELDOWN */
> +	{ 0x61, KEY_LAST},		/* LAST CHANNEL (RECALL) */
> +
> +	{ 0x72, KEY_VIDEO}, 		/* INPUT MODES (TV/FM) */
> +
> +	{ 0x70, KEY_POWER2},		/* TV ON/OFF */
> +
> +	{ 0x39, KEY_CYCLEWINDOWS},	/* MINIMIZE (BOSS) */
> +	{ 0x3a, KEY_NEW},		/* PIP */
> +	{ 0x73, KEY_ZOOM},		/* FULLSECREEN */
> +
> +	{ 0x66, KEY_INFO},		/* OSD (DISPLAY) */
> +
> +	{ 0x31, KEY_DOT},		/* '.' */
> +	{ 0x63, KEY_ENTER},		/* ENTER */
> +
> +};
> +
> +static struct rc_keymap winfast_usbii_deluxe_map = {
> +	.map = {
> +		.scan    = winfast_usbii_deluxe,
> +		.size    = ARRAY_SIZE(winfast_usbii_deluxe),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_WINFAST_USBII_DELUXE,
> +	}
> +};
> +
> +static int __init init_rc_map_winfast_usbii_deluxe(void)
> +{
> +	return ir_register_map(&winfast_usbii_deluxe_map);
> +}
> +
> +static void __exit exit_rc_map_winfast_usbii_deluxe(void)
> +{
> +	ir_unregister_map(&winfast_usbii_deluxe_map);
> +}
> +
> +module_init(init_rc_map_winfast_usbii_deluxe)
> +module_exit(exit_rc_map_winfast_usbii_deluxe)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/keymaps/rc-winfast.c b/drivers/media/IR/keymaps/rc-winfast.c
> new file mode 100644
> index 0000000..0e90a3b
> --- /dev/null
> +++ b/drivers/media/IR/keymaps/rc-winfast.c
> @@ -0,0 +1,102 @@
> +/* winfast.h - Keytable for winfast Remote Controller
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
> +
> +/* Table for Leadtek Winfast Remote Controls - used by both bttv and cx88 */
> +
> +static struct ir_scancode winfast[] = {
> +	/* Keys 0 to 9 */
> +	{ 0x12, KEY_0 },
> +	{ 0x05, KEY_1 },
> +	{ 0x06, KEY_2 },
> +	{ 0x07, KEY_3 },
> +	{ 0x09, KEY_4 },
> +	{ 0x0a, KEY_5 },
> +	{ 0x0b, KEY_6 },
> +	{ 0x0d, KEY_7 },
> +	{ 0x0e, KEY_8 },
> +	{ 0x0f, KEY_9 },
> +
> +	{ 0x00, KEY_POWER },
> +	{ 0x1b, KEY_AUDIO },		/* Audio Source */
> +	{ 0x02, KEY_TUNER },		/* TV/FM, not on Y0400052 */
> +	{ 0x1e, KEY_VIDEO },		/* Video Source */
> +	{ 0x16, KEY_INFO },		/* Display information */
> +	{ 0x04, KEY_VOLUMEUP },
> +	{ 0x08, KEY_VOLUMEDOWN },
> +	{ 0x0c, KEY_CHANNELUP },
> +	{ 0x10, KEY_CHANNELDOWN },
> +	{ 0x03, KEY_ZOOM },		/* fullscreen */
> +	{ 0x1f, KEY_TEXT },		/* closed caption/teletext */
> +	{ 0x20, KEY_SLEEP },
> +	{ 0x29, KEY_CLEAR },		/* boss key */
> +	{ 0x14, KEY_MUTE },
> +	{ 0x2b, KEY_RED },
> +	{ 0x2c, KEY_GREEN },
> +	{ 0x2d, KEY_YELLOW },
> +	{ 0x2e, KEY_BLUE },
> +	{ 0x18, KEY_KPPLUS },		/* fine tune + , not on Y040052 */
> +	{ 0x19, KEY_KPMINUS },		/* fine tune - , not on Y040052 */
> +	{ 0x2a, KEY_MEDIA },		/* PIP (Picture in picture */
> +	{ 0x21, KEY_DOT },
> +	{ 0x13, KEY_ENTER },
> +	{ 0x11, KEY_LAST },		/* Recall (last channel */
> +	{ 0x22, KEY_PREVIOUS },
> +	{ 0x23, KEY_PLAYPAUSE },
> +	{ 0x24, KEY_NEXT },
> +	{ 0x25, KEY_TIME },		/* Time Shifting */
> +	{ 0x26, KEY_STOP },
> +	{ 0x27, KEY_RECORD },
> +	{ 0x28, KEY_SAVE },		/* Screenshot */
> +	{ 0x2f, KEY_MENU },
> +	{ 0x30, KEY_CANCEL },
> +	{ 0x31, KEY_CHANNEL },		/* Channel Surf */
> +	{ 0x32, KEY_SUBTITLE },
> +	{ 0x33, KEY_LANGUAGE },
> +	{ 0x34, KEY_REWIND },
> +	{ 0x35, KEY_FASTFORWARD },
> +	{ 0x36, KEY_TV },
> +	{ 0x37, KEY_RADIO },		/* FM */
> +	{ 0x38, KEY_DVD },
> +
> +	{ 0x1a, KEY_MODE},		/* change to MCE mode on Y04G0051 */
> +	{ 0x3e, KEY_F21 },		/* MCE +VOL, on Y04G0033 */
> +	{ 0x3a, KEY_F22 },		/* MCE -VOL, on Y04G0033 */
> +	{ 0x3b, KEY_F23 },		/* MCE +CH,  on Y04G0033 */
> +	{ 0x3f, KEY_F24 }		/* MCE -CH,  on Y04G0033 */
> +};
> +
> +static struct rc_keymap winfast_map = {
> +	.map = {
> +		.scan    = winfast,
> +		.size    = ARRAY_SIZE(winfast),
> +		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
> +		.name    = RC_MAP_WINFAST,
> +	}
> +};
> +
> +static int __init init_rc_map_winfast(void)
> +{
> +	return ir_register_map(&winfast_map);
> +}
> +
> +static void __exit exit_rc_map_winfast(void)
> +{
> +	ir_unregister_map(&winfast_map);
> +}
> +
> +module_init(init_rc_map_winfast)
> +module_exit(exit_rc_map_winfast)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
> diff --git a/drivers/media/IR/rc-map.c b/drivers/media/IR/rc-map.c
> index aa269f5..02c72f0 100644
> --- a/drivers/media/IR/rc-map.c
> +++ b/drivers/media/IR/rc-map.c
> @@ -64,7 +64,7 @@ int ir_register_map(struct rc_keymap *map)
>  	spin_unlock(&rc_map_lock);
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(ir_raw_handler_register);
> +EXPORT_SYMBOL_GPL(ir_register_map);
>  
>  void ir_unregister_map(struct rc_keymap *map)
>  {
> @@ -72,4 +72,4 @@ void ir_unregister_map(struct rc_keymap *map)
>  	list_del(&map->list);
>  	spin_unlock(&rc_map_lock);
>  }
> -EXPORT_SYMBOL_GPL(ir_raw_handler_unregister);
> +EXPORT_SYMBOL_GPL(ir_unregister_map);

