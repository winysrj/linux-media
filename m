Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58095 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbaLPNH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 08:07:26 -0500
Message-ID: <54902E36.1060005@xs4all.nl>
Date: Tue, 16 Dec 2014 14:05:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
Subject: Re: [RFC] video support for Samsung SUR40
References: <548F029C.20907@butterbrot.org> <548F05EF.8080700@xs4all.nl> <548F5D6E.4070907@butterbrot.org> <548F6205.6000305@xs4all.nl> <5490271F.1060609@butterbrot.org>
In-Reply-To: <5490271F.1060609@butterbrot.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On 12/16/14 13:35, Florian Echtler wrote:
> On 15.12.2014 23:34, Hans Verkuil wrote:
>> On 12/15/2014 11:15 PM, Florian Echtler wrote:
>>> On 15.12.2014 17:01, Hans Verkuil wrote:
>>>> On 12/15/2014 04:47 PM, Florian Echtler wrote:
>>>> Why on earth is sur40_poll doing anything with video buffers? That's
>>>> all handled by vb2. As far as I can tell you can just delete everything
>>>> from '// deal with video data here' until the end of the poll function.
>>> Right now, the code doesn't do anything, but I'm planning to add the
>>> actual data retrieval at this point later. I'd like to use the
>>> input_polldev thread for this, as a) the video data should be fetched
>>> synchronously with the input device data and b) the thread will be
>>> running continuously anyway.
>> Ah, now I see it.
> One additional question you might be able to answer: if I use
> vb2_dma_contig_init_ctx for the allocator context, will usb_bulk_msg
> with a vb2_buffer then automatically use DMA?

No, it won't.

> I want to avoid
> unnecessary memcpy operations, so ideally the USB host controller should
> directly put the data into the buffer which is then passed to userspace.
> Does this require any additional setup?

I don't think you can do that since the USB packets need to be unpacked
(header stripped off, etc.), so you need to do a memcpy anyway. I'm no
USB expert, but it is my understanding that you always need to memcpy.

So it probably makes more sense for you to use videobuf2-vmalloc instead
of dma-contig since there is no requirement for physically contiguous
memory. All V4L2 USB drivers that I know off all use vb2-vmalloc.

Regards,

	Hans

> 
>>>> But, as I said, that code doesn't belong there at all, so just remove it.
>>> See above - that was actually intentional. It's kind of a hackish
>>> solution, but for the moment, I'd just like to get a video stream with
>>> minimal overhead, so I'm reusing the polldev thread.
>> OK. If you are planning to upstream this driver, then this probably needs
>> another look.
> Once I get it working, I'll submit a patch for further discussion.
> 
> Best, Florian
> 

