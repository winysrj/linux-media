Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E13FC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 13:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF92F20854
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 13:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfCYNMK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:12:10 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43145 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731223AbfCYNMK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 09:12:10 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 8POShfnT7NG8z8POVhOo3Y; Mon, 25 Mar 2019 14:12:07 +0100
Subject: Re: [PATCH v3 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
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
 <20190124100419.26492-3-tfiga@chromium.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cb3c73e0-9481-54d1-8730-69e51655d7d8@xs4all.nl>
Date:   Mon, 25 Mar 2019 14:12:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190124100419.26492-3-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFjHFLLdnOq55cz/nHatxuxhs0wVuFlLjfiFBm3XCnVi2WN2m9QhfWBaoo/jCbFmioncjPdQoo9WWGZF+kx0hkuS/Rhdlew04eVzBDvrkIJMcFYZ7BJZ
 toyF5hDlj70eFQaxYJWS4v7ldnkQNibuOWGeLaAg7HortuegcDRz0NJ75JqL/T5Z6Cic3lOnCUWz84UEp7MVEz51ByXaC6MO0ceS40sBsuVq/5nxIavzn5dZ
 06bXfavr2Q5Ai+c7fylX7jg5Tey/R36wGs/+YUqOMEG4qwsJtuj2uESviy7qkUyoyGtmHEZR5clJYaItwLrhQlidz4UZ9B7uTjtnJSlDEFEWee5OQXXxCLY7
 MraN63SCFjL1dQW0mu4FEWHn82xRC/w70Cs0wT5Stw2uOpWgMcFjQQs8ANe5Q1UOFuJFoRBAWTMihNRjYyfOyxuN6FWmA+DA9k7m+4/C4C/+dd9xW5jKEkTi
 8NNary7rKlQtqc/NBPzhZLEvK9L5Mir3r/KKYbQ8rZWCV6SVy0UgWCFrZQVnxaMkLEPznoBzw1OcUTjMK3aQHqkkInUFDlyUz20TBHB8RcaIVtTtiwervRYk
 Jra3HPJqeKkNtWUXJri6VYQJT9QnpzSJ/1COLhGlvyfLKKKVScRg5TBfTRJ+hplYgxqxH9oeCbVfnwa3N0Rtkm4fVB8AYOM4JZZEs2JFAkG05BxFDYwPI0tB
 u7zb9gaNcTQA2Z5kHaWnoQKzzknXl36c0DCA4J/qqIKjrUnnWPgIiCYb6hgYYBHI9gvse4QCPSgsZVICDAGmhKlbcD89fHEGIZlc+aovIaf/t5FKxnx3lcQO
 x6/FkVWtrZ2H74iE8TCwXi5Q2r+UoijB285LdwAmAxTMkirVOVwYjAt6FNTRgnonelGUDearf+ayYfAqSdM=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Another comment found while creating compliance tests:

On 1/24/19 11:04 AM, Tomasz Figa wrote:
> +Drain
> +=====
> +
> +To ensure that all the queued ``OUTPUT`` buffers have been processed and the
> +related ``CAPTURE`` buffers are given to the client, the client must follow the
> +drain sequence described below. After the drain sequence ends, the client has
> +received all encoded frames for all ``OUTPUT`` buffers queued before the
> +sequence was started.
> +
> +1. Begin the drain sequence by issuing :c:func:`VIDIOC_ENCODER_CMD`.
> +
> +   * **Required fields:**
> +
> +     ``cmd``
> +         set to ``V4L2_ENC_CMD_STOP``
> +
> +     ``flags``
> +         set to 0
> +
> +     ``pts``
> +         set to 0
> +
> +   .. warning::
> +
> +      The sequence can be only initiated if both ``OUTPUT`` and ``CAPTURE``
> +      queues are streaming. For compatibility reasons, the call to
> +      :c:func:`VIDIOC_ENCODER_CMD` will not fail even if any of the queues is
> +      not streaming, but at the same time it will not initiate the `Drain`
> +      sequence and so the steps described below would not be applicable.
> +
> +2. Any ``OUTPUT`` buffers queued by the client before the
> +   :c:func:`VIDIOC_ENCODER_CMD` was issued will be processed and encoded as
> +   normal. The client must continue to handle both queues independently,
> +   similarly to normal encode operation. This includes:
> +
> +   * queuing and dequeuing ``CAPTURE`` buffers, until a buffer marked with the
> +     ``V4L2_BUF_FLAG_LAST`` flag is dequeued,
> +
> +     .. warning::
> +
> +        The last buffer may be empty (with :c:type:`v4l2_buffer`
> +        ``bytesused`` = 0) and in that case it must be ignored by the client,
> +        as it does not contain an encoded frame.
> +
> +     .. note::
> +
> +        Any attempt to dequeue more buffers beyond the buffer marked with
> +        ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> +        :c:func:`VIDIOC_DQBUF`.
> +
> +   * dequeuing processed ``OUTPUT`` buffers, until all the buffers queued
> +     before the ``V4L2_ENC_CMD_STOP`` command are dequeued,
> +
> +   * dequeuing the ``V4L2_EVENT_EOS`` event, if the client subscribes to it.
> +
> +   .. note::
> +
> +      For backwards compatibility, the encoder will signal a ``V4L2_EVENT_EOS``
> +      event when the last frame has been decoded and all frames are ready to be
> +      dequeued. It is deprecated behavior and the client must not rely on it.
> +      The ``V4L2_BUF_FLAG_LAST`` buffer flag should be used instead.
> +
> +3. Once all ``OUTPUT`` buffers queued before the ``V4L2_ENC_CMD_STOP`` call are
> +   dequeued and the last ``CAPTURE`` buffer is dequeued, the encoder is stopped
> +   and it will accept, but not process any newly queued ``OUTPUT`` buffers
> +   until the client issues any of the following operations:
> +
> +   * ``V4L2_ENC_CMD_START`` - the encoder will not be reset and will resume
> +     operation normally, with all the state from before the drain,

I assume that calling CMD_START when *not* draining will succeed but does nothing.

In other words: while draining is in progress START will return EBUSY. When draining
was finished, then START will resume the encoder. In all other cases it just returns
0 since the encoder is really already started.

> +
> +   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
> +     ``CAPTURE`` queue - the encoder will be reset (see the `Reset` sequence)
> +     and then resume encoding,
> +
> +   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
> +     ``OUTPUT`` queue - the encoder will resume operation normally, however any
> +     source frames queued to the ``OUTPUT`` queue between ``V4L2_ENC_CMD_STOP``
> +     and :c:func:`VIDIOC_STREAMOFF` will be discarded.
> +
> +.. note::
> +
> +   Once the drain sequence is initiated, the client needs to drive it to
> +   completion, as described by the steps above, unless it aborts the process by
> +   issuing :c:func:`VIDIOC_STREAMOFF` on any of the ``OUTPUT`` or ``CAPTURE``
> +   queues.  The client is not allowed to issue ``V4L2_ENC_CMD_START`` or
> +   ``V4L2_ENC_CMD_STOP`` again while the drain sequence is in progress and they
> +   will fail with -EBUSY error code if attempted.

I assume calling STOP again once the drain sequence completed just returns 0 and
doesn't do anything else (since we're already stopped).

