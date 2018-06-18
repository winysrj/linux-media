Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:40653 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754551AbeFRHKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 03:10:55 -0400
MIME-Version: 1.0
In-Reply-To: <c02f92a8998fc62d3e3d48aa154fbaa7e223dd10.camel@collabora.com>
References: <20180617143625.32133-1-matwey@sai.msu.ru> <20180617143625.32133-2-matwey@sai.msu.ru>
 <c02f92a8998fc62d3e3d48aa154fbaa7e223dd10.camel@collabora.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Mon, 18 Jun 2018 10:10:34 +0300
Message-ID: <CAJs94EavBDcFHpd0KcCZJTgWf0JC=AEDY=X8b3P2nZvt8mBCPA@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: usb: pwc: Don't use coherent DMA buffers for
 ISO transfer
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: hverkuil@xs4all.nl, mchehab@kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        rostedt@goodmis.org, mingo@redhat.com, isely@pobox.com,
        bhumirks@gmail.com, colin.king@canonical.com,
        linux-media@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

2018-06-18 8:11 GMT+03:00 Ezequiel Garcia <ezequiel@collabora.com>:
> + Laurent
>
> On Sun, 2018-06-17 at 17:36 +0300, Matwey V. Kornilov wrote:
>> DMA cocherency slows the transfer down on systems without hardware
>> coherent DMA.
>>
>> Based on previous commit the following performance benchmarks have been
>> carried out. Average memcpy() data transfer rate (rate) and handler
>> completion time (time) have been measured when running video stream at
>> 640x480 resolution at 10fps.
>>
>> x86_64 based system (Intel Core i5-3470). This platform has hardware
>> coherent DMA support and proposed change doesn't make big difference here.
>>
>>  * kmalloc:            rate = (4.4 +- 1.0) GBps
>>                        time = (2.4 +- 1.2) usec
>>  * usb_alloc_coherent: rate = (4.1 +- 0.9) GBps
>>                        time = (2.5 +- 1.0) usec
>>
>> We see that the measurements agree well within error ranges in this case.
>> So no performance downgrade is introduced.
>>
>> armv7l based system (TI AM335x BeagleBone Black). This platform has no
>> hardware coherent DMA support. DMA coherence is implemented via disabled
>> page caching that slows down memcpy() due to memory controller behaviour.
>>
>>  * kmalloc:            rate =  (190 +-  30) MBps
>>                        time =   (50 +-  10) usec
>>  * usb_alloc_coherent: rate =   (33 +-   4) MBps
>>                        time = (3000 +- 400) usec
>>
>> Note, that quantative difference leads (this commit leads to 5 times
>> acceleration) to qualitative behavior change in this case. As it was
>> stated before, the video stream can not be successfully received at AM335x
>> platforms with MUSB based USB host controller due to performance issues
>> [1].
>>
>> [1] https://www.spinics.net/lists/linux-usb/msg165735.html
>>
>
> This is quite interesting! I have receive similar complaints
> from users wanting to use stk1160 on BBB and Raspberrys,
> without much luck on either, due to insufficient isoc bandwidth.
>
> I'm guessing other ARM platforms could be suffering
> from the same issue.
>
> Note that stk1160 and uvcvideo drivers use kmalloc on platforms
> where DMA_NONCOHERENT is defined, but this is not the case
> on ARM platforms.

There are some ARMv7 platforms that have coherent DMA (for instance
Broadcome Horthstar Plus series), but the most of them don't have. It
is defined in device tree file, and there is no way to recover this
information at runtime in USB perepherial driver.

>
> So, what is the benefit of using consistent
> for these URBs, as opposed to streaming?

I don't know, I think there is no real benefit and all we see is a
consequence of copy-pasta when some webcam drivers were inspired by
others and development priparily was going at x86 platforms. It would
be great if somebody corrected me here. DMA Coherence is quite strong
property and I cannot figure out how can it help when streaming video.
The CPU host always reads from the buffer and never writes to.
Hardware perepherial always writes to and never reads from. Moreover,
buffer access is mutually exclusive and separated in time by Interrupt
fireing and URB starting (when we reuse existing URB for new request).
Only single one memory barrier is really required here.

I understand that there are cases when DMA coherence is really needed,
for instane VirtIO VRing when we accessing same data structure in both
directions from the both sides, but this has nothing common with our
case.

>
> If the choice is simply platform dependent,
> can't we somehow detect which mapping should
> be prefered?

Now, we don't have this way.

>
>> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
>> ---
>>  drivers/media/usb/pwc/pwc-if.c | 12 +++---------
>>  1 file changed, 3 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
>> index 5775d1f60668..6a3cd9680a7f 100644
>> --- a/drivers/media/usb/pwc/pwc-if.c
>> +++ b/drivers/media/usb/pwc/pwc-if.c
>> @@ -427,11 +427,8 @@ static int pwc_isoc_init(struct pwc_device *pdev)
>>               urb->interval = 1; // devik
>>               urb->dev = udev;
>>               urb->pipe = usb_rcvisocpipe(udev, pdev->vendpoint);
>> -             urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
>> -             urb->transfer_buffer = usb_alloc_coherent(udev,
>> -                                                       ISO_BUFFER_SIZE,
>> -                                                       GFP_KERNEL,
>> -                                                       &urb->transfer_dma);
>> +             urb->transfer_flags = URB_ISO_ASAP;
>> +             urb->transfer_buffer = kmalloc(ISO_BUFFER_SIZE, GFP_KERNEL);
>>               if (urb->transfer_buffer == NULL) {
>>                       PWC_ERROR("Failed to allocate urb buffer %d\n", i);
>>                       pwc_isoc_cleanup(pdev);
>> @@ -491,10 +488,7 @@ static void pwc_iso_free(struct pwc_device *pdev)
>>               if (pdev->urbs[i]) {
>>                       PWC_DEBUG_MEMORY("Freeing URB\n");
>>                       if (pdev->urbs[i]->transfer_buffer) {
>> -                             usb_free_coherent(pdev->udev,
>> -                                     pdev->urbs[i]->transfer_buffer_length,
>> -                                     pdev->urbs[i]->transfer_buffer,
>> -                                     pdev->urbs[i]->transfer_dma);
>> +                             kfree(pdev->urbs[i]->transfer_buffer);
>>                       }
>>                       usb_free_urb(pdev->urbs[i]);
>>                       pdev->urbs[i] = NULL;
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
