Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:21739 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751900AbcBVPTa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 10:19:30 -0500
Message-ID: <1456154364.1943.3.camel@mtksdaap41>
Subject: Re: [PATCH v4 5/8] [Media] vcodec: mediatek: Add Mediatek V4L2
 Video Encoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Date: Mon, 22 Feb 2016 23:19:24 +0800
In-Reply-To: <56C82F60.4060304@xs4all.nl>
References: <1454585703-42428-1-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-2-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-3-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-4-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-5-git-send-email-tiffany.lin@mediatek.com>
	 <1454585703-42428-6-git-send-email-tiffany.lin@mediatek.com>
	 <56C1B4AF.1030207@xs4all.nl> <1455604653.19396.68.camel@mtksdaap41>
	 <56C2D371.9090805@xs4all.nl> <1455959480.12533.11.camel@mtksdaap41>
	 <56C82F60.4060304@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sat, 2016-02-20 at 10:18 +0100, Hans Verkuil wrote:
> On 02/20/2016 10:11 AM, tiffany lin wrote:
> > Hi Hans,
> > 
> > On Tue, 2016-02-16 at 08:44 +0100, Hans Verkuil wrote:
> >> On 02/16/2016 07:37 AM, tiffany lin wrote:
> >>>>> +
> >>>>> +const struct v4l2_ioctl_ops mtk_venc_ioctl_ops = {
> >>>>> +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> >>>>> +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
> >>>>> +
> >>>>> +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> >>>>> +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> >>>>> +	.vidioc_qbuf			= vidioc_venc_qbuf,
> >>>>> +	.vidioc_dqbuf			= vidioc_venc_dqbuf,
> >>>>> +
> >>>>> +	.vidioc_querycap		= vidioc_venc_querycap,
> >>>>> +	.vidioc_enum_fmt_vid_cap_mplane = vidioc_enum_fmt_vid_cap_mplane,
> >>>>> +	.vidioc_enum_fmt_vid_out_mplane = vidioc_enum_fmt_vid_out_mplane,
> >>>>> +	.vidioc_enum_framesizes		= vidioc_enum_framesizes,
> >>>>> +
> >>>>> +	.vidioc_try_fmt_vid_cap_mplane	= vidioc_try_fmt_vid_cap_mplane,
> >>>>> +	.vidioc_try_fmt_vid_out_mplane	= vidioc_try_fmt_vid_out_mplane,
> >>>>> +	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
> >>>>
> >>>> Please add vidioc_create_bufs and vidioc_prepare_buf as well.
> >>>>
> >>>
> >>> Currently we do not support these use cases, do we need to add
> >>> vidioc_create_bufs and vidioc_prepare_buf now?
> >>
> >> I would suggest you do. The vb2 framework gives it (almost) for free.
> >> prepare_buf is completely free (just add the helper) and create_bufs
> >> needs a few small changes in the queue_setup function, that's all.
> >>
> > After try to add vidioc_create_bufs directly using
> > vb2_ioctl_create_bufs, it will have problem in 
> 
> This is a m2m device, so you should use the m2m variant of this:
> v4l2_m2m_ioctl_create_bufs
> 
> That should solve this problem.
> 
> Ditto for prepare_buf: you need to use v4l2_m2m_ioctl_prepare_buf.
> 
Got it. After using v4l2_m2m_ioctl_create_bufs, the problem was solved.
Thanks for your help.

> Regards,
> 
> 	Hans





