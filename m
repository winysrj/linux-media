Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:64671 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3HVMYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 08:24:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v1 41/49] media: usb: tm6000: prepare for enabling irq in complete()
Date: Thu, 22 Aug 2013 14:24:42 +0200
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com> <1376756714-25479-42-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-42-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221424.42282.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat 17 August 2013 18:25:06 Ming Lei wrote:
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
>  drivers/media/usb/tm6000/tm6000-video.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
> index cc1aa14..8bb440f 100644
> --- a/drivers/media/usb/tm6000/tm6000-video.c
> +++ b/drivers/media/usb/tm6000/tm6000-video.c
> @@ -434,6 +434,7 @@ static void tm6000_irq_callback(struct urb *urb)
>  	struct tm6000_dmaqueue  *dma_q = urb->context;
>  	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
>  	int i;
> +	unsigned long flags;
>  
>  	switch (urb->status) {
>  	case 0:
> @@ -450,9 +451,9 @@ static void tm6000_irq_callback(struct urb *urb)
>  		break;
>  	}
>  
> -	spin_lock(&dev->slock);
> +	spin_lock_irqsave(&dev->slock, flags);
>  	tm6000_isoc_copy(urb);
> -	spin_unlock(&dev->slock);
> +	spin_unlock_irqrestore(&dev->slock, flags);
>  
>  	/* Reset urb buffers */
>  	for (i = 0; i < urb->number_of_packets; i++) {
> 
