Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34502 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab3CDJUT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 04:20:19 -0500
Received: by mail-wg0-f48.google.com with SMTP id 16so3961538wgi.27
        for <linux-media@vger.kernel.org>; Mon, 04 Mar 2013 01:20:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <fd5a003b7dfa01578da8e0fc92a9c1df551cd594.1362387265.git.hans.verkuil@cisco.com>
References: <b14bb5bd725678bc0fadfa241b462b5d6487f099.1362387265.git.hans.verkuil@cisco.com>
 <1362387905-3666-1-git-send-email-hverkuil@xs4all.nl> <fd5a003b7dfa01578da8e0fc92a9c1df551cd594.1362387265.git.hans.verkuil@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 4 Mar 2013 14:49:56 +0530
Message-ID: <CA+V-a8vzE9NzacS9_Lj3Y8Jmh-5ch=A4cPkuycufyjOsyYwTGA@mail.gmail.com>
Subject: Re: [REVIEW PATCH 09/11] davinci/vpfe_capture: remove current_norm
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	linux@arm.linux.org.uk, Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch!

On Mon, Mar 4, 2013 at 2:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Since vpfe_capture already provided a g_std op setting current_norm
> does not actually do anything. Remove it.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Lad, Prabhakar <prabhakar.lad@ti.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/media/platform/davinci/vpfe_capture.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
> index 70facc0..3d1af67 100644
> --- a/drivers/media/platform/davinci/vpfe_capture.c
> +++ b/drivers/media/platform/davinci/vpfe_capture.c
> @@ -1884,7 +1884,6 @@ static int vpfe_probe(struct platform_device *pdev)
>         vfd->fops               = &vpfe_fops;
>         vfd->ioctl_ops          = &vpfe_ioctl_ops;
>         vfd->tvnorms            = 0;
> -       vfd->current_norm       = V4L2_STD_PAL;
>         vfd->v4l2_dev           = &vpfe_dev->v4l2_dev;
>         snprintf(vfd->name, sizeof(vfd->name),
>                  "%s_V%d.%d.%d",
> --
> 1.7.10.4
>
