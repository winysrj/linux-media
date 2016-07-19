Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:62821 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752916AbcGSQoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 12:44:23 -0400
Message-ID: <1468946654.30095.4.camel@mtksdaap41>
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
Date: Wed, 20 Jul 2016 00:44:14 +0800
In-Reply-To: <f2c031e2-82ca-90f4-0900-4dc961a90f58@xs4all.nl>
References: <1464594768-1993-1-git-send-email-tiffany.lin@mediatek.com>
	 <4ca82842-968d-a5e2-587d-752c71713607@xs4all.nl>
	 <1468477674.32454.36.camel@mtksdaap41>
	 <bb96276a-8e6c-a535-6fd3-fe4327238f65@xs4all.nl>
	 <1468844895.12740.15.camel@mtksdaap41>
	 <f2c031e2-82ca-90f4-0900-4dc961a90f58@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2016-07-18 at 14:44 +0200, Hans Verkuil wrote:
> On 07/18/2016 02:28 PM, tiffany lin wrote:
> > Understood now.
> > 
> > Now I am trying to figure out how to make this function right.
> > Our encoder only support crop range from (0, 0) to (width, height), so
> > if s->r.top and s->r.left not 0, I will return -EINVAL.
> > 
> > 
> > Another thing is that in v4l2-compliance test, it has testLegacyCrop.
> > It looks like we still need to support 
> >  V4L2_SEL_TGT_COMPOSE_DEFAULT:
> >  V4L2_SEL_TGT_COMPOSE_BOUNDS:
> >  V4L2_SEL_TGT_COMPOSE:
> > to pass v4l2 compliance test, Or it will fail in 
> > fail: v4l2-test-formats.cpp(1318): !doioctl(node, VIDIOC_G_SELECTION,
> > &sel)
> > fail: v4l2-test-formats.cpp(1336): testLegacyCrop(node)
> > test Cropping: FAIL
> 
> Against which kernel are you testing? In the current media_tree master
> there is a bug in drivers/media/v4l2-core/v4l2-ioctl.c, v4l_cropcap():
> 
> This code:
> 
> if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_cropcap))
> 
> should be:
> 
> if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_g_selection))
> 
> The fix is waiting for a pull from Linus.
> 
> Also update to the latest v4l2-compliance: I've made some changes that
> might affect this. And I added additional checks to verify if all the
> colorspace-related format fields are properly propagated from the
> output format to the capture format.
> 

Sorry, I miss this part.
After update to latest version include this fix, it can pass crop test
without supporting COMPOSE in output queue.
Appreciated for your help

best regards,
Tiffany



> Regards,
> 
> 	Hans
> 
> > 
> > I don't understand the following testing code.
> > 
> >         /*
> >          * If either CROPCAP or G_CROP works, then G_SELECTION should
> >          * work as well.
> >          * If neither CROPCAP nor G_CROP work, then G_SELECTION
> > shouldn't
> >          * work either.
> >          */
> >         if (!doioctl(node, VIDIOC_CROPCAP, &cap)) {
> >                 fail_on_test(doioctl(node, VIDIOC_G_SELECTION, &sel));
> > 
> >                 // Checks for invalid types
> >                 if (cap.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >                         cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> >                 else
> >                         cap.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> >                 fail_on_test(doioctl(node, VIDIOC_CROPCAP, &cap) !=
> > EINVAL);
> >                 cap.type = 0xff;
> >                 fail_on_test(doioctl(node, VIDIOC_CROPCAP, &cap) !=
> > EINVAL);
> >         } else {
> >                 fail_on_test(!doioctl(node, VIDIOC_G_SELECTION, &sel));
> > -> fail here
> >         }
> > 
> > When test OUTPUT queue, it fail because v4l_cropcap will fail when
> > s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS.
> > If VIDIOC_CROPCAP ioctl fail, VIDIOC_G_SELECTION should fail.
> > But VIDIOC_G_SELECTION target on CROP not COMPOSE and it success.
> > 
> > 
> > best regards,
> > Tiffany
> > 
> > 
> > 
> >> Regards,
> >>
> >> 	Hans
> >>
> >>>
> >>>
> >>> static int v4l_g_crop(const struct v4l2_ioctl_ops *ops,
> >>> 				struct file *file, void *fh, void *arg)
> >>> {
> >>> 	struct v4l2_crop *p = arg;
> >>> 	struct v4l2_selection s = {
> >>> 		.type = p->type,
> >>> 	};
> >>> 	int ret;
> >>>
> >>> 	if (ops->vidioc_g_crop)
> >>> 		return ops->vidioc_g_crop(file, fh, p);
> >>> 	/* simulate capture crop using selection api */
> >>>
> >>> 	/* crop means compose for output devices */
> >>> 	if (V4L2_TYPE_IS_OUTPUT(p->type))
> >>> 		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> >>> 	else
> >>> 		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
> >>>
> >>> 	ret = ops->vidioc_g_selection(file, fh, &s);
> >>>
> >>> 	/* copying results to old structure on success */
> >>> 	if (!ret)
> >>> 		p->c = s.r;
> >>> 	return ret;
> >>> }
> >>>
> >>> static int v4l_s_crop(const struct v4l2_ioctl_ops *ops,
> >>> 				struct file *file, void *fh, void *arg)
> >>> {
> >>> 	struct v4l2_crop *p = arg;
> >>> 	struct v4l2_selection s = {
> >>> 		.type = p->type,
> >>> 		.r = p->c,
> >>> 	};
> >>>
> >>> 	if (ops->vidioc_s_crop)
> >>> 		return ops->vidioc_s_crop(file, fh, p);
> >>> 	/* simulate capture crop using selection api */
> >>>
> >>> 	/* crop means compose for output devices */
> >>> 	if (V4L2_TYPE_IS_OUTPUT(p->type))
> >>> 		s.target = V4L2_SEL_TGT_COMPOSE_ACTIVE;
> >>> 	else
> >>> 		s.target = V4L2_SEL_TGT_CROP_ACTIVE;
> >>>
> >>> 	return ops->vidioc_s_selection(file, fh, &s);
> >>> }
> >>>
> >>>
> >>> best regards,
> >>> Tiffany
> >>>
> >>>
> >>>
> >>>
> >>>> Regards,
> >>>>
> >>>> 	Hans
> >>>>
> >>>>> +
> >>>>> +	return 0;
> >>>>> +}
> >>>>> +
> >>>>>  static int vidioc_venc_qbuf(struct file *file, void *priv,
> >>>>>  			    struct v4l2_buffer *buf)
> >>>>>  {
> >>>>> @@ -688,6 +759,9 @@ const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
> >>>>>  
> >>>>>  	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
> >>>>>  	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
> >>>>> +
> >>>>> +	.vidioc_g_selection		= vidioc_venc_g_selection,
> >>>>> +	.vidioc_s_selection		= vidioc_venc_s_selection,
> >>>>>  };
> >>>>>  
> >>>>>  static int vb2ops_venc_queue_setup(struct vb2_queue *vq,
> >>>>>
> >>>
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>>
> > 
> > 


