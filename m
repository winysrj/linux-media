Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:35462 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaHDF6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 01:58:12 -0400
Received: by mail-yk0-f177.google.com with SMTP id 79so3863692ykr.8
        for <linux-media@vger.kernel.org>; Sun, 03 Aug 2014 22:58:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53DF1BEF.6030904@xs4all.nl>
References: <53DF1BEF.6030904@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 4 Aug 2014 14:57:30 +0900
Message-ID: <CAMm-=zCMU-Dy_7q+Me4u_p+vOBCQatmSe4fEmHWLYS-JQEXcmg@mail.gmail.com>
Subject: Re: [PATCH for v3.17] videobuf2-core: add comments before the WARN_ON
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 4, 2014 at 2:36 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Recently WARN_ON() calls have been added to warn if the driver is not
> properly returning buffers to vb2 in start_streaming (if it fails) or
> stop_streaming(). Add comments before those WARN_ON calls that refer
> to the videobuf2-core.h header that explains what drivers are supposed
> to do in these situations. That should help point developers in the
> right direction if they see these warnings.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index c359006..d3f2a22 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1762,6 +1762,12 @@ static int vb2_start_streaming(struct vb2_queue *q)
>         q->start_streaming_called = 0;
>
>         dprintk(1, "driver refused to start streaming\n");
> +       /*
> +        * If you see this warning, then the driver isn't cleaning up properly
> +        * after a failed start_streaming(). See the start_streaming()
> +        * documentation in videobuf2-core.h for more information how buffers
> +        * should be returned to vb2 in start_streaming().
> +        */
>         if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>                 unsigned i;
>
> @@ -2123,6 +2129,12 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>         if (q->start_streaming_called)
>                 call_void_qop(q, stop_streaming, q);
>
> +       /*
> +        * If you see this warning, then the driver isn't cleaning up properly
> +        * in stop_streaming(). See the stop_streaming() documentation in
> +        * videobuf2-core.h for more information how buffers should be returned
> +        * to vb2 in stop_streaming().
> +        */
>         if (WARN_ON(atomic_read(&q->owned_by_drv_count))) {
>                 for (i = 0; i < q->num_buffers; ++i)
>                         if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> --
> 2.0.1
>



-- 
Best regards,
Pawel Osciak
