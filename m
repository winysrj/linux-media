Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60523 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2LQI6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 03:58:19 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so6679060vby.19
        for <linux-media@vger.kernel.org>; Mon, 17 Dec 2012 00:58:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO_48GFBEEz1J_o=ZRcBh8rdFUj=eQ7Gr8s0sfL9RpHjZigamA@mail.gmail.com>
References: <1355477817-5750-1-git-send-email-sumit.semwal@ti.com>
 <50CB1442.50002@gmail.com> <CAO_48GFBEEz1J_o=ZRcBh8rdFUj=eQ7Gr8s0sfL9RpHjZigamA@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 17 Dec 2012 14:27:58 +0530
Message-ID: <CAO_48GGGXAYJrPiXEcCTR_nhh_dWSH5D_Et0pv+bmdEXKg_5XA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Add debugfs support
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17 December 2012 14:25, Sumit Semwal <sumit.semwal@linaro.org> wrote:
Apologies for re-sending, since the gmail ui 'decided' to set some
formatting options by default!
> Hi Maarten,
>
> On 14 December 2012 17:27, Maarten Lankhorst <m.b.lankhorst@gmail.com>
> wrote:
>>
>> Op 14-12-12 10:36, sumit.semwal@ti.com schreef:
>> > From: Sumit Semwal <sumit.semwal@linaro.org>
>> >
>> > Add debugfs support to make it easier to print debug information
>> > about the dma-buf buffers.
>> >
>> I like the idea, I don't know if it could be done in a free manner, but
>> for bonus points
>> could we also have the dma-buf fd be obtainable that way from a debugfs
>> entry?
>>
>> Doing so would allow me to 'steal' a dma-buf from an existing mapping
>> easily, and test against that.
>>
>> Also I think the name of the device and process that exported the dma-buf
>> would be useful
>> to have as well, even if in case of the device that would mean changing
>> the api slightly to record it.
>>
>> I was thinking of having a directory structure like this:
>>
>> /sys/kernel/debug/dma_buf/stats
>>
>> and then for each dma-buf:
>>
>> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-fd
>> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-attachments
>> /sys/kernel/debug/dma-buf/exporting_file.c/<number>-info
>>
>> Opening the fd file would give you back the original fd, or fail with -EIO
>> if refcount was dropped to 0.
>>
>> Would something like this be doable? I don't know debugfs that well, but I
>> don't see why it wouldn't be,
>
> Let me think more about it, but I am inclined to add simple support first,
> and then add more features to dma_buf debugfs as it grows.
>
> I still would want to take Daniel's suggestion on dma_buf_export_named()
> before I push this patch, so I guess I'll try to work a little more and
> prepare it for 3.9?
>
> I quite like your idea of .../dma-buf/<exporting_file.c>/...  , which would
> need the above as well :)
>>
>>
>> ~Maarten
>>
> Best regards,
> ~Sumit.
>



--
Thanks and regards,

Sumit Semwal

Linaro Kernel Engineer - Graphics working group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
