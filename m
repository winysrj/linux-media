Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:65238 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaCCEWj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 23:22:39 -0500
Received: by mail-yh0-f51.google.com with SMTP id f10so2652666yha.24
        for <linux-media@vger.kernel.org>; Sun, 02 Mar 2014 20:22:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393609335-12081-4-git-send-email-hverkuil@xs4all.nl>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl> <1393609335-12081-4-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 3 Mar 2014 13:21:59 +0900
Message-ID: <CAMm-=zB+p144muiPfRcsNJBfiatd7s34j9V9jv+fkk1BQGxbvg@mail.gmail.com>
Subject: Re: [REVIEWv3 PATCH 03/17] vb2: fix PREPARE_BUF regression
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 1, 2014 at 2:42 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Fix an incorrect test in vb2_internal_qbuf() where only DEQUEUED buffers
> are allowed. But PREPARED buffers are also OK.
>
> Introduced by commit 4138111a27859dcc56a5592c804dd16bb12a23d1
> ("vb2: simplify qbuf/prepare_buf by removing callback").
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index f1a2857c..909f367 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1420,11 +1420,6 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>                 return ret;
>
>         vb = q->bufs[b->index];
> -       if (vb->state != VB2_BUF_STATE_DEQUEUED) {
> -               dprintk(1, "%s(): invalid buffer state %d\n", __func__,
> -                       vb->state);
> -               return -EINVAL;
> -       }
>
>         switch (vb->state) {
>         case VB2_BUF_STATE_DEQUEUED:
> @@ -1438,7 +1433,8 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>                 dprintk(1, "qbuf: buffer still being prepared\n");
>                 return -EINVAL;
>         default:
> -               dprintk(1, "qbuf: buffer already in use\n");
> +               dprintk(1, "%s(): invalid buffer state %d\n", __func__,
> +                       vb->state);
>                 return -EINVAL;
>         }
>
> --
> 1.9.rc1
>



-- 
Best regards,
Pawel Osciak
