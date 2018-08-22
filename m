Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:38487 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbeHVHS2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Aug 2018 03:18:28 -0400
Received: by mail-io0-f196.google.com with SMTP id y3-v6so449039ioc.5
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 20:55:28 -0700 (PDT)
Received: from mail-io0-f179.google.com (mail-io0-f179.google.com. [209.85.223.179])
        by smtp.gmail.com with ESMTPSA id 1-v6sm408405ity.38.2018.08.21.20.55.26
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Aug 2018 20:55:26 -0700 (PDT)
Received: by mail-io0-f179.google.com with SMTP id r196-v6so466308iod.0
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 20:55:26 -0700 (PDT)
MIME-Version: 1.0
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <20180815091115.1abd814d@coco.lan> <2ace6597-d69a-b7c9-6031-b57bdc047a6e@xs4all.nl>
 <CAAFQd5D4OnLg10zMdfOumFHR_74piSO02YWtjS_9nb4X4+6DWQ@mail.gmail.com>
In-Reply-To: <CAAFQd5D4OnLg10zMdfOumFHR_74piSO02YWtjS_9nb4X4+6DWQ@mail.gmail.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 22 Aug 2018 12:55:14 +0900
Message-ID: <CAPBb6MXPgtfp-VK1mswfpwkXR0mU6GpuKtMrgCt2YUG2kf8mxQ@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Tomasz Figa <tfiga@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, mchehab+samsung@kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 21, 2018 at 6:15 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> On Wed, Aug 15, 2018 at 11:18 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 15/08/18 14:11, Mauro Carvalho Chehab wrote:
> > > Em Sat, 4 Aug 2018 15:50:04 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > >
> > >> Hi all,
> > >>
> > >> While the Request API patch series addresses all the core API issues, there
> > >> are some high-level considerations as well:
> > >>
> > >> 1) How can the application tell that the Request API is supported and for
> > >>    which buffer types (capture/output) and pixel formats?
> > >>
> > >> 2) How can the application tell if the Request API is required as opposed to being
> > >>    optional?
> > >
> > > Huh? Why would it be mandatory?
> >
> > It is mandatory for stateless codecs: you can't use them without the Request API since
> > each frame needs the state as well. If you could make a driver for a stateless codec
> > without the Request API we wouldn't have had to spend ages on developing it in the first
> > place, would we? :-)
>
> Technically, one could still do the synchronous S_EXT_CTRL, QBUF,
> DQBUF, S_EXT_CTRL... loop, but I'm not sure if this is something worth
> considering.

Having this option is useful for driver bringup at the very least. And
why add artificial constraints if the two APIs are able to work
independently, albeit in a sub-optimal way?

>
> [snip]
> > >> Regarding point 3: I think this should be documented next to the pixel format. I.e.
> > >> the MPEG-2 Slice format used by the stateless cedrus codec requires the request API
> > >> and that two MPEG-2 controls (slice params and quantization matrices) must be present
> > >> in each request.
> > >
> > > Makes sense to document with the pixel format...
> > >
> > >> I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is needed here.
> > >
> > > but it sounds worth to also have a flag.
> >
> > I'll wait to get some more feedback. I don't have a very strong opinion on
> > this.
> >
>
> I don't see any value in a flag for codecs. Querying the controls for
> the flag, if it's already required as a part of the Stateless Codec
> Interface for given pixel format, would only mean some redundant code
> both in kernel and user space.
>
> For other use cases, I'm not sure if we can say that a control is
> really required in a request. I think it should be something for the
> user space to decide, depending on the synchronization (and other)
> needs of given use case.
>
> Best regards,
> Tomasz
