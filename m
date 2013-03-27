Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35780 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab3C0Auj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 20:50:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH RFC] [media] add Aptina mt9m114 HD digital image sensor driver
Date: Wed, 27 Mar 2013 01:51:26 +0100
Message-ID: <3061473.pZdeCOpV7t@avalon>
In-Reply-To: <1358546444-30265-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1358546444-30265-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

Thank you for the patch.

On Friday 18 January 2013 17:00:44 Scott Jiang wrote:
> This driver support parallel data output mode and
> QVGA/VGA/WVGA/720P resolution. You can select YCbCr and RGB565
> output format.

What host bridge do you use this driver with ?

> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
> ---
>  drivers/media/i2c/Kconfig   |   10 +
>  drivers/media/i2c/Makefile  |    1 +
>  drivers/media/i2c/mt9m114.c | 1055 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1066 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/i2c/mt9m114.c

[snip]


> diff --git a/drivers/media/i2c/mt9m114.c b/drivers/media/i2c/mt9m114.c
> new file mode 100644
> index 0000000..564b711
> --- /dev/null
> +++ b/drivers/media/i2c/mt9m114.c
> @@ -0,0 +1,1055 @@
> +/*
> + * mt9m114.c Aptina MT9M114 sensor driver
> + *
> + * Copyright (c) 2012 Analog Devices Inc.
> + *
> + * refer to: SoC Camera driver by Andrew Chew <achew@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

You can remove the last paragraph, it doesn't bring any legal added value, and 
we don't want to patch every source file in the kernel if the FSF moves :-)

> + */

[snip]

> +struct mt9m114_reg {
> +	u16 reg;
> +	u32 val;
> +	int width;
> +};
> +
> +enum {
> +	MT9M114_QVGA,
> +	MT9M114_VGA,
> +	MT9M114_WVGA,
> +	MT9M114_720P,
> +};

This is the part I don't like. Instead of hardcoding 4 different resolutions 
and using large register address/value tables, you should compute the register 
values from the image size requested by the user.

-- 
Regards,

Laurent Pinchart

