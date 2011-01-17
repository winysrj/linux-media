Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:25035 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab1AQL43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 06:56:29 -0500
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LF6003PP163IP10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jan 2011 20:56:27 +0900 (KST)
Received: from JONGHUNHA11 ([12.23.103.140])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LF6009TW1637F@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Jan 2011 20:56:27 +0900 (KST)
Date: Mon, 17 Jan 2011 20:56:22 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: How to set global alpha to V4L2_BUF_TYPE_CAPTURE ?
In-reply-to: <201101170752.03018.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Message-id: <005b01cbb63d$9298aa50$b7c9fef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
References: <003801cbb5f8$ec278180$c4768480$%han@samsung.com>
 <201101170752.03018.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Thanks for interesting.

Ok, I will submit it using VIDIOC_S_CTRL.

Best regards,

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Monday, January 17, 2011 3:52 PM
> To: Jonghun Han
> Cc: linux-media@vger.kernel.org; pawel@osciak.com; 'Marek Szyprowski'
> Subject: Re: How to set global alpha to V4L2_BUF_TYPE_CAPTURE ?
> 
> On Monday, January 17, 2011 04:44:54 Jonghun Han wrote:
> >
> > Hello,
> >
> > How to set global alpha to V4L2_BUF_TYPE_CAPTURE ?
> >
> > Samsung SoC S5PC210 has Camera interface and Video post processor
> > named FIMC which can set the alpha value to V4L2_BUF_TYPE_CAPTURE.
> > For example during color space conversion from YUV422 to ARGB8888,
> > FIMC can set the alpha value to V4L2_BUF_TYPE_CAPTURE.
> >
> > I tried to find an available command to set it but I couldn't found it.
> 
> That's right, there isn't.
> 
> > But there is fmt.win.global_alpha for Video Overlay Interface.
> > So in my opinion VIDIOC_S_FMT is also suitable for
> V4L2_BUF_TYPE_CAPTURE*.
> > How about using fmt.pix.priv in struct v4l2_format and
> > fmt.pix_mp.reserved[0] in struct v4l2_format ?
> 
> Not a good idea. This is really ideal for a control. We already have a
somewhat
> similar control in the form of V4L2_CID_BG_COLOR. It's perfectly
reasonable to
> add a V4L2_CID_ALPHA_COLOR (or something similar) where you set this up.
> 
> The little available space in the format structs is too precious to use
for something
> trivial like this :-)
> 
> Regards,
> 
> 	Hans
> 
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco

