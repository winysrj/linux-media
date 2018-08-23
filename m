Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:58087 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729381AbeHWSBa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 14:01:30 -0400
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
Message-ID: <b46ee744-4c00-7e73-1925-65f2122e30f0@xs4all.nl>
Date: Thu, 23 Aug 2018 16:31:28 +0200
MIME-Version: 1.0
In-Reply-To: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

After reading through the comments I came to the following conclusions:

On 08/04/18 15:50, Hans Verkuil wrote:
> Hi all,
> 
> While the Request API patch series addresses all the core API issues, there
> are some high-level considerations as well:
> 
> 1) How can the application tell that the Request API is supported and for
>    which buffer types (capture/output) and pixel formats?
> 
> 2) How can the application tell if the Request API is required as opposed to being
>    optional?
> 
> 3) Some controls may be required in each request, how to let userspace know this?
>    Is it even necessary to inform userspace?
> 
> 4) (For bonus points): How to let the application know which streaming I/O modes
>    are available? That's never been possible before, but it would be very nice
>    indeed if that's made explicit.
> 
> Since the Request API associates data with frame buffers it makes sense to expose
> this as a new capability field in struct v4l2_requestbuffers and struct v4l2_create_buffers.
> 
> The first struct has 2 reserved fields, the second has 8, so it's not a problem to
> take one for a capability field. Both structs also have a buffer type, so we know
> if this is requested for a capture or output buffer type. The pixel format is known
> in the driver, so HAS/REQUIRES_REQUESTS can be set based on that. I doubt we'll have
> drivers where the request caps would actually depend on the pixel format, but it
> theoretically possible. For both ioctls you can call them with count=0 at the start
> of the application. REQBUFS has of course the side-effect of deleting all buffers,
> but at the start of your application you don't have any yet. CREATE_BUFS has no
> side-effects.
> 
> I propose adding these capabilities:
> 
> #define V4L2_BUF_CAP_HAS_REQUESTS	0x00000001
> #define V4L2_BUF_CAP_REQUIRES_REQUESTS	0x00000002
> #define V4L2_BUF_CAP_HAS_MMAP		0x00000100
> #define V4L2_BUF_CAP_HAS_USERPTR	0x00000200
> #define V4L2_BUF_CAP_HAS_DMABUF		0x00000400

I substituted SUPPORTS for HAS and dropped the REQUIRES_REQUESTS capability.
As Tomasz mentioned, technically (at least for stateless codecs) you could
handle just one frame at a time without using requests. It's very inefficient,
but it would work.

Otherwise I have implemented this as specified above.

> 
> If REQUIRES_REQUESTS is set, then HAS_REQUESTS is also set.
> 
> At this time I think that REQUIRES_REQUESTS would only need to be set for the
> output queue of stateless codecs.
> 
> If capabilities is 0, then it's from an old kernel and all you know is that
> requests are certainly not supported, and that MMAP is supported. Whether USERPTR
> or DMABUF are supported isn't known in that case (just try it :-) ).
> 
> Strictly speaking we do not need these HAS_MMAP/USERPTR/DMABUF caps, but it is very
> easy to add if we create a new capability field anyway, and it has always annoyed
> the hell out of me that we didn't have a good way to let userspace know what
> streaming I/O modes we support. And with vb2 it's easy to implement.
> 
> Regarding point 3: I think this should be documented next to the pixel format. I.e.
> the MPEG-2 Slice format used by the stateless cedrus codec requires the request API
> and that two MPEG-2 controls (slice params and quantization matrices) must be present
> in each request.

Everyone seemed to agree with this: which controls are required to be present in a
request should be documented as part of the corresponding pixel format.

> I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is needed here.

Nobody liked this, so this proposed flag is dropped.

Regards,

	Hans

> It's really implied by the fact that you use a stateless codec. It doesn't help
> generic applications like v4l2-ctl or qv4l2 either since in order to support
> stateless codecs they will have to know about the details of these controls anyway.
> 
> So I am inclined to say that it is not necessary to expose this information in
> the API, but it has to be documented together with the pixel format documentation.
> 
> Comments? Ideas?
> 
> Regards,
> 
> 	Hans
> 
