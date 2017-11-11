Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:53698 "EHLO mail.mleia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750770AbdKKONF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 09:13:05 -0500
From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH v4 3/5] staging: Introduce NVIDIA Tegra video decoder
 driver
To: Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Vladimir Zapolskiy <vz@mleia.com>
References: <cover.1508448293.git.digetx@gmail.com>
 <1a3798f337c0097e67d70226ae3ba665fd9156c2.1508448293.git.digetx@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <2c2910bc-40d4-b4ac-cdbe-b3c670a91f1b@mleia.com>
Date: Sat, 11 Nov 2017 16:06:52 +0200
MIME-Version: 1.0
In-Reply-To: <1a3798f337c0097e67d70226ae3ba665fd9156c2.1508448293.git.digetx@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitry,

I'll add just a couple of minor comments, in general the code looks
very good.

On 10/20/2017 12:34 AM, Dmitry Osipenko wrote:
> NVIDIA Tegra20/30/114/124/132 SoC's have video decoder engine that
> supports standard set of video formats like H.264 / MPEG-4 / WMV / VC1.
> Currently implemented decoding of CAVLC H.264 on Tegra20 only.
> 
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>

[snip]

> +++ b/drivers/staging/tegra-vde/uapi.h
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright (C) 2016-2017 Dmitry Osipenko <digetx@gmail.com>
> + * All Rights Reserved.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice (including the next
> + * paragraph) shall be included in all copies or substantial portions of the
> + * Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * VA LINUX SYSTEMS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + * OTHER DEALINGS IN THE SOFTWARE.

>From the specified MODULE_LICENSE("GPL") I'd rather expect to see a reference
to GPLv2+ license in the header, and here the text resembles MIT license only.

I understand that it is a UAPI header file and it may happen that different
rules are applied to this kind of sources, hopefully Greg can give the right
directions.

In general you may avoid the headache with the custom UAPI, if you reuse
V4L2 interfaces, if I remember correctly drivers/media/platform/coda does it.
Also from my point of view the custom UAPI is the only reason why the driver
is pushed to the staging folder.

[snip]

> +struct tegra_vde {
> +	void __iomem *sxe;
> +	void __iomem *bsev;
> +	void __iomem *mbe;
> +	void __iomem *ppe;
> +	void __iomem *mce;
> +	void __iomem *tfe;
> +	void __iomem *ppb;
> +	void __iomem *vdma;
> +	void __iomem *frameid;

Please find a comment in tegra_vde_probe() function regarding
devm_ioremap_resource() calls.

> +	struct mutex lock;
> +	struct miscdevice miscdev;
> +	struct reset_control *rst;
> +	struct gen_pool *iram_pool;
> +	struct completion decode_completion;
> +	struct clk *clk;
> +	dma_addr_t iram_lists_addr;
> +	u32 *iram;
> +};

[snip]

> +static int tegra_vde_wait_bsev(struct tegra_vde *vde, bool wait_dma)
> +{
> +	struct device *dev = vde->miscdev.parent;
> +	u32 value;
> +	int err;
> +
> +	err = readl_relaxed_poll_timeout(vde->bsev + INTR_STATUS, value,
> +					 !(value & BIT(2)), 1, 100);
> +	if (err) {
> +		dev_err(dev, "BSEV unknown bit timeout\n");
> +		return err;
> +	}
> +
> +	err = readl_relaxed_poll_timeout(vde->bsev + INTR_STATUS, value,
> +					 (value & BSE_ICMDQUE_EMPTY), 1, 100);
> +	if (err) {
> +		dev_err(dev, "BSEV ICMDQUE flush timeout\n");
> +		return err;
> +	}
> +
> +	if (!wait_dma)
> +		return 0;
> +
> +	err = readl_relaxed_poll_timeout(vde->bsev + INTR_STATUS, value,
> +					 !(value & BSE_DMA_BUSY), 1, 100);
> +	if (err) {
> +		dev_err(dev, "BSEV DMA timeout\n");
> +		return err;
> +	}
> +
> +	return 0;

	if (err)
		dev_err(dev, "BSEV DMA timeout\n");

	return err;

is two lines shorter.

> +}
> +

[snip]

