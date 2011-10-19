Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47883 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1JSGEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 02:04:04 -0400
Received: by yxp4 with SMTP id 4so1348691yxp.19
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 23:04:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317626505-17612-1-git-send-email-m.szyprowski@samsung.com>
References: <4E85C5A7.7090005@samsung.com> <1317626505-17612-1-git-send-email-m.szyprowski@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 18 Oct 2011 23:03:44 -0700
Message-ID: <CAMm-=zCL_4rXL351DyeR7TcFGfar0+sk3Lx75MqZRTi-w+urfw@mail.gmail.com>
Subject: Re: [PATCH] media: vb2: fix incorrect return value
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 3, 2011 at 00:21, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> This patch fixes incorrect return value. Errors should be returned
> as negative numbers.
>
> Reported-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/videobuf2-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 6687ac3..3f5c7a3 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -751,7 +751,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, struct v4l2_buffer *b)
>
>                /* Check if the provided plane buffer is large enough */
>                if (planes[plane].length < q->plane_sizes[plane]) {
> -                       ret = EINVAL;
> +                       ret = -EINVAL;
>                        goto err;
>                }
>
> --
> 1.7.1.569.g6f426
>
>


Acked-by: Pawel Osciak <pawel@osciak.com>

-- 
Best regards,
Pawel Osciak
