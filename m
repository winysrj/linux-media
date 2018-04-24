Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:38595 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755273AbeDXK3Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 06:29:25 -0400
Date: Tue, 24 Apr 2018 11:29:23 +0100
From: Sean Young <sean@mess.org>
To: Vladislav Zhurba <vzhurba@nvidia.com>
Cc: linux-kernel@vger.kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org, Jun Yan <juyan@nvidia.com>,
        marting <marting@nvidia.com>, Daniel Fu <danifu@nvidia.com>
Subject: Re: [PATCH 1/1] media: rc: Add NVIDIA IR keymapping
Message-ID: <20180424102923.2dfwojf6psf2jfed@gofer.mess.org>
References: <20180420184747.29022-1-vzhurba@nvidia.com>
 <20180420184747.29022-2-vzhurba@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180420184747.29022-2-vzhurba@nvidia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 11:47:47AM -0700, Vladislav Zhurba wrote:
> From: Jun Yan <juyan@nvidia.com>
> 
> Add keymap with NEC and SONY12 protocol for NVIDIA IR
> 
> Signed-off-by: Jun Yan <juyan@nvidia.com>
> Signed-off-by: marting <marting@nvidia.com>
> Signed-off-by: Daniel Fu <danifu@nvidia.com>
> Signed-off-by: Vladislav Zhurba <vzhurba@nvidia.com>
> ---
>  drivers/media/rc/keymaps/Makefile        |  2 +
>  drivers/media/rc/keymaps/rc-nvidia-nec.c | 66 ++++++++++++++++++++++++
>  drivers/media/rc/keymaps/rc-nvidia.c     | 66 ++++++++++++++++++++++++
>  include/media/rc-map.h                   |  2 +
>  4 files changed, 136 insertions(+)
>  create mode 100644 drivers/media/rc/keymaps/rc-nvidia-nec.c
>  create mode 100644 drivers/media/rc/keymaps/rc-nvidia.c
> 
> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> index d6b913a3032d..1d08500462fd 100644
> --- a/drivers/media/rc/keymaps/Makefile
> +++ b/drivers/media/rc/keymaps/Makefile
> @@ -75,6 +75,8 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>  			rc-nec-terratec-cinergy-xs.o \
>  			rc-norwood.o \
>  			rc-npgtech.o \
> +			rc-nvidia.o \
> +			rc-nvidia-nec.o \
>  			rc-pctv-sedna.o \
>  			rc-pinnacle-color.o \
>  			rc-pinnacle-grey.o \
> diff --git a/drivers/media/rc/keymaps/rc-nvidia-nec.c b/drivers/media/rc/keymaps/rc-nvidia-nec.c
> new file mode 100644
> index 000000000000..c910a2a683f6
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-nvidia-nec.c
> @@ -0,0 +1,66 @@
> +/* Keytable for NVIDIA Remote Controller
> + *
> + * Copyright (c) 2014-2018, NVIDIA CORPORATION. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + *
> + */

Would it be possible to use the SPDX-License-Identifier please.

