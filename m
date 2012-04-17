Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59144 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2DQKCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 06:02:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: Manjunath Hadli <manjunath.hadli@ti.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 05/13] davinci: vpif display: declare contiguous region of memory handled by dma_alloc_coherent
Date: Tue, 17 Apr 2012 12:02:55 +0200
Message-ID: <1658646.Sj5u4WkIAm@avalon>
In-Reply-To: <1334652791-15833-6-git-send-email-manjunath.hadli@ti.com>
References: <1334652791-15833-1-git-send-email-manjunath.hadli@ti.com> <1334652791-15833-6-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

Thanks for the patch.

On Tuesday 17 April 2012 14:23:03 Manjunath Hadli wrote:
> add support to declare contiguous region of memory to be handled
> when requested by dma_alloc_coherent call. The user can specify
> the size of the buffers with an offset from the kernel image
> using cont_bufsize and cont_bufoffset module parameters respectively.
> 
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  drivers/media/video/davinci/vpif_display.c |   65 ++++++++++++++++++++++++-
>  drivers/media/video/davinci/vpif_display.h |    1 +
>  2 files changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/vpif_display.c
> b/drivers/media/video/davinci/vpif_display.c index 355ad5c..27bc03d 100644
> --- a/drivers/media/video/davinci/vpif_display.c
> +++ b/drivers/media/video/davinci/vpif_display.c
> @@ -57,18 +57,24 @@ static u32 ch2_numbuffers = 3;
>  static u32 ch3_numbuffers = 3;
>  static u32 ch2_bufsize = 1920 * 1080 * 2;
>  static u32 ch3_bufsize = 720 * 576 * 2;
> +static u32 cont_bufoffset;
> +static u32 cont_bufsize;
> 
>  module_param(debug, int, 0644);
>  module_param(ch2_numbuffers, uint, S_IRUGO);
>  module_param(ch3_numbuffers, uint, S_IRUGO);
>  module_param(ch2_bufsize, uint, S_IRUGO);
>  module_param(ch3_bufsize, uint, S_IRUGO);
> +module_param(cont_bufoffset, uint, S_IRUGO);
> +module_param(cont_bufsize, uint, S_IRUGO);
> 
>  MODULE_PARM_DESC(debug, "Debug level 0-1");
>  MODULE_PARM_DESC(ch2_numbuffers, "Channel2 buffer count (default:3)");
>  MODULE_PARM_DESC(ch3_numbuffers, "Channel3 buffer count (default:3)");
>  MODULE_PARM_DESC(ch2_bufsize, "Channel2 buffer size (default:1920 x 1080 x
> 2)"); MODULE_PARM_DESC(ch3_bufsize, "Channel3 buffer size (default:720 x
> 576 x 2)"); +MODULE_PARM_DESC(cont_bufoffset, "Display offset(default 0)");
> +MODULE_PARM_DESC(cont_bufsize, "Display buffer size(default 0)");
> 
>  static struct vpif_config_params config_params = {
>  	.min_numbuffers		= 3,
> @@ -187,6 +193,24 @@ static int vpif_buffer_setup(struct videobuf_queue *q,
> unsigned int *count, return 0;
> 
>  	*size = config_params.channel_bufsize[ch->channel_id];
> +
> +	/*
> +	 * Checking if the buffer size exceeds the available buffer
> +	 * ycmux_mode = 0 means 1 channel mode HD and
> +	 * ycmux_mode = 1 means 2 channels mode SD
> +	 */
> +	if (ch->vpifparams.std_info.ycmux_mode == 0) {
> +		if (config_params.video_limit[ch->channel_id])
> +			while (*size * *count > (config_params.video_limit[0]
> +					+ config_params.video_limit[1]))
> +				(*count)--;
> +	} else {
> +		if (config_params.video_limit[ch->channel_id])
> +			while (*size * *count >
> +				config_params.video_limit[ch->channel_id])
> +				(*count)--;
> +	}
> +
>  	if (*count < config_params.min_numbuffers)
>  		*count = config_params.min_numbuffers;
> 
> @@ -830,7 +854,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
> 
>  	common = &ch->common[index];
> 
> -	if (common->fmt.type != reqbuf->type)
> +	if (common->fmt.type != reqbuf->type || !vpif_dev)
>  		return -EINVAL;
> 
>  	if (0 != common->io_usrs)
> @@ -847,7 +871,7 @@ static int vpif_reqbufs(struct file *file, void *priv,
> 
>  	/* Initialize videobuf queue as per the buffer type */
>  	videobuf_queue_dma_contig_init(&common->buffer_queue,
> -					    &video_qops, NULL,
> +					    &video_qops, vpif_dev,
>  					    &common->irqlock,
>  					    reqbuf->type, field,
>  					    sizeof(struct videobuf_buffer), fh,
> @@ -1686,12 +1710,14 @@ static __init int vpif_probe(struct platform_device
> *pdev) struct vpif_subdev_info *subdevdata;
>  	struct vpif_display_config *config;
>  	int i, j = 0, k, q, m, err = 0;
> +	unsigned long phys_end_kernel;
>  	struct i2c_adapter *i2c_adap;
>  	struct common_obj *common;
>  	struct channel_obj *ch;
>  	struct video_device *vfd;
>  	struct resource *res;
>  	int subdev_count;
> +	size_t size;
> 
>  	vpif_dev = &pdev->dev;
> 
> @@ -1749,6 +1775,41 @@ static __init int vpif_probe(struct platform_device
> *pdev) ch->video_dev = vfd;
>  	}
> 
> +	/* Initialising the memory from the input arguments file for
> +	 * contiguous memory buffers and avoid defragmentation
> +	 */
> +	if (cont_bufsize) {
> +		/* attempt to determine the end of Linux kernel memory */
> +		phys_end_kernel = virt_to_phys((void *)PAGE_OFFSET) +
> +			(num_physpages << PAGE_SHIFT);
> +		phys_end_kernel += cont_bufoffset;
> +		size = cont_bufsize;
> +
> +		err = dma_declare_coherent_memory(&pdev->dev, phys_end_kernel,
> +				phys_end_kernel, size,
> +				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);

This is a pretty dangerous hack. You should compute the memory address and 
size in board code, and pass it to the driver through a device resource (don't 
forget to call request_mem_region on the resource). I think the 
dma_declare_coherent_memory() call should be moved to board code as well.

> +		if (!err) {
> +			dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
> +			err = -ENOMEM;
> +			goto probe_out;
> +		}
> +
> +		/* The resources are divided into two equal memory and when
> +		 * we have HD output we can add them together
> +		 */
> +		for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
> +			ch = vpif_obj.dev[j];
> +			ch->channel_id = j;
> +
> +			/* only enabled if second resource exists */
> +			config_params.video_limit[ch->channel_id] = 0;
> +			if (cont_bufsize)
> +				config_params.video_limit[ch->channel_id] =
> +									size/2;
> +		}
> +	}
> +
>  	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
>  		ch = vpif_obj.dev[j];
>  		/* Initialize field of the channel objects */
> diff --git a/drivers/media/video/davinci/vpif_display.h
> b/drivers/media/video/davinci/vpif_display.h index dd4887c..8a311f1 100644
> --- a/drivers/media/video/davinci/vpif_display.h
> +++ b/drivers/media/video/davinci/vpif_display.h
> @@ -158,6 +158,7 @@ struct vpif_config_params {
>  	u32 min_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
>  	u32 channel_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
>  	u8 numbuffers[VPIF_DISPLAY_NUM_CHANNELS];
> +	u32 video_limit[VPIF_DISPLAY_NUM_CHANNELS];
>  	u8 min_numbuffers;
>  };

-- 
Regards,

Laurent Pinchart