> +static int tegra_vde_attach_dmabufs_to_frame(struct device *dev,
> +					struct video_frame *frame,
> +					struct tegra_vde_h264_frame *source,
> +					enum dma_data_direction dma_dir,
> +					bool baseline_profile,
> +					size_t csize)
> +{
> +	int err;
> +
> +	err = tegra_vde_attach_dmabuf(dev, source->y_fd,
> +				      source->y_offset, csize * 4,
> +				      &frame->y_dmabuf_attachment,
> +				      &frame->y_addr,
> +				      &frame->y_sgt,
> +				      NULL, dma_dir);
> +	if (err)
> +		return err;
> +
> +	err = tegra_vde_attach_dmabuf(dev, source->cb_fd,
> +				      source->cb_offset, csize,
> +				      &frame->cb_dmabuf_attachment,
> +				      &frame->cb_addr,
> +				      &frame->cb_sgt,
> +				      NULL, dma_dir);
> +	if (err)
> +		goto err_release_y;
> +
> +	err = tegra_vde_attach_dmabuf(dev, source->cr_fd,
> +				      source->cr_offset, csize,
> +				      &frame->cr_dmabuf_attachment,
> +				      &frame->cr_addr,
> +				      &frame->cr_sgt,
> +				      NULL, dma_dir);
> +	if (err)
> +		goto err_release_cb;
> +
> +	if (baseline_profile) {
> +		frame->aux_addr = 0xF4DEAD00;
> +	} else {

I would rather suggest to do

	if (baseline_profile) {
		frame->aux_addr = 0xF4DEAD00;
		return 0;
	}

and remove indentation from the code block below.

> +		err = tegra_vde_attach_dmabuf(dev, source->aux_fd,
> +					      source->aux_offset, csize,
> +					      &frame->aux_dmabuf_attachment,
> +					      &frame->aux_addr,
> +					      &frame->aux_sgt,
> +					      NULL, dma_dir);
> +		if (err)
> +			goto err_release_cr;
> +	}
> +
> +	return 0;

	if (!err)
		return 0;

and then remove a check above.

> +
> +err_release_cr:
> +	tegra_vde_detach_and_put_dmabuf(frame->cr_dmabuf_attachment,
> +					frame->cr_sgt, dma_dir);
> +err_release_cb:
> +	tegra_vde_detach_and_put_dmabuf(frame->cb_dmabuf_attachment,
> +					frame->cb_sgt, dma_dir);
> +err_release_y:
> +	tegra_vde_detach_and_put_dmabuf(frame->y_dmabuf_attachment,
> +					frame->y_sgt, dma_dir);
> +
> +	return err;
> +}

[snip]

