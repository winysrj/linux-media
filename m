Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47351 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758176Ab3HHWDk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 18:03:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Archit Taneja <archit@ti.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	dagriego@biglakesoftware.com, dale@farnsworth.org,
	pawel@osciak.com, m.szyprowski@samsung.com, hverkuil@xs4all.nl,
	tomi.valkeinen@ti.com
Subject: Re: [PATCH 1/6] v4l: ti-vpe: Create a vpdma helper library
Date: Fri, 09 Aug 2013 00:04:44 +0200
Message-ID: <7062944.SGK3kvnN1v@avalon>
In-Reply-To: <1375452223-30524-2-git-send-email-archit@ti.com>
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-2-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit,

Thank you for the patch.

On Friday 02 August 2013 19:33:38 Archit Taneja wrote:
> The primary function of VPDMA is to move data between external memory and
> internal processing modules(in our case, VPE) that source or sink data.
> VPDMA is capable of buffering this data and then delivering the data as
> demanded to the modules as programmed. The modules that source or sink data
> are referred to as clients or ports. A channel is setup inside the VPDMA to
> connect a specific memory buffer to a specific client. The VPDMA
> centralizes the DMA control functions and buffering required to allow all
> the clients to minimize the effect of long latency times.
> 
> Add the following to the VPDMA helper:
> 
> - A data struct which describe VPDMA channels. For now, these channels are
> the ones used only by VPE, the list of channels will increase when
> VIP(Video Input Port) also uses the VPDMA library. This channel information
> will be used to populate fields required by data descriptors.
> 
> - Data structs which describe the different data types supported by VPDMA.
> This data type information will be used to populate fields required by data
> descriptors and used by the VPE driver to map a V4L2 format to the
> corresponding VPDMA data type.
> 
> - Provide VPDMA register offset definitions, functions to read, write and
> modify VPDMA registers.
> 
> - Functions to create and submit a VPDMA list. A list is a group of
> descriptors that makes up a set of DMA transfers that need to be completed.
> Each descriptor will either perform a DMA transaction to fetch input
> buffers and write to output buffers(data descriptors), or configure the
> MMRs of sub blocks of VPE(configuration descriptors), or provide control
> information to VPDMA (control descriptors).
> 
> - Functions to allocate, map and unmap buffers needed for the descriptor
> list, payloads containing MMR values and motion vector buffers. These use
> the DMA mapping APIs to ensure exclusive access to VPDMA.
> 
> - Functions to enable VPDMA interrupts. VPDMA can trigger an interrupt on
> the VPE interrupt line when a descriptor list is parsed completely and the
> DMA transactions are completed. This requires masking the events in VPDMA
> registers and configuring some top level VPE interrupt registers.
> 
> - Enable some VPDMA specific parameters: frame start event(when to start DMA
> for a client) and line mode(whether each line fetched should be mirrored or
> not).
> 
> - Function to load firmware required by VPDMA. VPDMA requires a firmware for
> it's internal list manager. We add the required request_firmware apis to
> fetch this firmware from user space.
> 
> - Function to dump VPDMA registers.
> 
> - A function to initialize VPDMA, this will be called by the VPE driver with
> it's platform device pointer, this function will take care of loading VPDMA
> firmware and returning a handle back to the VPE driver. The VIP driver will
> also call the same init function to initialize it's own VPDMA instance.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/platform/ti-vpe/vpdma.c      | 589 ++++++++++++++++++++++++++
>  drivers/media/platform/ti-vpe/vpdma.h      | 154 ++++++++
>  drivers/media/platform/ti-vpe/vpdma_priv.h | 119 ++++++
>  3 files changed, 862 insertions(+)
>  create mode 100644 drivers/media/platform/ti-vpe/vpdma.c
>  create mode 100644 drivers/media/platform/ti-vpe/vpdma.h
>  create mode 100644 drivers/media/platform/ti-vpe/vpdma_priv.h
> 
> diff --git a/drivers/media/platform/ti-vpe/vpdma.c
> b/drivers/media/platform/ti-vpe/vpdma.c new file mode 100644
> index 0000000..b15b3dd
> --- /dev/null
> +++ b/drivers/media/platform/ti-vpe/vpdma.c
> @@ -0,0 +1,589 @@

