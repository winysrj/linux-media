Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:60691 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaDGIdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 04:33:44 -0400
Received: by mail-yh0-f42.google.com with SMTP id t59so5486905yho.15
        for <linux-media@vger.kernel.org>; Mon, 07 Apr 2014 01:33:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394486458-9836-7-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl> <1394486458-9836-7-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 7 Apr 2014 17:32:58 +0900
Message-ID: <CAMm-=zDr63ywzqhTPTen=8zFZamxtGOSp+jiP1Rkag0pFqE5_g@mail.gmail.com>
Subject: Re: [REVIEW PATCH 06/11] vb2: set timestamp when using write()
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 11, 2014 at 6:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> When using write() to write data to an output video node the vb2 core
> should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody

I'm confused. Shouldn't we be saving the existing timestamp from the buffer if
V4L2_BUF_FLAG_TIMESTAMP_COPY is true, instead of getting it from
v4l2_get_timestamp()?

> else is able to provide this information with the write() operation.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index e38b45e..afd1268 100644
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
> @@ -2767,6 +2768,9 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>  {
>         struct vb2_fileio_data *fileio;
>         struct vb2_fileio_buf *buf;
> +       bool set_timestamp = !read &&
> +               (q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
> +               V4L2_BUF_FLAG_TIMESTAMP_COPY;
>         int ret, index;
>
>         dprintk(3, "file io: mode %s, offset %ld, count %zd, %sblocking\n",
> @@ -2868,6 +2872,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>                 fileio->b.memory = q->memory;
>                 fileio->b.index = index;
>                 fileio->b.bytesused = buf->pos;
> +               if (set_timestamp)
> +                       v4l2_get_timestamp(&fileio->b.timestamp);
>                 ret = vb2_internal_qbuf(q, &fileio->b);
>                 dprintk(5, "file io: vb2_internal_qbuf result: %d\n", ret);
>                 if (ret)
> --
> 1.9.0
>



-- 
Best regards,
Pawel Osciak
