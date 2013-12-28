Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1089 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3L1M1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 07:27:08 -0500
Message-ID: <52BEC358.9000004@xs4all.nl>
Date: Sat, 28 Dec 2013 13:26:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3 21/24] em28xx: USB: adjust for changed 3.8 USB API
References: <1388232976-20061-1-git-send-email-mchehab@redhat.com> <1388232976-20061-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1388232976-20061-22-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/28/2013 01:16 PM, Mauro Carvalho Chehab wrote:
> From: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> The recent changes in the USB API ("implement new semantics for
> URB_ISO_ASAP") made the former meaning of the URB_ISO_ASAP flag the
> default, and changed this flag to mean that URBs can be delayed.
> This is not the behaviour wanted by any of the audio drivers because
> it leads to discontinuous playback with very small period sizes.
> Therefore, our URBs need to be submitted without this flag.

Does this affect other drivers as well? E.g. cx231xx-audio.c uses this
as well.

Regards,

	Hans

> 
> This patch implements the same fix as found at snd-usb-audio driver
> (commit c75c5ab575af7db707689cdbb5a5c458e9a034bb)
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-audio.c | 2 +-
>  drivers/media/usb/em28xx/em28xx-core.c  | 3 +--
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index a6eef06ffdcd..54f4eb6d513c 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -195,7 +195,7 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
>  		urb->dev = dev->udev;
>  		urb->context = dev;
>  		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
> -		urb->transfer_flags = URB_ISO_ASAP;
> +		urb->transfer_flags = 0;
>  		urb->transfer_buffer = dev->adev.transfer_buffer[i];
>  		urb->interval = 1;
>  		urb->complete = em28xx_audio_isocirq;
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index d6928d83fb2a..8376b9e6397f 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -953,8 +953,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
>  			usb_fill_int_urb(urb, dev->udev, pipe,
>  					 usb_bufs->transfer_buffer[i], sb_size,
>  					 em28xx_irq_callback, dev, 1);
> -			urb->transfer_flags = URB_ISO_ASAP |
> -					      URB_NO_TRANSFER_DMA_MAP;
> +			urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
>  			k = 0;
>  			for (j = 0; j < usb_bufs->num_packets; j++) {
>  				urb->iso_frame_desc[j].offset = k;
> 

