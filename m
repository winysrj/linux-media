Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:44023 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388581AbeHGJ0d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 05:26:33 -0400
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Tomasz Figa <tfiga@chromium.org>
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
References: <20180724140621.59624-1-tfiga@chromium.org>
 <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl>
 <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e0da6268-c7f6-1048-83b9-a7e67cfe000e@xs4all.nl>
Date: Tue, 7 Aug 2018 09:13:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/26/2018 12:20 PM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Wed, Jul 25, 2018 at 8:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> +
>>> +14. Call :c:func:`VIDIOC_STREAMON` to initiate decoding frames.
>>> +
>>> +Decoding
>>> +========
>>> +
>>> +This state is reached after a successful initialization sequence. In this
>>> +state, client queues and dequeues buffers to both queues via
>>> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
>>> +semantics.
>>> +
>>> +Both queues operate independently, following standard behavior of V4L2
>>> +buffer queues and memory-to-memory devices. In addition, the order of
>>> +decoded frames dequeued from ``CAPTURE`` queue may differ from the order of
>>> +queuing coded frames to ``OUTPUT`` queue, due to properties of selected
>>> +coded format, e.g. frame reordering. The client must not assume any direct
>>> +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
>>> +reported by :c:type:`v4l2_buffer` ``timestamp`` field.
>>
>> Is there a relationship between capture and output buffers w.r.t. the timestamp
>> field? I am not aware that there is one.
> 
> I believe the decoder was expected to copy the timestamp of matching
> OUTPUT buffer to respective CAPTURE buffer. Both s5p-mfc and coda seem
> to be implementing it this way. I guess it might be a good idea to
> specify this more explicitly.

What about an output buffer producing multiple capture buffers? Or the case
where the encoded bitstream of a frame starts at one output buffer and ends
at another? What happens if you have B frames and the order of the capture
buffers is different from the output buffers?

In other words, for codecs there is no clear 1-to-1 relationship between an
output buffer and a capture buffer. And we never defined what the 'copy timestamp'
behavior should be in that case or if it even makes sense.

Regards,

	Hans
