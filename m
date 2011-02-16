Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:60628 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab1BPJCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Feb 2011 04:02:30 -0500
Date: Wed, 16 Feb 2011 10:02:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hansverk@cisco.com>
cc: Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
In-Reply-To: <201102160949.04605.hansverk@cisco.com>
Message-ID: <Pine.LNX.4.64.1102160954560.20711@axis700.grange>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange>
 <7BAC95F5A7E67643AAFB2C31BEE662D014042CB8F0@SC-VEXCH2.marvell.com>
 <Pine.LNX.4.64.1102160829490.20711@axis700.grange> <201102160949.04605.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans

Thanks for looking at it!

On Wed, 16 Feb 2011, Hans Verkuil wrote:

> Hi Guennadi,
> 
> Here is my take on this:
> 
> On Wednesday, February 16, 2011 08:42:51 Guennadi Liakhovetski wrote:

[snip]

> > > 3. Not liking either of the above, it seems we need yet a new API for
> > > this... How about extending VIDIOC_REQBUFS with a videobuf queue index,
> > > thus using up one of the remaining two 32-bit reserved fields? Then we
> > > need one more ioctl() like VIDIOC_BUFQ_SELECT to switch from one queue to
> > > another, after which setting frame format and queuing and dequeuing
> > > buffers will affect this currently selected queue. We could also keep
> > > REQBUFS as is and require BUFQ_SELECT to be called before it for any queue
> > > except the default 0.
> 
> What you really are doing here is creating the functionality of two video 
> nodes without actually making two nodes.
> 
> But from the point of view of the application it makes more sense to actually
> have two video nodes. The only difference is that when one starts streaming it
> pre-empts the other.

Well, I don't think I like it all that much... One reason - yes, two 
"independent" video device-nodes, which actually only can stream in turn 
seems somewhat counterintuitive to me, specifically, I don't think there 
is a way to tell the application about this. What if we have more than two 
video devices on the system? Or what if you need more than two video 
queues / formats? Or actually only one? The kernel doesn't know initially 
how many, this is a dynamic resource, not a fixed static interface, IMHO.

> Of course, implementing this correctly will probably require some changes in 
> videobuf2 to make it easy.
> 
> When it comes to the userspace API I wonder if we shouldn't add a 
> VIDIOC_STREAM_FRAMES(u32 framecnt), which streams just 'framecnt' frames. I 
> can imagine that it can be hard to stream just a single frame otherwise.

Don't think you actually need to take just 1 frame for still photography. 
As far as I understand, in many cases they anyway want to take several of 
them to then be able to choose the best one or do some processing. 
Regardless, maybe that ioctl() would make sense, but that's something 
slightly different from what we're trying to figure out here. Yes, it is 
also related to still photography, but it's addressing a different aspect 
of it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
