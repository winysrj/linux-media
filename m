Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:44382 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754505AbeAOHM7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 15 Jan 2018 02:12:59 -0500
Received: by mail-io0-f193.google.com with SMTP id k18so12069433ioc.11
        for <linux-media@vger.kernel.org>; Sun, 14 Jan 2018 23:12:59 -0800 (PST)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com. [209.85.223.175])
        by smtp.gmail.com with ESMTPSA id l14sm4816363itl.24.2018.01.14.23.12.58
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jan 2018 23:12:58 -0800 (PST)
Received: by mail-io0-f175.google.com with SMTP id f34so6816820ioi.13
        for <linux-media@vger.kernel.org>; Sun, 14 Jan 2018 23:12:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180110160732.7722-6-gustavo@padovan.org>
References: <20180110160732.7722-1-gustavo@padovan.org> <20180110160732.7722-6-gustavo@padovan.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 15 Jan 2018 16:12:37 +0900
Message-ID: <CAPBb6MU-83QXHht_gLciGzfZtNxJL_=Fj5h1yfwPEt3vSKHVXg@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] [media] vb2: add out-fence support to QBUF
To: Gustavo Padovan <gustavo@padovan.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 11, 2018 at 1:07 AM, Gustavo Padovan <gustavo@padovan.org> wrote:
>  /*
>   * vb2_start_streaming() - Attempt to start streaming.
>   * @q:         videobuf2 queue
> @@ -1489,18 +1562,16 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>         if (vb->in_fence) {
>                 ret = dma_fence_add_callback(vb->in_fence, &vb->fence_cb,
>                                              vb2_qbuf_fence_cb);
> -               if (ret == -EINVAL) {
> +               /* is the fence signaled? */
> +               if (ret == -ENOENT) {
> +                       dma_fence_put(vb->in_fence);
> +                       vb->in_fence = NULL;
> +               } else if (ret) {
>                         spin_unlock_irqrestore(&vb->fence_cb_lock, flags);
>                         goto err;
> -               } else if (!ret) {
> -                       goto fill;
>                 }
> -
> -               dma_fence_put(vb->in_fence);
> -               vb->in_fence = NULL;

This chunk seems to deal with input fences, shouldn't it be part of
the previous patch instead of this one?

>
> -       if ((b->fence_fd != 0 && b->fence_fd != -1) &&
> -           !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> +       if (b->fence_fd > 0 && !(b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
>                 dprintk(1, "%s: fence_fd set without IN_FENCE flag\n", opname);
>                 return -EINVAL;
>         }
>
> +       if (b->fence_fd == -1 && (b->flags & V4L2_BUF_FLAG_IN_FENCE)) {
> +               dprintk(1, "%s: IN_FENCE flag set but no fence_fd\n", opname);
> +               return -EINVAL;
> +       }
> +

Same here?

>         return __verify_planes_array(q->bufs[b->index], b);
>  }
>
> @@ -212,7 +216,12 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>         b->sequence = vbuf->sequence;
>         b->reserved = 0;
>
> -       b->fence_fd = 0;
> +       if (b->flags & V4L2_BUF_FLAG_OUT_FENCE) {
> +               b->fence_fd = vb->out_fence_fd;
> +       } else {
> +               b->fence_fd = 0;
> +       }

Sorry if this has already been discussed, but I don't remember the
outcome if it has.

I wonder if doing this here could not make out_fence_fd leak in
situations where we don't need/want it to. Let's take for instance a
multi-process user program. One process queues a buffer with an
OUT_FENCE and gets a valid fd in fence_fd upon return. Then the other
process performs a QUERYBUF and gets the same fence_fd - which is
invalid in its context. Would it not be preferable fill the out fence
information only when queuing buffers, since it is the only time where
we are guaranteed it will be usable by the caller?

Similarly, when a buffer is processed and user-space performs a DQBUF,
the V4L2_BUF_FLAG_OUT_FENCE will be set but fence_fd will be 0. Again,
limiting the return of out fence information to QBUF would prevent
this.

If we go that route, out_fence_fd could maybe become a local variable
of vb2_qbuf() instead of being a member of vb2_buffer, and would be
returned by vb2_setup_out_fence(). This would guarantee it does not
leak anywhere else.
