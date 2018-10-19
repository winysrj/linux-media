Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39440 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbeJTIDZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 04:03:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id y144-v6so5103473wmd.4
        for <linux-media@vger.kernel.org>; Fri, 19 Oct 2018 16:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
 <20180918093421.12930-2-p.zabel@pengutronix.de> <CAJ+vNU2vraT=vUwS+1TYKuX50OsjZsNaN220y1kz8XgHvC48Sg@mail.gmail.com>
 <1539942796.3395.8.camel@pengutronix.de> <1f090c65-342a-fb43-c274-935cbf78fdd4@gmail.com>
In-Reply-To: <1f090c65-342a-fb43-c274-935cbf78fdd4@gmail.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Fri, 19 Oct 2018 16:54:16 -0700
Message-ID: <CAJ+vNU1f2HF9+bQp6cKWMXNYyNMfSGE1-pW_b-oYdWJAgi8EAw@mail.gmail.com>
Subject: Re: [PATCH v3 01/16] media: imx: add mem2mem device
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>, nicolas@ndufresne.ca,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 19, 2018 at 1:19 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
>
> On 10/19/18 2:53 AM, Philipp Zabel wrote:
> > Hi Tim,
> >
> > On Thu, 2018-10-18 at 15:53 -0700, Tim Harvey wrote:
> > [...]
> >> Philipp,
> >>
> >> Thanks for submitting this!
> >>
> >> I'm hoping this lets us use non-IMX capture devices along with the IMX
> >> media controller entities to so we can use hardware
> >> CSC,scaling,pixel-format-conversions and ultimately coda based encode.
> >>
> >> I've built this on top of linux-media and see that it registers as
> >> /dev/video8 but I'm not clear how to use it? I don't see it within the
> >> media controller graph.
> > It's a V4L2 mem2mem device that can be handled by the GstV4l2Transform
> > element, for example. GStreamer should create a v4l2video8convert
> > element of that type.
> >
> > The mem2mem device is not part of the media controller graph on purpose.
> > There is no interaction with any of the entities in the media controller
> > graph apart from the fact that the IC PP task we are using for mem2mem
> > scaling is sharing hardware resources with the IC PRP tasks used for the
> > media controller scaler entitites.
>
>
> It would be nice in the future to link mem2mem output-side to the ipu_vdic:1
> pad, to make use of h/w VDIC de-interlace as part of mem2mem operations.
> The progressive output from a new ipu_vdic:3 pad can then be sent to the
> image_convert APIs by the mem2mem driver for further tiled scaling, CSC,
> and rotation by the IC PP task. The ipu_vdic:1 pad makes use of pure
> DMA-based
> de-interlace, that is, all input frames (N-1, N, N+1) to the VDIC are sent
> from DMA buffers, and this VDIC mode of operation is well understood
> and produces clean de-interlace output. The risk is that this would require
> iDMAC channel 5 for ipu_vdic:3, which IFAIK is not verified to work yet.
>
>
> The other problem with that currently is that mem2mem would have to be
> split into
> separate device nodes: a /dev/videoN for output-side (linked to
> ipu_vdic:1), and
> a /dev/videoM for capture-side (linked from ipu_vdic:3). And then it no
> longer
> presents to userspace as a mem2mem device with a single device node for both
> output and capture sides.
>
>
> Or is there another way? I recall work to integrate mem2mem with media
> control.
> There is v4l2_m2m_register_media_controller(), but that create three
> entities:
> source, processing, and sink. The VDIC entity would be part of mem2mem
> processing but this entity already exists for the current graph. This
> function
> could however be used as a guide to incorporate the VDIC entity into m2m
> device.
>

I agree - without being able to utilize de-interlace,csc,scaling and
rotation it seems fairly limited today (but a great start!).

Also, if it were in the media graph wouldn't we be able to use the
compose selection subdev API?

I've got an AVC8000 minPCIe card here with a TW6869 with 8x analog
capture inputs that I'm hoping to someday soon be able to capture,
compose into a single frame, and encode.

Regards,

Tim
