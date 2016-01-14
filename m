Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47812 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbcANRVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 12:21:42 -0500
From: Kamil Debski <k.debski@samsung.com>
To: 'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	'Wu-Cheng Li' <wuchengli@chromium.org>, pawel@osciak.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi,
	standby24x7@gmail.com, ricardo.ribalda@gmail.com, ao2@ao2.it,
	bparrot@ti.com, 'Andrzej Hajda' <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
 <1452686611-145620-2-git-send-email-wuchengli@chromium.org>
 <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
 <1452783743.10009.18.camel@collabora.com>
In-reply-to: <1452783743.10009.18.camel@collabora.com>
Subject: RE: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
Date: Thu, 14 Jan 2016 18:21:37 +0100
Message-id: <00ac01d14ef0$0702b2f0$150818d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
> Sent: Thursday, January 14, 2016 4:02 PM
> To: Kamil Debski; 'Wu-Cheng Li'; pawel@osciak.com;
> mchehab@osg.samsung.com; hverkuil@xs4all.nl; crope@iki.fi;
> standby24x7@gmail.com; ricardo.ribalda@gmail.com; ao2@ao2.it;
> bparrot@ti.com
> Cc: linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> api@vger.kernel.org
> Subject: Re: [PATCH] v4l: add
> V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
> 
> Hi Kamil,
> 
> Le mercredi 13 janvier 2016 à 17:43 +0100, Kamil Debski a écrit :
> > Good to hear that there are new codecs to use the V4L2 codec API :)
> >
> > My two cents are following - when you add a control that does the same
> > work as a driver specific control then it would be great if you
> > modified the driver that uses the specific control to also support the
> > newly added control.
> > This way future applications  could use the control you added for both
> > new and old drivers.
> 
> When i first notice this MFC specific control, I believed it was use to produce
> I-Frame only streams (rather then a toggle, to produce one key- frame on
> demand). So I wanted to verify the implementation to make sure what Wu-
> Cheng is doing make sense. Though, I found that we set:
> 
>   ctx->force_frame_type = ctrl->val;
> 
> And never use that value anywhere else in the driver code. Hopefully I'm just
> missing something, but if it's not implemented, maybe it's better not to
> expose it. Otherwise, this may lead to hard to find streaming issues. I do
> hope we can add this feature though, as it's very useful feature for real time
> encoding.

Ooops, you're right. It's not implemented. I am adding Andrzej Hajda to the CC loop, he may know more about this. I think it may have been implemented in some of our development branches, but somehow did not make it into the mainline kernel. That's one thing.

The other one is about your previous comment. I will quote it below, as it is in another email.

> I don't like the way it's implemented. I don't know any decoder that have
> a frame type forcing feature other they I-Frame. It would be much more
> natural to use a toggle button control (and add more controls for other
> types when needed) then trying to merge hypothetical toggles into
>something that manually need to be set and disabled.

I had a look into the documentation of MFC. It is possible to force two types of a frame to be coded.
The one is a keyframe, the other is a not coded frame. As I understand this is a type of frame that means that image did not change from previous frame. I am sure I seen it in an MPEG4 stream in a movie trailer. The initial board with the age rating is displayed for a couple of seconds and remains static. Thus there is one I-frame and a number of non-coded frames.

That is the reason why the control was implemented in MFC as a menu and not a button. Thus the question remains - is it better to leave it as a menu, or should there be two (maybe more in the future) buttons? 

Wu-Cheng, does your hardware also supports inserting such a non-coded frame? I can imagine that there could be hardware (in the future or some current hardware that I am not aware of other than MFC) that could support this.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

