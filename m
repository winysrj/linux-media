Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:60658 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751432AbcGRM2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 08:28:37 -0400
Message-ID: <1468844895.12740.15.camel@mtksdaap41>
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
Date: Mon, 18 Jul 2016 20:28:15 +0800
In-Reply-To: <bb96276a-8e6c-a535-6fd3-fe4327238f65@xs4all.nl>
References: <1464594768-1993-1-git-send-email-tiffany.lin@mediatek.com>
	 <4ca82842-968d-a5e2-587d-752c71713607@xs4all.nl>
	 <1468477674.32454.36.camel@mtksdaap41>
	 <bb96276a-8e6c-a535-6fd3-fe4327238f65@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2016-07-15 at 19:50 +0200, Hans Verkuil wrote:
> On 07/14/2016 08:27 AM, tiffany lin wrote:
> > Hi Hans,
> > 
> > 
> > On Mon, 2016-07-11 at 06:32 +0200, Hans Verkuil wrote:
> >> Hi Tiffany,
> >>
> >> My apologies for the delay, but here is my review at last:
> >>
> >> On 05/30/2016 09:52 AM, Tiffany Lin wrote:
> >>> This patch add g/s_selection support for MT8173
> >>>
> >>> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> >>> ---
> >>>  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   74 ++++++++++++++++++++
> >>>  1 file changed, 74 insertions(+)
> >>>
> >>> diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> >>> index 6e72d73..23ef9a1 100644
> >>> --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> >>> +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> >>> @@ -630,6 +630,77 @@ static int vidioc_try_fmt_vid_out_mplane(struct file *file, void *priv,
> >>>  	return vidioc_try_fmt(f, fmt);
> >>>  }
> >>>  
> >>> +static int vidioc_venc_g_selection(struct file *file, void *priv,
> >>> +				     struct v4l2_selection *s)
> >>> +{
> >>> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> >>> +	struct mtk_q_data *q_data;
> >>> +
> >>> +	/* crop means compose for output devices */
> >>> +	switch (s->target) {
> >>> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> >>> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> >>> +	case V4L2_SEL_TGT_CROP:
> >>> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> >>> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> >>> +	case V4L2_SEL_TGT_COMPOSE:
> >>> +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> >>> +			mtk_v4l2_err("Invalid s->type = %d", s->type);
> >>> +			return -EINVAL;
> >>> +		}
> >>> +		break;
> >>> +	default:
> >>> +		mtk_v4l2_err("Invalid s->target = %d", s->target);
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> >>> +	q_data = mtk_venc_get_q_data(ctx, s->type);
> >>> +	if (!q_data)
> >>> +		return -EINVAL;
> >>> +
> >>> +	s->r.top = 0;
> >>> +	s->r.left = 0;
> >>> +	s->r.width = q_data->visible_width;
> >>> +	s->r.height = q_data->visible_height;
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>> +static int vidioc_venc_s_selection(struct file *file, void *priv,
> >>> +				     struct v4l2_selection *s)
> >>> +{
> >>> +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> >>> +	struct mtk_q_data *q_data;
> >>> +
> >>> +	switch (s->target) {
> >>> +	case V4L2_SEL_TGT_CROP_DEFAULT:
> >>> +	case V4L2_SEL_TGT_CROP_BOUNDS:
> >>> +	case V4L2_SEL_TGT_CROP:
> >>> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> >>> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> >>> +	case V4L2_SEL_TGT_COMPOSE:
> >>> +		if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> >>> +			mtk_v4l2_err("Invalid s->type = %d", s->type);
> >>> +			return -EINVAL;
> >>> +		}
> >>> +		break;
> >>> +	default:
> >>> +		mtk_v4l2_err("Invalid s->target = %d", s->target);
> >>> +		return -EINVAL;
> >>> +	}
> >>> +
> >>> +	q_data = mtk_venc_get_q_data(ctx, s->type);
> >>> +	if (!q_data)
> >>> +		return -EINVAL;
> >>> +
> >>> +	s->r.top = 0;
> >>> +	s->r.left = 0;
> >>> +	q_data->visible_width = s->r.width;
> >>> +	q_data->visible_height = s->r.height;
> >>
> >> This makes no sense.
> >>
> >> See this page:
> >>
> >> https://hverkuil.home.xs4all.nl/spec/media.html#selection-api
> >>
> >> For the video output direction (memory -> HW encoder) the data source is
> >> the memory, the data sink is the HW encoder. For the video capture direction
> >> (HW encoder -> memory) the data source is the HW encoder and the data sink
> >> is the memory.
> >>
> >> Usually for m2m devices the video output direction may support cropping and
> >> the video capture direction may support composing.
> >>
> >> It's not clear what you intend here, especially since you set left and right
> >> to 0. That's not what the selection operation is supposed to do.
> >>
> > I am confused about about g/s_selection.
> > If application want to configure encode area and crop meta-data, it
> > should set crop info to OUTPUT queue, is that right?
> > if user space still use g/s_crop ioctl, in 
> > v4l_g_crop and v4l_s_crop, it set target to V4L2_SEL_TGT_COMPOSE_ACTIVE
> > when buf type is V4L2_TYPE_IS_OUTPUT.
> > 
> > It looks like when work with g/s_crop ioctl, command set to OUTPUT
> > buffer will use target V4L2_SEL_TGT_COMPOSE_ACTIVE.
> 
> Correct. The semantics of g/s_crop for output devices is really weird
> and g/s_crop is generally useless for mem2mem devices.
> 
> You should completely ignore the old g/s_crop and only look at g/s_selection.
> 
> > When work with g/s_selection ictol, command set to OUTPUT buffer will
> > use V4L2_SEL_TGT_CROP_ACTIVE.
> > Is this correct behavior?
> 
> Yes. What this means is that userspace has to use g/s_selection for
> mem2mem devices since g/s_crop changes the wrong thing: compose instead
> of crop for OUTPUT and crop instead of compose for CAPTURE.
> 
> The g/s_selection ioctls were added to solve this problem with g/s_crop.
> It always confuses people and it was due to a lack of foresight when the
> old crop API was designed: it was made for video capture where you
> crop on the hardware side (in the video receiver), and for video output it
> would compose the image in the video transmitter's total frame (usually
> 720x480/576). None of this applies in general to memory-to-memory devices.
> 