[snip]

> +static int get_field(u32 value, u32 mask, int shift)
> +{
> +	return (value & (mask << shift)) >> shift;
> +}
> +
> +static int get_field_reg(struct vpdma_data *vpdma, int offset,
> +		u32 mask, int shift)

I would call this read_field_reg().

> +{
> +	return get_field(read_reg(vpdma, offset), mask, shift);
> +}
> +
> +static void insert_field(u32 *valp, u32 field, u32 mask, int shift)
> +{
> +	u32 val = *valp;
> +
> +	val &= ~(mask << shift);
> +	val |= (field & mask) << shift;
> +	*valp = val;
> +}

get_field() and insert_field() are used in a single location, you can manually 
inline them.

> +static void insert_field_reg(struct vpdma_data *vpdma, int offset, u32
> field,
> +		u32 mask, int shift)
> +{
> +	u32 val = read_reg(vpdma, offset);
> +
> +	insert_field(&val, field, mask, shift);
> +
> +	write_reg(vpdma, offset, val);
> +}

[snip]

> +/*
> + * Allocate a DMA buffer
> + */
> +int vpdma_buf_alloc(struct vpdma_buf *buf, size_t size)
> +{
> +	buf->size = size;
> +	buf->mapped = 0;
> +	buf->addr = kzalloc(size, GFP_KERNEL);

You should use the dma allocation API (depending on your needs, 
dma_alloc_coherent for instance) to allocate DMA-able buffers.

> +	if (!buf->addr)
> +		return -ENOMEM;
> +
> +	WARN_ON((u32) buf->addr & VPDMA_DESC_ALIGN);
> +
> +	return 0;
> +}
> +
> +void vpdma_buf_free(struct vpdma_buf *buf)
> +{
> +	WARN_ON(buf->mapped != 0);
> +	kfree(buf->addr);
> +	buf->addr = NULL;
> +	buf->size = 0;
> +}
> +
> +/*
> + * map a DMA buffer, enabling DMA access
> + */
> +void vpdma_buf_map(struct vpdma_data *vpdma, struct vpdma_buf *buf)
> +{
> +	struct device *dev = &vpdma->pdev->dev;
> +
> +	WARN_ON(buf->mapped != 0);
> +	buf->dma_addr = dma_map_single(dev, buf->addr, buf->size,
> +				DMA_TO_DEVICE);
> +	buf->mapped = 1;
> +	BUG_ON(dma_mapping_error(dev, buf->dma_addr));

BUG_ON() is too harsh, you should return a proper error instead.

> +}
> +
> +/*
> + * unmap a DMA buffer, disabling DMA access and
> + * allowing the main processor to acces the data
> + */
> +void vpdma_buf_unmap(struct vpdma_data *vpdma, struct vpdma_buf *buf)
> +{
> +	struct device *dev = &vpdma->pdev->dev;
> +
> +	if (buf->mapped)
> +		dma_unmap_single(dev, buf->dma_addr, buf->size, DMA_TO_DEVICE);
> +
> +	buf->mapped = 0;
> +}
> +
> +/*
> + * create a descriptor list, the user of this list will append
> configuration,
> + * contorl and data descriptors to this list, this list will be submitted

s/contorl/control/

> to
> + * VPDMA. VPDMA's list parser will go through each descriptor and perform
> + * the required DMA operations
> + */
> +int vpdma_create_desc_list(struct vpdma_desc_list *list, size_t size, int
> type)
> +{
> +	int r;
> +
> +	r = vpdma_buf_alloc(&list->buf, size);
> +	if (r)
> +		return r;
> +
> +	list->next = list->buf.addr;
> +
> +	list->type = type;
> +
> +	return 0;
> +}
> +
> +/*
> + * once a descriptor list is parsed by VPDMA, we reset the list by emptying
> it,
> + * to allow new descriptors to be added to the list.
> + */
> +void vpdma_reset_desc_list(struct vpdma_desc_list *list)
> +{
> +	list->next = list->buf.addr;
> +}
> +
> +/*
> + * free the buffer allocated fot the VPDMA descriptor list, this should be
> + * called when the user doesn't want to use VPDMA any more.
> + */
> +void vpdma_free_desc_list(struct vpdma_desc_list *list)
> +{
> +	vpdma_buf_free(&list->buf);
> +
> +	list->next = NULL;
> +}
> +
> +static int vpdma_list_busy(struct vpdma_data *vpdma, int list_num)

