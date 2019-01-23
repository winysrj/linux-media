Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB25C282C3
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 03:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8924D2085A
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 03:17:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Uz/SLNyb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfAWDR4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 22:17:56 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36662 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfAWDR4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 22:17:56 -0500
Received: by mail-ot1-f65.google.com with SMTP id k98so702103otk.3
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 19:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H+pJ28AT9sjEDq5MtBvLMOfDWKq6f3BVWATRbUyuNmk=;
        b=Uz/SLNybj6kkHSAMJd06tZkj8SzeMS6Iv7w0jWVcWW/orbPaDhfkab5a3RsmCNQ5Rd
         hv/xPKKLsW/YzZyPcrwXA8HaxBzL4i9X38spqv95ZNNZFxCKZHznW4tkPOq7srQon+fQ
         g3dsH5NuIGgzjLb5oycyC+FzDsS7qLqtJFl8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H+pJ28AT9sjEDq5MtBvLMOfDWKq6f3BVWATRbUyuNmk=;
        b=JPLWFmKx4T8+qy/0uRCwTrO2C5sT2BuEXbFBCVzWOXiHWm3hez74DQR3pGRm2PPrcz
         Q1NNFonzfs1IokEBGfgFpMDQsFfbsoKsZR51Y9qivgerzSFokHVSiDs9DLlYEKySX7+8
         D9LLL0hjjvbG3y/VKENQN6blnxcGXgwpGs6/E5dEwSTVevl/GUnCQqPMlQ3KPnJAzm4t
         /mcBa234TYhgEsA+LwsiLc3QgYq08hU293lyrpVIVJr03F7e3L+FQqiq2cZO3tw+QQxx
         tHYJOGpQMuBi+HNcDM1BMqQXV3SXqJhp8P4sd3fsUptsv/bDfloD84WxXUA04njK/OsU
         7oww==
X-Gm-Message-State: AJcUukdWUZ6fVxJ6uPZjzarulv/YMi4oxokCXFl8EtWJZi5fTZs3YTYq
        wkjx1bGTG7hOy7dAl5nxwkR1q5zfKeT2uA==
X-Google-Smtp-Source: ALg8bN4nNOYjO3G1iMzOx+hPcZi2MZCNvrXVE73o26hQTqzSHvMLp9xdQdI2526AAAvvrNbj1JaUtQ==
X-Received: by 2002:a9d:32c7:: with SMTP id u65mr336668otb.236.1548213474773;
        Tue, 22 Jan 2019 19:17:54 -0800 (PST)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id t201sm8262330oie.37.2019.01.22.19.17.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 19:17:53 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id 32so655363ota.12
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 19:17:53 -0800 (PST)
X-Received: by 2002:a9d:1d65:: with SMTP id m92mr336911otm.65.1548213473141;
 Tue, 22 Jan 2019 19:17:53 -0800 (PST)
MIME-Version: 1.0
References: <20190122112727.12662-1-hverkuil-cisco@xs4all.nl> <20190122112727.12662-4-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20190122112727.12662-4-hverkuil-cisco@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 23 Jan 2019 12:17:42 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DDGJnRMFq+f5o4YzOaRPPWUzWWr6woOeEa8+tBUz_1fQ@mail.gmail.com>
Message-ID: <CAAFQd5DDGJnRMFq+f5o4YzOaRPPWUzWWr6woOeEa8+tBUz_1fQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] Documentation/media: rename "Codec Interface"
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Tue, Jan 22, 2019 at 8:27 PM <hverkuil-cisco@xs4all.nl> wrote:
>
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>
> The "Codec Interface" chapter is poorly named since codecs are just one
> use-case of the Memory-to-Memory Interface. Rename it and clean up the
> text a bit.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  .../media/uapi/mediactl/request-api.rst       |  4 ++--
>  .../v4l/{dev-codec.rst => dev-mem2mem.rst}    | 21 +++++++------------
>  Documentation/media/uapi/v4l/devices.rst      |  2 +-
>  .../media/uapi/v4l/pixfmt-compressed.rst      |  2 +-
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  2 +-
>  5 files changed, 13 insertions(+), 18 deletions(-)
>  rename Documentation/media/uapi/v4l/{dev-codec.rst => dev-mem2mem.rst} (79%)
>

Thanks for this cleanup! Indeed it makes much more sense with your
changes. Some comments inline.

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

I guess this should eventually be made to point to the codec sections.
Alex, perhaps it would make sense to do it in your documentation
patch.

>  to associate specific controls to
>  be applied by the driver for the OUTPUT buffer, allowing user-space
>  to queue many such buffers in advance. It can also take advantage of requests'
> diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-mem2mem.rst
> similarity index 79%
> rename from Documentation/media/uapi/v4l/dev-codec.rst
> rename to Documentation/media/uapi/v4l/dev-mem2mem.rst
> index b5e017c17834..69efcc747588 100644
> --- a/Documentation/media/uapi/v4l/dev-codec.rst
> +++ b/Documentation/media/uapi/v4l/dev-mem2mem.rst
> @@ -7,11 +7,11 @@
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
> +Video Memory To Memory Interface
> +********************************
>
>  A V4L2 codec can compress, decompress, transform, or otherwise convert

Codec still left here.

>  video data from one format into another format, in memory. Typically
> @@ -25,19 +25,14 @@ memory) stream I/O. An application will have to setup the stream I/O for
>  both sides and finally call :ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>`
>  for both capture and output to start the codec.

Ditto.

>
> -Video compression codecs use the MPEG controls to setup their codec
> -parameters
> -
> -.. note::
> -
> -   The MPEG controls actually support many more codecs than
> -   just MPEG. See :ref:`mpeg-controls`.
> +Video compression codecs use codec controls to setup their codec parameters.
> +See :ref:`mpeg-controls`.
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

Reference to be updated later too.

Best regards,
Tomasz