> +#include <media/rc-map.h>
> +#include <linux/module.h>
> +
> +static struct rc_map_table foster_table[] = {
> +	{ 0x807e12, KEY_VOLUMEUP },
> +	{ 0x807e15, KEY_VOLUMEDOWN },
> +	{ 0x807e0c, KEY_UP },
> +	{ 0x807e0e, KEY_DOWN },
> +	{ 0x807e0b, KEY_LEFT },
> +	{ 0x807e0d, KEY_RIGHT },
> +	{ 0x807e09, KEY_HOMEPAGE },
> +	{ 0x807e06, KEY_POWER },
> +	{ 0x807e03, KEY_SELECT },
> +	{ 0x807e02, KEY_BACK },
> +	{ 0x807e14, KEY_MUTE },
> +	{ 0x807e20, KEY_PLAYPAUSE },
> +	{ 0x807e11, KEY_PLAYCD },
> +	{ 0x807e08, KEY_PAUSECD },
> +	{ 0x807e07, KEY_STOP },
> +	{ 0x807e0f, KEY_FASTFORWARD },
> +	{ 0x807e0a, KEY_REWIND },
> +	{ 0x807e41, KEY_SLEEP },
> +	{ 0x807e45, KEY_WAKEUP },
> +};
> +
> +static struct rc_map_list nvidia_map = {
> +	.map = {
> +			.scan = foster_table,
> +			.size = ARRAY_SIZE(foster_table),
> +			.rc_type = RC_TYPE_NEC,

This does not compile against mainline any more. Should be RC_PROTO_NEC.

> +			.name = RC_MAP_NVIDIA_NEC,

Would it be possible to give it a more descriptive name, not just
nvidia but also the product name.

> +	}
> +};
> +
> +static int __init init_rc_map_nvidia(void)
> +{
> +	return rc_map_register(&nvidia_map);
> +}
> +
> +static void __exit exit_rc_map_nvidia(void)
> +{
> +	rc_map_unregister(&nvidia_map);
> +}
> +
> +module_init(init_rc_map_nvidia);
> +module_exit(exit_rc_map_nvidia);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Daniel Fu <danifu@nvidia.com>");
> diff --git a/drivers/media/rc/keymaps/rc-nvidia.c b/drivers/media/rc/keymaps/rc-nvidia.c
> new file mode 100644
> index 000000000000..9767d85a6c9e
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-nvidia.c

Same comments for this file.

> @@ -0,0 +1,66 @@
> +/* Keytable for NVIDIA Remote Controller
> + *
> + * Copyright (c) 2014-2018, NVIDIA CORPORATION. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + *
> + */
> +#include <media/rc-map.h>
> +#include <linux/module.h>
> +
> +static struct rc_map_table foster_table[] = {
> +	{ 0x10009, KEY_0 },
> +	{ 0x10000, KEY_1 },
> +	{ 0x10001, KEY_2 },
> +	{ 0x10002, KEY_3 },
> +	{ 0x10003, KEY_4 },
> +	{ 0x10004, KEY_5 },
> +	{ 0x10005, KEY_6 },
> +	{ 0x10006, KEY_7 },
> +	{ 0x10007, KEY_8 },
> +	{ 0x10008, KEY_9 },
> +	{ 0x10012, KEY_VOLUMEUP },
> +	{ 0x10013, KEY_VOLUMEDOWN },
> +	{ 0x10010, KEY_CHANNELUP },
> +	{ 0x10011, KEY_CHANNELDOWN },
> +	{ 0x10074, KEY_UP },
> +	{ 0x10075, KEY_DOWN },
> +	{ 0x10034, KEY_LEFT },
> +	{ 0x10033, KEY_RIGHT },
> +	{ 0x10060, KEY_HOME },
> +};
> +
> +static struct rc_map_list nvidia_map = {
> +	.map = {
> +			.scan = foster_table,
> +			.size = ARRAY_SIZE(foster_table),
> +			.rc_type = RC_TYPE_SONY12,
> +			.name = RC_MAP_NVIDIA,
> +	}
> +};
> +
> +static int __init init_rc_map_nvidia(void)
> +{
> +	return rc_map_register(&nvidia_map);
> +}
> +
> +static void __exit exit_rc_map_nvidia(void)
> +{
> +	rc_map_unregister(&nvidia_map);
> +}
> +
> +module_init(init_rc_map_nvidia);
> +module_exit(exit_rc_map_nvidia);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Jun Yan <juyan@nvidia.com>");
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index bfa3017cecba..673d16eaabdf 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -235,6 +235,8 @@ struct rc_map *rc_map_get(const char *name);
>  #define RC_MAP_NEC_TERRATEC_CINERGY_XS   "rc-nec-terratec-cinergy-xs"
>  #define RC_MAP_NORWOOD                   "rc-norwood"
>  #define RC_MAP_NPGTECH                   "rc-npgtech"
> +#define RC_MAP_NVIDIA                    "rc-nvidia"
> +#define RC_MAP_NVIDIA_NEC                "rc-nvidia-nec"
>  #define RC_MAP_PCTV_SEDNA                "rc-pctv-sedna"
>  #define RC_MAP_PINNACLE_COLOR            "rc-pinnacle-color"
>  #define RC_MAP_PINNACLE_GREY             "rc-pinnacle-grey"
> -- 
> 2.17.0
