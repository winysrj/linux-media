Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36294 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbcEFSwX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 14:52:23 -0400
Date: Fri, 6 May 2016 15:52:16 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v4] media: vb2-dma-contig: configure DMA max segment
 size properly
Message-ID: <20160506155216.60dc910c@recife.lan>
In-Reply-To: <1462352403-27418-1-git-send-email-m.szyprowski@samsung.com>
References: <5729B396.1020706@xs4all.nl>
	<1462352403-27418-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 04 May 2016 11:00:03 +0200
Marek Szyprowski <m.szyprowski@samsung.com> escreveu:

> This patch lets vb2-dma-contig memory allocator to configure DMA max
> segment size properly for the client device. Setting it is needed to let
> DMA-mapping subsystem to create a single, contiguous mapping in DMA
> address space. This is essential for all devices, which use dma-contig
> videobuf2 memory allocator and shared buffers (in USERPTR or DMAbuf modes
> of operations).
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hello,
> 
> This patch is a follow-up of my previous attempts to let Exynos
> multimedia devices to work properly with shared buffers when IOMMU is
> enabled:
> 1. https://www.mail-archive.com/linux-media@vger.kernel.org/msg96946.html
> 2. http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/97316
> 3. https://patchwork.linuxtv.org/patch/30870/
> 
> As sugested by Hans, configuring DMA max segment size should be done by
> videobuf2-dma-contig module instead of requiring all device drivers to
> do it on their own.
> 
> Here is some backgroud why this is done in videobuf2-dc not in the
> respective generic bus code:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/305913.html
> 
> Best regards,
> Marek Szyprowski
> 
> changelog:
> v4:
> - rebased onto media master tree
> - call vb2_dc_set_max_seg_size after allocating vb2 buf object
> 
> v3:
> - added FIXME note about possible memory leak
> 
> v2:
> - fixes typos and other language issues in the comments
> 
> v1: http://article.gmane.org/gmane.linux.kernel.samsung-soc/53690
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 53 +++++++++++++++++++++++++-
>  1 file changed, 51 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 5361197f3e57..6291842a889f 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -448,6 +448,42 @@ static void vb2_dc_put_userptr(void *buf_priv)
>  }
>  
>  /*
> + * To allow mapping the scatter-list into a single chunk in the DMA
> + * address space, the device is required to have the DMA max segment
> + * size parameter set to a value larger than the buffer size. Otherwise,
> + * the DMA-mapping subsystem will split the mapping into max segment
> + * size chunks. This function increases the DMA max segment size
> + * parameter to let DMA-mapping map a buffer as a single chunk in DMA
> + * address space.
> + * This code assumes that the DMA-mapping subsystem will merge all
> + * scatterlist segments if this is really possible (for example when
> + * an IOMMU is available and enabled).
> + * Ideally, this parameter should be set by the generic bus code, but it
> + * is left with the default 64KiB value due to historical litmiations in
> + * other subsystems (like limited USB host drivers) and there no good
> + * place to set it to the proper value. It is done here to avoid fixing
> + * all the vb2-dc client drivers.
> + *
> + * FIXME: the allocated dma_params structure is leaked because there
> + * is completely no way to determine when to free it (dma_params might have
> + * been also already allocated by the bus code). However in typical
> + * use cases this function will be called for platform devices, which are
> + * not hot-plugged and exist all the time in the target system.
> + */
> +static int vb2_dc_set_max_seg_size(struct device *dev, unsigned int size)
> +{
> +	if (!dev->dma_parms) {
> +		dev->dma_parms = kzalloc(sizeof(dev->dma_parms), GFP_KERNEL);

Why don't you use devm_kzalloc() here? dma_parms will then be freed
if the device gets hot-unplugged/unbind.

And yes: it is possible to hot-unplug (actually, hot-unbind) a platform
device via sysfs.

Just assuming that only platform drivers will use dma-contig and adding
a memory leak here seems really ugly!

Regards,
Mauro
-- 
Thanks,
Mauro
