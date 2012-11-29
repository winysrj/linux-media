Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43565 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab2K2OXF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 09:23:05 -0500
Message-ID: <50B77045.3010102@redhat.com>
Date: Thu, 29 Nov 2012 15:25:09 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca - stv06xx: Fix a regression with the bridge/sensor
 vv6410
References: <20121122125906.35d6f98a@armhf>
In-Reply-To: <20121122125906.35d6f98a@armhf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch I've added this to my tree, and it is part
of the pull-request I just send to Mauro for 3.8

Regards,

Hans

On 11/22/2012 12:59 PM, Jean-Francois Moine wrote:
> From: Jean-François Moine <moinejf@free.fr>
>
> Setting the H and V flip controls at webcam connection time prevents
> the webcam to work correctly.
>
> This patch checks if the webcam is streaming before setting the flips.
> It does not set the flips (nor other controls) at webcam start time.
>
> Tested-by: Philippe ROUBACH <philippe.roubach@free.fr>
> Signed-off-by: Jean-François Moine <moinejf@free.fr>
>
> --- a/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
> +++ b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
> @@ -52,9 +52,13 @@
>
>   	switch (ctrl->id) {
>   	case V4L2_CID_HFLIP:
> +		if (!gspca_dev->streaming)
> +			return 0;
>   		err = vv6410_set_hflip(gspca_dev, ctrl->val);
>   		break;
>   	case V4L2_CID_VFLIP:
> +		if (!gspca_dev->streaming)
> +			return 0;
>   		err = vv6410_set_vflip(gspca_dev, ctrl->val);
>   		break;
>   	case V4L2_CID_GAIN:
>
