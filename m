Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35346 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756283Ab2IJIyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 04:54:41 -0400
Subject: Re: [PATCH v3 03/16] media: coda: fix IRAM/AXI handling for i.MX53
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: linux-media@vger.kernel.org,
	Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
In-Reply-To: <20120910082026.GC9043@b20223-02.ap.freescale.net>
References: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
	 <1346400670-16002-4-git-send-email-p.zabel@pengutronix.de>
	 <20120910082026.GC9043@b20223-02.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Sep 2012 10:54:33 +0200
Message-ID: <1347267273.2577.20.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

thank you for your comments.

Am Montag, den 10.09.2012, 16:20 +0800 schrieb Richard Zhao:
> On Fri, Aug 31, 2012 at 10:10:57AM +0200, Philipp Zabel wrote:
> > This uses the ARCH_MXC specific iram_alloc API to allocate a work
> > buffer in the SoC's on-chip SRAM and sets up the AXI_SRAM_USE
> > register. In the future, the allocation will be converted to use
> > the genalloc API.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/Kconfig |    3 ++-
> >  drivers/media/platform/coda.c  |   51 ++++++++++++++++++++++++++++++++++++----
> >  drivers/media/platform/coda.h  |   21 +++++++++++++----
> >  3 files changed, 66 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index d4c034d..76f9a8f 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -130,9 +130,10 @@ if V4L_MEM2MEM_DRIVERS
> >  
> >  config VIDEO_CODA
> >  	tristate "Chips&Media Coda multi-standard codec IP"
> > -	depends on VIDEO_DEV && VIDEO_V4L2
> > +	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
> >  	select VIDEOBUF2_DMA_CONTIG
> >  	select V4L2_MEM2MEM_DEV
> > +	select IRAM_ALLOC if SOC_IMX53
> >  	---help---
> >  	   Coda is a range of video codec IPs that supports
> >  	   H.264, MPEG-4, and other video formats.
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index 8ec2ff4..5c06bc1 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -24,6 +24,7 @@
> >  #include <linux/videodev2.h>
> >  #include <linux/of.h>
> >  
> > +#include <mach/iram.h>
> >  #include <media/v4l2-ctrls.h>
> >  #include <media/v4l2-device.h>
> >  #include <media/v4l2-ioctl.h>
> > @@ -42,6 +43,7 @@
> >  #define CODA7_WORK_BUF_SIZE	(512 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
> >  #define CODA_PARA_BUF_SIZE	(10 * 1024)
> >  #define CODA_ISRAM_SIZE	(2048 * 2)
> > +#define CODA7_IRAM_SIZE		0x14000 /* 81920 bytes */
> >  
> >  #define CODA_OUTPUT_BUFS	4
> >  #define CODA_CAPTURE_BUFS	2
> > @@ -127,6 +129,8 @@ struct coda_dev {
> >  
> >  	struct coda_aux_buf	codebuf;
> >  	struct coda_aux_buf	workbuf;
> > +	long unsigned int	iram_vaddr;
> should be void __iomem * ?

I wrote this with the genalloc API in mind: gen_pool_alloc returns an
unsigned long. We are not accessing this memory from the CPU, so
iram_vaddr could just as well be an opaque token that only needs to be
remembered for gen_pool_free.
For the iram_alloc API in its current state, as you point out below,
keeping track of iram_vaddr is not needed.

> > +	long unsigned int	iram_paddr;
> >  
> >  	spinlock_t		irqlock;
> >  	struct mutex		dev_mutex;
> > @@ -710,6 +714,13 @@ static void coda_device_run(void *m2m_priv)
> >  	coda_write(dev, pic_stream_buffer_addr, CODA_CMD_ENC_PIC_BB_START);
> >  	coda_write(dev, pic_stream_buffer_size / 1024,
> >  		   CODA_CMD_ENC_PIC_BB_SIZE);
> > +
> > +	if (dev->devtype->product == CODA_7541) {
> > +		coda_write(dev, CODA7_USE_BIT_ENABLE | CODA7_USE_HOST_BIT_ENABLE |
> > +				CODA7_USE_ME_ENABLE | CODA7_USE_HOST_ME_ENABLE,
> > +				CODA7_REG_BIT_AXI_SRAM_USE);
> > +	}
> > +
> >  	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
> >  }
> >  
> > @@ -941,8 +952,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> >  			CODA7_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
> >  	}
> >  
> > -	/* Configure the coda */
> > -	coda_write(dev, 0xffff4c00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
> > +	if (dev->devtype->product == CODA_DX6) {
> > +		/* Configure the coda */
> > +		coda_write(dev, dev->iram_paddr, CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR);
> > +	}
> >  
> >  	/* Could set rotation here if needed */
> >  	switch (dev->devtype->product) {
> > @@ -1017,7 +1030,12 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> >  		value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
> >  		value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
> >  		value |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
> > -		coda_write(dev, value, CODA_CMD_ENC_SEQ_FMO);
> > +		if (dev->devtype->product == CODA_DX6) {
> > +			coda_write(dev, value, CODADX6_CMD_ENC_SEQ_FMO);
> > +		} else {
> > +			coda_write(dev, dev->iram_paddr, CODA7_CMD_ENC_SEQ_SEARCH_BASE);
> > +			coda_write(dev, 48 * 1024, CODA7_CMD_ENC_SEQ_SEARCH_SIZE);
> > +		}
> >  	}
> >  
> >  	if (coda_command_sync(ctx, CODA_COMMAND_SEQ_INIT)) {
> > @@ -1047,7 +1065,15 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> >  	}
> >  
> >  	coda_write(dev, src_vq->num_buffers, CODA_CMD_SET_FRAME_BUF_NUM);
> > -	coda_write(dev, q_data_src->width, CODA_CMD_SET_FRAME_BUF_STRIDE);
> > +	coda_write(dev, round_up(q_data_src->width, 8), CODA_CMD_SET_FRAME_BUF_STRIDE);
> > +	if (dev->devtype->product != CODA_DX6) {
> > +		coda_write(dev, round_up(q_data_src->width, 8), CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE);
> > +		coda_write(dev, dev->iram_paddr + 48 * 1024, CODA7_CMD_SET_FRAME_AXI_DBKY_ADDR);
> > +		coda_write(dev, dev->iram_paddr + 53 * 1024, CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR);
> > +		coda_write(dev, dev->iram_paddr + 58 * 1024, CODA7_CMD_SET_FRAME_AXI_BIT_ADDR);
> > +		coda_write(dev, dev->iram_paddr + 68 * 1024, CODA7_CMD_SET_FRAME_AXI_IPACDC_ADDR);
> > +		coda_write(dev, 0x0, CODA7_CMD_SET_FRAME_AXI_OVL_ADDR);
> > +	}
> >  	if (coda_command_sync(ctx, CODA_COMMAND_SET_FRAME_BUF)) {
> >  		v4l2_err(v4l2_dev, "CODA_COMMAND_SET_FRAME_BUF timeout\n");
> >  		return -ETIMEDOUT;
> > @@ -1580,6 +1606,10 @@ static int coda_hw_init(struct coda_dev *dev)
> >  		coda_write(dev, CODA7_STREAM_BUF_PIC_FLUSH, CODA_REG_BIT_STREAM_CTRL);
> >  	}
> >  	coda_write(dev, 0, CODA_REG_BIT_FRAME_MEM_CTRL);
> > +
> > +	if (dev->devtype->product != CODA_DX6)
> > +		coda_write(dev, 0, CODA7_REG_BIT_AXI_SRAM_USE);
> > +
> >  	coda_write(dev, CODA_INT_INTERRUPT_ENABLE,
> >  		      CODA_REG_BIT_INT_ENABLE);
> >  
> > @@ -1848,6 +1878,17 @@ static int __devinit coda_probe(struct platform_device *pdev)
> >  		return -ENOMEM;
> >  	}
> >  
> > +	if (dev->devtype->product == CODA_DX6) {
> > +		dev->iram_paddr = 0xffff4c00;
> > +	} else {
> > +		dev->iram_vaddr = iram_alloc(CODA7_IRAM_SIZE,
> > +					     &dev->iram_paddr);
> There will be no build warning if iram_vaddr is void __iomem *.

Ok, and I'll use a temporary variable for vaddr here.

> > +		if (!dev->iram_vaddr) {
> > +			dev_err(&pdev->dev, "unable to alloc iram\n");
> > +			return -ENOMEM;
> > +		}
> > +	}
> > +
> >  	platform_set_drvdata(pdev, dev);
> >  
> >  	return coda_firmware_request(dev);
> > @@ -1863,6 +1904,8 @@ static int coda_remove(struct platform_device *pdev)
> >  	if (dev->alloc_ctx)
> >  		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> >  	v4l2_device_unregister(&dev->v4l2_dev);
> > +	if (dev->iram_vaddr)
> > +		iram_free(dev->iram_vaddr, CODA7_IRAM_SIZE);
> It should be freed by paddr.

Yes. I had a patch to make iram_free take the vaddr, but Shawn suggested
to drop it and just go for genalloc support.
(see https://lkml.org/lkml/2012/9/7/281 for the last round of patches)

regards
Philipp


