Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:38664 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728496AbeGYO6r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:58:47 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1807241652550.1311-100000@iolanthe.rowland.org>
References: <CAJs94EahjbkJRWKR=2QeD=tOMR=kznwXbQgTbKvSuTg4jBk1ew@mail.gmail.com>
 <Pine.LNX.4.44L0.1807241652550.1311-100000@iolanthe.rowland.org>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Wed, 25 Jul 2018 16:46:41 +0300
Message-ID: <CAJs94EZpJgDg0j8sVgOd56OY53mv7VxSODbhtR5MsZnFUoJA+g@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-07-24 23:55 GMT+03:00 Alan Stern <stern@rowland.harvard.edu>:
> On Tue, 24 Jul 2018, Matwey V. Kornilov wrote:
>
>> 2018-07-23 21:57 GMT+03:00 Alan Stern <stern@rowland.harvard.edu>:
>> > On Mon, 23 Jul 2018, Matwey V. Kornilov wrote:
>> >
>> >> I've tried to strategies:
>> >>
>> >> 1) Use dma_unmap and dma_map inside the handler (I suppose this is
>> >> similar to how USB core does when there is no URB_NO_TRANSFER_DMA_MAP)
>> >
>> > Yes.
>> >
>> >> 2) Use sync_cpu and sync_device inside the handler (and dma_map only
>> >> once at memory allocation)
>> >>
>> >> It is interesting that dma_unmap/dma_map pair leads to the lower
>> >> overhead (+1us) than sync_cpu/sync_device (+2us) at x86_64 platform.
>> >> At armv7l platform using dma_unmap/dma_map  leads to ~50 usec in the
>> >> handler, and sync_cpu/sync_device - ~65 usec.
>> >>
>> >> However, I am not sure is it mandatory to call
>> >> dma_sync_single_for_device for FROM_DEVICE direction?
>> >
>> > According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
>> > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
>> > not needed.
>>
>> Well, I measured the following at armv7l. The handler execution time
>> (URB_NO_TRANSFER_DMA_MAP is used for all cases):
>>
>> 1) coherent DMA: ~3000 usec (pwc is not functional)
>> 2) explicit dma_unmap and dma_map in the handler: ~52 usec
>> 3) explicit dma_sync_single_for_cpu (no dma_sync_single_for_device): ~56 usec
>>
>> So, I suppose that unfortunately Tomasz suggestion doesn't work. There
>> is no performance improvement when dma_sync_single is used.
>>
>> At x86_64 the following happens:
>>
>> 1) coherent DMA: ~2 usec
>> 2) explicit dma_unmap and dma_map in the handler: ~3.5 usec
>> 3) explicit dma_sync_single_for_cpu (no dma_sync_single_for_device): ~4 usec
>>
>> So, whats to do next? Personally, I think that DMA streaming API
>> introduces not so great overhead.
>> Does anybody happy with turning to streaming DMA or I'll introduce
>> module-level switch as Ezequiel suggested?
>
> How about using the dma_unmap and dma_map calls in the USB core?  If
> they add the same overhead as putting them in the handler, I think it
> would be acceptable for x86_64.

Sure, that is the simplest way to implement streaming API.

>
> It certainly is odd that the dma_sync_single APIs take longer than
> simply mapping and unmapping.

Well. I am surprised too. Probably, it is related to that only 9560
bytes are used for each URB. It is only three memory pages.

>
> Alan Stern
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
