Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49039 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab1BRNV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 08:21:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Michal Nazarewicz" <mina86@mina86.com>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
Date: Fri, 18 Feb 2011 14:21:53 +0100
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Hans Verkuil" <hansverk@cisco.com>, "Qing Xu" <qingx@marvell.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Neil Johnson" <realdealneil@gmail.com>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>,
	"Uwe Taeubert" <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>
References: <4D5D9B57.3090809@gmail.com> <201102181357.26382.laurent.pinchart@ideasonboard.com> <op.vq3om6es3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <op.vq3om6es3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181421.54063.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michal,

On Friday 18 February 2011 14:19:44 Michal Nazarewicz wrote:
> On Fri, 18 Feb 2011 13:57:25 +0100, Laurent Pinchart wrote:
> > On Friday 18 February 2011 12:37:24 Michal Nazarewicz wrote:
> > 
> > [snip]
> > 
> >> What I'm trying to say is that it would be best if one could configure
> >> the device in such a way that switching between modes would not require
> >> the device to free buffers (even though in user space they could be
> >> inaccessible).
> >> 
> >> 
> >> This is what I have in mind the usage would look like:
> >> 
> >> 1. Open device
> >> 
> >> 		Kernel creates some control structures, the usual stuff.
> >> 
> >> 2. Initialize multi-format (specifying what formats user space will
> >> use).
> >> 
> >> 		Kernel calculates amount of memory needed for the most
> >> 		demanding format and allocates it.
> > 
> > Don't forget that applications can also use USERPTR. We need a
> > low-latency solution for that as well.
> 
> That would probably work best if user provided one big buffer.  Again,
> I don't know how this maps to V4L API.
> 
> >> 3. Set format (restricted to one of formats specified in step 2)
> >> 
> >> 		Kernel has memory already allocated, so it only needs to split
> >> 		it to buffers needed in given format.
> >> 
> >> 4. Allocate buffers.
> >> 
> >> 		Kernel allocates memory needed for most demanding format
> >> 		(calculated in step 2).
> >> 		Once memory is allocated, splits it to buffers needed in
> >> 		given format.
> >> 
> >> 5. Do the loop... queue, dequeue, all the usual stuff.
> >> 
> >> 		Kernel instructs device to handle buffers, the usual stuff.
> > 
> > When buffers are queued cache needs to be cleaned. This is an expensive
> > operation, and we need to be able to pre-queue (or at least pre-clean)
> > buffers.
> 
> Cache operations are always needed, aren't they?  Whatever you do, you
> will always have to handle cache coherency (in one way or another) so
> there's nothing we can do about it, or is there?

To achieve low latency still image capture, you need to minimize the time 
spent reconfiguring the device from viewfinder to still capture. Cache 
cleaning is always needed, but you can prequeue buffers you can clean the 
cache in advance, avoiding an extra delay when the user presses the still 
image capture button.

> >> 6. Free buffers.
> >> 
> >> 		Kernel space destroys the buffers needed for given format
> >> 		but DOES NOT free memory.
> >> 
> >> 7. If not done, go to step 3.
> >> 
> >> 8. Finish multi-format mode.
> >> 
> >> 		Kernel actually frees the memory.
> >> 
> >> 9. Close the device.
> >> 
> >> A V4L device driver could just ignore step 2 and 7 and work in the less
> >> optimal mode.
> >> 
> >> If I understand V4L2 correctly, the API does not allow for step 2 and 8.
> >> In theory, they could be merged with step 1 and 9 respectively, I don't
> >> know id that feasible though.

-- 
Regards,

Laurent Pinchart
