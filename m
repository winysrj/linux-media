Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32842 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab3HZCsI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Aug 2013 22:48:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130823095444.GR31293@elgon.mountain>
References: <20130823095444.GR31293@elgon.mountain>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 26 Aug 2013 08:17:45 +0530
Message-ID: <CA+V-a8vkSxunfh-V_Fz32EiuE36ZEd_LGkxkpdQiS+22xvZTAA@mail.gmail.com>
Subject: Re: [patch] [media] sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 23, 2013 at 3:24 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The "i < " part of the "i < ARRAY_SIZE()" condition was missing.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by:  Lad, Prabhakar <prabhakar.lad@ti.com>

Regards,
--Prabhakar Lad

>
> diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
> index 7a9c5e9..41f612c 100644
> --- a/drivers/media/platform/sh_vou.c
> +++ b/drivers/media/platform/sh_vou.c
> @@ -776,9 +776,10 @@ static int sh_vou_try_fmt_vid_out(struct file *file, void *priv,
>         v4l_bound_align_image(&pix->width, 0, VOU_MAX_IMAGE_WIDTH, 1,
>                               &pix->height, 0, VOU_MAX_IMAGE_HEIGHT, 1, 0);
>
> -       for (i = 0; ARRAY_SIZE(vou_fmt); i++)
> +       for (i = 0; i < ARRAY_SIZE(vou_fmt); i++) {
>                 if (vou_fmt[i].pfmt == pix->pixelformat)
>                         return 0;
> +       }
>
>         pix->pixelformat = vou_fmt[0].pfmt;
>
