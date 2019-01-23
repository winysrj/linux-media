Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A986FC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 09:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 745B520861
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 09:48:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WbfJrlZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfAWJsy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 04:48:54 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37961 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfAWJsx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 04:48:53 -0500
Received: by mail-oi1-f195.google.com with SMTP id a77so1288249oii.5
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 01:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xA94088REcrxLg+eEQ1lRWUDx/V0vkg9Yf+0a/+qhT8=;
        b=WbfJrlZckn/QiVKhnpZkZjj1yI6TR9N3dzCnKoyzq7hilKXRr++77aOkMAr81pwtaO
         e8ENQOzhMxF6DUGByS784IZgCc0n6snffaO7tm0ujCs3sYsVXu1omIIyl03W8Bp6oo+S
         MWS7ipA7zm28S602leb+8pfz9Kv7sHz7WS3Vg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xA94088REcrxLg+eEQ1lRWUDx/V0vkg9Yf+0a/+qhT8=;
        b=JsKFq5/4Dj+Nv8xWIgghs41A0EqIhgPUMRNmdhTofnH4tuxsTSpmQw42muFW7AP3U6
         w+J5IazyN2zml4vChSCY4+MVGymt3N9VMukjISI+tr/O01sGbFTZqNTkh+4/Sm0rTNQh
         3vJXP6bjmTNZ16Mt2VZTzHynT4Ee4Y8fggzzs1cO86DtvLqAkHqyfIEQAF2L36tNNXpY
         YsZ52rGHb25UhNEsSAs/DNul1KGAIm6nIwxZV6muotJLsZ40Mv6wU4OA1+kv+k5aK6N+
         9GzhJy0ea0x/iWJA0drjcjhZK08JvKH0x681vRj0iDLR8buQWim/ylw/eeIenODihiT9
         j1nw==
X-Gm-Message-State: AJcUukf7UPCk/vsv+NxB4Qfc2okz/XcisItHguasSR8yhDQG3FCqgoc+
        x2EPn3gvNXy5JEwHMTyvJ9IzQDJY38fk2g==
X-Google-Smtp-Source: ALg8bN492D2ulmyYd6bCFCvR/R5pc5qd1haX9Dhxuih52idWMzybvQFVPf37eqZ/Kwdk/KZfQil3pQ==
X-Received: by 2002:aca:d804:: with SMTP id p4mr1014646oig.304.1548236932661;
        Wed, 23 Jan 2019 01:48:52 -0800 (PST)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com. [209.85.167.177])
        by smtp.gmail.com with ESMTPSA id i12sm7523400otr.74.2019.01.23.01.48.51
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 01:48:51 -0800 (PST)
Received: by mail-oi1-f177.google.com with SMTP id r62so1312702oie.1
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 01:48:51 -0800 (PST)
X-Received: by 2002:aca:ad14:: with SMTP id w20mr931221oie.3.1548236931543;
 Wed, 23 Jan 2019 01:48:51 -0800 (PST)
MIME-Version: 1.0
References: <c29a6f08-a450-73aa-c79d-93cdcbf416ae@xs4all.nl>
In-Reply-To: <c29a6f08-a450-73aa-c79d-93cdcbf416ae@xs4all.nl>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Wed, 23 Jan 2019 18:48:39 +0900
X-Gmail-Original-Message-ID: <CAPBb6MUHJpuOGAR+v7dfaBDMT7F=hiTkKM_eZSFozOP_+gD7QQ@mail.gmail.com>
Message-ID: <CAPBb6MUHJpuOGAR+v7dfaBDMT7F=hiTkKM_eZSFozOP_+gD7QQ@mail.gmail.com>
Subject: Re: [PATCH] vb2: vb2_find_timestamp: drop restriction on buffer state
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

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

So I suppose the means the stateless codec API needs to be updated to
reflect this? I cannot find any case where that would be a problem,
but just out of curiosity, what triggered this change?

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
>                 vb->timestamp = 0;
>
>         for (plane = 0; plane < vb->num_planes; ++plane) {
> @@ -594,14 +594,9 @@ int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>  {
>         unsigned int i;
>
> -       for (i = start_idx; i < q->num_buffers; i++) {
> -               struct vb2_buffer *vb = q->bufs[i];
> -
> -               if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
> -                    vb->state == VB2_BUF_STATE_DONE) &&
> -                   vb->timestamp == timestamp)
> +       for (i = start_idx; i < q->num_buffers; i++)
> +               if (q->bufs[i]->timestamp == timestamp)
>                         return i;
> -       }
>         return -1;
>  }
>  EXPORT_SYMBOL_GPL(vb2_find_timestamp);
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index a9961bc776dc..8a10889dc2fd 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -59,8 +59,7 @@ struct vb2_v4l2_buffer {
>   * vb2_find_timestamp() - Find buffer with given timestamp in the queue
>   *
>   * @q:         pointer to &struct vb2_queue with videobuf2 queue.
> - * @timestamp: the timestamp to find. Only buffers in state DEQUEUED or DONE
> - *             are considered.
> + * @timestamp: the timestamp to find.
>   * @start_idx: the start index (usually 0) in the buffer array to start
>   *             searching from. Note that there may be multiple buffers
>   *             with the same timestamp value, so you can restart the search
