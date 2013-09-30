Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3435 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3I3Luu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 07:50:50 -0400
Message-ID: <5249657E.1010607@xs4all.nl>
Date: Mon, 30 Sep 2013 13:50:22 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: Re: [PATCH 07/10] [media] coda: prefix v4l2_ioctl_ops with coda_
References: <1379582036-4840-1-git-send-email-p.zabel@pengutronix.de> <1379582036-4840-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1379582036-4840-8-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2013 11:13 AM, Philipp Zabel wrote:
> Moving the ioctl handler callbacks into the coda namespace helps
> tremendously to make sense of backtraces.

I like the idea, but I would just use the coda_ prefix, not coda_vidioc_. In general
the prefix is either vidioc_ or the name of the driver, not both.

Regards,

	Hans

> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 123 +++++++++++++++++++++---------------------
>  1 file changed, 63 insertions(+), 60 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 4f038c2..9091664 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -412,8 +412,8 @@ static char *coda_product_name(int product)
>  /*
>   * V4L2 ioctl() operations.
>   */
> -static int vidioc_querycap(struct file *file, void *priv,
> -			   struct v4l2_capability *cap)
> +static int coda_vidioc_querycap(struct file *file, void *priv,
> +				struct v4l2_capability *cap)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  
> @@ -484,8 +484,8 @@ static int enum_fmt(void *priv, struct v4l2_fmtdesc *f,
>  	return -EINVAL;
>  }
>  
> -static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> -				   struct v4l2_fmtdesc *f)
> +static int coda_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> +					struct v4l2_fmtdesc *f)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	struct vb2_queue *src_vq;
> @@ -503,13 +503,14 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
>  	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_CAPTURE, 0);
>  }
>  
> -static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
> -				   struct v4l2_fmtdesc *f)
> +static int coda_vidioc_enum_fmt_vid_out(struct file *file, void *priv,
> +					struct v4l2_fmtdesc *f)
>  {
>  	return enum_fmt(priv, f, V4L2_BUF_TYPE_VIDEO_OUTPUT, 0);
>  }
>  
> -static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +static int coda_vidioc_g_fmt(struct file *file, void *priv,
> +			     struct v4l2_format *f)
>  {
>  	struct vb2_queue *vq;
>  	struct coda_q_data *q_data;
> @@ -536,7 +537,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  	return 0;
>  }
>  
> -static int vidioc_try_fmt(struct coda_codec *codec, struct v4l2_format *f)
> +static int coda_vidioc_try_fmt(struct coda_codec *codec, struct v4l2_format *f)
>  {
>  	unsigned int max_w, max_h;
>  	enum v4l2_field field;
> @@ -575,8 +576,8 @@ static int vidioc_try_fmt(struct coda_codec *codec, struct v4l2_format *f)
>  	return 0;
>  }
>  
> -static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> -				  struct v4l2_format *f)
> +static int coda_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +				       struct v4l2_format *f)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	struct coda_codec *codec;
> @@ -604,7 +605,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  
>  	f->fmt.pix.colorspace = ctx->colorspace;
>  
> -	ret = vidioc_try_fmt(codec, f);
> +	ret = coda_vidioc_try_fmt(codec, f);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -620,8 +621,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> -				  struct v4l2_format *f)
> +static int coda_vidioc_try_fmt_vid_out(struct file *file, void *priv,
> +				       struct v4l2_format *f)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	struct coda_codec *codec;
> @@ -633,10 +634,10 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
>  	if (!f->fmt.pix.colorspace)
>  		f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
>  
> -	return vidioc_try_fmt(codec, f);
> +	return coda_vidioc_try_fmt(codec, f);
>  }
>  
> -static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
> +static int coda_vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
>  {
>  	struct coda_q_data *q_data;
>  	struct vb2_queue *vq;
> @@ -666,61 +667,62 @@ static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
>  	return 0;
>  }
>  
> -static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> -				struct v4l2_format *f)
> +static int coda_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> +				     struct v4l2_format *f)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	int ret;
>  
> -	ret = vidioc_try_fmt_vid_cap(file, priv, f);
> +	ret = coda_vidioc_try_fmt_vid_cap(file, priv, f);
>  	if (ret)
>  		return ret;
>  
> -	return vidioc_s_fmt(ctx, f);
> +	return coda_vidioc_s_fmt(ctx, f);
>  }
>  
> -static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
> -				struct v4l2_format *f)
> +static int coda_vidioc_s_fmt_vid_out(struct file *file, void *priv,
> +				     struct v4l2_format *f)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	int ret;
>  
> -	ret = vidioc_try_fmt_vid_out(file, priv, f);
> +	ret = coda_vidioc_try_fmt_vid_out(file, priv, f);
>  	if (ret)
>  		return ret;
>  
> -	ret = vidioc_s_fmt(ctx, f);
> +	ret = coda_vidioc_s_fmt(ctx, f);
>  	if (ret)
>  		ctx->colorspace = f->fmt.pix.colorspace;
>  
>  	return ret;
>  }
>  
> -static int vidioc_reqbufs(struct file *file, void *priv,
> -			  struct v4l2_requestbuffers *reqbufs)
> +static int coda_vidioc_reqbufs(struct file *file, void *priv,
> +			       struct v4l2_requestbuffers *reqbufs)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  
>  	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
>  }
>  
> -static int vidioc_querybuf(struct file *file, void *priv,
> -			   struct v4l2_buffer *buf)
> +static int coda_vidioc_querybuf(struct file *file, void *priv,
> +				struct v4l2_buffer *buf)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  
>  	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
>  }
>  
> -static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +static int coda_vidioc_qbuf(struct file *file, void *priv,
> +			    struct v4l2_buffer *buf)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  
>  	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
>  }
>  
> -static int vidioc_expbuf(struct file *file, void *priv,
> -			 struct v4l2_exportbuffer *eb)
> +static int coda_vidioc_expbuf(struct file *file, void *priv,
> +			      struct v4l2_exportbuffer *eb)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  
> @@ -738,7 +740,8 @@ static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
>  		(buf->sequence == (ctx->qsequence - 1)));
>  }
>  
> -static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +static int coda_vidioc_dqbuf(struct file *file, void *priv,
> +			     struct v4l2_buffer *buf)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	int ret;
> @@ -758,24 +761,24 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
>  	return ret;
>  }
>  
> -static int vidioc_create_bufs(struct file *file, void *priv,
> -			      struct v4l2_create_buffers *create)
> +static int coda_vidioc_create_bufs(struct file *file, void *priv,
> +				   struct v4l2_create_buffers *create)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  
>  	return v4l2_m2m_create_bufs(file, ctx->m2m_ctx, create);
>  }
>  
> -static int vidioc_streamon(struct file *file, void *priv,
> -			   enum v4l2_buf_type type)
> +static int coda_vidioc_streamon(struct file *file, void *priv,
> +				enum v4l2_buf_type type)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  
>  	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
>  }
>  
> -static int vidioc_streamoff(struct file *file, void *priv,
> -			    enum v4l2_buf_type type)
> +static int coda_vidioc_streamoff(struct file *file, void *priv,
> +				 enum v4l2_buf_type type)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(priv);
>  	int ret;
> @@ -792,8 +795,8 @@ static int vidioc_streamoff(struct file *file, void *priv,
>  	return ret;
>  }
>  
> -static int vidioc_decoder_cmd(struct file *file, void *fh,
> -			      struct v4l2_decoder_cmd *dc)
> +static int coda_vidioc_decoder_cmd(struct file *file, void *fh,
> +				   struct v4l2_decoder_cmd *dc)
>  {
>  	struct coda_ctx *ctx = fh_to_ctx(fh);
>  
> @@ -816,8 +819,8 @@ static int vidioc_decoder_cmd(struct file *file, void *fh,
>  	return 0;
>  }
>  
> -static int vidioc_subscribe_event(struct v4l2_fh *fh,
> -				  const struct v4l2_event_subscription *sub)
> +static int coda_vidioc_subscribe_event(struct v4l2_fh *fh,
> +				       const struct v4l2_event_subscription *sub)
>  {
>  	switch (sub->type) {
>  	case V4L2_EVENT_EOS:
> @@ -828,32 +831,32 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
>  }
>  
>  static const struct v4l2_ioctl_ops coda_ioctl_ops = {
> -	.vidioc_querycap	= vidioc_querycap,
> +	.vidioc_querycap	= coda_vidioc_querycap,
>  
> -	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
> -	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt,
> -	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
> -	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap = coda_vidioc_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap	= coda_vidioc_g_fmt,
> +	.vidioc_try_fmt_vid_cap	= coda_vidioc_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap	= coda_vidioc_s_fmt_vid_cap,
>  
> -	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
> -	.vidioc_g_fmt_vid_out	= vidioc_g_fmt,
> -	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
> -	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
> +	.vidioc_enum_fmt_vid_out = coda_vidioc_enum_fmt_vid_out,
> +	.vidioc_g_fmt_vid_out	= coda_vidioc_g_fmt,
> +	.vidioc_try_fmt_vid_out	= coda_vidioc_try_fmt_vid_out,
> +	.vidioc_s_fmt_vid_out	= coda_vidioc_s_fmt_vid_out,
>  
> -	.vidioc_reqbufs		= vidioc_reqbufs,
> -	.vidioc_querybuf	= vidioc_querybuf,
> +	.vidioc_reqbufs		= coda_vidioc_reqbufs,
> +	.vidioc_querybuf	= coda_vidioc_querybuf,
>  
> -	.vidioc_qbuf		= vidioc_qbuf,
> -	.vidioc_expbuf		= vidioc_expbuf,
> -	.vidioc_dqbuf		= vidioc_dqbuf,
> -	.vidioc_create_bufs	= vidioc_create_bufs,
> +	.vidioc_qbuf		= coda_vidioc_qbuf,
> +	.vidioc_expbuf		= coda_vidioc_expbuf,
> +	.vidioc_dqbuf		= coda_vidioc_dqbuf,
> +	.vidioc_create_bufs	= coda_vidioc_create_bufs,
>  
> -	.vidioc_streamon	= vidioc_streamon,
> -	.vidioc_streamoff	= vidioc_streamoff,
> +	.vidioc_streamon	= coda_vidioc_streamon,
> +	.vidioc_streamoff	= coda_vidioc_streamoff,
>  
> -	.vidioc_decoder_cmd	= vidioc_decoder_cmd,
> +	.vidioc_decoder_cmd	= coda_vidioc_decoder_cmd,
>  
> -	.vidioc_subscribe_event = vidioc_subscribe_event,
> +	.vidioc_subscribe_event = coda_vidioc_subscribe_event,
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };
>  
> 

