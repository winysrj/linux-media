Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34846 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727379AbeHJMIG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 08:08:06 -0400
MIME-Version: 1.0
In-Reply-To: <2131343.ieGLTDdppT@avalon>
References: <20180809181103.15437-1-matwey@sai.msu.ru> <20180809181103.15437-3-matwey@sai.msu.ru>
 <2131343.ieGLTDdppT@avalon>
From: "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Date: Fri, 10 Aug 2018 12:38:39 +0300
Message-ID: <CAJs94EajH_J268GnxygeTZXOjcTuJq+VG7g+ZfAzf0Rf8Wgkbw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        keiichiw@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-08-10 11:53 GMT+03:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Matwey,
>
> Thank you for the patch.
>
> On Thursday, 9 August 2018 21:11:03 EEST Matwey V. Kornilov wrote:
>> DMA cocherency slows the transfer down on systems without hardware
>> coherent DMA.
>> Instead we use noncocherent DMA memory and explicit sync at data receive
>> handler.
>>
>> Based on previous commit the following performance benchmarks have been
>> carried out. Average memcpy() data transfer rate (rate) and handler
>> completion time (time) have been measured when running video stream at
>> 640x480 resolution at 10fps.
>>
>> x86_64 based system (Intel Core i5-3470). This platform has hardware
>> coherent DMA support and proposed change doesn't make big difference here.
>>
>>  * kmalloc:            rate = (2.0 +- 0.4) GBps
>>                        time = (5.0 +- 3.0) usec
>>  * usb_alloc_coherent: rate = (3.4 +- 1.2) GBps
>>                        time = (3.5 +- 3.0) usec
>>
>> We see that the measurements agree within error ranges in this case.
>> So theoretically predicted performance downgrade cannot be reliably
>> measured here.
>>
>> armv7l based system (TI AM335x BeagleBone Black @ 300MHz). This platform
>> has no hardware coherent DMA support. DMA coherence is implemented via
>> disabled page caching that slows down memcpy() due to memory controller
>> behaviour.
>>
>>  * kmalloc:            rate =  (114 +- 5) MBps
>>                        time =   (84 +- 4) usec
>>  * usb_alloc_coherent: rate = (28.1 +- 0.1) MBps
>>                        time =  (341 +- 2) usec
>>
>> Note, that quantative difference leads (this commit leads to 4 times
>> acceleration) to qualitative behavior change in this case. As it was
>> stated before, the video stream cannot be successfully received at AM335x
>> platforms with MUSB based USB host controller due to performance issues
>> [1].
>>
>> [1] https://www.spinics.net/lists/linux-usb/msg165735.html
>>
>> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
>> ---
>>  drivers/media/usb/pwc/pwc-if.c | 56 +++++++++++++++++++++++++++++++-------
>>  1 file changed, 44 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
>> index 72d2897a4b9f..e9c826be1ba6 100644
>> --- a/drivers/media/usb/pwc/pwc-if.c
>> +++ b/drivers/media/usb/pwc/pwc-if.c
>> @@ -159,6 +159,32 @@ static const struct video_device pwc_template = {
>>  /**************************************************************************
>> */ /* Private functions */
>>
>> +static void *pwc_alloc_urb_buffer(struct device *dev,
>> +                               size_t size, dma_addr_t *dma_handle)
>> +{
>> +     void *buffer = kmalloc(size, GFP_KERNEL);
>> +
>> +     if (!buffer)
>> +             return NULL;
>> +
>> +     *dma_handle = dma_map_single(dev, buffer, size, DMA_FROM_DEVICE);
>> +     if (dma_mapping_error(dev, *dma_handle)) {
>> +             kfree(buffer);
>> +             return NULL;
>> +     }
>> +
>> +     return buffer;
>> +}
>> +
>> +static void pwc_free_urb_buffer(struct device *dev,
>> +                             size_t size,
>> +                             void *buffer,
>> +                             dma_addr_t dma_handle)
>> +{
>> +     dma_unmap_single(dev, dma_handle, size, DMA_FROM_DEVICE);
>> +     kfree(buffer);
>> +}
>> +
>>  static struct pwc_frame_buf *pwc_get_next_fill_buf(struct pwc_device *pdev)
>> {
>>       unsigned long flags = 0;
>> @@ -306,6 +332,11 @@ static void pwc_isoc_handler(struct urb *urb)
>>       /* Reset ISOC error counter. We did get here, after all. */
>>       pdev->visoc_errors = 0;
>>
>> +     dma_sync_single_for_cpu(&urb->dev->dev,
>> +                             urb->transfer_dma,
>> +                             urb->transfer_buffer_length,
>> +                             DMA_FROM_DEVICE);
>> +
>
> Aren't you're missing a dma_sync_single_for_device() call before submitting
> the URB ? IIRC that's required for correct operation of the DMA mapping API on
> some platforms, depending on the cache architecture. The additional sync can
> affect performances, so it would be useful to re-run the perf test.

This was already discussed:

https://lkml.org/lkml/2018/7/23/1051

I rely on Alan's reply:

>According to Documentation/DMA-API-HOWTO.txt, the CPU should not write
>to a DMA_FROM_DEVICE-mapped area, so dma_sync_single_for_device() is
>not needed.



>
>>       /* vsync: 0 = don't copy data
>>                 1 = sync-hunt
>>                 2 = synched
>> @@ -428,16 +459,15 @@ static int pwc_isoc_init(struct pwc_device *pdev)
>>               urb->dev = udev;
>>               urb->pipe = usb_rcvisocpipe(udev, pdev->vendpoint);
>>               urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
>> -             urb->transfer_buffer = usb_alloc_coherent(udev,
>> -                                                       ISO_BUFFER_SIZE,
>> -                                                       GFP_KERNEL,
>> -                                                       &urb->transfer_dma);
>> +             urb->transfer_buffer_length = ISO_BUFFER_SIZE;
>> +             urb->transfer_buffer = pwc_alloc_urb_buffer(&udev->dev,
>> +                                                         urb->transfer_buffer_length,
>> +                                                         &urb->transfer_dma);
>>               if (urb->transfer_buffer == NULL) {
>>                       PWC_ERROR("Failed to allocate urb buffer %d\n", i);
>>                       pwc_isoc_cleanup(pdev);
>>                       return -ENOMEM;
>>               }
>> -             urb->transfer_buffer_length = ISO_BUFFER_SIZE;
>>               urb->complete = pwc_isoc_handler;
>>               urb->context = pdev;
>>               urb->start_frame = 0;
>> @@ -488,15 +518,17 @@ static void pwc_iso_free(struct pwc_device *pdev)
>>
>>       /* Freeing ISOC buffers one by one */
>>       for (i = 0; i < MAX_ISO_BUFS; i++) {
>> -             if (pdev->urbs[i]) {
>> +             struct urb *urb = pdev->urbs[i];
>> +
>> +             if (urb) {
>>                       PWC_DEBUG_MEMORY("Freeing URB\n");
>> -                     if (pdev->urbs[i]->transfer_buffer) {
>> -                             usb_free_coherent(pdev->udev,
>> -                                     pdev->urbs[i]->transfer_buffer_length,
>> -                                     pdev->urbs[i]->transfer_buffer,
>> -                                     pdev->urbs[i]->transfer_dma);
>> +                     if (urb->transfer_buffer) {
>> +                             pwc_free_urb_buffer(&urb->dev->dev,
>> +                                                 urb->transfer_buffer_length,
>> +                                                 urb->transfer_buffer,
>> +                                                 urb->transfer_dma);
>>                       }
>
> No need for curly braces.
>
>> -                     usb_free_urb(pdev->urbs[i]);
>> +                     usb_free_urb(urb);
>>                       pdev->urbs[i] = NULL;
>>               }
>>       }
>
> --
> Regards,
>
> Laurent Pinchart
>
>
>

-- 
With best regards,
Matwey V. Kornilov
