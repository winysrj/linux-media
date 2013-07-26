Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4793 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab3GZO3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 10:29:09 -0400
Message-ID: <51F2878E.90705@xs4all.nl>
Date: Fri, 26 Jul 2013 16:28:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 35/50] media: usb: cx231xx: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-36-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-36-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/11/2013 11:05 AM, Ming Lei wrote:
> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/media/usb/cx231xx/cx231xx-audio.c |    6 ++++++
>  drivers/media/usb/cx231xx/cx231xx-core.c  |   10 ++++++----
>  drivers/media/usb/cx231xx/cx231xx-vbi.c   |    5 +++--
>  3 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
> index 81a1d97..58c1b5c 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-audio.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
> @@ -136,6 +136,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
>  		stride = runtime->frame_bits >> 3;
>  
>  		for (i = 0; i < urb->number_of_packets; i++) {
> +			unsigned long flags;
>  			int length = urb->iso_frame_desc[i].actual_length /
>  				     stride;
>  			cp = (unsigned char *)urb->transfer_buffer +
> @@ -158,6 +159,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
>  				       length * stride);
>  			}
>  
> +			local_irq_save(flags);
>  			snd_pcm_stream_lock(substream);

Can't you use snd_pcm_stream_lock_irqsave here?

Ditto for the other media drivers where this happens: em28xx and tlg2300.

I've reviewed the media driver changes and they look OK to me, so if
my comment above is fixed, then I can merge them for 3.12. Or are these
changes required for 3.11?

Regards,

	Hans

>  
>  			dev->adev.hwptr_done_capture += length;
> @@ -174,6 +176,7 @@ static void cx231xx_audio_isocirq(struct urb *urb)
>  				period_elapsed = 1;
>  			}
>  			snd_pcm_stream_unlock(substream);
> +			local_irq_restore(flags);
>  		}
>  		if (period_elapsed)
>  			snd_pcm_period_elapsed(substream);
> @@ -224,6 +227,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
>  		stride = runtime->frame_bits >> 3;
>  
>  		if (1) {
> +			unsigned long flags;
>  			int length = urb->actual_length /
>  				     stride;
>  			cp = (unsigned char *)urb->transfer_buffer;
> @@ -242,6 +246,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
>  				       length * stride);
>  			}
>  
> +			local_irq_save(flags);
>  			snd_pcm_stream_lock(substream);
>  
>  			dev->adev.hwptr_done_capture += length;
> @@ -258,6 +263,7 @@ static void cx231xx_audio_bulkirq(struct urb *urb)
>  				period_elapsed = 1;
>  			}
>  			snd_pcm_stream_unlock(substream);
> +			local_irq_restore(flags);
>  		}
>  		if (period_elapsed)
>  			snd_pcm_period_elapsed(substream);
> diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
> index 4ba3ce0..593b397 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-core.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-core.c
> @@ -798,6 +798,7 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
>  	    container_of(dma_q, struct cx231xx_video_mode, vidq);
>  	struct cx231xx *dev = container_of(vmode, struct cx231xx, video_mode);
>  	int i;
> +	unsigned long flags;
>  
>  	switch (urb->status) {
>  	case 0:		/* success */
> @@ -813,9 +814,9 @@ static void cx231xx_isoc_irq_callback(struct urb *urb)
>  	}
>  
>  	/* Copy data from URB */
> -	spin_lock(&dev->video_mode.slock);
> +	spin_lock_irqsave(&dev->video_mode.slock, flags);
>  	dev->video_mode.isoc_ctl.isoc_copy(dev, urb);
> -	spin_unlock(&dev->video_mode.slock);
> +	spin_unlock_irqrestore(&dev->video_mode.slock, flags);
>  
>  	/* Reset urb buffers */
>  	for (i = 0; i < urb->number_of_packets; i++) {
> @@ -842,6 +843,7 @@ static void cx231xx_bulk_irq_callback(struct urb *urb)
>  	struct cx231xx_video_mode *vmode =
>  	    container_of(dma_q, struct cx231xx_video_mode, vidq);
>  	struct cx231xx *dev = container_of(vmode, struct cx231xx, video_mode);
> +	unsigned long flags;
>  
>  	switch (urb->status) {
>  	case 0:		/* success */
> @@ -857,9 +859,9 @@ static void cx231xx_bulk_irq_callback(struct urb *urb)
>  	}
>  
>  	/* Copy data from URB */
> -	spin_lock(&dev->video_mode.slock);
> +	spin_lock_irqsave(&dev->video_mode.slock, flags);
>  	dev->video_mode.bulk_ctl.bulk_copy(dev, urb);
> -	spin_unlock(&dev->video_mode.slock);
> +	spin_unlock_irqrestore(&dev->video_mode.slock, flags);
>  
>  	/* Reset urb buffers */
>  	urb->status = usb_submit_urb(urb, GFP_ATOMIC);
> diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
> index c027942..38e78f8 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
> @@ -306,6 +306,7 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
>  	struct cx231xx_video_mode *vmode =
>  	    container_of(dma_q, struct cx231xx_video_mode, vidq);
>  	struct cx231xx *dev = container_of(vmode, struct cx231xx, vbi_mode);
> +	unsigned long flags;
>  
>  	switch (urb->status) {
>  	case 0:		/* success */
> @@ -322,9 +323,9 @@ static void cx231xx_irq_vbi_callback(struct urb *urb)
>  	}
>  
>  	/* Copy data from URB */
> -	spin_lock(&dev->vbi_mode.slock);
> +	spin_lock_irqsave(&dev->vbi_mode.slock, flags);
>  	dev->vbi_mode.bulk_ctl.bulk_copy(dev, urb);
> -	spin_unlock(&dev->vbi_mode.slock);
> +	spin_unlock_irqrestore(&dev->vbi_mode.slock, flags);
>  
>  	/* Reset status */
>  	urb->status = 0;
> 
