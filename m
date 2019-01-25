Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94C2C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 06:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F116218D2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 06:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="X4LK7yLN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfAYGbX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 01:31:23 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:42574 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbfAYGbX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 01:31:23 -0500
Received: by mail-ot1-f48.google.com with SMTP id v23so7581368otk.9
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 22:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQUNGvJM/g0ZS+/IlXJqcOpmo1BVOKu+ydZDCPSc8kg=;
        b=X4LK7yLNFpdhTquR7Vmynl/j6HdQup4EXQMyAJ4LjOAn2rv09+vJmBRRRdeYGAreAn
         nI7e27rV/pkvPnv7rx5PPixWkTklgNLEdyqGZlTtfU09ZxuEHZoz8saRNoLbkmjjWrqO
         sAKkoBHJGaLyvysUC2BDJIPUvRE5bJpOgPUfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQUNGvJM/g0ZS+/IlXJqcOpmo1BVOKu+ydZDCPSc8kg=;
        b=UBRvumh7OGnFai3s5ni/MH6EVJgudB+qjh0hYHzh8MmsZn4vKJ4sxZ71m7YCzrgse5
         14JBM+I26/E97Qh8kCZxY70jx89CbpSbCWmGaDJGjP/EqRZRenoYZOS6HpM8kwZL3/el
         D10Hn2bf/7BQ9+4neVAmGndhzSE2zA2AostgHLfoKOVPU+1MJIfvuGXs63/aZjrIRVG0
         dnKrI5QHQnAjH3/O/hTB4OKH6l0Tb3sjYeLZCqClEDrrY9d/B1Z1YJEbAAP333Rg3fiK
         PvXQRW7E6Ib5ZMpRGKytdkUOEFmhxT+VlF4vgii/3mafuueRE47C1EXYsHheEcFvq0BZ
         tuAA==
X-Gm-Message-State: AJcUukcolkaKsrKA7pVxk/wnze7mg4KQRe2CA1EZiKYjT7JFZZ0VJwaV
        w3b3Gvx004OgcfpAamkQRY2cjmjm7mBcmg==
X-Google-Smtp-Source: ALg8bN7rxfl3o81ncvJsgBqi0IjAFW2r/wOTy8nzBOSqb0A3mWipa6GKvRvdsmWm9Hziu2dD8+tchw==
X-Received: by 2002:a9d:aa9:: with SMTP id 38mr7162181otq.255.1548397881276;
        Thu, 24 Jan 2019 22:31:21 -0800 (PST)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com. [209.85.167.177])
        by smtp.gmail.com with ESMTPSA id l16sm869496otr.13.2019.01.24.22.31.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 22:31:20 -0800 (PST)
Received: by mail-oi1-f177.google.com with SMTP id r62so6979942oie.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 22:31:20 -0800 (PST)
X-Received: by 2002:aca:dec1:: with SMTP id v184mr506690oig.217.1548397879572;
 Thu, 24 Jan 2019 22:31:19 -0800 (PST)
MIME-Version: 1.0
References: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl>
 <20190122112727.12662-4-hverkuil-cisco@xs4all.nl> <4792b823-6eb1-536b-08d6-5cad28bb2f24@xs4all.nl>
In-Reply-To: <4792b823-6eb1-536b-08d6-5cad28bb2f24@xs4all.nl>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Fri, 25 Jan 2019 15:31:07 +0900
X-Gmail-Original-Message-ID: <CAPBb6MV3G8PxeNCM7qtYBQu=MDzpmwUmhbULuEZ8f7p2Ra+F=w@mail.gmail.com>
Message-ID: <CAPBb6MV3G8PxeNCM7qtYBQu=MDzpmwUmhbULuEZ8f7p2Ra+F=w@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] Documentation/media: rename "Codec Interface"
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 23, 2019 at 5:07 PM Hans Verkuil <hverkuil-cisco@xs4all.nl> wrote:
>
> The "Codec Interface" chapter is poorly named since codecs are just one
> use-case of the Memory-to-Memory Interface. Rename it and clean up the
> text a bit.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> Incorporated Tomasz' comments.
>
> Note that I moved the section about codec controls to the end. The idea
> is that when we add the codec specs this section is updated and the
> links to those specs is added there.

Makes sense indeed!

Acked-by: Alexandre Courbot <acourbot@chromium.org>

