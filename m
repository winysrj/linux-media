Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43411 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1BRMgc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 07:36:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
Date: Fri, 18 Feb 2011 13:36:27 +0100
Cc: Michal Nazarewicz <mina86@mina86.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>
References: <4D5D9B57.3090809@gmail.com> <201102181131.30920.laurent.pinchart@ideasonboard.com> <4D5E6708.9000500@infradead.org>
In-Reply-To: <4D5E6708.9000500@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181336.28766.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Friday 18 February 2011 13:33:12 Mauro Carvalho Chehab wrote:
> Em 18-02-2011 08:31, Laurent Pinchart escreveu:
> > It's a trade-off between memory and speed. Preallocating still image
> > capture buffers will give you better snapshot performances, at the
> > expense of memory.
> > 
> > The basic problems we have here is that taking snapshots is slow with the
> > current API if we need to stop capture, free buffers, change the format,
> > allocate new buffers (and perform cache management operations) and
> > restart the stream. To fix this we're considering a way to preallocate
> > still image capture buffers, but I'm open to proposals for other ways to
> > solve the issue :-)
> 
> From the above operations, considering that CMA is used to reserve a
> non-shared memory with enough space for the new buffer size/qtd, I don't
> think that the most expensive operation would be to realloc the memory.
> 
> The logic to stop/start streaming seems to be the most consuming one, as
> driver will need to wait for the current I/O operation to complete, and
> this can take hundreds of milisseconds (the duration of one frame).
> 
> How much time would CMA need to free and re-allocate the buffers for, let's
> say, something in the range of 1-10 MB, on a pre-allocated, non shared
> memory space?

CMA won't solve the problem, as not all drivers require continuous memory. The 
OMAP3 ISP has an IOMMU, and two very time-consuming tasks are mapping the 
memory to the IOMMU and cleaning the cache. This is why preallocation *and* 
prequeuing is needed.

-- 
Regards,

Laurent Pinchart
