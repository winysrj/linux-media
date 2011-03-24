Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54114 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab1CXKgw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 06:36:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH] omap3isp: implement ENUM_FMT
Date: Thu, 24 Mar 2011 11:36:53 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Jones <michael.jones@matrix-vision.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?iso-8859-1?q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	Yordan Kamenov <ykamenov@mm-sol.com>
References: <4D889C61.905@matrix-vision.de> <201103240842.43024.hverkuil@xs4all.nl> <4D8AFD20.4000705@maxwell.research.nokia.com>
In-Reply-To: <4D8AFD20.4000705@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103241136.54032.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Thursday 24 March 2011 09:13:20 Sakari Ailus wrote:
> Hans Verkuil wrote:
> > On Thursday, March 24, 2011 08:28:31 Michael Jones wrote:
> >> On 03/23/2011 01:16 PM, Laurent Pinchart wrote:
> >>> Hi Michael,
> >> 
> >> [snip]
> >> 
> >>>> Is there a policy decision that in the future, apps will be required
> >>>> to use libv4l to get images from the ISP?  Are we not intending to
> >>>> support using e.g. media-ctl + some v4l2 app, as I'm currently doing
> >>>> during development?
> >>> 
> >>> Apps should be able to use the V4L2 API directly. However, we can't
> >>> implement all that API, as most calls don't make sense for the OMA3
> >>> ISP driver. Which calls need to be implemented is a grey area at the
> >>> moment, as there's no detailed semantics on how subdev-level
> >>> configuration and video device configuration should interact.
> > 
> > We definitely need to discuss this in the near future. It's indeed a grey
> > area at the moment that needs to be clarified.
> 
> I fully agree.
> 
> >>> Your implementation of ENUM_FMT looks correct to me, but the question
> >>> is whether ENUM_FMT should be implemented. I don't think ENUM_FMT is a
> >>> required ioctl, so maybe v4l2src shouldn't depend on it. I'm
> >>> interesting in getting Hans' opinion on this.
> >> 
> >> I only implemented it after I saw that ENUM_FMT _was_ required by V4L2.
> >> 
> >>  From http://v4l2spec.bytesex.org/spec/x1859.htm#AEN1894 :
> >> "The VIDIOC_ENUM_FMT ioctl must be supported by all drivers exchanging
> >> image data with applications."

Good point.

> > If you can call S_FMT on a device node, then you also have to implement
> > ENUM_FMT.
> 
> I think the issue here is that it's not possible (or feasible) to
> implement ENUM_FMT in a way applications would obtain the information
> they're interested in. Available pixel formats are dictated by the
> formats on links (validation must be done first in a generic case!) and
> in the case of OMAP 3 ISP there's always just one.
> 
> S_FMT and TRY_FMT behave more or less the way applications like. The
> pixelformat or size may not change, though, and this information is also
> used to prepare the buffers.
> 
> > I am assuming applications need to call S_FMT for omap3 video nodes,
> > right? Because that defines the result of the DMA engine. Or is the
> > result always fixed, based on the current pipeline configuration? In the
> > latter case I would still expect to see an ENUM_FMT, but one that just
> > returns the current format. And S/TRY_FMT would also return the current
> > format.
> 
> There are some options in the format that is not defined by the
> v4l2_mbus_pixelcode already. Padding is such and I don't think there
> should be anything else than that since the v4l2_mbus_pixelcode
> conversion and scaling takes places in the subdevs. Laurent? :-)

Padding at end of line can be configured through S_FMT. Other than that, all 
other options (width, height, pixelcode) are fixed for a given mbus format 
*for the ISP driver*. Other drivers might support different pixel codes for a 
given mbus code (with different padding and/or endianness).

Application either need to be aware of the media controller framework, in 
which case they will know how to deal with mbus formats and pixel formats, or 
need to be run after an external application takes care of pipeline 
configuration. In the second case I suppose it's reasonable to assume that no 
application will touch the pipeline while the pure V4L2 runs. In that case I 
think your implementation of ENUM_FMT makes sense.

-- 
Regards,

Laurent Pinchart
