Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GN9B41028467
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 19:09:11 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9GN8WIZ012799
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 19:08:32 -0400
Date: Fri, 17 Oct 2008 01:08:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0810151247230.5361@axis700.grange>
Message-ID: <Pine.LNX.4.64.0810170107310.8422@axis700.grange>
References: <20081014183936.GB4710@cs181140183.pp.htv.fi>
	<Pine.LNX.4.64.0810142335400.10458@axis700.grange>
	<20081015033303.GC4710@cs181140183.pp.htv.fi>
	<20081015052026.GC20183@cs181140183.pp.htv.fi>
	<aec7e5c30810142328n1563163bw636b8baf1a47ad8b@mail.gmail.com>
	<Pine.LNX.4.64.0810150836100.3896@axis700.grange>
	<aec7e5c30810150103p7ed810ccyc815ad578d64feac@mail.gmail.com>
	<Pine.LNX.4.64.0810151011450.3896@axis700.grange>
	<aec7e5c30810150155q244834c0i65b2f3b927ba2d37@mail.gmail.com>
	<Pine.LNX.4.64.0810151247230.5361@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, video4linux-list@redhat.com,
	lethal@linux-sh.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] soc-camera: fix compile breakage on SH
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

On Wed, 15 Oct 2008, Guennadi Liakhovetski wrote:

> Fix Migo-R compile breakage caused by incomplete merge. Also remove 
> redundant soc_camera_platform_info struct definition from 
> drivers/media/video/soc_camera_platform.c

Ok, I got no acks to this one, so, let's drop it, I'll submit its two 
parts to the v4l and sh lists and maintainers independently.

Thanks
Guennadi

> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Tested-by: Magnus Damm <damm@igel.co.jp>
> 
> ---
> 
> Paul, Mauro, as this patch closes a compile-breakage, I'd like to get it 
> upstream asap. What would be the fastest way: get your both Acked-by and 
> send it directly to Andrew / Linus, or an Acked-by from one of you and 
> let the other one merge (you can decide who does what:-)) Splitting it 
> into two patches and merging separately seems suboptimal to me in this 
> case.
> 
> Thanks
> Guennadi
> 
> diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
> index 714dce9..95459f3 100644
> --- a/arch/sh/boards/mach-migor/setup.c
> +++ b/arch/sh/boards/mach-migor/setup.c
> @@ -312,6 +312,14 @@ static void camera_power_off(void)
>  	ctrl_outb(ctrl_inb(PORT_PTDR) & ~0x08, PORT_PTDR);
>  }
>  
> +static void camera_power(int mode)
> +{
> +	if (mode)
> +		camera_power_on();
> +	else
> +		camera_power_off();
> +}
> +
>  #ifdef CONFIG_I2C
>  static unsigned char camera_ov772x_magic[] =
>  {
> @@ -391,6 +399,7 @@ static struct soc_camera_platform_info ov772x_info = {
>  	},
>  	.bus_param =  SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
>  	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
> +	.power = camera_power,
>  	.set_capture = ov772x_set_capture,
>  };
>  
> @@ -405,8 +414,6 @@ static struct platform_device migor_camera_device = {
>  static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
>  	.flags = SOCAM_MASTER | SOCAM_DATAWIDTH_8 | SOCAM_PCLK_SAMPLE_RISING \
>  	| SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH,
> -	.enable_camera = camera_power_on,
> -	.disable_camera = camera_power_off,
>  };
>  
>  static struct resource migor_ceu_resources[] = {
> diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
> index 1adc257..bb7a9d4 100644
> --- a/drivers/media/video/soc_camera_platform.c
> +++ b/drivers/media/video/soc_camera_platform.c
> @@ -18,15 +18,7 @@
>  #include <linux/videodev2.h>
>  #include <media/v4l2-common.h>
>  #include <media/soc_camera.h>
> -
> -struct soc_camera_platform_info {
> -	int iface;
> -	char *format_name;
> -	unsigned long format_depth;
> -	struct v4l2_pix_format format;
> -	unsigned long bus_param;
> -	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
> -};
> +#include <media/soc_camera_platform.h>
>  
>  struct soc_camera_platform_priv {
>  	struct soc_camera_platform_info *info;
> @@ -44,11 +36,21 @@ soc_camera_platform_get_info(struct soc_camera_device *icd)
>  
>  static int soc_camera_platform_init(struct soc_camera_device *icd)
>  {
> +	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
> +
> +	if (p->power)
> +		p->power(1);
> +
>  	return 0;
>  }
>  
>  static int soc_camera_platform_release(struct soc_camera_device *icd)
>  {
> +	struct soc_camera_platform_info *p = soc_camera_platform_get_info(icd);
> +
> +	if (p->power)
> +		p->power(0);
> +
>  	return 0;
>  }
>  
> diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
> index 851f182..7c81ad3 100644
> --- a/include/media/soc_camera_platform.h
> +++ b/include/media/soc_camera_platform.h
> @@ -9,6 +9,7 @@ struct soc_camera_platform_info {
>  	unsigned long format_depth;
>  	struct v4l2_pix_format format;
>  	unsigned long bus_param;
> +	void (*power)(int);
>  	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
>  };
>  
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
