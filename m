Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33983 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdFBWFF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 18:05:05 -0400
Subject: Re: [PATCH 9/9] [media] s5p-jpeg: Add support for multi-planar APIs
To: Thierry Escande <thierry.escande@collabora.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1496419376-17099-1-git-send-email-thierry.escande@collabora.com>
 <1496419376-17099-10-git-send-email-thierry.escande@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <6ad28dbf-a031-29a2-11a8-cdd688be3c3d@gmail.com>
Date: Sat, 3 Jun 2017 00:04:20 +0200
MIME-Version: 1.0
In-Reply-To: <1496419376-17099-10-git-send-email-thierry.escande@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

What is the gain of introducing multiplanar API for this hardware?
AFAIR all the HW implementations store the data in a single contiguous
memory region and use suitable padding between planes.

On 06/02/2017 06:02 PM, Thierry Escande wrote:
> From: Ricky Liang <jcliang@chromium.org>
> 
> This patch adds multi-planar APIs to the s5p-jpeg driver. The multi-planar
> APIs are identical to the exisiting single-planar APIs except the plane
> format info is stored in the v4l2_pixel_format_mplan struct instead
> of the v4l2_pixel_format struct.
> 
> Signed-off-by: Ricky Liang <jcliang@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 152 +++++++++++++++++++++++++---
>  drivers/media/platform/s5p-jpeg/jpeg-core.h |   2 +
>  2 files changed, 139 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index db56135..a8fd7ed 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1371,6 +1371,15 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
>  		 dev_name(ctx->jpeg->dev));
>  	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M;
>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	/*
> +	 * Advertise multi-planar capabilities. The driver supports only
> +	 * single-planar pixel format at this moment so all the buffers will
> +	 * have only one plane.
> +	 */
> +	cap->capabilities |= V4L2_CAP_VIDEO_M2M_MPLANE |
> +			     V4L2_CAP_VIDEO_CAPTURE_MPLANE |
> +			     V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> +
>  	return 0;
>  }
>  
> @@ -1430,12 +1439,10 @@ static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
>  static struct s5p_jpeg_q_data *get_q_data(struct s5p_jpeg_ctx *ctx,
>  					  enum v4l2_buf_type type)
>  {
> -	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +	if (V4L2_TYPE_IS_OUTPUT(type))
>  		return &ctx->out_q;
> -	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return &ctx->cap_q;
>  
> -	return NULL;
> +	return &ctx->cap_q;
>  }
>  
>  static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> @@ -1449,16 +1456,14 @@ static int s5p_jpeg_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  	if (!vq)
>  		return -EINVAL;
>  
> -	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	if (!V4L2_TYPE_IS_OUTPUT(f->type) &&
>  	    ct->mode == S5P_JPEG_DECODE && !ct->hdr_parsed)
>  		return -EINVAL;
>  	q_data = get_q_data(ct, f->type);
>  	BUG_ON(q_data == NULL);
>  
> -	if ((f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> -	     ct->mode == S5P_JPEG_ENCODE) ||
> -	    (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> -	     ct->mode == S5P_JPEG_DECODE)) {
> +	if ((!V4L2_TYPE_IS_OUTPUT(f->type) && ct->mode == S5P_JPEG_ENCODE) ||
> +	    (V4L2_TYPE_IS_OUTPUT(f->type) && ct->mode == S5P_JPEG_DECODE)) {
>  		pix->width = 0;
>  		pix->height = 0;
>  	} else {
> @@ -1715,6 +1720,8 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
>  
>  	q_data = get_q_data(ct, f->type);
>  	BUG_ON(q_data == NULL);
> +	vq->type = f->type;
> +	q_data->type = f->type;
>  
>  	if (vb2_is_busy(vq)) {
>  		v4l2_err(&ct->jpeg->v4l2_dev, "%s queue busy\n", __func__);
> @@ -1919,7 +1926,9 @@ static int s5p_jpeg_g_selection(struct file *file, void *priv,
>  	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
>  
>  	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT &&
> -	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
> +	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>  		return -EINVAL;
>  
>  	/* For JPEG blob active == default == bounds */
> @@ -1957,7 +1966,8 @@ static int s5p_jpeg_s_selection(struct file *file, void *fh,
>  	struct v4l2_rect *rect = &s->r;
>  	int ret = -EINVAL;
>  
> -	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
> +	    s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>  		return -EINVAL;
>  
>  	if (s->target == V4L2_SEL_TGT_COMPOSE) {
> @@ -2118,6 +2128,107 @@ static int s5p_jpeg_controls_create(struct s5p_jpeg_ctx *ctx)
>  	return ret;
>  }
>  
> +static void v4l2_format_pixmp_to_pix(struct v4l2_format *fmt_pix_mp,
> +				     struct v4l2_format *fmt_pix) {
> +	struct v4l2_pix_format *pix = &fmt_pix->fmt.pix;
> +	struct v4l2_pix_format_mplane *pix_mp = &fmt_pix_mp->fmt.pix_mp;
> +
> +	fmt_pix->type = fmt_pix_mp->type;
> +	pix->width = pix_mp->width;
> +	pix->height = pix_mp->height;
> +	pix->pixelformat = pix_mp->pixelformat;
> +	pix->field = pix_mp->field;
> +	pix->colorspace = pix_mp->colorspace;
> +	pix->bytesperline = pix_mp->plane_fmt[0].bytesperline;
> +	pix->sizeimage = pix_mp->plane_fmt[0].sizeimage;
> +}
> +
> +static void v4l2_format_pixmp_from_pix(struct v4l2_format *fmt_pix_mp,
> +				       struct v4l2_format *fmt_pix) {
> +	struct v4l2_pix_format *pix = &fmt_pix->fmt.pix;
> +	struct v4l2_pix_format_mplane *pix_mp = &fmt_pix_mp->fmt.pix_mp;
> +
> +	fmt_pix_mp->type = fmt_pix->type;
> +	pix_mp->width = pix->width;
> +	pix_mp->height = pix->height;
> +	pix_mp->pixelformat = pix->pixelformat;
> +	pix_mp->field = pix->field;
> +	pix_mp->colorspace = pix->colorspace;
> +	pix_mp->plane_fmt[0].bytesperline = pix->bytesperline;
> +	pix_mp->plane_fmt[0].sizeimage = pix->sizeimage;
> +	pix_mp->num_planes = 1;
> +}
> +
> +static int s5p_jpeg_g_fmt_mplane(struct file *file, void *priv,
> +				 struct v4l2_format *f)
> +{
> +	struct v4l2_format tmp;
> +	int ret;
> +
> +	memset(&tmp, 0, sizeof(tmp));
> +	v4l2_format_pixmp_to_pix(f, &tmp);
> +	ret = s5p_jpeg_g_fmt(file, priv, &tmp);
> +	v4l2_format_pixmp_from_pix(f, &tmp);
> +
> +	return ret;
> +}
> +
> +static int s5p_jpeg_try_fmt_vid_cap_mplane(struct file *file, void *priv,
> +					   struct v4l2_format *f)
> +{
> +	struct v4l2_format tmp;
> +	int ret;
> +
> +	memset(&tmp, 0, sizeof(tmp));
> +	v4l2_format_pixmp_to_pix(f, &tmp);
> +	ret = s5p_jpeg_try_fmt_vid_cap(file, priv, &tmp);
> +	v4l2_format_pixmp_from_pix(f, &tmp);
> +
> +	return ret;
> +}
> +
> +static int s5p_jpeg_try_fmt_vid_out_mplane(struct file *file, void *priv,
> +					   struct v4l2_format *f)
> +{
> +	struct v4l2_format tmp;
> +	int ret;
> +
> +	memset(&tmp, 0, sizeof(tmp));
> +	v4l2_format_pixmp_to_pix(f, &tmp);
> +	ret = s5p_jpeg_try_fmt_vid_out(file, priv, &tmp);
> +	v4l2_format_pixmp_from_pix(f, &tmp);
> +
> +	return ret;
> +}
> +
> +static int s5p_jpeg_s_fmt_vid_cap_mplane(struct file *file, void *priv,
> +					 struct v4l2_format *f)
> +{
> +	struct v4l2_format tmp;
> +	int ret;
> +
> +	memset(&tmp, 0, sizeof(tmp));
> +	v4l2_format_pixmp_to_pix(f, &tmp);
> +	ret = s5p_jpeg_s_fmt_vid_cap(file, priv, &tmp);
> +	v4l2_format_pixmp_from_pix(f, &tmp);
> +
> +	return ret;
> +}
> +
> +static int s5p_jpeg_s_fmt_vid_out_mplane(struct file *file, void *priv,
> +					 struct v4l2_format *f)
> +{
> +	struct v4l2_format tmp;
> +	int ret;
> +
> +	memset(&tmp, 0, sizeof(tmp));
> +	v4l2_format_pixmp_to_pix(f, &tmp);
> +	ret = s5p_jpeg_s_fmt_vid_out(file, priv, &tmp);
> +	v4l2_format_pixmp_from_pix(f, &tmp);
> +
> +	return ret;
> +}
> +
>  static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
>  	.vidioc_querycap		= s5p_jpeg_querycap,
>  
> @@ -2133,6 +2244,18 @@ static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
>  	.vidioc_s_fmt_vid_cap		= s5p_jpeg_s_fmt_vid_cap,
>  	.vidioc_s_fmt_vid_out		= s5p_jpeg_s_fmt_vid_out,
>  
> +	.vidioc_enum_fmt_vid_cap_mplane	= s5p_jpeg_enum_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_out_mplane	= s5p_jpeg_enum_fmt_vid_out,
> +
> +	.vidioc_g_fmt_vid_cap_mplane	= s5p_jpeg_g_fmt_mplane,
> +	.vidioc_g_fmt_vid_out_mplane	= s5p_jpeg_g_fmt_mplane,
> +
> +	.vidioc_try_fmt_vid_cap_mplane	= s5p_jpeg_try_fmt_vid_cap_mplane,
> +	.vidioc_try_fmt_vid_out_mplane	= s5p_jpeg_try_fmt_vid_out_mplane,
> +
> +	.vidioc_s_fmt_vid_cap_mplane	= s5p_jpeg_s_fmt_vid_cap_mplane,
> +	.vidioc_s_fmt_vid_out_mplane	= s5p_jpeg_s_fmt_vid_out_mplane,
> +
>  	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
>  	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
>  	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
> @@ -2648,7 +2771,7 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>  	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
>  
>  	if (ctx->mode == S5P_JPEG_DECODE &&
> -	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +	    vb->vb2_queue->type == ctx->out_q.type) {
>  		static const struct v4l2_event ev_src_ch = {
>  			.type = V4L2_EVENT_SOURCE_CHANGE,
>  			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
> @@ -2657,8 +2780,7 @@ static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
>  		u32 ori_w;
>  		u32 ori_h;
>  
> -		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
> -					 V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		dst_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, ctx->cap_q.type);
>  		ori_w = ctx->out_q.w;
>  		ori_h = ctx->out_q.h;
>  
> @@ -2708,7 +2830,7 @@ static void s5p_jpeg_stop_streaming(struct vb2_queue *q)
>  	 * subsampling. Update capture queue when the stream is off.
>  	 */
>  	if (ctx->state == JPEGCTX_RESOLUTION_CHANGE &&
> -	    q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +	    !V4L2_TYPE_IS_OUTPUT(q->type)) {
>  		s5p_jpeg_set_capture_queue_data(ctx);
>  		ctx->state = JPEGCTX_RUNNING;
>  	}
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.h b/drivers/media/platform/s5p-jpeg/jpeg-core.h
> index 9aa26bd..302a297 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.h
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.h
> @@ -196,6 +196,7 @@ struct s5p_jpeg_marker {
>   * @sof_len:	SOF0 marker's payload length (without length field itself)
>   * @components:	number of image components
>   * @size:	image buffer size in bytes
> + * @type:	buffer type of the queue (enum v4l2_buf_type)
>   */
>  struct s5p_jpeg_q_data {
>  	struct s5p_jpeg_fmt	*fmt;
> @@ -208,6 +209,7 @@ struct s5p_jpeg_q_data {
>  	u32			sof_len;
>  	u32			components;
>  	u32			size;
> +	u32			type;
>  };
>  
>  /**
> 

-- 
Best regards,
Jacek Anaszewski
