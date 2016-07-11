Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:49857 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbcGKEcS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 00:32:18 -0400
Subject: Re: [PATCH] vcodec: mediatek: Add g/s_selection support for V4L2
 Encoder
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1464594768-1993-1-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4ca82842-968d-a5e2-587d-752c71713607@xs4all.nl>
Date: Mon, 11 Jul 2016 06:32:10 +0200
MIME-Version: 1.0
In-Reply-To: <1464594768-1993-1-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

My apologies for the delay, but here is my review at last:

On 05/30/2016 09:52 AM, Tiffany Lin wrote:
> This patch add g/s_selection support for MT8173
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   74 ++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> index 6e72d73..23ef9a1 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> @@ -630,6 +630,77 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
>  	return vidioc_try_fmt(f, fmt);
>  }
>  
> +static int vidioc_venc_g_selection(struct file *file, void *priv,
> +				     struct v4l2_selection *s)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct mtk_q_data *q_data;
> +
> +	/* crop means compose for output devices */
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE:
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +			mtk_v4l2_err("Invalid s->type = %d", s->type);
> +			return -EINVAL;
> +		}
> +		break;
> +	default:
> +		mtk_v4l2_err("Invalid s->target = %d", s->target);
> +		return -EINVAL;
> +	}
> +
> +	q_data = mtk_venc_get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	s->r.top = 0;
> +	s->r.left = 0;
> +	s->r.width = q_data->visible_width;
> +	s->r.height = q_data->visible_height;
> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_s_selection(struct file *file, void *priv,
> +				     struct v4l2_selection *s)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct mtk_q_data *q_data;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +	case V4L2_SEL_TGT_CROP:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE:
> +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +			mtk_v4l2_err("Invalid s->type = %d", s->type);
> +			return -EINVAL;
> +		}
> +		break;
> +	default:
> +		mtk_v4l2_err("Invalid s->target = %d", s->target);
> +		return -EINVAL;
> +	}
> +
> +	q_data = mtk_venc_get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	s->r.top = 0;
> +	s->r.left = 0;
> +	q_data->visible_width = s->r.width;
> +	q_data->visible_height = s->r.height;

This makes no sense.

See this page:

https://hverkuil.home.xs4all.nl/spec/media.html#selection-api

For the video output direction (memory -> HW encoder) the data source is
the memory, the data sink is the HW encoder. For the video capture direction
(HW encoder -> memory) the data source is the HW encoder and the data sink
is the memory.

Usually for m2m devices the video output direction may support cropping and
the video capture direction may support composing.

It's not clear what you intend here, especially since you set left and right
to 0. That's not what the selection operation is supposed to do.

Regards,

	Hans

> +
> +	return 0;
> +}
> +
>  static int vidioc_venc_qbuf(struct file *file, void *priv,
>  			    struct v4l2_buffer *buf)
>  {
> @@ -688,6 +759,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
>  
>  	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
>  	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
> +
> +	.vidioc_g_selection		= vidioc_venc_g_selection,
> +	.vidioc_s_selection		= vidioc_venc_s_selection,
>  };
>  
>  static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
> 
