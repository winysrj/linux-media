Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1760FC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5B2B218A2
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 10:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfAXKiM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:38:12 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42572 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726034AbfAXKiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 05:38:12 -0500
Received: from [IPv6:2001:420:44c1:2579:b544:2b8b:2897:10d8] ([IPv6:2001:420:44c1:2579:b544:2b8b:2897:10d8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id mcOagWy09NR5ymcOdgpVdx; Thu, 24 Jan 2019 11:38:09 +0100
Subject: Re: [PATCH v3 0/2] Document memory-to-memory video codec interfaces
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
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a894dd18-7cc7-aae9-969f-4a3fe18ba2d5@xs4all.nl>
Date:   Thu, 24 Jan 2019 11:38:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190124100419.26492-1-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfBIwtDEzuf8OKaNsFnb6bUa2L0fP9zIy49MpxShf3hDpeTr2l2USJO/J7VEXAZYIjgd6W1r1Mnxx1gV5U7tqhWa+KF7NBnbCJqMwI+LrqeZAimBNpD1U
 Y0MdLz95vk3bCOdq8Ko5JDqMKJUnQrJgPOBGc0vKlWjP1bexrzKBv4hFAnlYcdRuBop9EstyCYGp1jFjFYpU3cQjlJlOfFcfh3WYb6Dlt1jYBKK0E9fTdOlz
 DZnUppJwER5xHc47Ex7PZszUzRp9ITGbE3yXLVqUIQQ5x8qrUQXrHob36/z3qkENhzO//6Kcxuz1Hz3jm5T0A892sSagE4j23aty8m9nHAi41J4iUoOLxZrW
 immwWmEJVcw90sZJkPx1g0QVj7Z619izaQ0AfJ7qW0FiH9vhNd6NKoziwWA4pLDaT2jmRqDw1gOzj2yn7kDgUPQa5tYVXeNmOjMa1dAmzx1EYY6/1yEft/V5
 ZcTUlpqNlehRGSzdvLMhRPoutLy4kH2J2HxFaWlyKy/LhIzA3vCR/Jf7blxhpoPg7z+wi3CIs83M4Yf1F+A6C3U1nsWY3Gh0ja13LUjD77scKkohszINFVpZ
 A4WX7EymaxG8Wo9TkeJTy/X4UMFmhu8y/6SE4AHcERTljVdLHZDzWzVhU/s8HMWpuh2RDPgWaK8Y3hawxid2xAtcN6bRXEE7aQ3XwJsg00ff1BDZOYqWNTx7
 mLpf7TVzjnkvjzLBj9eAF0j4goYUmg5guR1hcJFyfA7PwLskr5FGVl5cpNckOGLXFaqsUIltMfRZ48t9VrFEWJbqrWtyWONrN5+/L9OAS9OlJKH1gKtWCCcC
 OLUw13i6b8EjxJuCK4//Iiu82iM44MP97/vL34GS20OfXEa5mIVN0P981toH3GB2a+CnAwy0rVcsJLpbnnvXa+tJ/0ERrWQrMKawkA+8dRqHUzNifjYL/G2G
 VcAUYxVEa+ChtE+olHZopcCEKBy/IwXcDHzBvwmHCFrjYGtwC10ohaRB/+HlK1uO3Y0R7w==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 01/24/19 11:04, Tomasz Figa wrote:
> Late happy new year everyone. It's been a while, but here is the v3 of
> the stateful mem2mem codec interfaces documentation. Sorry for taking so
> long time to respin. (Again.)
> 
> This series attempts to add the documentation of what was discussed
> during Media Workshops at LinuxCon Europe 2012 in Barcelona and then
> later Embedded Linux Conference Europe 2014 in Düsseldorf and then
> eventually written down by Pawel Osciak and tweaked a bit by Chrome OS
> video team (but mostly in a cosmetic way or making the document more
> precise), during the several years of Chrome OS using the APIs in
> production.
> 
> Note that most, if not all, of the API is already implemented in
> existing mainline drivers, such as s5p-mfc or mtk-vcodec. Intention of
> this series is just to formalize what we already have.
> 
> Thanks everyone for the huge amount of useful comments for the RFC and
> v1. Much of the credits should go to Pawel Osciak too, for writing most
> of the original text of the initial RFC.

Thank you very much for this v3.

I've updated the spec with this v3 + Alexandre's v2 incorporated here:

https://hverkuil.home.xs4all.nl/codec-api/uapi/v4l/dev-mem2mem.html

I plan to review this as soon as I can because I really would like to
get this merged for 5.1.

Regards,

	Hans

> 
> Changes since v2:
> (https://lore.kernel.org/patchwork/cover/1002474/)
> Decoder:
>  - Specified that the initial source change event is signaled
>    regardless of whether the client-set format matches the
>    stream format.
>  - Dropped V4L2_CID_MIN_BUFFERS_FOR_OUTPUT since it's meaningless
>    for the bitstream input buffers of decoders.
>  - Explicitly stated that VIDIOC_REQBUFS is not allowed on CAPTURE
>    if the stream information is not available.
>  - Described decode error handling.
>  - Mentioned that timestamps can be observed after a seek to
>    determine whether the CAPTURE buffers originated from before
>    or after the seek.
>  - Explicitly stated that after a pair of V4L2_DEC_CMD_STOP and
>    V4L2_DEC_CMD_START, the decoder is not reset and preserves
>    all the state.
> 
> Encoder:
>  - Specified that width and height of CAPTURE format are ignored
>    and always zero.
>  - Explicitly noted the common use case for the CROP target with
>    macroblock-unaligned video resolutions.
>  - Added a reference to Request API.
>  - Dropped V4L2_CID_MIN_BUFFERS_FOR_CAPTURE since it's meaningless
>    for the bitstream output buffers of encoders.
>  - Explicitly stated that after a pair of V4L2_ENC_CMD_STOP and
>    V4L2_ENC_CMD_START, the encoder is not reset and preserves
>    all the state.
> 
> General:
>  - Dropped format enumeration from "Initialization", since it's already
>    a part of "Querying capabilities".
>  - Many spelling, grammar, stylistic, etc. changes.
>  - Changed the style of note blocks.
>  - Rebased onto Hans' documentation cleanup series.
>    (https://patchwork.kernel.org/cover/10775407/
>     https://patchwork.kernel.org/patch/10776737/)
>  - Moved the interfaces under the "Video Memory-To-Memory Interface"
>    section.
> 
> For changes since v1 see the v2:
> https://lore.kernel.org/patchwork/cover/1002474/
> 
> For changes since RFC see the v1:
> https://patchwork.kernel.org/cover/10542207/
> 
> Tomasz Figa (2):
>   media: docs-rst: Document memory-to-memory video decoder interface
>   media: docs-rst: Document memory-to-memory video encoder interface
> 
>  Documentation/media/uapi/v4l/dev-decoder.rst  | 1076 +++++++++++++++++
>  Documentation/media/uapi/v4l/dev-encoder.rst  |  586 +++++++++
>  Documentation/media/uapi/v4l/dev-mem2mem.rst  |    6 +
>  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |   10 +
>  Documentation/media/uapi/v4l/v4l2.rst         |   12 +-
>  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
>  .../media/uapi/v4l/vidioc-encoder-cmd.rst     |   38 +-
>  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
>  8 files changed, 1752 insertions(+), 30 deletions(-)
>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
>  create mode 100644 Documentation/media/uapi/v4l/dev-encoder.rst
> 

