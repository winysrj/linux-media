Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A13AC43387
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 01:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4E6E20821
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 01:30:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fY98/lb4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbfAIBaX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:30:23 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35247 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729137AbfAIBaX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 20:30:23 -0500
Received: by mail-lj1-f193.google.com with SMTP id x85-v6so5097376ljb.2
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2019 17:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L8yhIYjLqXs6LOxWn+8M8ybu8WxeKskZUxyHuGsNUJY=;
        b=fY98/lb4TGY2BFtPccqrF1xbMYAlymE4noKMrFEaAcafexXRQLuHh4NJulcdobO38U
         JUKNBwBnCUVUNIzJkWeO2DtrnYw4duiYXhFEkpVTArs6Z+xtVZLsYQsobafP0RAHLDUR
         phRIc+dz3TNUT9svTm0rcLgiWQE9SuOEXNpPAGCQKe3ZMiSAyFRzxEJBolaPoVT9b8JK
         IUbC0h6lh/LSvBy1sjYrol2EnFEuT0h1WUiSnOt4fgh1KuB5ZNaGMKo4n4LRHhpNUvBN
         S/pkoReTeClXjL6Ze26bO94AHaRrPar4HrmgbNHdOd9fKqkFrdaif1/91sZvkRdW6KgF
         QjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L8yhIYjLqXs6LOxWn+8M8ybu8WxeKskZUxyHuGsNUJY=;
        b=YmGjvaTjBB+3aXUBSrY2xJZbRlEX+PHwYG+FpgslXonlljd9bSMK6c4UKbJluog1nG
         A3jSC8hFTlm+x5m7ZqN+GVsn6TRidjtO+jz428ktJFHS+6MSVrqWt7sV44nH4fdvUF2P
         RtU3m3iaFBtJ5HOqiAJTBfZtAs3AbWhbDWDSPzVw3kcMDaHNAdo53S7ZJjxI9si+HbPl
         Q1wbhpWBD0Ja9X0mycfXq2aVJLh8UOJW9kR5oWNsP1otQnAkGl2Te1yoJB3thqFbZSlL
         6TXOlVN3rniICgx/nKH9NPvACO/J3bPslbMehUFe5Mf4PdzaQK8ZScxqaYHp2VuJzj1l
         W1yQ==
X-Gm-Message-State: AJcUuke0F60212OTJdveq/wHruSWhjpjcpnsBitF1QOuc0RSCofgm/2Y
        dxjN3Cjn8PR9MAIZeg39e92/1Dha3DzbY7TtlA==
X-Google-Smtp-Source: ALg8bN6cGJYiJdK9EOpfzOLwSZv9Y57sQNgunsBfmWPwWnjM7Xu38odGPdL9SgKzuzbZOlKhnCwKHkyeIgVZrLxLLJw=
X-Received: by 2002:a2e:b04f:: with SMTP id d15-v6mr2471762ljl.3.1546997420750;
 Tue, 08 Jan 2019 17:30:20 -0800 (PST)
MIME-Version: 1.0
References: <CADwFkYdCXY5my5DW=qGJcJBDpjtZpRHXN6h4H2geneekiOzCgg@mail.gmail.com>
 <3268a1a8-1712-52b2-e0e4-c6a98f003d75@xs4all.nl> <CADwFkYevGQKMkK6nQd3qp2qTLUo2=2zBR5d-0HAGLoMpsnz5ew@mail.gmail.com>
In-Reply-To: <CADwFkYevGQKMkK6nQd3qp2qTLUo2=2zBR5d-0HAGLoMpsnz5ew@mail.gmail.com>
From:   Yi Qingliang <niqingliang2003@gmail.com>
Date:   Wed, 9 Jan 2019 09:30:09 +0800
Message-ID: <CADwFkYdpCqno=V4YRS7C_cngKuoBMc_E5nkDs8vQEwZp8kcqqw@mail.gmail.com>
Subject: Re: epoll and vb2_poll: can't wake_up
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

the first patch can work on freescale's 4.1.2 kernel ! My case maybe
can't cover other changes.

in file drivers/media/v4l2-core/videobuf-core.c, the function
'videobuf_poll_stream' may return POLLERR without calling 'poll_wait',
it looks like different with 'vb2_poll''s process, maybe need further
check.

Thanks!

Yi Qingliang


On Mon, Jan 7, 2019 at 2:29 PM Yi Qingliang <niqingliang2003@gmail.com> wrote:
>
> Thanks! It should work now.
> BTW, I don't know if we should think about the error case before
> calling poll_wait, just like not streamon.
> if poll return error, does epoll framework need and how to remove
> waiter for client?
> for epoll framework, does it have some requirements or some tutorial
> for the implementation of client's poll?
>
> and I think it's better to split the two operation: adding waiter and
> polling, not only for epoll framework, and also for all clients.
>
> Yi Qingliang
>
> On Mon, Jan 7, 2019 at 1:45 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > On 12/29/2018 03:10 AM, Yi Qingliang wrote:
> > > Hello, I encountered a "can't wake_up" problem when use camera on imx6.
> > >
> > > if delay some time after 'streamon' the /dev/video0, then add fd
> > > through epoll_ctl, then the process can't be waken_up after some time.
> > >
> > > I checked both the epoll / vb2_poll(videobuf2_core.c) code.
> > >
> > > epoll will pass 'poll_table' structure to vb2_poll, but it only
> > > contain valid function pointer when inserting fd.
> > >
> > > in vb2_poll, if found new data in done list, it will not call 'poll_wait'.
> > > after that, every call to vb2_poll will not contain valid poll_table,
> > > which will result in all calling to poll_wait will not work.
> > >
> > > so if app can process frames quickly, and found frame data when
> > > inserting fd (i.e. poll_wait will not be called or not contain valid
> > > function pointer), it will not found valid frame in 'vb2_poll' finally
> > > at some time, then call 'poll_wait' to expect be waken up at following
> > > vb2_buffer_done, but no good luck.
> > >
> > > I also checked the 'videobuf-core.c', there is no this problem.
> > >
> > > of course, both epoll and vb2_poll are right by itself side, but the
> > > result is we can't get new frames.
> > >
> > > I think by epoll's implementation, the user should always call poll_wait.
> > >
> > > and it's better to split the two actions: 'wait' and 'poll' both for
> > > epoll framework and all epoll users, for example, v4l2.
> > >
> > > am I right?
> > >
> > > Yi Qingliang
> > >
> >
> > Can you test this patch?
> >
> > Looking at what other drivers/frameworks do it seems that calling
> > poll_wait() at the start of the poll function is the right approach.
> >
> > Regards,
> >
> >         Hans
> >
> > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > ---
> > diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> > index 70e8c3366f9c..b1809628475d 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-core.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> > @@ -2273,6 +2273,8 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
> >         struct vb2_buffer *vb = NULL;
> >         unsigned long flags;
> >
> > +       poll_wait(file, &q->done_wq, wait);
> > +
> >         if (!q->is_output && !(req_events & (EPOLLIN | EPOLLRDNORM)))
> >                 return 0;
> >         if (q->is_output && !(req_events & (EPOLLOUT | EPOLLWRNORM)))
> > @@ -2329,8 +2331,6 @@ __poll_t vb2_core_poll(struct vb2_queue *q, struct file *file,
> >                  */
> >                 if (q->last_buffer_dequeued)
> >                         return EPOLLIN | EPOLLRDNORM;
> > -
> > -               poll_wait(file, &q->done_wq, wait);
> >         }
> >
> >         /*
