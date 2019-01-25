Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5601DC282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 04:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C3AC218CD
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 04:41:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G2M7g9O9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfAYEl6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 23:41:58 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38775 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbfAYEl6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 23:41:58 -0500
Received: by mail-oi1-f194.google.com with SMTP id a77so6804679oii.5
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 20:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wXj8UNzfnsoiZa8oGqlW3/u2Gj2eYVEUqFrCwd1+GVY=;
        b=G2M7g9O91TDhhs9d5AHlsm+H/xxYPHrZ1f1a8yawrGKQq4XwQ3hr/3K/1Mwt6Bzg/M
         O9/17r1rcddXPomXhHCNljn+Zs+ohzrTs+RMk5kTEgLNWeeSe6+yqa5T3xW33BCctxPD
         cO9f04IsHsRxgv/7hMAZcxsnbuMHIRttQVkpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wXj8UNzfnsoiZa8oGqlW3/u2Gj2eYVEUqFrCwd1+GVY=;
        b=o2tigmv6WOUoP1jFGd4BXd5qb5fy0F53F0ClKqJVB2tR3rUHH/KJWIzrEkbYxkQKGC
         X+7EDObJUAGRWQi7c9CXnqAkiUHWrYK1dECIKPsBTEoeSWTBQqjtTiH9gVmb2eljfxB2
         D1e3pYzQ+EpEeF9LcEH5y1PHeAAzv2HCaZiCFkJjp8RLvsIraeb1arM40t0WYZV47Ixe
         PqeO/GLV/nJLVnA86eKMqvhZcI/YeQ8qBWXQEIepao+ceBkuDhfkDKrZFCKXrXdQcNh5
         cTA3+YXDDpwrEBP81HujTshxdwF7KFLbh6V8B1Ezg+CgmBoMsn5imhSy5ZFoz1xu+dmP
         rjyQ==
X-Gm-Message-State: AJcUukeY0DHCx+yiiVU+SijTSH2Koq7iwP6AN3RBpEDveZ7dxicKcHy3
        eSaCuTJGJqmseL4lJZYzmX5S37RAgK0jQg==
X-Google-Smtp-Source: ALg8bN6szQjVheX41kvk9NQoYp0irfAJKjeJiCu4/QaMk8gLjlHczCubRG429tcYI79Mx96TDF13eA==
X-Received: by 2002:aca:ac04:: with SMTP id v4mr336245oie.342.1548390117126;
        Thu, 24 Jan 2019 20:21:57 -0800 (PST)
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com. [209.85.210.41])
        by smtp.gmail.com with ESMTPSA id a1sm705615oto.71.2019.01.24.20.21.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 20:21:56 -0800 (PST)
Received: by mail-ot1-f41.google.com with SMTP id s13so7400194otq.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 20:21:55 -0800 (PST)
X-Received: by 2002:a9d:1d65:: with SMTP id m92mr6639238otm.65.1548390115572;
 Thu, 24 Jan 2019 20:21:55 -0800 (PST)
MIME-Version: 1.0
References: <20181119110903.24383-1-hverkuil@xs4all.nl> <20181119110903.24383-2-hverkuil@xs4all.nl>
In-Reply-To: <20181119110903.24383-2-hverkuil@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 25 Jan 2019 13:21:44 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Dsyiwb2_rj1JHK6rLeKobpfCS9p8J2-6DzmgxOLX6CvQ@mail.gmail.com>
Message-ID: <CAAFQd5Dsyiwb2_rj1JHK6rLeKobpfCS9p8J2-6DzmgxOLX6CvQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/4] vb2: add waiting_in_dqbuf flag
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Mon, Nov 19, 2018 at 8:09 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Calling VIDIOC_DQBUF can release the core serialization lock pointed to
> by vb2_queue->lock if it has to wait for a new buffer to arrive.
>
> However, if userspace dup()ped the video device filehandle, then it is
> possible to read or call DQBUF from two filehandles at the same time.
>
> It is also possible to call REQBUFS from one filehandle while the other
> is waiting for a buffer. This will remove all the buffers and reallocate
> new ones. Removing all the buffers isn't the problem here (that's already
> handled correctly by DQBUF), but the reallocating part is: DQBUF isn't
> aware that the buffers have changed.
>
> This is fixed by setting a flag whenever the lock is released while waiting
> for a buffer to arrive. And checking the flag where needed so we can return
> -EBUSY.
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Reported-by: syzbot+4180ff9ca6810b06c1e9@syzkaller.appspotmail.com
> ---
>  .../media/common/videobuf2/videobuf2-core.c   | 22 +++++++++++++++++++
>  include/media/videobuf2-core.h                |  1 +
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 975ff5669f72..f7e7e633bcd7 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -672,6 +672,11 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>                 return -EBUSY;
>         }
>
> +       if (q->waiting_in_dqbuf && *count) {
> +               dprintk(1, "another dup()ped fd is waiting for a buffer\n");

Actually, couldn't it also happen with the same FD just another thread?

That said, it's just a debugging message, so feel free to just add

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
