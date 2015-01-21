Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:35404 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323AbbAUNbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2015 08:31:03 -0500
Message-ID: <54BFA9D6.1040201@xs4all.nl>
Date: Wed, 21 Jan 2015 14:29:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <64652239.MTTlcOgNK2@avalon> <54BE5204.3020600@xs4all.nl> <6025823.veVKIskIW2@avalon> <54BFA989.4090405@butterbrot.org>
In-Reply-To: <54BFA989.4090405@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/15 14:28, Florian Echtler wrote:
> Hello everyone,
> 
> On 20.01.2015 14:06, Laurent Pinchart wrote:
>> On Tuesday 20 January 2015 14:03:00 Hans Verkuil wrote:
>>> On 01/20/15 13:59, Laurent Pinchart wrote:
>>>> On Tuesday 20 January 2015 10:30:07 Hans Verkuil wrote:
>>>>> I've CC-ed Laurent, I think he knows a lot more about this than I do.
>>>>>
>>>>> Laurent, when does the USB core use DMA? What do you need to do on the
>>>>> driver side to have USB use DMA when doing bulk transfers?
>>>>
>>>> How USB HCD drivers map buffers for DMA is HCD-specific, but all drivers
>>>> exepct ehci-tegra, max3421-hcd and musb use the default implementation
>>>> usb_hcd_map_urb_for_dma() (in drivers/usb/core/hcd.c).
>>>>
>>>> Unless the buffer has already been mapped by the USB driver (in which case
>>>> the driver will have set the URB_NO_TRANSFER_DMA_MAP flag in
>>>> urb->transfer_flags and initialized the urb->transfer_dma field), the
>>>> function will use dma_map_sg(), dma_map_page() or dma_map_single()
>>>> depending on the buffer type (controlled through urb->sg and
>>>> urb->num_sgs). DMA will thus always be used *expect* if the platform uses
>>>> bounce buffers when the buffer can't be mapped directly for DMA.
>>>
>>> So we can safely use videobuf2-vmalloc, right?
>>
>> That depends on the platform and whether it can DMA to vmalloc'ed memory :-) 
>> To be totally safe I think vb2-dma-sg would be better, but I'm not sure it's 
>> worth the trouble. uvcvideo uses vb2-vmalloc as it performs a memcpy anyway.
> 
> The SUR40 sends raw video data without any headers over the bulk
> endpoint in blocks of 16k, so I'm assuming that in this specific case,
> vb2-dma-sg would be the most efficient choice?
> 
> On that note, I've seen that vb2_dma_sg_{init|cleanup}_ctx will appear
> only in 3.19. If I want to maintain a backwards-compatible version for
> older kernels, what do I use in that case?

Easiest would actually be to copy all the videobuf2 sources and headers
to that older kernel.

Obviously, for upstreaming you should always use the latest APIs and
never use backwards-compatible constructs.

Regards,

	Hans

