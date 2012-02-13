Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57726 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2BMOKV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Feb 2012 09:10:21 -0500
Date: Mon, 13 Feb 2012 15:10:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.hauer@pengutronix.de
Subject: Re: [PATCH 5/6] media: i.MX27 camera: fix compilation warning.
In-Reply-To: <1329141115-23133-6-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1202131508080.8277@axis700.grange>
References: <1329141115-23133-1-git-send-email-javier.martin@vista-silicon.com>
 <1329141115-23133-6-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Mon, 13 Feb 2012, Javier Martin wrote:

> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/mx2_camera.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index d9028f1..8ccdb4a 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1210,7 +1210,9 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
>  static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  		int bufnum, bool err)
>  {
> +#ifdef DEBUG
>  	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
> +#endif
>  	struct mx2_buffer *buf;
>  	struct vb2_buffer *vb;
>  	unsigned long phys;
> @@ -1232,18 +1234,16 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  		if (prp->cfg.channel == 1) {
>  			if (readl(pcdev->base_emma + PRP_DEST_RGB1_PTR +
>  				4 * bufnum) != phys) {
> -				dev_err(pcdev->dev, "%p != %p\n", phys,
> -						readl(pcdev->base_emma +
> -							PRP_DEST_RGB1_PTR +
> -							4 * bufnum));
> +				dev_err(pcdev->dev, "%p != %p\n", (void *)phys,
> +					(void *)readl(pcdev->base_emma +
> +					PRP_DEST_RGB1_PTR + 4 * bufnum));
>  			}
>  		} else {
>  			if (readl(pcdev->base_emma + PRP_DEST_Y_PTR -
>  				0x14 * bufnum) != phys) {
> -				dev_err(pcdev->dev, "%p != %p\n", phys,
> -						readl(pcdev->base_emma +
> -							PRP_DEST_Y_PTR -
> -							0x14 * bufnum));
> +				dev_err(pcdev->dev, "%p != %p\n", (void *)phys,
> +					(void *)readl(pcdev->base_emma +
> +					PRP_DEST_Y_PTR - 0x14 * bufnum));

I think, just using %lx would be better.

>  			}
>  		}
>  #endif
> -- 
> 1.7.0.4

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
