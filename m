Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx04.extmail.prod.ext.phx2.redhat.com
	[10.5.110.8])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nA4EmPX0006860
	for <video4linux-list@redhat.com>; Wed, 4 Nov 2009 09:48:25 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id nA4EmA9o002615
	for <video4linux-list@redhat.com>; Wed, 4 Nov 2009 09:48:11 -0500
Date: Wed, 4 Nov 2009 15:48:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ueiohwrdo.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0911041543470.4837@axis700.grange>
References: <ueiohwrdo.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/4] soc-camera: tw9910: Add revision control
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

On Mon, 2 Nov 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/tw9910.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index 09ea042..a0b5bbe 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -225,6 +225,7 @@ struct tw9910_priv {
>  	struct v4l2_subdev                subdev;
>  	struct tw9910_video_info       *info;
>  	const struct tw9910_scale_ctrl *scale;
> +	int rev;

Not critical, but I think we can afford a complete "revision" here.

>  };
>  
>  /*
> @@ -570,8 +571,11 @@ static int tw9910_enum_input(struct soc_camera_device *icd,
>  static int tw9910_g_chip_ident(struct v4l2_subdev *sd,
>  			       struct v4l2_dbg_chip_ident *id)
>  {
> +	struct i2c_client *client = sd->priv;
> +	struct tw9910_priv *priv = to_tw9910(client);
> +
>  	id->ident = V4L2_IDENT_TW9910;
> -	id->revision = 0;
> +	id->revision = priv->rev;
>  
>  	return 0;
>  }
> @@ -886,6 +890,8 @@ static int tw9910_video_probe(struct soc_camera_device *icd,
>  		return -ENODEV;
>  	}
>  
> +	priv->rev = GET_ReV(val);
> +

If you assign this directly after calling i2c_smbus_read_byte_data() you 
would save yourself a couple of "&" operations behind the GET_ReV() macro 
(btw, why such strange capitalisation? why not just GET_REV()?). Don't 
worry about the error case, priv will get freed then.

>  	dev_info(&client->dev,
>  		 "tw9910 Product ID %0x:%0x\n", GET_ID(val), GET_ReV(val));

you would also replace it here.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
