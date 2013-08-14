Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55571 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759580Ab3HNKVF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 06:21:05 -0400
Message-ID: <520B59C6.8060900@ti.com>
Date: Wed, 14 Aug 2013 15:49:50 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	<linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<dagriego@biglakesoftware.com>, <dale@farnsworth.org>,
	<pawel@osciak.com>, <m.szyprowski@samsung.com>,
	<hverkuil@xs4all.nl>
Subject: Re: [PATCH 1/6] v4l: ti-vpe: Create a vpdma helper library
References: <1375452223-30524-1-git-send-email-archit@ti.com> <51FF5EB4.8090007@ti.com> <51FF8BF6.3060900@ti.com> <3105630.O8pg1OPHiU@avalon>
In-Reply-To: <3105630.O8pg1OPHiU@avalon>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 09 August 2013 03:05 AM, Laurent Pinchart wrote:
> Hi Archit,
>
> On Monday 05 August 2013 16:56:46 Archit Taneja wrote:
>> On Monday 05 August 2013 01:43 PM, Tomi Valkeinen wrote:
>>> On 02/08/13 17:03, Archit Taneja wrote:
>>>> +struct vpdma_data_format vpdma_yuv_fmts[] = {
>>>> +	[VPDMA_DATA_FMT_Y444] = {
>>>> +		.data_type	= DATA_TYPE_Y444,
>>>> +		.depth		= 8,
>>>> +	},
>>>
>>> This, and all the other tables, should probably be consts?
>>
>> That's true, I'll fix those.
>>
>>>> +static void insert_field(u32 *valp, u32 field, u32 mask, int shift)
>>>> +{
>>>> +	u32 val = *valp;
>>>> +
>>>> +	val &= ~(mask << shift);
>>>> +	val |= (field & mask) << shift;
>>>> +	*valp = val;
>>>> +}
>>>
>>> I think "insert" normally means, well, inserting a thing in between
>>> something. What you do here is overwriting.
>>>
>>> Why not just call it "write_field"?
>>
>> sure, will change it.
>>
>>>> + * Allocate a DMA buffer
>>>> + */
>>>> +int vpdma_buf_alloc(struct vpdma_buf *buf, size_t size)
>>>> +{
>>>> +	buf->size = size;
>>>> +	buf->mapped = 0;
>>>
>>> Maybe true/false is clearer here that 0/1.
>>
>> okay.
>>
>>>> +/*
>>>> + * submit a list of DMA descriptors to the VPE VPDMA, do not wait for
>>>> completion + */
>>>> +int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list
>>>> *list) +{
>>>> +	/* we always use the first list */
>>>> +	int list_num = 0;
>>>> +	int list_size;
>>>> +
>>>> +	if (vpdma_list_busy(vpdma, list_num))
>>>> +		return -EBUSY;
>>>> +
>>>> +	/* 16-byte granularity */
>>>> +	list_size = (list->next - list->buf.addr) >> 4;
>>>> +
>>>> +	write_reg(vpdma, VPDMA_LIST_ADDR, (u32) list->buf.dma_addr);
>>>> +	wmb();
>>>
>>> What is the wmb() for?
>>
>> VPDMA_LIST_ADDR needs to be written before VPDMA_LIST_ATTR, otherwise
>> VPDMA doesn't work. wmb() ensures the ordering.
>
> write_reg() calls iowrite32(), which already includes an __iowmb().

I wasn't aware of that. I'll remove the wmb() call. Thanks for sharing 
this info.

Archit