> +static int tegra_vde_ioctl_decode_h264(struct tegra_vde *vde,
> +				       unsigned long vaddr)
> +{
> +	struct device *dev = vde->miscdev.parent;
> +	struct tegra_vde_h264_decoder_ctx ctx;
> +	struct tegra_vde_h264_frame __user *frames_user;
> +	struct tegra_vde_h264_frame *frames;
> +	struct video_frame *dpb_frames;
> +	struct dma_buf_attachment *bitstream_data_dmabuf_attachment;
> +	struct sg_table *bitstream_sgt;
> +	enum dma_data_direction dma_dir;
> +	dma_addr_t bitstream_data_addr;
> +	dma_addr_t bsev_ptr;
> +	size_t bitstream_data_size;
> +	unsigned int macroblocks_nb;
> +	unsigned int read_bytes;
> +	unsigned int i = 0;
> +	bool timeout;
> +	int ret;
> +
> +	if (copy_from_user(&ctx, (void __user *)vaddr, sizeof(ctx)))
> +		return -EFAULT;
> +
> +	ret = tegra_vde_validate_h264_ctx(dev, &ctx);
> +	if (ret)
> +		return -EINVAL;

Or "return ret".

> +
> +	ret = tegra_vde_attach_dmabuf(dev, ctx.bitstream_data_fd,
> +				      ctx.bitstream_data_offset, 0,
> +				      &bitstream_data_dmabuf_attachment,
> +				      &bitstream_data_addr,
> +				      &bitstream_sgt,
> +				      &bitstream_data_size,
> +				      DMA_TO_DEVICE);
> +	if (ret)
> +		return ret;
> +
> +	dpb_frames = kcalloc(ctx.dpb_frames_nb, sizeof(*dpb_frames),
> +			     GFP_KERNEL);
> +	if (!dpb_frames) {
> +		ret = -ENOMEM;
> +		goto err_release_bitstream_dmabuf;
> +	}
> +
> +	macroblocks_nb = ctx.pic_width_in_mbs * ctx.pic_height_in_mbs;
> +	frames_user = u64_to_user_ptr(ctx.dpb_frames_ptr);
> +
> +	frames = kmalloc_array(ctx.dpb_frames_nb, sizeof(*frames), GFP_KERNEL);
> +	if (!frames) {
> +		ret = -ENOMEM;
> +		goto err_release_dpb_frames;
> +	}
> +
> +	if (copy_from_user(frames, frames_user,
> +			   ctx.dpb_frames_nb * sizeof(*frames))) {
> +		ret = -EFAULT;
> +		goto free_frames;

It could be

	ret = -EFAULT;
	kfree(frames);
	goto err_release_dpb_frames;

> +	}
> +
> +	for (i = 0; i < ctx.dpb_frames_nb; i++) {
> +		ret = tegra_vde_validate_frame(dev, &frames[i]);
> +		if (ret)
> +			goto free_frames;

It could be

	if (ret)
		break;

or
	if (ret) {
		kfree(frames);
		goto err_release_dpb_frames;
	}

> +
> +		dpb_frames[i].flags = frames[i].flags;
> +		dpb_frames[i].frame_num = frames[i].frame_num;
> +
> +		dma_dir = (i == 0) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +
> +		ret = tegra_vde_attach_dmabufs_to_frame(dev, &dpb_frames[i],
> +							&frames[i], dma_dir,
> +							ctx.baseline_profile,
> +							macroblocks_nb * 64);
> +		if (ret)
> +			goto free_frames;

It could be

	if (ret)
		break;

or

	if (ret) {
		kfree(frames);
		goto err_release_dpb_frames;
	}

I don't strictly ask for the changes, but in my opinion less indentation
is better.

> +	}
> +
> +free_frames:
> +	kfree(frames);
> +
> +	if (ret)
> +		goto err_release_dpb_frames;

If you select an option with 'kfree' in all three cases above, then
it is possible to remove 'kfree' here, remove the check and remove
a goto label.

It's up to you to decide, which version is better.

[snip]

> +
> +static int tegra_vde_runtime_resume(struct device *dev)
> +{
> +	struct tegra_vde *vde = dev_get_drvdata(dev);
> +	int err;
> +
> +	err = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_VDEC,
> +						vde->clk, vde->rst);
> +	if (err) {
> +		dev_err(dev, "Failed to power up HW : %d\n", err);
> +		return err;
> +	}
> +
> +	return 0;

	if (err)
		dev_err(dev, "Failed to power up HW : %d\n", err);

	return err;

saves 2 lines of code.

> +}
> +
> +static int tegra_vde_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *regs;
> +	struct tegra_vde *vde;
> +	int irq, err;
> +
> +	vde = devm_kzalloc(dev, sizeof(*vde), GFP_KERNEL);
> +	if (!vde)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, vde);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "sxe");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->sxe = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->sxe))
> +		return PTR_ERR(vde->sxe);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "bsev");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->bsev = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->bsev))
> +		return PTR_ERR(vde->bsev);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mbe");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->mbe = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->mbe))
> +		return PTR_ERR(vde->mbe);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ppe");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->ppe = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->ppe))
> +		return PTR_ERR(vde->ppe);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mce");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->mce = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->mce))
> +		return PTR_ERR(vde->mce);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "tfe");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->tfe = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->tfe))
> +		return PTR_ERR(vde->tfe);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ppb");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->ppb = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->ppb))
> +		return PTR_ERR(vde->ppb);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vdma");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->vdma = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->vdma))
> +		return PTR_ERR(vde->vdma);
> +
> +	regs = platform_get_resource_byname(pdev, IORESOURCE_MEM, "frameid");
> +	if (!regs)
> +		return -ENODEV;
> +
> +	vde->frameid = devm_ioremap_resource(dev, regs);
> +	if (IS_ERR(vde->frameid))
> +		return PTR_ERR(vde->frameid);

This is just my personal opinion on which I do not insist, however I'd like
to share it, a single memory region described in DTB (and the same single
region mapped once) and subregion offsets in the driver may be more preferable.

