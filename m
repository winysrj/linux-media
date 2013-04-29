Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12128 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3D2PNk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 11:13:40 -0400
Message-id: <517E8E1F.4080807@samsung.com>
Date: Mon, 29 Apr 2013 17:13:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, shaik.samsung@gmail.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v2 3/6] media: fimc-lite: Adding support for Exynos5
References: <1366789273-30184-1-git-send-email-shaik.ameer@samsung.com>
 <1366789273-30184-4-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1366789273-30184-4-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/2013 09:41 AM, Shaik Ameer Basha wrote:
> FIMC-LITE supports multiple DMA shadow registers from Exynos5 onwards.
> This patch adds the functionality of using shadow registers by
> checking the driver data.
> 
> Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
> ---
>  drivers/media/platform/exynos4-is/fimc-lite-reg.c |   13 +++++++
>  drivers/media/platform/exynos4-is/fimc-lite-reg.h |   41 ++++++++++++++++++++-
>  drivers/media/platform/exynos4-is/fimc-lite.c     |   12 ++++--
>  3 files changed, 60 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.c b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
> index 8cc0d39..a1d566a 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite-reg.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.c
> @@ -215,6 +215,18 @@ void flite_hw_set_camera_bus(struct fimc_lite *dev,
>  	flite_hw_set_camera_port(dev, si->mux_id);
>  }
>  
> +static void flite_hw_set_pack12(struct fimc_lite *dev, int on)
> +{
> +	u32 cfg = readl(dev->regs + FLITE_REG_CIODMAFMT);
> +
> +	cfg &= ~FLITE_REG_CIODMAFMT_PACK12;
> +
> +	if (on)
> +		cfg |= FLITE_REG_CIODMAFMT_PACK12;
> +
> +	writel(cfg, dev->regs + FLITE_REG_CIODMAFMT);
> +}
> +
>  static void flite_hw_set_out_order(struct fimc_lite *dev, struct flite_frame *f)
>  {
>  	static const u32 pixcode[4][2] = {
> @@ -267,6 +279,7 @@ void flite_hw_set_output_dma(struct fimc_lite *dev, struct flite_frame *f,
>  
>  	flite_hw_set_out_order(dev, f);
>  	flite_hw_set_dma_window(dev, f);
> +	flite_hw_set_pack12(dev, 0);

Are you planning to use this function with the second argument's different
value than 0 ? FLITE_REG_CIODMAFMT_PACK12 default value after reset is 0. 
I'm not opposed to keeping this code, just was wondering if it is not needed 
only when support for some packed media bus formats is added and we actually
set the PACK12 bit to 1 ?

>  }
>  
>  void flite_hw_dump_regs(struct fimc_lite *dev, const char *label)
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite-reg.h b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
> index 3903839..8e57e7a 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite-reg.h
> +++ b/drivers/media/platform/exynos4-is/fimc-lite-reg.h
> @@ -120,6 +120,10 @@
>  /* b0: 1 - camera B, 0 - camera A */
>  #define FLITE_REG_CIGENERAL_CAM_B		(1 << 0)
>  
> +
> +#define FLITE_REG_CIFCNTSEQ			0x100
> +#define FLITE_REG_CIOSAN(x)			(0x200 + (4 * (x)))
> +
>  /* ----------------------------------------------------------------------------
>   * Function declarations
>   */
> @@ -143,8 +147,41 @@ void flite_hw_set_dma_window(struct fimc_lite *dev, struct flite_frame *f);
>  void flite_hw_set_test_pattern(struct fimc_lite *dev, bool on);
>  void flite_hw_dump_regs(struct fimc_lite *dev, const char *label);
>  
> -static inline void flite_hw_set_output_addr(struct fimc_lite *dev, u32 paddr)
> +static inline void flite_hw_set_output_addr(struct fimc_lite *dev,
> +	u32 paddr, u32 index)
> +{
> +	u32 config;
> +
> +	/* FLITE in EXYNOS4 has only one DMA register */
> +	if (!dev->dd->support_multi_dma_buf)
> +		index = 0;
> +
> +	config = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
> +	config |= 1 << index;

nit: Could be also written more explicitly:

config |= BIT(index);

(needs #include <linux/bitops.h>)

> +static inline void flite_hw_set_output_addr(struct fimc_lite *dev,
> +	u32 paddr, u32 index)

> +	writel(config, dev->regs + FLITE_REG_CIFCNTSEQ);
> +
> +	if (index == 0)
> +		writel(paddr, dev->regs + FLITE_REG_CIOSA);
> +	else
> +		writel(paddr, dev->regs + FLITE_REG_CIOSAN(index-1));
> +}
> +
> +static inline void flite_hw_clear_output_addr(struct fimc_lite *dev, u32 index)
>  {
> -	writel(paddr, dev->regs + FLITE_REG_CIOSA);
> +	u32 config;
> +
> +	/* FLITE in EXYNOS4 has only one DMA register */
> +	if (!dev->dd->support_multi_dma_buf)
> +		index = 0;
> +
> +	config = readl(dev->regs + FLITE_REG_CIFCNTSEQ);
> +	config &= ~(1 << index);
> +	writel(config, dev->regs + FLITE_REG_CIFCNTSEQ);
>  }
> +
> +static inline void flite_hw_clear_output_index(struct fimc_lite *dev)
> +{
> +	writel(0, dev->regs + FLITE_REG_CIFCNTSEQ);
> +}
> +
>  #endif /* FIMC_LITE_REG_H */
> diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
> index cb173ec..1b12ea8 100644
> --- a/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ b/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -166,6 +166,8 @@ static int fimc_lite_hw_init(struct fimc_lite *fimc, bool isp_output)
>  	if (fimc->inp_frame.fmt == NULL || fimc->out_frame.fmt == NULL)
>  		return -EINVAL;
>  
> +	flite_hw_clear_output_index(fimc);
> +
>  	/* Get sensor configuration data from the sensor subdev */
>  	si = v4l2_get_subdev_hostdata(fimc->sensor);
>  	if (!si)
> @@ -307,11 +309,12 @@ static irqreturn_t flite_irq_handler(int irq, void *priv)
>  		tv->tv_sec = ts.tv_sec;
>  		tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>  		vbuf->vb.v4l2_buf.sequence = fimc->frame_count++;
> +		flite_hw_clear_output_addr(fimc, vbuf->vb.v4l2_buf.index);

This patch looks OK except that it might not be a good idea to use v4l2_buf.index
in the kernel to control how frame buffers are queued in the hardware.
I think it can break with USERPTR buffers, when user space is free to re-assign
memory buffer address to a v4l2_buffer with given index.
So IMO the kernel should maintain it's own id of a buffer in hardware, 
associated with a buffer in e.g. buffer_queue op.

> @@ -643,7 +647,7 @@ static int fimc_vidioc_querycap_capture(struct file *file, void *priv,
>  	strlcpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
>  	cap->bus_info[0] = 0;
>  	cap->card[0] = 0;
> -	cap->capabilities = V4L2_CAP_STREAMING;
> +	cap->capabilities = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE_MPLANE;

The FIMC-LITE video nodes require some subdevices to be configured and video
capture will not work if user space skips these steps. Hence it cannot be
assumed at user space that this video node is a standard V4L2 video capture
device and V4L2_CAP_VIDEO_CAPTURE_MPLANE must not be set for it.

I have tested patches 2...4/6 on Exynos4412 SoC and a side effect is that 
frame rate seems to be twice lower. In addition, there is twice as many
FIMC-LITE interrupts, since you have turned on FRAME_END interrupt 
permanently. With two additional interrupts from the MIPI-CSI receiver per 
each frame it's a bit worrying. I'll comment on that at patch 5/6.


Regards,
Sylwester
