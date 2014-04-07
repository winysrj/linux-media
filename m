Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:38555 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaDGIi7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 04:38:59 -0400
Received: by mail-yh0-f41.google.com with SMTP id v1so5587611yhn.28
        for <linux-media@vger.kernel.org>; Mon, 07 Apr 2014 01:38:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394486458-9836-8-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl> <1394486458-9836-8-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 7 Apr 2014 17:38:18 +0900
Message-ID: <CAMm-=zB8qfrZfWcv4LdCw7n6N61i9jo=b_DExhiTcLRtEKp3sQ@mail.gmail.com>
Subject: Re: [REVIEW PATCH 07/11] vb2: reject output buffers with V4L2_FIELD_ALTERNATE
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
> This is not allowed by the spec and does in fact not make any sense.
> Return -EINVAL if this is the case.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index afd1268..8984187 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1526,6 +1526,15 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                         __func__, ret);
>                 return ret;
>         }
> +       if (V4L2_TYPE_IS_OUTPUT(q->type) && b->field == V4L2_FIELD_ALTERNATE) {

Checking for field first would probably eliminate the additional
OUTPUT check most of the time.
I'd swap them.

> +               /*
> +                * If field is ALTERNATE, then we return an error.

I'd drop this line, doesn't really add anything.

> +                * If the format's field is ALTERNATE, then the buffer's field
> +                * should be either TOP or BOTTOM, but using ALTERNATE here as
> +                * well makes no sense.

This doesn't really explain why this is an error and is confusing,
since we don't check TOP/BOTTOM
anyway. I think it would be better to say why ALTERNATE doesn't make
sense instead.

> +                */
> +               return -EINVAL;
> +       }
>
>         vb->state = VB2_BUF_STATE_PREPARING;
>         vb->v4l2_buf.timestamp.tv_sec = 0;
> --
> 1.9.0
>



-- 
Best regards,
Pawel Osciak
