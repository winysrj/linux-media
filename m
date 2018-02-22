Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33974 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753719AbeBVMlJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 07:41:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
Date: Thu, 22 Feb 2018 14:41:52 +0200
Message-ID: <1557033.P9RvW324FW@avalon>
In-Reply-To: <247e07b2-6d21-331a-53d5-3bade8beec51@xs4all.nl>
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se> <20180221210140.qf77u5yf6ja6cmdi@valkosipuli.retiisi.org.uk> <247e07b2-6d21-331a-53d5-3bade8beec51@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday, 22 February 2018 10:01:13 EET Hans Verkuil wrote:
> On 02/21/2018 10:01 PM, Sakari Ailus wrote:
> > On Wed, Feb 21, 2018 at 10:16:25PM +0200, Laurent Pinchart wrote:
> >> No, I'm sorry, for MC-based drivers this isn't correct. The media entity
> >> that symbolizes the DMA engine indeed has a sink pad, but it's a video
> >> node, not a subdev. It thus has no media bus format configured for its
> >> sink pad. The closest pad in the pipeline that has a media bus format is
> >> the source pad of the subdev connected to the video node.
> >> 
> >> There's no communication within the kernel at G/S_FMT time between the
> >> video node and its connected subdev. The only time we look at the
> >> pipeline as a whole is when starting the stream to validate that the
> >> pipeline is correctly configured. We thus have to implement G/S_FMT on
> >> the video node without any knowledge about the connected subdev, and
> >> thus accept any colorspace.
> > 
> > A few more notes related to this --- there's no propagation of sub-device
> > format across the entities; there were several reasons for the design
> > choice. The V4L2 pixel format in the video node must be compatible with
> > the sub-device format when streaming is started. And... the streaming will
> > start in the pipeline defined by the enabled links to/from the video node.
> > In principle nothign prevents having multiple links there, and at the time
> > S_FMT IOCTL is called on the video node, none of those links could be
> > enabled. And that's perfectly valid use of the API.
> > 
> > A lot of the DMA engine drivers are simply devices that receive data and
> > write that to system memory, they really don't necessarily know anything
> > else. For the hardware this data is just pixels (or even bits, especially
> > in the case of CSI-2!).
> 
> Not in my experience. Most DMA engines I've ever worked with can do at
> least quantization and RGB <-> YUV conversions. Which is pretty much
> required functionality if you work with video receivers.

That's because you have a coarser view of the hardware in the PC world, where 
the RGB <-> YUV converter and DMA engine are bundled in a single block in 
documentation. In the embedded world a DMA engine is just a DMA engine. There 
is in many cases a RGB <-> YUV converter just before the DMA engine, but it's 
then usually exposed as a subdevice separate from the video node.

> And in order to program that correctly in the DMA engine you have to
> know what you receive.

Depending on the hardware I'm fine letting driver authors decide whether to 
expose the RGB <-> YUV conversion as a separate subdev, or as part of the 
video node. In the latter case the video node implementation will need to 
program the RGB <-> YUV conversion hardware based on the output pixel format 
and input media bus format. This can be done without any issue at stream on 
time: the video node implementation can access the format of the connected 
source pad in the pipeline when starting the stream, as links are configured 
and frozen at that time. What the video node implementation can't do is access 
that information at G/S_FMT time, as G/S_FMT on both subdevs and video nodes 
must be contained to a single entity when using MC-based drivers.

> Full-fledged colorspace converters that can convert between different
> colorspaces and transfer functions are likely to be separate subdevs
> due to the complexity of that.
> 
> > So I agree with Laurent here that requiring correct colour space for
> > [GS]_FMT IOCTLs on video nodes in the general case is not feasible
> > (especially on MC-centric devices), due to the way the Media controller
> > pipeline and formats along that pipeline are configured and validated
> > (i.e. at streamon time).
> > 
> > But what to do here then? The colourspace field is not verified even in
> > link validation so there's no guarantee it's correctly set more or less
> > anywhere else than in the source of the stream. And if the stream has
> > multiple sources with different colour spaces, then what do you do? That's
> > perhaps a theoretical case but the current frameworks and APIs do in
> > principle support that.
> 
> It's not theoretical at all. But anyway, in that case it is up to userspace
> to decide. A typical example is an sRGB OSD on top of a Rec.709 video.
> 
> In practice the differences in color at too small to be a problem, you'd
> just use Rec. 709 and slight color differences in the sRGB OSD is not
> something that is noticeable. But with HDR and BT.2020 this becomes much
> more complicated.
> 
> However, that is out of scope of the kernel driver.

What I believe should be in scope for the kernel driver is reporting correct 
colorspace information. Once a pipeline is correctly configured for streaming, 
the colorspace reported by G_FMT on a capture video node should correspond to 
the colorspace of the data that will be written to memory. That's why we 
validate pipelines at stream on time: even if the device would work exactly 
the same way with a wrong colorspace set on the video node, an application 
that calls G_FMT would see a colorspace that doesn't correspond to reality. Of 
course the application can walk up the pipeline and check the colorspace on 
the sensor at the input, but I think we need to keep parameters valid across 
the whole pipeline to avoid confusion in userspace.

To summarize my position, in the VIN case, we need to accept any colorspace at 
S_FMT time, as the DMA engine is colorspace-agnostic and doesn't know at S_FMT 
time what it will receive, and validate the configured colorspace at stream on 
time to ensure that userspace receives consistent information.

> > Perhaps we should specify that the user should always set the same
> > colourspace on the sink end of a link that was there in the source? The
> > same should likely apply to the rest of the fields apart from width,
> > height and code, too. Before the user configures formats this doesn't work
> > though, and this does not address the matter with v4l2-compliance.
> > 
> > Granted that the drivers will themselves handle the colour space
> > information correctly, it'd still provide a way for the user to gain the
> > knowledge of the colour space which I believe is what matters.
> 
> Urgh. It's really wrong IMHO that the DMA engine's input pad can't be
> configured. It's inconsistent. I don't think we ever thought this through
> properly.

The video node is an entity but isn't a subdev, so it has pads, but no media 
bus format exposed there. And frankly I don't think that's an issue. Today we 
do the following.

1. In the VIDIOC_S_FMT handler, accept any colorspace, as we can't know what 
we will be fed (as explained above and a few times before, S_FMT is contained 
in a single entity, it doesn't follow links inside the kernel).

2. At stream on time, validate the input link to verify that the colorspace on 
the connected subdev's source pad is identical to the colorspace on the video 
node.

If we could configure the media bus format on the sink pad of the video node, 
we would

1. Require userspace to set the format on the sink pad. We would need to 
accept any colorspace there too (again we can't know what we will be fed).

2. In the VIDIOC_S_FMT handler, validate the passed colorspace to verify it is 
identical to the colorspace configured on the sink pad.

3. At stream on time, validate the input link to verify that the colorspace on 
the connected subdev's source pad is identical to the colorspace on the video 
node's sink pad.

Why would that be better ? In both cases we need to accept any colorspace at 
S_FMT time (on the video node in the first case, on the video node's sink pad 
in the second case) and validate it at stream on time.

> Let me first fix all the other compliance issues and then I'll have to get
> back to this. It's a mess.

How do we move forward with VIN though ? I don't think we should block the 
driver due to this.

-- 
Regards,

Laurent Pinchart
