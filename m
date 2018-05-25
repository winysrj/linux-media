Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:40106 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936197AbeEYOkV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 10:40:21 -0400
Received: by mail-vk0-f65.google.com with SMTP id e67-v6so3279430vke.7
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 07:40:21 -0700 (PDT)
Received: from mail-ua0-f176.google.com (mail-ua0-f176.google.com. [209.85.217.176])
        by smtp.gmail.com with ESMTPSA id a31-v6sm15863655uai.41.2018.05.25.07.40.19
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 May 2018 07:40:19 -0700 (PDT)
Received: by mail-ua0-f176.google.com with SMTP id f30-v6so1834303uab.11
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 07:40:19 -0700 (PDT)
MIME-Version: 1.0
References: <157f4fc4-eebf-41ab-1e9c-93d7baefc612@xs4all.nl> <20180525141655.ugmd7xki4nsqz2pg@kekkonen.localdomain>
In-Reply-To: <20180525141655.ugmd7xki4nsqz2pg@kekkonen.localdomain>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 25 May 2018 23:40:06 +0900
Message-ID: <CAAFQd5BeLYQyBtKQvd3o01OUxHk+Lic2M_8+35_xGeCJf1dmLg@mail.gmail.com>
Subject: Re: RFC: Request API and memory-to-memory devices
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        nicolas@ndufresne.ca
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 11:17 PM Sakari Ailus <sakari.ailus@linux.intel.com>
wrote:

> Hi Hans,

> On Thu, May 24, 2018 at 10:44:13AM +0200, Hans Verkuil wrote:
> > Memory-to-memory devices have one video node, one internal control
handler
> > but two vb2_queues (DMA engines). While often there is one buffer
produced
> > for every buffer consumed, but this is by no means standard. E.g.
deinterlacers
> > will produce on buffer for every two buffers consumed. Codecs that
receive
> > a bit stream and can parse it to discover the framing may have no
relation
> > between the number of buffers consumed and the number of buffers
produced.

> Do you have examples of such devices? I presume they're not supported in
> the current m2m API either, are they?

All stateful video decoders work like this and this means all video
decoders currently in mainline (e.g. s5p-mfc, coda, mtk-vcodec), since we
don't support stateless decoders yet. This is due to the nature of encoded
bitstreams, such as H264, which can have frame reordering, long reference
frame range and other tricks.

I wouldn't say there is something like m2m API, unless you mean the m2m
helpers, but that's not mandatory. Stateful decoders work according to V4L2
Codec API, which is a further specification of V4L2 (or something like
application notes?).


> >
> > This poses a few problems for the Request API. Requiring that a request
> > contains the buffers for both output and capture queue will be difficult
> > to implement, especially in the latter case where there is no
relationship
> > between the number of consumed and produced buffers.
> >
> > In addition, userspace can make two requests: one for the capture queue,
> > one for the output queue, each with associated controls. But since the
> > controls are shared between capture and output there is an issue of
> > what to do when the same control is set in both requests.

> As I commented on v13, the two requests need to be handled separately in
> this case. Mem-to-mem devices are rather special in this respect; there's
> an established practice of matching buffers in the order they arrive from
> the queues, but that's not how the request API is intended to work: the
> buffers are associated to the request, and a request is processed
> independently of other requests.

> While that approach might work for mem-to-mem devices at least in some use
> cases, it is not a feasible approach for other devices. As a consequence,
> will have different API semantics between mem2mem devices and the rest.
I'd
> like to avoid that if possible: this will be similarly visible in the user
> applications as well.


I'd say that the semantics for m2m devices are already significantly
different from non-m2m devices even without Request API, e.g. we have codec
API for codecs. Everyone is aware of this special treatment and it doesn't
seem to be a problem for anyone.

> >
> > I propose to restrict the usage of requests for m2m drivers to the
output
> > queue only. This keeps things simple for both kernel and userspace and
> > avoids complex solutions.

> If there's a convincing reason to use different API semantics, such as the
> relationship between different buffers being unknown to the user, then
> there very likely is a need to associate non-request data with
> request-bound data in the driver. But it'd be better to limit it to where
> it's really needed.

> >
> > Requests only make sense if there is actually configuration you can
apply
> > for each buffer, and while that's true for the output queue, on the
capture
> > queue you just capture the result of whatever the device delivers. I
don't
> > believe there is much if anything you can or want to control per-buffer.

> May there be controls associated with the capture queue buffers?

What would be the value in having such association? Don't we want to
associate thing with particular hardware job (which is represented by a
request) rather than buffer?

Best regards,
Tomasz
