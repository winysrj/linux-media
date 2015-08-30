Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55641 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbbH3OGa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 10:06:30 -0400
Date: Sun, 30 Aug 2015 16:06:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: soc-camera: increase the length of clk_name on
 soc_of_bind()
In-Reply-To: <1438685469-12230-1-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1508301604030.29683@axis700.grange>
References: <1438685469-12230-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Sorry, I missed the 4.3 merge cycle, but isn't this patch a fix? Isn't it 
fixing soc-camera / atmel-isi on a specific platform, where the clock name 
is longer, than currently supported? Is this platform in the mainline and 
its current camera support is broken because of this? In such a case we 
could still push it in for 4.3

Thanks
Guennadi

On Tue, 4 Aug 2015, Josh Wu wrote:

> Since in soc_of_bind() it may use the of node's full name as the clk_name,
> and this full name may be longer than 32 characters, take at91 i2c sensor
> as an example, length is 34 bytes:
>    /ahb/apb/i2c@f8028000/camera@0x30
> 
> So this patch increase the clk_name[] array size to 64. It seems big
> enough so far.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> 
>  drivers/media/platform/soc_camera/soc_camera.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index d708df4..fcf3e97 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1621,7 +1621,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
>  	struct soc_camera_async_client *sasc;
>  	struct soc_of_info *info;
>  	struct i2c_client *client;
> -	char clk_name[V4L2_SUBDEV_NAME_SIZE];
> +	char clk_name[V4L2_SUBDEV_NAME_SIZE + 32];
>  	int ret;
>  
>  	/* allocate a new subdev and add match info to it */
> -- 
> 1.9.1
> 
