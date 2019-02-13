Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D8AC282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 08:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F2C222C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 08:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NKEIPb1A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732488AbfBMIBZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 03:01:25 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39207 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbfBMIBZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 03:01:25 -0500
Received: by mail-ot1-f65.google.com with SMTP id n8so2472577otl.6
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2019 00:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5xZU5SqAwVW/aJ1qmIZojEi2NWuRMpnWrd6BPo5d4w8=;
        b=NKEIPb1ANHnhDHgpzdsxGmIvmKjBZJF6zPSXqWIi2J+Gbq/JMC7uYtjcX3mUGc839C
         O8sHdaUSS8hYQ9C4Nz4cV6KcFTMMLxbhpYfMV4C2d8YcJU6axkm9HmporvOuuOC4oNdc
         hthYzFyZFumrfcbHdYpV8sXfECcZvzBvDGVvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5xZU5SqAwVW/aJ1qmIZojEi2NWuRMpnWrd6BPo5d4w8=;
        b=O0ZRlFgK2hUNNcMGh6O98iUMJS/30ynpQrJKqIQ6isbi4SGaa98hP9vgMNyTtrMW5c
         NmHwOX3b9QF3qttnVkVUojlxsFNud8wZO+ucSifEi3R3fhwTOrw2/zqeoZWkbk43cbB6
         MJvyHcwmsjQCeluQOnne6alOE5jwj8ak89J9r0ktpUMHw3brLl1F4PjuL9YWs2to3k3a
         DO98x36bzor/BponnW9ZmNalMK/UCIsuYZ4WBzo+n9pW4Omep7LSgI6wCfNpYOi9PZxu
         K15nYYkEq6XZtWdImmMxosvXKHArdoSva1RmPw8AZRbgquP9+SM0z/0WVsXIHJLqhy3F
         M5Lw==
X-Gm-Message-State: AHQUAuabRw+wgWD6At6Wab5sGiJXnzqphSU+UBvAx5WE3sI7opxK44c2
        mCtv/7QnmSoaZUx33oTg9VQIgJp57GaH8Q==
X-Google-Smtp-Source: AHgI3IbVEMj2UFLDGERsRcDqdZByr2p1Q63fkDiTnv7evp2KzHMYsdKELot4bWdSsEXcWm0KR5F8uA==
X-Received: by 2002:a05:6808:107:: with SMTP id b7mr462598oie.172.1550044884332;
        Wed, 13 Feb 2019 00:01:24 -0800 (PST)
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com. [209.85.210.49])
        by smtp.gmail.com with ESMTPSA id u64sm6098373oig.2.2019.02.13.00.01.23
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 00:01:23 -0800 (PST)
Received: by mail-ot1-f49.google.com with SMTP id n8so2472514otl.6
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2019 00:01:23 -0800 (PST)
X-Received: by 2002:a9d:654e:: with SMTP id q14mr7871090otl.142.1550044883238;
 Wed, 13 Feb 2019 00:01:23 -0800 (PST)
MIME-Version: 1.0
References: <20190204101134.56283-1-hverkuil-cisco@xs4all.nl> <20190204101134.56283-4-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20190204101134.56283-4-hverkuil-cisco@xs4all.nl>
From:   Alexandre Courbot <acourbot@chromium.org>
Date:   Wed, 13 Feb 2019 17:01:11 +0900
X-Gmail-Original-Message-ID: <CAPBb6MUn87+Pu2HNv7MF7vHaqQw-3mQQfDaeu1GtbD=hnDfo1A@mail.gmail.com>
Message-ID: <CAPBb6MUn87+Pu2HNv7MF7vHaqQw-3mQQfDaeu1GtbD=hnDfo1A@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] vb2: add 'match' arg to vb2_find_buffer()
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 4, 2019 at 7:11 PM <hverkuil-cisco@xs4all.nl> wrote:
>
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>
> When finding a buffer vb2_find_buffer() should also check if the

I think this is about vb2_find_timestamp() rather than
vb2_find_buffer()? (also in the mail title and in patch 0/3).

> properties of the found buffer (i.e. number of planes and plane sizes)
> match the properties of the 'match' buffer.

What cases does this extra check protect us against? Is this in case
user-space requeues a buffer with a different number of planes/dmabufs
than what it had when its timestamp has been copied? If so, shouldn't
such cases be covered by the reference count increase on the buffer
resource that you mention in 0/3?



>
> Update the cedrus driver accordingly.
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/common/videobuf2/videobuf2-v4l2.c   | 15 ++++++++++++---
>  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c |  8 ++++----
>  include/media/videobuf2-v4l2.h                    |  3 ++-
>  3 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 55277370c313..0207493c8877 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -599,14 +599,23 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
>  };
>
>  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
> -                      unsigned int start_idx)
> +                      const struct vb2_buffer *match, unsigned int start_idx)
>  {
>         unsigned int i;
>
>         for (i = start_idx; i < q->num_buffers; i++)
>                 if (q->bufs[i]->copied_timestamp &&
> -                   q->bufs[i]->timestamp == timestamp)
> -                       return i;
> +                   q->bufs[i]->timestamp == timestamp &&
> +                   q->bufs[i]->num_planes == match->num_planes) {
> +                       unsigned int p;
> +
> +                       for (p = 0; p < match->num_planes; p++)
> +                               if (q->bufs[i]->planes[p].length <
> +                                   match->planes[p].length)
> +                                       break;
> +                       if (p == match->num_planes)
> +                               return i;
> +               }
>         return -1;
>  }
>  EXPORT_SYMBOL_GPL(vb2_find_timestamp);
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> index cb45fda9aaeb..16bc82f1cb2c 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> @@ -159,8 +159,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>         cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
>
>         /* Forward and backward prediction reference buffers. */
> -       forward_idx = vb2_find_timestamp(cap_q,
> -                                        slice_params->forward_ref_ts, 0);
> +       forward_idx = vb2_find_timestamp(cap_q, slice_params->forward_ref_ts,
> +                                        &run->dst->vb2_buf, 0);
>
>         fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
>         fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
> @@ -168,8 +168,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
>         cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
>         cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
>
> -       backward_idx = vb2_find_timestamp(cap_q,
> -                                         slice_params->backward_ref_ts, 0);
> +       backward_idx = vb2_find_timestamp(cap_q, slice_params->backward_ref_ts,
> +                                         &run->dst->vb2_buf, 0);
>         bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
>         bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
>
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index 8a10889dc2fd..b123d12424ba 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -60,6 +60,7 @@ struct vb2_v4l2_buffer {
>   *
>   * @q:         pointer to &struct vb2_queue with videobuf2 queue.
>   * @timestamp: the timestamp to find.
> + * @match:     the properties of the buffer to find must match this buffer.
>   * @start_idx: the start index (usually 0) in the buffer array to start
>   *             searching from. Note that there may be multiple buffers
>   *             with the same timestamp value, so you can restart the search
> @@ -69,7 +70,7 @@ struct vb2_v4l2_buffer {
>   * -1 if no buffer with @timestamp was found.
>   */
>  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
> -                      unsigned int start_idx);
> +                      const struct vb2_buffer *match, unsigned int start_idx);
>
>  int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
>
> --
> 2.20.1
>
