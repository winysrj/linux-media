Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33662 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbeHGGSF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 02:18:05 -0400
Received: by mail-pf1-f196.google.com with SMTP id d4-v6so7893980pfn.0
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2018 21:05:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Tue, 7 Aug 2018 01:05:43 -0300
Message-ID: <CAAEAJfD-CV+2HBtuAjD2RkF_djkKuit3_6Zx7St7dnygDD2rrQ@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 August 2018 at 10:50, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi all,
>
> While the Request API patch series addresses all the core API issues, the=
re
> are some high-level considerations as well:
>
> 1) How can the application tell that the Request API is supported and for
>    which buffer types (capture/output) and pixel formats?
>
> 2) How can the application tell if the Request API is required as opposed=
 to being
>    optional?
>
> 3) Some controls may be required in each request, how to let userspace kn=
ow this?
>    Is it even necessary to inform userspace?
>
> 4) (For bonus points): How to let the application know which streaming I/=
O modes
>    are available? That's never been possible before, but it would be very=
 nice
>    indeed if that's made explicit.
>
> Since the Request API associates data with frame buffers it makes sense t=
o expose
> this as a new capability field in struct v4l2_requestbuffers and struct v=
4l2_create_buffers.
>
> The first struct has 2 reserved fields, the second has 8, so it's not a p=
roblem to
> take one for a capability field. Both structs also have a buffer type, so=
 we know
> if this is requested for a capture or output buffer type. The pixel forma=
t is known
> in the driver, so HAS/REQUIRES_REQUESTS can be set based on that. I doubt=
 we'll have
> drivers where the request caps would actually depend on the pixel format,=
 but it
> theoretically possible.

Actually, I think that for stateless JPEG encoders and decoders, an applica=
tion
could work without the Request API. In that case, the same encoding/decodin=
g
parameters would be used for all the encoded/decoded buffers.

So, it seems that having per-pixelformat capabilities sounds correct.

> For both ioctls you can call them with count=3D0 at the start
> of the application. REQBUFS has of course the side-effect of deleting all=
 buffers,
> but at the start of your application you don't have any yet. CREATE_BUFS =
has no
> side-effects.
>
> I propose adding these capabilities:
>
> #define V4L2_BUF_CAP_HAS_REQUESTS       0x00000001
> #define V4L2_BUF_CAP_REQUIRES_REQUESTS  0x00000002
> #define V4L2_BUF_CAP_HAS_MMAP           0x00000100
> #define V4L2_BUF_CAP_HAS_USERPTR        0x00000200
> #define V4L2_BUF_CAP_HAS_DMABUF         0x00000400
>
> If REQUIRES_REQUESTS is set, then HAS_REQUESTS is also set.
>
> At this time I think that REQUIRES_REQUESTS would only need to be set for=
 the
> output queue of stateless codecs.
>
> If capabilities is 0, then it's from an old kernel and all you know is th=
at
> requests are certainly not supported, and that MMAP is supported. Whether=
 USERPTR
> or DMABUF are supported isn't known in that case (just try it :-) ).
>
> Strictly speaking we do not need these HAS_MMAP/USERPTR/DMABUF caps, but =
it is very
> easy to add if we create a new capability field anyway, and it has always=
 annoyed
> the hell out of me that we didn't have a good way to let userspace know w=
hat
> streaming I/O modes we support. And with vb2 it's easy to implement.
>
> Regarding point 3: I think this should be documented next to the pixel fo=
rmat. I.e.
> the MPEG-2 Slice format used by the stateless cedrus codec requires the r=
equest API
> and that two MPEG-2 controls (slice params and quantization matrices) mus=
t be present
> in each request.
>
> I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is nee=
ded here.
> It's really implied by the fact that you use a stateless codec. It doesn'=
t help
> generic applications like v4l2-ctl or qv4l2 either since in order to supp=
ort
> stateless codecs they will have to know about the details of these contro=
ls anyway.
>

This makes a lot of sense to me.

> So I am inclined to say that it is not necessary to expose this informati=
on in
> the API, but it has to be documented together with the pixel format docum=
entation.
>
> Comments? Ideas?
>

--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
