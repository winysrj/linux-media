Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:52814 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3HVMYZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 08:24:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH v1 39/49] media: usb: sn9x102: prepare for enabling irq in complete()
Date: Thu, 22 Aug 2013 14:24:21 +0200
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com> <1376756714-25479-40-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-40-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308221424.21666.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat 17 August 2013 18:25:04 Ming Lei wrote:
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
>  drivers/media/usb/sn9c102/sn9c102_core.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/sn9c102/sn9c102_core.c b/drivers/media/usb/sn9c102/sn9c102_core.c
> index 2cb44de..33dc595 100644
> --- a/drivers/media/usb/sn9c102/sn9c102_core.c
> +++ b/drivers/media/usb/sn9c102/sn9c102_core.c
> @@ -784,12 +784,14 @@ end_of_frame:
>  				      cam->sensor.pix_format.pixelformat ==
>  				      V4L2_PIX_FMT_JPEG) && eof)) {
>  					u32 b;
> +					unsigned long flags;
>  
>  					b = (*f)->buf.bytesused;
>  					(*f)->state = F_DONE;
>  					(*f)->buf.sequence= ++cam->frame_count;
>  
> -					spin_lock(&cam->queue_lock);
> +					spin_lock_irqsave(&cam->queue_lock,
> +							  flags);
>  					list_move_tail(&(*f)->frame,
>  						       &cam->outqueue);
>  					if (!list_empty(&cam->inqueue))
> @@ -799,7 +801,8 @@ end_of_frame:
>  							frame );
>  					else
>  						(*f) = NULL;
> -					spin_unlock(&cam->queue_lock);
> +					spin_unlock_irqrestore(&cam->queue_lock,
> +							       flags);
>  
>  					memcpy(cam->sysfs.frame_header,
>  					       cam->sof.header, soflen);
> 
