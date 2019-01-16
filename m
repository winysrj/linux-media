Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F53C43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D61B0206C2
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404885AbfAPP3K (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:29:10 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:52700 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404852AbfAPP3K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 10:29:10 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id jn7rgUv9tNR5yjn7sgQ0kx; Wed, 16 Jan 2019 16:29:08 +0100
Subject: Re: [PATCH v3 1/3] media: imx: add capture compose rectangle
To:     Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, kernel@pengutronix.de
References: <20190111111053.12551-1-p.zabel@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f23fae30-d1ed-7817-e531-d47a47ea94a5@xs4all.nl>
Date:   Wed, 16 Jan 2019 16:29:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190111111053.12551-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfJS9+y7pso4pZ91D6rqJeYUb97lbTwTTNVa5bvafXDTRX1SNYVGwC3XK6GySVEE4pdX8Ft6/WhldH8I4FIF/+RVt3TZGP9Q4oCuiIVr0zVSuKn85Ng9W
 x8kIXEo+QJJE+LvYqO62c5nWv3Q3LzMbsEn13pMF49Js+WlcWxh/0uN8QcE35KceZ4zf/WhUs0UzXg+1+KHOFQR/WxH6OnsXf21udAjfCxXqGNOsHnW408Hm
 vUGNbcewbIgtU1LQctzo8/q3JF4++He0EuDR95aXMQZEZu8O2yNy0j0Qfgnp09pIcr7Mbzyr2SyWEmKbs8Pd3FLJigiczcy3PcAn2e1drU8ppKnxyVcPofyO
 tVIGotutyrsUlFAKk567x9k/BvhFKRCJuBniNclZnn0n1ebdBSCmo7JyD2Nx8idNfjXpuprlzyU2oSsL8MBDDExnbK0WBg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/11/19 12:10 PM, Philipp Zabel wrote:
> Allowing to compose captured images into larger memory buffers
> will let us lift alignment restrictions on CSI crop width.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/staging/media/imx/imx-ic-prpencvf.c   |  3 +-
>  drivers/staging/media/imx/imx-media-capture.c | 37 +++++++++++++++++++
>  drivers/staging/media/imx/imx-media-csi.c     |  3 +-
>  drivers/staging/media/imx/imx-media-vdic.c    |  4 +-
>  drivers/staging/media/imx/imx-media.h         |  2 +
>  5 files changed, 43 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
> index 28f41caba05d..fe5a77baa592 100644
> --- a/drivers/staging/media/imx/imx-ic-prpencvf.c
> +++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
> @@ -366,8 +366,7 @@ static int prp_setup_channel(struct prp_priv *priv,
>  
>  	memset(&image, 0, sizeof(image));
>  	image.pix = vdev->fmt.fmt.pix;
> -	image.rect.width = image.pix.width;
> -	image.rect.height = image.pix.height;
> +	image.rect = vdev->compose;
>  
>  	if (rot_swap_width_height) {
>  		swap(image.pix.width, image.pix.height);
> diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
> index b37e1186eb2f..fb985e68f9ab 100644
> --- a/drivers/staging/media/imx/imx-media-capture.c
> +++ b/drivers/staging/media/imx/imx-media-capture.c
> @@ -262,6 +262,10 @@ static int capture_s_fmt_vid_cap(struct file *file, void *fh,
>  	priv->vdev.fmt.fmt.pix = f->fmt.pix;
>  	priv->vdev.cc = imx_media_find_format(f->fmt.pix.pixelformat,
>  					      CS_SEL_ANY, true);
> +	priv->vdev.compose.left = 0;
> +	priv->vdev.compose.top = 0;
> +	priv->vdev.compose.width = f->fmt.pix.width;
> +	priv->vdev.compose.height = f->fmt.pix.height;
>  
>  	return 0;
>  }
> @@ -290,6 +294,34 @@ static int capture_s_std(struct file *file, void *fh, v4l2_std_id std)
>  	return v4l2_subdev_call(priv->src_sd, video, s_std, std);
>  }
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

The crop rectangle is equal to the compose rectangle? That can't be right.
Does the hardware support cropping at all? Probably not, and in that case
you shouldn't support the crop target at all.

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

Don't implement s_selection unless you can actually change the selection
rectangle(s).

> +
>  static int capture_g_parm(struct file *file, void *fh,
>  			  struct v4l2_streamparm *a)
>  {
> @@ -350,6 +382,9 @@ static const struct v4l2_ioctl_ops capture_ioctl_ops = {
>  	.vidioc_g_std           = capture_g_std,
>  	.vidioc_s_std           = capture_s_std,
>  
> +	.vidioc_g_selection	= capture_g_selection,
> +	.vidioc_s_selection	= capture_s_selection,
> +
>  	.vidioc_g_parm          = capture_g_parm,
>  	.vidioc_s_parm          = capture_s_parm,
>  
> @@ -687,6 +722,8 @@ int imx_media_capture_device_register(struct imx_media_video_dev *vdev)
>  	vdev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  	imx_media_mbus_fmt_to_pix_fmt(&vdev->fmt.fmt.pix,
>  				      &fmt_src.format, NULL);
> +	vdev->compose.width = fmt_src.format.width;
> +	vdev->compose.height = fmt_src.format.height;
>  	vdev->cc = imx_media_find_format(vdev->fmt.fmt.pix.pixelformat,
>  					 CS_SEL_ANY, false);
>  
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 4223f8d418ae..c4523afe7b48 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -413,8 +413,7 @@ static int csi_idmac_setup_channel(struct csi_priv *priv)
>  
>  	memset(&image, 0, sizeof(image));
>  	image.pix = vdev->fmt.fmt.pix;
> -	image.rect.width = image.pix.width;
> -	image.rect.height = image.pix.height;
> +	image.rect = vdev->compose;
>  
>  	csi_idmac_setup_vb2_buf(priv, phys);
>  
> diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
> index 482250d47e7c..e08d296cf4eb 100644
> --- a/drivers/staging/media/imx/imx-media-vdic.c
> +++ b/drivers/staging/media/imx/imx-media-vdic.c
> @@ -263,10 +263,10 @@ static int setup_vdi_channel(struct vdic_priv *priv,
>  
>  	memset(&image, 0, sizeof(image));
>  	image.pix = vdev->fmt.fmt.pix;
> +	image.rect = vdev->compose;
>  	/* one field to VDIC channels */
>  	image.pix.height /= 2;
> -	image.rect.width = image.pix.width;
> -	image.rect.height = image.pix.height;
> +	image.rect.height /= 2;
>  	image.phys0 = phys0;
>  	image.phys1 = phys1;
>  
> diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
> index bc7feb81937c..7a0e658753f0 100644
> --- a/drivers/staging/media/imx/imx-media.h
> +++ b/drivers/staging/media/imx/imx-media.h
> @@ -80,6 +80,8 @@ struct imx_media_video_dev {
>  
>  	/* the user format */
>  	struct v4l2_format fmt;
> +	/* the compose rectangle */
> +	struct v4l2_rect compose;
>  	const struct imx_media_pixfmt *cc;
>  
>  	/* links this vdev to master list */
> 

Regards,

	Hans
