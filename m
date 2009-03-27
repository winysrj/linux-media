Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61430 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbZC0PUb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2009 11:20:31 -0400
Received: by bwz17 with SMTP id 17so1046149bwz.37
        for <linux-media@vger.kernel.org>; Fri, 27 Mar 2009 08:20:27 -0700 (PDT)
Message-ID: <49CCEE3A.8000502@gmail.com>
Date: Fri, 27 Mar 2009 17:18:18 +0200
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
References: <49C89F00.1020402@gmail.com> <Pine.LNX.4.64.0903261405520.5438@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903261405520.5438@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>> +/*
>> + *  Videobuf operations
>> + */
>> +static int imx_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
>> +			      unsigned int *size)
>> +{
>> +	struct soc_camera_device *icd = vq->priv_data;
>> +
>> +	*size = icd->width * icd->height *
>> +		((icd->current_fmt->depth + 7) >> 3);
>> +
>> +	if (0 == *count)
>> +		*count = 32;
> 
> Doesn't look like a good idea to me. You don't restrict picture sizes in 
> your try_fmt / set_fmt and here you default to 32 buffers...

I'm not sure about this one. Should I leave this unchanged?


>> +	struct imx_camera_dev *pcdev = ici->priv;
>> +	struct imx_buffer *buf = container_of(vb, struct imx_buffer, vb);
>> +	unsigned long flags;
>> +
>> +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>> +		vb, vb->baddr, vb->bsize);
>> +	spin_lock_irqsave(&pcdev->lock, flags);
> 
> You use an FIQ for SoF, and spin_lock_irqsave() to protect. Don't they 
> only disable IRQs and not FIQs? But it seems your FIQ cannot cause any 
> trouble, so, it should be fine. Do you really need an FIQ?

yes, FIQ is necessary. Because IRQ is to slow. When SoF is detected, DMA must be activated immediately, but not to early.
Whe tried to use IRQ, and many starts of frames were missed.
May I remove these spin_lock_irqsave's?

> 
>> +
>> +	list_add_tail(&vb->queue, &pcdev->capture);
>> +
>> +	vb->state = VIDEOBUF_ACTIVE;
>> +
>> +	if (!pcdev->active) {
>> +		pcdev->active = buf;
>> +
>> +		/* setup sg list for future DMA */
>> +		if (!imx_camera_setup_dma(pcdev)) {
>> +			unsigned int temp;
>> +			/* enable SOF irq */
>> +			temp = __raw_readl(pcdev->base + CSICR1) |
>> +						  CSICR1_SOF_INTEN;
> 
> Hm, looks like an error in the datasheet:
> 
> SOF_INTEN	Start Of Frame Interrupt--SOF interrupt status bit; set Read:
> Bit 16		when interrupt occurs.                                  0 = No interrupt
> 		                                                        1 = SOF interrupt occurred
> 		                                                        Write:
> 		                                                        0 = No action
> 		                                                        1 = Clears bit
> 
> This is not a status bit, but a control "SoF interrupt enable" bit, right?

Yes, probably it's only 'small' error in datasheet :)


>> +static void imx_camera_dma_irq(int channel, void *data)
>> +{
>> +	struct imx_camera_dev *pcdev = data;
>> +	struct imx_buffer *buf;
>> +	unsigned long flags;
>> +	struct videobuf_buffer *vb;
>> +
>> +	spin_lock_irqsave(&pcdev->lock, flags);
>> +
>> +	imx_dma_disable(channel);
>> +
>> +	if (unlikely(!pcdev->active)) {
>> +		dev_err(pcdev->dev, "DMA End IRQ with no active buffer\n");
>> +		goto out;
>> +	}
>> +
>> +	vb = &pcdev->active->vb;
>> +	buf = container_of(vb, struct imx_buffer, vb);
>> +	WARN_ON(buf->inwork || list_empty(&vb->queue));
>> +	dev_dbg(pcdev->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>> +		vb, vb->baddr, vb->bsize);
>> +
>> +	imx_camera_wakeup(pcdev, vb, buf);
> 
> AFAIU, your flow looks as follows:
> 
> 1. configure DMA, enable Start of Frame FIQ
> 2. <SoF FIQ> enable DMA, DMA IRQ, disable SoF FIQ
> 3. <DMA done IRQ> disable DMA, report completed buffer, goto 1

is it ok?


>> +static int imx_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
>> +{
>> +	struct soc_camera_host *ici =
>> +		to_soc_camera_host(icd->dev.parent);
>> +	struct imx_camera_dev *pcdev = ici->priv;
>> +	unsigned long camera_flags, common_flags;
>> +	unsigned int csicr1;
>> +	int ret;
>> +
>> +	camera_flags = icd->ops->query_bus_param(icd);
>> +
>> +	common_flags = soc_camera_bus_param_compatible(camera_flags,
>> +						       CSI_BUS_FLAGS);
>> +	if (!common_flags)
>> +		return -EINVAL;
>> +
>> +	if (!(common_flags & SOCAM_DATAWIDTH_8)) {
> 
> I don't understand this. In your CSI_BUS_FLAGS you only support 8 bits. If 
> the camera doesn't support it, you get a 0 back in common_flags and return 
> -EINVAL above. So, this test seems redundant.

yes, this is uneeded. I removed this already.


>> +static struct soc_camera_host_ops imx_soc_camera_host_ops = {
>> +	.owner		= THIS_MODULE,
>> +	.add		= imx_camera_add_device,
>> +	.remove		= imx_camera_remove_device,
>> +	.set_fmt	= imx_camera_set_fmt,
>> +	.try_fmt	= imx_camera_try_fmt,
>> +	.init_videobuf	= imx_camera_init_videobuf,
>> +	.reqbufs	= imx_camera_reqbufs,
>> +	.poll		= imx_camera_poll,
>> +	.querycap	= imx_camera_querycap,
>> +	.set_bus_param	= imx_camera_set_bus_param,
> 
> You are not implementing this against a current v4l tree. Please, rebase 
> onto, e.g., linux-next. You will have to at least implement a .set_crop 
> method too.

could you please explain shortly what exactly should be implemented in .set_crop and .get_formats
methods?


>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (!res || !irq) {
>> +		err = -ENODEV;
>> +		goto exit;
>> +	}
>> +
>> +	clk = clk_get(&pdev->dev, "csi_clk");
> 
> I think, the preferred method to get a clock now is to use NULL for its 
> name, as long as there's only one clock attached to this device. However, 
> it looks like mx1 doesn't implement clkdev yet, am I right?

in case mx1 doesn't implement clkdev yet, I will leave clock name there, ok?
We could remove it in the future.


> 
> Any reason to not be using .suspend and .resume from struct 
> soc_camera_host_ops?

no reason, moved already.
But I don't know is there anything to do in suspend and resume functions?
Methods .reset and .power are removed from pdata.


>> +module_param(mclk, int, 0);
>> +MODULE_PARM_DESC(mclk, "MCLK value in Hz");
> 
> Hm, do you really think anyone needs mclk as a parameter?

We needed it before, but not anymore since yet.
Micron and Omnivision sensors usually need different MCLK.
During development time it was not very convenient to re-build kernel with different MCLK's in pdata.
Therefore Paulius added this module param.

Darius A.

