Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2266 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab3H3HHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 03:07:49 -0400
Message-ID: <522044AE.1080501@xs4all.nl>
Date: Fri, 30 Aug 2013 09:07:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	tomi.valkeinen@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 3/6] v4l: ti-vpe: Add VPE mem to mem driver
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1377779572-22624-1-git-send-email-archit@ti.com> <1377779572-22624-4-git-send-email-archit@ti.com> <201308291528.21281.hverkuil@xs4all.nl> <5220400F.60705@ti.com>
In-Reply-To: <5220400F.60705@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2013 08:47 AM, Archit Taneja wrote:
> On Thursday 29 August 2013 06:58 PM, Hans Verkuil wrote:
>> On Thu 29 August 2013 14:32:49 Archit Taneja wrote:
>>> VPE is a block which consists of a single memory to memory path which can
>>> perform chrominance up/down sampling, de-interlacing, scaling, and color space
>>> conversion of raster or tiled YUV420 coplanar, YUV422 coplanar or YUV422
>>> interleaved video formats.
>>>
>>> We create a mem2mem driver based primarily on the mem2mem-testdev example.
>>> The de-interlacer, scaler and color space converter are all bypassed for now
>>> to keep the driver simple. Chroma up/down sampler blocks are implemented, so
>>> conversion beteen different YUV formats is possible.
>>>
>>> Each mem2mem context allocates a buffer for VPE MMR values which it will use
>>> when it gets access to the VPE HW via the mem2mem queue, it also allocates
>>> a VPDMA descriptor list to which configuration and data descriptors are added.
>>>
>>> Based on the information received via v4l2 ioctls for the source and
>>> destination queues, the driver configures the values for the MMRs, and stores
>>> them in the buffer. There are also some VPDMA parameters like frame start and
>>> line mode which needs to be configured, these are configured by direct register
>>> writes via the VPDMA helper functions.
>>>
>>> The driver's device_run() mem2mem op will add each descriptor based on how the
>>> source and destination queues are set up for the given ctx, once the list is
>>> prepared, it's submitted to VPDMA, these descriptors when parsed by VPDMA will
>>> upload MMR registers, start DMA of video buffers on the various input and output
>>> clients/ports.
>>>
>>> When the list is parsed completely(and the DMAs on all the output ports done),
>>> an interrupt is generated which we use to notify that the source and destination
>>> buffers are done.
>>>
>>> The rest of the driver is quite similar to other mem2mem drivers, we use the
>>> multiplane v4l2 ioctls as the HW support coplanar formats.
>>>
>>> Signed-off-by: Archit Taneja <archit@ti.com>
>>
>> Thanks for the patch. Just a few small comments below...
>>
>>> ---
>>>   drivers/media/platform/Kconfig           |   16 +
>>>   drivers/media/platform/Makefile          |    2 +
>>>   drivers/media/platform/ti-vpe/Makefile   |    5 +
>>>   drivers/media/platform/ti-vpe/vpe.c      | 1740 ++++++++++++++++++++++++++++++
>>>   drivers/media/platform/ti-vpe/vpe_regs.h |  496 +++++++++
>>>   5 files changed, 2259 insertions(+)
>>>   create mode 100644 drivers/media/platform/ti-vpe/Makefile
>>>   create mode 100644 drivers/media/platform/ti-vpe/vpe.c
>>>   create mode 100644 drivers/media/platform/ti-vpe/vpe_regs.h
>>>
>>> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
>>> new file mode 100644
>>> index 0000000..85b0880
>>> --- /dev/null
>>> +++ b/drivers/media/platform/ti-vpe/vpe.c
>>
>> <snip>
>>
>>> +static int vpe_enum_fmt(struct file *file, void *priv,
>>> +				struct v4l2_fmtdesc *f)
>>> +{
>>> +	if (V4L2_TYPE_IS_OUTPUT(f->type))
>>> +		return __enum_fmt(f, VPE_FMT_TYPE_OUTPUT);
>>> +	else
>>
>> The line above isn't necessary.
> 
> Oh right, thanks for spotting that.
> 
>>
>>> +		return __enum_fmt(f, VPE_FMT_TYPE_CAPTURE);
>>> +}
>>> +
> <snip>
> 
>>> +
>>> +	pix->field = V4L2_FIELD_NONE;
>>> +
>>> +	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, W_ALIGN,
>>> +			      &pix->height, MIN_H, MAX_H, H_ALIGN,
>>> +			      S_ALIGN);
>>> +
>>> +	pix->num_planes = fmt->coplanar ? 2 : 1;
>>> +	pix->pixelformat = fmt->fourcc;
>>> +	pix->colorspace = fmt->fourcc == V4L2_PIX_FMT_RGB24 ?
>>> +			V4L2_COLORSPACE_SRGB : V4L2_COLORSPACE_SMPTE170M;
>>
>> pix->priv should be set to NULL as well.
> 
> I'll fix this.
> 
> <snip>
> 
>>> +}
>>> +
>>> +#define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_USER_BASE + 0x1000)
>>
>> Reserve a control range for this driver in include/uapi/linux/v4l2-controls.h.
>> Similar to the ones already defined there.
>>
>> That will ensure that controls for this driver have unique IDs.
> 
> Thanks, I took this from the mem2mem-testdev driver, a test driver 
> doesn't need to worry about this I suppose.
> 
> I had a query regarding this. I am planning to add a capture driver in 
> the future for a similar IP which can share some of the control IDs with 
> VPE. Is it possible for 2 different drivers to share the IDs?

Certainly. There are three levels of controls:

1) Standard controls: can be used by any driver and are documented in the spec.
2) IP-specific controls: controls specific for a commonly used IP.
   These can be used by any driver containing that IP and are documented as well
   in the spec. Good examples are the MFC and CX2341x MPEG controls.
3) Driver-specific controls: these are specific to a driver and do not have to be
   documented in the spec, only in the header/source specifying them. A range
   of controls needs to be assigned to such a driver in v4l2-dv-controls.h.

In your case it looks like the controls would fall into category 2.

> Also, I noticed in the header that most drivers reserve space for 16 
> IDs. The current driver just has one, but there will be more custom ones 
> in the future. Is it fine if I reserve 16 for this driver too?

Sure, that's no problem. Make sure you reserve enough space for future
expansion, i.e. IDs are cheap, so no need to be conservative when defining
the range.

Regards,

	Hans
