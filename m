Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:59541 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbcDYH0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 03:26:10 -0400
Subject: Re: [PATCHv3 01/12] vb2: add a dev field to use for the default
 allocation context
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1461314299-36126-1-git-send-email-hverkuil@xs4all.nl>
 <2941455.gjxYJiS6KM@avalon> <571B5056.9030508@xs4all.nl>
 <2315180.nFEM82KaAP@avalon>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Florian Echtler <floe@butterbrot.org>,
	Federico Vaga <federico.vaga@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Benoit Parrot <bparrot@ti.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571DC685.1040901@xs4all.nl>
Date: Mon, 25 Apr 2016 09:25:57 +0200
MIME-Version: 1.0
In-Reply-To: <2315180.nFEM82KaAP@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/2016 11:51 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Saturday 23 Apr 2016 12:37:10 Hans Verkuil wrote:
>> On 04/23/2016 02:14 AM, Laurent Pinchart wrote:
>>> On Friday 22 Apr 2016 10:38:08 Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> The allocation context is nothing more than a per-plane device pointer
>>>> to use when allocating buffers. So just provide a dev pointer in
>>>> vb2_queue for that purpose and drivers can skip
>>>> allocating/releasing/filling in the allocation context unless they
>>>> require different per-plane device pointers as used by some Samsung
>>>> SoCs.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
>>>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>>>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>> Cc: Florian Echtler <floe@butterbrot.org>
>>>> Cc: Federico Vaga <federico.vaga@gmail.com>
>>>> Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
>>>> Cc: Philipp Zabel <p.zabel@pengutronix.de>
>>>> Cc: Fabien Dessenne <fabien.dessenne@st.com>
>>>> Cc: Benoit Parrot <bparrot@ti.com>
>>>> Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
>>>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>>> Cc: Javier Martin <javier.martin@vista-silicon.com>
>>>> Cc: Jonathan Corbet <corbet@lwn.net>
>>>> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
>>>> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>>> Cc: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> ---
>>>>
>>>>  drivers/media/v4l2-core/videobuf2-core.c | 16 +++++++++-------
>>>>  include/media/videobuf2-core.h           |  3 +++
>>>>  2 files changed, 12 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>>>> b/drivers/media/v4l2-core/videobuf2-core.c index 5d016f4..88b5e48 100644
>>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>>> @@ -206,8 +206,9 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>>>
>>>>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>>>>  	
>>>>  		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
>>>>
>>>> -		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
>>>> -				      size, dma_dir, q->gfp_flags);
>>>> +		mem_priv = call_ptr_memop(vb, alloc,
>>>> +				q->alloc_ctx[plane] ? : &q->dev,
>>>> +				size, dma_dir, q->gfp_flags);
>>>
>>> While the videobuf2-dma-sg allocation context indeed only contains a
>>> pointer to the device, the videobuf2-dma-contig context also contains a
>>> dma_attrs. This patch will break the videobuf2-dma-contig alloc
>>> implementation.
>>
>> Good point. I fixed this in the last patch, but that would mean dma-contig
>> would be broken for the patches in between.
>>
>> I'm moving dma_attrs to struct vb2_queue as the first patch, then the rest
>> will work fine.
> 
> Couldn't a driver require different dma attributes per plane ? Would it make 
> sense to keep the allocation context structure, and use the struct device and 
> dma attributes stored in the queue when no allocation context is provided ?

I kept the dma_attrs part simple for two reasons:

1) No driver in the kernel uses it.
2) I really can't think of any scenario where you get different DMA attrs per plane.
   Perhaps if we make it possible to have a variable number of planes, but all
   that is in the future and I rather take care of it when we actually know what
   we need.

The 'allocation context' idea was simply a bad one: you're stuck with void pointers
(I hate those) and always having to check for ENOMEM when allocating them. When all
you need in almost all cases is just a device pointer.

Regards,

	Hans
