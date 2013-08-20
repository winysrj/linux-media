Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45743 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3HTLiW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 07:38:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Archit Taneja <archit@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	dagriego@biglakesoftware.com, dale@farnsworth.org,
	pawel@osciak.com, m.szyprowski@samsung.com, hverkuil@xs4all.nl,
	tomi.valkeinen@ti.com
Subject: Re: [PATCH 1/6] v4l: ti-vpe: Create a vpdma helper library
Date: Tue, 20 Aug 2013 13:39:34 +0200
Message-ID: <1436822.NCo0PqzB8p@avalon>
In-Reply-To: <520B62B5.8080000@ti.com>
References: <1375452223-30524-1-git-send-email-archit@ti.com> <7062944.SGK3kvnN1v@avalon> <520B62B5.8080000@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit,

On Wednesday 14 August 2013 16:27:57 Archit Taneja wrote:
> On Friday 09 August 2013 03:34 AM, Laurent Pinchart wrote:
> > On Friday 02 August 2013 19:33:38 Archit Taneja wrote:
> >> The primary function of VPDMA is to move data between external memory and
> >> internal processing modules(in our case, VPE) that source or sink data.
> >> VPDMA is capable of buffering this data and then delivering the data as
> >> demanded to the modules as programmed. The modules that source or sink
> >> data are referred to as clients or ports. A channel is setup inside the
> >> VPDMA to connect a specific memory buffer to a specific client. The VPDMA
> >> centralizes the DMA control functions and buffering required to allow all
> >> the clients to minimize the effect of long latency times.
> >> 
> >> Add the following to the VPDMA helper:
> >> 
> >> - A data struct which describe VPDMA channels. For now, these channels
> >> are the ones used only by VPE, the list of channels will increase when
> >> VIP(Video Input Port) also uses the VPDMA library. This channel
> >> information will be used to populate fields required by data descriptors.
> >> 
> >> - Data structs which describe the different data types supported by
> >> VPDMA. This data type information will be used to populate fields
> >> required by data descriptors and used by the VPE driver to map a V4L2
> >> format to the corresponding VPDMA data type.
> >> 
> >> - Provide VPDMA register offset definitions, functions to read, write and
> >> modify VPDMA registers.
> >> 
> >> - Functions to create and submit a VPDMA list. A list is a group of
> >> descriptors that makes up a set of DMA transfers that need to be
> >> completed. Each descriptor will either perform a DMA transaction to fetch
> >> input buffers and write to output buffers(data descriptors), or configure
> >> the MMRs of sub blocks of VPE(configuration descriptors), or provide
> >> control information to VPDMA (control descriptors).
> >> 
> >> - Functions to allocate, map and unmap buffers needed for the descriptor
> >> list, payloads containing MMR values and motion vector buffers. These use
> >> the DMA mapping APIs to ensure exclusive access to VPDMA.
> >> 
> >> - Functions to enable VPDMA interrupts. VPDMA can trigger an interrupt on
> >> the VPE interrupt line when a descriptor list is parsed completely and
> >> the DMA transactions are completed. This requires masking the events in
> >> VPDMA registers and configuring some top level VPE interrupt registers.
> >> 
> >> - Enable some VPDMA specific parameters: frame start event(when to start
> >> DMA for a client) and line mode(whether each line fetched should be
> >> mirrored or not).
> >> 
> >> - Function to load firmware required by VPDMA. VPDMA requires a firmware
> >> for it's internal list manager. We add the required request_firmware
> >> apis to fetch this firmware from user space.
> >> 
> >> - Function to dump VPDMA registers.
> >> 
> >> - A function to initialize VPDMA, this will be called by the VPE driver
> >> with it's platform device pointer, this function will take care of
> >> loading VPDMA firmware and returning a handle back to the VPE driver.
> >> The VIP driver will also call the same init function to initialize it's
> >> own VPDMA instance.
> >> 
> >> Signed-off-by: Archit Taneja <archit@ti.com>

[snip]

> >> +/*
> >> + * Allocate a DMA buffer
> >> + */
> >> +int vpdma_buf_alloc(struct vpdma_buf *buf, size_t size)
> >> +{
> >> +	buf->size = size;
> >> +	buf->mapped = 0;
> >> +	buf->addr = kzalloc(size, GFP_KERNEL);
> > 
> > You should use the dma allocation API (depending on your needs,
> > dma_alloc_coherent for instance) to allocate DMA-able buffers.
> 
> I'm not sure about this, dma_map_single() api works fine on kzalloc'd
> buffers. The above function is used to allocate small contiguous buffers
> (never more than 1024 bytes) needed for descriptors for the DMA IP. I
> thought of using DMA pool, but that creates small buffers of the same size.
> So I finally went with kzalloc.

OK, I mistakenly thought it would allocate larger buffers as well. If it's 
used to allocate descriptors only, would it be better to rename it to 
vpdma_desc_alloc() (or something similar) ?

> >> +	if (!buf->addr)
> >> +		return -ENOMEM;
> >> +
> >> +	WARN_ON((u32) buf->addr & VPDMA_DESC_ALIGN);
> >> +
> >> +	return 0;
> >> +}

[snip]

> >> +static int vpdma_load_firmware(struct vpdma_data *vpdma)
> >> +{
> >> +	int r;
> >> +	struct device *dev = &vpdma->pdev->dev;
> >> +
> >> +	r = request_firmware_nowait(THIS_MODULE, 1,
> >> +		(const char *) VPDMA_FIRMWARE, dev, GFP_KERNEL, vpdma,
> >> +		vpdma_firmware_cb);
> > 
> > Is there a reason not to use the synchronous interface ? That would
> > simplify both this code and the callers, as they won't have to check
> > whether the firmware has been correctly loaded.
> 
> I'm not clear what you mean by that, the firmware would be stored in the
> filesystem. If the driver is built-in, then the synchronous interface
> wouldn't work unless the firmware is appended to the kernel image. Am I
> missing something here? I'm not very aware of the firmware api.

request_firmware() would just sleep (with a 30 seconds timeout if I'm not 
mistaken) until userspace provides the firmware. As devices are probed 
asynchronously (in kernel threads) the system will just boot normally, and the 
request_firmware() call will return when the firmware is available.

> >> +	if (r) {
> >> +		dev_err(dev, "firmware not available %s\n", VPDMA_FIRMWARE);
> >> +		return r;
> >> +	} else {
> >> +		dev_info(dev, "loading firmware %s\n", VPDMA_FIRMWARE);
> >> +	}
> >> +
> >> +	return 0;
> >> +}

-- 
Regards,

Laurent Pinchart

