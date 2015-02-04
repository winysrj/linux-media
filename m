Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35536 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149AbbBDLjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 06:39:46 -0500
Message-ID: <54D204F2.3040006@xs4all.nl>
Date: Wed, 04 Feb 2015 12:39:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Florian Echtler <floe@butterbrot.org>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <54D1F2CA.9020201@xs4all.nl> <54D1FAFA.3070506@butterbrot.org> <10701805.dDfTQCs2MO@avalon>
In-Reply-To: <10701805.dDfTQCs2MO@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/04/15 12:34, Laurent Pinchart wrote:
> Hi Florian,
> 
> On Wednesday 04 February 2015 11:56:58 Florian Echtler wrote:
>> On 04.02.2015 11:22, Hans Verkuil wrote:
>>> On 02/04/15 11:08, Florian Echtler wrote:
>>>> On 04.02.2015 09:08, Hans Verkuil wrote:
>>>>> You can also make a version with vmalloc and I'll merge that, and then
>>>>> you can look more into the DMA issues. That way the driver is merged,
>>>>> even if it is perhaps not yet optimal, and you can address that part
>>>>> later.
>>>>
>>>> OK, that sounds sensible, I will try that route. When using
>>>> videobuf2-vmalloc, what do I pass back for alloc_ctxs in queue_setup?
>>>
>>> vmalloc doesn't need those, so you can just drop any alloc_ctx related
>>> code.
>>
>> That's what I assumed, however, I'm running into the same problem as
>> with dma-sg when I switch to vmalloc...?
> 
> I don't expect vmalloc to work, as you can't DMA to vmalloc memory directly 
> without any IOMMU in the general case (the allocated memory being physically 
> fragmented).
> 
> dma-sg should work though, but you won't be able to use usb_bulk_msg(). You 
> need to create the URBs manually, set their sg and num_sgs fields and submit 
> them.

So it works for other usb media drivers because they allocate memory
using kmalloc (and presumably the usb core can DMA to that), and then memcpy
it to the vmalloc-ed buffers?

Anyway Florian, based on Laurent's explanation I think trying to make
dma-sg work seems to be the best solution. And I've learned something
new :-)

Regards,

	Hans

> 
>> I've sent a "proper" patch submission again, which has all the other
>> issues from the previous submission fixed. I'm hoping you can maybe have
>> a closer look and see if I'm doing anything subtly wrong which causes
>> both vmalloc and dma-sg to fail while dma-contig works.
> 

