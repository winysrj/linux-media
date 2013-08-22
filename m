Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:63938 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3HVMY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 08:24:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v1 43/49] media: usb: em28xx: prepare for enabling irq in complete()
Date: Thu, 22 Aug 2013 14:24:53 +0200
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com> <1376756714-25479-44-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-44-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221424.53696.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat 17 August 2013 18:25:08 Ming Lei wrote:
> Complete() will be run with interrupt enabled, so add local_irq_save()
> before acquiring the lock without irqsave().
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/em28xx/em28xx-audio.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index 2fdb66e..7fd1b2a 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -113,6 +113,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
>  		stride = runtime->frame_bits >> 3;
>  
>  		for (i = 0; i < urb->number_of_packets; i++) {
> +			unsigned long flags;
>  			int length =
>  			    urb->iso_frame_desc[i].actual_length / stride;
>  			cp = (unsigned char *)urb->transfer_buffer +
> @@ -134,7 +135,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
>  				       length * stride);
>  			}
>  
> -			snd_pcm_stream_lock(substream);
> +			snd_pcm_stream_lock_irqsave(substream, flags);
>  
>  			dev->adev.hwptr_done_capture += length;
>  			if (dev->adev.hwptr_done_capture >=
> @@ -150,7 +151,7 @@ static void em28xx_audio_isocirq(struct urb *urb)
>  				period_elapsed = 1;
>  			}
>  
> -			snd_pcm_stream_unlock(substream);
> +			snd_pcm_stream_unlock_irqrestore(substream, flags);
>  		}
>  		if (period_elapsed)
>  			snd_pcm_period_elapsed(substream);
> 
