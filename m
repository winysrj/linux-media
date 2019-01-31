Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34CCC169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 10:45:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C296F218AC
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 10:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbfAaKpT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 05:45:19 -0500
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:37690 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726221AbfAaKpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 05:45:19 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id p9qJgAkSQNR5yp9qNgPK9W; Thu, 31 Jan 2019 11:45:17 +0100
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
Message-ID: <a3b1b650-94d7-bb84-41ef-dc4cab0cdae1@xs4all.nl>
Date:   Thu, 31 Jan 2019 11:45:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190124100419.26492-2-tfiga@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfAP1SKWx7vj6JGa6THWk2FZ+ZO1iIWWiwOvdChXk+1pZd6gX7FLXLQz9xmaAgo4ATUdLnK7jMlJYgNO62X4PkhvaJ61jCsy/rXjEkq7oyZNZlxDawpxU
 /xwc5huPIdcqWumW5SaX+V/ReHhMDeg7q7maTIeVaMGdXGe6X44rv+chy6SGUH0MojIDRVY//DU2o/qNX3CW+bfqnyZvTWwqJQ48Ao0DmKoBwy2kwaoX1R2E
 CCgBcLqQtW8gz/cnMe/WAyXuBfzMrx6K+2gZS2twCniDJ2obLhY5Oeg8fUU/jCSq8Q1BG5F45lPREfQxFm0+4lrKEJ51sgVNZPQeaIoI/t+cbc9VDHZeNwEZ
 0YwHEHHjV5TAeHk7D/oCEDAISPOBtRD1OGSDLtrr1T/0uLpjmbvgpLEniYeiy3wUMWp+DhPFhZJBSFhvaYRHD6vD9AOZfPPeSwR/9psnggKx0bMS0iRYgbFK
 9Lbv2wHjDrfRHHx2FbYXAg+FueYMNKSTSKrvCrOD2GeOiuOGxxU4Mao/YIqG0by08lqzpDV1MBCSb5dZ+lJdeNUBqWzHDtv6/Tn8A4uglaZyM/2wukySbqjK
 RVbOdznKsj67uhhgBDjRTfDqluX7ABgM6K+mxybI4dH0GMC86eXAcJoqbKTutufKhesGVzGfa9xGP7BGFLCk6QjCA8cRYFf+TsfVPoefZbgfBIeL3LCKOJvy
 jd5LYUGnenwuHRAk8tKu49QBx2KVIo7ExW742+CgATCZGpT40c2OBUSDU1JTYIMmUZafGazHGVAskJJAx8RZ7stdRtg3irz779mud6GWEtbxQqfO/YEZSpjp
 SlLE/RQ8p/Wf2D+8t3NuqnqtrG1jRHJpNibBRYbeDcMU0c1ETMyqKPV8oL/KxXruWPMQWJ7gpAGvLO7QYjM=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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

<snip>

> +4.  **This step only applies to coded formats that contain resolution information
> +    in the stream.** Continue queuing/dequeuing bitstream buffers to/from the
> +    ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`. The
> +    buffers will be processed and returned to the client in order, until
> +    required metadata to configure the ``CAPTURE`` queue are found. This is
> +    indicated by the decoder sending a ``V4L2_EVENT_SOURCE_CHANGE`` event with
> +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type.
> +
> +    * It is not an error if the first buffer does not contain enough data for
> +      this to occur. Processing of the buffers will continue as long as more
> +      data is needed.
> +
> +    * If data in a buffer that triggers the event is required to decode the
> +      first frame, it will not be returned to the client, until the
> +      initialization sequence completes and the frame is decoded.
> +
> +    * If the client sets width and height of the ``OUTPUT`` format to 0,
> +      calling :c:func:`VIDIOC_G_FMT`, :c:func:`VIDIOC_S_FMT`,
> +      :c:func:`VIDIOC_TRY_FMT` or :c:func:`VIDIOC_REQBUFS` on the ``CAPTURE``
> +      queue will return the ``-EACCES`` error code, until the decoder
> +      configures ``CAPTURE`` format according to stream metadata.

I think this should also include the G/S_SELECTION ioctls, right?

Regards,

	Hans
