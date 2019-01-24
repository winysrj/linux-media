Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72E7C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8275A21872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cQw3ntpT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfAXI7C (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:59:02 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33158 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfAXI7B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:59:01 -0500
Received: by mail-ot1-f65.google.com with SMTP id i20so4613438otl.0
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XJe2cscw7D9xp02UyNOyctY9lhvWSUgopqe/HB3pDOk=;
        b=cQw3ntpTR+Tam8Z6BKazIhwiJgcZVqL0XLJFz56kWfU+329lsvXDQXxufzfaGuoJTg
         eXQ112Hs2WS6MtMfPYUZn7UwSxCUuK0Ea3XAMtut/H63Z5v9vmMjY8HkmoHOdVgr+Qh+
         1AOy8E5wH3rjRQBbBg2dK6fgQx204wVrNOEzI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XJe2cscw7D9xp02UyNOyctY9lhvWSUgopqe/HB3pDOk=;
        b=U7fenV/Zht6pLBCWzaN549kFsM1Pggjp2hhB28/kmckqqbHspr0RTKsEt/IsARxd4h
         +iKUaHxkN3j+agaRvBe+OPruEPRI7GIvxCJZgiUrxOWVdw9D1bdrmFcabFU4lu2s4oaE
         RdxzjXWX6YNj9lz1vTkxjm/5jNnrXiSzmTfJ24XEcgwJyBW6N8sUm2xkBitnuFbx12Fd
         n/E+aquDodgXnHCeWTTJU2/VNCm2THqi6XPcJuChuXh3c/x273icnzDpxCqvoPZTJYJ7
         yGw/uvpkqg9RxFPuW2vUjJ8kTHpOX7XOh3eEynArQRAwKZ3ktayJ00k9A3ocnJubNyP4
         GUwg==
X-Gm-Message-State: AJcUukeJgHJf8V1JQaJzBlHHaVWenVzChuFe/IE8CgKivAH4YKLms2nm
        b6CQBKbmOZPqnoMA14SvEBEave8nEc8=
X-Google-Smtp-Source: ALg8bN4LC9HCYLPFycinp0sAbVUMKPHtXtugs0FWugEXukt2z1Kv1A7j9kLPGqx6YZsd76wisqDgkg==
X-Received: by 2002:a9d:6009:: with SMTP id h9mr3973787otj.349.1548320336850;
        Thu, 24 Jan 2019 00:58:56 -0800 (PST)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com. [209.85.210.45])
        by smtp.gmail.com with ESMTPSA id u65sm10082190oib.5.2019.01.24.00.58.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 00:58:56 -0800 (PST)
Received: by mail-ot1-f45.google.com with SMTP id e12so4587798otl.5
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:58:55 -0800 (PST)
X-Received: by 2002:a9d:4687:: with SMTP id z7mr3983715ote.350.1548320334945;
 Thu, 24 Jan 2019 00:58:54 -0800 (PST)
MIME-Version: 1.0
References: <3bc5f149-895d-468d-81ee-1c7c4cbae8d8@xs4all.nl>
In-Reply-To: <3bc5f149-895d-468d-81ee-1c7c4cbae8d8@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 24 Jan 2019 17:58:44 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Db5fQz1d-gkaPS9Ot2N7HYt5_2SAgebrfWgEEj4ya+yg@mail.gmail.com>
Message-ID: <CAAFQd5Db5fQz1d-gkaPS9Ot2N7HYt5_2SAgebrfWgEEj4ya+yg@mail.gmail.com>
Subject: Re: [PATCHv2] vb2: vb2_find_timestamp: drop restriction on buffer state
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, Jan 24, 2019 at 5:47 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> There really is no reason why vb2_find_timestamp can't just find
> buffers in any state. Drop that part of the test.
>
> This also means that vb->timestamp should only be set to 0 when
> the driver doesn't copy timestamps.
>
> This change allows for more efficient pipelining (i.e. you can use
> a buffer for a reference frame even when it is queued).
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> Changes since v1: set timestamp to 0 unless copy_timestamp is set instead of also
> checking whether it is an output queue.
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
> +       if (!vb->vb2_queue->copy_timestamp)
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

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
