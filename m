Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34946 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbdAWXIw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 18:08:52 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
Subject: Re: [PATCH v3 00/24] i.MX Media Driver
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <c6e98327-7e2c-f34a-2d23-af7b236de441@xs4all.nl>
 <1484929911.2897.70.camel@pengutronix.de>
 <3fb68686-9447-2d8a-e2d2-005e4138cd43@gmail.com>
 <5d23d244-aa0e-401c-24a9-07f28acf1563@xs4all.nl>
 <1485169204.2874.57.camel@pengutronix.de>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <ce2d1851-8a2e-ea0b-25b8-be6649b1ebaf@gmail.com>
Date: Mon, 23 Jan 2017 15:08:48 -0800
MIME-Version: 1.0
In-Reply-To: <1485169204.2874.57.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/23/2017 03:00 AM, Philipp Zabel wrote:
> On Fri, 2017-01-20 at 21:39 +0100, Hans Verkuil wrote:
> [...]
>>> There is a VDIC entity in the i.MX IPU that performs de-interlacing with
>>> hardware filters for motion compensation. Some of the motion compensation
>>> modes ("low" and "medium" motion) require that the VDIC receive video
>>> frame fields from memory buffers (dedicated dma channels in the
>>> IPU are used to transfer those buffers into the VDIC).
>>>
>>> So one option to support those modes would be to pass the raw buffers
>>> from a camera sensor up to userspace to a capture device, and then pass
>>> them back to the VDIC for de-interlacing using a mem2mem device.
>>>
>>> Philipp and I are both in agreement that, since userland is not interested
>>> in the intermediate interlaced buffers in this case, but only the final
>>> result (motion compensated, de-interlaced frames), it is more efficient
>>> to provide a media link that allows passing those intermediate frames
>>> directly from a camera source pad to VDIC sink pad, without having
>>> to route them through userspace.
>>>
>>> So in order to support that, I've implemented a simple FIFO dma buffer
>>> queue in the driver to allow passing video buffers directly from a source
>>> to a sink. It is modeled loosely off the vb2 state machine and API, but
>>> simpler (for instance it only allows contiguous, cache-coherent buffers).
>>>
>>> This is where Philipp has an argument, that this should be done with a
>>> new API in videobuf2.
> That is one part of the argument. I'm glad to understand now that we
> agree about this.
>
>>> And I'm actually in total agreement with that. I definitely agree that there
>>> should be a mechanism in the media framework that allows passing video
>>> buffers from a source pad to a sink pad using a software queue, with no
>>> involvement from userland.
> That is the other part of the argument. I do not agree that these
> software queue "links" should be presented to userspace as media pad
> links between two entities of a media device.
> First, that would limit the links to subdevices contained in the same
> media graph, while this should work between any two capture and output
> queues of different devices.

It sounds like we are talking about two different new proposed features.

My proposal is to implement a software buffer queue between pads.
Beyond enabling the link between pads using the existing media controller
API, userspace is not involved after that. The fact that this link is 
accomplished
with a software buffer queue is not known, and doesn't need to be known,
by userspace.

Your proposal, if I have it right, is to allow linking two v4l2 device 
vb2 queues
(i.e. /dev/videoX -> /dev/videoY), using a new user level API, in a free-run
mode such that v4l2 buffers get passed from one device's vb2 queue to the
other without requiring the v4l2 user program to actively forward those 
buffers.

There isn't anything that would preclude one from the other, they can
both exist. But they are different ideas. One implements software queues
at the _pad level_ and is opaque to userspace, the other links queues
at the _device level_ using a new user API, but once the link is 
established,
also does not require any involvement from userspace.

What I'm saying is we can do _both_.


> Assume for example, we want to encode the captured, deinterlaced video
> to h.264 with the coda VPU driver. A software queue link could be
> established between the CSI capture and the VDIC deinterlacer input,

That's already available in the media graph. By linking CSI and
VDIC entities. The capture device will then already be providing
de-interlaced video, and ...

> just as between the VDIC deinterlacer output and the coda VPU input.
> Technically, there would be no difference between those two linked
> capture/output queue pairs. But the coda driver is a completely separate
> mem2mem device. And since it is not part of the i.MX media graph, there
> is no entity pad to link to.

your free-run queue linking could then be used to link the (already)
de-interlaced stream to the coda device for h.264 encode.

The other idea would be to eventually make the coda device part of
the media graph as an entity. Then this link would instead be via pads.

> Or assume there is an USB analog capture device that produces interlaced
> frames. I think it should be possible to connect its capture queue to
> the VDIC deinterlacer output queue just the same way as linking the CSI
> to the VDIC (in software queue mode).

Right, for devices that are outside the i.MX media graph, such as a USB
capture device (or coda), access to the i.MX entities such as the VDIC would
require an i.MX mem2mem device with media links to the VDIC. The USB
capture device would forward its captured frames to mem2mem (maybe
using your free-run vb2 queue linking idea):

usb device -> i.mx mem2mem device -> VDIC entity -> i.mx mem2mem device



> Second, the subdevice pad formats describe wire formats, not memory
> formats. The user might want to choose between 4:2:2 and 4:2:0
> subsampled YUV formats for the intermediate buffer, for example,
> depending on memory bandwidth constraints and quality requirements. This
> is impossible with the media entity / subdevice pad links.

It's true that there are currently no defined planar media bus
pixel formats. We just need to add new definitions for them. Once
that is done, the media driver will support planar YUV formats
simply by adding the new codes to imx_media_formats[].

Perhaps this gets to the root of the issue.

Is the media bus concept an abstract one, or is the media bus
intended to represent actual physical buses (as the lack of planar
media bus formats would imply)?

Can we break with the physical-bus-only idea if that is the case, and
loosen the definition of a media bus to mean the passage of media
data from one pad to another by whatever means?

In my view the idea of a physical bus at the sensor makes sense, but
beyond that, keeping that restriction limits how data can pass between
pads.

Hans, any input here?

If this is really anathema, then I'm willing to remove the software queues
between pads, but it will be giving up some functionality in the media 
driver.
It would also mean splitting the VDIC in two. The VDIC entity would be 
limited
to only one motion compensation mode, and the full functionality would have
to be added somewhere else. Currently all functionality of the VDIC is
implemented in a single media entity.

> I think an interface where userspace configures the capture and output
> queues via v4l2 API, passes dma buffers around from one to the other
> queue, and then puts both queues into a free running mode would be a
> much better fit for this mechanism.

As I said, I see these as two different ideas that can both be
implemented.

>>> My only disagreement is when this should be implemented. I think it is
>>> fine to keep my custom implementation of this in the driver for now. Once
>>> an extension of vb2 is ready to support this feature, it would be fairly
>>> straightforward to strip out my custom implementation and go with the
>>> new API.
>> For a staging driver this isn't necessary, as long as it is documented in
>> the TODO file that this needs to be fixed before it can be moved out of
>> staging. The whole point of staging is that there is still work to be
>> done in the driver, after all :-)
> Absolutely. The reason I am arguing against merging the mem2mem media
> control links so vehemently is that I am convinced the userspace
> interface is wrong, and I am afraid that even though in staging, it
> might become established.

I don't believe there is anything wrong with the userspace interface,
In fact it hasn't even changed. The fact two pads are passing memory
buffers is "under the hood".

Steve



