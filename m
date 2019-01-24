Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E956FC282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 05:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7418218A4
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 05:49:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kvW8VMnw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfAXFta (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 00:49:30 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43078 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbfAXFta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 00:49:30 -0500
Received: by mail-oi1-f194.google.com with SMTP id u18so3894504oie.10
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 21:49:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qOjfNUBPlZ/r11vW38GQAjEu9BGH8jAWQXqsZUqQEQY=;
        b=kvW8VMnwXbVrceGdYdMTzAAlnKObyci/84w/nmFf8N8+eEFXOFYd9JaGYohDM/ZagF
         CYZarj+Q0tWLfEZKG/oaymdlpsbc86CqM46lUmWExDQZ0kg67ALweElediCUntHnv17O
         FB8kEwdOMGp25KjlCUgCy4zYUi/aqRgzneNss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qOjfNUBPlZ/r11vW38GQAjEu9BGH8jAWQXqsZUqQEQY=;
        b=PnMrHojO0GIr12wKrhFTLjbMt5etN9gnfbnMG7Px5wl0bCFoSxz7P0fvWI2Kg7lV0X
         uUX+I1dCkhJxD4WCT+us8kPK+qkLxYmXsMT1X2EijATjFgtg4QCI8dIa4pC0mjQWAi5U
         uURZg/YoTqBHO3DJd3zThcVUQ59vBClw+GdmDxMDaoIZMJroTzP7H6Xa4txVJDOfNEgR
         dycJxQoSqvK3fqwDvqe0iFVa5yzI7J7GVJLYc18qHlA0kOUD68TV67STqzAhaPC/SImN
         /iRVcTkpHCa6uehMKBvTx/qBQjksl4S03gug69iALmVIYMoyvCeS491gEPcdaS+CmMIV
         4KXg==
X-Gm-Message-State: AJcUukfNk7YlGZYhIoIaWHs3DdKffENb97cO5Ym4RtmvmEFeK3846nmt
        n17yctIJdj6FHNTBE7dF4R8QDPKnlo0=
X-Google-Smtp-Source: ALg8bN4zG+xcRfAnS/QRtf7QKIVyeBsLyKW1lrReDlwpzLANXpD7adwN2+ALvkryuCRXMdy9nQ9IwA==
X-Received: by 2002:aca:5641:: with SMTP id k62mr241480oib.339.1548308966585;
        Wed, 23 Jan 2019 21:49:26 -0800 (PST)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com. [209.85.210.49])
        by smtp.gmail.com with ESMTPSA id n3sm11263248oia.3.2019.01.23.21.49.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 21:49:25 -0800 (PST)
Received: by mail-ot1-f49.google.com with SMTP id v23so4218488otk.9
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 21:49:25 -0800 (PST)
X-Received: by 2002:a9d:1d65:: with SMTP id m92mr3525960otm.65.1548308964909;
 Wed, 23 Jan 2019 21:49:24 -0800 (PST)
MIME-Version: 1.0
References: <c29a6f08-a450-73aa-c79d-93cdcbf416ae@xs4all.nl>
In-Reply-To: <c29a6f08-a450-73aa-c79d-93cdcbf416ae@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 24 Jan 2019 14:49:14 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BZnH_fuAVOf9cNWroKqDSYHUJ2HAFoebiqf9duDdrOYg@mail.gmail.com>
Message-ID: <CAAFQd5BZnH_fuAVOf9cNWroKqDSYHUJ2HAFoebiqf9duDdrOYg@mail.gmail.com>
Subject: Re: [PATCH] vb2: vb2_find_timestamp: drop restriction on buffer state
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Wed, Jan 23, 2019 at 5:30 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> There really is no reason why vb2_find_timestamp can't just find
> buffers in any state. Drop that part of the test.
>
> This also means that vb->timestamp should only be set to 0 when a
> capture buffer is queued AND when the driver doesn't copy timestamps.
>
> This change allows for more efficient pipelining (i.e. you can use
> a buffer for a reference frame even when it is queued).
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 75ea90e795d8..2a093bff0bf5 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -567,7 +567,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
>         struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>         unsigned int plane;
>
> -       if (!vb->vb2_queue->is_output || !vb->vb2_queue->copy_timestamp)
> +       if (!vb->vb2_queue->is_output && !vb->vb2_queue->copy_timestamp)

Is the change fully as expected?

Current behavior:

      COPY   !COPY
CAP   0      0
OUT   keep   0

New behavior:

      COPY   !COPY
CAP   keep   0
OUT   keep   keep

Don't we still want to zero OUT if !COPY? I suppose that would make
the condition as simple as if (!vb->vb2_queue->copy_timestamp).

Best regards,
Tomasz
