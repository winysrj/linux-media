Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37577 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdKSWHJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Nov 2017 17:07:09 -0500
Date: Sun, 19 Nov 2017 22:07:06 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/6] media: rc keymaps: add SPDX identifiers to the code
 I wrote
Message-ID: <20171119220706.qekc2schk5klzber@gofer.mess.org>
References: <e0917bf82693b0a7383310f9d8fb3aea10ef6615.1510913595.git.mchehab@s-opensource.com>
 <9c89e9a9dd48cdf491a5b074b4167c64371695bd.1510913595.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c89e9a9dd48cdf491a5b074b4167c64371695bd.1510913595.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 08:21:29AM -0200, Mauro Carvalho Chehab wrote:
> As we're now using SPDX identifiers, on the several
> RC keymap files I wrote, add the proper SPDX, identifying
> the license I meant.
> 
> As we're now using the short license, it doesn't make sense to
> keep the original license text.
> 
> Also, fix MODULE_LICENSE to identify GPL v2, as this is the
> minimal license requirement for those modles.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c       | 8 ++------
>  drivers/media/rc/keymaps/rc-apac-viewcomp.c           | 8 ++------
>  drivers/media/rc/keymaps/rc-asus-pc39.c               | 8 ++------
>  drivers/media/rc/keymaps/rc-asus-ps3-100.c            | 8 ++------
>  drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c    | 8 ++------
>  drivers/media/rc/keymaps/rc-avermedia-a16d.c          | 8 ++------
>  drivers/media/rc/keymaps/rc-avermedia-cardbus.c       | 8 ++------
>  drivers/media/rc/keymaps/rc-avermedia-dvbt.c          | 8 ++------
>  drivers/media/rc/keymaps/rc-avermedia-m135a.c         | 8 ++------
>  drivers/media/rc/keymaps/rc-avermedia.c               | 8 ++------
>  drivers/media/rc/keymaps/rc-avertv-303.c              | 8 ++------
>  drivers/media/rc/keymaps/rc-behold-columbus.c         | 8 ++------
>  drivers/media/rc/keymaps/rc-behold.c                  | 8 ++------
>  drivers/media/rc/keymaps/rc-budget-ci-old.c           | 8 ++------
>  drivers/media/rc/keymaps/rc-cinergy-1400.c            | 8 ++------
>  drivers/media/rc/keymaps/rc-cinergy.c                 | 8 ++------
>  drivers/media/rc/keymaps/rc-dib0700-nec.c             | 8 ++------
>  drivers/media/rc/keymaps/rc-dib0700-rc5.c             | 8 ++------
>  drivers/media/rc/keymaps/rc-dm1105-nec.c              | 8 ++------
>  drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c         | 8 ++------
>  drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c      | 8 ++------
>  drivers/media/rc/keymaps/rc-em-terratec.c             | 8 ++------
>  drivers/media/rc/keymaps/rc-encore-enltv-fm53.c       | 8 ++------
>  drivers/media/rc/keymaps/rc-encore-enltv.c            | 8 ++------
>  drivers/media/rc/keymaps/rc-encore-enltv2.c           | 8 ++------
>  drivers/media/rc/keymaps/rc-evga-indtube.c            | 8 ++------
>  drivers/media/rc/keymaps/rc-eztv.c                    | 8 ++------
>  drivers/media/rc/keymaps/rc-flydvb.c                  | 8 ++------
>  drivers/media/rc/keymaps/rc-flyvideo.c                | 8 ++------
>  drivers/media/rc/keymaps/rc-fusionhdtv-mce.c          | 8 ++------
>  drivers/media/rc/keymaps/rc-gadmei-rm008z.c           | 8 ++------
>  drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c      | 8 ++------
>  drivers/media/rc/keymaps/rc-gotview7135.c             | 8 ++------
>  drivers/media/rc/keymaps/rc-hauppauge.c               | 8 ++------
>  drivers/media/rc/keymaps/rc-iodata-bctv7e.c           | 8 ++------
>  drivers/media/rc/keymaps/rc-kaiomy.c                  | 8 ++------
>  drivers/media/rc/keymaps/rc-kworld-315u.c             | 8 ++------
>  drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c   | 8 ++------
>  drivers/media/rc/keymaps/rc-manli.c                   | 8 ++------
>  drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c     | 8 ++------
>  drivers/media/rc/keymaps/rc-msi-tvanywhere.c          | 8 ++------
>  drivers/media/rc/keymaps/rc-nebula.c                  | 8 ++------
>  drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c | 8 ++------
>  drivers/media/rc/keymaps/rc-norwood.c                 | 8 ++------
>  drivers/media/rc/keymaps/rc-npgtech.c                 | 8 ++------
>  drivers/media/rc/keymaps/rc-pctv-sedna.c              | 8 ++------
>  drivers/media/rc/keymaps/rc-pinnacle-color.c          | 8 ++------
>  drivers/media/rc/keymaps/rc-pinnacle-grey.c           | 8 ++------
>  drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c        | 8 ++------
>  drivers/media/rc/keymaps/rc-pixelview-002t.c          | 8 ++------
>  drivers/media/rc/keymaps/rc-pixelview-mk12.c          | 8 ++------
>  drivers/media/rc/keymaps/rc-pixelview-new.c           | 8 ++------
>  drivers/media/rc/keymaps/rc-pixelview.c               | 8 ++------
>  drivers/media/rc/keymaps/rc-powercolor-real-angel.c   | 8 ++------
>  drivers/media/rc/keymaps/rc-proteus-2309.c            | 8 ++------
>  drivers/media/rc/keymaps/rc-purpletv.c                | 8 ++------
>  drivers/media/rc/keymaps/rc-pv951.c                   | 8 ++------
>  drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c  | 8 ++------
>  drivers/media/rc/keymaps/rc-tbs-nec.c                 | 8 ++------
>  drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c     | 8 ++------
>  drivers/media/rc/keymaps/rc-tevii-nec.c               | 8 ++------
>  drivers/media/rc/keymaps/rc-tt-1500.c                 | 8 ++------
>  drivers/media/rc/keymaps/rc-videomate-s350.c          | 8 ++------
>  drivers/media/rc/keymaps/rc-videomate-tv-pvr.c        | 8 ++------
>  drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c    | 8 ++------
>  drivers/media/rc/keymaps/rc-winfast.c                 | 8 ++------
>  66 files changed, 132 insertions(+), 396 deletions(-)
> 
> diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
> index 2d303c2cee3b..65cd7f304ce7 100644
> --- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
> +++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+

