Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:40274 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbeHDKF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2018 06:05:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAAFQd5AKJrCAAFiis-YjKFULPb1zqboPVSgT8Uepg-C561fgeg@mail.gmail.com>
References: <CAJs94EahjbkJRWKR=2QeD=tOMR=kznwXbQgTbKvSuTg4jBk1ew@mail.gmail.com>
 <Pine.LNX.4.44L0.1807241652550.1311-100000@iolanthe.rowland.org>
 <CAJs94EZpJgDg0j8sVgOd56OY53mv7VxSODbhtR5MsZnFUoJA+g@mail.gmail.com> <CAAFQd5AKJrCAAFiis-YjKFULPb1zqboPVSgT8Uepg-C561fgeg@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Sat, 4 Aug 2018 11:05:50 +0300
Message-ID: <CAJs94EYAEoTM+B79TBTy934FVqOrruv962ZnymO3N6YbfccYLw@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
To: Tomasz Figa <tfiga@chromium.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
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

2018-07-30 7:14 GMT+03:00 Tomasz Figa <tfiga@chromium.org>:
> On Wed, Jul 25, 2018 at 10:47 PM Matwey V. Kornilov <matwey@sai.msu.ru> wrote:
>>
>> 2018-07-24 23:55 GMT+03:00 Alan Stern <stern@rowland.harvard.edu>:
>> > On Tue, 24 Jul 2018, Matwey V. Kornilov wrote:
>> >
>> >> 2018-07-23 21:57 GMT+03:00 Alan Stern <stern@rowland.harvard.edu>:
>> >> > On Mon, 23 Jul 2018, Matwey V. Kornilov wrote:
>> >> >
>> >> >> I've tried to strategies:
>> >> >>
>> >> >> 1) Use dma_unmap and dma_map inside the handler (I suppose this is
>> >> >> similar to how USB core does when there is no URB_NO_TRANSFER_DMA_MAP)
>> >> >
>> >> > Yes.
>> >> >
>> >> >> 2) Use sync_cpu and sync_device inside the handler (and dma_map only
>> >> >> once at memory allocation)
>> >> >>
>> >> >> It is interesting that dma_unmap/dma_map pair leads to the lower
>> >> >> overhead (+1us) than sync_cpu/sync_device (+2us) at x86_64 platform.
>> >> >> At armv7l platform using dma_unmap/dma_map  leads to ~50 usec in the
>> >> >> handler, and sync_cpu/sync_device - ~65 usec.
>> >> >>
>> >> >> However, I am not sure is it mandatory to call
>> >> >> dma_sync_single_for_device for FROM_DEVICE direction?
>> >> >
>> >> > According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
>> >> > to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
>> >> > not needed.
>> >>
>> >> Well, I measured the following at armv7l. The handler execution time
>> >> (URB_NO_TRANSFER_DMA_MAP is used for all cases):
>> >>
>> >> 1) coherent DMA: ~3000 usec (pwc is not functional)
>> >> 2) explicit dma_unmap and dma_map in the handler: ~52 usec
>> >> 3) explicit dma_sync_single_for_cpu (no dma_sync_single_for_device): ~56 usec
>
> That's very strange because on ARM dma_unmap_single() does exactly the
> same thing as dma_sync_single_for_cpu():
>
> arm_dma_map_page()
> https://elixir.bootlin.com/linux/v4.18-rc7/source/arch/arm/mm/dma-mapping.c#L129
> arm_dma_unmap_page()
> https://elixir.bootlin.com/linux/v4.18-rc7/source/arch/arm/mm/dma-mapping.c#L159
>
> arm_dma_sync_single_for_cpu()
> https://elixir.bootlin.com/linux/v4.18-rc7/source/arch/arm/mm/dma-mapping.c#L167
>
> Could you post the code you used for testing of cases 2) and 3)?

I remeasured the timings (see my other mail).
The code you asked is here:
https://github.com/matwey/linux/tree/pwc_dma_v3 but I am going to
rebase this branch.

>
> Best regards,
> Tomasz
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
