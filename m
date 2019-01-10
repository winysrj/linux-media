Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F25FC43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 00:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E3B02173B
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 00:09:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hHqYQx9f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfAJAJA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 19:09:00 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34646 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfAJAJA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 19:09:00 -0500
Received: by mail-wm1-f68.google.com with SMTP id y185so12120507wmd.1
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2019 16:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4kxErpjqM4qUG6VqpQq3CjQyTIfXW0O3ICnxFUuZBSw=;
        b=hHqYQx9fq2EL9ObGCRhTukSYJJ0wyXqCyxQOgf5oMQoORsavtUjK6GQ6hPaNAk0BbC
         S1fhy6fE2ceYtnk9/KKuGT4yg4B0OTlhsjV80/BpG2iUYwGaAY6LUNgPn7gRzgSE6XRK
         xuXraPtqtxPHWodvQ9xK/BUePU0KMXf/heI0wLTtszei9zNgvjeiBTo8oHB8mq8De+8D
         0IbutNdg1uEBw41dc8EjJXuBtnVENIVTWLPm5V4GLRDUR+isflD/hAeM+2dnVFDZJ3Zy
         8GBBG8H/G7QxuPS56hgiOQM9TdLR8betocNTpH9A1AaHif9574tOa5dchMUiSdPc/sNI
         4zSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4kxErpjqM4qUG6VqpQq3CjQyTIfXW0O3ICnxFUuZBSw=;
        b=GiqQ2OF2OHl8kBq7cC5DxoAwAeF+O/swc1pJzE8uiahzVjzJgbHIvRJmTrEnTfLNFh
         B5S3/LlCnX0+1Bswdz/1gqXti5MhSUUuTc2R7BT/HVNMVH1NDnS1mVi8tBVI8rBO1YmO
         acmgOKxp1mxa+9jCaqjjBDHOnUq3r8R+ds5v7XMUiNU2WZkDY/1fXZI69OruWdLPJBrx
         RnJzNmJfwgE4T7Ql9b3PjE9mZLRAKuBymZRih8+1LZmmv9KlTqRin4D6dGdAQUfRjZmF
         IPM8ALvE6OupPYaAQp863Ac4zdovx9Yn6KgriZqthwlP6GItV1q+Ut9flI7xMg/GDF8v
         2X/g==
X-Gm-Message-State: AJcUukfYiAoimVwS5ECnuiSiVNpJrdQ805r8Km6oap7oFZKbcl7b6YKe
        3DX0LvOStcFUSKtKozrQubI=
X-Google-Smtp-Source: ALg8bN77nDdTXQ1G/IzdQ6/B2OiYV+fmQ65n3vTEaaapkvY9lAITDNH69iMmZDr4ayYCCg5hnnOjzQ==
X-Received: by 2002:a1c:df46:: with SMTP id w67mr7818978wmg.51.1547078937891;
        Wed, 09 Jan 2019 16:08:57 -0800 (PST)
Received: from [172.30.90.141] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id z206sm14274502wmc.18.2019.01.09.16.08.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 16:08:57 -0800 (PST)
Subject: Re: [PATCH v2 1/3] media: imx: add capture compose rectangle
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
References: <20190109110831.23395-1-p.zabel@pengutronix.de>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <ebccc88d-3e04-1084-01c8-4904a8d6f79e@gmail.com>
Date:   Wed, 9 Jan 2019 16:08:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190109110831.23395-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>


