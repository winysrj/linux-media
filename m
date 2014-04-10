Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:42679 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbaDJA6J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 20:58:09 -0400
Received: by mail-yh0-f54.google.com with SMTP id f73so3205220yha.13
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 17:58:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396876272-18222-8-git-send-email-hverkuil@xs4all.nl>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl> <1396876272-18222-8-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 10 Apr 2014 09:57:27 +0900
Message-ID: <CAMm-=zDNLMCBFhCWgD1aOr5mbbn3fdLvE2eVnepGCxzkCWOr4A@mail.gmail.com>
Subject: Re: [REVIEWv2 PATCH 07/13] vb2: reject output buffers with V4L2_FIELD_ALTERNATE
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 7, 2014 at 10:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This is not allowed by the spec and does in fact not make any sense.
> Return -EINVAL if this is the case.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index b7de6be..c662ad9 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1511,6 +1511,19 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                 dprintk(1, "plane parameters verification failed: %d\n", ret);
>                 return ret;
>         }
> +       if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
> +               /*
> +                * If the format's field is ALTERNATE, then the buffer's field
> +                * should be either TOP or BOTTOM, not ALTERNATE since that
> +                * makes no sense. The driver has to know whether the
> +                * buffer represents a top or a bottom field in order to
> +                * program any DMA correctly. Using ALTERNATE is wrong, since
> +                * that just says that it is either a top or a bottom field,
> +                * but not which of the two it is.
> +                */
> +               dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
> +               return -EINVAL;
> +       }
>
>         vb->state = VB2_BUF_STATE_PREPARING;
>         vb->v4l2_buf.timestamp.tv_sec = 0;
> --
> 1.9.1
>



-- 
Best regards,
Pawel Osciak
