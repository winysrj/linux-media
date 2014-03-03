Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:42612 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaCCEUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Mar 2014 23:20:20 -0500
Received: by mail-yh0-f45.google.com with SMTP id i57so3105140yha.18
        for <linux-media@vger.kernel.org>; Sun, 02 Mar 2014 20:20:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393609335-12081-2-git-send-email-hverkuil@xs4all.nl>
References: <1393609335-12081-1-git-send-email-hverkuil@xs4all.nl> <1393609335-12081-2-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 3 Mar 2014 13:19:33 +0900
Message-ID: <CAMm-=zCyMqktJh8G-zWwrUXPKz__YLx8wdXWH4XyQvz8W1T5BQ@mail.gmail.com>
Subject: Re: [REVIEWv3 PATCH 01/17] vb2: Check if there are buffers before streamon
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 1, 2014 at 2:41 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>
> This patch adds a test preventing streamon() if there is no buffer
> ready.
>
> Without this patch, a user could call streamon() before
> preparing any buffer. This leads to a situation where if he calls
> close() before calling streamoff() the device is kept streaming.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 5a5fb7f..a127925 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1776,6 +1776,11 @@ static int vb2_internal_streamon(struct vb2_queue *q, enum v4l2_buf_type type)
>                 return 0;
>         }
>
> +       if (!q->num_buffers) {
> +               dprintk(1, "streamon: no buffers have been allocated\n");
> +               return -EINVAL;
> +       }
> +
>         /*
>          * If any buffers were queued before streamon,
>          * we can now pass them to driver for processing.
> --
> 1.9.rc1
>



-- 
Best regards,
Pawel Osciak
