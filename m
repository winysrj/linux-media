Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58103 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2HQM4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 08:56:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: workshop-2011@linuxtv.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] V4L2 API ambiguities: workshop presentation
Date: Fri, 17 Aug 2012 14:57:02 +0200
Message-ID: <70803480.BV5Mjk80If@avalon>
In-Reply-To: <201208171455.13961.hverkuil@xs4all.nl>
References: <201208171235.58094.hverkuil@xs4all.nl> <502E3D97.3090502@redhat.com> <201208171455.13961.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 17 August 2012 14:55:13 Hans Verkuil wrote:
> On Fri August 17 2012 14:48:23 Hans de Goede wrote:
> > On 08/17/2012 12:35 PM, Hans Verkuil wrote:
> > > Hi all,
> > > 
> > > I've prepared a presentation for the upcoming workshop based on my RFC
> > > and the comments I received.
> > > 
> > > It is available here:
> > > 
> > > http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-2012.odp
> > > http://hverkuil.home.xs4all.nl/presentations/v4l2-workshop-2012.pdf
> > > 
> > > Attendees of the workshop: please review this before the workshop
> > > starts. I
> > > want to go through this list fairly quickly (particularly slides 1-14)
> > > so we can have more time for other topics.
> > 
> > A note on the Pixel Aspect Ratio from me, since I won't be attending:
> > 
> > I'm not sure if having a VIDIOC_G_PIXELASPECT is enough, it will work
> > to get the current mode, but not for enumerating. Also it will not
> > work with TRY_FMT, that is one cannot find out the actual pixelaspect
> > until after a S_FMT. As mentioned in previous mail I think at a minimum
> > the results of ENUM_FRAMESIZES should contain the pixel aspect per
> > framesize, there is enough reserved space in the relevant structs to make
> > this happen
> Pixel aspect doesn't belong in the FMT ioctls: the pixel aspect ratio is
> a property of the video input/output format, but the FMT ioctls deal with
> scaling as well, so the aspect ratio would then be scaled as well, making
> it very complex indeed.
> 
> Regarding ENUM_FRAMESIZES: it makes sense to add an aspect ratio here for
> use with sensors. But for video receivers ENUM_FRAMESIZES isn't applicable.

Do we have sensors with non-square pixels ?

-- 
Regards,

Laurent Pinchart

