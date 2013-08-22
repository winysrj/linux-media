Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:58741 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab3HVMYf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 08:24:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v1 40/49] media: usb: tlg2300: prepare for enabling irq in complete()
Date: Thu, 22 Aug 2013 14:24:31 +0200
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com> <1376756714-25479-41-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-41-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221424.31462.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat 17 August 2013 18:25:05 Ming Lei wrote:
> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/tlg2300/pd-alsa.c  |    5 +++--
>  drivers/media/usb/tlg2300/pd-video.c |    5 +++--
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/tlg2300/pd-alsa.c b/drivers/media/usb/tlg2300/pd-alsa.c
> index 3f3e141..65c46a2 100644
> --- a/drivers/media/usb/tlg2300/pd-alsa.c
> +++ b/drivers/media/usb/tlg2300/pd-alsa.c
> @@ -141,6 +141,7 @@ static inline void handle_audio_data(struct urb *urb, int *period_elapsed)
>  	int len		= urb->actual_length / stride;
>  	unsigned char *cp	= urb->transfer_buffer;
>  	unsigned int oldptr	= pa->rcv_position;
> +	unsigned long flags;
>  
>  	if (urb->actual_length == AUDIO_BUF_SIZE - 4)
>  		len -= (AUDIO_TRAILER_SIZE / stride);
> @@ -156,7 +157,7 @@ static inline void handle_audio_data(struct urb *urb, int *period_elapsed)
>  		memcpy(runtime->dma_area + oldptr * stride, cp, len * stride);
>  
>  	/* update the statas */
> -	snd_pcm_stream_lock(pa->capture_pcm_substream);
> +	snd_pcm_stream_lock_irqsave(pa->capture_pcm_substream, flags);
>  	pa->rcv_position	+= len;
>  	if (pa->rcv_position >= runtime->buffer_size)
>  		pa->rcv_position -= runtime->buffer_size;
> @@ -166,7 +167,7 @@ static inline void handle_audio_data(struct urb *urb, int *period_elapsed)
>  		pa->copied_position -= runtime->period_size;
>  		*period_elapsed = 1;
>  	}
> -	snd_pcm_stream_unlock(pa->capture_pcm_substream);
> +	snd_pcm_stream_unlock_irqrestore(pa->capture_pcm_substream, flags);
>  }
>  
>  static void complete_handler_audio(struct urb *urb)
> diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
> index 8df668d..4e5bd07 100644
> --- a/drivers/media/usb/tlg2300/pd-video.c
> +++ b/drivers/media/usb/tlg2300/pd-video.c
> @@ -151,11 +151,12 @@ static void init_copy(struct video_data *video, bool index)
>  static bool get_frame(struct front_face *front, int *need_init)
>  {
>  	struct videobuf_buffer *vb = front->curr_frame;
> +	unsigned long flags;
>  
>  	if (vb)
>  		return true;
>  
> -	spin_lock(&front->queue_lock);
> +	spin_lock_irqsave(&front->queue_lock, flags);
>  	if (!list_empty(&front->active)) {
>  		vb = list_entry(front->active.next,
>  			       struct videobuf_buffer, queue);
> @@ -164,7 +165,7 @@ static bool get_frame(struct front_face *front, int *need_init)
>  		front->curr_frame = vb;
>  		list_del_init(&vb->queue);
>  	}
> -	spin_unlock(&front->queue_lock);
> +	spin_unlock_irqrestore(&front->queue_lock, flags);
>  
>  	return !!vb;
>  }
> 
