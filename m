Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:60250 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaDGIJ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 04:09:57 -0400
Received: by mail-yk0-f177.google.com with SMTP id q200so5103199ykb.22
        for <linux-media@vger.kernel.org>; Mon, 07 Apr 2014 01:09:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394486458-9836-6-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl> <1394486458-9836-6-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 7 Apr 2014 17:09:11 +0900
Message-ID: <CAMm-=zA7BHDHyRAzmEnsEvQNEabAcUAo5fQfiBPm+f7JkmG2Pg@mail.gmail.com>
Subject: Re: [REVIEW PATCH 05/11] vb2: move __qbuf_mmap before __qbuf_userptr
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
> __qbuf_mmap was sort of hidden in between the much larger __qbuf_userptr
> and __qbuf_dmabuf functions. Move it before __qbuf_userptr which is
> also conform the usual order these memory models are implemented: first
> mmap, then userptr, then dmabuf.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 71be247..e38b45e 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1254,6 +1254,20 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  }
>
>  /**
> + * __qbuf_mmap() - handle qbuf of an MMAP buffer
> + */
> +static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +{
> +       int ret;
> +
> +       __fill_vb2_buffer(vb, b, vb->v4l2_planes);
> +       ret = call_vb_qop(vb, buf_prepare, vb);
> +       if (ret)
> +               fail_vb_qop(vb, buf_prepare);
> +       return ret;
> +}
> +
> +/**
>   * __qbuf_userptr() - handle qbuf of a USERPTR buffer
>   */
>  static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> @@ -1359,20 +1373,6 @@ err:
>  }
>
>  /**
> - * __qbuf_mmap() - handle qbuf of an MMAP buffer
> - */
> -static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> -{
> -       int ret;
> -
> -       __fill_vb2_buffer(vb, b, vb->v4l2_planes);
> -       ret = call_vb_qop(vb, buf_prepare, vb);
> -       if (ret)
> -               fail_vb_qop(vb, buf_prepare);
> -       return ret;
> -}
> -
> -/**
>   * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
>   */
>  static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> --
> 1.9.0
>



-- 
Best regards,
Pawel Osciak
