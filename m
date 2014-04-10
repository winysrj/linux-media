Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:35534 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbaDJAxo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 20:53:44 -0400
Received: by mail-yh0-f45.google.com with SMTP id a41so3199296yho.18
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 17:53:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396876272-18222-3-git-send-email-hverkuil@xs4all.nl>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl> <1396876272-18222-3-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 10 Apr 2014 09:46:47 +0900
Message-ID: <CAMm-=zC=k_Cx-tmd_iPsiFmv1YXpYXKwfaR12mU9UeYHGddfLg@mail.gmail.com>
Subject: Re: [REVIEWv2 PATCH 02/13] vb2: fix handling of data_offset and v4l2_plane.reserved[]
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good to me, just a small nit below.


On Mon, Apr 7, 2014 at 10:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The videobuf2-core did not zero the 'planes' array in __qbuf_userptr()
> and __qbuf_dmabuf(). That's now memset to 0. Without this the reserved
> array in struct v4l2_plane would be non-zero, causing v4l2-compliance
> errors.
>
> More serious is the fact that data_offset was not handled correctly:
>
> - for capture devices it was never zeroed, which meant that it was
>   uninitialized. Unless the driver sets it it was a completely random
>   number. With the memset above this is now fixed.
>
> - __qbuf_dmabuf had a completely incorrect length check that included
>   data_offset.
>
> - in __fill_vb2_buffer in the DMABUF case the data_offset field was
>   unconditionally copied from v4l2_buffer to v4l2_plane when this
>   should only happen in the output case.
>
> - in the single-planar case data_offset was never correctly set to 0.
>   The single-planar API doesn't support data_offset, so setting it
>   to 0 is the right thing to do. This too is now solved by the memset.
>
> All these issues were found with v4l2-compliance.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index f9059bb..596998e 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1169,8 +1169,6 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                                         b->m.planes[plane].m.fd;
>                                 v4l2_planes[plane].length =
>                                         b->m.planes[plane].length;
> -                               v4l2_planes[plane].data_offset =
> -                                       b->m.planes[plane].data_offset;
>                         }
>                 }
>         } else {
> @@ -1180,10 +1178,8 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                  * In videobuf we use our internal V4l2_planes struct for
>                  * single-planar buffers as well, for simplicity.
>                  */
> -               if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +               if (V4L2_TYPE_IS_OUTPUT(b->type))
>                         v4l2_planes[0].bytesused = b->bytesused;
> -                       v4l2_planes[0].data_offset = 0;
> -               }
>
>                 if (b->memory == V4L2_MEMORY_USERPTR) {
>                         v4l2_planes[0].m.userptr = b->m.userptr;
> @@ -1193,9 +1189,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                 if (b->memory == V4L2_MEMORY_DMABUF) {
>                         v4l2_planes[0].m.fd = b->m.fd;
>                         v4l2_planes[0].length = b->length;
> -                       v4l2_planes[0].data_offset = 0;
>                 }
> -
>         }
>
>         /* Zero flags that the vb2 core handles */
> @@ -1238,6 +1232,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         int write = !V4L2_TYPE_IS_OUTPUT(q->type);
>         bool reacquired = vb->planes[0].mem_priv == NULL;
>
> +       memset(planes, 0, sizeof(planes[0]) * vb->num_planes);

memset(planes, 0, sizeof(planes));

>         /* Copy relevant information provided by the userspace */
>         __fill_vb2_buffer(vb, b, planes);
>
> @@ -1357,6 +1352,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>         int write = !V4L2_TYPE_IS_OUTPUT(q->type);
>         bool reacquired = vb->planes[0].mem_priv == NULL;
>
> +       memset(planes, 0, sizeof(planes[0]) * vb->num_planes);

memset(planes, 0, sizeof(planes));

>         /* Copy relevant information provided by the userspace */
>         __fill_vb2_buffer(vb, b, planes);
>
> @@ -1374,8 +1370,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>                 if (planes[plane].length == 0)
>                         planes[plane].length = dbuf->size;
>
> -               if (planes[plane].length < planes[plane].data_offset +
> -                   q->plane_sizes[plane]) {
> +               if (planes[plane].length < q->plane_sizes[plane]) {
>                         dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
>                                 plane);
>                         ret = -EINVAL;
> --
> 1.9.1
>



-- 
Best regards,
Pawel Osciak
