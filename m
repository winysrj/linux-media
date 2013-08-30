Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36845 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab3H3KGE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 06:06:04 -0400
Message-ID: <52206E57.4080300@ti.com>
Date: Fri, 30 Aug 2013 15:35:11 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
	<tomi.valkeinen@ti.com>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 3/6] v4l: ti-vpe: Add VPE mem to mem driver
References: <1376996457-17275-1-git-send-email-archit@ti.com> <1377779572-22624-1-git-send-email-archit@ti.com> <1377779572-22624-4-git-send-email-archit@ti.com> <201308291528.21281.hverkuil@xs4all.nl> <5220400F.60705@ti.com> <522044AE.1080501@xs4all.nl>
In-Reply-To: <522044AE.1080501@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 30 August 2013 12:37 PM, Hans Verkuil wrote:
> On 08/30/2013 08:47 AM, Archit Taneja wrote:
>> On Thursday 29 August 2013 06:58 PM, Hans Verkuil wrote:
>>> On Thu 29 August 2013 14:32:49 Archit Taneja wrote:
>>>> VPE is a block which consists of a single memory to memory path which can
>>>> perform chrominance up/down sampling, de-interlacing, scaling, and color space
>>>> conversion of raster or tiled YUV420 coplanar, YUV422 coplanar or YUV422
>>>> interleaved video formats.
>>>>
>>>> We create a mem2mem driver based primarily on the mem2mem-testdev example.
>>>> The de-interlacer, scaler and color space converter are all bypassed for now
>>>> to keep the driver simple. Chroma up/down sampler blocks are implemented, so
>>>> conversion beteen different YUV formats is possible.
>>>>
>>>> Each mem2mem context allocates a buffer for VPE MMR values which it will use
>>>> when it gets access to the VPE HW via the mem2mem queue, it also allocates
>>>> a VPDMA descriptor list to which configuration and data descriptors are added.
>>>>
>>>> Based on the information received via v4l2 ioctls for the source and
>>>> destination queues, the driver configures the values for the MMRs, and stores
>>>> them in the buffer. There are also some VPDMA parameters like frame start and
>>>> line mode which needs to be configured, these are configured by direct register
>>>> writes via the VPDMA helper functions.
>>>>
>>>> The driver's device_run() mem2mem op will add each descriptor based on how the
>>>> source and destination queues are set up for the given ctx, once the list is
>>>> prepared, it's submitted to VPDMA, these descriptors when parsed by VPDMA will
>>>> upload MMR registers, start DMA of video buffers on the various input and output
>>>> clients/ports.
>>>>
<snip>

>>
>>>> +}
>>>> +
>>>> +#define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_USER_BASE + 0x1000)
>>>
>>> Reserve a control range for this driver in include/uapi/linux/v4l2-controls.h.
>>> Similar to the ones already defined there.
>>>
>>> That will ensure that controls for this driver have unique IDs.
>>
>> Thanks, I took this from the mem2mem-testdev driver, a test driver
>> doesn't need to worry about this I suppose.
>>
>> I had a query regarding this. I am planning to add a capture driver in
>> the future for a similar IP which can share some of the control IDs with
>> VPE. Is it possible for 2 different drivers to share the IDs?
>
> Certainly. There are three levels of controls:
>
> 1) Standard controls: can be used by any driver and are documented in the spec.
> 2) IP-specific controls: controls specific for a commonly used IP.
>     These can be used by any driver containing that IP and are documented as well
>     in the spec. Good examples are the MFC and CX2341x MPEG controls.
> 3) Driver-specific controls: these are specific to a driver and do not have to be
>     documented in the spec, only in the header/source specifying them. A range
>     of controls needs to be assigned to such a driver in v4l2-dv-controls.h.
>
> In your case it looks like the controls would fall into category 2.

For 2), by commonly used IP, do you mean a commonly used class of IPs 
like MPEG decoder, FM and camera? Or do you mean a specific vendor IP 
like say a camera subsystem found on different SoCs.

I think the controls in my case are very specific to the VPE and VIP 
IPs. These 2 IPs have some components like scaler, color space 
converter, chrominance up/downsampler in common. The controls will be 
specific to how these components behave. For example, a control can tell 
what value of frequency of Luminance peaking the scaler needs to 
perform. I don't think all scalers would provide Luma peaking. This 
holds for other controls too.

So if I understood your explanation correctly, I think 3) might make 
more sense.

>
>> Also, I noticed in the header that most drivers reserve space for 16
>> IDs. The current driver just has one, but there will be more custom ones
>> in the future. Is it fine if I reserve 16 for this driver too?
>
> Sure, that's no problem. Make sure you reserve enough space for future
> expansion, i.e. IDs are cheap, so no need to be conservative when defining
> the range.

Thanks for the clarification.

Archit

