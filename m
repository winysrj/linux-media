Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42447 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbbLXLRv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 06:17:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Dec 2015 12:17:48 +0100
From: hverkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	linux-media-owner@vger.kernel.org
Subject: Re: per-frame camera metadata (again)
In-Reply-To: <20165691.OGa4CkqcQt@avalon>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange>
 <56749F85.8000502@linux.intel.com>
 <Pine.LNX.4.64.1512231004050.6327@axis700.grange>
 <20165691.OGa4CkqcQt@avalon>
Message-ID: <7eb32a870441220fc4f6738d03a96a36@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-12-24 11:46, Laurent Pinchart wrote:
> Hi Guennadi,
> 
> On Wednesday 23 December 2015 10:47:57 Guennadi Liakhovetski wrote:

>> >>> 2. Separate buffer queues. Pros: (a) no need to extend multiplanar
>> >>> buffer implementation. Cons: (a) more difficult synchronisation with
>> >>> image frames, (b) still need to work out a way to specify the metadata
>> >>> version.
>> >
>> > Do you think you have different versions of metadata from a sensor, for
>> > instance? Based on what I've seen these tend to be sensor specific, or
>> > SMIA which defines a metadata type for each bit depth for compliant
>> > sensors.
>> >
>> > Each metadata format should have a 4cc code, SMIA bit depth specific or
>> > sensor specific where metadata is sensor specific.
>> >
>> > Other kind of metadata than what you get from sensors is not covered by
>> > the thoughts above.
>> >
>> > <URL:http://www.retiisi.org.uk/v4l2/foil/v4l2-multi-format.pdf>
>> >
>> > I think I'd still favour separate buffer queues.
>> 
>> And separate video nodes then.
>> 
>> >>> Any further options? Of the above my choice would go with (1) but with
>> >>> a dedicated metadata plane in struct vb2_buffer.
>> >>
>> >> 3. Use the request framework and return the metadata as control(s).
>> >> Since controls can be associated with events when they change you can
>> >> subscribe to such events. Note: currently I haven't implemented such
>> >> events for request controls since I am not certainly how it would be
>> >> used, but this would be a good test case.
>> >>
>> >> Pros: (a) no need to extend multiplanar buffer implementation, (b)
>> >> syncing up with the image frames should be easy (both use the same
>> >> request ID), (c) a lot of freedom on how to export the metadata. Cons:
>> >> (a) request framework is still work in progress (currently worked on by
>> >> Laurent), (b) probably too slow for really large amounts of metadata,
>> >> you'll need proper DMA handling for that in which case I would go for 2.
>> >
>> > Agreed. You could consider it as a drawback that the number of new
>> > controls required for this could be large as well, but then already for
>> > other reasons the best implementation would rather be the second option
>> > mentioned.
>> 
>> But wouldn't a single extended control with all metadata-transferred
>> controls solve the performance issue?
> 
> You would still have to update the value of the controls in the kernel 
> based
> on meta-data parsing, we've never measured the cost of such an 
> operation when
> the number of controls is large.

Before discounting this option we need to measure the cost first. I 
suspect that
if there are just a handful (let's say <= 10) of controls, then the cost 
is limited.

> An interesting side issue is that the control
> framework currently doesn't support updating controls from interrupt 
> context
> as all controls are protected by a mutex. The cost of locking, once it 
> will be
> reworked, also needs to be taken into account.

I think the cost of locking can be limited (and I am not even sure if 
locking is
needed if we restrict the type of control where this can be done). I 
have some ideas
about that.

> 
>> >>> In either of the above options we also need a way to tell the user
>> >>> what is in the metadata buffer, its format. We could create new FOURCC
>> >>> codes for them, perhaps as V4L2_META_FMT_... or the user space could
>> >>> identify the metadata format based on the camera model and an opaque
>> >>> type (metadata version code) value. Since metadata formats seem to be
>> >>> extremely camera-specific, I'd go with the latter option.
>> >
>> > I think I'd use separate 4cc codes for the metadata formats when they
>> > really are different. There are plenty of possible 4cc codes we can use.
>> > :-)
>> >
>> > Documenting the formats might be painful though.
>> 
>> The advantage of this approach together with a separate video node /
>> buffer queue is, that no changes to the core would be required.
>> 
>> At the moment I think, that using (extended) controls would be the 
>> most
>> "correct" way to implement that metadata, but you can associate such
>> control values with frames only when the request API is there. Yet 
>> another
>> caveat is, that we define V4L2_CTRL_ID2CLASS() as ((id) & 
>> 0x0fff0000UL)
>> and V4L2_CID_PRIVATE_BASE as 0x08000000, so that drivers cannot define
>> private controls to belong to existing classes. Was this intensional?

PRIVATE_BASE is deprecated and cannot be used with the control framework 
(it
was a very bad design). The control framework provides backwards compat 
code
to handle old apps that still use PRIVATE_BASE.

Control classes are not deprecated, only the use of the control_class 
field in
struct v4l2_ext_controls to limit the controls in the list to a single 
control
class is deprecated. That old limitation was from pre-control-framework 
times
to simplify driver design. With the creation of the control framework 
that
limitation is no longer needed.

Per-control class private controls are perfectly possible: such controls 
start
at control class base ID + 0x1000.

> 
> Control classes are a deprecated concept, so I don't think this matters 
> much.

As described above, this statement is not correct.

Regards,

     Hans

