Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56570 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996AbcFXXPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 19:15:47 -0400
Date: Sat, 25 Jun 2016 02:15:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 1/4] v4l: Add metadata buffer type and format
Message-ID: <20160624231542.GU24980@valkosipuli.retiisi.org.uk>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <5744750A.5070205@xs4all.nl>
 <20160524162632.GG26360@valkosipuli.retiisi.org.uk>
 <1591724.fl6z3cA6YR@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591724.fl6z3cA6YR@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Jun 22, 2016 at 07:51:06PM +0300, Laurent Pinchart wrote:
> Hello,
> 
> On Tuesday 24 May 2016 19:26:32 Sakari Ailus wrote:
> > On Tue, May 24, 2016 at 05:36:42PM +0200, Hans Verkuil wrote:
> > > On 05/24/2016 05:28 PM, Sakari Ailus wrote:
> > > > Hi Hans,
> > > > 
> > > >> Should it be mentioned here that changing the video format might change
> > > >> the buffersize? In case the buffersize is always a multiple of the
> > > >> width?
> > > > 
> > > > Isn't that the case in general, as with pixel formats? buffersize could
> > > > also be something else than a multiple of width (there's no width for
> > > > metadata formats) due to e.g. padding required by hardware.
> > > 
> > > Well, I don't think it is obvious that the metadata buffersize depends on
> > > the video width. Perhaps developers who are experienced with CSI know
> > > this, but if you know little or nothing about CSI, then it can be
> > > unexpected (hey, that was the case for me!).
> > > 
> > > I think it doesn't hurt to mention this relation.
> > 
> > Ah, I think I misunderstood you first.
> > 
> > Typically the metadata width is the same as the image data width, that's
> > true. And it's how the hardware works. This is still visible in the media
> > bus format and the solution belongs rather to how multiple streams over a
> > single link are supported.
> 
> Let me clarify on this.
> 
> In the general case there's no concept of metadata width when stored in 
> memory. The two most common use cases for metadata store register values (or 
> similar) information, or statistics. The former is just a byte stream in some 

In general case perhaps not.

But in specific cases such as sensor produced embedded data is indeed
line-based, with each line having a preable and a predetermined amount of
data after the preamble. In this respect it's very much like image data.

> kind of TLV (Type Length Value) format. The latter a set of values or arrays 
> computed either on the full image or on subwindows, possibly laid out as a 
> grid.
> 
> When transported over a bus, however, metadata can sometimes have a width and 
> height. That's the case for CSI-2, which is a line-oriented format. Metadata 
> then need to be broken into chunks transmitted in a CSI-2 line packet, even if 
> they don't correspond to a line of an image. The line width on the bus is just 
> the number of bytes transmitted in a single packet, which could be chosen 
> freely (within the range allowed by CSI-2). In practice, to simplify the 
> implementation, the line width is chosen to be identical to the line width of 
> the image frames that the metadata correspond to, but that's not a requirement 
> of either CSI-2 or the metadata format itself.
> 
> We thus need to expose metadata width and height on subdevs to ensure proper 
> configuration of the transmitter and receiver, but that's not strictly 
> mandatory on video nodes.

To support sensor embedded data, I think we do need bytesperline, width and
height. They might not be applicable to e.g. some types of statistics.

The rest looks good to me.

> 
> The metadata buffer size itself doesn't depend on the width and height of the 
> corresponding image frames. A histogram using 64 bins on 3 components will be 
> stored exactly the same way regardless of whether it's computed on a VGA or 
> 1080p frame. The buffer size depends on the configuration of the metadata 
> source only, which in the case of the histogram generator in the VSP would 
> include a control that decides whether to compute the histogram with 64 bins 
> or 256 bins (the latter needs a 4 times larger buffer).
> 
> For metadata computed on a variable number of subwindows the buffer size will 
> depend on the number of subwindows, which will in turn be possibly influenced 
> by the size of the image. It could make sense to use fewer subwindows to 
> compute AF data on a VGA image than on a 4k image. That is not however a 
> requirement, and there's no direct mapping between image size and metadata 
> size, the number of subwindows being usually configured by userspace.
> 
> I hope this clarifies the problem. Please let me know if you have additional 
> questions or thoughts, and if you see anything that should be worded 
> differently in the documentation (or even structures that should get new 
> fields).
> 
> > It's just that setting the image media bus format affects the metadata media
> > bus format. I guess that could be mentioned albeit it's hardware specific,
> > on some sensors metadata width is independent of the image width. Even then
> > this is not where I'd put it. I'd get back to the topic when documenting
> > how the API for multiple streams over a single link works.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
