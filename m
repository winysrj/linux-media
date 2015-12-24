Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54162 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbbLXKqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 05:46:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Aviv Greenberg <avivgr@gmail.com>
Subject: Re: per-frame camera metadata (again)
Date: Thu, 24 Dec 2015 12:46:43 +0200
Message-ID: <20165691.OGa4CkqcQt@avalon>
In-Reply-To: <Pine.LNX.4.64.1512231004050.6327@axis700.grange>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange> <56749F85.8000502@linux.intel.com> <Pine.LNX.4.64.1512231004050.6327@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 23 December 2015 10:47:57 Guennadi Liakhovetski wrote:
> On Sat, 19 Dec 2015, Sakari Ailus wrote:
> > Hans Verkuil wrote:
> >> On 12/16/15 10:37, Guennadi Liakhovetski wrote:
> >>> Hi all,
> >>> 
> >>> A project, I am currently working on, requires acquiringing per-frame
> >>> metadata from the camera and passing it to user-space. This is not the
> >>> first time this comes up and I know such discussions have been held
> >>> before. A typical user is Android (also my case), where you have to
> >>> provide parameter values, that have been used to capture a specific
> >>> frame, to the user. I know Hans is working to handle one side of this
> >>> process - sending per-request controls,
> >> 
> >> Actually, the request framework can do both sides of the equation:
> >> giving back meta data in read-only controls that are per-frame. While
> >> ideally the driver would extract the information from the binary blob
> >> and put it in nice controls, it is also possible to make a control that
> >> just contains the binary blob itself. Whether that's a good approach
> >> depends on many factors and that's another topic.
> > 
> > I think that could be possible in some cases. If you don't have a lot of
> > metadata, then, sure.
> > 
> >>> but I'm not aware whether he or anyone else is actively working on
> >>> this already or is planning to do so in the near future? I also know,
> >>> that several proprietary solutions have been developed and are in use
> >>> in various projects.
> >>> 
> >>> I think a general agreement has been, that such data has to be passed
> >>> via a buffer queue. But there are a few possibilities there too. Below
> >>> are some:
> >>> 
> >>> 1. Multiplanar. A separate plane is dedicated to metadata. Pros: (a)
> >>> metadata is already associated to specific frames, which they
> >>> correspond to. Cons: (a) a correct implementation would specify image
> >>> plane fourcc separately from any metadata plane format description,
> >>> but we currently don't support per-plane format specification.
> >> 
> >> This only makes sense if the data actually comes in via DMA and if it is
> >> large enough to make it worth the effort of implementing this. As you
> >> say, it will require figuring out how to do per-frame fourcc.
> >> 
> >> It also only makes sense if the metadata comes in at the same time as
> >> the frame.
> > 
> > I agree. Much of the time the metadata indeed arrives earlier than the
> > rest of the frame. The frame layout nor the use cases should be assumed
> > in the bridge (ISP) driver which implements the interface, essentially
> > forcing this on the user. This is a major drawback in the approach.
> > 
> > Albeit. If you combine this with the need to pass buffer data to the user
> > before the entire buffer is ready, i.e. a plane is ready, you could get
> > around this quite neatly.
> > 
> > However, if the DMA engine writing the metadata is different than what's
> > writing the image data to memory, then you have a plain metadata buffer
> > --- as it's a different video node. But there's really nothing special
> > about that then.
> > 
> > Conceptually we should support multi-part frames rather than metadata,
> > albeit metadata is just a single use case where a single DMA engine
> > outputs multiple kind of data. This could be statistics as well. Or
> > multiple images, e.g. YUV and RAW format images of the same frame.
> 
> If you stream different kinds of images (raw, yuv), then using multiple
> nodes is rather straight-forward, isn't it? Whereas for statistics and
> metadata, if we do that, do we assign new FOURCC codes for each new such
> data layout?
> 
> > With CSI-2, as the virtual channels are independent, one could start and
> > stop them at different times and the frame rate in those channels could
> > as well be unrelated. This suggests that different virtual channels
> > should be conceptually separate streams also in V4L2 and thus the data
> > from different streams should not end up to the same buffer.
> > 
> > Metadata usually (or practically ever?) does not arrive on a separate
> > virtual channel though. So this isn't something that necessarily is taken
> > into account right now but it's good to be aware of it.
> 
> A camera can send image data and metadata on the same virtual channel, but
> then it should use different data types for them?

