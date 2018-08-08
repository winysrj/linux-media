Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:37205 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbeHHFhC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 01:37:02 -0400
Received: by mail-yw1-f66.google.com with SMTP id w76-v6so559911ywg.4
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 20:19:32 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id g16-v6sm1777588ywe.11.2018.08.07.20.19.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Aug 2018 20:19:31 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id 139-v6so541616ywg.12
        for <linux-media@vger.kernel.org>; Tue, 07 Aug 2018 20:19:31 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl> <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
 <e0da6268-c7f6-1048-83b9-a7e67cfe000e@xs4all.nl>
In-Reply-To: <e0da6268-c7f6-1048-83b9-a7e67cfe000e@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 8 Aug 2018 12:11:42 +0900
Message-ID: <CAAFQd5CK6NSy6cmDFmaMNjFwoS1w7jx1zX8WD_80x2LB0LeZLA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
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

On Tue, Aug 7, 2018 at 4:13 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 07/26/2018 12:20 PM, Tomasz Figa wrote:
> > Hi Hans,
> >
> > On Wed, Jul 25, 2018 at 8:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>> +
> >>> +14. Call :c:func:`VIDIOC_STREAMON` to initiate decoding frames.
> >>> +
> >>> +Decoding
> >>> +========
> >>> +
> >>> +This state is reached after a successful initialization sequence. In this
> >>> +state, client queues and dequeues buffers to both queues via
> >>> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
> >>> +semantics.
> >>> +
> >>> +Both queues operate independently, following standard behavior of V4L2
> >>> +buffer queues and memory-to-memory devices. In addition, the order of
> >>> +decoded frames dequeued from ``CAPTURE`` queue may differ from the order of
> >>> +queuing coded frames to ``OUTPUT`` queue, due to properties of selected
> >>> +coded format, e.g. frame reordering. The client must not assume any direct
> >>> +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
> >>> +reported by :c:type:`v4l2_buffer` ``timestamp`` field.
> >>
> >> Is there a relationship between capture and output buffers w.r.t. the timestamp
> >> field? I am not aware that there is one.
> >
> > I believe the decoder was expected to copy the timestamp of matching
> > OUTPUT buffer to respective CAPTURE buffer. Both s5p-mfc and coda seem
> > to be implementing it this way. I guess it might be a good idea to
> > specify this more explicitly.
>
> What about an output buffer producing multiple capture buffers? Or the case
> where the encoded bitstream of a frame starts at one output buffer and ends
> at another? What happens if you have B frames and the order of the capture
> buffers is different from the output buffers?
>
> In other words, for codecs there is no clear 1-to-1 relationship between an
> output buffer and a capture buffer. And we never defined what the 'copy timestamp'
> behavior should be in that case or if it even makes sense.

You're perfectly right. There is no 1:1 relationship, but it doesn't
prevent copying timestamps. It just makes it possible for multiple
CAPTURE buffers to have the same timestamp or some OUTPUT timestamps
not to be found in any CAPTURE buffer.

Best regards,
Tomasz
