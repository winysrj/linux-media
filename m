Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4810C169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 13:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76B7D20989
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 13:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfA2NLZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 08:11:25 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:56001 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbfA2NLY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 08:11:24 -0500
Received: from [IPv6:2001:420:44c1:2579:1c83:9203:362b:bf24] ([IPv6:2001:420:44c1:2579:1c83:9203:362b:bf24])
        by smtp-cloud9.xs4all.net with ESMTPA
        id oTAZg1kDkRO5ZoTAcgO1SG; Tue, 29 Jan 2019 14:11:21 +0100
Subject: Re: [PATCH v3 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To:     Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?= 
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
References: <20190124100419.26492-1-tfiga@chromium.org>
 <20190124100419.26492-2-tfiga@chromium.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <961accdd-307f-fc97-5c21-5f1576a3d0bf@xs4all.nl>
Date:   Tue, 29 Jan 2019 14:11:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190124100419.26492-2-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfB3++iqZwzV5DZg6WIG+NKOLgaZry2XTHeoE2UKdctkw8k1u3c6PD/I1PClSoLT47OPojAtNyiY9+GkZzxycoaaXaZbkV84bYz/+N6+XGWBn73HLB4ey
 DKJs1F8olSDG4p0Lm7IJwdbM1P+CeMdiRGs1R02i+dnt1fiEgbr8b6FLaGnDzBiRd52w9J7YVgO9WOmO8FrwLeKhPgj2329Ioe15YzF0l7ur5rk48Z22zpxU
 2JEkumCJvBcNuVnqIFdb18J3rXJoKt8PfQ1cePyG3UxxdFtDM4S2fM2HmllmU7Qy7QSY2rPvkyCY/oOj4aYiTF/U2BK4jJcN7bJSkbFbARGhZKWrjtrC1dR5
 j9nkY+3Y767G2NNC80f3cOOkAt63XGLhBzdPjudzVvhZdwaLNKt7YmEX3uRv+Igptl4eGpG4JeIcpZefU7EBckiNzZ1dJYnD8knQxGKcJ0oDVSN7jpuMUyv0
 R+H6j+SCU2v3V8URuyhxIA1ajNemQNtVuBbt8Sw9yUso/+EHieWzGDmm4KbFSLOHJSZCgG+GVldsCNos+ms0wvL+b4P4tP6E9tTZVe/nnzwxe/OUOqbFRmZ9
 HaGJHUHEatri4JDH+8hORyt064OCJfUK5UhbzKJfsN/W78wUZW0DKdljqq5q7Sw0hnTqxca3DBKmhKhEFIYKQaF6DDlnXysNK514tueuX0g4QJnmRX0AOhu7
 ocnxQhhGl29VqbZ++y2IK48FOKDN1iijfnHulwuTXUQJeokV7ItbZuQqLgKPqYJOUzgNsXq+1JWecv76FS6uxqPkdCQShKr/4PAOlREJhlg9uiDrvY7gAVou
 xXmN9xCIiOm6NsRmtXniCcC/diPyvdcdEf0VvF77pEZXM3/d6wznl1VjGKLDZ8vdjRpH/JtW9tTuXXMhgauOY0Ss/Ka3EhB+rrdPV9UaKunKACOqcea/qO6h
 Qg/HwMPjupT+48jlii1q3m9GJSe5h0r3VyCVEhDD7zM3cIjGnplFRgfnQiBt2pck9jYCKA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tomasz,

Just one typo and a wrong year in a copyright:

On 1/24/19 11:04 AM, Tomasz Figa wrote:
> Due to complexity of the video decoding process, the V4L2 drivers of
> stateful decoder hardware require specific sequences of V4L2 API calls
> to be followed. These include capability enumeration, initialization,
> decoding, seek, pause, dynamic resolution change, drain and end of
> stream.
> 
> Specifics of the above have been discussed during Media Workshops at
> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
> originated at those events was later implemented by the drivers we already
> have merged in mainline, such as s5p-mfc or coda.
> 
> The only thing missing was the real specification included as a part of
> Linux Media documentation. Fix it now and document the decoder part of
> the Codec API.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  Documentation/media/uapi/v4l/dev-decoder.rst  | 1076 +++++++++++++++++
>  Documentation/media/uapi/v4l/dev-mem2mem.rst  |    5 +
>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
>  Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
>  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
>  6 files changed, 1135 insertions(+), 15 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> 
> diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst b/Documentation/media/uapi/v4l/dev-decoder.rst
> new file mode 100644
> index 000000000000..b7db2352ad41
> --- /dev/null
> +++ b/Documentation/media/uapi/v4l/dev-decoder.rst

<snip>

> +Decoding
> +========
> +
> +This state is reached after the `Capture setup` sequence finishes successfully.
> +In this state, the client queues and dequeues buffers to both queues via
> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following the standard
> +semantics.
> +
> +The contents of the source ``OUTPUT`` buffers depend on the active coded pixel
> +format and may be affected by codec-specific extended controls, as stated in
> +the documentation of each format.
> +
> +Both queues operate independently, following the standard behavior of V4L2
> +buffer queues and memory-to-memory devices. In addition, the order of decoded
> +frames dequeued from the ``CAPTURE`` queue may differ from the order of queuing
> +coded frames to the ``OUTPUT`` queue, due to properties of the selected coded
> +format, e.g. frame reordering.
> +
> +The client must not assume any direct relationship between ``CAPTURE``
> +and ``OUTPUT`` buffers and any specific timing of buffers becoming
> +available to dequeue. Specifically:
> +
> +* a buffer queued to ``OUTPUT`` may result in no buffers being produced
> +  on ``CAPTURE`` (e.g. if it does not contain encoded data, or if only
> +  metadata syntax structures are present in it),
> +
> +* a buffer queued to ``OUTPUT`` may result in more than 1 buffer produced
> +  on ``CAPTURE`` (if the encoded data contained more than one frame, or if
> +  returning a decoded frame allowed the decoder to return a frame that
> +  preceded it in decode, but succeeded it in the display order),
> +
> +* a buffer queued to ``OUTPUT`` may result in a buffer being produced on
> +  ``CAPTURE`` later into decode process, and/or after processing further
> +  ``OUTPUT`` buffers, or be returned out of order, e.g. if display
> +  reordering is used,
> +
> +* buffers may become available on the ``CAPTURE`` queue without additional
> +  buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), because of the
> +  ``OUTPUT`` buffers queued in the past whose decoding results are only
> +  available at later time, due to specifics of the decoding process.
> +
> +.. note::
> +
> +   To allow matching decoded ``CAPTURE`` buffers with ``OUTPUT`` buffers they
> +   originated from, the client can set the ``timestamp`` field of the
> +   :c:type:`v4l2_buffer` struct when queuing an ``OUTPUT`` buffer. The
> +   ``CAPTURE`` buffer(s), which resulted from decoding that ``OUTPUT`` buffer
> +   will have their ``timestamp`` field set to the same value when dequeued.
> +
> +   In addition to the straightforward case of one ``OUTPUT`` buffer producing
> +   one ``CAPTURE`` buffer, the following cases are defined:
> +
> +   * one ``OUTPUT`` buffer generates multiple ``CAPTURE`` buffers: the same
> +     ``OUTPUT`` timestamp will be copied to multiple ``CAPTURE`` buffers,
> +
> +   * multiple ``OUTPUT`` buffers generate one ``CAPTURE`` buffer: timestamp of
> +     the ``OUTPUT`` buffer queued last will be copied,
> +
> +   * the decoding order differs from the display order (i.e. the ``CAPTURE``
> +     buffers are out-of-order compared to the ``OUTPUT`` buffers): ``CAPTURE``
> +     timestamps will not retain the order of ``OUTPUT`` timestamps.
> +
> +During the decoding, the decoder may initiate one of the special sequences, as
> +listed below. The sequences will result in the decoder returning all the
> +``CAPTURE`` buffers that originated from all the ``OUTPUT`` buffers processed
> +before the sequence started. Last of the buffers will have the
> +``V4L2_BUF_FLAG_LAST`` flag set. To determine the sequence to follow, the client
> +must check if there is any pending event and:
> +
> +* if a ``V4L2_EVENT_SOURCE_CHANGE`` event is pending, the `Dynamic resolution
> +  change` sequence needs to be followed,
> +
> +* if a ``V4L2_EVENT_EOS`` event is pending, the `End of stream` sequence needs
> +  to be followed.
> +
> +Some of the sequences can be intermixed with each other and need to be handled
> +as they happen. The exact operation is documented for each sequence.
> +
> +Should a decoding error occur, it will be reported to the client with the level
> +of details depending on the decoder capabilities. Specifically:
> +
> +* the CAPTURE buffer that contains the results of the failed decode operation
> +  will be returned with the V4L2_BUF_FLAG_ERROR flag set,
> +
> +* if the decoder is able to precisely report the OUTPUT buffer that triggered
> +  the error, such bufffer will be returned with the V4L2_BUF_FLAG_ERROR flag
> +  set.
> +
> +In case of a fatal failure that does not allow the decoding to continue, any
> +further opertions on corresponding decoder file handle will return the -EIO

