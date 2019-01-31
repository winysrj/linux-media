Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A060C169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7294D2087F
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfAaMiK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:38:10 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54433 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726153AbfAaMiJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 07:38:09 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id pBbXgCDjANR5ypBbagPzIB; Thu, 31 Jan 2019 13:38:07 +0100
Subject: Re: [PATCH v3 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
From:   Hans Verkuil <hverkuil@xs4all.nl>
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
 <a3b1b650-94d7-bb84-41ef-dc4cab0cdae1@xs4all.nl>
 <54430438-33a3-2c52-b6c8-4000a4088906@xs4all.nl>
Message-ID: <abee9ef3-7c05-dc2b-43b8-12734a25f5fd@xs4all.nl>
Date:   Thu, 31 Jan 2019 13:38:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <54430438-33a3-2c52-b6c8-4000a4088906@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfF0xa23txqXqaqIKU/rJ8k3GyBz/8bKZrwr/1/jh2YrdeaKW5iU+Am8r9XpVvXaIIL26rM19lalZ/vkD0v3VknbZOz9Nqk+oEwduK3sKT1WSQ/fYU+dD
 gH26YKuKq8vs2OO0Q7TCoX+BzRU/3G/F30RsREeVxfgFeS51rYqndrG3KAvZ/RIDCAEOpjRbeABKS3v5bDldFQDYGQBmpO4hszxdTO/b1E4ZzYrZPzbSWXyC
 06I4OryYrJllqUT6uy5ke/5+0n10vhYt7wzO6syo0IbYfVYKRgCsnvv8EWznGKoMVqjn+c479sLa4v4o2hvkdx6qLkDQ4/7eVFnSv63knXLdBpIUvpHlZGrg
 WKbB2QdRubd+svIMw5ZsliOKGFu1NNPFQf0TkAQlgcNcqmhF7MyXd5Yb9oVI7g+wYxjl+T/kLrUmn58XeQZQxBkB9wRMixx2e4boEH5FkAoZdr11QVKT7XQT
 hVgqBut7VD/IgcXB9Nli4+eBjCsas1eWVoPklftWlDTRgcf4Xmrfb0fSBn0eyqqV/YcLQ5ntWt5slZtd0OSOdTMwDkpRavdNwVNHaa/RF4SUHdhgFMIREZmm
 xG53NHoVC/sNCl71WUZrWA+HIQ/Sz3UH6nDpYnKde0kkva762MuvH8m5q4z27Rx+Uuf3tiqaNdTcschrQLE2gaB9tBpWbiiCdBTUVrMEj0x5hPyhHSsF8vPF
 rP2UewyA7c5TGhodqm1VySG3l/IfzXsZM09R1UEa3yGezGWftKCq/jPaLpiR4EcKm8fXl7DmzOXvkV9XSHGSEJ7Fzn2ufrS+EyBY5F+AyASZRIWDpAxg/niY
 xaNS2FC0rKW5ETDMiz7/0pBVN9cHPUvIfmnj2X4xNRNZiKVTbQtbW5Q6UWpXkV41H91Pmjps6/ZqEVmAW+A=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/31/19 1:30 PM, Hans Verkuil wrote:
> On 1/31/19 11:45 AM, Hans Verkuil wrote:
>> On 1/24/19 11:04 AM, Tomasz Figa wrote:
>>> Due to complexity of the video decoding process, the V4L2 drivers of
>>> stateful decoder hardware require specific sequences of V4L2 API calls
>>> to be followed. These include capability enumeration, initialization,
>>> decoding, seek, pause, dynamic resolution change, drain and end of
>>> stream.
>>>
>>> Specifics of the above have been discussed during Media Workshops at
>>> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
>>> Conference Europe 2014 in Düsseldorf. The de facto Codec API that
>>> originated at those events was later implemented by the drivers we already
>>> have merged in mainline, such as s5p-mfc or coda.
>>>
>>> The only thing missing was the real specification included as a part of
>>> Linux Media documentation. Fix it now and document the decoder part of
>>> the Codec API.
>>>
>>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
>>> ---
>>>  Documentation/media/uapi/v4l/dev-decoder.rst  | 1076 +++++++++++++++++
>>>  Documentation/media/uapi/v4l/dev-mem2mem.rst  |    5 +
>>>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
>>>  Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
>>>  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
>>>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
>>>  6 files changed, 1135 insertions(+), 15 deletions(-)
>>>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
>>>
>>
>> <snip>
>>
>>> +4.  **This step only applies to coded formats that contain resolution information
>>> +    in the stream.** Continue queuing/dequeuing bitstream buffers to/from the
>>> +    ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`. The
>>> +    buffers will be processed and returned to the client in order, until
>>> +    required metadata to configure the ``CAPTURE`` queue are found. This is
>>> +    indicated by the decoder sending a ``V4L2_EVENT_SOURCE_CHANGE`` event with
>>> +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type.
>>> +
>>> +    * It is not an error if the first buffer does not contain enough data for
>>> +      this to occur. Processing of the buffers will continue as long as more
>>> +      data is needed.
>>> +
>>> +    * If data in a buffer that triggers the event is required to decode the
>>> +      first frame, it will not be returned to the client, until the
>>> +      initialization sequence completes and the frame is decoded.
>>> +
>>> +    * If the client sets width and height of the ``OUTPUT`` format to 0,
>>> +      calling :c:func:`VIDIOC_G_FMT`, :c:func:`VIDIOC_S_FMT`,
>>> +      :c:func:`VIDIOC_TRY_FMT` or :c:func:`VIDIOC_REQBUFS` on the ``CAPTURE``
>>> +      queue will return the ``-EACCES`` error code, until the decoder
>>> +      configures ``CAPTURE`` format according to stream metadata.
>>
>> I think this should also include the G/S_SELECTION ioctls, right?
> 
> I've started work on adding compliance tests for codecs to v4l2-compliance and
> I quickly discovered that this 'EACCES' error code is not nice at all.
> 
> The problem is that it is really inconsistent with V4L2 behavior: the basic
> rule is that there always is a format defined, i.e. G_FMT will always return
> a format.
> 
> Suddenly returning an error is actually quite painful to handle because it is
> a weird exception just for the capture queue of a stateful decoder if no
> output resolution is known.
> 
> Just writing that sentence is painful.

Note that adding EACCES support in vicodec was just as painful as adding
v4l2-compliance support for it. So it is also easier to handle this in
the driver if you can just set up a default format.

Regards,

	Hans

> 
> Why not just return some default driver defined format? It will automatically
> be updated once the decoder parsed the bitstream and knows the new resolution.
> 
> It really is just the same behavior as with a resolution change.
> 
> It is also perfectly fine to request buffers for the capture queue for that
> default format. It's pointless, but not a bug.
> 
> Unless I am missing something I strongly recommend changing this behavior.
> 
> Regards,
> 
> 	Hans
> 

