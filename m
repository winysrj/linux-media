Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50118 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274AbaJUMsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 08:48:09 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDS003XZP0XNS20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Oct 2014 13:50:57 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	'Kiran AVND' <avnd.kiran@samsung.com>,
	linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	laurent.pinchart@ideasonboard.com
Cc: wuchengli@chromium.org, posciak@chromium.org, arun.m@samsung.com,
	ihf@chromium.org, prathyush.k@samsung.com, arun.kk@samsung.com,
	kiran@chromium.org, Andrzej Hajda <a.hajda@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
 <1411707142-4881-15-git-send-email-avnd.kiran@samsung.com>
 <11f301cfe2e2$0cacc810$26065830$%debski@samsung.com>
 <54354B8D.8050208@collabora.com>
 <125301cfe3a8$acd561f0$068025d0$%debski@samsung.com>
 <544644D9.4020701@xs4all.nl>
In-reply-to: <544644D9.4020701@xs4all.nl>
Subject: RE: [PATCH v2 14/14] [media] s5p-mfc: Don't change the image size to
 smaller than the request.
Date: Tue, 21 Oct 2014 14:48:02 +0200
Message-id: <0c1001cfed2d$422620e0$c67262a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-transfer-encoding: 8BIT
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Tuesday, October 21, 2014 1:35 PM
> 
> Hi,
> 
> Let me chime in as well, based on the discussions I had last week in
> Düsseldorf:
> 
> On 10/09/2014 12:06 PM, Kamil Debski wrote:
> > Hi,
> >
> >> From: Nicolas Dufresne [mailto:nicolas.dufresne@collabora.com]
> >> Sent: Wednesday, October 08, 2014 4:35 PM
> >>
> >>
> >> Le 2014-10-08 06:24, Kamil Debski a écrit :
> >>> Hi,
> >>>
> >>> This patch seems complicated and I do not understand your motives.
> >>>
> >>> Could you explain what is the problem with the current aligning of
> >> the
> >>> values?
> >>> Is this a hardware problem? Which MFC version does it affect?
> >>> Is it a software problem? If so, maybe the user space application
> >> should
> >>> take extra care on what value it passes/receives to try_fmt?
> >> This looks like something I wanted to bring here as an RFC but never
> >> manage to get the time. In an Odroid Integration we have started
> using
> >> the following simple patch to work around this:
> >>
> >> https://github.com/dsd/linux-
> >> odroid/commit/c76b38c1d682b9870ea3b00093ad6500a9c5f5f6
> >>
> >> The context is that right now we have decided that alignment in
> s_fmt
> >> shall be done with a closest rounding. So the format returned may be
> >> bigger, or smaller, that's basically random. I've been digging
> through
> >> a
> >> lot, and so far I have found no rational that explains this choice
> >> other
> >> that this felt right.
> >>
> >> In real life, whenever the resulting format is smaller then request,
> >> there is little we can do other then fail or try again blindly other
> >> sizes. But with bigger raw buffers, we can use zero-copy  cropping
> >> techniques to keep going. Here's a example:
> >>
> >> image_generator -> hw_converter -> display
> >>
> >> As hw_converter is a V4L2 M2M, an ideal use case here would be for
> >> image_generator to use buffers from the hw_converter. For the
> scenario,
> >> it is likely that a fixed video size is wanted, but this size is
> also
> >> likely not to match HW requirement. If hw_converter decide to give
> back
> >> something smaller, there is nothing image_generator can do. It would
> >> have to try again with random size to find out that best match. It's
> a
> >> bit silly to force that on application, as the hw_converter know the
> >> closest best match, which is simply the next valid bigger size if
> that
> >> exist.
> >>
> >> hope that helps,
> >> Nicolas
> >
> > Nicolas, thank you for shedding light on this problem. I see that it
> is
> > not MFC specific. It seems that the problem applies to all
> Video4Linux2
> > devices that use v4l_bound_align_image. I agree with you that this
> deservers
> > an RFC and some discussion as this would change the behaviour of
> quite
> > a few drivers.
> >
> > I think the documentation does not specify how TRY_FMT/S_FMT should
> adjust
> > the parameters. Maybe it would a good idea to add some flagS that
> determine
> > the behaviour?
> 
> I think we should add flags here as well. NEAREST (the default),
> ROUND_DOWN and
> ROUND_UP. Existing calls will use NEAREST. I can think of use-cases for
> all
> three of these, and I think the caller should just have to specify what
> is
> needed.
> 
> Just replacing the algorithm used seems asking for problems, you want
> to be
> able to select what you want to do.

I agree with Hans here. Nicolas, Pawel, I understand your problem with
the nearest value behaviour and I think this should be resolved right.

I think the flags could be added to the flags field of v4l2_pix_format (and
its multiplane counterpart). Something along the lines:
V4L2_PIX_FMT_FLAG_ALIGN_GE, V4L2_PIX_FMT_FLAG_ALIGN_LE (akin to the flags
used in the selection API).

The function v4l2_bound_align could be then modified to take one more
argument and act accordingly. No flags set would mean the current behaviour,
and when flags are set it would either round up, down or return an error
if the exact value cannot be used.

What do you think?

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

