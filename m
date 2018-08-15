Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:43551 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728957AbeHORK1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 13:10:27 -0400
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <20180815091115.1abd814d@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2ace6597-d69a-b7c9-6031-b57bdc047a6e@xs4all.nl>
Date: Wed, 15 Aug 2018 16:18:04 +0200
MIME-Version: 1.0
In-Reply-To: <20180815091115.1abd814d@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/08/18 14:11, Mauro Carvalho Chehab wrote:
> Em Sat, 4 Aug 2018 15:50:04 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi all,
>>
>> While the Request API patch series addresses all the core API issues, there
>> are some high-level considerations as well:
>>
>> 1) How can the application tell that the Request API is supported and for
>>    which buffer types (capture/output) and pixel formats?
>>
>> 2) How can the application tell if the Request API is required as opposed to being
>>    optional?
> 
> Huh? Why would it be mandatory?

It is mandatory for stateless codecs: you can't use them without the Request API since
each frame needs the state as well. If you could make a driver for a stateless codec
without the Request API we wouldn't have had to spend ages on developing it in the first
place, would we? :-)

> 
>>
>> 3) Some controls may be required in each request, how to let userspace know this?
>>    Is it even necessary to inform userspace?
> 
> Again, why would it need to have a set of mandatory controls for requests
> to work? If this is really required,  it should have a way to send such
> list to userspace.

Also for stateless codecs: each frame needs the state information. This is done
through one or more controls (see the cedrus driver implementation). Which controls
those are is standardized, but it will differ depending on the HW codec (MPEG, H264,
HEVC will almost certainly each require different state information).

Obviously this will have to be documented as part of the pixel format for each
HW codec.

> 
>>
>> 4) (For bonus points): How to let the application know which streaming I/O modes
>>    are available? That's never been possible before, but it would be very nice
>>    indeed if that's made explicit.
>>
>> Since the Request API associates data with frame buffers it makes sense to expose
>> this as a new capability field in struct v4l2_requestbuffers and struct v4l2_create_buffers.
>>
>> The first struct has 2 reserved fields, the second has 8, so it's not a problem to
>> take one for a capability field. Both structs also have a buffer type, so we know
>> if this is requested for a capture or output buffer type. The pixel format is known
>> in the driver, so HAS/REQUIRES_REQUESTS can be set based on that. I doubt we'll have
>> drivers where the request caps would actually depend on the pixel format, but it
>> theoretically possible. For both ioctls you can call them with count=0 at the start
>> of the application. REQBUFS has of course the side-effect of deleting all buffers,
>> but at the start of your application you don't have any yet. CREATE_BUFS has no
>> side-effects.
>>
>> I propose adding these capabilities:
>>
>> #define V4L2_BUF_CAP_HAS_REQUESTS	0x00000001
> 
> I'm OK with that.
> 
>> #define V4L2_BUF_CAP_REQUIRES_REQUESTS	0x00000002
> 
> But I'm not ok with breaking even more userspace support by forcing 
> requests.

You don't break userspace. This is for stateless codecs, which didn't
exist before precisely because they require the Request API.

> 
>> #define V4L2_BUF_CAP_HAS_MMAP		0x00000100
>> #define V4L2_BUF_CAP_HAS_USERPTR	0x00000200
>> #define V4L2_BUF_CAP_HAS_DMABUF		0x00000400
> 
> Those sounds ok to me too.
> 
>>
>> If REQUIRES_REQUESTS is set, then HAS_REQUESTS is also set.
>>
>> At this time I think that REQUIRES_REQUESTS would only need to be set for the
>> output queue of stateless codecs.
> 
> Same as before: I don't see the need of support a request-only driver.
> 
>>
>> If capabilities is 0, then it's from an old kernel and all you know is that
>> requests are certainly not supported, and that MMAP is supported. Whether USERPTR
>> or DMABUF are supported isn't known in that case (just try it :-) ).
>>
>> Strictly speaking we do not need these HAS_MMAP/USERPTR/DMABUF caps, but it is very
>> easy to add if we create a new capability field anyway, and it has always annoyed
>> the hell out of me that we didn't have a good way to let userspace know what
>> streaming I/O modes we support. And with vb2 it's easy to implement.
> 
> Yeah, that sounds a bonus to me too.
> 
>> Regarding point 3: I think this should be documented next to the pixel format. I.e.
>> the MPEG-2 Slice format used by the stateless cedrus codec requires the request API
>> and that two MPEG-2 controls (slice params and quantization matrices) must be present
>> in each request.
> 
> Makes sense to document with the pixel format...
> 
>> I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is needed here.
> 
> but it sounds worth to also have a flag.

I'll wait to get some more feedback. I don't have a very strong opinion on
this.

> 
>> It's really implied by the fact that you use a stateless codec. It doesn't help
>> generic applications like v4l2-ctl or qv4l2 either since in order to support
>> stateless codecs they will have to know about the details of these controls anyway.
> 
> Yeah, but they could skip enum those ioctls if they see one marked with
> V4L2_CTRL_FLAG_REQUIRED_IN_REQ and don't know how to use. Then, default
> to not use request API. 

I would expect that V4L2_CTRL_FLAG_REQUIRED_IN_REQ only makes sense if
V4L2_BUF_CAP_REQUIRES_REQUESTS is also set. But then you already know through
the documentation which controls as required.

I can't think of a reason why V4L2_CTRL_FLAG_REQUIRED_IN_REQ would be set
but V4L2_BUF_CAP_REQUIRES_REQUESTS isn't.

Regards,

	Hans

> 
> Then, the driver would use a default that would work (even not providing
> the best possible compression).
> 
>> So I am inclined to say that it is not necessary to expose this information in
>> the API, but it has to be documented together with the pixel format documentation.
>>
>> Comments? Ideas?
>>
>> Regards,
>>
>> 	Hans
> 
> Thanks,
> Mauro
> 
