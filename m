Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38131 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbeHHFZU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 01:25:20 -0400
Received: by mail-yw1-f68.google.com with SMTP id r3-v6so544286ywc.5
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 20:07:52 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id b11-v6sm2727372ywa.46.2018.08.07.20.07.49
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 20:07:50 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id s68-v6so550073ywg.2
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 20:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl> <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
 <e0da6268-c7f6-1048-83b9-a7e67cfe000e@xs4all.nl> <CAHStOZ7H88GRSZ_U9GeBnd34JrcCL9crJF279zcpGYtJCV-uEQ@mail.gmail.com>
In-Reply-To: <CAHStOZ7H88GRSZ_U9GeBnd34JrcCL9crJF279zcpGYtJCV-uEQ@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 8 Aug 2018 12:07:37 +0900
Message-ID: <CAAFQd5Ce=GhmrD-iuu54r1gGNsooHgRDAAXySHkWDP8PO5_pug@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 8, 2018 at 4:11 AM Maxime Jourdan <maxi.jourdan@wanadoo.fr> wrote:
>
> 2018-08-07 9:13 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> > On 07/26/2018 12:20 PM, Tomasz Figa wrote:
> >> Hi Hans,
> >>
> >> On Wed, Jul 25, 2018 at 8:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>>> +
> >>>> +14. Call :c:func:`VIDIOC_STREAMON` to initiate decoding frames.
> >>>> +
> >>>> +Decoding
> >>>> +========
> >>>> +
> >>>> +This state is reached after a successful initialization sequence. In this
> >>>> +state, client queues and dequeues buffers to both queues via
> >>>> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
> >>>> +semantics.
> >>>> +
> >>>> +Both queues operate independently, following standard behavior of V4L2
> >>>> +buffer queues and memory-to-memory devices. In addition, the order of
> >>>> +decoded frames dequeued from ``CAPTURE`` queue may differ from the order of
> >>>> +queuing coded frames to ``OUTPUT`` queue, due to properties of selected
> >>>> +coded format, e.g. frame reordering. The client must not assume any direct
> >>>> +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
> >>>> +reported by :c:type:`v4l2_buffer` ``timestamp`` field.
> >>>
> >>> Is there a relationship between capture and output buffers w.r.t. the timestamp
> >>> field? I am not aware that there is one.
> >>
> >> I believe the decoder was expected to copy the timestamp of matching
> >> OUTPUT buffer to respective CAPTURE buffer. Both s5p-mfc and coda seem
> >> to be implementing it this way. I guess it might be a good idea to
> >> specify this more explicitly.
> >
> > What about an output buffer producing multiple capture buffers? Or the case
> > where the encoded bitstream of a frame starts at one output buffer and ends
> > at another? What happens if you have B frames and the order of the capture
> > buffers is different from the output buffers?
> >
> > In other words, for codecs there is no clear 1-to-1 relationship between an
> > output buffer and a capture buffer. And we never defined what the 'copy timestamp'
> > behavior should be in that case or if it even makes sense.
> >
> > Regards,
> >
> >         Hans
>
> As it is done right now in userspace (FFmpeg, GStreamer) and most (if
> not all?) drivers, it's a 1:1 between OUTPUT and CAPTURE. The only
> thing that changes is the ordering since OUTPUT buffers are in
> decoding order while CAPTURE buffers are in presentation order.

If I understood it correctly, there is a feature in VP9 that lets one
frame repeat several times, which would make one OUTPUT buffer produce
multiple CAPTURE buffers.

Moreover, V4L2_PIX_FMT_H264 is actually defined to be a byte stream,
without any need for framing, and yes, there are drivers that follow
this definition correctly (s5p-mfc and, AFAIR, coda). In that case,
one OUTPUT buffer can have arbitrary amount of bitstream and lead to
multiple CAPTURE frames being produced.

>
> This almost always implies some timestamping kung-fu to match the
> OUTPUT timestamps with the corresponding CAPTURE timestamps. It's
> often done indirectly by the firmware on some platforms (rpi comes to
> mind iirc).

I don't think there is an upstream driver for it, is there? (If not,
are you aware of any work towards it?)

>
> The current constructions also imply one video packet per OUTPUT
> buffer. If a video packet is too big to fit in a buffer, FFmpeg will
> crop that packet to the maximum buffer size and will discard the
> remaining packet data. GStreamer will abort the decoding. This is
> unfortunately one of the shortcomings of having fixed-size buffers.
> And if they were to split the packet in multiple buffers, then some
> drivers in their current state wouldn't be able to handle the
> timestamping issues and/or x:1 OUTPUT:CAPTURE buffer numbers.

In Chromium, we just allocate OUTPUT buffers big enough to be really
unlikely for a single frame not to fit inside [1]. Obviously it's a
waste of memory, for formats which normally have just single frames
inside buffers, but it seems to work in practice.

[1] https://cs.chromium.org/chromium/src/media/gpu/v4l2/v4l2_video_decode_accelerator.h?rcl=3468d5a59e00bcb2c2e946a30694e6057fd9ab21&l=118

Best regards,
Tomasz
