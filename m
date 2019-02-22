Return-Path: <SRS0=hjs2=Q5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4119EC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 01:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAC7F207E0
	for <linux-media@archiver.kernel.org>; Fri, 22 Feb 2019 01:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="prQgkmsO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfBVB2T (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Feb 2019 20:28:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40475 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfBVB2S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Feb 2019 20:28:18 -0500
Received: by mail-wr1-f68.google.com with SMTP id q1so578759wrp.7
        for <linux-media@vger.kernel.org>; Thu, 21 Feb 2019 17:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=0nDj4yU4v9b2HljLBbyRCecwe3C0YUC/hMMHw0sho/4=;
        b=prQgkmsO6BTM3OO6Ds+NHGW0Q4N+mT+TZ1+gHPQIjwNJaOLm+wNsVDVnW7cW7Gf9ij
         007B6Z2G9xTQbe9O8u36NYzP1zb/+D5b6xlYJIWfaPzNSVy/k0fygDZzlqZNtz7RyOpg
         UMCGOp5fsHJH3yMI4dZFRZYGJXF2+lz1ztSfJJlVC1NeabcI3rlYPHYIdj/jC9VqKJ29
         9RXi1PW4UHKq3HbuEKvkCslZ7jE8YWVJfxOi5jB9OwEBPBKkaNg879HC88TVGY0d7anj
         ma7wwxdRW5vp27y9w8YnUVfvfa7a5K9wW9EYxSUnpV3q2bwZchOBZ14K3xuvNhUP2dl4
         MR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=0nDj4yU4v9b2HljLBbyRCecwe3C0YUC/hMMHw0sho/4=;
        b=eULU6O9FQGY0ajjw5SfmjLIOuMK8kC7Nt9qHhoEKiYW+6HdfPodxMv9pkt//9KT9mz
         E0nFVbmcoMEK46tBGo6kghTV9TJcksjscIGCwKujwk++liRdG/9XZFqUqjkPotgrkv+s
         VfIEJzkuyVPAOBXy5bcAUkOvjSY3nuD8O8zesqmehkeghV3tx0PqfKSMyor+IIAsNvmc
         NvVGFLouy/2qo3g3D9rKBIUov0NLT8CFSuefuOfFMLX0WX1U+VWXQUPVxtQGG/6Svkd/
         8ng8Ts7Bkl1U5qDtUjbX0pFBBkBYA6lGljuANSypU3Fj1YXKVKBsdw9aOv6xIbCUM5T5
         ymug==
X-Gm-Message-State: AHQUAuZ6Q4f2PugCS9lUBriJQubx0YgymCQblHUCg9unL0jl3ycWeSqe
        IIzq2urB6VKnenlncYFLjMA=
X-Google-Smtp-Source: AHgI3IZJTbvwwY0W9DOglCJ6Hcj5bVCAbHIZEayqzoXtpXR324Ey+pG8pmS8g4aXR9K2MiN0LWOS4w==
X-Received: by 2002:adf:b687:: with SMTP id j7mr951321wre.81.1550798895663;
        Thu, 21 Feb 2019 17:28:15 -0800 (PST)
Received: from [172.30.89.59] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id k6sm131852wrq.82.2019.02.21.17.28.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 17:28:15 -0800 (PST)
Subject: Re: [PATCH] media: imx: vdic: add frame skipping support
To:     =?UTF-8?Q?Ga=c3=abl_PORTAY?= <gael.portay@collabora.com>,
        linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel@collabora.com
References: <20190218151304.662-1-gael.portay@collabora.com>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <997b314f-3aa0-5fb1-f2ee-afd0bbe10e71@gmail.com>
Date:   Thu, 21 Feb 2019 17:28:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190218151304.662-1-gael.portay@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Gael,

Some general comments before getting to specifics below.

First, the frame skipping register interface in IPUv3 is very similar 
between CSI/SMFC, VDIC, IC PRPENC, and IC PRPVF. They all support the 
same register frame skipping interface, the only difference being the 
maximum skip set. CSI/SMFC max skip set size is 5 frames, IC PRPENC/VF 
is 4, and VDIC is 11. So It would be preferable to move the frame 
skipping API into imx-media-utils, to make this available to the CSI, 
PRPENC, PRPVF, and VDIC subdevices with less code duplication.