Should the function return a bool instead of an int ?

> +{
> +	u32 sync_reg = read_reg(vpdma, VPDMA_LIST_STAT_SYNC);
> +
> +	return (sync_reg >> (list_num + 16)) & 0x01;

You could shorten that as

	return read_reg(vpdma, VPDMA_LIST_STAT_SYNC) & BIT(list_num + 16);

> +}
> +
> +/*
> + * submit a list of DMA descriptors to the VPE VPDMA, do not wait for
> completion
> + */
> +int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list
> *list)
> +{
> +	/* we always use the first list */
> +	int list_num = 0;
> +	int list_size;
> +
> +	if (vpdma_list_busy(vpdma, list_num))
> +		return -EBUSY;
> +
> +	/* 16-byte granularity */
> +	list_size = (list->next - list->buf.addr) >> 4;
> +
> +	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) list->buf.dma_addr);
> +	wmb();
> +	write_reg(vpdma, VPDMA_LIST_ATTR,
> +			(list_num << VPDMA_LIST_NUM_SHFT) |
> +			(list->type << VPDMA_LIST_TYPE_SHFT) |
> +			list_size);
> +
> +	return 0;
> +}
> +
> +/* set or clear the mask for list complete interrupt */
> +void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
> +		bool enable)
> +{
> +	u32 val;
> +
> +	val = read_reg(vpdma, VPDMA_INT_LIST0_MASK);
> +	if (enable)
> +		val |= (1 << (list_num * 2));
> +	else
> +		val &= ~(1 << (list_num * 2));
> +	write_reg(vpdma, VPDMA_INT_LIST0_MASK, val);
> +}
> +
> +/* clear previosuly occured list intterupts in the LIST_STAT register */
> +void vpdma_clear_list_stat(struct vpdma_data *vpdma)
> +{
> +	write_reg(vpdma, VPDMA_INT_LIST0_STAT,
> +		read_reg(vpdma, VPDMA_INT_LIST0_STAT));
> +}
> +
> +/*
> + * configures the output mode of the line buffer for the given client, the
> + * line buffer content can either be mirrored(each line repeated twice) or
> + * passed to the client as is
> + */
> +void vpdma_set_line_mode(struct vpdma_data *vpdma, int line_mode,
> +		enum vpdma_channel chan)
> +{
> +	int client_cstat = chan_info[chan].cstat_offset;
> +
> +	insert_field_reg(vpdma, client_cstat, line_mode,
> +		VPDMA_CSTAT_LINE_MODE_MASK, VPDMA_CSTAT_LINE_MODE_SHIFT);
> +}
> +
> +/*
> + * configures the event which should trigger VPDMA transfer for the given
> + * client
> + */
> +void vpdma_set_frame_start_event(struct vpdma_data *vpdma,
> +		enum vpdma_frame_start_event fs_event,
> +		enum vpdma_channel chan)
> +{
> +	int client_cstat = chan_info[chan].cstat_offset;
> +
> +	insert_field_reg(vpdma, client_cstat, fs_event,
> +		VPDMA_CSTAT_FRAME_START_MASK, VPDMA_CSTAT_FRAME_START_SHIFT);
> +}
> +
> +static void vpdma_firmware_cb(const struct firmware *f, void *context)
> +{
> +	struct vpdma_data *vpdma = context;
> +	struct vpdma_buf fw_dma_buf;
> +	int i, r;
> +
> +	dev_dbg(&vpdma->pdev->dev, "firmware callback\n");
> +
> +	if (!f || !f->data) {
> +		dev_err(&vpdma->pdev->dev, "couldn't get firmware\n");
> +		return;
> +	}
> +
> +	/* already initialized */
> +	if (get_field_reg(vpdma, VPDMA_LIST_ATTR, VPDMA_LIST_RDY_MASK,
> +			VPDMA_LIST_RDY_SHFT)) {
> +		vpdma->ready = true;
> +		return;
> +	}
> +
> +	r = vpdma_buf_alloc(&fw_dma_buf, f->size);
> +	if (r) {
> +		dev_err(&vpdma->pdev->dev,
> +			"failed to allocate dma buffer for firmware\n");
> +		goto rel_fw;
> +	}
> +
> +	memcpy(fw_dma_buf.addr, f->data, f->size);
> +
> +	vpdma_buf_map(vpdma, &fw_dma_buf);
> +
> +	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) fw_dma_buf.dma_addr);
> +
> +	for (i = 0; i < 100; i++) {		/* max 1 second */
> +		msleep_interruptible(10);
> +
> +		if (get_field_reg(vpdma, VPDMA_LIST_ATTR, VPDMA_LIST_RDY_MASK,
> +				VPDMA_LIST_RDY_SHFT))
> +			break;
> +	}
> +
> +	if (i == 100) {
> +		dev_err(&vpdma->pdev->dev, "firmware upload failed\n");
> +		goto free_buf;
> +	}
> +
> +	vpdma->ready = true;
> +
> +free_buf:
> +	vpdma_buf_unmap(vpdma, &fw_dma_buf);
> +
> +	vpdma_buf_free(&fw_dma_buf);
> +rel_fw:
> +	release_firmware(f);
> +}
> +
> +static int vpdma_load_firmware(struct vpdma_data *vpdma)
> +{
> +	int r;
> +	struct device *dev = &vpdma->pdev->dev;
> +
> +	r = request_firmware_nowait(THIS_MODULE, 1,
> +		(const char *) VPDMA_FIRMWARE, dev, GFP_KERNEL, vpdma,
> +		vpdma_firmware_cb);

Is there a reason not to use the synchronous interface ? That would simplify 
both this code and the callers, as they won't have to check whether the 
firmware has been correctly loaded.
> +	if (r) {
> +		dev_err(dev, "firmware not available %s\n", VPDMA_FIRMWARE);
> +		return r;
> +	} else {
> +		dev_info(dev, "loading firmware %s\n", VPDMA_FIRMWARE);
> +	}
> +
> +	return 0;
> +}
> +
> +int vpdma_init(struct platform_device *pdev, struct vpdma_data **pvpdma)

