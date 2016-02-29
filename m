Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34130 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbcB2Nb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 08:31:59 -0500
Received: by mail-lb0-f175.google.com with SMTP id of3so79707252lbc.1
        for <linux-media@vger.kernel.org>; Mon, 29 Feb 2016 05:31:58 -0800 (PST)
Subject: Re: [PATCH/RFC 1/4] media: soc_camera: rcar_vin: Add UDS support
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org
References: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
 <1456751563-21246-2-git-send-email-ykaneko0929@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-renesas-soc@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <56D4484C.1040605@cogentembedded.com>
Date: Mon, 29 Feb 2016 16:31:56 +0300
MIME-Version: 1.0
In-Reply-To: <1456751563-21246-2-git-send-email-ykaneko0929@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 2/29/2016 4:12 PM, Yoshihiro Kaneko wrote:

> From: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
>
> Add UDS control for R-Car Gen3. Up down scaler can be vertical and
> horizontal scaling.
>
> Signed-off-by: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
>   drivers/media/platform/soc_camera/rcar_vin.c | 175 +++++++++++++++++++++------
>   1 file changed, 140 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index dc75a80..a22141b 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -90,6 +90,7 @@
>
>   /* Register bit fields for R-Car VIN */
>   /* Video n Main Control Register bits */
> +#define VNMC_SCLE		(1 << 26)

    This is gen3 only, right? Please add a comment about that.

>   #define VNMC_FOC		(1 << 21)
>   #define VNMC_YCAL		(1 << 19)
>   #define VNMC_INF_YUV8_BT656	(0 << 16)
> @@ -132,6 +133,17 @@
>   #define VNDMR2_FTEV		(1 << 17)
>   #define VNDMR2_VLV(n)		((n & 0xf) << 12)
>
> +/* UDS */
> +#define VNUDS_CTRL_REG		0x80	/* Scaling Control Registers */
> +#define VNUDS_CTRL_AMD		(1 << 30)
> +#define VNUDS_CTRL_BC		(1 << 20)
> +#define VNUDS_CTRL_TDIPC	(1 << 1)
> +
> +#define VNUDS_SCALE_REG		0x84	/* Scaling Factor Register */
> +#define VNUDS_PASS_BWIDTH_REG	0x90	/* Passband Registers */
> +#define VNUDS_IPC_REG		0x98	/* 2D IPC Setting Register */
> +#define VNUDS_CLIP_SIZE_REG	0xA4	/* UDS Output Size Clipping Register */
> +
>   #define VIN_MAX_WIDTH		2048
>   #define VIN_MAX_HEIGHT		2048
>
> @@ -526,6 +538,14 @@ struct rcar_vin_cam {
>   	const struct soc_mbus_pixelfmt	*extra_fmt;
>   };
>
> +static inline int is_scaling(struct rcar_vin_cam *cam)

    s/int/bool/.

> +{
> +	if (cam->width != cam->out_width || cam->height != cam->out_height)
> +		return 1;

    s/1/true/.

> +
> +	return 0;

    s/0/false/.

[...]
> +static unsigned long rcar_vin_compute_ratio(unsigned int input,
> +		unsigned int output)
> +{
> +#ifdef DISABLE_UDS_CTRL_AMD

    This not #define'd, right?

> +	return (input - 1) * 4096 / (output - 1);
> +#else
> +	if (output > input)
> +		return input * 4096 / output;
> +	else
> +		return (input - 1) * 4096 / (output - 1);
> +#endif
> +}
[...]
> -	/* Horizontal upscaling is carried out by scaling down from double size */
> -	if (value < 4096)
> -		value *= 2;
> +		dev_dbg(icd->parent, "XS Value: %x\n", value);
> +		iowrite32(value, priv->base + VNXS_REG);
>
> -	set_coeff(priv, value);
> +		/*
> +		 * Horizontal upscaling is carried out
> +		 * by scaling down from double size
> +		 */
> +		if (value < 4096)
> +			value *= 2;
> +
> +		set_coeff(priv, value);
> +
> +		/* Set Start/End Pixel/Line Post-Clip */
> +		iowrite32(0, priv->base + VNSPPOC_REG);
> +		iowrite32(0, priv->base + VNSLPOC_REG);
> +		iowrite32((cam->out_width - 1) << dsize,
> +			priv->base + VNEPPOC_REG);

    Please align the continuation line to start under the second (.

[...]

MBR, Sergei