Second, since there is no API change in IPUv3 (only the addition of a 
new exported function), it would be much preferred to split this patch 
up into at least 2 patches, one being pure IPUv3 patch, and the other(s) 
pure imx-media.


On 2/18/19 7:13 AM, Gaël PORTAY wrote:
> The VDIC can skip frames, allowing to reduce the frame rate at its
> output pad by small fractions.
>
> With this commit, once can specify the frame interval with media-ctl.
>
> media-ctl -V "'ipu1_vdic':2 [fmt: UYVY8_2X8/720x576@1/30 field:interlaced-tb]"

The VDIC source pad will only output motion-compensated de-interlaced 
output, so above should be written "field:none".

>
> The commit is an adaptation for VDIC of the commit fb30ee795576 ([media]
> media: imx: csi: add frame skipping support).
>
> Signed-off-by: Gaël PORTAY <gael.portay@collabora.com>
> ---
>   drivers/gpu/ipu-v3/ipu-common.c            |  28 +++++
>   drivers/staging/media/imx/imx-media-vdic.c | 129 +++++++++++++++++++--
>   include/video/imx-ipu-v3.h                 |   1 +
>   3 files changed, 149 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
> index 474b00e19697..19e1e50dc469 100644
> --- a/drivers/gpu/ipu-v3/ipu-common.c
> +++ b/drivers/gpu/ipu-v3/ipu-common.c
> @@ -35,6 +35,12 @@
>   #include <video/imx-ipu-v3.h>
>   #include "ipu-prv.h"
>   
> +/* IPU Register Fields */
> +#define VDI_MAX_RATIO_SKIP_MASK			0x000f0000
> +#define VDI_MAX_RATIO_SKIP_SHIFT		16
> +#define VDI_SKIP_MASK_MASK			0xfff00000
> +#define VDI_SKIP_SHIFT_SHIFT			20
> +
>   static inline u32 ipu_cm_read(struct ipu_soc *ipu, unsigned offset)
>   {
>   	return readl(ipu->cm_reg + offset);
> @@ -267,6 +273,28 @@ int ipu_rot_mode_to_degrees(int *degrees, enum ipu_rotate_mode mode,
>   }
>   EXPORT_SYMBOL_GPL(ipu_rot_mode_to_degrees);
>   
> +int ipu_set_skip_vdi(struct ipu_soc *ipu, u32 skip, u32 max_ratio)
> +{
> +	unsigned long flags;
> +	u32 temp;
> +
> +	if (max_ratio > 15)
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&ipu->lock, flags);
> +
> +	temp = ipu_cm_read(ipu, IPU_SKIP);
> +	temp &= ~(VDI_MAX_RATIO_SKIP_MASK | VDI_SKIP_MASK_MASK);
> +	temp |= (max_ratio << VDI_MAX_RATIO_SKIP_SHIFT) |
> +		(skip << VDI_SKIP_SHIFT_SHIFT);
> +	ipu_cm_write(ipu, temp, IPU_SKIP);
> +
> +	spin_unlock_irqrestore(&ipu->lock, flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_set_skip_vdi);
> +
>   struct ipuv3_channel *ipu_idmac_get(struct ipu_soc *ipu, unsigned num)
>   {
>   	struct ipuv3_channel *channel;
> diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
> index 2808662e2597..a12ac4dd5afd 100644
> --- a/drivers/staging/media/imx/imx-media-vdic.c
> +++ b/drivers/staging/media/imx/imx-media-vdic.c
> @@ -9,6 +9,7 @@
>    * (at your option) any later version.
>    */
>   #include <linux/delay.h>
> +#include <linux/gcd.h>
>   #include <linux/interrupt.h>
>   #include <linux/module.h>
>   #include <linux/platform_device.h>
> @@ -68,6 +69,18 @@ struct vdic_pipeline_ops {
>   #define H_ALIGN    1 /* multiple of 2 lines */
>   #define S_ALIGN    1 /* multiple of 2 */
>   
> +/*
> + * struct vdic_skip_desc - VDIC frame skipping descriptor
> + * @keep - number of frames kept per max_ratio frames
> + * @max_ratio - width of skip, written to MAX_RATIO bitfield
> + * @skip - skip pattern written to the SKIP bitfield
> + */
> +struct vdic_skip_desc {
> +	u8 keep;
> +	u8 max_ratio;
> +	u8 skip;
> +};
> +
>   struct vdic_priv {
>   	struct device        *dev;
>   	struct ipu_soc       *ipu;
> @@ -111,6 +124,7 @@ struct vdic_priv {
>   	struct v4l2_mbus_framefmt format_mbus[VDIC_NUM_PADS];
>   	const struct imx_media_pixfmt *cc[VDIC_NUM_PADS];
>   	struct v4l2_fract frame_interval[VDIC_NUM_PADS];
> +	const struct vdic_skip_desc *skip;
>   
>   	/* the video device at IDMAC input pad */
>   	struct imx_media_video_dev *vdev;
> @@ -388,6 +402,7 @@ static int vdic_start(struct vdic_priv *priv)
>   		      infmt->width, infmt->height);
>   	ipu_vdi_set_field_order(priv->vdi, V4L2_STD_UNKNOWN, infmt->field);
>   	ipu_vdi_set_motion(priv->vdi, priv->motion);
> +	ipu_set_skip_vdi(priv->ipu, priv->skip->skip, priv->skip->max_ratio - 1);
>   
>   	ret = priv->ops->setup(priv);
>   	if (ret)
> @@ -558,6 +573,63 @@ static int vdic_enum_mbus_code(struct v4l2_subdev *sd,
>   	return imx_media_enum_ipu_format(&code->code, code->index, CS_SEL_YUV);
>   }
>   
> +static const struct vdic_skip_desc vdic_skip[12] = {
> +	{ 1, 1, 0x00 }, /* Keep all frames */
> +	{ 5, 6, 0x10 }, /* Skip every sixth frame */
> +	{ 4, 5, 0x08 }, /* Skip every fifth frame */
> +	{ 3, 4, 0x04 }, /* Skip every fourth frame */
> +	{ 2, 3, 0x02 }, /* Skip every third frame */
> +	{ 3, 5, 0x0a }, /* Skip frames 1 and 3 of every 5 */
> +	{ 1, 2, 0x01 }, /* Skip every second frame */
> +	{ 2, 5, 0x0b }, /* Keep frames 1 and 4 of every 5 */
> +	{ 1, 3, 0x03 }, /* Keep one in three frames */
> +	{ 1, 4, 0x07 }, /* Keep one in four frames */
> +	{ 1, 5, 0x0f }, /* Keep one in five frames */
> +	{ 1, 6, 0x1f }, /* Keep one in six frames */
> +};
> +
> +static void vdic_apply_skip_interval(const struct vdic_skip_desc *skip,
> +				     struct v4l2_fract *interval)
> +{
> +	unsigned int div;
> +
> +	interval->numerator *= skip->max_ratio;
> +	interval->denominator *= skip->keep;
> +
> +	/* Reduce fraction to lowest terms */
> +	div = gcd(interval->numerator, interval->denominator);
> +	if (div > 1) {
> +		interval->numerator /= div;
> +		interval->denominator /= div;
> +	}
> +}
> +
> +static int vdic_enum_frame_interval(struct v4l2_subdev *sd,
> +				    struct v4l2_subdev_pad_config *cfg,
> +				    struct v4l2_subdev_frame_interval_enum *fie)
> +{
> +	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
> +	struct v4l2_fract *input_fi;
> +	int ret = 0;
> +
> +	if (fie->pad >= VDIC_NUM_PADS ||
> +	    fie->index >= (fie->pad != VDIC_SRC_PAD_DIRECT ?
> +			   1 : ARRAY_SIZE(vdic_skip)))
> +		return -EINVAL;
> +
> +	mutex_lock(&priv->lock);
> +
> +	input_fi = &priv->frame_interval[CSI_SINK_PAD];
> +	fie->interval = *input_fi;
> +
> +	if (fie->pad == VDIC_SRC_PAD_DIRECT)
> +		vdic_apply_skip_interval(&vdic_skip[fie->index],
> +					 &fie->interval);
> +
> +	mutex_unlock(&priv->lock);
> +	return ret;
> +}
> +
>   static int vdic_get_fmt(struct v4l2_subdev *sd,
>   			struct v4l2_subdev_pad_config *cfg,
>   			struct v4l2_subdev_format *sdformat)
> @@ -786,6 +858,48 @@ static int vdic_link_validate(struct v4l2_subdev *sd,
>   	return ret;
>   }
>   
> +/*
> + * Find the skip pattern to produce the output frame interval closest to the
> + * requested one, for the given input frame interval. Updates the output frame
> + * interval to the exact value.
> + */
> +static const struct vdic_skip_desc *vdic_find_best_skip(struct v4l2_fract *in,
> +							struct v4l2_fract *out)
> +{
> +	const struct vdic_skip_desc *skip = &vdic_skip[0], *best_skip = skip;
> +	u32 min_err = UINT_MAX;
> +	u64 want_us;
> +	int i;
> +
> +	/* Default to 1:1 ratio */
> +	if (out->numerator == 0 || out->denominator == 0 ||
> +	    in->numerator == 0 || in->denominator == 0) {
> +		*out = *in;
> +		return best_skip;
> +	}
> +
> +	want_us = div_u64((u64)USEC_PER_SEC * out->numerator, out->denominator);
> +
> +	/* Find the reduction closest to the requested time per frame */
> +	for (i = 0; i < ARRAY_SIZE(vdic_skip); i++, skip++) {
> +		u64 tmp, err;
> +
> +		tmp = div_u64((u64)USEC_PER_SEC * in->numerator *
> +			      skip->max_ratio, in->denominator * skip->keep);
> +
> +		err = abs((s64)tmp - want_us);
> +		if (err < min_err) {
> +			min_err = err;
> +			best_skip = skip;
> +		}
> +	}
> +
> +	*out = *in;
> +	vdic_apply_skip_interval(best_skip, out);
> +
> +	return best_skip;
> +}
> +
>   static int vdic_g_frame_interval(struct v4l2_subdev *sd,
>   				struct v4l2_subdev_frame_interval *fi)
>   {
> @@ -826,17 +940,10 @@ static int vdic_s_frame_interval(struct v4l2_subdev *sd,
>   		*output_fi = fi->interval;
>   		if (priv->csi_direct)
>   			output_fi->denominator *= 2;
> +		priv->skip = &vdic_skip[0];
>   		break;
>   	case VDIC_SRC_PAD_DIRECT:
> -		/*
> -		 * frame rate at output pad is double input
> -		 * rate when using direct CSI->VDIC pipeline.
> -		 *
> -		 * TODO: implement VDIC frame skipping
> -		 */
> -		fi->interval = *input_fi;
> -		if (priv->csi_direct)
> -			fi->interval.denominator *= 2;
> +		priv->skip = vdic_find_best_skip(output_fi, &fi->interval);

According to the i.MX6 reference manual, "Skipping is relevant only if 
the source to the VDIC is coming from the CSI". So VDIC frame skipping 
should only be allowed if priv->csi_direct is true.

Steve

>   		break;
>   	default:
>   		ret = -EINVAL;
> @@ -883,6 +990,9 @@ static int vdic_registered(struct v4l2_subdev *sd)
>   			priv->frame_interval[i].denominator *= 2;
>   	}
>   
> +	/* disable frame skipping */
> +	priv->skip = &vdic_skip[0];
> +
>   	priv->active_input_pad = VDIC_SINK_PAD_DIRECT;
>   
>   	ret = vdic_init_controls(priv);
> @@ -906,6 +1016,7 @@ static void vdic_unregistered(struct v4l2_subdev *sd)
>   static const struct v4l2_subdev_pad_ops vdic_pad_ops = {
>   	.init_cfg = imx_media_init_cfg,
>   	.enum_mbus_code = vdic_enum_mbus_code,
> +	.enum_frame_interval = vdic_enum_frame_interval,
>   	.get_fmt = vdic_get_fmt,
>   	.set_fmt = vdic_set_fmt,
>   	.link_validate = vdic_link_validate,
> diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
> index c887f4bee5f8..026c4340a8da 100644
> --- a/include/video/imx-ipu-v3.h
> +++ b/include/video/imx-ipu-v3.h
> @@ -203,6 +203,7 @@ int ipu_idmac_channel_irq(struct ipu_soc *ipu, struct ipuv3_channel *channel,
>    * IPU Common functions
>    */
>   int ipu_get_num(struct ipu_soc *ipu);
> +int ipu_set_skip_vdi(struct ipu_soc *csi, u32 skip, u32 max_ratio);
>   void ipu_set_csi_src_mux(struct ipu_soc *ipu, int csi_id, bool mipi_csi2);
>   void ipu_set_ic_src_mux(struct ipu_soc *ipu, int csi_id, bool vdi);
>   void ipu_dump(struct ipu_soc *ipu);

