Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:64830 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3ILX2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Sep 2013 19:28:42 -0400
Received: by mail-ea0-f179.google.com with SMTP id b10so223754eae.10
        for <linux-media@vger.kernel.org>; Thu, 12 Sep 2013 16:28:41 -0700 (PDT)
Date: Fri, 13 Sep 2013 01:28:38 +0200
From: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/3] [media] siano: Improve debug/info messages
Message-ID: <20130913012838.7238b80d@neutrino.exnihilo>
In-Reply-To: <1379016000-19577-3-git-send-email-m.chehab@samsung.com>
References: <1379016000-19577-1-git-send-email-m.chehab@samsung.com>
	<1379016000-19577-3-git-send-email-m.chehab@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 12 Sep 2013 16:59:59 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> wrote:

Tested-by: André Roth <neolynx@gmail.com>


> Some messages are not clear, some are debug data, but are
> shown as errors, and one message is duplicated.
> 
> Cleanup that mess in order to provide a cleaner log.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/siano/smsusb.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
> index 03761c6..74236b8 100644
> --- a/drivers/media/usb/siano/smsusb.c
> +++ b/drivers/media/usb/siano/smsusb.c
> @@ -209,8 +209,10 @@ static int smsusb_sendrequest(void *context, void *buffer, size_t size)
>  	struct sms_msg_hdr *phdr = (struct sms_msg_hdr *) buffer;
>  	int dummy;
>  
> -	if (dev->state != SMSUSB_ACTIVE)
> +	if (dev->state != SMSUSB_ACTIVE) {
> +		sms_debug("Device not active yet");
>  		return -ENOENT;
> +	}
>  
>  	sms_debug("sending %s(%d) size: %d",
>  		  smscore_translate_msg(phdr->msg_type), phdr->msg_type,
> @@ -445,14 +447,15 @@ static int smsusb_probe(struct usb_interface *intf,
>  	char devpath[32];
>  	int i, rc;
>  
> -	sms_info("interface number %d",
> +	sms_info("board id=%lu, interface number %d",
> +		 id->driver_info,
>  		 intf->cur_altsetting->desc.bInterfaceNumber);
>  
>  	if (sms_get_board(id->driver_info)->intf_num !=
>  	    intf->cur_altsetting->desc.bInterfaceNumber) {
> -		sms_err("interface number is %d expecting %d",
> -			sms_get_board(id->driver_info)->intf_num,
> -			intf->cur_altsetting->desc.bInterfaceNumber);
> +		sms_debug("interface %d won't be used. Expecting interface %d to popup",
> +			intf->cur_altsetting->desc.bInterfaceNumber,
> +			sms_get_board(id->driver_info)->intf_num);
>  		return -ENODEV;
>  	}
>  
> @@ -483,12 +486,11 @@ static int smsusb_probe(struct usb_interface *intf,
>  	}
>  	if ((udev->actconfig->desc.bNumInterfaces == 2) &&
>  	    (intf->cur_altsetting->desc.bInterfaceNumber == 0)) {
> -		sms_err("rom interface 0 is not used");
> +		sms_debug("rom interface 0 is not used");
>  		return -ENODEV;
>  	}
>  
>  	if (id->driver_info == SMS1XXX_BOARD_SIANO_STELLAR_ROM) {
> -		sms_info("stellar device was found.");
>  		snprintf(devpath, sizeof(devpath), "usb\\%d-%s",
>  			 udev->bus->busnum, udev->devpath);
>  		sms_info("stellar device was found.");
> @@ -498,7 +500,7 @@ static int smsusb_probe(struct usb_interface *intf,
>  	}
>  
>  	rc = smsusb_init_device(intf, id->driver_info);
> -	sms_info("rc %d", rc);
> +	sms_info("Device initialized with return code %d", rc);
>  	sms_board_load_modules(id->driver_info);
>  	return rc;
>  }
