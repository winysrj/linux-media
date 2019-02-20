Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D91C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 09:57:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 380652086C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 09:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfBTJ5l (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 04:57:41 -0500
Received: from gofer.mess.org ([88.97.38.141]:60925 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbfBTJ5l (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 04:57:41 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 10A226020B; Wed, 20 Feb 2019 09:57:39 +0000 (GMT)
Date:   Wed, 20 Feb 2019 09:57:38 +0000
From:   Sean Young <sean@mess.org>
To:     Jonas Karlman <jonas@kwiboo.se>
Cc:     "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] [media] rc/keymaps: add keytable for Pine64 IR
 Remote Controller
Message-ID: <20190220095738.ftshqrhccoa3hvyy@gofer.mess.org>
References: <20190218215915.2782-1-jonas@kwiboo.se>
 <AM3PR03MB09661A45FEB90FFC3CB44508AC630@AM3PR03MB0966.eurprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM3PR03MB09661A45FEB90FFC3CB44508AC630@AM3PR03MB0966.eurprd03.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 18, 2019 at 09:59:36PM +0000, Jonas Karlman wrote:
> This RC map is based on remote key schema at [1], the mouse button key
> did not have an obvious target and was mapped to KEY_CONTEXT_MENU.

How about BTN_LEFT ?

Thanks,

Sean

> 
> [1] http://files.pine64.org/doc/Pine%20A64%20Schematic/remote-wit-logo.jpg
> 
> Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
> ---
>  drivers/media/rc/keymaps/Makefile    |  1 +
>  drivers/media/rc/keymaps/rc-pine64.c | 59 ++++++++++++++++++++++++++++
>  include/media/rc-map.h               |  1 +
>  3 files changed, 61 insertions(+)
>  create mode 100644 drivers/media/rc/keymaps/rc-pine64.c
> 
> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> index 5b1399af6b3a..0ea52f65bb03 100644
> --- a/drivers/media/rc/keymaps/Makefile
> +++ b/drivers/media/rc/keymaps/Makefile
> @@ -76,6 +76,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>  			rc-norwood.o \
>  			rc-npgtech.o \
>  			rc-pctv-sedna.o \
> +			rc-pine64.o \
>  			rc-pinnacle-color.o \
>  			rc-pinnacle-grey.o \
>  			rc-pinnacle-pctv-hd.o \
> diff --git a/drivers/media/rc/keymaps/rc-pine64.c b/drivers/media/rc/keymaps/rc-pine64.c
> new file mode 100644
> index 000000000000..94e5624f63f4
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-pine64.c
> @@ -0,0 +1,59 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +// Keytable for Pine64 IR Remote Controller
> +// Copyright (c) 2017 Jonas Karlman
> +
> +#include <media/rc-map.h>
> +#include <linux/module.h>
> +
> +static struct rc_map_table pine64[] = {
> +	{ 0x404000, KEY_NUMERIC_0 },
> +	{ 0x404001, KEY_NUMERIC_1 },
> +	{ 0x404002, KEY_NUMERIC_2 },
> +	{ 0x404003, KEY_NUMERIC_3 },
> +	{ 0x404004, KEY_NUMERIC_4 },
> +	{ 0x404005, KEY_NUMERIC_5 },
> +	{ 0x404006, KEY_NUMERIC_6 },
> +	{ 0x404007, KEY_NUMERIC_7 },
> +	{ 0x404008, KEY_NUMERIC_8 },
> +	{ 0x404009, KEY_NUMERIC_9 },
> +	{ 0x40400a, KEY_MUTE },
> +	{ 0x40400b, KEY_UP },
> +	{ 0x40400c, KEY_BACKSPACE },
> +	{ 0x40400d, KEY_OK },
> +	{ 0x40400e, KEY_DOWN },
> +	{ 0x404010, KEY_LEFT },
> +	{ 0x404011, KEY_RIGHT },
> +	{ 0x404017, KEY_VOLUMEDOWN },
> +	{ 0x404018, KEY_VOLUMEUP },
> +	{ 0x40401a, KEY_HOME },
> +	{ 0x40401d, KEY_MENU },
> +	{ 0x40401f, KEY_WWW },
> +	{ 0x404045, KEY_BACK },
> +	{ 0x404047, KEY_CONTEXT_MENU },
> +	{ 0x40404d, KEY_POWER },
> +};
> +
> +static struct rc_map_list pine64_map = {
> +	.map = {
> +		.scan     = pine64,
> +		.size     = ARRAY_SIZE(pine64),
> +		.rc_proto = RC_PROTO_NECX,
> +		.name     = RC_MAP_PINE64,
> +	}
> +};
> +
> +static int __init init_rc_map_pine64(void)
> +{
> +	return rc_map_register(&pine64_map);
> +}
> +
> +static void __exit exit_rc_map_pine64(void)
> +{
> +	rc_map_unregister(&pine64_map);
> +}
> +
> +module_init(init_rc_map_pine64)
> +module_exit(exit_rc_map_pine64)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jonas Karlman");
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index d621acadfbf3..52b554aa784d 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -236,6 +236,7 @@ struct rc_map *rc_map_get(const char *name);
>  #define RC_MAP_NORWOOD                   "rc-norwood"
>  #define RC_MAP_NPGTECH                   "rc-npgtech"
>  #define RC_MAP_PCTV_SEDNA                "rc-pctv-sedna"
> +#define RC_MAP_PINE64                    "rc-pine64"
>  #define RC_MAP_PINNACLE_COLOR            "rc-pinnacle-color"
>  #define RC_MAP_PINNACLE_GREY             "rc-pinnacle-grey"
>  #define RC_MAP_PINNACLE_PCTV_HD          "rc-pinnacle-pctv-hd"
> -- 
> 2.17.1
