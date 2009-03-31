Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:34303 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758471AbZCaGjx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 02:39:53 -0400
Date: Tue, 31 Mar 2009 08:39:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: Add soc_camera_match function
In-Reply-To: <uzlf2uscy.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0903310839400.4806@axis700.grange>
References: <uzlf2uscy.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Mar 2009, Kuninori Morimoto wrote:

> 
> ${LINUX}/drivers/base/dd.c :: __device_attach
> use driver_match_device function.
> It needs bus->match function.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> ---
> 
> > Guennadi
> 
> I tried latest Linux 2.6.29 from Paul's git
>  git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git
> 
> Then, soc_camera doesn't works.
> please check 49b420a13ff95b449947181190b08367348e3e1b
> But I'm not sure is this patch correct fix ? 

Please, see http://marc.info/?t=123245859800006&r=1&w=2

Thanks
Guennadi

> 
>  drivers/media/video/soc_camera.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 6d8bfd4..a10828b 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -929,12 +929,21 @@ static int soc_camera_resume(struct device *dev)
>  	return ret;
>  }
>  
> +int soc_camera_match(struct device *dev, struct device_driver *drv)
> +{
> +	struct soc_camera_device *icd = to_soc_camera_dev(dev);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +
> +	return ici->nr == icd->iface;
> +}
> +
>  static struct bus_type soc_camera_bus_type = {
>  	.name		= "soc-camera",
>  	.probe		= soc_camera_probe,
>  	.remove		= soc_camera_remove,
>  	.suspend	= soc_camera_suspend,
>  	.resume		= soc_camera_resume,
> +	.match		= soc_camera_match,
>  };
>  
>  static struct device_driver ic_drv = {
> -- 
> 1.5.6.3
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
