Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44493 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750939AbdAXL2c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Jan 2017 06:28:32 -0500
Message-ID: <1485257269.3600.96.camel@pengutronix.de>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Tue, 24 Jan 2017 12:27:49 +0100
In-Reply-To: <ce2d1851-8a2e-ea0b-25b8-be6649b1ebaf@gmail.com>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
         <c6e98327-7e2c-f34a-2d23-af7b236de441@xs4all.nl>
         <1484929911.2897.70.camel@pengutronix.de>
         <3fb68686-9447-2d8a-e2d2-005e4138cd43@gmail.com>
         <5d23d244-aa0e-401c-24a9-07f28acf1563@xs4all.nl>
         <1485169204.2874.57.camel@pengutronix.de>
         <ce2d1851-8a2e-ea0b-25b8-be6649b1ebaf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve, Hans,

[added Laurent to Cc: who I believe might have an opinion on the media
bus formats, too. Sorry for the wall of text, I have put a marker where
the MEDIA_BUS argument starts]

The central issue seems to be that I think media pad links / media bus
formats should describe physical links, such as parallel or serial
buses, and the formats of pixels flowing through them, whereas Steve
would like to extend them to describe software transports and in-memory
formats.

On Mon, 2017-01-23 at 15:08 -0800, Steve Longerbeam wrote:
[...]
> >>> And I'm actually in total agreement with that. I definitely agree that there
> >>> should be a mechanism in the media framework that allows passing video
> >>> buffers from a source pad to a sink pad using a software queue, with no
> >>> involvement from userland.
> > That is the other part of the argument. I do not agree that these
> > software queue "links" should be presented to userspace as media pad
> > links between two entities of a media device.
> > First, that would limit the links to subdevices contained in the same
> > media graph, while this should work between any two capture and output
> > queues of different devices.
> 
> It sounds like we are talking about two different new proposed features.

We are talking about the same thing, but we both want a different user
interface.
Technically, the issue is to trigger the DMA read channel of a mem2mem
device automatically whenever another capture device's DMA write channel
signals a finished frame. Where we disagree is how to present this to
userspace.

You represent the capture DMA write channel and mem2mem DMA read channel
as pads on media entites and configure the in-kernel software queue
between the two using a media pad link. At the same time a different
representation of the same DMA write and read channels (the capture
vb2_queue of the capture device and the output vb2_queue of the mem2mem
device) would be used for operation in the classic, userspace controlled
mode via dmabuf passing.

I don't want the software-only link in the media graph, but instead use
the vb2_queue representation for both cases, and implement the in-kernel
queue link on top of the vb2_queue interface. This would allow userspace
to have control over buffer allocations and format, and thus avoid
unexpected performance implications: it is impossible for userspace to
understand which media entity link, when enabled, will cause a
significant increase in memory bandwidth usage, or even how much.
Also the same mechanism could then be used to link any two devices in a
generic manner, instead of special casing the software queue link for
two devices that happen to be part of the same media graph.

> My proposal is to implement a software buffer queue between pads.
> Beyond enabling the link between pads using the existing media controller
> API, userspace is not involved after that. The fact that this link is 
> accomplished with a software buffer queue is not known, and doesn't
> need to be known, by userspace.

I don't think this is a good thing for the reasons stated above and
below:
Since the software buffer queue is opaque to userspace, it is completely
out of userspace control which format is chosen and how the buffers are
allocated.
By using media bus formats to configure software links the kernel
pretends to userspace that there is a physical connection where there
isn't one.
Also, the media entity graph would quickly become very unreadable if we
were to add all devices to it that could reasonably be linked with
software queues.

> Your proposal, if I have it right, is to allow linking two v4l2 device 
> vb2 queues
> (i.e. /dev/videoX -> /dev/videoY), using a new user level API, in a free-run
> mode such that v4l2 buffers get passed from one device's vb2 queue to the
> other without requiring the v4l2 user program to actively forward those 
> buffers.

Yes.

> There isn't anything that would preclude one from the other, they can
> both exist. But they are different ideas. One implements software queues
> at the _pad level_ and is opaque to userspace, the other links queues
> at the _device level_ using a new user API, but once the link is 
> established, also does not require any involvement from userspace.

Well, they are different ideas of how the userspace interface _for the
same thing_ should look like.

> What I'm saying is we can do _both_.

What I am saying is we shouldn't do the pad link interface for the
software queues. In my opinion it is the wrong abstraction, and apart
from the convenience of being able to switch the links on with a single
media-ctl invocation, I see too many downsides.

> > Assume for example, we want to encode the captured, deinterlaced video
> > to h.264 with the coda VPU driver. A software queue link could be
> > established between the CSI capture and the VDIC deinterlacer input,
> 
> That's already available in the media graph. By linking CSI and
> VDIC entities. The capture device will then already be providing
> de-interlaced video, and ...

I know it is in your code. That is the cause for my concern. The link
between CSI and VDIC entity should only describe the direct physical
connection through the VDIC FIFO1 in my opinion.
For the indirect CSI -> SMFC -> IDMAC -> RAM, RAM -> IDMAC -> VDIC
software queue, I would strongly prefer to use linked vb2_queues instead
of the media entity link.

> > just as between the VDIC deinterlacer output and the coda VPU input.
> > Technically, there would be no difference between those two linked
> > capture/output queue pairs. But the coda driver is a completely separate
> > mem2mem device. And since it is not part of the i.MX media graph, there
> > is no entity pad to link to.
> 
> your free-run queue linking could then be used to link the (already)
> de-interlaced stream to the coda device for h.264 encode.

