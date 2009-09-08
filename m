Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n887W3IA006613
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 03:32:03 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n887VmAS008851
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 03:31:49 -0400
Date: Tue, 8 Sep 2009 09:31:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ueiqiw6mn.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0909080931160.4550@axis700.grange>
References: <ueiqiw6mn.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 1/4] soc-camera: tw9910: hsync_ctrl can control from
 platform
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

Hi Morimoto-san

Before reviewing the code - why is this needed?

Thanks
Guennadi

On Tue, 8 Sep 2009, Kuninori Morimoto wrote:

> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
>  drivers/media/video/tw9910.c |   31 ++++++++++++++-----------------
>  include/media/tw9910.h       |    2 ++
>  2 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
> index e41eb9c..79ba997 100644
> --- a/drivers/media/video/tw9910.c
> +++ b/drivers/media/video/tw9910.c
> @@ -192,6 +192,10 @@
>  #define RTSEL_FIELD 0x06 /* 0110 = FIELD */
>  #define RTSEL_RTCO  0x07 /* 0111 = RTCO ( Real Time Control ) */
>  
> +/* HSYNC default */
> +#define HSTART 0x0160
> +#define HEND   0x0300
> +
>  /*
>   * structure
>   */
> @@ -216,11 +220,6 @@ struct tw9910_cropping_ctrl {
>  	u16 hactive;
>  };
>  
> -struct tw9910_hsync_ctrl {
> -	u16 start;
> -	u16 end;
> -};
> -
>  struct tw9910_priv {
>  	struct v4l2_subdev                subdev;
>  	struct tw9910_video_info       *info;
> @@ -346,11 +345,6 @@ static const struct tw9910_cropping_ctrl tw9910_cropping_ctrl = {
>  	.hactive = 0x02D0,
>  };
>  
> -static const struct tw9910_hsync_ctrl tw9910_hsync_ctrl = {
> -	.start = 0x0260,
> -	.end   = 0x0300,
> -};
> -
>  /*
>   * general function
>   */
> @@ -417,19 +411,19 @@ static int tw9910_set_cropping(struct i2c_client *client,
>  }
>  
>  static int tw9910_set_hsync(struct i2c_client *client,
> -			    const struct tw9910_hsync_ctrl *hsync)
> +			    const u16 start, const u16 end)
>  {
>  	int ret;
>  
>  	/* bit 10 - 3 */
>  	ret = i2c_smbus_write_byte_data(client, HSGEGIN,
> -					(hsync->start & 0x07F8) >> 3);
> +					(start & 0x07F8) >> 3);
>  	if (ret < 0)
>  		return ret;
>  
>  	/* bit 10 - 3 */
>  	ret = i2c_smbus_write_byte_data(client, HSEND,
> -					(hsync->end & 0x07F8) >> 3);
> +					(end & 0x07F8) >> 3);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -439,9 +433,9 @@ static int tw9910_set_hsync(struct i2c_client *client,
>  		return ret;
>  
>  	ret = i2c_smbus_write_byte_data(client, HSLOWCTL,
> -					(ret & 0x88)                 |
> -					(hsync->start & 0x0007) << 4 |
> -					(hsync->end   & 0x0007));
> +					(ret   & 0x88)        |
> +					(start & 0x0007) << 4 |
> +					(end   & 0x0007));
>  
>  	return ret;
>  }
> @@ -697,7 +691,10 @@ static int tw9910_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
>  	/*
>  	 * set hsync
>  	 */
> -	ret = tw9910_set_hsync(client, &tw9910_hsync_ctrl);
> +	ret = tw9910_set_hsync(client,
> +			       HSTART + priv->info->start_offset,
> +			       HEND   + priv->info->end_offset);
> +
>  	if (ret < 0)
>  		goto tw9910_set_fmt_error;
>  
> diff --git a/include/media/tw9910.h b/include/media/tw9910.h
> index 73231e7..6ddb654 100644
> --- a/include/media/tw9910.h
> +++ b/include/media/tw9910.h
> @@ -33,6 +33,8 @@ struct tw9910_video_info {
>  	unsigned long          buswidth;
>  	enum tw9910_mpout_pin  mpout;
>  	struct soc_camera_link link;
> +	u16 start_offset;
> +	u16 end_offset;
>  };
>  
>  
> -- 
> 1.6.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
