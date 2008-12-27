Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBRHU1h9032579
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 12:30:01 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBRHTkKO005580
	for <video4linux-list@redhat.com>; Sat, 27 Dec 2008 12:29:47 -0500
Date: Sat, 27 Dec 2008 18:29:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uprjfiigy.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0812271829420.4409@axis700.grange>
References: <uprjfiigy.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] Settle i2c client data on ov772x driver
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
>  drivers/media/video/ov772x.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
> index 0cc7ea4..c7a2420 100644
> --- a/drivers/media/video/ov772x.c
> +++ b/drivers/media/video/ov772x.c
> @@ -944,8 +944,10 @@ static int ov772x_probe(struct i2c_client          *client,
>  
>  	ret = soc_camera_device_register(icd);
>  
> -	if (ret)
> +	if (ret) {
> +		i2c_set_clientdata(client, NULL);
>  		kfree(priv);
> +	}
>  
>  	return ret;
>  }
> @@ -955,6 +957,7 @@ static int ov772x_remove(struct i2c_client *client)
>  	struct ov772x_priv *priv = i2c_get_clientdata(client);
>  
>  	soc_camera_device_unregister(&priv->icd);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(priv);
>  	return 0;
>  }
> -- 
> 1.5.6.3
> 

---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
