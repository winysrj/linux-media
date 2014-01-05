Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:53332 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaAEU4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 15:56:16 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so7549741eek.17
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 12:56:15 -0800 (PST)
Message-ID: <52C9C733.9050006@googlemail.com>
Date: Sun, 05 Jan 2014 21:57:23 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 20/22] [media] em28xx: use usb_alloc_coherent() for
 audio
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-21-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-21-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> Instead of allocating transfer buffers with kmalloc() use
> usb_alloc_coherent().
>
> That makes it work also with arm CPUs.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-audio.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index a6eef06ffdcd..e5120430ec80 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -64,16 +64,22 @@ static int em28xx_deinit_isoc_audio(struct em28xx *dev)
>  
>  	dprintk("Stopping isoc\n");
>  	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
> +		struct urb *urb = dev->adev.urb[i];
> +
>  		if (!irqs_disabled())
> -			usb_kill_urb(dev->adev.urb[i]);
> +			usb_kill_urb(urb);
>  		else
> -			usb_unlink_urb(dev->adev.urb[i]);
> +			usb_unlink_urb(urb);
>  
> -		usb_free_urb(dev->adev.urb[i]);
> -		dev->adev.urb[i] = NULL;
> +		usb_free_coherent(dev->udev,
> +				  urb->transfer_buffer_length,
> +				  dev->adev.transfer_buffer[i],
> +				  urb->transfer_dma);
>  
> -		kfree(dev->adev.transfer_buffer[i]);
>  		dev->adev.transfer_buffer[i] = NULL;
> +
> +		usb_free_urb(urb);
> +		dev->adev.urb[i] = NULL;
>  	}
>  
>  	return 0;
> @@ -176,12 +182,8 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
>  	for (i = 0; i < EM28XX_AUDIO_BUFS; i++) {
>  		struct urb *urb;
>  		int j, k;
> +		void *buf;
>  
> -		dev->adev.transfer_buffer[i] = kmalloc(sb_size, GFP_ATOMIC);
> -		if (!dev->adev.transfer_buffer[i])
> -			return -ENOMEM;
> -
> -		memset(dev->adev.transfer_buffer[i], 0x80, sb_size);
>  		urb = usb_alloc_urb(EM28XX_NUM_AUDIO_PACKETS, GFP_ATOMIC);
>  		if (!urb) {
>  			em28xx_errdev("usb_alloc_urb failed!\n");
> @@ -192,10 +194,17 @@ static int em28xx_init_audio_isoc(struct em28xx *dev)
>  			return -ENOMEM;
>  		}
>  
> +		buf = usb_alloc_coherent(dev->udev, sb_size, GFP_ATOMIC,
> +					 &urb->transfer_dma);
> +		if (!buf)
> +			return -ENOMEM;
> +		dev->adev.transfer_buffer[i] = buf;
> +		memset(buf, 0x80, sb_size);
> +
>  		urb->dev = dev->udev;
>  		urb->context = dev;
>  		urb->pipe = usb_rcvisocpipe(dev->udev, EM28XX_EP_AUDIO);
> -		urb->transfer_flags = URB_ISO_ASAP;
> +		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
>  		urb->transfer_buffer = dev->adev.transfer_buffer[i];
>  		urb->interval = 1;
>  		urb->complete = em28xx_audio_isocirq;

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

