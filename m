Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083AbaDMM20 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Apr 2014 08:28:26 -0400
Message-ID: <534A82DE.9080908@redhat.com>
Date: Sun, 13 Apr 2014 14:28:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <jdelvare@suse.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH] [media] Prefer gspca_sonixb over sn9c102 for all devices
References: <20140411091532.2a1bcce2@endymion.delvare>
In-Reply-To: <20140411091532.2a1bcce2@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/11/2014 09:15 AM, Jean Delvare wrote:
> The sn9c102 driver is deprecated. It was moved to staging in
> anticipation of its removal in a future kernel version. However, USB
> devices 0C45:6024 and 0C45:6025 are still handled by sn9c102 when
> both sn9c102 and gspca_sonixb are enabled.
> 
> We must migrate all the users of these devices to the gspca_sonixb
> driver now, so that it gets sufficient testing before the sn9c102
> driver is finally phased out.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Luca Risolia <luca.risolia@studio.unibo.it>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> I consider this a bug fix, I believe it should go upstream ASAP.

Agreed:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Mauro, can you pick this up directly, or do you want a pull-req from me
for this?

Regards,

Hans


> 
>  drivers/media/usb/gspca/sonixb.c                 |    2 --
>  drivers/staging/media/sn9c102/sn9c102_devtable.h |    2 --
>  2 files changed, 4 deletions(-)
> 
> --- linux-3.15-rc0.orig/drivers/media/usb/gspca/sonixb.c	2014-04-11 08:57:26.932408285 +0200
> +++ linux-3.15-rc0/drivers/media/usb/gspca/sonixb.c	2014-04-11 09:02:32.151943578 +0200
> @@ -1430,10 +1430,8 @@ static const struct usb_device_id device
>  	{USB_DEVICE(0x0c45, 0x600d), SB(PAS106, 101)},
>  	{USB_DEVICE(0x0c45, 0x6011), SB(OV6650, 101)},
>  	{USB_DEVICE(0x0c45, 0x6019), SB(OV7630, 101)},
> -#if !IS_ENABLED(CONFIG_USB_SN9C102)
>  	{USB_DEVICE(0x0c45, 0x6024), SB(TAS5130CXX, 102)},
>  	{USB_DEVICE(0x0c45, 0x6025), SB(TAS5130CXX, 102)},
> -#endif
>  	{USB_DEVICE(0x0c45, 0x6027), SB(OV7630, 101)}, /* Genius Eye 310 */
>  	{USB_DEVICE(0x0c45, 0x6028), SB(PAS202, 102)},
>  	{USB_DEVICE(0x0c45, 0x6029), SB(PAS106, 102)},
> --- linux-3.15-rc0.orig/drivers/staging/media/sn9c102/sn9c102_devtable.h	2014-04-11 08:57:26.932408285 +0200
> +++ linux-3.15-rc0/drivers/staging/media/sn9c102/sn9c102_devtable.h	2014-04-11 09:02:32.151943578 +0200
> @@ -48,10 +48,8 @@ static const struct usb_device_id sn9c10
>  	{ SN9C102_USB_DEVICE(0x0c45, 0x600d, BRIDGE_SN9C102), },
>  /*	{ SN9C102_USB_DEVICE(0x0c45, 0x6011, BRIDGE_SN9C102), }, OV6650 */
>  	{ SN9C102_USB_DEVICE(0x0c45, 0x6019, BRIDGE_SN9C102), },
> -#endif
>  	{ SN9C102_USB_DEVICE(0x0c45, 0x6024, BRIDGE_SN9C102), },
>  	{ SN9C102_USB_DEVICE(0x0c45, 0x6025, BRIDGE_SN9C102), },
> -#if !defined CONFIG_USB_GSPCA_SONIXB && !defined CONFIG_USB_GSPCA_SONIXB_MODULE
>  	{ SN9C102_USB_DEVICE(0x0c45, 0x6028, BRIDGE_SN9C102), },
>  	{ SN9C102_USB_DEVICE(0x0c45, 0x6029, BRIDGE_SN9C102), },
>  	{ SN9C102_USB_DEVICE(0x0c45, 0x602a, BRIDGE_SN9C102), },
> 
> 