Conceptually a sensor could send meta-data as embedded data lines using the 
same data type. I'm not sure whether that's done in practice.

> >>> 2. Separate buffer queues. Pros: (a) no need to extend multiplanar
> >>> buffer implementation. Cons: (a) more difficult synchronisation with
> >>> image frames, (b) still need to work out a way to specify the metadata
> >>> version.
> > 
> > Do you think you have different versions of metadata from a sensor, for
> > instance? Based on what I've seen these tend to be sensor specific, or
> > SMIA which defines a metadata type for each bit depth for compliant
> > sensors.
> > 
> > Each metadata format should have a 4cc code, SMIA bit depth specific or
> > sensor specific where metadata is sensor specific.
> > 
> > Other kind of metadata than what you get from sensors is not covered by
> > the thoughts above.
> > 
> > <URL:http://www.retiisi.org.uk/v4l2/foil/v4l2-multi-format.pdf>
> > 
> > I think I'd still favour separate buffer queues.
> 
> And separate video nodes then.
> 
> >>> Any further options? Of the above my choice would go with (1) but with
> >>> a dedicated metadata plane in struct vb2_buffer.
> >> 
> >> 3. Use the request framework and return the metadata as control(s).
> >> Since controls can be associated with events when they change you can
> >> subscribe to such events. Note: currently I haven't implemented such
> >> events for request controls since I am not certainly how it would be
> >> used, but this would be a good test case.
> >> 
> >> Pros: (a) no need to extend multiplanar buffer implementation, (b)
> >> syncing up with the image frames should be easy (both use the same
> >> request ID), (c) a lot of freedom on how to export the metadata. Cons:
> >> (a) request framework is still work in progress (currently worked on by
> >> Laurent), (b) probably too slow for really large amounts of metadata,
> >> you'll need proper DMA handling for that in which case I would go for 2.
> > 
> > Agreed. You could consider it as a drawback that the number of new
> > controls required for this could be large as well, but then already for
> > other reasons the best implementation would rather be the second option
> > mentioned.
>
> But wouldn't a single extended control with all metadata-transferred
> controls solve the performance issue?

You would still have to update the value of the controls in the kernel based 
on meta-data parsing, we've never measured the cost of such an operation when 
the number of controls is large. An interesting side issue is that the control 
framework currently doesn't support updating controls from interrupt context 
as all controls are protected by a mutex. The cost of locking, once it will be 
reworked, also needs to be taken into account.

> >>> In either of the above options we also need a way to tell the user
> >>> what is in the metadata buffer, its format. We could create new FOURCC
> >>> codes for them, perhaps as V4L2_META_FMT_... or the user space could
> >>> identify the metadata format based on the camera model and an opaque
> >>> type (metadata version code) value. Since metadata formats seem to be
> >>> extremely camera-specific, I'd go with the latter option.
> > 
> > I think I'd use separate 4cc codes for the metadata formats when they
> > really are different. There are plenty of possible 4cc codes we can use.
> > :-)
> > 
> > Documenting the formats might be painful though.
> 
> The advantage of this approach together with a separate video node /
> buffer queue is, that no changes to the core would be required.
> 
> At the moment I think, that using (extended) controls would be the most
> "correct" way to implement that metadata, but you can associate such
> control values with frames only when the request API is there. Yet another
> caveat is, that we define V4L2_CTRL_ID2CLASS() as ((id) & 0x0fff0000UL)
> and V4L2_CID_PRIVATE_BASE as 0x08000000, so that drivers cannot define
> private controls to belong to existing classes. Was this intensional?

Control classes are a deprecated concept, so I don't think this matters much.

> >>> Comments extremely welcome.
> >> 
> >> What I like about the request framework is that the driver can pick
> >> apart the metadata and turn it into well-defined controls. So the
> >> knowledge how to do that is in the place where it belongs. In cases
> >> where the meta data is simple too large for that to be feasible, then I
> >> don't have much of an opinion. Camera + version could be enough.
> >> Although the same can just as easily be encoded as a fourcc
> >> (V4L2_META_FMT_OVXXXX_V1, _V2, etc). A fourcc is more consistent with
> >> the current API.

-- 
Regards,

Laurent Pinchart

