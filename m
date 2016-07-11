Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:5674 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752160AbcGKIKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 04:10:00 -0400
Message-ID: <1468224591.2462.6.camel@mtksdaap41>
Subject: Re: [PATCH] vcodec: mediatek: Add g/s_selection support for V4L2
 Encoder
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>
Date: Mon, 11 Jul 2016 16:09:51 +0800
In-Reply-To: <4ca82842-968d-a5e2-587d-752c71713607@xs4all.nl>
References: <1464594768-1993-1-git-send-email-tiffany.lin@mediatek.com>
	 <4ca82842-968d-a5e2-587d-752c71713607@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2016-07-11 at 06:32 +0200, Hans Verkuil wrote:
> Hi Tiffany,
> 
> My apologies for the delay, but here is my review at last:
> 
> On 05/30/2016 09:52 AM, Tiffany Lin wrote:
> > This patch add g/s_selection support for MT8173
> > 
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   74 ++++++++++++++++++++
> >  1 file changed, 74 insertions(+)
> > 
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > index 6e72d73..23ef9a1 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > @@ -630,6 +630,77 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
> >  	return vidioc_try_fmt(f, fmt);
> >  }
> >  
> > +static int vidioc_venc_g_selection(struct file *file, void *priv,
> > +				     struct v4l2_selection *s)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	struct mtk_q_data *q_data;
> > +
> > +	/* crop means compose for output devices */
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +	case V4L2_SEL_TGT_CROP:
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +	case V4L2_SEL_TGT_COMPOSE:
> > +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +			mtk_v4l2_err("Invalid s->type = %d", s->type);
> > +			return -EINVAL;
> > +		}
> > +		break;
> > +	default:
> > +		mtk_v4l2_err("Invalid s->target = %d", s->target);
> > +		return -EINVAL;
> > +	}
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, s->type);
> > +	if (!q_data)
> > +		return -EINVAL;
> > +
> > +	s->r.top = 0;
> > +	s->r.left = 0;
> > +	s->r.width = q_data->visible_width;
> > +	s->r.height = q_data->visible_height;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_venc_s_selection(struct file *file, void *priv,
> > +				     struct v4l2_selection *s)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	struct mtk_q_data *q_data;
> > +
> > +	switch (s->target) {
> > +	case V4L2_SEL_TGT_CROP_DEFAULT:
> > +	case V4L2_SEL_TGT_CROP_BOUNDS:
> > +	case V4L2_SEL_TGT_CROP:
> > +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > +	case V4L2_SEL_TGT_COMPOSE:
> > +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> > +			mtk_v4l2_err("Invalid s->type = %d", s->type);
> > +			return -EINVAL;
> > +		}
> > +		break;
> > +	default:
> > +		mtk_v4l2_err("Invalid s->target = %d", s->target);
> > +		return -EINVAL;
> > +	}
> > +
> > +	q_data = mtk_venc_get_q_data(ctx, s->type);
> > +	if (!q_data)
> > +		return -EINVAL;
> > +
> > +	s->r.top = 0;
> > +	s->r.left = 0;
> > +	q_data->visible_width = s->r.width;
> > +	q_data->visible_height = s->r.height;
> 
> This makes no sense.
> 
> See this page:
> 
> https://hverkuil.home.xs4all.nl/spec/media.html#selection-api
> 
> For the video output direction (memory -> HW encoder) the data source is
> the memory, the data sink is the HW encoder. For the video capture direction
> (HW encoder -> memory) the data source is the HW encoder and the data sink
> is the memory.
> 
> Usually for m2m devices the video output direction may support cropping and
> the video capture direction may support composing.
> 
> It's not clear what you intend here, especially since you set left and right
> to 0. That's not what the selection operation is supposed to do.
> 

We only support simple crop, but as you mentioned we need to use
g/s_selection not g/s_crop.
This provide our user space application could get/set encode region to
driver and encode region should always start from (0,0) to (width,
height).
That's why we always set top and left to 0.


best regards,
Tiffany

> Regards,
> 
> 	Hans
> 
> > +
> > +	return 0;
> > +}
> > +
> >  static int vidioc_venc_qbuf(struct file *file, void *priv,
> >  			    struct v4l2_buffer *buf)
> >  {
> > @@ -688,6 +759,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
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