> ---
>  .../media/uapi/mediactl/request-api.rst       |  4 +-
>  .../v4l/{dev-codec.rst => dev-mem2mem.rst}    | 41 +++++++++----------
>  Documentation/media/uapi/v4l/devices.rst      |  2 +-
>  .../media/uapi/v4l/pixfmt-compressed.rst      |  2 +-
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  2 +-
>  5 files changed, 25 insertions(+), 26 deletions(-)
>  rename Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} (50%)
>
> diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
> index 4b25ad03f45a..1ad631e549fe 100644
> --- a/Documentation/media/uapi/mediactl/request-api.rst
> +++ b/Documentation/media/uapi/mediactl/request-api.rst
> @@ -91,7 +91,7 @@ A request must contain at least one buffer, otherwise ``ENOENT`` is returned.
>  A queued request cannot be modified anymore.
>
>  .. caution::
> -   For :ref:`memory-to-memory devices <codec>` you can use requests only for
> +   For :ref:`memory-to-memory devices <mem2mem>` you can use requests only for
>     output buffers, not for capture buffers. Attempting to add a capture buffer
>     to a request will result in an ``EACCES`` error.
>
> @@ -152,7 +152,7 @@ if it had just been allocated.
>  Example for a Codec Device
>  --------------------------
>
> -For use-cases such as :ref:`codecs <codec>`, the request API can be used
> +For use-cases such as :ref:`codecs <mem2mem>`, the request API can be used
>  to associate specific controls to
>  be applied by the driver for the OUTPUT buffer, allowing user-space
>  to queue many such buffers in advance. It can also take advantage of requests'
> diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-mem2mem.rst
> similarity index 50%
> rename from Documentation/media/uapi/v4l/dev-codec.rst
> rename to Documentation/media/uapi/v4l/dev-mem2mem.rst
> index b5e017c17834..67a980818dc8 100644
> --- a/Documentation/media/uapi/v4l/dev-codec.rst
> +++ b/Documentation/media/uapi/v4l/dev-mem2mem.rst
> @@ -7,37 +7,36 @@
>  ..
>  .. TODO: replace it to GFDL-1.1-or-later WITH no-invariant-sections
>
> -.. _codec:
> +.. _mem2mem:
>
> -***************
> -Codec Interface
> -***************
> +********************************
> +Video Memory-To-Memory Interface
> +********************************
>
> -A V4L2 codec can compress, decompress, transform, or otherwise convert
> -video data from one format into another format, in memory. Typically
> -such devices are memory-to-memory devices (i.e. devices with the
> -``V4L2_CAP_VIDEO_M2M`` or ``V4L2_CAP_VIDEO_M2M_MPLANE`` capability set).
> +A V4L2 memory-to-memory device can compress, decompress, transform, or
> +otherwise convert video data from one format into another format, in memory.
> +Such memory-to-memory devices set the ``V4L2_CAP_VIDEO_M2M`` or
> +``V4L2_CAP_VIDEO_M2M_MPLANE`` capability. Examples of memory-to-memory
> +devices are codecs, scalers, deinterlacers or format converters (i.e.
> +converting from YUV to RGB).
>
>  A memory-to-memory video node acts just like a normal video node, but it
> -supports both output (sending frames from memory to the codec hardware)
> -and capture (receiving the processed frames from the codec hardware into
> +supports both output (sending frames from memory to the hardware)
> +and capture (receiving the processed frames from the hardware into
>  memory) stream I/O. An application will have to setup the stream I/O for
>  both sides and finally call :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
> -for both capture and output to start the codec.
> -
> -Video compression codecs use the MPEG controls to setup their codec
> -parameters
> -
> -.. note::
> -
> -   The MPEG controls actually support many more codecs than
> -   just MPEG. See :ref:`mpeg-controls`.
> +for both capture and output to start the hardware.
>
>  Memory-to-memory devices function as a shared resource: you can
>  open the video node multiple times, each application setting up their
> -own codec properties that are local to the file handle, and each can use
> +own properties that are local to the file handle, and each can use
>  it independently from the others. The driver will arbitrate access to
> -the codec and reprogram it whenever another file handler gets access.
> +the hardware and reprogram it whenever another file handler gets access.
>  This is different from the usual video node behavior where the video
>  properties are global to the device (i.e. changing something through one
>  file handle is visible through another file handle).
> +
> +One of the most common memory-to-memory device is the codec. Codecs
> +are more complicated than most and require additional setup for
> +their codec parameters. This is done through codec controls.
> +See :ref:`mpeg-controls`.
> diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/media/uapi/v4l/devices.rst
> index d6fcf3db5909..07f8d047662b 100644
> --- a/Documentation/media/uapi/v4l/devices.rst
> +++ b/Documentation/media/uapi/v4l/devices.rst
> @@ -21,7 +21,7 @@ Interfaces
>      dev-overlay
>      dev-output
>      dev-osd
> -    dev-codec
> +    dev-mem2mem
>      dev-raw-vbi
>      dev-sliced-vbi
>      dev-radio
> diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> index e4c5e456df59..2675bef3eefe 100644
> --- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> +++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
> @@ -73,7 +73,7 @@ Compressed Formats
>        - 'MG2S'
>        - MPEG-2 parsed slice data, as extracted from the MPEG-2 bitstream.
>         This format is adapted for stateless video decoders that implement a
> -       MPEG-2 pipeline (using the :ref:`codec` and :ref:`media-request-api`).
> +       MPEG-2 pipeline (using the :ref:`mem2mem` and :ref:`media-request-api`).
>         Metadata associated with the frame to decode is required to be passed
>         through the ``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS`` control and
>         quantization matrices can optionally be specified through the
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index 3259168a7358..c138d149faea 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -123,7 +123,7 @@ then ``EINVAL`` will be returned.
>     :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAMON>` or calling :ref:`VIDIOC_REQBUFS`
>     the check for this will be reset.
>
> -   For :ref:`memory-to-memory devices <codec>` you can specify the
> +   For :ref:`memory-to-memory devices <mem2mem>` you can specify the
>     ``request_fd`` only for output buffers, not for capture buffers. Attempting
>     to specify this for a capture buffer will result in an ``EACCES`` error.
>
> --
> 2.20.1
>
>
