Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:52791 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932907AbbLPJ7p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 04:59:45 -0500
Subject: Re: per-frame camera metadata (again)
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Aviv Greenberg <avivgr@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <567136C6.8090009@xs4all.nl>
Date: Wed, 16 Dec 2015 11:02:46 +0100
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1512160901460.24913@axis700.grange>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/16/15 10:37, Guennadi Liakhovetski wrote:
> Hi all,
> 
> A project, I am currently working on, requires acquiringing per-frame 
> metadata from the camera and passing it to user-space. This is not the 
> first time this comes up and I know such discussions have been held 
> before. A typical user is Android (also my case), where you have to 
> provide parameter values, that have been used to capture a specific frame, 
> to the user. I know Hans is working to handle one side of this process - 
> sending per-request controls,

Actually, the request framework can do both sides of the equation: giving
back meta data in read-only controls that are per-frame. While ideally the
driver would extract the information from the binary blob and put it in
nice controls, it is also possible to make a control that just contains the
binary blob itself. Whether that's a good approach depends on many factors
and that's another topic.

> but I'm not aware whether he or anyone else
> is actively working on this already or is planning to do so in the near 
> future? I also know, that several proprietary solutions have been 
> developed and are in use in various projects.
> 
> I think a general agreement has been, that such data has to be passed via 
> a buffer queue. But there are a few possibilities there too. Below are 
> some:
> 
> 1. Multiplanar. A separate plane is dedicated to metadata. Pros: (a) 
> metadata is already associated to specific frames, which they correspond 
> to. Cons: (a) a correct implementation would specify image plane fourcc 
> separately from any metadata plane format description, but we currently 
> don't support per-plane format specification.

This only makes sense if the data actually comes in via DMA and if it is
large enough to make it worth the effort of implementing this. As you say,
it will require figuring out how to do per-frame fourcc.

It also only makes sense if the metadata comes in at the same time as the
frame.

> 2. Separate buffer queues. Pros: (a) no need to extend multiplanar buffer 
> implementation. Cons: (a) more difficult synchronisation with image 
> frames, (b) still need to work out a way to specify the metadata version.
> 
> Any further options? Of the above my choice would go with (1) but with a 
> dedicated metadata plane in struct vb2_buffer.

3. Use the request framework and return the metadata as control(s). Since controls
can be associated with events when they change you can subscribe to such events.
Note: currently I haven't implemented such events for request controls since I am
not certainly how it would be used, but this would be a good test case.

Pros: (a) no need to extend multiplanar buffer implementation, (b) syncing up
with the image frames should be easy (both use the same request ID), (c) a lot
of freedom on how to export the metadata. Cons: (a) request framework is still
work in progress (currently worked on by Laurent), (b) probably too slow for
really large amounts of metadata, you'll need proper DMA handling for that in
which case I would go for 2.

> 
> In either of the above options we also need a way to tell the user what is 
> in the metadata buffer, its format. We could create new FOURCC codes for 
> them, perhaps as V4L2_META_FMT_... or the user space could identify the 
> metadata format based on the camera model and an opaque type (metadata 
> version code) value. Since metadata formats seem to be extremely camera- 
> specific, I'd go with the latter option.
> 
> Comments extremely welcome.

What I like about the request framework is that the driver can pick apart
the metadata and turn it into well-defined controls. So the knowledge how
to do that is in the place where it belongs. In cases where the meta data
is simple too large for that to be feasible, then I don't have much of an
opinion. Camera + version could be enough. Although the same can just as
easily be encoded as a fourcc (V4L2_META_FMT_OVXXXX_V1, _V2, etc). A fourcc
is more consistent with the current API.

Regards,

	Hans