This says GPLv2 or higher.

>  /* adstech-dvb-t-pci.h - Keytable for adstech_dvb_t_pci Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.

This says GPLv2 or higher.

>   */
>  
>  #include <media/rc-map.h>
> @@ -86,5 +82,5 @@ static void __exit exit_rc_map_adstech_dvb_t_pci(void)
>  module_init(init_rc_map_adstech_dvb_t_pci)
>  module_exit(exit_rc_map_adstech_dvb_t_pci)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");

Now this says GPLv2 only.

Am I confused?


Sean

>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
> index 65bc8957d9c3..6fcd9ef037e1 100644
> --- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
> +++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* apac-viewcomp.h - Keytable for apac_viewcomp Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -77,5 +73,5 @@ static void __exit exit_rc_map_apac_viewcomp(void)
>  module_init(init_rc_map_apac_viewcomp)
>  module_exit(exit_rc_map_apac_viewcomp)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
> index 530e1d1158d1..1776f5204620 100644
> --- a/drivers/media/rc/keymaps/rc-asus-pc39.c
> +++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* asus-pc39.h - Keytable for asus_pc39 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -88,5 +84,5 @@ static void __exit exit_rc_map_asus_pc39(void)
>  module_init(init_rc_map_asus_pc39)
>  module_exit(exit_rc_map_asus_pc39)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-asus-ps3-100.c b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
> index c91ba332984c..02a9fa1e9690 100644
> --- a/drivers/media/rc/keymaps/rc-asus-ps3-100.c
> +++ b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* asus-ps3-100.h - Keytable for asus_ps3_100 Remote Controller
>   *
>   * Copyright (c) 2012 by Mauro Carvalho Chehab
>   *
>   * Based on a previous patch from Remi Schwartz <remi.schwartz@gmail.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -87,5 +83,5 @@ rc_map_unregister(&asus_ps3_100_map);
>  module_init(init_rc_map_asus_ps3_100)
>  module_exit(exit_rc_map_asus_ps3_100)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
> index 11b4bdd2392b..538ab91fab5b 100644
> --- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
> +++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* ati-tv-wonder-hd-600.h - Keytable for ati_tv_wonder_hd_600 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -66,5 +62,5 @@ static void __exit exit_rc_map_ati_tv_wonder_hd_600(void)
>  module_init(init_rc_map_ati_tv_wonder_hd_600)
>  module_exit(exit_rc_map_ati_tv_wonder_hd_600)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
> index 510dc90ebf49..981a147df833 100644
> --- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
> +++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* avermedia-a16d.h - Keytable for avermedia_a16d Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -72,5 +68,5 @@ static void __exit exit_rc_map_avermedia_a16d(void)
>  module_init(init_rc_map_avermedia_a16d)
>  module_exit(exit_rc_map_avermedia_a16d)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
> index 4bbc1e68d1b8..0b5f453e6f05 100644
> --- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
> +++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* avermedia-cardbus.h - Keytable for avermedia_cardbus Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -94,5 +90,5 @@ static void __exit exit_rc_map_avermedia_cardbus(void)
>  module_init(init_rc_map_avermedia_cardbus)
>  module_exit(exit_rc_map_avermedia_cardbus)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
> index f6b8547dbad3..e3f5ec3ed965 100644
> --- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
> +++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* avermedia-dvbt.h - Keytable for avermedia_dvbt Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -75,5 +71,5 @@ static void __exit exit_rc_map_avermedia_dvbt(void)
>  module_init(init_rc_map_avermedia_dvbt)
>  module_exit(exit_rc_map_avermedia_dvbt)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
> index 9882e2cde975..0eb0963c000b 100644
> --- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
> +++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
> @@ -1,12 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* avermedia-m135a.c - Keytable for Avermedia M135A Remote Controllers
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
>   * Copyright (c) 2010 by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -144,5 +140,5 @@ static void __exit exit_rc_map_avermedia_m135a(void)
>  module_init(init_rc_map_avermedia_m135a)
>  module_exit(exit_rc_map_avermedia_m135a)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
> index 6503f11c7df5..787e790b3385 100644
> --- a/drivers/media/rc/keymaps/rc-avermedia.c
> +++ b/drivers/media/rc/keymaps/rc-avermedia.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* avermedia.h - Keytable for avermedia Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -83,5 +79,5 @@ static void __exit exit_rc_map_avermedia(void)
>  module_init(init_rc_map_avermedia)
>  module_exit(exit_rc_map_avermedia)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
> index fbdd7ada57ce..49c8bb65dd75 100644
> --- a/drivers/media/rc/keymaps/rc-avertv-303.c
> +++ b/drivers/media/rc/keymaps/rc-avertv-303.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* avertv-303.h - Keytable for avertv_303 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -82,5 +78,5 @@ static void __exit exit_rc_map_avertv_303(void)
>  module_init(init_rc_map_avertv_303)
>  module_exit(exit_rc_map_avertv_303)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
> index d256743be998..3bafeb6eff75 100644
> --- a/drivers/media/rc/keymaps/rc-behold-columbus.c
> +++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* behold-columbus.h - Keytable for behold_columbus Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -105,5 +101,5 @@ static void __exit exit_rc_map_behold_columbus(void)
>  module_init(init_rc_map_behold_columbus)
>  module_exit(exit_rc_map_behold_columbus)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
> index 93dc795adc67..6fdf39cd48cf 100644
> --- a/drivers/media/rc/keymaps/rc-behold.c
> +++ b/drivers/media/rc/keymaps/rc-behold.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* behold.h - Keytable for behold Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -138,5 +134,5 @@ static void __exit exit_rc_map_behold(void)
>  module_init(init_rc_map_behold)
>  module_exit(exit_rc_map_behold)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
> index 81ea1424d9e5..d5fec4e5d148 100644
> --- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
> +++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* budget-ci-old.h - Keytable for budget_ci_old Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -90,5 +86,5 @@ static void __exit exit_rc_map_budget_ci_old(void)
>  module_init(init_rc_map_budget_ci_old)
>  module_exit(exit_rc_map_budget_ci_old)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
> index bcb96b3dda85..9631c8948597 100644
> --- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
> +++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* cinergy-1400.h - Keytable for cinergy_1400 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -81,5 +77,5 @@ static void __exit exit_rc_map_cinergy_1400(void)
>  module_init(init_rc_map_cinergy_1400)
>  module_exit(exit_rc_map_cinergy_1400)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
> index fd56c402aae5..5a6d5f2349d7 100644
> --- a/drivers/media/rc/keymaps/rc-cinergy.c
> +++ b/drivers/media/rc/keymaps/rc-cinergy.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* cinergy.h - Keytable for cinergy Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -75,5 +71,5 @@ static void __exit exit_rc_map_cinergy(void)
>  module_init(init_rc_map_cinergy)
>  module_exit(exit_rc_map_cinergy)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
> index 1b4df106b7b5..576e425cc1c8 100644
> --- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
> +++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* rc-dvb0700-big.c - Keytable for devices in dvb0700
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> @@ -8,11 +9,6 @@
>   * be identificated.
>   *
>   * The table were imported from dib0700_devices.c.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -121,5 +117,5 @@ static void __exit exit_rc_map(void)
>  module_init(init_rc_map)
>  module_exit(exit_rc_map)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
> index b0f8151bb824..ef5f74aeb089 100644
> --- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
> +++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* rc-dvb0700-big.c - Keytable for devices in dvb0700
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> @@ -8,11 +9,6 @@
>   * be identificated.
>   *
>   * The table were imported from dib0700_devices.c.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -232,5 +228,5 @@ static void __exit exit_rc_map(void)
>  module_init(init_rc_map)
>  module_exit(exit_rc_map)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
> index c353445d10ed..cbdbbdd7bac1 100644
> --- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
> +++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* dm1105-nec.h - Keytable for dm1105_nec Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -73,5 +69,5 @@ static void __exit exit_rc_map_dm1105_nec(void)
>  module_init(init_rc_map_dm1105_nec)
>  module_exit(exit_rc_map_dm1105_nec)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
> index 5bafd5b70f5e..342786bb6dce 100644
> --- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
> +++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* dntv-live-dvb-t.h - Keytable for dntv_live_dvb_t Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -75,5 +71,5 @@ static void __exit exit_rc_map_dntv_live_dvb_t(void)
>  module_init(init_rc_map_dntv_live_dvb_t)
>  module_exit(exit_rc_map_dntv_live_dvb_t)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
> index 360167c8829b..03780abeffca 100644
> --- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
> +++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* dntv-live-dvbt-pro.h - Keytable for dntv_live_dvbt_pro Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -94,5 +90,5 @@ static void __exit exit_rc_map_dntv_live_dvbt_pro(void)
>  module_init(init_rc_map_dntv_live_dvbt_pro)
>  module_exit(exit_rc_map_dntv_live_dvbt_pro)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
> index 18e1a2679c20..4403b21377b3 100644
> --- a/drivers/media/rc/keymaps/rc-em-terratec.c
> +++ b/drivers/media/rc/keymaps/rc-em-terratec.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* em-terratec.h - Keytable for em_terratec Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -66,5 +62,5 @@ static void __exit exit_rc_map_em_terratec(void)
>  module_init(init_rc_map_em_terratec)
>  module_exit(exit_rc_map_em_terratec)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
> index 72ffd5cb0108..4301b30fa570 100644
> --- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
> +++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* encore-enltv-fm53.h - Keytable for encore_enltv_fm53 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -78,5 +74,5 @@ static void __exit exit_rc_map_encore_enltv_fm53(void)
>  module_init(init_rc_map_encore_enltv_fm53)
>  module_exit(exit_rc_map_encore_enltv_fm53)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
> index e0381e7aa964..a88f2874f6cf 100644
> --- a/drivers/media/rc/keymaps/rc-encore-enltv.c
> +++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* encore-enltv.h - Keytable for encore_enltv Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -109,5 +105,5 @@ static void __exit exit_rc_map_encore_enltv(void)
>  module_init(init_rc_map_encore_enltv)
>  module_exit(exit_rc_map_encore_enltv)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
> index e9b0bfba319c..0215f34c0d4a 100644
> --- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
> +++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* encore-enltv2.h - Keytable for encore_enltv2 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -87,5 +83,5 @@ static void __exit exit_rc_map_encore_enltv2(void)
>  module_init(init_rc_map_encore_enltv2)
>  module_exit(exit_rc_map_encore_enltv2)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
> index b77c5e908668..84b138c6f9e3 100644
> --- a/drivers/media/rc/keymaps/rc-evga-indtube.c
> +++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* evga-indtube.h - Keytable for evga_indtube Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -58,5 +54,5 @@ static void __exit exit_rc_map_evga_indtube(void)
>  module_init(init_rc_map_evga_indtube)
>  module_exit(exit_rc_map_evga_indtube)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
> index 5013b3b2aa93..658931af2ee9 100644
> --- a/drivers/media/rc/keymaps/rc-eztv.c
> +++ b/drivers/media/rc/keymaps/rc-eztv.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* eztv.h - Keytable for eztv Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -93,5 +89,5 @@ static void __exit exit_rc_map_eztv(void)
>  module_init(init_rc_map_eztv)
>  module_exit(exit_rc_map_eztv)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
> index 418b32521273..80983ad9fb1c 100644
> --- a/drivers/media/rc/keymaps/rc-flydvb.c
> +++ b/drivers/media/rc/keymaps/rc-flydvb.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* flydvb.h - Keytable for flydvb Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -74,5 +70,5 @@ static void __exit exit_rc_map_flydvb(void)
>  module_init(init_rc_map_flydvb)
>  module_exit(exit_rc_map_flydvb)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
> index 93fb87ecf061..f1fe4a57af5b 100644
> --- a/drivers/media/rc/keymaps/rc-flyvideo.c
> +++ b/drivers/media/rc/keymaps/rc-flyvideo.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* flyvideo.h - Keytable for flyvideo Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -67,5 +63,5 @@ static void __exit exit_rc_map_flyvideo(void)
>  module_init(init_rc_map_flyvideo)
>  module_exit(exit_rc_map_flyvideo)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
> index 9ed3f749262b..aa9df1938398 100644
> --- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
> +++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* fusionhdtv-mce.h - Keytable for fusionhdtv_mce Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -95,5 +91,5 @@ static void __exit exit_rc_map_fusionhdtv_mce(void)
>  module_init(init_rc_map_fusionhdtv_mce)
>  module_exit(exit_rc_map_fusionhdtv_mce)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
> index 3443b721d092..080bb8179a35 100644
> --- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
> +++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* gadmei-rm008z.h - Keytable for gadmei_rm008z Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -78,5 +74,5 @@ static void __exit exit_rc_map_gadmei_rm008z(void)
>  module_init(init_rc_map_gadmei_rm008z)
>  module_exit(exit_rc_map_gadmei_rm008z)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
> index d140e8d45bcc..7a48b0ac4081 100644
> --- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
> +++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* genius-tvgo-a11mce.h - Keytable for genius_tvgo_a11mce Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -81,5 +77,5 @@ static void __exit exit_rc_map_genius_tvgo_a11mce(void)
>  module_init(init_rc_map_genius_tvgo_a11mce)
>  module_exit(exit_rc_map_genius_tvgo_a11mce)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
> index 51230fbb52ba..e18842d7a4d5 100644
> --- a/drivers/media/rc/keymaps/rc-gotview7135.c
> +++ b/drivers/media/rc/keymaps/rc-gotview7135.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* gotview7135.h - Keytable for gotview7135 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -76,5 +72,5 @@ static void __exit exit_rc_map_gotview7135(void)
>  module_init(init_rc_map_gotview7135)
>  module_exit(exit_rc_map_gotview7135)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
> index 890164b68d64..e535f7dc6c47 100644
> --- a/drivers/media/rc/keymaps/rc-hauppauge.c
> +++ b/drivers/media/rc/keymaps/rc-hauppauge.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* rc-hauppauge.c - Keytable for Hauppauge Remote Controllers
>   *
>   * keymap imported from ir-keymaps.c
> @@ -9,11 +10,6 @@
>   *	- DSR-0112 remote bundled with Haupauge MiniStick.
>   *
>   * Copyright (c) 2010-2011 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -289,5 +285,5 @@ static void __exit exit_rc_map_rc5_hauppauge_new(void)
>  module_init(init_rc_map_rc5_hauppauge_new)
>  module_exit(exit_rc_map_rc5_hauppauge_new)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
> index 8cf87a15c4f2..c29cd7413201 100644
> --- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
> +++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* iodata-bctv7e.h - Keytable for iodata_bctv7e Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -85,5 +81,5 @@ static void __exit exit_rc_map_iodata_bctv7e(void)
>  module_init(init_rc_map_iodata_bctv7e)
>  module_exit(exit_rc_map_iodata_bctv7e)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
> index e791f1e1b43b..4cdd56ef77fa 100644
> --- a/drivers/media/rc/keymaps/rc-kaiomy.c
> +++ b/drivers/media/rc/keymaps/rc-kaiomy.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* kaiomy.h - Keytable for kaiomy Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -84,5 +80,5 @@ static void __exit exit_rc_map_kaiomy(void)
>  module_init(init_rc_map_kaiomy)
>  module_exit(exit_rc_map_kaiomy)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
> index 71dce0138f0e..f45b45c3c435 100644
> --- a/drivers/media/rc/keymaps/rc-kworld-315u.c
> +++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* kworld-315u.h - Keytable for kworld_315u Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -80,5 +76,5 @@ static void __exit exit_rc_map_kworld_315u(void)
>  module_init(init_rc_map_kworld_315u)
>  module_exit(exit_rc_map_kworld_315u)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
> index e0322ed16c94..489826ac6aee 100644
> --- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
> +++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* kworld-plus-tv-analog.h - Keytable for kworld_plus_tv_analog Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -96,5 +92,5 @@ static void __exit exit_rc_map_kworld_plus_tv_analog(void)
>  module_init(init_rc_map_kworld_plus_tv_analog)
>  module_exit(exit_rc_map_kworld_plus_tv_analog)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
> index da566902a4dd..a9138cc4576b 100644
> --- a/drivers/media/rc/keymaps/rc-manli.c
> +++ b/drivers/media/rc/keymaps/rc-manli.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* manli.h - Keytable for manli Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -131,5 +127,5 @@ static void __exit exit_rc_map_manli(void)
>  module_init(init_rc_map_manli)
>  module_exit(exit_rc_map_manli)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
> index dfa0ed1d7667..afcdeec5ab9c 100644
> --- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
> +++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* msi-tvanywhere-plus.h - Keytable for msi_tvanywhere_plus Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -120,5 +116,5 @@ static void __exit exit_rc_map_msi_tvanywhere_plus(void)
>  module_init(init_rc_map_msi_tvanywhere_plus)
>  module_exit(exit_rc_map_msi_tvanywhere_plus)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
> index 2111816a3f59..2f983aef70db 100644
> --- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
> +++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* msi-tvanywhere.h - Keytable for msi_tvanywhere Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -66,5 +62,5 @@ static void __exit exit_rc_map_msi_tvanywhere(void)
>  module_init(init_rc_map_msi_tvanywhere)
>  module_exit(exit_rc_map_msi_tvanywhere)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
> index 109b6e1a8b1a..a60200986363 100644
> --- a/drivers/media/rc/keymaps/rc-nebula.c
> +++ b/drivers/media/rc/keymaps/rc-nebula.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* nebula.h - Keytable for nebula Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -93,5 +89,5 @@ static void __exit exit_rc_map_nebula(void)
>  module_init(init_rc_map_nebula)
>  module_exit(exit_rc_map_nebula)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
> index bb2d3a2962c0..a26dd21163ec 100644
> --- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
> +++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* nec-terratec-cinergy-xs.h - Keytable for nec_terratec_cinergy_xs Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -154,5 +150,5 @@ static void __exit exit_rc_map_nec_terratec_cinergy_xs(void)
>  module_init(init_rc_map_nec_terratec_cinergy_xs)
>  module_exit(exit_rc_map_nec_terratec_cinergy_xs)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
> index cd25df336749..934ba1e6ee31 100644
> --- a/drivers/media/rc/keymaps/rc-norwood.c
> +++ b/drivers/media/rc/keymaps/rc-norwood.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* norwood.h - Keytable for norwood Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -82,5 +78,5 @@ static void __exit exit_rc_map_norwood(void)
>  module_init(init_rc_map_norwood)
>  module_exit(exit_rc_map_norwood)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
> index 140bbc20a764..c19b9d7bb4bf 100644
> --- a/drivers/media/rc/keymaps/rc-npgtech.c
> +++ b/drivers/media/rc/keymaps/rc-npgtech.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* npgtech.h - Keytable for npgtech Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -77,5 +73,5 @@ static void __exit exit_rc_map_npgtech(void)
>  module_init(init_rc_map_npgtech)
>  module_exit(exit_rc_map_npgtech)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
> index 52b4558b7bd0..002a99124a73 100644
> --- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
> +++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* pctv-sedna.h - Keytable for pctv_sedna Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -77,5 +73,5 @@ static void __exit exit_rc_map_pctv_sedna(void)
>  module_init(init_rc_map_pctv_sedna)
>  module_exit(exit_rc_map_pctv_sedna)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
> index 973c9c34e304..4f3fd13804c1 100644
> --- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
> +++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* pinnacle-color.h - Keytable for pinnacle_color Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -91,5 +87,5 @@ static void __exit exit_rc_map_pinnacle_color(void)
>  module_init(init_rc_map_pinnacle_color)
>  module_exit(exit_rc_map_pinnacle_color)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
> index 22e44b0d2a93..ae4a329cf3c2 100644
> --- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
> +++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* pinnacle-grey.h - Keytable for pinnacle_grey Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -86,5 +82,5 @@ static void __exit exit_rc_map_pinnacle_grey(void)
>  module_init(init_rc_map_pinnacle_grey)
>  module_exit(exit_rc_map_pinnacle_grey)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
> index 186dcf8e0491..788af140e0b5 100644
> --- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
> +++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* pinnacle-pctv-hd.h - Keytable for pinnacle_pctv_hd Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -67,5 +63,5 @@ static void __exit exit_rc_map_pinnacle_pctv_hd(void)
>  module_init(init_rc_map_pinnacle_pctv_hd)
>  module_exit(exit_rc_map_pinnacle_pctv_hd)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
> index b235ada2e28f..ad49d82a657d 100644
> --- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
> +++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* rc-pixelview-mk12.h - Keytable for pixelview Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -74,5 +70,5 @@ static void __exit exit_rc_map_pixelview(void)
>  module_init(init_rc_map_pixelview)
>  module_exit(exit_rc_map_pixelview)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
> index 453d52d663fe..91ca3681a8c3 100644
> --- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
> +++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* rc-pixelview-mk12.h - Keytable for pixelview Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -80,5 +76,5 @@ static void __exit exit_rc_map_pixelview(void)
>  module_init(init_rc_map_pixelview)
>  module_exit(exit_rc_map_pixelview)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
> index ef97095ec8f1..5900a38ae0c4 100644
> --- a/drivers/media/rc/keymaps/rc-pixelview-new.c
> +++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* pixelview-new.h - Keytable for pixelview_new Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -80,5 +76,5 @@ static void __exit exit_rc_map_pixelview_new(void)
>  module_init(init_rc_map_pixelview_new)
>  module_exit(exit_rc_map_pixelview_new)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
> index cfd8f80d3617..d07220a2493a 100644
> --- a/drivers/media/rc/keymaps/rc-pixelview.c
> +++ b/drivers/media/rc/keymaps/rc-pixelview.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* pixelview.h - Keytable for pixelview Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -79,5 +75,5 @@ static void __exit exit_rc_map_pixelview(void)
>  module_init(init_rc_map_pixelview)
>  module_exit(exit_rc_map_pixelview)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
> index b63f82bcf29a..921ef9bf11bf 100644
> --- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
> +++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* powercolor-real-angel.h - Keytable for powercolor_real_angel Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -78,5 +74,5 @@ static void __exit exit_rc_map_powercolor_real_angel(void)
>  module_init(init_rc_map_powercolor_real_angel)
>  module_exit(exit_rc_map_powercolor_real_angel)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
> index be34c517e4e1..49038e04c6ac 100644
> --- a/drivers/media/rc/keymaps/rc-proteus-2309.c
> +++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* proteus-2309.h - Keytable for proteus_2309 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -66,5 +62,5 @@ static void __exit exit_rc_map_proteus_2309(void)
>  module_init(init_rc_map_proteus_2309)
>  module_exit(exit_rc_map_proteus_2309)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
> index 84c40b97ee00..6ec4d3d2638f 100644
> --- a/drivers/media/rc/keymaps/rc-purpletv.c
> +++ b/drivers/media/rc/keymaps/rc-purpletv.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* purpletv.h - Keytable for purpletv Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -78,5 +74,5 @@ static void __exit exit_rc_map_purpletv(void)
>  module_init(init_rc_map_purpletv)
>  module_exit(exit_rc_map_purpletv)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
> index be190ddebfc4..78b97ab805e5 100644
> --- a/drivers/media/rc/keymaps/rc-pv951.c
> +++ b/drivers/media/rc/keymaps/rc-pv951.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* pv951.h - Keytable for pv951 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -75,5 +71,5 @@ static void __exit exit_rc_map_pv951(void)
>  module_init(init_rc_map_pv951)
>  module_exit(exit_rc_map_pv951)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
> index 957fa21747ea..99070671d7da 100644
> --- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
> +++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* real-audio-220-32-keys.h - Keytable for real_audio_220_32_keys Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -75,5 +71,5 @@ static void __exit exit_rc_map_real_audio_220_32_keys(void)
>  module_init(init_rc_map_real_audio_220_32_keys)
>  module_exit(exit_rc_map_real_audio_220_32_keys)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
> index 05facc043272..39490c5ae8e4 100644
> --- a/drivers/media/rc/keymaps/rc-tbs-nec.c
> +++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* tbs-nec.h - Keytable for tbs_nec Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -72,5 +68,5 @@ static void __exit exit_rc_map_tbs_nec(void)
>  module_init(init_rc_map_tbs_nec)
>  module_exit(exit_rc_map_tbs_nec)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
> index 3d0f6f7e5bea..bccb57bbd2ae 100644
> --- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
> +++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* terratec-cinergy-xs.h - Keytable for terratec_cinergy_xs Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -89,5 +85,5 @@ static void __exit exit_rc_map_terratec_cinergy_xs(void)
>  module_init(init_rc_map_terratec_cinergy_xs)
>  module_exit(exit_rc_map_terratec_cinergy_xs)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
> index 31f8a0fd1f2c..fedbcb231817 100644
> --- a/drivers/media/rc/keymaps/rc-tevii-nec.c
> +++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* tevii-nec.h - Keytable for tevii_nec Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -85,5 +81,5 @@ static void __exit exit_rc_map_tevii_nec(void)
>  module_init(init_rc_map_tevii_nec)
>  module_exit(exit_rc_map_tevii_nec)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
> index 374c230705d2..48f44d5fb7f7 100644
> --- a/drivers/media/rc/keymaps/rc-tt-1500.c
> +++ b/drivers/media/rc/keymaps/rc-tt-1500.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* tt-1500.h - Keytable for tt_1500 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -79,5 +75,5 @@ static void __exit exit_rc_map_tt_1500(void)
>  module_init(init_rc_map_tt_1500)
>  module_exit(exit_rc_map_tt_1500)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
> index b4f103269872..aeccfb501d71 100644
> --- a/drivers/media/rc/keymaps/rc-videomate-s350.c
> +++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* videomate-s350.h - Keytable for videomate_s350 Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -82,5 +78,5 @@ static void __exit exit_rc_map_videomate_s350(void)
>  module_init(init_rc_map_videomate_s350)
>  module_exit(exit_rc_map_videomate_s350)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
> index c431fdf44057..e0c830a164f1 100644
> --- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
> +++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* videomate-tv-pvr.h - Keytable for videomate_tv_pvr Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -84,5 +80,5 @@ static void __exit exit_rc_map_videomate_tv_pvr(void)
>  module_init(init_rc_map_videomate_tv_pvr)
>  module_exit(exit_rc_map_videomate_tv_pvr)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
> index 5a437e61bd5d..d128a1f64de4 100644
> --- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
> +++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* winfast-usbii-deluxe.h - Keytable for winfast_usbii_deluxe Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -79,5 +75,5 @@ static void __exit exit_rc_map_winfast_usbii_deluxe(void)
>  module_init(init_rc_map_winfast_usbii_deluxe)
>  module_exit(exit_rc_map_winfast_usbii_deluxe)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
> index 53685d1f9a47..50e858209d4a 100644
> --- a/drivers/media/rc/keymaps/rc-winfast.c
> +++ b/drivers/media/rc/keymaps/rc-winfast.c
> @@ -1,13 +1,9 @@
> +// SPDX-License-Identifier: GPL-2.0+
>  /* winfast.h - Keytable for winfast Remote Controller
>   *
>   * keymap imported from ir-keymaps.c
>   *
>   * Copyright (c) 2010 by Mauro Carvalho Chehab
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */
>  
>  #include <media/rc-map.h>
> @@ -99,5 +95,5 @@ static void __exit exit_rc_map_winfast(void)
>  module_init(init_rc_map_winfast)
>  module_exit(exit_rc_map_winfast)
>  
> -MODULE_LICENSE("GPL");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Mauro Carvalho Chehab");
> -- 
> 2.14.3
