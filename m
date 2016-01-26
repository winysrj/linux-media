Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55027 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbcAZMtx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 07:49:53 -0500
Date: Tue, 26 Jan 2016 13:49:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aviv Greenberg <avivgr@gmail.com>
Subject: Re: per-frame camera metadata (again)
In-Reply-To: <5888039.Rc9CarTOsL@avalon>
Message-ID: <Pine.LNX.4.64.1601261321580.28816@axis700.grange>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange>
 <Pine.LNX.4.64.1601051214080.21342@axis700.grange>
 <Pine.LNX.4.64.1601251155160.20896@axis700.grange> <5888039.Rc9CarTOsL@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, 25 Jan 2016, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Monday 25 January 2016 12:14:14 Guennadi Liakhovetski wrote:
> > On Tue, 5 Jan 2016, Guennadi Liakhovetski wrote:
> > > On Fri, 1 Jan 2016, Guennadi Liakhovetski wrote:
> > >> On Sun, 27 Dec 2015, Laurent Pinchart wrote:
> > >>> On Thursday 24 December 2015 11:42:49 Guennadi Liakhovetski wrote:
> > >>>> Hi Laurent,
> > >>>> 
> > >>>> Let me put this at the top: So far it looks like we converge on two
> > >>>> possibilities:
> > >>>> 
> > >>>> (1) a separate video-device node with a separate queue. No
> > >>>> user-space visible changes are required apart from new FOURCC codes.
> > >>>> In the kernel we'd have to add some subdev API between the bridge
> > >>>> and the sensor drivers to let the sensor driver instruct the bridge
> > >>>> driver to use some of the data, arriving over the camera interface,
> > >>>> as metadata.
> > >>> 
> > >>> The interface should be more generic and allow describing how multiple
> > >>> channels (in terms of virtual channels and data types for CSI-2 for
> > >>> instance) are multiplexed over a single physical link. I'm not sure
> > >>> how to represent that at the media controller level, that's also one
> > >>> topic that needs to be researched.
> > >> 
> > >> Sure, agree. How about an enumetation style method, something like
> > >> .enum_mbus_streams()?
> 
> I'd rather not. The enumeration-style API isn't really a model of efficiency. 
> I'd prefer passing all the data in a single call.

Right, that idea has been abandoned by now.

> > > It now also occurs to me, that we currently configure pads with a single
> > > configuration - pixel format, resolution. However, a single CSI-2
> > > interface can transfer different frame formats at the same time. So, such
> > > a sensor driver has to export multiple source pads? The bridge driver
> > > would export multiple sink pads, then we don't need any new API methods,
> > > we just configure each link separately, for which we have to add those
> > > fields to struct v4l2_mbus_framefmt?
> >
> > It has been noted, that pads and links conceptually are designed to
> > represent physical interfaces and connections between then, therefore
> > representing a single CSI-2 link by multiple Media Controller pads and
> > links is wrong.
> >
> > As an alternative it has been proposed to implement a multiplexer and a
> > demultiplexer subdevices on the CSI-2 transmitter (camera) and receiver
> > (SoC) sides respectively. Originally it has also been proposed to add a
> > supporting API to configure multiple streams over such a multiplexed
> > connection. However, this seems redundant, because mux sink pads and demux
> > source pads will anyway have to be configured individually, which already
> > configures the receiver and the transmitter sides.
> 
> You have a point, but I wonder how we would then validate pipelines.

Well, maybe from "such" pads we should require a .link_validate() method? 
And "such" could mean pads, using the FIXED format, or 0x0 size.

> > Currently the design seems to be converging to simply configuring the
> > multiplexed link with the MEDIA_BUS_FMT_FIXED format and a fixed
> > resolution and perform all real configuration on the other side of the mux
> > and demux subdevices. The only API extension, that would be required for
> > such a design would be adding CSI-2 Virtual Channel IDs to pad format
> > specifications, i.e. to struct v4l2_mbus_framefmt.
> 
> I wouldn't add a CSI2-specific field, but a more generic stream ID instead. We 
> would then need a way to map stream IDs to the actual bus implementations. For 
> CSI-2 that would include both virtual channel and data type.

We discussed the CSI-2 data type with Sakari and I explained to him, that 
I think, that the CSI-2 data type should be directly mapped to the Media 
Bus pixel code. You know, that CSI-2 defines a few such codes, so, adding 
the data type for those would be a real duplication and an additional 
point to check for. It is less clear with user-defined data types, that 
the CSI-2 leaves free for device-specific formats, but there are only 8 
of them. We could just add generic numeric defines for them like

#define MEDIA_BUS_FMT_CSI2_UD_0X30 ...
#define MEDIA_BUS_FMT_CSI2_UD_0X31 ...
...
#define MEDIA_BUS_FMT_CSI2_UD_0X37 ...

That's it.

As for stream ID vs. virtual channel number - we can go either way. I 
think the bus type information combined with a union whould be sufficient.

> > On the video device side each stream will be sent to a separate video
> > device node.
> 
> Not necessarily, they could be sent to different pieces of hardware.

Yes, sure, then those nodes would just be EBUSY.

> > Each CSI-2 controller only supports a finate number of streams, that it can
> > demultiplex at any given time. Typically this maximum number is much smaller
> > than 256, which is the total number of streams, that can be distinguished on
> > a CSI-2 bus, using 2 bits for Virtual Channels and 6 bits for data types.
> > For example, if a CSI-2 controller can demultiplex up to 8 streams
> > simultaneously, the CSI-2 bridge driver would statically create 8
> > /dev/video* nodes, statically connected to 8 sources of an internal demux
> > subdevice. The user-space will then just have to configure internal pads
> > with a Virtual Channel number, Media Bus pixel format and resolution and the
> > /dev/video* node with the required output configuration.
> 
> If there are 8 independent DMA engines then 8 video nodes would seem quite 
> logical. Another option would be to create a single video node with 8 buffer 
> queues. I'm still debating that with myself though, but it could make sense in 
> the case of a single DMA engine with multiple contexts. One could argue that 
> we're touching a grey area.

I haven't read the sources of all those controllers :) I suspect however, 
that at least in many cases it will be just one DMA engine with multiple 
channels. I understand (at least some) disadvantages of using multiple 
video nodes, but at least this is something we can use now without really 
breaking or (badly) abusing any existing APIs. We can add multiple buffer 
queue support too, but so far I don't see a _really_ compelling reason for 
that. Nice to have, but not a deal breaker IMHO.

My another doubt is statically creating all (8) video nodes vs. creating 
them on the fly as respective pads get configured. The latter seems more 
elegant to me and wouldn't fry Linux hotplug daemons by presenting them 
with dozens of non-functional video devices, but also when such devices 
get created the daemons would feel attacked and dealing with dyamically 
creating ones would be more difficult for applications too.

Thanks
Guennadi