opertions on corresponding decoder -> operations on the corresponding decoder

> +error code. The client may close the file handle and open a new one, or
> +alternatively reinitialize the instance by stopping streaming on both queues,
> +releasing all buffers and performing the Initialization sequence again.
> +

<snip>

> diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/media/uapi/v4l/v4l2.rst
> index 004ec00db6bd..97015b9b40b8 100644
> --- a/Documentation/media/uapi/v4l/v4l2.rst
> +++ b/Documentation/media/uapi/v4l/v4l2.rst
> @@ -60,6 +60,10 @@ Authors, in alphabetical order:
>  
>    - Original author of the V4L2 API and documentation.
>  
> +- Figa, Tomasz <tfiga@chromium.org>
> +
> +  - Documented the memory-to-memory decoder interface.
> +
>  - H Schimek, Michael <mschimek@gmx.at>
>  
>    - Original author of the V4L2 API and documentation.
> @@ -68,6 +72,10 @@ Authors, in alphabetical order:
>  
>    - Documented the Digital Video timings API.
>  
> +- Osciak, Pawel <posciak@chromium.org>
> +
> +  - Documented the memory-to-memory decoder interface.
> +
>  - Osciak, Pawel <pawel@osciak.com>
>  
>    - Designed and documented the multi-planar API.
> @@ -92,7 +100,7 @@ Authors, in alphabetical order:
>  
>    - Designed and documented the VIDIOC_LOG_STATUS ioctl, the extended control ioctls, major parts of the sliced VBI API, the MPEG encoder and decoder APIs and the DV Timings API.
>  
> -**Copyright** |copy| 1999-2016: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari.
> +**Copyright** |copy| 1999-2018: Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab, Pawel Osciak, Sakari Ailus & Antti Palosaari, Tomasz Figa

2018 -> 2019

>  
>  Except when explicitly stated as GPL, programming examples within this
>  part can be used and distributed without restrictions.

Just let me know that you are OK with these changes and I can fix up this
patch myself. It looks great and I am ready to merge this patch.

Regards,

	Hans
