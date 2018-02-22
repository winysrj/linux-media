Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50560 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751687AbeBVIBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 03:01:18 -0500
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se>
 <20180219222804.GD8442@bigcity.dyn.berto.se>
 <94142433-a72d-ddd4-22bc-b36380f4efbc@xs4all.nl> <2556801.UsItpXbr2P@avalon>
 <20180221210140.qf77u5yf6ja6cmdi@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <247e07b2-6d21-331a-53d5-3bade8beec51@xs4all.nl>
Date: Thu, 22 Feb 2018 09:01:13 +0100
MIME-Version: 1.0
In-Reply-To: <20180221210140.qf77u5yf6ja6cmdi@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/2018 10:01 PM, Sakari Ailus wrote:
> Hi Laurent and Hans,
> 
> On Wed, Feb 21, 2018 at 10:16:25PM +0200, Laurent Pinchart wrote:
>> No, I'm sorry, for MC-based drivers this isn't correct. The media entity that 
>> symbolizes the DMA engine indeed has a sink pad, but it's a video node, not a 
>> subdev. It thus has no media bus format configured for its sink pad. The 
>> closest pad in the pipeline that has a media bus format is the source pad of 
>> the subdev connected to the video node.
>>
>> There's no communication within the kernel at G/S_FMT time between the video 
>> node and its connected subdev. The only time we look at the pipeline as a 
>> whole is when starting the stream to validate that the pipeline is correctly 
>> configured. We thus have to implement G/S_FMT on the video node without any 
>> knowledge about the connected subdev, and thus accept any colorspace.
> 
> A few more notes related to this --- there's no propagation of sub-device
> format across the entities; there were several reasons for the design
> choice. The V4L2 pixel format in the video node must be compatible with the
> sub-device format when streaming is started. And... the streaming will
> start in the pipeline defined by the enabled links to/from the video node.
> In principle nothign prevents having multiple links there, and at the time
> S_FMT IOCTL is called on the video node, none of those links could be
> enabled. And that's perfectly valid use of the API.
> 
> A lot of the DMA engine drivers are simply devices that receive data and
> write that to system memory, they really don't necessarily know anything
> else. For the hardware this data is just pixels (or even bits, especially
> in the case of CSI-2!).

Not in my experience. Most DMA engines I've ever worked with can do at
least quantization and RGB <-> YUV conversions. Which is pretty much
required functionality if you work with video receivers.

And in order to program that correctly in the DMA engine you have to
know what you receive.

Full-fledged colorspace converters that can convert between different
colorspaces and transfer functions are likely to be separate subdevs
due to the complexity of that.

> So I agree with Laurent here that requiring correct colour space for
> [GS]_FMT IOCTLs on video nodes in the general case is not feasible
> (especially on MC-centric devices), due to the way the Media controller
> pipeline and formats along that pipeline are configured and validated (i.e.
> at streamon time).
> 
> But what to do here then? The colourspace field is not verified even in
> link validation so there's no guarantee it's correctly set more or less
> anywhere else than in the source of the stream. And if the stream has
> multiple sources with different colour spaces, then what do you do? That's
> perhaps a theoretical case but the current frameworks and APIs do in
> principle support that.

It's not theoretical at all. But anyway, in that case it is up to userspace
to decide. A typical example is an sRGB OSD on top of a Rec.709 video.

In practice the differences in color at too small to be a problem, you'd
just use Rec. 709 and slight color differences in the sRGB OSD is not something
that is noticeable. But with HDR and BT.2020 this becomes much more complicated.

However, that is out of scope of the kernel driver.

> 
> Perhaps we should specify that the user should always set the same
> colourspace on the sink end of a link that was there in the source? The
> same should likely apply to the rest of the fields apart from width, height
> and code, too. Before the user configures formats this doesn't work though,
> and this does not address the matter with v4l2-compliance.
> 
> Granted that the drivers will themselves handle the colour space
> information correctly, it'd still provide a way for the user to gain the
> knowledge of the colour space which I believe is what matters.
> 

Urgh. It's really wrong IMHO that the DMA engine's input pad can't be
configured. It's inconsistent. I don't think we ever thought this through
properly.

Let me first fix all the other compliance issues and then I'll have to get
back to this. It's a mess.

Regards,

	Hans
