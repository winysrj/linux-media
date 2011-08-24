Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:63663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1HXHTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 03:19:40 -0400
Date: Wed, 24 Aug 2011 09:19:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-arm-kernel@lists.infradead.org,
	Baruch Siach <baruch@tkos.co.il>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media i.MX27 camera: remove legacy dma support
In-Reply-To: <1314167073-11058-1-git-send-email-s.hauer@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1108240843001.8985@axis700.grange>
References: <1314167073-11058-1-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sure, if it's broken, let's remove it. But there are a couple of points, 
that we have to fix in this patch. Sorry, a stupid question: has this been 
tested on i.MX27?

On Wed, 24 Aug 2011, Sascha Hauer wrote:

> The i.MX27 dma support was introduced with the initial commit of
> this driver and originally created by me. However, I never got
> this stable due to the racy dma engine and used the EMMA engine
> instead. As the DMA support is most probably unused and broken in
> its current state, remove it. This also helps us to get rid of
> another user of the legacy i.MX DMA support,
> Also, remove the dependency on ARCH_MX* macros as these are scheduled
> for removal.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: linux-media@vger.kernel.org
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/video/Kconfig      |    2 +-
>  drivers/media/video/mx2_camera.c |  183 --------------------------------------
>  2 files changed, 1 insertions(+), 184 deletions(-)
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index f574dc0..27b41b8 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -941,7 +941,7 @@ config VIDEO_MX2_HOSTSUPPORT
>  
>  config VIDEO_MX2
>  	tristate "i.MX27/i.MX25 Camera Sensor Interface driver"
> -	depends on VIDEO_DEV && SOC_CAMERA && (MACH_MX27 || ARCH_MX25)
> +	depends on VIDEO_DEV && SOC_CAMERA && ARCH_MXC
>  	select VIDEOBUF_DMA_CONTIG
>  	select VIDEO_MX2_HOSTSUPPORT
>  	---help---
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index ec2410c..3b5c8eb 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -38,9 +38,6 @@
>  #include <linux/videodev2.h>
>  
>  #include <mach/mx2_cam.h>
> -#ifdef CONFIG_MACH_MX27
> -#include <mach/dma-mx1-mx2.h>
> -#endif
>  #include <mach/hardware.h>
>  
>  #include <asm/dma.h>
> @@ -330,41 +327,10 @@ static void mx2_camera_remove_device(struct soc_camera_device *icd)
>  	pcdev->icd = NULL;
>  }
>  
> -#ifdef CONFIG_MACH_MX27
> -static void mx27_camera_dma_enable(struct mx2_camera_dev *pcdev)
> -{
> -	u32 tmp;
> -
> -	imx_dma_enable(pcdev->dma);
> -
> -	tmp = readl(pcdev->base_csi + CSICR1);
> -	tmp |= CSICR1_RF_OR_INTEN;
> -	writel(tmp, pcdev->base_csi + CSICR1);
> -}
> -
> -static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
> -{
> -	struct mx2_camera_dev *pcdev = data;
> -	u32 status = readl(pcdev->base_csi + CSISR);
> -
> -	if (status & CSISR_SOF_INT && pcdev->active) {
> -		u32 tmp;
> -
> -		tmp = readl(pcdev->base_csi + CSICR1);
> -		writel(tmp | CSICR1_CLR_RXFIFO, pcdev->base_csi + CSICR1);
> -		mx27_camera_dma_enable(pcdev);
> -	}
> -
> -	writel(CSISR_SOF_INT | CSISR_RFF_OR_INT, pcdev->base_csi + CSISR);
> -
> -	return IRQ_HANDLED;
> -}
> -#else
>  static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
>  {
>  	return IRQ_NONE;
>  }

If this is really all, what's needed for i.MX27 ISR, let's remove it 
completely. But maybe you could explain to me, how it is now supposed to 
work on i.MX27. In probe() we have

	irq_handler_t mx2_cam_irq_handler = cpu_is_mx25() ? mx25_camera_irq
		: mx27_camera_irq;

	...

	err = request_irq(pcdev->irq_csi, mx2_cam_irq_handler, 0,
			MX2_CAM_DRV_NAME, pcdev);

