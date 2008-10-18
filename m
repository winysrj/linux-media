Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9INa9Ud004018
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 19:36:09 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9INZHLD021675
	for <video4linux-list@redhat.com>; Sat, 18 Oct 2008 19:35:18 -0400
Date: Sun, 19 Oct 2008 01:35:23 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uzll4930b.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0810180054180.9365@axis700.grange>
References: <uzll4930b.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L <video4linux-list@redhat.com>, mchehab@infradead.org
Subject: Re: [PATCH v3] Add ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hello,

On Thu, 16 Oct 2008, Kuninori Morimoto wrote:

> This patch adds ov772x driver that use soc_camera framework.
> It was tested on SH Migo-r board.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Thanks for the update and for fixing issues I pointed out in a previous 
review. Unfortunately, two of issues I commented upon stayed unfixed: 
space beore a comma in four places (just search for " ,"), and no 
copyright / license in the header. A couple more notes below - new ones, 
introduced with the current changes, and old ones, that I didn't mention 
in the first review. Still, they are all quite easy to fix and we still 
have a chance to get it in for 2.6.28, if we are quick enough:-)

> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> new file mode 100644
> index 0000000..92ef9de
> --- /dev/null
> +++ b/drivers/media/video/ov772x.c
> @@ -0,0 +1,982 @@
> +/*
> + * ov772x Camera Driver
> + *
> + * Copyright (C) 2008 Renesas Solutions Corp.
> + * Kuninori Morimoto <morimoto.kuninori@renesas.com>
> + *
> + * Based on ov7670 and soc_camera_platform driver,
> + *
> + * Copyright 2006-7 Jonathan Corbet <corbet@lwn.net>
> + * Copyright (C) 2008 Magnus Damm
> + * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <linux/videodev2.h>

Purely cosmetic, but it would look better, if you swap these two headers - 
first all under linux/ then under media/

> +#include <media/v4l2-common.h>
> +#include <media/soc_camera.h>
> +#include <media/ov772x.h>
> +
> +/*
> + * bit defines
> + */
> +#define ZERO 0x00
> +#define B0   0x01
> +#define B1   0x02
> +#define B2   0x04
> +#define B3   0x08
> +
> +#define B4   0x10
> +#define B5   0x20
> +#define B6   0x40
> +#define B7   0x80

Please, remove these defines, IMHO, they only obfuscate the code. Just use 
respective hexadecimal numbers or something like (1UL << 0), (1UL << 1), 
etc. if you prefer.

> +#define ENDMARKER { 0xff, 0xff }
> +
> +static struct regval_list ov772x_default_regs[] =
> +{
> +	{ COM3,  ZERO },
> +	{ COM4,  PLL_4x | 0x01 },
> +	{ 0x16,  0x00 },  /* Mystery */
> +	{ COM11, B4 },    /* Mystery */
> +	{ 0x28,  0x00 },  /* Mystery */
> +	{ HREF,  0x00 },
> +	{ COM13, 0xe2 },  /* Mystery */
> +	{ AREF0, 0xef },
> +	{ AREF2, 0x60 },
> +	{ AREF6, 0x7a },
> +	ENDMARKER,
> +};
> +
> +/*
> + * register setting for color format
> + */
> +static struct regval_list ov772x_RGB555_regs[] = {
> +	{ COM7, FMT_RGB555 | OFMT_RGB },
> +	ENDMARKER,
> +};
> +
> +static struct regval_list ov772x_RGB565_regs[] = {
> +	{ COM7, FMT_RGB565 | OFMT_RGB },
> +	ENDMARKER,
> +};
> +
> +static struct regval_list ov772x_YYUV_regs[] = {
> +	{ COM3, SWAP_YUV },
> +	{ COM7, OFMT_YUV },
> +	ENDMARKER,
> +};
> +
> +static struct regval_list ov772x_UVYY_regs[] = {
> +	{ COM7, OFMT_YUV },
> +	ENDMARKER,
> +};
> +
> +
> +/*
> + * register setting for window size
> + */
> +static struct regval_list ov772x_qvga_regs[] = {
> +	{ HSTART,   HST_QVGA },
> +	{ HSIZE,    HSZ_QVGA },
> +	{ VSTART,   VST_QVGA },
> +	{ VSIZE,    VSZ_QVGA  },
> +	{ HOUTSIZE, HOSZ_QVGA },
> +	{ VOUTSIZE, VOSZ_QVGA },
> +	ENDMARKER,
> +};
> +
> +static struct regval_list ov772x_vga_regs[] = {
> +	{ HSTART,   HST_VGA },
> +	{ HSIZE,    HSZ_VGA },
> +	{ VSTART,   VST_VGA },
> +	{ VSIZE,    VSZ_VGA },
> +	{ HOUTSIZE, HOSZ_VGA },
> +	{ VOUTSIZE, VOSZ_VGA },
> +	ENDMARKER ,
> +};

As far as I understand, these structs do not change at runtime, right? If 
so, would be nice to mark them const. Then you would certainly have to 
mark the regs pointer in struct ov772x_color_format, struct 
ov772x_win_size and the vals parameter to ov772x_write_array() const too, 
maybe there are more. The advantages of doing so is 1) it makes it clear, 
that these data doesn't change, 2) the compiler gets a chance to optimize 
these (no idea if it does), 3) your use of the ENDMARKER becomes more 
justified then - the structs do not change, 4) then you can simplify the 
test in ov772x_write_array() to just (vals->reg_num != 0xff). But this is 
just an idea, you may disagree:-)

[snip]

> +/*
> + * general function
> + */
> +
> +static int ov772x_write_array(struct i2c_client  *client,
> +			      struct regval_list *vals)
> +{
> +	while (vals->reg_num != 0xff || vals->value != 0xff) {

This is the loop I meant above.

[snip]

> +static int ov772x_video_probe(struct soc_camera_device *icd)
> +{
> +	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
> +
> +	/*
> +	 * We must have a parent by now. And it cannot be a wrong one.
> +	 * So this entire test is completely redundant.
> +	 */
> +	if (!icd->dev.parent ||
> +	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)
> +		return -ENODEV;
> +
> +	/*
> +	 * ov772x only use 8 or 10 bit bus width
> +	 */
> +	if (SOCAM_DATAWIDTH_10 != priv->info->buswidth &&
> +	    SOCAM_DATAWIDTH_8  != priv->info->buswidth) {
> +		dev_err(&icd->dev, "bus width error\n");
> +		return -ENODEV;
> +	}
> +
> +	/*
> +	 * show product ID and manufacturer ID
> +	 */
> +	dev_info(&icd->dev,
> +		 "ov772x Product ID %0x:%0x Manufacturer ID %x:%x\n" ,
> +		 i2c_smbus_read_byte_data(priv->client, PID),
> +		 i2c_smbus_read_byte_data(priv->client, VER),
> +		 i2c_smbus_read_byte_data(priv->client, MIDH),
> +		 i2c_smbus_read_byte_data(priv->client, MIDL));

Would be good to verify that the ID(s) read from the hardware match 
expectation and fail probe otherwise.

> +
> +	icd->formats     = ov772x_fmt_lists;
> +	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
> +
> +	if (priv->info->link.power)
> +		priv->info->link.power(&priv->client->dev, 1);

This doesn't look right. You first read out IDs and then power the camera 
on?...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
