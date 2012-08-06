Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1171 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2HFImP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Aug 2012 04:42:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH 3/3 v2] [media] sta2x11_vip: convert to videobuf2 and control framework
Date: Mon, 6 Aug 2012 10:42:03 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
References: <1343765829-6006-4-git-send-email-federico.vaga@gmail.com> <1344241059-15271-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1344241059-15271-1-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208061042.03658.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon August 6 2012 10:17:39 Federico Vaga wrote:
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> 
> ---
>  drivers/media/video/sta2x11_vip.c | 1239 +++++++++++++------------------------
>  1 file modificato, 414 inserzioni(+), 825 rimozioni(-)
> 
> diff --git a/drivers/media/video/sta2x11_vip.c b/drivers/media/video/sta2x11_vip.c
> index 4c10205..ffd9f0a 100644
> --- a/drivers/media/video/sta2x11_vip.c
> +++ b/drivers/media/video/sta2x11_vip.c
> @@ -1186,25 +798,6 @@ static void vip_gpio_release(struct device *dev, int pin, const char *name)
>  	}
>  }
>  
> -/**
> - * sta2x11_vip_init_one - init one instance of video device
> - * @pdev: PCI device
> - * @ent: (not used)
> - *
> - * allocate reset pins for DAC.
> - * Reset video DAC, this is done via reset line.
> - * allocate memory for managing device
> - * request interrupt
> - * map IO region
> - * register device
> - * find and initialize video DAC
> - *
> - * return value: 0, no error
> - *
> - * -ENOMEM, no memory
> - *
> - * -ENODEV, device could not be detected or registered
> - */
>  static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
>  					  const struct pci_device_id *ent)
>  {
> @@ -1212,10 +805,17 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
>  	struct sta2x11_vip *vip;
>  	struct vip_config *config;
>  
> +	/* Check if hardware support 26-bit DMA */
> +	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(26))) {
> +		dev_err(&pdev->dev, "26-bit DMA addressing not available\n");
> +		return -EINVAL;
> +	}
> +	/* Enable PCI */
>  	ret = pci_enable_device(pdev);
>  	if (ret)
>  		return ret;
>  
> +	/* Get VIP platform data */
>  	config = dev_get_platdata(&pdev->dev);
>  	if (!config) {
>  		dev_info(&pdev->dev, "VIP slot disabled\n");
> @@ -1223,6 +823,7 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
>  		goto disable;
>  	}
>  
> +	/* Power configuration */
>  	ret = vip_gpio_reserve(&pdev->dev, config->pwr_pin, 0,
>  			       config->pwr_name);
>  	if (ret)
> @@ -1237,7 +838,6 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
>  			goto disable;
>  		}
>  	}
> -
>  	if (config->pwr_pin != -1) {
>  		/* Datasheet says 5ms between PWR and RST */
>  		usleep_range(5000, 25000);
> @@ -1251,17 +851,20 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
>  	}
>  	usleep_range(5000, 25000);
>  
> +	/* Allocate a new VIP instance */
>  	vip = kzalloc(sizeof(struct sta2x11_vip), GFP_KERNEL);
>  	if (!vip) {
>  		ret = -ENOMEM;
>  		goto release_gpios;
>  	}
> -
>  	vip->pdev = pdev;
>  	vip->std = V4L2_STD_PAL;
>  	vip->format = formats_50[0];
>  	vip->config = config;
>  
> +	ret = sta2x11_vip_init_controls(vip);
> +	if (ret)
> +		goto free_mem;
>  	if (v4l2_device_register(&pdev->dev, &vip->v4l2_dev))
>  		goto free_mem;
>  
> @@ -1271,46 +874,52 @@ static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
>  
>  	pci_set_master(pdev);
>  
> -	ret = pci_request_regions(pdev, DRV_NAME);
> +	ret = pci_request_regions(pdev, KBUILD_MODNAME);
>  	if (ret)
>  		goto unreg;
>  
>  	vip->iomem = pci_iomap(pdev, 0, 0x100);
>  	if (!vip->iomem) {
> -		ret = -ENOMEM; /* FIXME */
> +		ret = -ENOMEM;
>  		goto release;
>  	}
>  
>  	pci_enable_msi(pdev);
>  
> -	INIT_LIST_HEAD(&vip->capture);
> +	/* Initialize buffer */
> +	ret = sta2x11_vip_init_buffer(vip);
> +	if (ret)
> +		goto unmap;
> +
>  	spin_lock_init(&vip->slock);
> -	mutex_init(&vip->mutex);
> -	vip->started = 0;
> -	vip->disabled = 0;
>  
>  	ret = request_irq(pdev->irq,
>  			  (irq_handler_t) vip_irq,
> -			  IRQF_SHARED, DRV_NAME, vip);
> +			  IRQF_SHARED, KBUILD_MODNAME, vip);
>  	if (ret) {
>  		dev_err(&pdev->dev, "request_irq failed\n");
>  		ret = -ENODEV;
> -		goto unmap;
> +		goto release_buf;
>  	}
>  
> +	/* Alloc, initialize and register video device */
>  	vip->video_dev = video_device_alloc();
>  	if (!vip->video_dev) {
>  		ret = -ENOMEM;
>  		goto release_irq;
>  	}
>  
> -	*(vip->video_dev) = video_dev_template;
> +	vip->video_dev = &video_dev_template;
> +	vip->video_dev->v4l2_dev = &vip->v4l2_dev;
> +	vip->video_dev->queue = &vip->vb_vidq;
> +	vip->video_dev->flags |= V4L2_FL_USES_V4L2_FH | V4L2_FL_USE_FH_PRIO;

Been there, done that :-)

V4L2_FL_USE_FH_PRIO is a bit number, not a bit mask. Use set_bit instead:

	set_bit(V4L2_FL_USE_FH_PRIO, &vip->video_dev->flags);

No need to set V4L2_FL_USES_V4L2_FH, BTW. That will be set automatically as soon
as v4l2_fh_open is called.

Regards,

	Hans
