Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4730AC43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A0AC2183E
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 14:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kVYJuClK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfAGO3z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 09:29:55 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45891 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfAGO3z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2019 09:29:55 -0500
Received: by mail-lf1-f66.google.com with SMTP id b20so388645lfa.12
        for <linux-media@vger.kernel.org>; Mon, 07 Jan 2019 06:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mKdxwusZFloEN/MbwbU6RCjHm6yGJ1yRCdfzIU3hXc8=;
        b=kVYJuClKBPu65MUgDTCR8BXuRMSazaGSHXV/oxoFxusnE/wvu7Czv9XepLyCSjBSmP
         rASXyzr+FQ7Vt/Kqu03IxibJZIprbe8IQeCPLof75GI+QwQRVimQAZLMtaEg+s7sbDa3
         nWG3tNgFUO6IEieIWcDm6x4pK3EzZ2v7uR88rguym0QG13hgCHNPZXSohjjm3a10Dxgt
         OH74ViJLkVF8pUg5MmSgVtQajMQvt3lbOcIivWoETBnxW2xvxxnOsv6ftpnc9Ot3U+wy
         GksX4zlqWrpScN2lrutLvnI4/zzPyisyIuyFDKmpGq0Vr6AkO1LL4hNJA/ZqQR1drerB
         fdOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mKdxwusZFloEN/MbwbU6RCjHm6yGJ1yRCdfzIU3hXc8=;
        b=OW8+8lB8ltGD0y+TXfz9WaleN44t8SZn2/WflUuEJsR6/v0zq7Cn3Oipj5J8SAisK4
         dYBmIX+XNGtDWJ7rTBQ36FnntSzMpYCHo+2RBqyND6LBLrlGCNf1ylWLyykp8uK4OHYZ
         xw3v4H0O1RiJh4C3s5KuUoqjRfoEJMZkxbpTGOv8M6xn+uvh3DEC3qg6u1uZjyb7SsDI
         7jjpOMO4il5ADFenxgrGwppeCS9c/4/dhxuBBLlF2eiKY+UBQq6TTvOO7P3I3c6uGBPY
         F6K3qmCI6cD7lei/it/zGRsFA6e2koTjXxHQtxlpIh2mmDsHNuqNT/Q2p0sEMudUZH24
         dHmw==
X-Gm-Message-State: AA+aEWarmM5VKdqONLzZ6rPGwxRJ9CzZDfYh1BmhRgDIN45MEVT/QrFr
        BGeGewTnbo34OSzsjBRhgXNKcWV7dxCkm9KGCg==
X-Google-Smtp-Source: AFSGD/W0OGxtJ+i40tnxzmb+3SbYZrTZpN8xOAycL6kiTZDipiG/rvN8sNpUGrDKLR6U8yPTJeYnVZC8ibXtPx0+Jhk=
X-Received: by 2002:a19:8096:: with SMTP id b144mr32737799lfd.8.1546871392385;
 Mon, 07 Jan 2019 06:29:52 -0800 (PST)
MIME-Version: 1.0
References: <CADwFkYdCXY5my5DW=qGJcJBDpjtZpRHXN6h4H2geneekiOzCgg@mail.gmail.com>
 <3268a1a8-1712-52b2-e0e4-c6a98f003d75@xs4all.nl>
In-Reply-To: <3268a1a8-1712-52b2-e0e4-c6a98f003d75@xs4all.nl>
From:   Yi Qingliang <niqingliang2003@gmail.com>
Date:   Mon, 7 Jan 2019 14:29:41 +0000
Message-ID: <CADwFkYevGQKMkK6nQd3qp2qTLUo2=2zBR5d-0HAGLoMpsnz5ew@mail.gmail.com>
Subject: Re: epoll and vb2_poll: can't wake_up
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Thanks! It should work now.
BTW, I don't know if we should think about the error case before
calling poll_wait, just like not streamon.
if poll return error, does epoll framework need and how to remove
waiter for client?
for epoll framework, does it have some requirements or some tutorial
for the implementation of client's poll?

and I think it's better to split the two operation: adding waiter and
polling, not only for epoll framework, and also for all clients.

Yi Qingliang

On Mon, Jan 7, 2019 at 1:45 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 12/29/2018 03:10 AM, Yi Qingliang wrote:
> > Hello, I encountered a "can't wake_up" problem when use camera on imx6.
> >
> > if delay some time after 'streamon' the /dev/video0, then add fd
> > through epoll_ctl, then the process can't be waken_up after some time.
> >
> > I checked both the epoll / vb2_poll(videobuf2_core.c) code.
> >
> > epoll will pass 'poll_table' structure to vb2_poll, but it only
> > contain valid function pointer when inserting fd.
> >
> > in vb2_poll, if found new data in done list, it will not call 'poll_wait'.
> > after that, every call to vb2_poll will not contain valid poll_table,
> > which will result in all calling to poll_wait will not work.
> >
> > so if app can process frames quickly, and found frame data when
> > inserting fd (i.e. poll_wait will not be called or not contain valid
> > function pointer), it will not found valid frame in 'vb2_poll' finally
> > at some time, then call 'poll_wait' to expect be waken up at following
> > vb2_buffer_done, but no good luck.
> >
> > I also checked the 'videobuf-core.c', there is no this problem.
> >
> > of course, both epoll and vb2_poll are right by itself side, but the
> > result is we can't get new frames.
> >
> > I think by epoll's implementation, the user should always call poll_wait.
> >
> > and it's better to split the two actions: 'wait' and 'poll' both for
> > epoll framework and all epoll users, for example, v4l2.
> >
> > am I right?
> >
> > Yi Qingliang
> >
>
> Can you test this patch?
>
> Looking at what other drivers/frameworks do it seems that calling
> poll_wait() at the start of the poll function is the right approach.
>
> Regards,
>
>         Hans
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 70e8c3366f9c..b1809628475d 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -2273,6 +2273,8 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
>         struct vb2_buffer *vb = NULL;
>         unsigned long flags;
>
> +       poll_wait(file, &q->done_wq, wait);
> +
>         if (!q->is_output && !(req_events & (EPOLLIN | EPOLLRDNORM)))
>                 return 0;
>         if (q->is_output && !(req_events & (EPOLLOUT | EPOLLWRNORM)))
> @@ -2329,8 +2331,6 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
>                  */
>                 if (q->last_buffer_dequeued)
>                         return EPOLLIN | EPOLLRDNORM;
> -
> -               poll_wait(file, &q->done_wq, wait);
>         }
>
>         /*
