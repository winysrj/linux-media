Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1676 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaCCHup (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 02:50:45 -0500
Message-ID: <53143439.5030007@xs4all.nl>
Date: Mon, 03 Mar 2014 08:50:17 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>, k.debski@samsung.com
CC: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 7/7] v4l: ti-vpe: Add crop support in VPE driver
References: <1393832008-22174-1-git-send-email-archit@ti.com> <1393832008-22174-8-git-send-email-archit@ti.com>
In-Reply-To: <1393832008-22174-8-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit!

On 03/03/2014 08:33 AM, Archit Taneja wrote:
> Add crop ioctl ops. For VPE, cropping only makes sense with the input to VPE, or
> the V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer type.
> 
> For the CAPTURE type, a S_CROP ioctl results in setting the crop region as the
> whole image itself, hence making crop dimensions same as the pix dimensions.
> 
> Setting the crop successfully should result in re-configuration of those
> registers which are affected when either source or destination dimensions
> change, set_srcdst_params() is called for this purpose.
> 
> Some standard crop parameter checks are done in __vpe_try_crop().

Please use the selection ops instead: if you implement cropping with those then you'll
support both the selection API and the old cropping API will be implemented by the v4l2
core using the selection ops. Two for the price of one...

Regards,

	Hans

> 
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/platform/ti-vpe/vpe.c | 96 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 6acdcd8..c6778f4 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -1585,6 +1585,98 @@ static int vpe_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  	return set_srcdst_params(ctx);
>  }
>  
> +static int __vpe_try_crop(struct vpe_ctx *ctx, struct v4l2_crop *cr)
> +{
> +	struct vpe_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, cr->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	/* we don't support crop on capture plane */
> +	if (cr->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +		cr->c.top = cr->c.left = 0;
> +		cr->c.width = q_data->width;
> +		cr->c.height = q_data->height;
> +		return 0;
> +	}
> +
> +	if (cr->c.top < 0 || cr->c.left < 0) {
> +		vpe_err(ctx->dev, "negative values for top and left\n");
> +		cr->c.top = cr->c.left = 0;
> +	}
> +
> +	v4l_bound_align_image(&cr->c.width, MIN_W, q_data->width, 1,
> +		&cr->c.height, MIN_H, q_data->height, H_ALIGN, S_ALIGN);
> +
> +	/* adjust left/top if cropping rectangle is out of bounds */
> +	if (cr->c.left + cr->c.width > q_data->width)
> +		cr->c.left = q_data->width - cr->c.width;
> +	if (cr->c.top + cr->c.height > q_data->height)
> +		cr->c.top = q_data->height - cr->c.height;
> +
> +	return 0;
> +}
> +
> +static int vpe_cropcap(struct file *file, void *priv, struct v4l2_cropcap *cr)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +	struct vpe_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, cr->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	cr->bounds.left = 0;
> +	cr->bounds.top = 0;
> +	cr->bounds.width = q_data->width;
> +	cr->bounds.height = q_data->height;
> +	cr->defrect = cr->bounds;
> +
> +	return 0;
> +}
> +
> +static int vpe_g_crop(struct file *file, void *fh, struct v4l2_crop *cr)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +	struct vpe_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, cr->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	cr->c = q_data->c_rect;
> +
> +	return 0;
> +}
> +
> +static int vpe_s_crop(struct file *file, void *priv,
> +		const struct v4l2_crop *crop)
> +{
> +	struct vpe_ctx *ctx = file2ctx(file);
> +	struct vpe_q_data *q_data;
> +	struct v4l2_crop cr = *crop;
> +	int ret;
> +
> +	ret = __vpe_try_crop(ctx, &cr);
> +	if (ret)
> +		return ret;
> +
> +	q_data = get_q_data(ctx, cr.type);
> +
> +	if ((q_data->c_rect.left == cr.c.left) &&
> +			(q_data->c_rect.top == cr.c.top) &&
> +			(q_data->c_rect.width == cr.c.width) &&
> +			(q_data->c_rect.height == cr.c.height)) {
> +		vpe_dbg(ctx->dev, "requested crop values are already set\n");
> +		return 0;
> +	}
> +
> +	q_data->c_rect = cr.c;
> +
> +	return set_srcdst_params(ctx);
> +}
> +
>  static int vpe_reqbufs(struct file *file, void *priv,
>  		       struct v4l2_requestbuffers *reqbufs)
>  {
> @@ -1672,6 +1764,10 @@ static const struct v4l2_ioctl_ops vpe_ioctl_ops = {
>  	.vidioc_try_fmt_vid_out_mplane	= vpe_try_fmt,
>  	.vidioc_s_fmt_vid_out_mplane	= vpe_s_fmt,
>  
> +	.vidioc_cropcap			= vpe_cropcap,
> +	.vidioc_g_crop			= vpe_g_crop,
> +	.vidioc_s_crop			= vpe_s_crop,
> +
>  	.vidioc_reqbufs		= vpe_reqbufs,
>  	.vidioc_querybuf	= vpe_querybuf,
>  
> 