Yes, and I see no reason why that should use a different interface than
what is exactly the same process between CSI and VDIC.

> The other idea would be to eventually make the coda device part of
> the media graph as an entity. Then this link would instead be via pads.

I would only want to do this if there was a direct connection between
the IPU FIFOs and the coda VPU device somehow. But since the devices are
completely separate, they should be described as such.

> > Or assume there is an USB analog capture device that produces interlaced
> > frames. I think it should be possible to connect its capture queue to
> > the VDIC deinterlacer output queue just the same way as linking the CSI
> > to the VDIC (in software queue mode).
> 
> Right, for devices that are outside the i.MX media graph, such as a USB
> capture device (or coda), access to the i.MX entities such as the VDIC would
> require an i.MX mem2mem device with media links to the VDIC. The USB
> capture device would forward its captured frames to mem2mem (maybe
> using your free-run vb2 queue linking idea):
> 
> usb device -> i.mx mem2mem device -> VDIC entity -> i.mx mem2mem device

The VDIC doesn't have a direct to memory channel, so that would be
mem2mem -> VDIC -> IC -> mem2mem, I think?

========== MEDIA_BUS formats below =====================================

> > Second, the subdevice pad formats describe wire formats, not memory
> > formats. The user might want to choose between 4:2:2 and 4:2:0
> > subsampled YUV formats for the intermediate buffer, for example,
> > depending on memory bandwidth constraints and quality requirements. This
> > is impossible with the media entity / subdevice pad links.
> 
> It's true that there are currently no defined planar media bus
> pixel formats. We just need to add new definitions for them. Once
> that is done, the media driver will support planar YUV formats
> simply by adding the new codes to imx_media_formats[].

I am not comfortable with starting to mix MEDIA_BUS_FMT and V4L2_PIX_FMT
this way.

> Perhaps this gets to the root of the issue.
> 
> Is the media bus concept an abstract one, or is the media bus
> intended to represent actual physical buses (as the lack of planar
> media bus formats would imply)?

Yes, maybe that is the root of our disconnect. As I understand it, the
media bus formats are describing "image formats as flowing over physical
busses" [1].

[1] Linux Media Subsystem Documentation, Chapter 4.15.3.4.1.1. Media Bus Pixel Codes
    https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/subdev-formats.html?highlight=media%20bus#v4l2-mbus-pixelcode

I would like to keep it that way and not soften up that description.

> Can we break with the physical-bus-only idea if that is the case, and
> loosen the definition of a media bus to mean the passage of media
> data from one pad to another by whatever means?
> 
> In my view the idea of a physical bus at the sensor makes sense, but
> beyond that, keeping that restriction limits how data can pass between
> pads.
> 
> Hans, any input here?
> 
> If this is really anathema, then I'm willing to remove the software queues
> between pads, but it will be giving up some functionality in the media 
> driver.

So far I am the only one arguing against this, and I haven't yet heard
anything yet that would have convinced me otherwise. That's why I'd too
like some more input on this issue.

Certainly removing the controversial pad link controlled software queues
would remove the point of contention. I think losing some functionality
(in this case "higher quality" deinterlacing without userspace
intervention) for now would be worth it to achieve consensus, and also
reduce the list of things that have to be done for this driver to leave
staging, but that is of course from the point of view of the guy arguing
against that interface.

> It would also mean splitting the VDIC in two. The VDIC entity would be
> limited to only one motion compensation mode,

Currently, yes. That direct mode is the only one that should be
described by the media pad link between CSI and VDIC in my opinion.

> and the full functionality would have
> to be added somewhere else.

I don't understand why the other functionality would necessarily have to
live somewere else, but I can see that it might make sense to do so. In
any case, the separate control of the VDIC/IC via a mem2mem video device
will be needed anyway, as pointed out in the USB example above, or to
deinterlace streams received via network or played back from files.

>  Currently all functionality of the VDIC is implemented in a single media entity.

Yes, at least the mem2mem part should move into its own mem2mem video
device.

> > I think an interface where userspace configures the capture and output
> > queues via v4l2 API, passes dma buffers around from one to the other
> > queue, and then puts both queues into a free running mode would be a
> > much better fit for this mechanism.
> 
> As I said, I see these as two different ideas that can both be
> implemented.

I think we should have cleared up now where we disagree. These are two
different ideas for userspace interfaces for the same functionality. My
opinion is that both should not be implemented

> >>> My only disagreement is when this should be implemented. I think it is
> >>> fine to keep my custom implementation of this in the driver for now. Once
> >>> an extension of vb2 is ready to support this feature, it would be fairly
> >>> straightforward to strip out my custom implementation and go with the
> >>> new API.
> >> For a staging driver this isn't necessary, as long as it is documented in
> >> the TODO file that this needs to be fixed before it can be moved out of
> >> staging. The whole point of staging is that there is still work to be
> >> done in the driver, after all :-)
> > Absolutely. The reason I am arguing against merging the mem2mem media
> > control links so vehemently is that I am convinced the userspace
> > interface is wrong, and I am afraid that even though in staging, it
> > might become established.
> 
> I don't believe there is anything wrong with the userspace interface,
> In fact it hasn't even changed. The fact two pads are passing memory
> buffers is "under the hood".

Which I disagree with. Doing things like this under the hood would be
fine only if they were properly introspectable and if the interface
wouldn't break assumptions that I believe to be there, such as media
links describing physical connections between hardware entities, and
media bus formats describing the image format on a physical bus.
Also with videobuf2 we already have a userspace interface for DMA read
and write queues, and I'd prefer to extend and improve that instead of
reimplementing the same functionality, even simplified, under the hood.

regards
Philipp