As the function allocates the vpdma instance, I would call it vpdma_create()  
and make it turn a struct vpdma_data *. You can then return error codes using 
ERR_PTR().

> +{
> +	struct resource *res;
> +	struct vpdma_data *vpdma;
> +	int r;
> +
> +	dev_dbg(&pdev->dev, "vpdma_init\n");
> +
> +	vpdma = devm_kzalloc(&pdev->dev, sizeof(*vpdma), GFP_KERNEL);
> +	if (!vpdma) {
> +		dev_err(&pdev->dev, "couldn't alloc vpdma_dev\n");
> +		return -ENOMEM;
> +	}
> +
> +	vpdma->pdev = pdev;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpdma");
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "missing platform resources data\n");
> +		return -ENODEV;
> +	}
> +
> +	vpdma->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));

You can use devm_ioremap_resource(). The function checks the res pointer and 
prints error messages, so you can remove the res == NULL check above and the 
dev_err() below.

> +	if (!vpdma->base) {
> +		dev_err(&pdev->dev, "failed to ioremap\n");
> +		return -ENOMEM;
> +	}
> +
> +	r = vpdma_load_firmware(vpdma);
> +	if (r) {
> +		pr_err("failed to load firmware %s\n", VPDMA_FIRMWARE);
> +		return r;
> +	}
> +
> +	*pvpdma = vpdma;
> +
> +	return 0;
> +}
> +MODULE_FIRMWARE(VPDMA_FIRMWARE);

-- 
Regards,

Laurent Pinchart

