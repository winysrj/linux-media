Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34683 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1BPJLy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 04:11:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
Date: Wed, 16 Feb 2011 10:11:59 +0100
Cc: Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange> <201102160949.04605.hansverk@cisco.com> <Pine.LNX.4.64.1102160954560.20711@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102160954560.20711@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102161011.59830.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

On Wednesday 16 February 2011 10:02:18 Guennadi Liakhovetski wrote:
> On Wed, 16 Feb 2011, Hans Verkuil wrote:
> > On Wednesday, February 16, 2011 08:42:51 Guennadi Liakhovetski wrote:
> [snip]

I definitely don't like solutions 1 and 2 either, so I'll only comment on 3.

> > > > 3. Not liking either of the above, it seems we need yet a new API for
> > > > this... How about extending VIDIOC_REQBUFS with a videobuf queue
> > > > index, thus using up one of the remaining two 32-bit reserved
> > > > fields? Then we need one more ioctl() like VIDIOC_BUFQ_SELECT to
> > > > switch from one queue to another, after which setting frame format
> > > > and queuing and dequeuing buffers will affect this currently
> > > > selected queue. We could also keep REQBUFS as is and require
> > > > BUFQ_SELECT to be called before it for any queue except the default
> > > > 0.
> > 
> > What you really are doing here is creating the functionality of two video
> > nodes without actually making two nodes.
> > 
> > But from the point of view of the application it makes more sense to
> > actually have two video nodes. The only difference is that when one
> > starts streaming it pre-empts the other.
> 
> Well, I don't think I like it all that much... One reason - yes, two
> "independent" video device-nodes, which actually only can stream in turn
> seems somewhat counterintuitive to me, specifically, I don't think there
> is a way to tell the application about this. What if we have more than two
> video devices on the system? Or what if you need more than two video
> queues / formats? Or actually only one? The kernel doesn't know initially
> how many, this is a dynamic resource, not a fixed static interface, IMHO.

I agree with this, which is why I don't think two (or more) video nodes would 
be a good solution.

We've hit the exact same issue with the OMAP3 ISP driver. Our current solution 
is to allocate video buffer queues at the file handle level instead of the 
video node level. Applications can open the same video device twice and 
allocate buffers for the viewfinder on one of the instances and for still 
image capture on the other. When switching from viewfinder to still image 
capture, all it needs to do (beside obviously reconfiguring the media 
controller pipeline if required) is to issue VIDIOC_STREAMOFF on the 
viewfinder file handle and VIDIOC_STREAMON on the still capture file handle.

One issue with this approach is that allocating buffers requires knowledge of 
the format and resolution. The driver traditionally computes the buffer size 
from the parameters set by VIDIOC_S_FMT. This would prevent an application 
opening the video node a second time and setting up buffers for still image 
capture a second time while the viewfinder is running, as the VIDIOC_S_FMT on 
the second file handle won't be allowed then.

Changes to the V4L2 spec would be needed to allow this to work properly. One 
possible direction would be to enhance the buffers allocation API to allow 
applications to set the buffer size. I've been thinking about this, and I 
believe this is where the "global buffers pool" API could come into play.

> > Of course, implementing this correctly will probably require some changes
> > in videobuf2 to make it easy.
> > 
> > When it comes to the userspace API I wonder if we shouldn't add a
> > VIDIOC_STREAM_FRAMES(u32 framecnt), which streams just 'framecnt' frames.
> > I can imagine that it can be hard to stream just a single frame
> > otherwise.
> 
> Don't think you actually need to take just 1 frame for still photography.
> As far as I understand, in many cases they anyway want to take several of
> them to then be able to choose the best one or do some processing.
> Regardless, maybe that ioctl() would make sense, but that's something
> slightly different from what we're trying to figure out here. Yes, it is
> also related to still photography, but it's addressing a different aspect
> of it.

-- 
Regards,

Laurent Pinchart
