Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:37815 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbcHAImn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 04:42:43 -0400
Subject: Re: [PATCH v2] vcodec: mediatek: Add g/s_selection support for V4L2
 Encoder
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
References: <1469785858-44115-1-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7f94c88c-0671-9e08-3501-e1030a545f14@xs4all.nl>
Date: Mon, 1 Aug 2016 10:39:38 +0200
MIME-Version: 1.0
In-Reply-To: <1469785858-44115-1-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

On 07/29/2016 11:50 AM, Tiffany Lin wrote:
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> ---
>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   83 ++++++++++++++++++--
>  1 file changed, 78 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> index 3ed3f2d..8f09dd3 100644
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
> @@ -530,13 +529,12 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
>  	q_data->coded_width = f->fmt.pix_mp.width;
>  	q_data->coded_height = f->fmt.pix_mp.height;
>  
> -	pitch_w_div16 = DIV_ROUND_UP(q_data->visible_width, 16);
> -	if (pitch_w_div16 % 8 != 0) {
> +	if (q_data->visible_width % 16) {
>  		/* Adjust returned width/height, so application could correctly
>  		 * allocate hw required memory
>  		 */
> -		q_data->visible_height += 32;
> -		vidioc_try_fmt(f, q_data->fmt);
> +		q_data->coded_height += 32;
> +		f->fmt.pix_mp.height += 32;
>  	}
>  
>  	q_data->field = f->fmt.pix_mp.field;
> @@ -631,6 +629,78 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
>  	return vidioc_try_fmt(f, fmt);
>  }
>  
> +static int vidioc_venc_g_selection(struct file *file, void *priv,
> +				     struct v4l2_selection *s)
> +{
> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> +	struct mtk_q_data *q_data;
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		mtk_v4l2_err("Invalid s->type = %d", s->type);

This is not an error you want to log, just drop this. You can always get detailed
debugging by running 'echo 2 >/sys/class/video4linux/videoX/dev_debug'.

> +		return -EINVAL;
> +	}
> +
> +	q_data = mtk_venc_get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	/* crop means compose for output devices */

Drop this comment. That's only true for the old G/S_CROP ioctls.
For the selection API crop is really crop.

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
> +		mtk_v4l2_err("Invalid s->target = %d", s->target);

Same here: just drop this line.

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
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		mtk_v4l2_err("Invalid s->type = %d", s->type);

Ditto.

> +		return -EINVAL;
> +	}
> +
> +	q_data = mtk_venc_get_q_data(ctx, s->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_CROP:
> +		/* Only support crop from (0,0) */
> +		if ((s->r.width > q_data->coded_width) ||
> +			(s->r.height > q_data->coded_height)) {
> +			return -ERANGE;
> +		}

This isn't correct, instead just correct the width and height to the
max possible value.

> +		s->r.top = 0;
> +		s->r.left = 0;
> +		q_data->visible_width = s->r.width;
> +		q_data->visible_height = s->r.height;
> +		break;
> +	default:
> +		mtk_v4l2_err("Invalid s->target = %d", s->target);

Ditto.

> +		return -EINVAL;
> +	}
> +	return 0;
> +}

Note that this function doesn't check the constraint flags in s->r. However, this
is a generic problem that I see often. I've written a patch that adds a helper
function that can check the new rectangle against the original rectangle and
constraint flags and returns -ERANGE if it doesn't fit.

That should simplify this code to:

struct v4l2_rect r = s->r;
int err;

...

case V4L2_SEL_TGT_CROP:
	r.left = 0;
	r.top = 0;
	r.width = min(r.width, q_data->coded_width);
	r.height = min(r.height, q_data->coded_height);
	err = v4l2_s_selection(s, &r);
	if (err)
		return err;
	q_data->visible_width = s->r.width;
	q_data->visible_height = s->r.height;
	break;

Please test that patch and fold it into your v3 patch series.
	
> +
>  static int vidioc_venc_qbuf(struct file *file, void *priv,
>  			    struct v4l2_buffer *buf)
>  {
> @@ -689,6 +759,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
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

Regards,

	Hans
