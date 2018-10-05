Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36822 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbeJELbX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2018 07:31:23 -0400
Received: by mail-yb1-f193.google.com with SMTP id 5-v6so4928068ybf.3
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 21:34:28 -0700 (PDT)
MIME-Version: 1.0
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com> <1494255810-12672-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1494255810-12672-4-git-send-email-sakari.ailus@linux.intel.com>
From: Tomasz Figa <tfiga@google.com>
Date: Fri, 5 Oct 2018 13:34:17 +0900
Message-ID: <CAAFQd5B3XF7oqDHtPwZ_vmtjY-hTwm36S=9+m-J6+60Y2UoLAg@mail.gmail.com>
Subject: Re: [RFC v4 03/18] vb2: Move cache synchronisation from buffer done
 to dqbuf handler
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, labbott@redhat.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, Hans,

On Tue, May 9, 2017 at 12:05 AM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
>
> The cache synchronisation may be a time consuming operation and thus not
> best performed in an interrupt which is a typical context for
> vb2_buffer_done() calls. This may consume up to tens of ms on some
> machines, depending on the buffer size.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 8bf3369..e866115 100644
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
> @@ -1573,6 +1568,10 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>
>         vb->state = VB2_BUF_STATE_DEQUEUED;
>
> +       /* sync buffers */
> +       for (i = 0; i < vb->num_planes; ++i)
> +               call_void_memop(vb, finish, vb->planes[i].mem_priv);
> +

Sorry for digging up this old patch. Posting for reference, in case
someone decides to use or take over this patch.

This piece of code seems to be executed after queue's .buf_finish()
callback. The latter is allowed to access the buffer contents, so it
looks like we're breaking it, because it would now access the buffer
before the cache is synchronized.

Best regards,
Tomasz
