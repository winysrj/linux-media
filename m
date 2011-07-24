Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48071 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab1GXWKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jul 2011 18:10:46 -0400
Received: by qwk3 with SMTP id 3so1803931qwk.19
        for <linux-media@vger.kernel.org>; Sun, 24 Jul 2011 15:10:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110714150934.74777696@bike.lwn.net>
References: <20110714150934.74777696@bike.lwn.net>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 24 Jul 2011 15:10:25 -0700
Message-ID: <CAMm-=zBoYX+Zv5kRKsksUjTGtoRjNnmhdqyeAZPC+SAiG6Uo9w@mail.gmail.com>
Subject: Re: [PATCH] videobuf2: call buf_finish() on unprocessed buffers
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,
There is a misunderstanding here. This patch will call buf_finish for
some buffers twice. A buffer does not get removed from queued_list
even if it is on the done_list. A buffer gets into the queued_list on
qbuf, gets into the done_list after an operation is finished and is
removed from both lists on dqbuf. This means that you shouldn't call
buf_finish for buffers on both lists, only for all buffers in the
queued_list, as it is a superset of both.
-- 
Best regards,
Pawel Osciak

On Thu, Jul 14, 2011 at 14:09, Jonathan Corbet <corbet@lwn.net> wrote:
> When user space stops streaming, there may be buffers which have been given
> to buf_prepare() and which may or may not have been passed to buf_queue().
> The videobuf2 core simply takes those buffers back; if buf_prepare() does
> work that needs cleaning up (like setting up a DMA mapping), that cleanup
> will not happen.
>
> This patch establishes a simple contract with drivers: buffers given to
> buf_prepare() will eventually see a buf_finish() call.
>
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  drivers/media/video/videobuf2-core.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 6ba1461..2ba08ab 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1177,6 +1177,7 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
>  */
>  static void __vb2_queue_cancel(struct vb2_queue *q)
>  {
> +       struct vb2_buffer *vb;
>        unsigned int i;
>
>        /*
> @@ -1188,13 +1189,18 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>        q->streaming = 0;
>
>        /*
> -        * Remove all buffers from videobuf's list...
> +        * Remove all buffers from videobuf's list...  Give the driver
> +        * a chance to clean them up first, though.
>         */
> +       list_for_each_entry(vb, &q->queued_list, queued_entry)
> +               call_qop(q, buf_finish, vb);
>        INIT_LIST_HEAD(&q->queued_list);
>        /*
>         * ...and done list; userspace will not receive any buffers it
>         * has not already dequeued before initiating cancel.
>         */
> +       list_for_each_entry(vb, &q->done_list, done_entry)
> +               call_qop(q, buf_finish, vb);
>        INIT_LIST_HEAD(&q->done_list);
>        wake_up_all(&q->done_wq);
>
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
