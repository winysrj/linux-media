Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:33073 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3C3Muw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Mar 2013 08:50:52 -0400
Received: by mail-ea0-f172.google.com with SMTP id z7so529456eaf.3
        for <linux-media@vger.kernel.org>; Sat, 30 Mar 2013 05:50:51 -0700 (PDT)
Message-ID: <5156DFE6.70206@googlemail.com>
Date: Sat, 30 Mar 2013 13:51:50 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] em28xx: fix typo in scale_to_size().
References: <201303301031.42165.hverkuil@xs4all.nl>
In-Reply-To: <201303301031.42165.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 30.03.2013 10:31, schrieb Hans Verkuil:
> em28xx: fix typo in scale_to_size().
>
> The second hscale should be vscale. This bug caused xawtv to fail because it
> cannot find a workable image size.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index ef1959b..792ead1 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -996,7 +996,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  	}
>  
>  	size_to_scale(dev, width, height, &hscale, &vscale);
> -	scale_to_size(dev, hscale, hscale, &width, &height);
> +	scale_to_size(dev, hscale, vscale, &width, &height);
>  
>  	f->fmt.pix.width = width;
>  	f->fmt.pix.height = height;

Acked-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Thanks for catching this !

Regards,
Frank
