Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:35325 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751037AbdE3HkQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 03:40:16 -0400
Received: by mail-ua0-f174.google.com with SMTP id y4so46511553uay.2
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 00:40:16 -0700 (PDT)
Received: from mail-ua0-f180.google.com (mail-ua0-f180.google.com. [209.85.217.180])
        by smtp.gmail.com with ESMTPSA id l68sm1358208vke.40.2017.05.30.00.40.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 May 2017 00:40:15 -0700 (PDT)
Received: by mail-ua0-f180.google.com with SMTP id u10so46568052uaf.1
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 00:40:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170530065437.65828-1-hiroh@chromium.org>
References: <20170530065437.65828-1-hiroh@chromium.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 30 May 2017 16:39:54 +0900
Message-ID: <CAPBb6MXQ1EXA2uZn0VoLKjh=V_y1Jhx-U-nmpTX9gfKwLagKjg@mail.gmail.com>
Subject: Re: [PATCH] Lower the log level of debug outputs
To: Hirokazu Honda <hiroh@chromium.org>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 30, 2017 at 3:54 PM, Hirokazu Honda <hiroh@chromium.org> wrote:
> Some debug output whose log level is set 1 flooded the log.
> Their log level is lowered to find the important log easily.
>
> Signed-off-by: Hirokazu Honda <hiroh@chromium.org>

Your patch title should specify the subsystem of your patch. Something
like "[media] vb2: core: Lower the log level of debug outputs"

Otherwise,

Acked-by: Alexandre Courbot <acourbot@chromium.org>


> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 94afbbf92807..25257f92bbcf 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1139,7 +1139,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>                         continue;
>                 }
>
> -               dprintk(1, "buffer for plane %d changed\n", plane);
> +               dprintk(3, "buffer for plane %d changed\n", plane);
>
>                 if (!reacquired) {
>                         reacquired = true;
> @@ -1294,7 +1294,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>         /* Fill buffer information for the userspace */
>         call_void_bufop(q, fill_user_buffer, vb, pb);
>
> -       dprintk(1, "prepare of buffer %d succeeded\n", vb->index);
> +       dprintk(2, "prepare of buffer %d succeeded\n", vb->index);
>
>         return ret;
>  }
> @@ -1424,7 +1424,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>                         return ret;
>         }
>
> -       dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
> +       dprintk(2, "qbuf of buffer %d succeeded\n", vb->index);
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
> @@ -1472,7 +1472,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>                 }
>
>                 if (nonblocking) {
> -                       dprintk(1, "nonblocking and no buffers to dequeue, will not wait\n");
> +                       dprintk(3, "nonblocking and no buffers to dequeue, will not wait\n");
>                         return -EAGAIN;
>                 }
>
> @@ -1619,7 +1619,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
>         /* go back to dequeued state */
>         __vb2_dqbuf(vb);
>
> -       dprintk(1, "dqbuf of buffer %d, with state %d\n",
> +       dprintk(2, "dqbuf of buffer %d, with state %d\n",
>                         vb->index, vb->state);
>
>         return 0;
> --
> 2.13.0.219.gdb65acc882-goog
>
