Return-Path: <SRS0=G3Vt=RO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D10AC43381
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEEEE20657
	for <linux-media@archiver.kernel.org>; Mon, 11 Mar 2019 15:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KMw4kyxb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfCKPbX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Mar 2019 11:31:23 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46899 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbfCKPbX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Mar 2019 11:31:23 -0400
Received: by mail-lj1-f195.google.com with SMTP id v16so4451704ljg.13;
        Mon, 11 Mar 2019 08:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQp296CCJHJi73tm7U0Fpj4NvT79CDYo+sJDL+q9Q7o=;
        b=KMw4kyxb/nokVc8caAJdAo7nkfOwjCVD+vD8Cno7Fjgnrkt16OmDDTTkH5TJ6B2gRQ
         yzrOl2S3V4rR8cf1C1kWnctRBxbqHuCQt+RujDVJBRaE6DtVejqYrwedX3vpKzvTWnsR
         HvGB66t3MCE9TF0MJSituMChFJQlyBB5UZW1nQLEagbp9ddd6Lor6k6QKrTSKacKNYcJ
         HC41DnkVGXXdhA5Z2AQTYjjAKSE4DDAbVVkFli+qPeS8syvp0wbANJTaAAc3sgZmp35f
         +pW+2Z0lJ8Vm5vO/d3ib9VMmVLrQsw5i4sXRu2/LtcCWZsawddsEvNXB4vWL6EEYySks
         hyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQp296CCJHJi73tm7U0Fpj4NvT79CDYo+sJDL+q9Q7o=;
        b=kobBMSZCK+/6TeiK52ERhyKsZ1DXLvzJ9Q8a2d0EibS4WF9Z1wIHB3QoqPDRC1Web1
         oxbAUMU/xoWGfU9ex+0IcceCIFKg6dFWKLikurqswe+gOh7SdO96MIajYoBBtNNw8iQh
         3zPOTA0P5bxVtzYuY1Uvdznr5XrFTLRoMYxwJvJ2FS1u3H+9S13Fh13CUehE3ysg7oUC
         M7t/o7R3fFlKK2mjSsXdCu+B1r4LOcqYRxZJXnvJxAQjk4PM/AHL39SMRLwag/6sk0th
         vGOJo30OB3HSTwliDmfDhCI1DaqH8cF/ZnW1mHFjvWcXWBLyKeINDaj3Np7nmZaCb3i+
         bVFQ==
X-Gm-Message-State: APjAAAXNgJ73cjeZpOuchpiuRB78kXW+bxCPPd3DJSzp6Q4bWv1U3juW
        FZQuD+RPg5huOczFElYr+ScRH4OxXX/39uhGEpQ=
X-Google-Smtp-Source: APXvYqwjZa/cE8yEYFCQj/5o9Gh4ER9pMwAMb12nGs0tHZycLtjY7J6R1nighfKUvJEDBdS9qXPRMM2LFTrHfVb/VOY=
X-Received: by 2002:a2e:9b95:: with SMTP id z21mr9056336lji.155.1552318281137;
 Mon, 11 Mar 2019 08:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190204150142.GA3900@jordon-HP-15-Notebook-PC>
 <CAFqt6zbWPn4H6ArYEecou0Ri79a6hQcYcBo8ZrjPfkxFJUV-UQ@mail.gmail.com>
 <CAFqt6zZ=9-xtHg_vuCQ2E+S91G6jD8CcK=Wr-OjYONO4+SnEmg@mail.gmail.com> <52354072-81c5-4aaa-b3ea-885437e043b0@xs4all.nl>
In-Reply-To: <52354072-81c5-4aaa-b3ea-885437e043b0@xs4all.nl>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Mon, 11 Mar 2019 21:01:09 +0530
Message-ID: <CAFqt6zZD=hthKfLRAPeERP-42OJMTZX90-JndK05hqLL7hc21g@mail.gmail.com>
Subject: Re: [PATCHv2] media: videobuf2: Return error after allocation failure
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     pawel@osciak.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Mar 11, 2019 at 9:00 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 3/1/19 4:04 AM, Souptick Joarder wrote:
> > On Mon, Feb 11, 2019 at 7:42 AM Souptick Joarder <jrdr.linux@gmail.com> wrote:
> >>
> >> On Mon, Feb 4, 2019 at 8:27 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
> >>>
> >>> There is no point to continuing assignment after memory allocation
> >>> failed, rather throw error immediately.
> >>>
> >>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> >>
> >> Any comment on this patch ?
> >
> > If no further comment, can we get this patch in queue for 5.1 ?
>
> 5.1 was too late, but it will certainly go into 5.2.

Thanks.
>
> Regards,
>
>         Hans
>
> >>
> >>> ---
> >>> v1 -> v2:
> >>>         Corrected typo in change log.
> >>>
> >>>  drivers/media/common/videobuf2/videobuf2-vmalloc.c | 8 ++++----
> >>>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> >>> index 6dfbd5b..d3f71e2 100644
> >>> --- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> >>> +++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> >>> @@ -46,16 +46,16 @@ static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
> >>>
> >>>         buf->size = size;
> >>>         buf->vaddr = vmalloc_user(buf->size);
> >>> -       buf->dma_dir = dma_dir;
> >>> -       buf->handler.refcount = &buf->refcount;
> >>> -       buf->handler.put = vb2_vmalloc_put;
> >>> -       buf->handler.arg = buf;
> >>>
> >>>         if (!buf->vaddr) {
> >>>                 pr_debug("vmalloc of size %ld failed\n", buf->size);
> >>>                 kfree(buf);
> >>>                 return ERR_PTR(-ENOMEM);
> >>>         }
> >>> +       buf->dma_dir = dma_dir;
> >>> +       buf->handler.refcount = &buf->refcount;
> >>> +       buf->handler.put = vb2_vmalloc_put;
> >>> +       buf->handler.arg = buf;
> >>>
> >>>         refcount_set(&buf->refcount, 1);
> >>>         return buf;
> >>> --
> >>> 1.9.1
> >>>
>
