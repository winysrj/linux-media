Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55934 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbcEWNBI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 09:01:08 -0400
Date: Mon, 23 May 2016 15:00:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 0/4] Meta-data video device type
In-Reply-To: <20160513095242.GV26360@valkosipuli.retiisi.org.uk>
Message-ID: <Pine.LNX.4.64.1605231200170.18611@axis700.grange>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <57359DBE.4090904@xs4all.nl> <20160513095242.GV26360@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Fri, 13 May 2016, Sakari Ailus wrote:

> Hi Hans and Laurent,
> 
> On Fri, May 13, 2016 at 11:26:22AM +0200, Hans Verkuil wrote:
> > On 05/12/2016 02:17 AM, Laurent Pinchart wrote:
> > > Hello,
> > > 
> > > This RFC patch series is a second attempt at adding support for passing
> > > statistics data to userspace using a standard API.
> > > 
> > > The core requirements haven't changed. Statistics data capture requires
> > > zero-copy and decoupling statistics buffers from images buffers, in order to
> > > make statistics data available to userspace as soon as they're captured. For
> > > those reasons the early consensus we have reached is to use a video device
> > > node with a buffer queue to pass statistics buffers using the V4L2 API, and
> > > this new RFC version doesn't challenge that.
> > > 
> > > The major change compared to the previous version is how the first patch has
> > > been split in two. Patch 1/4 now adds a new metadata buffer type and format
> > > (including their support in videobuf2-v4l2), usable with regular V4L2 video
> > > device nodes, while patch 2/4 adds the new metadata video device type.
> > > Metadata buffer queues are thus usable on both the regular V4L2 device nodes
> > > and the new metadata device nodes.
> > > 
> > > This change was driven by the fact that an important category of use cases
> > > doesn't differentiate between metadata and image data in hardware at the DMA
> > > engine level. With such hardware (CSI-2 receivers in particular, but other bus
> > > types could also fall into this category) a stream containing both metadata
> > > and image data virtual streams is transmitted over a single physical link. The
> > > receiver demultiplexes, filters and routes the virtual streams to further
> > > hardware blocks, and in many cases, directly to DMA engines that are part of
> > > the receiver. Those DMA engines can capture a single virtual stream to memory,
> > > with as many DMA engines physically present in the device as the number of
> > > virtual streams that can be captured concurrently. All those DMA engines are
> > > usually identical and don't care about the type of data they receive and
> > > capture. For that reason limiting the metadata buffer type to metadata device
> > > nodes would require creating two device nodes for each DMA engine (and
> > > possibly more later if we need to capture other types of data). Not only would
> > > this make the API more complex to use for applications, it wouldn't bring any
> > > added value as the video and metadata device nodes associated with a DMA
> > > engine couldn't be used concurrently anyway, as they both correspond to the
> > > same hardware resource.
> > > 
> > > For this reason the ability to capture metadata on a video device node is
> > > useful and desired, and is implemented patch 1/4 using a dedicated video
> > > buffers queue. In the CSI-2 case a driver will create two buffer queues
> > > internally for the same DMA engine, and can select which one to use based on
> > > the buffer type passed for instance to the REQBUFS ioctl (details still need
> > > to be discussed here).
> > 
> > Not quite. It still has only one vb2_queue, you just change the type depending
> > on what mode it is in (video or meta data). Similar to raw vs sliced VBI.
> > 
> > In the latter case it is the VIDIOC_S_FMT call that changes the vb2_queue type
> > depending on whether raw or sliced VBI is requested. That's probably where I
> > would do this for video vs meta as well.
> > 
> > There is one big thing missing here: how does userspace know in this case whether
> > it will get metadata or video? Who decides which CSI virtual stream is routed
> 
> My first impression would be to say by formats, so that's actually defined
> by the user. The media bus formats do not have such separation between image
> and metadata formats either.

I'm still not sure whether we actually need different formats for 
metadata. E.g. on CSI-2 I expect metadata to use the 8-bit embedded 
non-image Data Type - on all cameras. So, what should the CSI-2 bridge 
sink pad be configured with? Some sensor-specific type or just a format, 
telling it what to capture on the CSI-2 bus?

> VIDIOC_ENUM_FMT should be amended with media bus code as well so that the
> user can figure out which format corresponds to a given media bus code.

I'm not sure what you mean by this correspondence, could you elaborate on 
this a bit, please?

> > to which video node?
> 
> I think that should be considered as a seprate problem, albeit it will
> require a solution as well. And it's a much biffer problem than this one.

Yes, we did want to revive the stream routing work, didn't we? ;-)

But let me add one more use-case for consideration: UVC. Some UVC cameras 
include per-frame (meta)data in the private part of the payload header, 
even though I don't find anything in the UVC spec, that would suggest that 
as an acceptable approach. A more standard-conform design seems to be to 
transfer metadata using some Stream Based Payload on a separate USB 
Interface and synchronise it with video data using the timing information 
from UVC packet headers? I imagine each manufacturer would use a different 
GUID for their metadata format. Do we really want to create a new FOURCC 
code for each of them? Or just configure the pads with a fixed format and 
configure routing? But if then a camera decides to support several 
metadata formats on a single Input Terminal, we would only be able to 
distinguish between them, using size, unless they all have the same size.

Thanks
Guennadi