If I remember correctly that was found in the previous versions of the driver,
the new scheme might be preferred only if the offsets are different in different
Tegra VDE IPs, but even in the latter case it might be better to handle the
difference inside the driver.

> +
> +	vde->clk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(vde->clk)) {
> +		err = PTR_ERR(vde->clk);
> +		dev_err(dev, "Could not get VDE clk %d\n", err);
> +		return err;
> +	}
> +
> +	vde->rst = devm_reset_control_get(dev, NULL);
> +	if (IS_ERR(vde->rst)) {
> +		err = PTR_ERR(vde->rst);
> +		dev_err(dev, "Could not get VDE reset %d\n", err);
> +		return err;
> +	}
> +
> +	irq = platform_get_irq_byname(pdev, "sync-token");
> +	if (irq < 0)
> +		return irq;
> +
> +	err = devm_request_irq(dev, irq, tegra_vde_isr, 0,
> +			       dev_name(dev), vde);
> +	if (err) {
> +		dev_err(dev, "Could not request IRQ %d\n", err);
> +		return err;
> +	}
> +
> +	vde->iram_pool = of_gen_pool_get(dev->of_node, "iram", 0);
> +	if (!vde->iram_pool) {
> +		dev_err(dev, "Could not get IRAM pool\n");
> +		return -EPROBE_DEFER;
> +	}
> +
> +	vde->iram = gen_pool_dma_alloc(vde->iram_pool, 0x3FC00,

The size of the pool should not be hardcoded, it is expected to be
obtained from the device tree:

	gen_pool_size(vde->iram_pool)

> +				       &vde->iram_lists_addr);
> +	if (!vde->iram) {
> +		dev_err(dev, "Could not reserve IRAM\n");
> +		return -ENOMEM;
> +	}
> +
> +	mutex_init(&vde->lock);
> +	init_completion(&vde->decode_completion);
> +
> +	vde->miscdev.minor = MISC_DYNAMIC_MINOR;
> +	vde->miscdev.name = "tegra_vde";
> +	vde->miscdev.fops = &tegra_vde_fops;
> +	vde->miscdev.parent = dev;
> +
> +	err = misc_register(&vde->miscdev);
> +	if (err) {
> +		dev_err(dev, "Failed to register misc device: %d\n", err);
> +		goto err_gen_free;
> +	}
> +
> +	pm_runtime_enable(dev);
> +	pm_runtime_use_autosuspend(dev);
> +	pm_runtime_set_autosuspend_delay(dev, 300);
> +
> +	if (!pm_runtime_enabled(dev)) {
> +		err = tegra_vde_runtime_resume(dev);
> +		if (err)
> +			goto err_misc_unreg;
> +	}
> +
> +	return 0;
> +
> +err_misc_unreg:
> +	misc_deregister(&vde->miscdev);
> +
> +err_gen_free:
> +	gen_pool_free(vde->iram_pool,
> +		      (unsigned long)vde->iram, 0x3FC00);

See a comment above.

> +
> +	return err;
> +}
> +
> +static int tegra_vde_remove(struct platform_device *pdev)
> +{
> +	struct tegra_vde *vde = platform_get_drvdata(pdev);
> +	struct device *dev = &pdev->dev;
> +	int err;
> +
> +	if (!pm_runtime_enabled(dev)) {
> +		err = tegra_vde_runtime_suspend(dev);
> +		if (err)
> +			return err;
> +	}
> +
> +	pm_runtime_dont_use_autosuspend(dev);
> +	pm_runtime_disable(dev);
> +
> +	misc_deregister(&vde->miscdev);
> +
> +	gen_pool_free(vde->iram_pool,
> +		      (unsigned long)vde->iram, 0x3FC00);

See a comment above.

> +
> +	return 0;
> +}
> +

[snip]

> +
> +MODULE_DESCRIPTION("NVIDIA Tegra20 Video Decoder driver");
> +MODULE_AUTHOR("Dmitry Osipenko");

Please add your email here, then if you are not a maintainer (and by
the way please consider to add your name to the MAINTAINERS file),
you'll get a higher chance to receive updates in the future.

> +MODULE_LICENSE("GPL");
> 

--
With best wishes,
Vladimir
