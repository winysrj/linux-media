Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:40146 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbeHUMep (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 08:34:45 -0400
Received: by mail-yb0-f193.google.com with SMTP id f4-v6so5704872ybp.7
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 02:15:24 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id 200-v6sm3301701ywr.102.2018.08.21.02.15.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Aug 2018 02:15:23 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id x83-v6so495205ywd.4
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 02:15:22 -0700 (PDT)
MIME-Version: 1.0
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <20180815091115.1abd814d@coco.lan> <2ace6597-d69a-b7c9-6031-b57bdc047a6e@xs4all.nl>
In-Reply-To: <2ace6597-d69a-b7c9-6031-b57bdc047a6e@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 21 Aug 2018 18:15:11 +0900
Message-ID: <CAAFQd5D4OnLg10zMdfOumFHR_74piSO02YWtjS_9nb4X4+6DWQ@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 15, 2018 at 11:18 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 15/08/18 14:11, Mauro Carvalho Chehab wrote:
> > Em Sat, 4 Aug 2018 15:50:04 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >
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
> >
> > Huh? Why would it be mandatory?
>
> It is mandatory for stateless codecs: you can't use them without the Request API since
> each frame needs the state as well. If you could make a driver for a stateless codec
> without the Request API we wouldn't have had to spend ages on developing it in the first
> place, would we? :-)

Technically, one could still do the synchronous S_EXT_CTRL, QBUF,
DQBUF, S_EXT_CTRL... loop, but I'm not sure if this is something worth
considering.

[snip]
> >> Regarding point 3: I think this should be documented next to the pixel format. I.e.
> >> the MPEG-2 Slice format used by the stateless cedrus codec requires the request API
> >> and that two MPEG-2 controls (slice params and quantization matrices) must be present
> >> in each request.
> >
> > Makes sense to document with the pixel format...
> >
> >> I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_REQ) is needed here.
> >
> > but it sounds worth to also have a flag.
>
> I'll wait to get some more feedback. I don't have a very strong opinion on
> this.
>

I don't see any value in a flag for codecs. Querying the controls for
the flag, if it's already required as a part of the Stateless Codec
Interface for given pixel format, would only mean some redundant code
both in kernel and user space.

For other use cases, I'm not sure if we can say that a control is
really required in a request. I think it should be something for the
user space to decide, depending on the synchronization (and other)
needs of given use case.

Best regards,
Tomasz
