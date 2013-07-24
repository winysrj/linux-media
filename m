Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:51248 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab3GXQOc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 12:14:32 -0400
Date: Wed, 24 Jul 2013 18:14:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH v8] V4L2: soc_camera: Renesas R-Car VIN driver
In-Reply-To: <201307200314.35345.sergei.shtylyov@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1307241731560.2179@axis700.grange>
References: <201307200314.35345.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei, Vladimir

So, looks like we're almost there. checkpatch.pl looks pretty good too, I 
don't care about > 80 chars, Kconfig seems to be a dull one, have a look 
at msleep(1) warning whether it bothers you.

On Sat, 20 Jul 2013, Sergei Shtylyov wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> Add Renesas R-Car VIN (Video In) V4L2 driver.
> 
> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> 
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: removed deprecated IRQF_DISABLED flag, reordered/renamed 'enum chip_id'
> values, reordered rcar_vin_id_table[] entries,  removed senseless parens from
> to_buf_list() macro, used ALIGN() macro in rcar_vin_setup(), added {} to the
> *if* statement  and used 'bool' values instead of 0/1 where necessary, removed
> unused macros, done some reformatting and clarified some comments.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> 
> ---
> This patch is against the 'media_tree.git' repo.
> 
> Changes since version 7:
> - remove 'icd' field from 'struct rcar_vin_priv' in accordance with the commit
>   f7f6ce2d09c86bd80ee11bd654a1ac1e8f5dfe13 ([media] soc-camera: move common code
>   to soc_camera.c);
> - added mandatory clock_{start|stop}() methods in accordance with the commit
>   a78fcc11264b824d9651b55abfeedd16d5cd8415 ([media] soc-camera: make .clock_
>   {start,stop} compulsory, .add / .remove optional).
> 
> Changes since version 6:
> - sorted #include's alphabetically once again;
> - BUG() on invalid format in rcar_vin_setup();

No, please don't. I think I commented on the use of BUG() in this driver 
already. It shall only be used if the machine cannot continue to run. I 
don't think this is the sace here.

[snip]

> Index: media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> ===================================================================
> --- /dev/null
> +++ media_tree/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -0,0 +1,1474 @@

[snip]

> +	/* output format */
> +	switch (icd->current_fmt->host_fmt->fourcc) {
> +	case V4L2_PIX_FMT_NV16:
> +		iowrite32(ALIGN(cam->width * cam->height, 0x80),
> +			  priv->base + VNUVAOF_REG);
> +		dmr = VNDMR_DTMD_YCSEP;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_YUYV:
> +		dmr = VNDMR_BPSM;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_UYVY:
> +		dmr = 0;
> +		output_is_yuv = true;
> +		break;
> +	case V4L2_PIX_FMT_RGB555X:
> +		dmr = VNDMR_DTMD_ARGB1555;
> +		break;
> +	case V4L2_PIX_FMT_RGB565:
> +		dmr = 0;
> +		break;
> +	case V4L2_PIX_FMT_RGB32:
> +		if (priv->chip == RCAR_H1 || priv->chip == RCAR_E1) {
> +			dmr = VNDMR_EXRGB;
> +			break;
> +		}
> +	default:
> +		BUG();

as commented above, please, remove

[snip]

> +/* Called with .host_lock held */
> +static int rcar_vin_clock_start(struct soc_camera_host *ici)
> +{

Ok, this looks suspicious to me, because all other drivers activate their 
master clock output here. Looking at the datasheet though it does look 
like VIN doesn't have a master clock output. In such a case maybe you 
could add a clarifying comment here. It might even be worth making these 
two callbacks optional too, but this is the only driver so far, that 
doesn't use them, so, let's keep it this way for now, just, please, add a 
comment.

> +	return 0;
> +}
> +
> +/* Called with .host_lock held */
> +static void rcar_vin_clock_stop(struct soc_camera_host *ici)
> +{
> +}

[snip]

> +static const struct soc_mbus_pixelfmt rcar_vin_formats[] = {
> +	{
> +		.fourcc			= V4L2_PIX_FMT_NV16,
> +		.name			= "NV16",
> +		.bits_per_sample	= 16,
> +		.packing		= SOC_MBUS_PACKING_2X8_PADHI,

ehem... you sample 16 bits and you say you have to sample 2 x 8 bits, 
something seems wrong to me.

> +		.order			= SOC_MBUS_ORDER_LE,
> +		.layout			= SOC_MBUS_LAYOUT_PLANAR_Y_C,
> +	},

[snip]

> +	ret = soc_camera_client_scale(icd, &cam->rect, &cam->subrect,
> +				      &mf, &vin_sub_width, &vin_sub_height,
> +				      can_scale, 12);
> +
> +	/* Done with the camera. Now see if we can improve the result */
> +	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
> +		ret, mf.width, mf.height, pix->width, pix->height);
> +
> +	if (ret == -ENOIOCTLCMD)
> +		dev_dbg(dev, "Sensor doesn't support cropping\n");

You mean "scaling"

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
