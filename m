Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54562 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbcFVQup (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 12:50:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 1/4] v4l: Add metadata buffer type and format
Date: Wed, 22 Jun 2016 19:51:06 +0300
Message-ID: <1591724.fl6z3cA6YR@avalon>
In-Reply-To: <20160524162632.GG26360@valkosipuli.retiisi.org.uk>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <5744750A.5070205@xs4all.nl> <20160524162632.GG26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday 24 May 2016 19:26:32 Sakari Ailus wrote:
> On Tue, May 24, 2016 at 05:36:42PM +0200, Hans Verkuil wrote:
> > On 05/24/2016 05:28 PM, Sakari Ailus wrote:
> > > Hi Hans,
> > > 
> > >> Should it be mentioned here that changing the video format might change
> > >> the buffersize? In case the buffersize is always a multiple of the
> > >> width?
> > > 
> > > Isn't that the case in general, as with pixel formats? buffersize could
> > > also be something else than a multiple of width (there's no width for
> > > metadata formats) due to e.g. padding required by hardware.
> > 
> > Well, I don't think it is obvious that the metadata buffersize depends on
> > the video width. Perhaps developers who are experienced with CSI know
> > this, but if you know little or nothing about CSI, then it can be
> > unexpected (hey, that was the case for me!).
> > 
> > I think it doesn't hurt to mention this relation.
> 
> Ah, I think I misunderstood you first.
> 
> Typically the metadata width is the same as the image data width, that's
> true. And it's how the hardware works. This is still visible in the media
> bus format and the solution belongs rather to how multiple streams over a
> single link are supported.

Let me clarify on this.

In the general case there's no concept of metadata width when stored in 
memory. The two most common use cases for metadata store register values (or 
similar) information, or statistics. The former is just a byte stream in some 
kind of TLV (Type Length Value) format. The latter a set of values or arrays 
computed either on the full image or on subwindows, possibly laid out as a 
grid.

When transported over a bus, however, metadata can sometimes have a width and 
height. That's the case for CSI-2, which is a line-oriented format. Metadata 
then need to be broken into chunks transmitted in a CSI-2 line packet, even if 
they don't correspond to a line of an image. The line width on the bus is just 
the number of bytes transmitted in a single packet, which could be chosen 
freely (within the range allowed by CSI-2). In practice, to simplify the 
implementation, the line width is chosen to be identical to the line width of 
the image frames that the metadata correspond to, but that's not a requirement 
of either CSI-2 or the metadata format itself.

We thus need to expose metadata width and height on subdevs to ensure proper 
configuration of the transmitter and receiver, but that's not strictly 
mandatory on video nodes.

The metadata buffer size itself doesn't depend on the width and height of the 
corresponding image frames. A histogram using 64 bins on 3 components will be 
stored exactly the same way regardless of whether it's computed on a VGA or 
1080p frame. The buffer size depends on the configuration of the metadata 
source only, which in the case of the histogram generator in the VSP would 
include a control that decides whether to compute the histogram with 64 bins 
or 256 bins (the latter needs a 4 times larger buffer).

For metadata computed on a variable number of subwindows the buffer size will 
depend on the number of subwindows, which will in turn be possibly influenced 
by the size of the image. It could make sense to use fewer subwindows to 
compute AF data on a VGA image than on a 4k image. That is not however a 
requirement, and there's no direct mapping between image size and metadata 
size, the number of subwindows being usually configured by userspace.

I hope this clarifies the problem. Please let me know if you have additional 
questions or thoughts, and if you see anything that should be worded 
differently in the documentation (or even structures that should get new 
fields).

> It's just that setting the image media bus format affects the metadata media
> bus format. I guess that could be mentioned albeit it's hardware specific,
> on some sensors metadata width is independent of the image width. Even then
> this is not where I'd put it. I'd get back to the topic when documenting
> how the API for multiple streams over a single link works.

-- 
Regards,

Laurent Pinchart

