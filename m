Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:35727 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965193AbdAIPKN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 10:10:13 -0500
Subject: Re: [PATCH v2] [media] vivid: support for contiguous DMA buffers
To: Vincent Abriou <vincent.abriou@st.com>, linux-media@vger.kernel.org
References: <1473670047-24670-1-git-send-email-vincent.abriou@st.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2996e55c-b014-ac75-5cb0-c4706a7b5f37@xs4all.nl>
Date: Mon, 9 Jan 2017 16:10:07 +0100
MIME-Version: 1.0
In-Reply-To: <1473670047-24670-1-git-send-email-vincent.abriou@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2016 10:47 AM, Vincent Abriou wrote:
> It allows to simulate the behavior of hardware with such limitations or
> to connect vivid to real hardware with such limitations.
> 
> Add the "allocators" module parameter option to let vivid use the
> dma-contig instead of vmalloc.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
> 
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/media/v4l-drivers/vivid.rst |  8 ++++++++
>  drivers/media/platform/vivid/Kconfig      |  2 ++
>  drivers/media/platform/vivid/vivid-core.c | 32 ++++++++++++++++++++++++++-----
>  3 files changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/media/v4l-drivers/vivid.rst b/Documentation/media/v4l-drivers/vivid.rst
> index c8cf371..3e44b22 100644
> --- a/Documentation/media/v4l-drivers/vivid.rst
> +++ b/Documentation/media/v4l-drivers/vivid.rst
> @@ -263,6 +263,14 @@ all configurable using the following module options:
>  	removed. Unless overridden by ccs_cap_mode and/or ccs_out_mode the
>  	will default to enabling crop, compose and scaling.
>  
> +- allocators:
> +
> +	memory allocator selection, default is 0. It specifies the way buffers
> +	will be allocated.
> +
> +		- 0: vmalloc
> +		- 1: dma-contig

Could you add support for dma-sg as well? I think that would be fairly trivial (unless
I missed something).

Once that's added (or it's clear dma-sg won't work for some reason), then I'll merge this.

Regards,

	Hans

> +
>  Taken together, all these module options allow you to precisely customize
>  the driver behavior and test your application with all sorts of permutations.
>  It is also very suitable to emulate hardware that is not yet available, e.g.
> diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
> index 8e6918c..2e238a1 100644
> --- a/drivers/media/platform/vivid/Kconfig
> +++ b/drivers/media/platform/vivid/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_VIVID
>  	tristate "Virtual Video Test Driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64 && FB
> +	depends on HAS_DMA
>  	select FONT_SUPPORT
>  	select FONT_8x16
>  	select FB_CFB_FILLRECT
> @@ -8,6 +9,7 @@ config VIDEO_VIVID
>  	select FB_CFB_IMAGEBLIT
>  	select MEDIA_CEC_EDID
>  	select VIDEOBUF2_VMALLOC
> +	select VIDEOBUF2_DMA_CONTIG
>  	select VIDEO_V4L2_TPG
>  	default n
>  	---help---
> diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
> index 741460a..02e1909 100644
> --- a/drivers/media/platform/vivid/vivid-core.c
> +++ b/drivers/media/platform/vivid/vivid-core.c
> @@ -30,6 +30,7 @@
>  #include <linux/videodev2.h>
>  #include <linux/v4l2-dv-timings.h>
>  #include <media/videobuf2-vmalloc.h>
> +#include <media/videobuf2-dma-contig.h>
>  #include <media/v4l2-dv-timings.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-fh.h>
> @@ -151,6 +152,12 @@ static bool no_error_inj;
>  module_param(no_error_inj, bool, 0444);
>  MODULE_PARM_DESC(no_error_inj, " if set disable the error injecting controls");
>  
> +static unsigned int allocators[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 0 };
> +module_param_array(allocators, uint, NULL, 0444);
> +MODULE_PARM_DESC(allocators, " memory allocator selection, default is 0.\n"
> +			     "\t\t    0 == vmalloc\n"
> +			     "\t\t    1 == dma-contig");
> +
>  static struct vivid_dev *vivid_devs[VIVID_MAX_DEVS];
>  
>  const struct v4l2_rect vivid_min_rect = {
> @@ -636,6 +643,10 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  {
>  	static const struct v4l2_dv_timings def_dv_timings =
>  					V4L2_DV_BT_CEA_1280X720P60;
> +	static const struct vb2_mem_ops * const vivid_mem_ops[2] = {
> +		&vb2_vmalloc_memops,
> +		&vb2_dma_contig_memops,
> +	};
>  	unsigned in_type_counter[4] = { 0, 0, 0, 0 };
>  	unsigned out_type_counter[4] = { 0, 0, 0, 0 };
>  	int ccs_cap = ccs_cap_mode[inst];
> @@ -646,6 +657,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  	struct video_device *vfd;
>  	struct vb2_queue *q;
>  	unsigned node_type = node_types[inst];
> +	unsigned int allocator = allocators[inst];
>  	v4l2_std_id tvnorms_cap = 0, tvnorms_out = 0;
>  	int ret;
>  	int i;
> @@ -1036,6 +1048,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  	if (!dev->cec_workqueue)
>  		goto unreg_dev;
>  
> +	if (allocator == 1)
> +		dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> +	else if (allocator >= ARRAY_SIZE(vivid_mem_ops))
> +		allocator = 0;
> +
>  	/* start creating the vb2 queues */
>  	if (dev->has_vid_cap) {
>  		/* initialize vid_cap queue */
> @@ -1046,10 +1063,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_vid_cap_qops;
> -		q->mem_ops = &vb2_vmalloc_memops;
> +		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
>  		q->lock = &dev->mutex;
> +		q->dev = dev->v4l2_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> @@ -1065,10 +1083,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_vid_out_qops;
> -		q->mem_ops = &vb2_vmalloc_memops;
> +		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
>  		q->lock = &dev->mutex;
> +		q->dev = dev->v4l2_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> @@ -1084,10 +1103,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_vbi_cap_qops;
> -		q->mem_ops = &vb2_vmalloc_memops;
> +		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
>  		q->lock = &dev->mutex;
> +		q->dev = dev->v4l2_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> @@ -1103,10 +1123,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_vbi_out_qops;
> -		q->mem_ops = &vb2_vmalloc_memops;
> +		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 2;
>  		q->lock = &dev->mutex;
> +		q->dev = dev->v4l2_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> @@ -1121,10 +1142,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
>  		q->drv_priv = dev;
>  		q->buf_struct_size = sizeof(struct vivid_buffer);
>  		q->ops = &vivid_sdr_cap_qops;
> -		q->mem_ops = &vb2_vmalloc_memops;
> +		q->mem_ops = vivid_mem_ops[allocator];
>  		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  		q->min_buffers_needed = 8;
>  		q->lock = &dev->mutex;
> +		q->dev = dev->v4l2_dev.dev;
>  
>  		ret = vb2_queue_init(q);
>  		if (ret)
> 

