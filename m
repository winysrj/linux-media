Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33913 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaBNE55 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 23:57:57 -0500
Received: by mail-yk0-f177.google.com with SMTP id q200so21860168ykb.8
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 20:57:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392284450-41019-7-git-send-email-hverkuil@xs4all.nl>
References: <1392284450-41019-1-git-send-email-hverkuil@xs4all.nl> <1392284450-41019-7-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 14 Feb 2014 13:49:04 +0900
Message-ID: <CAMm-=zA7OY7YeKF-QFi89sW=1SXBXR27zZscvPv7L4wJR0RJGw@mail.gmail.com>
Subject: Re: [RFCv3 PATCH 06/10] vb2: fix read/write regression
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 13, 2014 at 6:40 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Commit 88e268702bfba78448abd20a31129458707383aa ("vb2: Improve file I/O
> emulation to handle buffers in any order") broke read/write support if
> the size of the buffer being read/written is less than the size of the
> image.
>
> When the commit was tested originally I used qv4l2, which call read()
> with exactly the size of the image. But if you try 'cat /dev/video0'
> then it will fail and typically hang after reading two buffers.
>
> This patch fixes the behavior by adding a new buf_index field that
> contains the index of the field currently being filled/read, or it
> is num_buffers in which case a new buffer needs to be dequeued.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Andy Walls <awalls@md.metrocast.net>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7766bf5..a3b4b4c 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2418,6 +2418,7 @@ struct vb2_fileio_data {
>         struct v4l2_requestbuffers req;
>         struct v4l2_buffer b;
>         struct vb2_fileio_buf bufs[VIDEO_MAX_FRAME];
> +       unsigned int buf_index;
>         unsigned int index;

The two index fields are now confusing, especially because there is no
documentation. Perhaps we could call index "cur_index" and also add
documentation please?

>         unsigned int q_count;
>         unsigned int dq_count;
> @@ -2519,6 +2520,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>                         fileio->bufs[i].queued = 1;
>                 }
>                 fileio->index = q->num_buffers;
> +               fileio->buf_index = q->num_buffers;
>         }
>
>         /*
> @@ -2597,7 +2599,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>         /*
>          * Check if we need to dequeue the buffer.
>          */
> -       index = fileio->index;
> +       index = fileio->buf_index;
>         if (index >= q->num_buffers) {
>                 /*
>                  * Call vb2_dqbuf to get buffer back.
> @@ -2611,7 +2613,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>                         return ret;
>                 fileio->dq_count += 1;
>
> -               index = fileio->b.index;
> +               fileio->buf_index = index = fileio->b.index;
>                 buf = &fileio->bufs[index];
>
>                 /*
> @@ -2689,6 +2691,7 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>                 fileio->q_count += 1;
>                 if (fileio->index < q->num_buffers)
>                         fileio->index++;
> +               fileio->buf_index = fileio->index;
>         }
>
>         /*
> --
> 1.8.4.rc3
>



-- 
Best regards,
Pawel Osciak
