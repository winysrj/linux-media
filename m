Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61157 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2KIXeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 18:34:08 -0500
Received: by mail-vb0-f46.google.com with SMTP id ff1so4471262vbb.19
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2012 15:34:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1350401832-22186-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1350401832-22186-1-git-send-email-laurent.pinchart@ideasonboard.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 9 Nov 2012 15:33:22 -0800
Message-ID: <CAMm-=zCd3T=YnkjxTPej_2J-MaiCtsrH5entkiz5GgKCBg31rw@mail.gmail.com>
Subject: Re: [PATCH v2] videobuf2-core: Verify planes lengths for output buffers
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 16, 2012 at 8:37 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> For output buffers application provide to the kernel the number of bytes
> they stored in each plane of the buffer. Verify that the value is
> smaller than or equal to the plane length.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---

Acked-by: Pawel Osciak <pawel@osciak.com>

>  drivers/media/v4l2-core/videobuf2-core.c |   39 ++++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
>
> Changes compared to v1:
>
> - Sanity check the data_offset value for each plane.
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 432df11..479337d 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -296,6 +296,41 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
>  }
>
>  /**
> + * __verify_length() - Verify that the bytesused value for each plane fits in
> + * the plane length and that the data offset doesn't exceed the bytesused value.
> + */
> +static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +{
> +       unsigned int length;
> +       unsigned int plane;
> +
> +       if (!V4L2_TYPE_IS_OUTPUT(b->type))
> +               return 0;
> +
> +       if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> +               for (plane = 0; plane < vb->num_planes; ++plane) {
> +                       length = (b->memory == V4L2_MEMORY_USERPTR)
> +                              ? b->m.planes[plane].length
> +                              : vb->v4l2_planes[plane].length;
> +
> +                       if (b->m.planes[plane].bytesused > length)
> +                               return -EINVAL;
> +                       if (b->m.planes[plane].data_offset >=
> +                           b->m.planes[plane].bytesused)
> +                               return -EINVAL;
> +               }
> +       } else {
> +               length = (b->memory == V4L2_MEMORY_USERPTR)
> +                      ? b->length : vb->v4l2_planes[0].length;
> +
> +               if (b->bytesused > length)
> +                       return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
> +/**
>   * __buffer_in_use() - return true if the buffer is in use and
>   * the queue cannot be freed (by the means of REQBUFS(0)) call
>   */
> @@ -975,6 +1010,10 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         struct vb2_queue *q = vb->vb2_queue;
>         int ret;
>
> +       ret = __verify_length(vb, b);
> +       if (ret < 0)
> +               return ret;
> +
>         switch (q->memory) {
>         case V4L2_MEMORY_MMAP:
>                 ret = __qbuf_mmap(vb, b);
> --
> Regards,
>
> Laurent Pinchart
>



-- 
Best regards,
Pawel Osciak
