Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:39357 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762392AbZFOQCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 12:02:49 -0400
Received: by pxi27 with SMTP id 27so312713pxi.33
        for <linux-media@vger.kernel.org>; Mon, 15 Jun 2009 09:02:51 -0700 (PDT)
Subject: Re: [PATCH] zr364xx.c: vfree does its own NULL check
From: "Figo.zhang" <figo1802@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <1244279782.3185.9.camel@myhost>
References: <1244279782.3185.9.camel@myhost>
Content-Type: text/plain
Date: Tue, 16 Jun 2009 00:02:48 +0800
Message-Id: <1245081768.3337.0.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi Mauro,
is it ok for this patch?

Best Regards,

Figo.zhang


On Sat, 2009-06-06 at 17:16 +0800, Figo.zhang wrote:
> vfree() does it's own NULL checking, no need for explicit check before
> calling it.
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> --- 
>  drivers/media/video/zr364xx.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
> index ac169c9..fc976f4 100644
> --- a/drivers/media/video/zr364xx.c
> +++ b/drivers/media/video/zr364xx.c
> @@ -882,9 +882,11 @@ static void zr364xx_disconnect(struct usb_interface *intf)
>  		video_unregister_device(cam->vdev);
>  	cam->vdev = NULL;
>  	kfree(cam->buffer);
> -	if (cam->framebuf)
> -		vfree(cam->framebuf);
> +	cam->buffer = NULL;
> +	vfree(cam->framebuf);
> +	cam->framebuf = NULL;
>  	kfree(cam);
> +	cam = NULL;
>  }
>  
> 
> 
> 
> 
> 
> 
> 

