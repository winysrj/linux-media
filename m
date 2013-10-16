Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:35057 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab3JPFJJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 01:09:09 -0400
Message-ID: <525E1F36.6080101@ti.com>
Date: Wed, 16 Oct 2013 10:38:06 +0530
From: Archit Taneja <archit@ti.com>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v5 3/4] v4l: ti-vpe: Add VPE mem to mem driver
References: <1378462346-10880-1-git-send-email-archit@ti.com> <1381328975-18244-1-git-send-email-archit@ti.com> <5257ACD1.9010501@xs4all.nl> <525D477F.10606@ti.com> <525D487B.1000903@xs4all.nl> <05c401cec9be$e0fbf160$a2f3d420$%debski@samsung.com>
In-Reply-To: <05c401cec9be$e0fbf160$a2f3d420$%debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tuesday 15 October 2013 09:24 PM, Kamil Debski wrote:
> Hi Archit,
>
> Please find my comment below.
>
>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>> Sent: Tuesday, October 15, 2013 3:52 PM
>>
>> Kamil,
>>
>> Can you take this driver as m2m maintainer or should I take it?
>>
>> Regards,
>>
>> 	Hans
>>
>> On 10/15/2013 03:47 PM, Archit Taneja wrote:
>>> Hi Hans,
>>>
>>> On Friday 11 October 2013 01:16 PM, Hans Verkuil wrote:
>>>> On 10/09/2013 04:29 PM, Archit Taneja wrote:
>>>>> VPE is a block which consists of a single memory to memory path
>>>>> which can perform chrominance up/down sampling, de-interlacing,
>>>>> scaling, and color space conversion of raster or tiled YUV420
>>>>> coplanar, YUV422 coplanar or YUV422 interleaved video formats.
>>>>>
>>>>> We create a mem2mem driver based primarily on the mem2mem-testdev
>> example.
>>>>> The de-interlacer, scaler and color space converter are all
>> bypassed
>>>>> for now to keep the driver simple. Chroma up/down sampler blocks
>> are
>>>>> implemented, so conversion beteen different YUV formats is possible.
>>>>>
>>>>> Each mem2mem context allocates a buffer for VPE MMR values which it
>>>>> will use when it gets access to the VPE HW via the mem2mem queue,
>> it
>>>>> also allocates a VPDMA descriptor list to which configuration and
>> data descriptors are added.
>>>>>
>>>>> Based on the information received via v4l2 ioctls for the source
>> and
>>>>> destination queues, the driver configures the values for the MMRs,
>>>>> and stores them in the buffer. There are also some VPDMA parameters
>>>>> like frame start and line mode which needs to be configured, these
>>>>> are configured by direct register writes via the VPDMA helper
>> functions.
>>>>>
>>>>> The driver's device_run() mem2mem op will add each descriptor based
>>>>> on how the source and destination queues are set up for the given
>>>>> ctx, once the list is prepared, it's submitted to VPDMA, these
>>>>> descriptors when parsed by VPDMA will upload MMR registers, start
>>>>> DMA of video buffers on the various input and output clients/ports.
>>>>>
>>>>> When the list is parsed completely(and the DMAs on all the output
>>>>> ports done), an interrupt is generated which we use to notify that
>>>>> the source and destination buffers are done.
>>>>>
>>>>> The rest of the driver is quite similar to other mem2mem drivers,
>> we
>>>>> use the multiplane v4l2 ioctls as the HW support coplanar formats.
>>>>>
>>>>> Signed-off-by: Archit Taneja <archit@ti.com>
>>>>
>>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>
>>> Thanks for the Acks. Is it possible to queue these for 3.13?
>
> Yep, it is possible. But [v4,4/4] v4l: ti-vpe: Add de-interlacer support in
> VPE does
> not apply after applying [v5,3/4] v4l: ti-vpe: Add VPE mem to mem driver.
>
> Please send a v5 with all patches.

Ah, sorry about that. There was a minor conflict with the updated patch. 
Will post out v5.

Thanks,
Archit

