Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48193 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbbBDIJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 03:09:10 -0500
Message-ID: <54D1D37C.20701@xs4all.nl>
Date: Wed, 04 Feb 2015 09:08:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] add raw video support for Samsung SUR40 touchscreen
References: <1420626920-9357-1-git-send-email-floe@butterbrot.org> <64652239.MTTlcOgNK2@avalon> <54BE5204.3020600@xs4all.nl> <6025823.veVKIskIW2@avalon> <54BFA989.4090405@butterbrot.org> <54BFA9D6.1040201@xs4all.nl> <54CAA786.2040908@butterbrot.org> <54D13383.7010603@butterbrot.org>
In-Reply-To: <54D13383.7010603@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On 02/03/2015 09:45 PM, Florian Echtler wrote:
> Sorry to bring this up again, but would it be acceptable to simply use
> dma-contig after all? Since the GFP_DMA flag is gone, this shouldn't be
> too big of an issue IMHO, and I was kind of hoping the patch could still
> be part of 3.20.

The window for 3.20 is closed, I'm afraid.

I remain very skeptical about the use of dma-contig (or dma-sg for that
matter). Have you tried using vmalloc and check if the USB core isn't
automatically using DMA transfers for that?

Basically I would like to see proof that vmalloc is not an option before
allowing dma-contig (or dma-sg if you can figure out why that isn't
working).

You can also make a version with vmalloc and I'll merge that, and then
you can look more into the DMA issues. That way the driver is merged,
even if it is perhaps not yet optimal, and you can address that part later.

Regards,

	Hans

> 
> Best, Florian
> 
> On 29.01.2015 22:35, Florian Echtler wrote:
>> I'm still having a couple of issues sorting out the correct way to
>> provide DMA access for my driver. I've integrated most of your
>> suggestions, but I still can't switch from dma-contig to dma-sg.
>> As far as I understood it, there is no further initialization required
>> besides using vb2_dma_sg_memops, vb2_dma_sg_init_ctx and
>> vb2_dma_sg_cleanup_ctx instead of the respective -contig- calls, correct?
>> However, as soon as I swap the relevant function calls, the video image
>> stays black and in dmesg, I get the following warning:
>>
>> Call Trace:
>> [<ffffffff817c4584>] dump_stack+0x45/0x57
>> [<ffffffff81076df7>] warn_slowpath_common+0x97/0xe0
>> [<ffffffff81076ef6>] warn_slowpath_fmt+0x46/0x50
>> [<ffffffff815aff0b>] usb_hcd_map_urb_for_dma+0x4eb/0x500
>> [<ffffffff817d03b4>] ? schedule_timeout+0x124/0x210
>> [<ffffffff815b0bd5>] usb_hcd_submit_urb+0x135/0x1c0
>> [<ffffffff815b20a6>] usb_submit_urb.part.8+0x1f6/0x580
>> [<ffffffff811bb542>] ? vmap_pud_range+0x122/0x1c0
>> [<ffffffff815b2465>] usb_submit_urb+0x35/0x80
>> [<ffffffff815b339a>] usb_start_wait_urb+0x6a/0x170
>> [<ffffffff815b1cce>] ? usb_alloc_urb+0x1e/0x50
>> [<ffffffff815b1cce>] ? usb_alloc_urb+0x1e/0x50
>> [<ffffffff815b3570>] usb_bulk_msg+0xd0/0x1a0
>> [<ffffffffc059a841>] sur40_poll+0x561/0x5e0 [sur40]
>>
>> Moreover, I'm getting the following test failure from v4l2-compliance:
>>
>> Streaming ioctls:
>> 	test read/write: OK
>> 	test MMAP: OK
>> 		fail: v4l2-test-buffers.cpp(951): buf.qbuf(node)
>> 		fail: v4l2-test-buffers.cpp(994): setupUserPtr(node, q)
>> 	test USERPTR: FAIL
>> 	test DMABUF: Cannot test, specify --expbuf-device
>>
>> Total: 45, Succeeded: 44, Failed: 1, Warnings: 0
> 
> 

