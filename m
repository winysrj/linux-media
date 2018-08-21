Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39635 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbeHUMxn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 08:53:43 -0400
Received: by mail-yw1-f66.google.com with SMTP id r184-v6so7891096ywg.6
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 02:34:19 -0700 (PDT)
Received: from mail-yb0-f181.google.com (mail-yb0-f181.google.com. [209.85.213.181])
        by smtp.gmail.com with ESMTPSA id r69-v6sm5682236ywh.44.2018.08.21.02.34.17
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Aug 2018 02:34:17 -0700 (PDT)
Received: by mail-yb0-f181.google.com with SMTP id o17-v6so5712284yba.2
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 02:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com> <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl>
In-Reply-To: <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 21 Aug 2018 18:34:05 +0900
Message-ID: <CAAFQd5BUkAZOa-qwrg+cYvPVuB7=69zy8=6CB5XPpYY0DddASQ@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 6, 2018 at 5:32 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
> > Hi Hans and all,
> >
> > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> >> Hi all,
> >>
> >> While the Request API patch series addresses all the core API issues, there
> >> are some high-level considerations as well:
> >>
> >> 1) How can the application tell that the Request API is supported and for
> >>    which buffer types (capture/output) and pixel formats?
> >>
> >> 2) How can the application tell if the Request API is required as opposed to being
> >>    optional?
> >>
> >> 3) Some controls may be required in each request, how to let userspace know this?
> >>    Is it even necessary to inform userspace?
> >>
> >> 4) (For bonus points): How to let the application know which streaming I/O modes
> >>    are available? That's never been possible before, but it would be very nice
> >>    indeed if that's made explicit.
> >
> > Thanks for bringing up these considerations and questions, which perhaps
> > cover the last missing bits for streamlined use of the request API by
> > userspace. I would suggest another item, related to 3):
> >
> > 5) How can applications tell whether the driver supports a specific
> > codec profile/level, not only for encoding but also for decoding? It's
> > common for low-end embedded hardware to not support the most advanced
> > profiles (e.g. H264 high profile).
> >
> >> Since the Request API associates data with frame buffers it makes sense to expose
> >> this as a new capability field in struct v4l2_requestbuffers and struct v4l2_create_buffers.
> >>
> >> The first struct has 2 reserved fields, the second has 8, so it's not a problem to
> >> take one for a capability field. Both structs also have a buffer type, so we know
> >> if this is requested for a capture or output buffer type. The pixel format is known
> >> in the driver, so HAS/REQUIRES_REQUESTS can be set based on that. I doubt we'll have
> >> drivers where the request caps would actually depend on the pixel format, but it
> >> theoretically possible. For both ioctls you can call them with count=0 at the start
> >> of the application. REQBUFS has of course the side-effect of deleting all buffers,
> >> but at the start of your application you don't have any yet. CREATE_BUFS has no
> >> side-effects.
> >
> > My initial thoughts on this point were to have flags exposed in
> > v4l2_capability, but now that you're saying it, it does make sense for
> > the flag to be associated with a buffer rather than the global device.
> >
> > In addition, I've heard of cases (IIRC it was some Rockchip platforms)
> > where the platform has both stateless and stateful VPUs (I think it was
> > stateless up to H264 and stateful for H265).

AFAIR, on Rockchip those are two separate hardware blocks.

> > This would allow supporting
> > these two hardware blocks under the same video device (if that makes
> > sense anyway). And even if there's no immediate need, it's always good
> > to have this level of granularity (with little drawbacks).
> >
> >> I propose adding these capabilities:
> >>
> >> #define V4L2_BUF_CAP_HAS_REQUESTS    0x00000001
> >> #define V4L2_BUF_CAP_REQUIRES_REQUESTS       0x00000002
> >> #define V4L2_BUF_CAP_HAS_MMAP                0x00000100
> >> #define V4L2_BUF_CAP_HAS_USERPTR     0x00000200
> >> #define V4L2_BUF_CAP_HAS_DMABUF              0x00000400
> >>
> >> If REQUIRES_REQUESTS is set, then HAS_REQUESTS is also set.
> >>
> >> At this time I think that REQUIRES_REQUESTS would only need to be set for the
> >> output queue of stateless codecs.
> >>
> >> If capabilities is 0, then it's from an old kernel and all you know is that
> >> requests are certainly not supported, and that MMAP is supported. Whether USERPTR
> >> or DMABUF are supported isn't known in that case (just try it :-) ).
> >
> > Sounds good to me!

SGTM.

+/- the fact that I'm not convinced if something really "requires
requests" at V4L2 interface level. Would that mean that we strictly
prohibit the lame synchronous way for stateless codecs? (Possibly
useful for debugging.)

Best regards,
Tomasz
