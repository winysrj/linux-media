Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:35056 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbdC0V1i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 17:27:38 -0400
Received: by mail-ot0-f196.google.com with SMTP id s100so5355098ota.2
        for <linux-media@vger.kernel.org>; Mon, 27 Mar 2017 14:27:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161216012425.11179-4-laurent.pinchart+renesas@ideasonboard.com>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com> <20161216012425.11179-4-laurent.pinchart+renesas@ideasonboard.com>
From: Shuah Khan <shuahkhan@gmail.com>
Date: Mon, 27 Mar 2017 15:27:36 -0600
Message-ID: <CAKocOOP1quatsWr4O7fwxXVhuPisaST-xkJoPRCO41RHSPhhNw@mail.gmail.com>
Subject: Re: [RFC v2 03/11] vb2: Move cache synchronisation from buffer done
 to dqbuf handler
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Shuah Khan <shuahkhan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 15, 2016 at 6:24 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> The cache synchronisation may be a time consuming operation and thus not
> best performed in an interrupt which is a typical context for
> vb2_buffer_done() calls. This may consume up to tens of ms on some
> machines, depending on the buffer size.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Changes since v1:
>
> - Don't rename the 'i' loop counter to 'plane'
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 8ba48703b189..15a83f338072 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -889,7 +889,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  {
>         struct vb2_queue *q = vb->vb2_queue;
>         unsigned long flags;
> -       unsigned int plane;
>
>         if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
>                 return;
> @@ -910,10 +909,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>         dprintk(4, "done processing on buffer %d, state: %d\n",
>                         vb->index, state);
>
> -       /* sync buffers */
> -       for (plane = 0; plane < vb->num_planes; ++plane)
> -               call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> -
>         spin_lock_irqsave(&q->done_lock, flags);
>         if (state == VB2_BUF_STATE_QUEUED ||
>             state == VB2_BUF_STATE_REQUEUEING) {
> @@ -1571,6 +1566,10 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>
>         vb->state = VB2_BUF_STATE_DEQUEUED;
>
> +       /* sync buffers */
> +       for (i = 0; i < vb->num_planes; ++i)
> +               call_void_memop(vb, finish, vb->planes[i].mem_priv);
> +

Does this compile?? Where is "i" defined? Looks like it needs to be added
back in.

-- Shuah

>         /* unmap DMABUF buffer */
>         if (q->memory == VB2_MEMORY_DMABUF)
>                 for (i = 0; i < vb->num_planes; ++i) {
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
