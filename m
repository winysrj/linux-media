Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31880 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab2A3MAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 07:00:34 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LYM00MRI1CWQC@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Jan 2012 12:00:32 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYM00DJP1CWNX@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Jan 2012 12:00:32 +0000 (GMT)
Date: Mon, 30 Jan 2012 13:00:31 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC] More on subdev selections API: composition
In-reply-to: <20120129180641.GA16140@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, t.stanislaws@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, g.liakhovetski@gmx.de,
	teturtia@gmail.com
Message-id: <4F26865F.4050508@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <20120129180641.GA16140@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/29/2012 07:06 PM, Sakari Ailus wrote:
> The problem with multiple sink pads is that which one you're referring to
> when you're configuring the first processing step on the source. Without
> composition there are no issues.
> 
> What I can think of is to create a special composition target which is not
> bound to any pad, but reflects the size of the rectangle on which streams
> may be composed from source pad. Cropping on source pad refers to the
> coordinates of the composition rectangle. Composition target on sink pad in
> the original proposal would be renamed as the scaling target. There would

I would prefer to stick with CROP and COMPOSE target names on both video and
subdev nodes, not to add unnecessary confusion. 

> also be no composition on source pads as it does not make that much sense.

> To make configuration simple, accessing any unsupported rectangles should
> return EINVAL. So devices not supporting composition would work as proposed
> earlier: the compose rectangle would be omitted and the sink crop (if
> supported) would refer to either scaling or crop targets or even the sink
> format directly.
> 
> <URL:http://www.retiisi.org.uk/v4l2/tmp/format2.eps>
> 
> Alternatively I think we could as well drop composition support at this
> point as we have no drivers using it. We still need to plan ahead how it

No, that's not true there is no drivers supporting composition. On S5P FIMC
I currently use crop on source pad to configure composition rectangle on the
output buffers. The drivers forms following pipeline:

/dev/subdev?   /dev/subdev?    /dev/video? 
+--------+      +--------+      +-----+
| sensor |o----o| scaler |o----o| DMA |
+--------+      +--------+      +-----+
pads:     S0   SC0      SC1    D0

Physically the scaler and DMA are tightly coupled in one platform device, hence
SC1 <-> D0 link is immutable.
Format on D0 link is currently always same as configured with VIDIOC_S_FMT on
/dev/video?.

What is needed here seems just crop on sink pad (SC0) and compose on source pad
(SC1). But I'm not so sure about it, given your interpretation and after short
(well, not so) discussion with Tomasz.

TBH all functionality of the device could be exposed with the scaler subdev
removed and VIDIOC_S/G_SELECTION used on /dev/video?. It is getting overly
complicated with all the subdevs as above in place and your guys interpretation
of the subdev selection.

> could be supported as the need likely arises at some point. As far as I see
> the current interface proposal is compatible with composition.
> 
> Should we discuss this further on #v4l-meeting, I propose Tuesday 2012-01-31
> 15:00 Finnish time (13:00 GMT).


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