> +
> +   Although mandatory, the availability of encoder commands may be queried
> +   using :c:func:`VIDIOC_TRY_ENCODER_CMD`.

Some corner cases:

1) No buffers are queued on either vb2_queue, but STREAMON is called for both queues.
   Now ENC_CMD_STOP is issued. What should happen?

   Proposal: the next time the applications queues a CAPTURE buffer it is returned
   at once as an empty buffer with FLAG_LAST set.

2) Both queues are streaming and buffers have been encoded, but currently no buffers
   are queued on either vb2_queue. Now ENC_CMD_STOP is issued. What should happen?

   Proposal: the next time the applications queues a CAPTURE buffer it is returned
   at once as an empty buffer with FLAG_LAST set. This is consistent with the
   previous corner case.

3) The CAPTURE queue contains buffers, the OUTPUT queue does not. Now ENC_CMD_STOP
   is issued. What should happen?

   Proposal: the oldest CAPTURE buffer in the ready queue is returned as an empty
   buffer with FLAG_LAST set.

4) Both queues have queued buffers. ENC_CMD_STOP is issued to start the drain process.
   Before the drain process completes STREAMOFF is called for either CAPTURE or
   OUTPUT queue. What should happen?

   Proposal for STREAMOFF(CAPTURE): aborts the drain process and all CAPTURE buffers are
   returned to userspace. If encoding is restarted, then any remaining OUTPUT buffers
   will be used as input to the encoder.

   Proposal for STREAMOFF(OUTPUT): the next capture buffer will be empty and have
   FLAG_LAST set.

Some of this might have to be documented, but these corner cases should certainly be
tested by v4l2-compliance. Before I write those tests I'd like to know if you agree
with this.

Regards,

	Hans
