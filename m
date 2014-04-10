Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:50291 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaDJBQt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 21:16:49 -0400
Received: by mail-yk0-f174.google.com with SMTP id 20so2932157yks.5
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 18:16:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396876272-18222-11-git-send-email-hverkuil@xs4all.nl>
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl> <1396876272-18222-11-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 10 Apr 2014 10:08:31 +0900
Message-ID: <CAMm-=zADVfFPJSuHifGadOeYxbxM-8P0cf2nsRFbM_5U_6yxtQ@mail.gmail.com>
Subject: Re: [REVIEWv2 PATCH 10/13] vb2: set v4l2_buffer.bytesused to 0 for mp buffers
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 7, 2014 at 10:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The bytesused field of struct v4l2_buffer is not used for multiplanar
> formats, so just zero it to prevent it from having some random value.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 08152dd..ef7ef82 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -582,6 +582,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>                  * for it. The caller has already verified memory and size.
>                  */
>                 b->length = vb->num_planes;
> +               b->bytesused = 0;
>                 memcpy(b->m.planes, vb->v4l2_planes,
>                         b->length * sizeof(struct v4l2_plane));
>         } else {
> --
> 1.9.1
>



-- 
Best regards,
Pawel Osciak
