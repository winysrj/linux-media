Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BA1C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 06:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7901C20989
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 06:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Uyoff7v8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfA1GB3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 01:01:29 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42238 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfA1GB2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 01:01:28 -0500
Received: by mail-oi1-f196.google.com with SMTP id w13so12072655oiw.9
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 22:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vFcdm97ZQVqY+sV8pPGkw6BS+L2oAzaBBnHbL8dP6qY=;
        b=Uyoff7v8XzH8f5DxoBbglk0HZJLuF+9E8p7lxgKwVrvu5ZYWUGmCiADjNdzSzDki9M
         dn31m0DG6cwz/d8+NwWxZI5CL2SMMzbEKpvOXMMgXKMY14+ciHrdd9LNFavU5QXk+l0Q
         eMU36ihXXuctBaDC0u8ivl7W6QrPxSq8SdAYw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vFcdm97ZQVqY+sV8pPGkw6BS+L2oAzaBBnHbL8dP6qY=;
        b=UnWVDEcB/9pdNE3bYWHskOcu0gijwJgpr88GBPSC5CQemtSwILb9oo6WKkNHLYM0LR
         ha71jpEqG1syEZfqygc/V6QSC3iy4NaidMrc9tKAuQhm5d/gE+3b+Ihz7Vk6V0hg8S41
         6hI+6mz/sMNvSLoPQ15Ej2toUByMu0syI7YXTqXcaUMMGcnXEHNB/vhaRb3SUZcVnh8F
         TxE4dk3CSd+LSpWPJjHE111wE27EOxLMoTtxeg3302g3W2w24L4EQzKvEL25C2lID3ps
         puLwIh7yknmKUWdB1CeuE+e0rtPrkVclfsnqe2VRZhgEIXPC1waC60fGiGFwHZV5D6ve
         qxMg==
X-Gm-Message-State: AHQUAua5FBd2ulvpvcUw1LLbV8R30lJoLYH9eqdoRUO1aSchMYgYDGCY
        8I21m54V+/9Pt/cySYTn27MBSemrvJY=
X-Google-Smtp-Source: ALg8bN5g9PgnW0sDHRnSVcSfOr0bTHSXhA34STuESLlyhZZ/ZR8BWfRzxmtPX3L67qVoeVyaBCxyXA==
X-Received: by 2002:aca:7c5:: with SMTP id 188mr4856423oih.313.1548655287691;
        Sun, 27 Jan 2019 22:01:27 -0800 (PST)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id j23sm4679896oih.22.2019.01.27.22.01.27
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Jan 2019 22:01:27 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id x202so12062523oif.13
        for <linux-media@vger.kernel.org>; Sun, 27 Jan 2019 22:01:27 -0800 (PST)
X-Received: by 2002:a54:4486:: with SMTP id v6mr5215060oiv.233.1548654879619;
 Sun, 27 Jan 2019 21:54:39 -0800 (PST)
MIME-Version: 1.0
References: <20181115145650.9827-1-maxime.ripard@bootlin.com> <20181115145650.9827-2-maxime.ripard@bootlin.com>
In-Reply-To: <20181115145650.9827-2-maxime.ripard@bootlin.com>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Mon, 28 Jan 2019 14:54:27 +0900
X-Gmail-Original-Message-ID: <CAPBb6MX9=+k=5M-w7SyCUAKUceAXN7UG_6==tFx4RhR13Etdwg@mail.gmail.com>
Message-ID: <CAPBb6MX9=+k=5M-w7SyCUAKUceAXN7UG_6==tFx4RhR13Etdwg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: uapi: Add H264 low-level decoder API
 compound controls.
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        jenskuske@gmail.com, linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Guenter Roeck <groeck@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Nov 15, 2018 at 11:56 PM Maxime Ripard
<maxime.ripard@bootlin.com> wrote:
>
> From: Pawel Osciak <posciak@chromium.org>
>
> Stateless video codecs will require both the H264 metadata and slices in
> order to be able to decode frames.
>
> This introduces the definitions for a new pixel format for H264 slices that
> have been parsed, as well as the structures used to pass the metadata from
> the userspace to the kernel.
>
> Co-Developed-by: Maxime Ripard <maxime.ripard@bootlin.com>
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Guenter Roeck <groeck@chromium.org>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

<snip>

> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index b854cceb19dc..e96c453208e8 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -825,6 +825,11 @@ const char *v4l2_ctrl_get_name(u32 id)
>         case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of HC Layers";
>         case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
>                                                                 return "H264 Set QP Value for HC Layers";
> +       case V4L2_CID_MPEG_VIDEO_H264_SPS:                      return "H264 SPS";
> +       case V4L2_CID_MPEG_VIDEO_H264_PPS:                      return "H264 PPS";
> +       case V4L2_CID_MPEG_VIDEO_H264_SCALING_MATRIX:           return "H264 Scaling Matrix";
> +       case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAMS:             return "H264 Slice Parameters";
> +       case V4L2_CID_MPEG_VIDEO_H264_DECODE_PARAMS:            return "H264 Decode Parameters";
>         case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:              return "MPEG4 I-Frame QP Value";
>         case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:              return "MPEG4 P-Frame QP Value";
>         case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:              return "MPEG4 B-Frame QP Value";

To make things future-proof I think it may be good to add a control
specifying the granularity of data sent with each request (see
https://lkml.org/lkml/2019/1/24/147).

Right now we have a consensus that to make things simple, we request
one frame of encoded data per request. But this will probably be
relaxed in the future, since allowing to process things at lower
granularity may improve latency. Moreover the granularity accepted by
the encoder is hardware/firmware dependent, so it is probably a good
idea to expose this from the beginning.

How about a new V4L2_CID_MPEG_VIDEO_H264_GRANULARITY control with only
one value at the moment, namely
V4L2_MPEG_VIDEO_H264_GRANULARITY_FRAME? We could extend this in the
future, and that way user-space will have no excuse for not checking
that the codec supports the input granularity it will send.

I'm wondering whether this could be made codec-independent, but I'm
afraid this would add confusion.
