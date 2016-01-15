Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38092 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbcAORB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2016 12:01:26 -0500
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
 <00ac01d14ef0$0702b2f0$150818d0$@samsung.com>
 <1452798133.3306.3.camel@collabora.com>
In-reply-to: <1452798133.3306.3.camel@collabora.com>
Subject: RE: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
Date: Fri, 15 Jan 2016 18:01:21 +0100
Message-id: <000301d14fb6$5cdd6370$16982a50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
> Sent: Thursday, January 14, 2016 8:02 PM
> To: Kamil Debski; 'Wu-Cheng Li'; pawel@osciak.com;
> mchehab@osg.samsung.com; hverkuil@xs4all.nl; crope@iki.fi;
> standby24x7@gmail.com; ricardo.ribalda@gmail.com; ao2@ao2.it;
> bparrot@ti.com; 'Andrzej Hajda'
> Cc: linux-media@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> api@vger.kernel.org
> Subject: Re: [PATCH] v4l: add
> V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
> 
> Le jeudi 14 janvier 2016 à 18:21 +0100, Kamil Debski a écrit :
> > I had a look into the documentation of MFC. It is possible to force
> > two types of a frame to be coded.
> > The one is a keyframe, the other is a not coded frame. As I understand
> > this is a type of frame that means that image did not change from
> > previous frame. I am sure I seen it in an MPEG4 stream in a movie
> > trailer. The initial board with the age rating is displayed for a
> > couple of seconds and remains static. Thus there is one I-frame and a
> > number of non-coded frames.
> >
> > That is the reason why the control was implemented in MFC as a menu
> > and not a button. Thus the question remains - is it better to leave it
> > as a menu, or should there be two (maybe more in the future) buttons?
> 
> Then I believe we need both. Because with the menu, setting I-Frame, I
> would expect to only receive keyframes from now-on. While the useful
> feature we are looking for here, is to get the next buffer (or nearby) to be a
> keyframe. It's the difference between creating an I-Frame only stream and
> requesting a key-frame manually for recovery (RTP use case).
> In this end, we should probably take that time to review the features we
> have as we need:

I think we had a discussion about this long, long time ago. Should it be
deterministic which frame Is encoded as a key frame? Should it be the
next queued frame, or the next processed frame? How to achieve this?
I vaguely remember that we discussed per buffer controls on the mailing
list, but I am not sure where the discussion went from there.

> 
> - A way to trigger a key frame to be produce
> - A way to produce a I-Frame only stream

This control can be used to do this:
- V4L2_CID_MPEG_VIDEO_GOP_SIZE (It is not well documented as I can see ;) )
	+ If set to 0 the encoder produces a stream with P only frames
	+ if set to 1 the encoder produces a stream with I only frames
	+ other values indicate the GOP size (I-frame interval)

> - A way to set the key-frame distance (in frames) even though this could
> possibly be emulated using the trigger.

As described above V4L2_CID_MPEG_VIDEO_GOP_SIZE can be used to achieve this.

> 
> cheers,
>Nicolas
 
Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

