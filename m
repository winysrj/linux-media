Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:64323 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3HVMYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 08:24:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v1 38/49] media: usb: em28xx: prepare for enabling irq in complete()
Date: Thu, 22 Aug 2013 14:24:08 +0200
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com> <1376756714-25479-39-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-39-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221424.09015.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat 17 August 2013 18:25:03 Ming Lei wrote:
> Complete() will be run with interrupt enabled, so change to
> spin_lock_irqsave().
> 
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: linux-media@vger.kernel.org
> Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> Tested-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/em28xx/em28xx-core.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index fc157af..0d698f9 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -941,6 +941,7 @@ static void em28xx_irq_callback(struct urb *urb)
>  {
>  	struct em28xx *dev = urb->context;
>  	int i;
> +	unsigned long flags;
>  
>  	switch (urb->status) {
>  	case 0:             /* success */
> @@ -956,9 +957,9 @@ static void em28xx_irq_callback(struct urb *urb)
>  	}
>  
>  	/* Copy data from URB */
> -	spin_lock(&dev->slock);
> +	spin_lock_irqsave(&dev->slock, flags);
>  	dev->usb_ctl.urb_data_copy(dev, urb);
> -	spin_unlock(&dev->slock);
> +	spin_unlock_irqrestore(&dev->slock, flags);
>  
>  	/* Reset urb buffers */
>  	for (i = 0; i < urb->number_of_packets; i++) {
> 
