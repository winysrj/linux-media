Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3926 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3FXJov (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 05:44:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L2: soc-camera: fix uninitialised use compiler warning
Date: Mon, 24 Jun 2013 11:44:44 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1306241130310.19735@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1306241130310.19735@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306241144.44951.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 24 2013 11:32:32 Guennadi Liakhovetski wrote:
> In scan_async_group() if the size parameter is negative, the sasd pointer
> will be used uninitialised:
> 
> drivers/media/platform/soc_camera/soc_camera.c: In function "soc_camera_host_register":
> drivers/media/platform/soc_camera/soc_camera.c:1514:55: warning: "sasd" may
> be used uninitialized in this function [-Wmaybe-uninitialized]
>     sasd->asd.match.i2c.adapter_id, sasd->asd.match.i2c.address);
>                                                        ^
> drivers/media/platform/soc_camera/soc_camera.c:1464:34: note: "sasd" was
> declared here
>   struct soc_camera_async_subdev *sasd;
> 
> Fix this by making "size" and the array, from which it is assigned unsigned.
> 
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Hi Hans. None of my 2 cross-compilers produce the above warning. Could you 
> verify, that this fixes the warning, that you've seen?

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

That fixes it. I've updated my cross-compilers to 4.8.1, it might be related to that.
For some reason the daily build always sees more warnings than I get when I compile
'normally'. I've never understood why, but since the warnings are valid, I'm not
complaining :-)

	Hans

> 
> Thanks
> Guennadi
> 
>  drivers/media/platform/soc_camera/soc_camera.c |    2 +-
>  include/media/sh_mobile_ceu.h                  |    2 +-
>  include/media/soc_camera.h                     |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 2e47b51..2dd0e52 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1459,7 +1459,7 @@ static int soc_camera_async_complete(struct v4l2_async_notifier *notifier)
>  }
>  
>  static int scan_async_group(struct soc_camera_host *ici,
> -			    struct v4l2_async_subdev **asd, int size)
> +			    struct v4l2_async_subdev **asd, unsigned int size)
>  {
>  	struct soc_camera_async_subdev *sasd;
>  	struct soc_camera_async_client *sasc;
> diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
> index 8937241..7f57056 100644
> --- a/include/media/sh_mobile_ceu.h
> +++ b/include/media/sh_mobile_ceu.h
> @@ -23,7 +23,7 @@ struct sh_mobile_ceu_info {
>  	int max_height;
>  	struct sh_mobile_ceu_companion *csi2;
>  	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
> -	int *asd_sizes;			/* 0-terminated array pf asd group sizes */
> +	unsigned int *asd_sizes;	/* 0-terminated array pf asd group sizes */
>  };
>  
>  #endif /* __ASM_SH_MOBILE_CEU_H__ */
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 906ed98..34d2414 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -87,7 +87,7 @@ struct soc_camera_host {
>  	const char *drv_name;
>  	struct soc_camera_host_ops *ops;
>  	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
> -	int *asd_sizes;			/* 0-terminated array of asd group sizes */
> +	unsigned int *asd_sizes;	/* 0-terminated array of asd group sizes */
>  };
>  
>  struct soc_camera_host_ops {
> 
