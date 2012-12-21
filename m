Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab2LULiz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 06:38:55 -0500
Message-ID: <50D4441E.9060005@redhat.com>
Date: Fri, 21 Dec 2012 12:12:30 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org,
	Jacob Schloss <jacob.schloss@unlimitedautomata.com>
Subject: Re: [PATCH] [media] gspca_kinect: add Kinect for Windows USB id
References: <1354948731.10575.8.camel@andromeda> <1355095105-23310-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1355095105-23310-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 12/10/2012 12:18 AM, Antonio Ospite wrote:
> From: Jacob Schloss <jacob.schloss@unlimitedautomata.com>
>
> Add the USB ID for the Kinect for Windows RGB camera so it can be used
> with the gspca_kinect driver.
>
> Signed-off-by: Jacob Schloss <jacob.schloss@unlimitedautomata.com>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>
> Thanks Jacob, I took the liberty to rebase the patch on top of
> linux-3.7.0-rc7 as the gspca location has changed from
> drivers/media/video/gspca to drivers/media/usb/gspca
>
> It will be a little easier for HdG to apply it.

Thanks I've added this patch to my tree, and it will be included
in my fixes pull-req for 3.8 to Mauro later today.

Regards,

Hans

>
> Regards,
>     Antonio
>
>   drivers/media/usb/gspca/kinect.c |    1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
> index 40ad668..3773a8a 100644
> --- a/drivers/media/usb/gspca/kinect.c
> +++ b/drivers/media/usb/gspca/kinect.c
> @@ -381,6 +381,7 @@ static const struct sd_desc sd_desc = {
>   /* -- module initialisation -- */
>   static const struct usb_device_id device_table[] = {
>   	{USB_DEVICE(0x045e, 0x02ae)},
> +	{USB_DEVICE(0x045e, 0x02bf)},
>   	{}
>   };
>
>
