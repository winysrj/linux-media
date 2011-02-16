Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:54449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab1BPKf3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 05:35:29 -0500
Date: Wed, 16 Feb 2011 11:35:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
In-Reply-To: <201102161011.59830.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1102161033440.20711@axis700.grange>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange>
 <201102160949.04605.hansverk@cisco.com> <Pine.LNX.4.64.1102160954560.20711@axis700.grange>
 <201102161011.59830.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent

Thanks for commenting.

On Wed, 16 Feb 2011, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Wednesday 16 February 2011 10:02:18 Guennadi Liakhovetski wrote:
> > On Wed, 16 Feb 2011, Hans Verkuil wrote:
> > > On Wednesday, February 16, 2011 08:42:51 Guennadi Liakhovetski wrote:
> > [snip]
> 
> I definitely don't like solutions 1 and 2 either, so I'll only comment on 3.
> 
> > > > > 3. Not liking either of the above, it seems we need yet a new API for
> > > > > this... How about extending VIDIOC_REQBUFS with a videobuf queue
> > > > > index, thus using up one of the remaining two 32-bit reserved
> > > > > fields? Then we need one more ioctl() like VIDIOC_BUFQ_SELECT to
> > > > > switch from one queue to another, after which setting frame format
> > > > > and queuing and dequeuing buffers will affect this currently
> > > > > selected queue. We could also keep REQBUFS as is and require
> > > > > BUFQ_SELECT to be called before it for any queue except the default
> > > > > 0.
> > > 
> > > What you really are doing here is creating the functionality of two video
> > > nodes without actually making two nodes.
> > > 
> > > But from the point of view of the application it makes more sense to
> > > actually have two video nodes. The only difference is that when one
> > > starts streaming it pre-empts the other.
> > 
> > Well, I don't think I like it all that much... One reason - yes, two
> > "independent" video device-nodes, which actually only can stream in turn
> > seems somewhat counterintuitive to me, specifically, I don't think there
> > is a way to tell the application about this. What if we have more than two
> > video devices on the system? Or what if you need more than two video
> > queues / formats? Or actually only one? The kernel doesn't know initially
> > how many, this is a dynamic resource, not a fixed static interface, IMHO.
> 
> I agree with this, which is why I don't think two (or more) video nodes would 
> be a good solution.
> 
> We've hit the exact same issue with the OMAP3 ISP driver. Our current solution 
> is to allocate video buffer queues at the file handle level instead of the 
> video node level. Applications can open the same video device twice and 
> allocate buffers for the viewfinder on one of the instances and for still 
> image capture on the other. When switching from viewfinder to still image 
> capture, all it needs to do (beside obviously reconfiguring the media 
> controller pipeline if required) is to issue VIDIOC_STREAMOFF on the 
> viewfinder file handle and VIDIOC_STREAMON on the still capture file handle.
> 
> One issue with this approach is that allocating buffers requires knowledge of 
> the format and resolution. The driver traditionally computes the buffer size 
> from the parameters set by VIDIOC_S_FMT. This would prevent an application 
> opening the video node a second time and setting up buffers for still image 
> capture a second time while the viewfinder is running, as the VIDIOC_S_FMT on 
> the second file handle won't be allowed then.
> 
> Changes to the V4L2 spec would be needed to allow this to work properly.

The spec is actually saying about the S_FMT ioctl():

"On success the driver may program the hardware, allocate resources and 
generally prepare for data exchange."

- _may_ program the hardware. So, if we don't do that and instead only 
verify the format and store it for future activation upon a call to 
STREAMON we are not violating the spec, thus, no change is required. OTOH, 
another spec sections "V4L2 close()" says:

"data format parameters, current input or output, control values or other 
properties remain unchanged."

which is usually interpreted as "a sequence open(); ioctl(S_FMT); close(); 
open(); ioctl(STREAMON);" _must_ use the format, set by the call to S_FMT, 
which is not necessarily logical, if we adopt the per-file-descriptor 
format / stream approach.

I think, we have two options:

(1) adopt Laurent's proposal of per-fd contexts, but that would require a 
pretty heave modification of the spec - S_FMT is not kept across close() / 
open() pair.

(2) cleanly separate setting video data format (S_FMT) from specifying the 
allocated buffer size.

Of course, there are further possibilities, like my switching ioctl() 
above, or we could extend the enum v4l2_priority with an extra application 
priority, saying, that this file-descriptor can maintain a separate S_FMT 
/ STREAMON thread, without immediately affecting other descriptors, but 
this seems too obscure to me.

My vote goes for (2) above, which is also what Laurent has mentioned here:

> One 
> possible direction would be to enhance the buffers allocation API to allow 
> applications to set the buffer size. I've been thinking about this, and I 
> believe this is where the "global buffers pool" API could come into play.

I just wouldn't necessarily bind it to "global buffer pools."

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
