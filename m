Return-path: <mchehab@pedra>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58777 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993Ab1GDP37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 11:29:59 -0400
Received: by fxd18 with SMTP id 18so5363372fxd.11
        for <linux-media@vger.kernel.org>; Mon, 04 Jul 2011 08:29:58 -0700 (PDT)
Date: Mon, 4 Jul 2011 17:29:54 +0200 (CEST)
From: Bastian Hecht <hechtb@googlemail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: sh_mobile_ceu_camera: fix Oops when USERPTR mapping
 fails
In-Reply-To: <Pine.LNX.4.64.1107041713500.28687@axis700.grange>
Message-ID: <alpine.DEB.2.02.1107041728360.30004@bender>
References: <Pine.LNX.4.64.1107041713500.28687@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Mon, 4 Jul 2011, Guennadi Liakhovetski wrote:

> If vb2_dma_contig_get_userptr() fails on a videobuffer, driver's
> .buf_init() method will not be called and the list will not be
> initialised. Trying to remove an uninitialised element from a list leads
> to a NULL-dereference.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Tested on mackerel.

Tested-by: Bastian Hecht <hechtb@gmail.com>

Thanks,

 Bastian

> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 3ae5c9c..a851a3e 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -421,8 +421,12 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
>  		pcdev->active = NULL;
>  	}
>  
> -	/* Doesn't hurt also if the list is empty */
> -	list_del_init(&buf->queue);
> +	/*
> +	 * Doesn't hurt also if the list is empty, but it hurts, if queuing the
> +	 * buffer failed, and .buf_init() hasn't been called
> +	 */
> +	if (buf->queue.next)
> +		list_del_init(&buf->queue);
>  
>  	spin_unlock_irq(&pcdev->lock);
>  }
> -- 
> 1.7.2.5
> 
