Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932090AbeDFO2M (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 10:28:12 -0400
Date: Fri, 6 Apr 2018 11:28:06 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] media: platform: fsl-viu: add __iomem annotations
Message-ID: <20180406112806.3b52e5d8@vento.lan>
In-Reply-To: <20180406142336.2079928-1-arnd@arndb.de>
References: <20180406142336.2079928-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  6 Apr 2018 16:23:18 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> This avoids countless sparse warnings like
> 
>    drivers/media/platform/fsl-viu.c:1081:25: sparse: incorrect type in argument 2 (different address spaces)
>    drivers/media/platform/fsl-viu.c:1082:25: sparse: incorrect type in argument 2 (different address spaces)

Heh, that's almost identical to this one:

	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=compile_test&id=457312e30430e83f9dc4bf1804acb15b91e5dfc1

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/fsl-viu.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
> index 200c47c69a75..cc85620267f1 100644
> --- a/drivers/media/platform/fsl-viu.c
> +++ b/drivers/media/platform/fsl-viu.c
> @@ -128,7 +128,7 @@ struct viu_dev {
>  	int			dma_done;
>  
>  	/* Hardware register area */
> -	struct viu_reg		*vr;
> +	struct viu_reg __iomem	*vr;
>  
>  	/* Interrupt vector */
>  	int			irq;
> @@ -244,7 +244,7 @@ struct viu_fmt *format_by_fourcc(int fourcc)
>  
>  void viu_start_dma(struct viu_dev *dev)
>  {
> -	struct viu_reg *vr = dev->vr;
> +	struct viu_reg __iomem *vr = dev->vr;
>  
>  	dev->field = 0;
>  
> @@ -255,7 +255,7 @@ void viu_start_dma(struct viu_dev *dev)
>  
>  void viu_stop_dma(struct viu_dev *dev)
>  {
> -	struct viu_reg *vr = dev->vr;
> +	struct viu_reg __iomem *vr = dev->vr;
>  	int cnt = 100;
>  	u32 status_cfg;
>  
> @@ -395,7 +395,7 @@ static void free_buffer(struct videobuf_queue *vq, struct viu_buf *buf)
>  
>  inline int buffer_activate(struct viu_dev *dev, struct viu_buf *buf)
>  {
> -	struct viu_reg *vr = dev->vr;
> +	struct viu_reg __iomem *vr = dev->vr;
>  	int bpp;
>  
>  	/* setup the DMA base address */
> @@ -703,9 +703,9 @@ static int verify_preview(struct viu_dev *dev, struct v4l2_window *win)
>  	return 0;
>  }
>  
> -inline void viu_activate_overlay(struct viu_reg *viu_reg)
> +inline void viu_activate_overlay(struct viu_reg __iomem *viu_reg)
>  {
> -	struct viu_reg *vr = viu_reg;
> +	struct viu_reg __iomem *vr = viu_reg;
>  
>  	out_be32(&vr->field_base_addr, reg_val.field_base_addr);
>  	out_be32(&vr->dma_inc, reg_val.dma_inc);
> @@ -985,9 +985,9 @@ inline void viu_activate_next_buf(struct viu_dev *dev,
>  	}
>  }
>  
> -inline void viu_default_settings(struct viu_reg *viu_reg)
> +inline void viu_default_settings(struct viu_reg __iomem *viu_reg)
>  {
> -	struct viu_reg *vr = viu_reg;
> +	struct viu_reg __iomem *vr = viu_reg;
>  
>  	out_be32(&vr->luminance, 0x9512A254);
>  	out_be32(&vr->chroma_r, 0x03310000);
> @@ -1001,7 +1001,7 @@ inline void viu_default_settings(struct viu_reg *viu_reg)
>  
>  static void viu_overlay_intr(struct viu_dev *dev, u32 status)
>  {
> -	struct viu_reg *vr = dev->vr;
> +	struct viu_reg __iomem *vr = dev->vr;
>  
>  	if (status & INT_DMA_END_STATUS)
>  		dev->dma_done = 1;
> @@ -1032,7 +1032,7 @@ static void viu_overlay_intr(struct viu_dev *dev, u32 status)
>  static void viu_capture_intr(struct viu_dev *dev, u32 status)
>  {
>  	struct viu_dmaqueue *vidq = &dev->vidq;
> -	struct viu_reg *vr = dev->vr;
> +	struct viu_reg __iomem *vr = dev->vr;
>  	struct viu_buf *buf;
>  	int field_num;
>  	int need_two;
> @@ -1104,7 +1104,7 @@ static void viu_capture_intr(struct viu_dev *dev, u32 status)
>  static irqreturn_t viu_intr(int irq, void *dev_id)
>  {
>  	struct viu_dev *dev  = (struct viu_dev *)dev_id;
> -	struct viu_reg *vr = dev->vr;
> +	struct viu_reg __iomem *vr = dev->vr;
>  	u32 status;
>  	u32 error;
>  
> @@ -1169,7 +1169,7 @@ static int viu_open(struct file *file)
>  	struct video_device *vdev = video_devdata(file);
>  	struct viu_dev *dev = video_get_drvdata(vdev);
>  	struct viu_fh *fh;
> -	struct viu_reg *vr;
> +	struct viu_reg __iomem *vr;
>  	int minor = vdev->minor;
>  	u32 status_cfg;
>  
> @@ -1305,7 +1305,7 @@ static int viu_release(struct file *file)
>  	return 0;
>  }
>  
> -void viu_reset(struct viu_reg *reg)
> +void viu_reset(struct viu_reg __iomem *reg)
>  {
>  	out_be32(&reg->status_cfg, 0);
>  	out_be32(&reg->luminance, 0x9512a254);



Thanks,
Mauro
