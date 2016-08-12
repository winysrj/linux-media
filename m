Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:45916 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbcHLLpv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 07:45:51 -0400
Subject: Re: [PATCH v4] vcodec: mediatek: Add g/s_selection support for V4L2
 Encoder
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1470812407-12498-1-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <bc57b594-9998-70c8-27b9-98c7996cc6ab@cisco.com>
Date: Fri, 12 Aug 2016 13:45:42 +0200
MIME-Version: 1.0
In-Reply-To: <1470812407-12498-1-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/10/2016 09:00 AM, Tiffany Lin wrote:

No commit log?

This v4 patch got lost on the mailinglist (some vger,kernel.org mishap), so a new
version would be welcome anyway.

The visible_height change should really be moved to a separate patch as it is
independent from the part that adds g/s_selection.

Regards,

	Hans

> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
> v4:
> - do not return -ERANGE and just select a rectangle that works with the
>   hardware and is closest to the requested rectangle
> - refine v3 note about remove visible_height modification in s_fmt_out
> v3:
> - add v4l2_s_selection to check constraint flags
> - remove visible_height modification in s_fmt_out, it will make v4l2-compliance
>   test Cropping fail becuase visible_height larger than coded_height.
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   77 +++++++++++++++++---
>  1 file changed, 67 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> index 3ed3f2d..21b4e57 100644
> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> @@ -487,7 +487,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
>  	struct mtk_q_data *q_data;
>  	int ret, i;
>  	struct mtk_video_fmt *fmt;
> -	unsigned int pitch_w_div16;
>  	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
>
>  	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> @@ -530,15 +529,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
>  	q_data->coded_width = f->fmt.pix_mp.width;
>  	q_data->coded_height = f->fmt.pix_mp.height;
>
> -	pitch_w_div16 = DIV_ROUND_UP(q_data->visible_width, 16);
> -	if (pitch_w_div16 % 8 != 0) {
> -		/* Adjust returned width/height, so application could correctly
> -		 * allocate hw required memory
> -		 */
> -		q_data->visible_height += 32;
> -		vidioc_try_fmt(f, q_data->fmt);
> -	}
> -
>  	q_data->field = f->fmt.pix_mp.field;
>  	ctx->colorspace = f->fmt.pix_mp.colorspace;
>  	ctx->ycbcr_enc = f->fmt.pix_mp.ycbcr_enc;
> @@ -631,6 +621,70 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
>  	return vidioc_try_fmt(f, fmt);
>  }
>
> +static int vidioc_venc_g_selection(struct file *file, void *priv,
> +				     struct v4l2_selection *s)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct mtk_q_data *q_data;
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;
> +
> +	q_data = mtk_venc_get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> +		s->r.top = 0;
> +		s->r.left = 0;
> +		s->r.width = q_data->coded_width;
> +		s->r.height = q_data->coded_height;
> +		break;
> +	case V4L2_SEL_TGT_CROP:
> +		s->r.top = 0;
> +		s->r.left = 0;
> +		s->r.width = q_data->visible_width;
> +		s->r.height = q_data->visible_height;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_venc_s_selection(struct file *file, void *priv,
> +				     struct v4l2_selection *s)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct mtk_q_data *q_data;
> +	int err;
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> +		return -EINVAL;
> +
> +	q_data = mtk_venc_get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		/* Only support crop from (0,0) */
> +		s->r.top = 0;
> +		s->r.left = 0;
> +		s->r.width = min(s->r.width, q_data->coded_width);
> +		s->r.height = min(s->r.height, q_data->coded_height);
> +		q_data->visible_width = s->r.width;
> +		q_data->visible_height = s->r.height;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static int vidioc_venc_qbuf(struct file *file, void *priv,
>  			    struct v4l2_buffer *buf)
>  {
> @@ -689,6 +743,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
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

