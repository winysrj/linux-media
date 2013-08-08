Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47201 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966702Ab3HHVeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 17:34:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Archit Taneja <archit@ti.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	dagriego@biglakesoftware.com, dale@farnsworth.org,
	pawel@osciak.com, m.szyprowski@samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 1/6] v4l: ti-vpe: Create a vpdma helper library
Date: Thu, 08 Aug 2013 23:35:15 +0200
Message-ID: <3105630.O8pg1OPHiU@avalon>
In-Reply-To: <51FF8BF6.3060900@ti.com>
References: <1375452223-30524-1-git-send-email-archit@ti.com> <51FF5EB4.8090007@ti.com> <51FF8BF6.3060900@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Archit,

On Monday 05 August 2013 16:56:46 Archit Taneja wrote:
> On Monday 05 August 2013 01:43 PM, Tomi Valkeinen wrote:
> > On 02/08/13 17:03, Archit Taneja wrote:
> >> +struct vpdma_data_format vpdma_yuv_fmts[] = {
> >> +	[VPDMA_DATA_FMT_Y444] = {
> >> +		.data_type	= DATA_TYPE_Y444,
> >> +		.depth		= 8,
> >> +	},
> > 
> > This, and all the other tables, should probably be consts?
> 
> That's true, I'll fix those.
> 
> >> +static void insert_field(u32 *valp, u32 field, u32 mask, int shift)
> >> +{
> >> +	u32 val = *valp;
> >> +
> >> +	val &= ~(mask << shift);
> >> +	val |= (field & mask) << shift;
> >> +	*valp = val;
> >> +}
> > 
> > I think "insert" normally means, well, inserting a thing in between
> > something. What you do here is overwriting.
> > 
> > Why not just call it "write_field"?
> 
> sure, will change it.
> 
> >> + * Allocate a DMA buffer
> >> + */
> >> +int vpdma_buf_alloc(struct vpdma_buf *buf, size_t size)
> >> +{
> >> +	buf->size = size;
> >> +	buf->mapped = 0;
> > 
> > Maybe true/false is clearer here that 0/1.
> 
> okay.
> 
> >> +/*
> >> + * submit a list of DMA descriptors to the VPE VPDMA, do not wait for
> >> completion + */
> >> +int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list
> >> *list) +{
> >> +	/* we always use the first list */
> >> +	int list_num = 0;
> >> +	int list_size;
> >> +
> >> +	if (vpdma_list_busy(vpdma, list_num))
> >> +		return -EBUSY;
> >> +
> >> +	/* 16-byte granularity */
> >> +	list_size = (list->next - list->buf.addr) >> 4;
> >> +
> >> +	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) list->buf.dma_addr);
> >> +	wmb();
> > 
> > What is the wmb() for?
> 
> VPDMA_LIST_ADDR needs to be written before VPDMA_LIST_ATTR, otherwise
> VPDMA doesn't work. wmb() ensures the ordering.

write_reg() calls iowrite32(), which already includes an __iowmb().

> >> +	write_reg(vpdma, VPDMA_LIST_ATTR,
> >> +			(list_num << VPDMA_LIST_NUM_SHFT) |
> >> +			(list->type << VPDMA_LIST_TYPE_SHFT) |
> >> +			list_size);
> >> +
> >> +	return 0;
> >> +}
> >> 
> >> +static void vpdma_firmware_cb(const struct firmware *f, void *context)
> >> +{
> >> +	struct vpdma_data *vpdma = context;
> >> +	struct vpdma_buf fw_dma_buf;
> >> +	int i, r;
> >> +
> >> +	dev_dbg(&vpdma->pdev->dev, "firmware callback\n");
> >> +
> >> +	if (!f || !f->data) {
> >> +		dev_err(&vpdma->pdev->dev, "couldn't get firmware\n");
> >> +		return;
> >> +	}
> >> +
> >> +	/* already initialized */
> >> +	if (get_field_reg(vpdma, VPDMA_LIST_ATTR, VPDMA_LIST_RDY_MASK,
> >> +			VPDMA_LIST_RDY_SHFT)) {
> >> +		vpdma->ready = true;
> >> +		return;
> >> +	}
> >> +
> >> +	r = vpdma_buf_alloc(&fw_dma_buf, f->size);
> >> +	if (r) {
> >> +		dev_err(&vpdma->pdev->dev,
> >> +			"failed to allocate dma buffer for firmware\n");
> >> +		goto rel_fw;
> >> +	}
> >> +
> >> +	memcpy(fw_dma_buf.addr, f->data, f->size);
> >> +
> >> +	vpdma_buf_map(vpdma, &fw_dma_buf);
> >> +
> >> +	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) fw_dma_buf.dma_addr);
> >> +
> >> +	for (i = 0; i < 100; i++) {		/* max 1 second */
> >> +		msleep_interruptible(10);
> > 
> > You call interruptible version here, but you don't handle the
> > interrupted case. I believe the loop will just continue looping, even if
> > the user interrupted.
> 
> Okay. I think I don't understand the interruptible version correctly. We
> don't need to msleep_interruptible here, we aren't waiting on any wake
> up event, we just want to wait till a bit gets set.
> 
> I am thinking of implementing something similar to wait_for_bit_change()
> in 'drivers/video/omap2/dss/dsi.c'

-- 
Regards,

Laurent Pinchart

