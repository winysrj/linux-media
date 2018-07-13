Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34543 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729765AbeGMQ1X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 12:27:23 -0400
MIME-Version: 1.0
In-Reply-To: <20180622120419.7675-3-matwey@sai.msu.ru>
References: <20180622120419.7675-1-matwey@sai.msu.ru> <20180622120419.7675-3-matwey@sai.msu.ru>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Fri, 13 Jul 2018 19:11:45 +0300
Message-ID: <CAJs94EbjUMRQSz+nnuUOX3TuQoGqUDo=-VQrXEbCgsZLZboniQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: usb: pwc: Don't use coherent DMA buffers
 for ISO transfer
To: hverkuil@xs4all.nl, mchehab@kernel.org
Cc: "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Mike Isely <isely@pobox.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin King <colin.king@canonical.com>,
        linux-media@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-06-22 15:04 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
> DMA cocherency slows the transfer down on systems without hardware
> coherent DMA.
>

Ping.

> Based on previous commit the following performance benchmarks have been
> carried out. Average memcpy() data transfer rate (rate) and handler
> completion time (time) have been measured when running video stream at
> 640x480 resolution at 10fps.
>
> x86_64 based system (Intel Core i5-3470). This platform has hardware
> coherent DMA support and proposed change doesn't make big difference here.
>
>  * kmalloc:            rate = (4.4 +- 1.0) GBps
>                        time = (2.4 +- 1.2) usec
>  * usb_alloc_coherent: rate = (4.1 +- 0.9) GBps
>                        time = (2.5 +- 1.0) usec
>
> We see that the measurements agree well within error ranges in this case.
> So no performance downgrade is introduced.
>
> armv7l based system (TI AM335x BeagleBone Black). This platform has no
> hardware coherent DMA support. DMA coherence is implemented via disabled
> page caching that slows down memcpy() due to memory controller behaviour.
>
>  * kmalloc:            rate =  (190 +-  30) MBps
>                        time =   (50 +-  10) usec
>  * usb_alloc_coherent: rate =   (33 +-   4) MBps
>                        time = (3000 +- 400) usec
>
> Note, that quantative difference leads (this commit leads to 5 times
> acceleration) to qualitative behavior change in this case. As it was
> stated before, the video stream can not be successfully received at AM335x
> platforms with MUSB based USB host controller due to performance issues
> [1].
>
> [1] https://www.spinics.net/lists/linux-usb/msg165735.html
>
> Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
> ---
>  drivers/media/usb/pwc/pwc-if.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/usb/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
> index 72d2897a4b9f..339a285600d1 100644
> --- a/drivers/media/usb/pwc/pwc-if.c
> +++ b/drivers/media/usb/pwc/pwc-if.c
> @@ -427,11 +427,8 @@ static int pwc_isoc_init(struct pwc_device *pdev)
>                 urb->interval = 1; // devik
>                 urb->dev = udev;
>                 urb->pipe = usb_rcvisocpipe(udev, pdev->vendpoint);
> -               urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
> -               urb->transfer_buffer = usb_alloc_coherent(udev,
> -                                                         ISO_BUFFER_SIZE,
> -                                                         GFP_KERNEL,
> -                                                         &urb->transfer_dma);
> +               urb->transfer_flags = URB_ISO_ASAP;
> +               urb->transfer_buffer = kmalloc(ISO_BUFFER_SIZE, GFP_KERNEL);
>                 if (urb->transfer_buffer == NULL) {
>                         PWC_ERROR("Failed to allocate urb buffer %d\n", i);
>                         pwc_isoc_cleanup(pdev);
> @@ -491,10 +488,7 @@ static void pwc_iso_free(struct pwc_device *pdev)
>                 if (pdev->urbs[i]) {
>                         PWC_DEBUG_MEMORY("Freeing URB\n");
>                         if (pdev->urbs[i]->transfer_buffer) {
> -                               usb_free_coherent(pdev->udev,
> -                                       pdev->urbs[i]->transfer_buffer_length,
> -                                       pdev->urbs[i]->transfer_buffer,
> -                                       pdev->urbs[i]->transfer_dma);
> +                               kfree(pdev->urbs[i]->transfer_buffer);
>                         }
>                         usb_free_urb(pdev->urbs[i]);
>                         pdev->urbs[i] = NULL;
> --
> 2.16.4
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119234, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
