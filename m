Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f49.google.com ([209.85.213.49]:38696 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbaDJA4c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 20:56:32 -0400
Received: by mail-yh0-f49.google.com with SMTP id z6so3177797yhz.22
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 17:56:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396876272-18222-7-git-send-email-hverkuil@xs4all.nl>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl> <1396876272-18222-7-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 10 Apr 2014 09:55:51 +0900
Message-ID: <CAMm-=zAwWKDs4Rn4xDVyHZ247a21DyJ1fwMFYR9cFbpWaZgA=g@mail.gmail.com>
Subject: Re: [REVIEWv2 PATCH 06/13] vb2: set timestamp when using write()
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I see. Ack, but please add a comment about this in the code.

On Mon, Apr 7, 2014 at 10:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> When using write() to write data to an output video node the vb2 core
> should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
> else is able to provide this information with the write() operation.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 2e448a7..b7de6be 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -22,6 +22,7 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
> +#include <media/v4l2-common.h>
>  #include <media/videobuf2-core.h>
>
>  static int debug;
> @@ -2751,6 +2752,9 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>  {
>         struct vb2_fileio_data *fileio;
>         struct vb2_fileio_buf *buf;
> +       bool set_timestamp = !read &&
> +               (q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> +               V4L2_BUF_FLAG_TIMESTAMP_COPY;

Please add an explicit comment why we are doing this here in the code.

>         int ret, index;
>
>         dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
> @@ -2852,6 +2856,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>                 fileio->b.memory = q->memory;
>                 fileio->b.index = index;
>                 fileio->b.bytesused = buf->pos;
> +               if (set_timestamp)
> +                       v4l2_get_timestamp(&fileio->b.timestamp);
>                 ret = vb2_internal_qbuf(q, &fileio->b);
>                 dprintk(5, "vb2_dbuf result: %d\n", ret);
>                 if (ret)
> --
> 1.9.1
>



-- 
Best regards,
Pawel Osciak
