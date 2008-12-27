Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBRHTUXj032519
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 12:29:30 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBRHTFcL005409
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 12:29:16 -0500
Date: Sat, 27 Dec 2008 18:29:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uocyziigu.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812271829040.4409@axis700.grange>
References: <uocyziigu.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] dev_info to dev_dbg on ov772x driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Thu, 18 Dec 2008, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

Queued.

Thanks
Guennadi

> ---
>  drivers/media/video/ov772x.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 0657048..15721f0 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -637,7 +637,6 @@ static int ov772x_start_capture(struct soc_camera_device *icd)
>  	struct ov772x_priv *priv = container_of(icd, struct ov772x_priv, icd);
>  	int                 ret;
>  
> -
>  	if (!priv->win)
>  		priv->win = &ov772x_win_vga;
>  	if (!priv->fmt)
> @@ -690,7 +689,7 @@ static int ov772x_start_capture(struct soc_camera_device *icd)
>  			goto start_end;
>  	}
>  
> -	dev_info(&icd->dev,
> +	dev_dbg(&icd->dev,
>  		 "format %s, win %s\n", priv->fmt->name, priv->win->name);
>  
>  start_end:
> -- 
> 1.5.6.3
> 

---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