On 1/9/19 3:08 AM, Philipp Zabel wrote:
> Allowing to compose captured images into larger memory buffers
> will let us lift alignment restrictions on CSI crop width.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Changes since v1:
>   - remove NATIVE_SIZE selection target
>   - fixed typo in capture_s_fmt_vid_cap
> ---
>   drivers/staging/media/imx/imx-ic-prpencvf.c   |  3 +-
>   drivers/staging/media/imx/imx-media-capture.c | 37 +++++++++++++++++++
>   drivers/staging/media/imx/imx-media-csi.c     |  3 +-
>   drivers/staging/media/imx/imx-media-vdic.c    |  4 +-
>   drivers/staging/media/imx/imx-media.h         |  2 +
>   5 files changed, 43 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index 28f41caba05d..fe5a77baa592 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -366,8 +366,7 @@ static int prp_setup_channel(struct prp_priv *priv,
>   
>   	memset(&image, 0, sizeof(image));
>   	image.pix = vdev->fmt.fmt.pix;
> -	image.rect.width = image.pix.width;
> -	image.rect.height = image.pix.height;
> +	image.rect = vdev->compose;
>   
>   	if (rot_swap_width_height) {
>   		swap(image.pix.width, image.pix.height);
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index b37e1186eb2f..fb985e68f9ab 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -262,6 +262,10 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>   	priv->vdev.fmt.fmt.pix = f->fmt.pix;
>   	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat,
>   					      CS_SEL_ANY, true);
> +	priv->vdev.compose.left = 0;
> +	priv->vdev.compose.top = 0;
> +	priv->vdev.compose.width = f->fmt.pix.width;
> +	priv->vdev.compose.height = f->fmt.pix.height;
>   
>   	return 0;
>   }
> @@ -290,6 +294,34 @@ static int capture_s_std(struct file *file, void *fh, v4l2_std_id std)
>   	return v4l2_subdev_call(priv->src_sd, video, s_std, std);
>   }
>   
> +static int capture_g_selection(struct file *file, void *fh,
> +			       struct v4l2_selection *s)
> +{
> +	struct capture_priv *priv = video_drvdata(file);
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_PADDED:
> +		s->r = priv->vdev.compose;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int capture_s_selection(struct file *file, void *fh,
> +			       struct v4l2_selection *s)
> +{
> +	return capture_g_selection(file, fh, s);
> +}
> +
>   static int capture_g_parm(struct file *file, void *fh,
>   			  struct v4l2_streamparm *a)
>   {
> @@ -350,6 +382,9 @@ static const struct v4l2_ioctl_ops capture_ioctl_ops = {
>   	.vidioc_g_std           = capture_g_std,
>   	.vidioc_s_std           = capture_s_std,
>   
> +	.vidioc_g_selection	= capture_g_selection,
> +	.vidioc_s_selection	= capture_s_selection,
> +
>   	.vidioc_g_parm          = capture_g_parm,
>   	.vidioc_s_parm          = capture_s_parm,
>   
> @@ -687,6 +722,8 @@ int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
>   	vdev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>   	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
>   				      &fmt_src.format, NULL);
> +	vdev->compose.width = fmt_src.format.width;
> +	vdev->compose.height = fmt_src.format.height;
>   	vdev->cc = imx_media_find_format(vdev->fmt.fmt.pix.pixelformat,
>   					 CS_SEL_ANY, false);
>   
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 4223f8d418ae..c4523afe7b48 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -413,8 +413,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>   
>   	memset(&image, 0, sizeof(image));
>   	image.pix = vdev->fmt.fmt.pix;
> -	image.rect.width = image.pix.width;
> -	image.rect.height = image.pix.height;
> +	image.rect = vdev->compose;
>   
>   	csi_idmac_setup_vb2_buf(priv, phys);
>   
> diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
> index 482250d47e7c..e08d296cf4eb 100644
> --- a/drivers/staging/media/imx/imx-media-vdic.c
> +++ b/drivers/staging/media/imx/imx-media-vdic.c
> @@ -263,10 +263,10 @@ static int setup_vdi_channel(struct vdic_priv *priv,
>   
>   	memset(&image, 0, sizeof(image));
>   	image.pix = vdev->fmt.fmt.pix;
> +	image.rect = vdev->compose;
>   	/* one field to VDIC channels */
>   	image.pix.height /= 2;
> -	image.rect.width = image.pix.width;
> -	image.rect.height = image.pix.height;
> +	image.rect.height /= 2;
>   	image.phys0 = phys0;
>   	image.phys1 = phys1;
>   
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
> index bc7feb81937c..7a0e658753f0 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -80,6 +80,8 @@ struct imx_media_video_dev {
>   
>   	/* the user format */
>   	struct v4l2_format fmt;
> +	/* the compose rectangle */
> +	struct v4l2_rect compose;
>   	const struct imx_media_pixfmt *cc;
>   
>   	/* links this vdev to master list */

