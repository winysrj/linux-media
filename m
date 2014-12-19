Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:61400 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaLSOfx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 09:35:53 -0500
Received: by mail-oi0-f45.google.com with SMTP id x69so1780511oia.4
        for <linux-media@vger.kernel.org>; Fri, 19 Dec 2014 06:35:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418729778-14480-1-git-send-email-k.debski@samsung.com>
References: <1418729778-14480-1-git-send-email-k.debski@samsung.com>
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Fri, 19 Dec 2014 15:35:37 +0100
Message-ID: <CAL8zT=jDYoiYgYm8THFmYQ1-XKndaQE99a2541UywYXLK1KzVg@mail.gmail.com>
Subject: Re: [PATCH 1/2] vb2: Add VB2_FILEIO_ALLOW_ZERO_BYTESUSED flag to vb2_fileio_flags
To: Kamil Debski <k.debski@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	m.szyprowski@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

2014-12-16 12:36 GMT+01:00 Kamil Debski <k.debski@samsung.com>:
> The vb2: fix bytesused == 0 handling (8a75ffb) patch changed the behavior
> of __fill_vb2_buffer function, so that if bytesused is 0 it is set to the
> size of the buffer. However, bytesused set to 0 is used by older codec
> drivers as as indication used to mark the end of stream.
>
> To keep backward compatibility, this patch adds a flag passed to the
> vb2_queue_init function - VB2_FILEIO_ALLOW_ZERO_BYTESUSED. If the flag is
> set upon initialization of the queue, the videobuf2 keeps the value of
> bytesused intact and passes it to the driver.

Nice, this is something we were planning to do :).
But I would split this patch and the second which is specific to
s5p-mfc as this is core specific and should be independant.


> Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |   33 ++++++++++++++++++++++++------
>  include/media/videobuf2-core.h           |    3 +++
>  2 files changed, 30 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index d09a891..1068dbb 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1276,13 +1276,23 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                          * userspace clearly never bothered to set it and
>                          * it's a safe assumption that they really meant to
>                          * use the full plane sizes.
> +                        *
> +                        * Some drivers, e.g. old codec drivers, use bytesused
> +                        * == 0 as a way to indicate that streaming is finished.
> +                        * In that case, the driver should use the following
> +                        * io_flag VB2_FILEIO_ALLOW_ZERO_BYTESUSED to keep old
> +                        * userspace applications working.

Not sure if this comment is necessary, as this is already in the commit ?

>                          */
>                         for (plane = 0; plane < vb->num_planes; ++plane) {
>                                 struct v4l2_plane *pdst = &v4l2_planes[plane];
>                                 struct v4l2_plane *psrc = &b->m.planes[plane];
>
> -                               pdst->bytesused = psrc->bytesused ?
> -                                       psrc->bytesused : pdst->length;
> +                               if (vb->vb2_queue->io_flags &
> +                                       VB2_FILEIO_ALLOW_ZERO_BYTESUSED)
> +                                       pdst->bytesused = psrc->bytesused;
> +                               else
> +                                       pdst->bytesused = psrc->bytesused ?
> +                                               psrc->bytesused : pdst->length;
>                                 pdst->data_offset = psrc->data_offset;
>                         }
>                 }
> @@ -1295,6 +1305,12 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                  *
>                  * If bytesused == 0 for the output buffer, then fall back
>                  * to the full buffer size as that's a sensible default.
> +                *
> +                * Some drivers, e.g. old codec drivers, use bytesused == 0
> +                * as a way to indicate that streaming is finished. In that
> +                * case, the driver should use the following io_flag
> +                * VB2_FILEIO_ALLOW_ZERO_BYTESUSED to keep old userspace
> +                * applications working.

Again, not sure this is useful.

>                  */
>                 if (b->memory == V4L2_MEMORY_USERPTR) {
>                         v4l2_planes[0].m.userptr = b->m.userptr;
> @@ -1306,11 +1322,16 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                         v4l2_planes[0].length = b->length;
>                 }
>
> -               if (V4L2_TYPE_IS_OUTPUT(b->type))
> -                       v4l2_planes[0].bytesused = b->bytesused ?
> -                               b->bytesused : v4l2_planes[0].length;
> -               else
> +               if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +                       if (vb->vb2_queue->io_flags &
> +                               VB2_FILEIO_ALLOW_ZERO_BYTESUSED)
> +                               v4l2_planes[0].bytesused = b->bytesused;
> +                       else
> +                               v4l2_planes[0].bytesused = b->bytesused ?
> +                                       b->bytesused : v4l2_planes[0].length;
> +               } else {
>                         v4l2_planes[0].bytesused = 0;
> +               }
>
>         }
>
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index bd2cec2..0540bc3 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -138,10 +138,13 @@ enum vb2_io_modes {
>   * by default the 'streaming' style is used by the file io emulator
>   * @VB2_FILEIO_READ_ONCE:      report EOF after reading the first buffer
>   * @VB2_FILEIO_WRITE_IMMEDIATELY:      queue buffer after each write() call
> + * @VB2_FILEIO_ALLOW_ZERO_BYTESUSED:   the driver setting this flag will handle
> + *                                     bytesused == 0 as a special case
>   */
>  enum vb2_fileio_flags {
>         VB2_FILEIO_READ_ONCE            = (1 << 0),
>         VB2_FILEIO_WRITE_IMMEDIATELY    = (1 << 1),
> +       VB2_FILEIO_ALLOW_ZERO_BYTESUSED = (1 << 2),
>  };
>
>  /**
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I tested it with your coda patch too on i.MX6, thank you, this was annoying :).
JM
