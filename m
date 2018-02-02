Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:42292 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbeBBN51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Feb 2018 08:57:27 -0500
Received: by mail-qk0-f181.google.com with SMTP id f68so3667268qke.9
        for <linux-media@vger.kernel.org>; Fri, 02 Feb 2018 05:57:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180202100859.4004-1-sakari.ailus@linux.intel.com>
References: <20180202100859.4004-1-sakari.ailus@linux.intel.com>
From: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Fri, 2 Feb 2018 08:57:26 -0500
Message-ID: <CAGoCfixma+h4nHkroeKd+Mw+cxhhQ_mAZ8X7w6UXmy0a8VOi9A@mail.gmail.com>
Subject: Re: [PATCH 1/1] vb2: core: Finish buffers at the end of the stream
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sakari,

Thanks for proposing this patch.  I'll give it a try this weekend.

Regards,

Devin

On Fri, Feb 2, 2018 at 5:08 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> If buffers were prepared or queued and the buffers were released without
> starting the queue, the finish mem op (corresponding to the prepare mem
> op) was never called to the buffers.
>
> Before commit a136f59c0a1f there was no need to do this as in such a case
> the prepare mem op had not been called yet. Address the problem by
> explicitly calling finish mem op when the queue is stopped if the buffer
> is in either prepared or queued state.
>
> Fixes: a136f59c0a1f ("[media] vb2: Move buffer cache synchronisation to prepare from queue")
> Cc: stable@vger.kernel.org # for v4.13 and up
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Devin,
>
> Could you check whether this will resolve the problem you've found?
>
> Thanks.
>
>  drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index f7109f827f6e..52a7c1d0a79a 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1696,6 +1696,15 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>         for (i = 0; i < q->num_buffers; ++i) {
>                 struct vb2_buffer *vb = q->bufs[i];
>
> +               if (vb->state == VB2_BUF_STATE_PREPARED ||
> +                   vb->state == VB2_BUF_STATE_QUEUED) {
> +                       unsigned int plane;
> +
> +                       for (plane = 0; plane < vb->num_planes; ++plane)
> +                               call_void_memop(vb, finish,
> +                                               vb->planes[plane].mem_priv);
> +               }
> +
>                 if (vb->state != VB2_BUF_STATE_DEQUEUED) {
>                         vb->state = VB2_BUF_STATE_PREPARED;
>                         call_void_vb_qop(vb, buf_finish, vb);
> --
> 2.11.0
>



-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
