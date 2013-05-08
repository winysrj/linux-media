Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3EHMME convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 08:12:04 -0400
Date: Wed, 8 May 2013 14:11:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] mt9t031: Fix panic on probe
In-Reply-To: <1368014334-23680-1-git-send-email-philippe.retornaz@epfl.ch>
Message-ID: <Pine.LNX.4.64.1305081411080.11707@axis700.grange>
References: <1368014334-23680-1-git-send-email-philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philippe

On Wed, 8 May 2013, Philippe Rétornaz wrote:

> The video device is not yet valid when probe() is called.
> Call directly soc_camera_power_on/off() instead of calling mt9t031_s_power().
> 
> Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>

There is already a patch for this:

https://patchwork.kernel.org/patch/2462501/

Thanks
Guennadi

> ---
>  drivers/media/i2c/soc_camera/mt9t031.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
> index d80d044..71c0b16 100644
> --- a/drivers/media/i2c/soc_camera/mt9t031.c
> +++ b/drivers/media/i2c/soc_camera/mt9t031.c
> @@ -632,10 +632,11 @@ static int mt9t031_s_power(struct v4l2_subdev *sd, int on)
>  static int mt9t031_video_probe(struct i2c_client *client)
>  {
>  	struct mt9t031 *mt9t031 = to_mt9t031(client);
> +	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
>  	s32 data;
>  	int ret;
>  
> -	ret = mt9t031_s_power(&mt9t031->subdev, 1);
> +	ret = soc_camera_power_on(&client->dev, ssdd);
>  	if (ret < 0)
>  		return ret;
>  
> @@ -664,7 +665,7 @@ static int mt9t031_video_probe(struct i2c_client *client)
>  	ret = v4l2_ctrl_handler_setup(&mt9t031->hdl);
>  
>  done:
> -	mt9t031_s_power(&mt9t031->subdev, 0);
> +	soc_camera_power_off(&client->dev, ssdd);
>  
>  	return ret;
>  }
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
