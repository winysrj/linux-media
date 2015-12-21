Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49616 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbbLUDl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Dec 2015 22:41:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aviv Greenberg <avivgr@gmail.com>
Subject: Re: per-frame camera metadata (again)
Date: Mon, 21 Dec 2015 05:41:22 +0200
Message-ID: <4607936.L97stxNvbj@avalon>
In-Reply-To: <Pine.LNX.4.64.1512161108540.24913@axis700.grange>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange> <567136C6.8090009@xs4all.nl> <Pine.LNX.4.64.1512161108540.24913@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 16 December 2015 12:25:24 Guennadi Liakhovetski wrote:
> On Wed, 16 Dec 2015, Hans Verkuil wrote:
> > On 12/16/15 10:37, Guennadi Liakhovetski wrote:
> > > Hi all,
> > > 
> > > A project, I am currently working on, requires acquiringing per-frame
> > > metadata from the camera and passing it to user-space. This is not the
> > > first time this comes up and I know such discussions have been held
> > > before. A typical user is Android (also my case), where you have to
> > > provide parameter values, that have been used to capture a specific
> > > frame, to the user. I know Hans is working to handle one side of this
> > > process - sending per-request controls,
> > 
> > Actually, the request framework can do both sides of the equation: giving
> > back meta data in read-only controls that are per-frame. While ideally the
> > driver would extract the information from the binary blob and put it in
> > nice controls, it is also possible to make a control that just contains
> > the binary blob itself. Whether that's a good approach depends on many
> > factors and that's another topic.
> 
> Yes, sorry, didn't mention this possibility. On the one hand I agree, that
> this would look nice and consistent - you send a bunch of controls down
> and you get them back in exactly the same way, nicely taken apart. OTOH
> there are some issues with that:
> 
> 1. Metadata values can indeed come from the camera in a buffer, that's
> DMAed to a buffer by the bridge - we have such examples. In our use-cases
> those buffers are separate from main data, so, that the driver could
> allocate them itself, but can there be cases, in which those buffers have
> to be supplied by the user?

The only case I can think of where the user would benefit from supplying the 
buffer is sharing meta data with other processes and/or devices *if* the 
amount of meta data is so large that a memcpy would negatively affect 
performances. And I can't think of such a case at the moment :-)

> 2. Size - not sure how large those control buffers can become, in
> use-cases, that I'm aware of we transfer up to 20 single-value parameters
> per frame.

I have to deal with a system that can transfer up to ~200 parameters per frame 
(at least in theory).

> 3. With control values delivered per DMA, it's the bridge driver, that
> gets the data, but it's the sensor subdevice driver, that knows what that
> buffer contains. So, to deliver those parameters to the user, the sensor
> driver control processing routines will have to get access to that
> metadata buffer. This isn't supported so far even with the proposed
> request API?

Correct. My current implementation (see git://linuxtv.org/pinchartl/media.git 
drm/du/vsp1-kms/request) doesn't deal with controls yet as the first use case 
I focused on for the request API primarily requires setting formats (and 
links, which are my next target).

My other use case (Android camera HAL v3 for Project Ara) mainly deals with 
controls and meta-data, but I'll then likely pass the meta-data blob to 
userspace as-is, as its format isn't always known to the driver. I'm also 
concerned about efficiency but haven't had time to perform measurements yet.

> > > but I'm not aware whether he or anyone else is actively working on this
> > > already or is planning to do so in the near future? I also know, that
> > > several proprietary solutions have been developed and are in use in
> > > various projects.
> > > 
> > > I think a general agreement has been, that such data has to be passed
> > > via a buffer queue. But there are a few possibilities there too. Below
> > > are some:
> > > 
> > > 1. Multiplanar. A separate plane is dedicated to metadata. Pros: (a)
> > > metadata is already associated to specific frames, which they correspond
> > > to. Cons: (a) a correct implementation would specify image plane fourcc
> > > separately from any metadata plane format description, but we currently
> > > don't support per-plane format specification.
> > 
> > This only makes sense if the data actually comes in via DMA and if it is
> > large enough to make it worth the effort of implementing this. As you say,
> > it will require figuring out how to do per-frame fourcc.
> > 
> > It also only makes sense if the metadata comes in at the same time as the
> > frame.
> > 
> > > 2. Separate buffer queues. Pros: (a) no need to extend multiplanar
> > > buffer implementation. Cons: (a) more difficult synchronisation with
> > > image frames, (b) still need to work out a way to specify the metadata
> > > version.
> > > 
> > > Any further options? Of the above my choice would go with (1) but with a
> > > dedicated metadata plane in struct vb2_buffer.
> > 
> > 3. Use the request framework and return the metadata as control(s). Since
> > controls can be associated with events when they change you can subscribe
> > to such events. Note: currently I haven't implemented such events for
> > request controls since I am not certainly how it would be used, but this
> > would be a good test case.
> > 
> > Pros: (a) no need to extend multiplanar buffer implementation, (b) syncing
> > up with the image frames should be easy (both use the same request ID),
> > (c) a lot of freedom on how to export the metadata. Cons: (a) request
> > framework is still work in progress (currently worked on by Laurent), (b)
> > probably too slow for really large amounts of metadata, you'll need
> > proper DMA handling for that in which case I would go for 2.

(a) will eventually be solved, (b) needs measurements before discussing it 
further.

> For (2) (separate buffer queue) would we have to extend VIDIOC_DQBUF to
> select a specific buffer queue?

Wouldn't it use a separate video device node ?

> > > In either of the above options we also need a way to tell the user what
> > > is in the metadata buffer, its format. We could create new FOURCC codes
> > > for them, perhaps as V4L2_META_FMT_... or the user space could identify
> > > the metadata format based on the camera model and an opaque type
> > > (metadata version code) value. Since metadata formats seem to be
> > > extremely camera-specific, I'd go with the latter option.
> > > 
> > > Comments extremely welcome.
> > 
> > What I like about the request framework is that the driver can pick apart
> > the metadata and turn it into well-defined controls. So the knowledge how
> > to do that is in the place where it belongs. In cases where the meta data
> > is simple too large for that to be feasible, then I don't have much of an
> > opinion. Camera + version could be enough. Although the same can just as
> > easily be encoded as a fourcc (V4L2_META_FMT_OVXXXX_V1, _V2, etc). A
> > fourcc is more consistent with the current API.
> 
> Right, our use-cases so far don't send a lot of data as per-frame
> metadata, no idea what others do.

What kind of hardware do you deal with that sends meta-data ? And over what 
kind of channel does it send it ?

-- 
Regards,

Laurent Pinchart

