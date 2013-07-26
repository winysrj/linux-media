Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:58858 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758650Ab3GZL0c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 07:26:32 -0400
Date: Fri, 26 Jul 2013 13:26:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: fix compiler warning
In-Reply-To: <201307251440.34496.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1307261320280.22137@axis700.grange>
References: <201307251440.34496.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

Thanks for the patch.

On Thu, 25 Jul 2013, Hans Verkuil wrote:

> 
> media_build/v4l/soc_camera.c: In function 'soc_camera_host_register':
> media_build/v4l/soc_camera.c:1513:10: warning: 'sasd' may be used uninitialized in this function [-Wmaybe-uninitialized]
>   snprintf(clk_name, sizeof(clk_name), "%d-%04x",
>           ^
> media_build/v4l/soc_camera.c:1464:34: note: 'sasd' was declared here
>   struct soc_camera_async_subdev *sasd;
>                                   ^

Heh, cool... You did report a similar warning earlier, for which I cooked 
up a patch "[media] V4L2: soc-camera: fix uninitialised use compiler 
warning" and IIRC you reported that with that patch the warning 
disappeared... How come we've got another one now? Have you updated your 
compiler again or what can be the reason?

In principle I have nothing against this patch, just wondering where 
you're getting your compilers from ;-)

> By changing the type of 'i' to unsigned and changing a condition we finally
> convince the compiler that sasd is really initialized.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I haven't got any more 3.11 fixed in my queue and we have to push this 
before -rc3 / rc4 ;) So, if you prefer, feel free to take it via your tree 
with my

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/platform/soc_camera/soc_camera.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 2dd0e52..ed7a99f 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1466,7 +1466,8 @@ static int scan_async_group(struct soc_camera_host *ici,
>  	struct soc_camera_device *icd;
>  	struct soc_camera_desc sdesc = {.host_desc.bus_id = ici->nr,};
>  	char clk_name[V4L2_SUBDEV_NAME_SIZE];
> -	int ret, i;
> +	unsigned int i;
> +	int ret;
>  
>  	/* First look for a sensor */
>  	for (i = 0; i < size; i++) {
> @@ -1475,7 +1476,7 @@ static int scan_async_group(struct soc_camera_host *ici,
>  			break;
>  	}
>  
> -	if (i == size || asd[i]->bus_type != V4L2_ASYNC_BUS_I2C) {
> +	if (i >= size || asd[i]->bus_type != V4L2_ASYNC_BUS_I2C) {
>  		/* All useless */
>  		dev_err(ici->v4l2_dev.dev, "No I2C data source found!\n");
>  		return -ENODEV;
> -- 
> 1.8.3.2
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