Understood now.

Now I am trying to figure out how to make this function right.
Our encoder only support crop range from (0, 0) to (width, height), so
if s->r.top and s->r.left not 0, I will return -EINVAL.


Another thing is that in v4l2-compliance test, it has testLegacyCrop.
It looks like we still need to support 
 V4L2_SEL_TGT_COMPOSE_DEFAULT:
 V4L2_SEL_TGT_COMPOSE_BOUNDS:
 V4L2_SEL_TGT_COMPOSE:
to pass v4l2 compliance test, Or it will fail in 
fail: v4l2-test-formats.cpp(1318): !doioctl(node, VIDIOC_G_SELECTION,
&sel)
fail: v4l2-test-formats.cpp(1336): testLegacyCrop(node)
test Cropping: FAIL

I don't understand the following testing code.

        /*
         * If either CROPCAP or G_CROP works, then G_SELECTION should
         * work as well.
         * If neither CROPCAP nor G_CROP work, then G_SELECTION
shouldn't
         * work either.
         */
        if (!doioctl(node, VIDIOC_CROPCAP, &cap)) {
                fail_on_test(doioctl(node, VIDIOC_G_SELECTION, &sel));

                // Checks for invalid types
                if (cap.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
                        cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
                else
                        cap.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
                fail_on_test(doioctl(node, VIDIOC_CROPCAP, &cap) !=
EINVAL);
                cap.type = 0xff;
                fail_on_test(doioctl(node, VIDIOC_CROPCAP, &cap) !=
EINVAL);
        } else {
                fail_on_test(!doioctl(node, VIDIOC_G_SELECTION, &sel));
-> fail here
        }

When test OUTPUT queue, it fail because v4l_cropcap will fail when
s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS.
If VIDIOC_CROPCAP ioctl fail, VIDIOC_G_SELECTION should fail.
But VIDIOC_G_SELECTION target on CROP not COMPOSE and it success.


best regards,
Tiffany



> Regards,
> 
> 	Hans
> 
> > 
> > 
> > static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
> > 				struct file *file, void *fh, void *arg)
> > {
> > 	struct v4l2_crop *p = arg;
> > 	struct v4l2_selection s = {
> > 		.type = p->type,
> > 	};
> > 	int ret;
> > 
> > 	if (ops->vidioc_g_crop)
> > 		return ops->vidioc_g_crop(file, fh, p);
> > 	/* simulate capture crop using selection api */
> > 
> > 	/* crop means compose for output devices */
> > 	if (V4L2_TYPE_IS_OUTPUT(p->type))
> > 		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> > 	else
> > 		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
> > 
> > 	ret = ops->vidioc_g_selection(file, fh, &s);
> > 
> > 	/* copying results to old structure on success */
> > 	if (!ret)
> > 		p->c = s.r;
> > 	return ret;
> > }
> > 
> > static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
> > 				struct file *file, void *fh, void *arg)
> > {
> > 	struct v4l2_crop *p = arg;
> > 	struct v4l2_selection s = {
> > 		.type = p->type,
> > 		.r = p->c,
> > 	};
> > 
> > 	if (ops->vidioc_s_crop)
> > 		return ops->vidioc_s_crop(file, fh, p);
> > 	/* simulate capture crop using selection api */
> > 
> > 	/* crop means compose for output devices */
> > 	if (V4L2_TYPE_IS_OUTPUT(p->type))
> > 		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> > 	else
> > 		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
> > 
> > 	return ops->vidioc_s_selection(file, fh, &s);
> > }
> > 
> > 
> > best regards,
> > Tiffany
> > 
> > 
> > 
> > 
> >> Regards,
> >>
> >> 	Hans
> >>
> >>> +
> >>> +	return 0;
> >>> +}
> >>> +
> >>>  static int vidioc_venc_qbuf(struct file *file, void *priv,
> >>>  			    struct v4l2_buffer *buf)
> >>>  {
> >>> @@ -688,6 +759,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
> >>>  
> >>>  	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
> >>>  	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
> >>> +
> >>> +	.vidioc_g_selection		= vidioc_venc_g_selection,
> >>> +	.vidioc_s_selection		= vidioc_venc_s_selection,
> >>>  };
> >>>  
> >>>  static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
> >>>
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 


