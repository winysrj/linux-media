Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:53725 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab3GKNNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 09:13:37 -0400
Received: by mail-la0-f41.google.com with SMTP id fn20so6788393lab.14
        for <linux-media@vger.kernel.org>; Thu, 11 Jul 2013 06:13:36 -0700 (PDT)
Message-ID: <51DEAF7D.4010609@cogentembedded.com>
Date: Thu, 11 Jul 2013 17:13:33 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 42/50] media: usb: tlg2300: spin_lock in complete() cleanup
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com> <1373533573-12272-43-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-43-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11-07-2013 13:06, Ming Lei wrote:

     Subject doesn't match the patch.

> Complete() will be run with interrupt enabled, so disable local
> interrupt before holding a global lock which is held without
> irqsave.
>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>   drivers/media/usb/tlg2300/pd-alsa.c |    3 +++
>   1 file changed, 3 insertions(+)

> diff --git a/drivers/media/usb/tlg2300/pd-alsa.c b/drivers/media/usb/tlg2300/pd-alsa.c
> index 3f3e141..cbccc96 100644
> --- a/drivers/media/usb/tlg2300/pd-alsa.c
> +++ b/drivers/media/usb/tlg2300/pd-alsa.c
[...]
> @@ -156,6 +157,7 @@ static inline void handle_audio_data(struct urb *urb, int *period_elapsed)
>   		memcpy(runtime->dma_area + oldptr * stride, cp, len * stride);
>
>   	/* update the statas */
> +	local_irq_save(flags);
>   	snd_pcm_stream_lock(pa->capture_pcm_substream);
>   	pa->rcv_position	+= len;
>   	if (pa->rcv_position >= runtime->buffer_size)
> @@ -167,6 +169,7 @@ static inline void handle_audio_data(struct urb *urb, int *period_elapsed)
>   		*period_elapsed = 1;
>   	}
>   	snd_pcm_stream_unlock(pa->capture_pcm_substream);
> +	local_irq_restore(flags);
>   }

WBR, Sergei


