Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:39138 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756374AbcHEDNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2016 23:13:17 -0400
Message-ID: <1470366751.10352.15.camel@mtksdaap41>
Subject: Re: [PATCH v3] vcodec: mediatek: Add g/s_selection support for V4L2
 Encoder
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>
Date: Fri, 5 Aug 2016 11:12:31 +0800
In-Reply-To: <f84d1d4c-1794-26f1-f0e2-586dc9dfc687@xs4all.nl>
References: <1470305295-27785-1-git-send-email-tiffany.lin@mediatek.com>
	 <f84d1d4c-1794-26f1-f0e2-586dc9dfc687@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, 2016-08-04 at 15:00 +0200, Hans Verkuil wrote:
> 
> On 08/04/2016 12:08 PM, Tiffany Lin wrote:
> > This patch add g/s_selection support for MT8173 v4l2 encoder
> > 
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> > v3:
> > - add v4l2_s_selection to check constraint flags
> > - remove visible_height modification in s_fmt_out
> 
> Is this selection-related, or is this an unrelated bug fix?
> If it is the latter, then please split it up as a separate patch.
> 
> In both cases the commit log should explain a bit more why
> this s_fmt_out change is needed.
> 
This is a bug I found when I add g_selection.
It will make visible_height out of coded_height and compliance test will
fail if not include this part of modification.

The original code here is for that user space could get buffer size HW
required by using coded_width * coded_height.
But the original code here adjust visible_height and not returned as
f->fmt.pix_mp.height, it's a bug.
But if it update coded_height here, q_data->coded_height += 32;, it will
fail in s_fmt compliance test that s_fmt(g_fmt) != g_fmt.
So I decided to drop this.
User space should use sizeimage to get buffer size HW required and
coded_width/coded_height just alignment width/height that HW required.

best regards,
Tiffany


> > ---
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   81 +++++++++++++++++---
> >  1 file changed, 71 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > index 3ed3f2d..c4b8e00 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > @@ -487,7 +487,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
> >  	struct mtk_q_data *q_data;
> >  	int ret, i;
> >  	struct mtk_video_fmt *fmt;
> > -	unsigned int pitch_w_div16;
> >  	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> >  
> >  	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> > @@ -530,15 +529,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
> >  	q_data->coded_width = f->fmt.pix_mp.width;
> >  	q_data->coded_height = f->fmt.pix_mp.height;
> >  
> > -	pitch_w_div16 = DIV_ROUND_UP(q_data->visible_width, 16);
> > -	if (pitch_w_div16 % 8 != 0) {
> > -		/* Adjust returned width/height, so application could correctly
> > -		 * allocate hw required memory
> > -		 */
> > -		q_data->visible_height += 32;
> > -		vidioc_try_fmt(f, q_data->fmt);
> > -	}
> > -
> >  	q_data->field = f->fmt.pix_mp.field;
> >  	ctx->colorspace = f->fmt.pix_mp.colorspace;
> >  	ctx->ycbcr_enc = f->fmt.pix_mp.ycbcr_enc;
> > @@ -631,6 +621,74 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
> >  	return vidioc_try_fmt(f, fmt);
> >  }
> >  
> > +static int vidioc_venc_g_selection(struct file *file, void *priv,
> > +				     struct v4l2_selection *s)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	struct mtk_q_data *q_data;
> > +
> > +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > +		return -EINVAL;
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, s->type);
> > +	if (!q_data)
> > +		return -EINVAL;
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +		s->r.top = 0;
> > +		s->r.left = 0;
> > +		s->r.width = q_data->coded_width;
> > +		s->r.height = q_data->coded_height;
> > +		break;
> > +	case V4L2_SEL_TGT_CROP:
> > +		s->r.top = 0;
> > +		s->r.left = 0;
> > +		s->r.width = q_data->visible_width;
> > +		s->r.height = q_data->visible_height;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_venc_s_selection(struct file *file, void *priv,
> > +				     struct v4l2_selection *s)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	struct mtk_q_data *q_data;
> > +	struct v4l2_rect r = s->r;
> > +	int err;
> > +
> > +	if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > +		return -EINVAL;
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, s->type);
> > +	if (!q_data)
> > +		return -EINVAL;
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_CROP:
> > +		/* Only support crop from (0,0) */
> > +		s->r.top = 0;
> > +		s->r.left = 0;
> > +		r.width = min(r.width, q_data->coded_width);
> > +		r.height = min(r.height, q_data->coded_height);
> > +		err = v4l2_s_selection(s, &r);
> > +		if (err)
> > +			return err;
> > +		q_data->visible_width = s->r.width;
> > +		q_data->visible_height = s->r.height;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static int vidioc_venc_qbuf(struct file *file, void *priv,
> >  			    struct v4l2_buffer *buf)
> >  {
> > @@ -689,6 +747,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
> >  
> >  	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
> >  	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
> > +
> > +	.vidioc_g_selection		= vidioc_venc_g_selection,
> > +	.vidioc_s_selection		= vidioc_venc_s_selection,
> >  };
> >  
> >  static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
> > 
> 
> The selection code looks good!
> 
> 	Hans


