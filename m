Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:38863 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbeHVRSc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 13:18:32 -0400
Received: by mail-yb0-f176.google.com with SMTP id c1-v6so684300ybq.5
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2018 06:53:31 -0700 (PDT)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id g205-v6sm2053365ywb.23.2018.08.22.06.53.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Aug 2018 06:53:29 -0700 (PDT)
Received: by mail-yw1-f52.google.com with SMTP id p206-v6so649792ywg.12
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2018 06:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
 <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl> <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
 <CAHStOZ5aU5N5UssqqSTU8YRN7nmGCX7H0eGO0GeB=AN0YK53dQ@mail.gmail.com> <2ce0778a85616ea71d9ca493372b645b5858dc81.camel@bootlin.com>
In-Reply-To: <2ce0778a85616ea71d9ca493372b645b5858dc81.camel@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 22 Aug 2018 22:53:15 +0900
Message-ID: <CAAFQd5Da3xSR7--79d6Z3YdrfNF6CVSDYbK78S2O3dU_1qSzFQ@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 22, 2018 at 10:21 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi,
>
> [...]
>
> On Wed, 2018-08-15 at 14:51 +0200, Maxime Jourdan wrote:
> > Hi Paul, I think we need to go deeper than just exposing the supported
> > profiles/levels and also include a way to query the CAPTURE pixel
> > formats that are supported for each profile.
> >
> > Maybe HEVC Main produces yuv420p but HEVC Main10 gives you
> > yuv420p10le. Maybe H.264 HiP produces NV12 but H.264 Hi422P produces
> > YUYV while also supporting down-sampling to NV12.
>
> Well, I think we're looking at this backwards. Userspace certainly known
> what destination format is relevant for the video, so it shouldn't have
> to query the driver about it except to check that the format is indeed
> supported.

Typically the profile itself only defines the sub-sampling and sample
size, but not the exact set of formats supported by the hardware. VP9
profile 0 is expected to decode into YUV 4:2:0 8-bit, but whether that
would be NV12, YUV420, NV21 or maybe some hw-specific tiled format
(like NV12MT), is entirely up to the hardware/driver. Userspace will
definitely need to know if the decoder can decode the video into a
format, which it can later use (display).

>
> > I don't know the specifics of each platform and the only example I can
> > think of is the Amlogic HEVC decoder that can produce NV12 for Main,
> > but only outputs a compressed proprietary format for Main10.
> >
> > I unfortunately don't have an idea about how to implement that, but
> > I'll think about it.
>
> On the first generations of Allwinner platforms, we also have a vendor-
> specific format as output, that we expose with a dedicated format.
> There's no particular interfacing issue with that. Only that userspace
> has to be aware of the format and how to deal with it.
>

Typically a decode operates as a part of a pipeline with other
components. If your display doesn't let you display format X on an
overlay plane, you may want to use a post-processor hardware to
convert it to format Y. Or maybe use GPU to blit the video into the
primary plane? Or maybe you need to do both, because format X is a
decoder-specific tiled format and the GPU can't deal with it and all
the overlay planes are occupied with some other surfaces? Or maybe
it's just cheaper to do software decode rather than the conversion+GPU
blit? This is something that normally needs to be queried before the
video playback is initialized.

Best regards,
Tomasz