So, after this patch i.MX27 will always have a dummy camera ISR and just 
use EMMA, right? Then maybe we have to make EMMA resource availability 
compulsory on those SoCs, and not optional, as now? You'll have to make 
emma the only possibility on i.MX27, then pcdev->use_emma will disappear, 
locations like

	if (mx27_camera_emma(pcdev)) {
		csicr1 |= CSICR1_PRP_IF_EN | CSICR1_FCC |
			CSICR1_RXFF_LEVEL(0);
	} else if (cpu_is_mx27())
		csicr1 |= CSICR1_SOF_INTEN | CSICR1_RXFF_LEVEL(2);

will need to be fixed.

> -#endif /* CONFIG_MACH_MX27 */
>  
>  static void mx25_camera_frame_done(struct mx2_camera_dev *pcdev, int fb,
>  		int state)
> @@ -547,25 +513,6 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
>  
>  	if (mx27_camera_emma(pcdev)) {
>  		goto out;

You can remove this goto now and instead

> -#ifdef CONFIG_MACH_MX27
> -	} else if (cpu_is_mx27()) {
> -		int ret;
> -
> -		if (pcdev->active == NULL) {
> -			ret = imx_dma_setup_single(pcdev->dma,
> -					videobuf_to_dma_contig(vb), vb->size,
> -					(u32)pcdev->base_dma + 0x10,
> -					DMA_MODE_READ);
> -			if (ret) {
> -				vb->state = VIDEOBUF_ERROR;
> -				wake_up(&vb->done);
> -				goto out;
> -			}
> -
> -			vb->state = VIDEOBUF_ACTIVE;
> -			pcdev->active = buf;
> -		}
> -#endif
>  	} else { /* cpu_is_mx25() */

make this to a real

	if (cpu_is_mx25()) {
		...

>  		u32 csicr3, dma_inten = 0;
>  
> @@ -1037,117 +984,6 @@ static int mx2_camera_reqbufs(struct soc_camera_device *icd,
>  	return 0;
>  }
>  
> -#ifdef CONFIG_MACH_MX27
> -static void mx27_camera_frame_done(struct mx2_camera_dev *pcdev, int state)
> -{
> -	struct videobuf_buffer *vb;
> -	struct mx2_buffer *buf;
> -	unsigned long flags;
> -	int ret;
> -
> -	spin_lock_irqsave(&pcdev->lock, flags);
> -
> -	if (!pcdev->active) {
> -		dev_err(pcdev->dev, "%s called with no active buffer!\n",
> -				__func__);
> -		goto out;
> -	}
> -
> -	vb = &pcdev->active->vb;
> -	buf = container_of(vb, struct mx2_buffer, vb);
> -	WARN_ON(list_empty(&vb->queue));
> -	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> -		vb, vb->baddr, vb->bsize);
> -
> -	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
> -	list_del_init(&vb->queue);
> -	vb->state = state;
> -	do_gettimeofday(&vb->ts);
> -	vb->field_count++;
> -
> -	wake_up(&vb->done);
> -
> -	if (list_empty(&pcdev->capture)) {
> -		pcdev->active = NULL;
> -		goto out;
> -	}
> -
> -	pcdev->active = list_entry(pcdev->capture.next,
> -			struct mx2_buffer, vb.queue);
> -
> -	vb = &pcdev->active->vb;
> -	vb->state = VIDEOBUF_ACTIVE;
> -
> -	ret = imx_dma_setup_single(pcdev->dma, videobuf_to_dma_contig(vb),
> -			vb->size, (u32)pcdev->base_dma + 0x10, DMA_MODE_READ);
> -
> -	if (ret) {
> -		vb->state = VIDEOBUF_ERROR;
> -		pcdev->active = NULL;
> -		wake_up(&vb->done);
> -	}
> -
> -out:
> -	spin_unlock_irqrestore(&pcdev->lock, flags);
> -}
> -
> -static void mx27_camera_dma_err_callback(int channel, void *data, int err)
> -{
> -	struct mx2_camera_dev *pcdev = data;
> -
> -	mx27_camera_frame_done(pcdev, VIDEOBUF_ERROR);
> -}
> -
> -static void mx27_camera_dma_callback(int channel, void *data)
> -{
> -	struct mx2_camera_dev *pcdev = data;
> -
> -	mx27_camera_frame_done(pcdev, VIDEOBUF_DONE);
> -}
> -
> -#define DMA_REQ_CSI_RX          31 /* FIXME: Add this to a resource */
> -
> -static int __devinit mx27_camera_dma_init(struct platform_device *pdev,
> -		struct mx2_camera_dev *pcdev)
> -{
> -	int err;
> -
> -	pcdev->dma = imx_dma_request_by_prio("CSI RX DMA", DMA_PRIO_HIGH);
> -	if (pcdev->dma < 0) {
> -		dev_err(&pdev->dev, "%s failed to request DMA channel\n",
> -				__func__);
> -		return pcdev->dma;
> -	}
> -
> -	err = imx_dma_setup_handlers(pcdev->dma, mx27_camera_dma_callback,
> -					mx27_camera_dma_err_callback, pcdev);
> -	if (err) {
> -		dev_err(&pdev->dev, "%s failed to set DMA callback\n",
> -				__func__);
> -		goto err_out;
> -	}
> -
> -	err = imx_dma_config_channel(pcdev->dma,
> -			IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_FIFO,
> -			IMX_DMA_MEMSIZE_32 | IMX_DMA_TYPE_LINEAR,
> -			DMA_REQ_CSI_RX, 1);
> -	if (err) {
> -		dev_err(&pdev->dev, "%s failed to config DMA channel\n",
> -				__func__);
> -		goto err_out;
> -	}
> -
> -	imx_dma_config_burstlen(pcdev->dma, 64);
> -
> -	return 0;
> -
> -err_out:
> -	imx_dma_free(pcdev->dma);
> -
> -	return err;
> -}
> -#endif /* CONFIG_MACH_MX27 */
> -
>  static unsigned int mx2_camera_poll(struct file *file, poll_table *pt)
>  {
>  	struct soc_camera_device *icd = file->private_data;
> @@ -1352,15 +1188,6 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  	dev_dbg(&pdev->dev, "Camera clock frequency: %ld\n",
>  			clk_get_rate(pcdev->clk_csi));
>  
> -	/* Initialize DMA */
> -#ifdef CONFIG_MACH_MX27
> -	if (cpu_is_mx27()) {
> -		err = mx27_camera_dma_init(pdev, pcdev);
> -		if (err)
> -			goto exit_clk_put;
> -	}
> -#endif /* CONFIG_MACH_MX27 */
> -
>  	pcdev->res_csi = res_csi;
>  	pcdev->pdata = pdev->dev.platform_data;
>  	if (pcdev->pdata) {
> @@ -1452,12 +1279,6 @@ exit_iounmap:
>  exit_release:
>  	release_mem_region(res_csi->start, resource_size(res_csi));
>  exit_dma_free:
> -#ifdef CONFIG_MACH_MX27
> -	if (cpu_is_mx27())
> -		imx_dma_free(pcdev->dma);
> -exit_clk_put:
> -	clk_put(pcdev->clk_csi);
> -#endif /* CONFIG_MACH_MX27 */

This has been wrong before too, "#endif" should have been one line higher. 
Now you have to rename labels: exit_dma_free makes no more sense.

You might want to search through the driver for mx2[57], MX2[57], emma, 
EMMA.

Also, please, base your patch on 
git://linuxtv.org/gliakhovetski/v4l-dvb.git mbus-config
This should be quite easy, changes to mx2-camera are minimal, if any.

Baruch, any comment?

Thanks
Guennadi

>  exit_kfree:
>  	kfree(pcdev);
>  exit:
> @@ -1472,10 +1293,6 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
>  	struct resource *res;
>  
>  	clk_put(pcdev->clk_csi);
> -#ifdef CONFIG_MACH_MX27
> -	if (cpu_is_mx27())
> -		imx_dma_free(pcdev->dma);
> -#endif /* CONFIG_MACH_MX27 */
>  	free_irq(pcdev->irq_csi, pcdev);
>  	if (mx27_camera_emma(pcdev))
>  		free_irq(pcdev->irq_emma, pcdev);
> -- 
> 1.7.5.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
