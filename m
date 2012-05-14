Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59188 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab2ENHqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 03:46:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 05/13] davinci: vpif display: declare contiguous region of memory handled by dma_alloc_coherent
Date: Mon, 14 May 2012 09:46:27 +0200
Message-ID: <8358601.0Ocm27lmng@avalon>
In-Reply-To: <E99FAA59F8D8D34D8A118DD37F7C8F753E927D6A@DBDE01.ent.ti.com>
References: <1334652791-15833-1-git-send-email-manjunath.hadli@ti.com> <1658646.Sj5u4WkIAm@avalon> <E99FAA59F8D8D34D8A118DD37F7C8F753E927D6A@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manjunath,

On Friday 11 May 2012 05:30:43 Hadli, Manjunath wrote:
> On Tue, Apr 17, 2012 at 15:32:55, Laurent Pinchart wrote:
> > On Tuesday 17 April 2012 14:23:03 Manjunath Hadli wrote:
> > > add support to declare contiguous region of memory to be handled when
> > > requested by dma_alloc_coherent call. The user can specify the size of
> > > the buffers with an offset from the kernel image using cont_bufsize
> > > and cont_bufoffset module parameters respectively.

[snip]

> > > @@ -1686,12 +1710,14 @@ static __init int vpif_probe(struct
> > > platform_device *pdev) struct vpif_subdev_info *subdevdata;
> > > 
> > >  	struct vpif_display_config *config;
> > >  	int i, j = 0, k, q, m, err = 0;
> > > 
> > > +	unsigned long phys_end_kernel;
> > > 
> > >  	struct i2c_adapter *i2c_adap;
> > >  	struct common_obj *common;
> > >  	struct channel_obj *ch;
> > >  	struct video_device *vfd;
> > >  	struct resource *res;
> > >  	int subdev_count;
> > > 
> > > +	size_t size;
> > > 
> > >  	vpif_dev = &pdev->dev;
> > > 
> > > @@ -1749,6 +1775,41 @@ static __init int vpif_probe(struct
> > > platform_device
> > > *pdev) ch->video_dev = vfd;
> > > 
> > >  	}
> > > 
> > > +	/* Initialising the memory from the input arguments file for
> > > +	 * contiguous memory buffers and avoid defragmentation
> > > +	 */
> > > +	if (cont_bufsize) {
> > > +		/* attempt to determine the end of Linux kernel memory */
> > > +		phys_end_kernel = virt_to_phys((void *)PAGE_OFFSET) +
> > > +			(num_physpages << PAGE_SHIFT);
> > > +		phys_end_kernel += cont_bufoffset;
> > > +		size = cont_bufsize;
> > > +
> > > +		err = dma_declare_coherent_memory(&pdev->dev, phys_end_kernel,
> > > +				phys_end_kernel, size,
> > > +				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
> > 
> > This is a pretty dangerous hack. You should compute the memory address and
> > size in board code, and pass it to the driver through a device resource
> > (don't forget to call request_mem_region on the resource). I think the
> > dma_declare_coherent_memory() call should be moved to board code as well.
>
> I don't think it is a hack. Since the device does not support scatter gather
> MMU, we need to make sure that the requirement of memory scucceeds for the
> Driver buffers.

If two drivers attempt to do the same you're screwed. That's why this should 
be moved to board code, where memory reservation for all devices that need it 
can be coordinated. You should call dma_declare_coherent_memory() there, not 
in the VPIF driver.

> Here the size is taken as part of module parameters, which If I am right,
> cannot be moved to board file.

Depending on how early you need the information in board code you can use 
early_param(), __setup() or normal module parameter macros in the board code.

> > > +		if (!err) {
> > > +			dev_err(&pdev->dev, "Unable to declare MMAP memory.\n");
> > > +			err = -ENOMEM;
> > > +			goto probe_out;
> > > +		}
> > > +
> > > +		/* The resources are divided into two equal memory and when
> > > +		 * we have HD output we can add them together
> > > +		 */
> > > +		for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
> > > +			ch = vpif_obj.dev[j];
> > > +			ch->channel_id = j;
> > > +
> > > +			/* only enabled if second resource exists */
> > > +			config_params.video_limit[ch->channel_id] = 0;
> > > +			if (cont_bufsize)
> > > +				config_params.video_limit[ch->channel_id] =
> > > +									size/2;
> > > +		}
> > > +	}
> > > +
> > > 
> > >  	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
> > >  	
> > >  		ch = vpif_obj.dev[j];
> > >  		/* Initialize field of the channel objects */ diff --git

-- 
Regards,

Laurent Pinchart

