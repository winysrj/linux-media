Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:63219 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaDGHVN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 03:21:13 -0400
Received: by mail-yh0-f46.google.com with SMTP id b6so5465853yha.19
        for <linux-media@vger.kernel.org>; Mon, 07 Apr 2014 00:21:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394486458-9836-4-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl> <1394486458-9836-4-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 7 Apr 2014 16:20:27 +0900
Message-ID: <CAMm-=zCtWq=4_g9aweU6Hc=_ONscHLMegytFWXMjoC7edi1O2g@mail.gmail.com>
Subject: Re: [REVIEW PATCH 03/11] vb2: if bytesused is 0, then fill with
 output buffer length
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm thinking, that if we are doing this, perhaps we should just update
the API to allow this case, i.e. say that if the bytesused is not set
for any planes, length will be used by default?
This would be backwards-compatible.

On Tue, Mar 11, 2014 at 6:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The application should really always fill in bytesused for output
> buffers, unfortunately the vb2 framework never checked for that.
>
> So for single planar formats replace a bytesused of 0 by the length
> of the buffer, and for multiplanar format do the same if bytesused is
> 0 for ALL planes.
>
> This seems to be what the user really intended if v4l2_buffer was
> just memset to 0.
>
> I'm afraid that just checking for this and returning an error would
> break too many applications. Quite a few drivers never check for bytesused
> at all and just use the buffer length instead.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 1a09442..83e78e9 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1145,19 +1145,35 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                         memset(v4l2_planes[plane].reserved, 0,
>                                sizeof(v4l2_planes[plane].reserved));
>                         v4l2_planes[plane].data_offset = 0;
> +                       v4l2_planes[plane].bytesused = 0;
>                 }
>
>                 /* Fill in driver-provided information for OUTPUT types */
>                 if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +                       bool bytesused_is_used;
> +
> +                       /* Check if bytesused == 0 for all planes */
> +                       for (plane = 0; plane < vb->num_planes; ++plane)
> +                               if (b->m.planes[plane].bytesused)
> +                                       break;
> +                       bytesused_is_used = plane < vb->num_planes;
> +
>                         /*
>                          * Will have to go up to b->length when API starts
>                          * accepting variable number of planes.
> +                        *
> +                        * If bytesused_is_used is false, then fall back to the
> +                        * full buffer size. In that case userspace clearly
> +                        * never bothered to set it and it's a safe assumption
> +                        * that they really meant to use the full plane sizes.
>                          */
>                         for (plane = 0; plane < vb->num_planes; ++plane) {
> -                               v4l2_planes[plane].bytesused =
> -                                       b->m.planes[plane].bytesused;
> -                               v4l2_planes[plane].data_offset =
> -                                       b->m.planes[plane].data_offset;
> +                               struct v4l2_plane *pdst = &v4l2_planes[plane];
> +                               struct v4l2_plane *psrc = &b->m.planes[plane];
> +
> +                               pdst->bytesused = bytesused_is_used ?
> +                                       psrc->bytesused : psrc->length;
> +                               pdst->data_offset = psrc->data_offset;
>                         }
>                 }
>
> @@ -1183,9 +1199,15 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>                  * so fill in relevant v4l2_buffer struct fields instead.
>                  * In videobuf we use our internal V4l2_planes struct for
>                  * single-planar buffers as well, for simplicity.
> +                *
> +                * If bytesused == 0, then fall back to the full buffer size
> +                * as that's a sensible default.
>                  */
>                 if (V4L2_TYPE_IS_OUTPUT(b->type))
> -                       v4l2_planes[0].bytesused = b->bytesused;
> +                       v4l2_planes[0].bytesused =
> +                               b->bytesused ? b->bytesused : b->length;
> +               else
> +                       v4l2_planes[0].bytesused = 0;
>                 /* Single-planar buffers never use data_offset */
>                 v4l2_planes[0].data_offset = 0;
>
> --
> 1.9.0
>



-- 
Best regards,
Pawel Osciak
