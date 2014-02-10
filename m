Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59762 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbaBJF2d (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 00:28:33 -0500
Message-ID: <52F8637F.5070501@iki.fi>
Date: Mon, 10 Feb 2014 07:28:31 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: GEORGE <geoubuntu@gmail.com>, Anca Emanuel <anca.emanuel@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] saa7134: Add support for SnaZio TvPVR PRO
References: <1391961995-3948-1-git-send-email-user@george> <CAJL_dMsQLrYpkOa4T_pfOKqS8tyUx8t36SWhJZxJSwdob9FE_g@mail.gmail.com> <52F812F8.6070702@gmail.com>
In-Reply-To: <52F812F8.6070702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka!

On 10.02.2014 01:44, GEORGE wrote:

> b/drivers/media/rc/keymaps/rc-snazio-tvpvr-pro.c
> new file mode 100644
> index 0000000..44f0c81
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-snazio-tvpvr-pro.c
> @@ -0,0 +1,116 @@
> +/* rc-snazio-tvpvr-pro.h - Keytable for snazio_tvpvr_pro Remote Controller
> + *
> + * keymap imported from ir-keymaps.c
> + *
> + * Copyright (c) 2010 by Mauro Carvalho Chehab
> + * Copyright (c) 2014 by POJAR GEORGE <geoubuntu@gmail.com>
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
> +/*
> +  Keycodes for remote on the SnaZio TvPVR PRO.
> +  POJAR GEORGE <geoubuntu@gmail.com>
> +*/
> +
> +static struct rc_map_table snazio_tvpvr_pro[] = {
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
> +    MINIMIZE          ZOOM
> +
> +          CH+
> +      VOL-                   VOL+
> +          CH-
> +
> +    SNAPSHOT           MTS
> +
> +     <<      FUNC    >>     RESET
> +*/
> +
> +    { 0x01, KEY_1 },        /* 1 */
> +    { 0x0b, KEY_2 },        /* 2 */
> +    { 0x1b, KEY_3 },        /* 3 */
> +    { 0x05, KEY_4 },        /* 4 */
> +    { 0x09, KEY_5 },        /* 5 */
> +    { 0x15, KEY_6 },        /* 6 */
> +    { 0x06, KEY_7 },        /* 7 */
> +    { 0x0a, KEY_8 },        /* 8 */
> +    { 0x12, KEY_9 },        /* 9 */
> +    { 0x02, KEY_0 },        /* 0 */
> +    { 0x10, KEY_KPPLUS },        /* + */
> +    { 0x13, KEY_AGAIN },        /* Recall */
> +
> +    { 0x1e, KEY_POWER },        /* Power */
> +    { 0x07, KEY_VIDEO },        /* Source */
> +    { 0x1c, KEY_SEARCH },        /* Scan */
> +    { 0x18, KEY_MUTE },        /* Mute */
> +
> +    { 0x03, KEY_RADIO },        /* TV/FM */
> +    /* The next four keys are duplicates that appear to send the
> +       same IR code as Ch+, Ch-, >>, and << .  The raw code assigned
> +       to them is the actual code + 0x20 - they will never be
> +       detected as such unless some way is discovered to distinguish
> +       these buttons from those that have the same code. */
> +    { 0x3f, KEY_RIGHT },        /* |> and Ch+ */
> +    { 0x37, KEY_LEFT },        /* <| and Ch- */
> +    { 0x2c, KEY_UP },        /* ^^Up and >> */
> +    { 0x24, KEY_DOWN },        /* vvDn and << */
> +
> +    { 0x00, KEY_RECORD },        /* Record */
> +    { 0x08, KEY_STOP },        /* Stop */
> +    { 0x11, KEY_PLAY },        /* Play */
> +
> +    { 0x0f, KEY_CLOSE },        /* Minimize */
> +    { 0x19, KEY_ZOOM },        /* Zoom */
> +    { 0x1a, KEY_CAMERA },        /* Snapshot */
> +    { 0x0d, KEY_LANGUAGE },        /* MTS */
> +
> +    { 0x14, KEY_VOLUMEDOWN },    /* Vol- */
> +    { 0x16, KEY_VOLUMEUP },        /* Vol+ */
> +    { 0x17, KEY_CHANNELDOWN },    /* Ch- */
> +    { 0x1f, KEY_CHANNELUP },    /* Ch+ */
> +
> +    { 0x04, KEY_REWIND },        /* << */
> +    { 0x0e, KEY_MENU },        /* Function */
> +    { 0x0c, KEY_FASTFORWARD },    /* >> */
> +    { 0x1d, KEY_RESTART },        /* Reset */
> +};
> +
> +static struct rc_map_list snazio_tvpvr_pro_map = {
> +    .map = {
> +        .scan    = snazio_tvpvr_pro,
> +        .size    = ARRAY_SIZE(snazio_tvpvr_pro),
> +        .rc_type = RC_TYPE_UNKNOWN,    /* Legacy IR type */
> +        .name    = RC_MAP_SNAZIO_TVPVR_PRO,
> +    }
> +};
> +
> +static int __init init_rc_map_snazio_tvpvr_pro(void)
> +{
> +    return rc_map_register(&snazio_tvpvr_pro_map);
> +}
> +
> +static void __exit exit_rc_map_snazio_tvpvr_pro(void)
> +{
> +    rc_map_unregister(&snazio_tvpvr_pro_map);
> +}
> +
> +module_init(init_rc_map_snazio_tvpvr_pro)
> +module_exit(exit_rc_map_snazio_tvpvr_pro)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("POJAR GEORGE <geoubuntu@gmail.com>");
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index e5aa240..b802af4 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -177,6 +177,7 @@ void rc_map_init(void);
>   #define RC_MAP_REAL_AUDIO_220_32_KEYS "rc-real-audio-220-32-keys"
>   #define RC_MAP_REDDO                     "rc-reddo"
>   #define RC_MAP_SNAPSTREAM_FIREFLY        "rc-snapstream-firefly"
> +#define RC_MAP_SNAZIO_TVPVR_PRO          "rc-snazio-tvpvr-pro"
>   #define RC_MAP_STREAMZAP                 "rc-streamzap"
>   #define RC_MAP_TBS_NEC                   "rc-tbs-nec"
>   #define RC_MAP_TECHNISAT_USB2            "rc-technisat-usb2"

That remote controller is same than rc-msi-tvanywhere-plus.c. If there 
is still some reason you need to duplicate it (like one keycode mapped 
differently), please add comment to file "this is almost similar than 
that keymap X, but for the reason Y we need to define new table".

rc-pixelview.c seems to be also rather similar.

Do you have some other receiver which returns full scan code? That 
keytable should be converted to some standard rc type (NEC?)

regards
Antti

-- 
http://palosaari.fi/
