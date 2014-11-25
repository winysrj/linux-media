Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46406 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaKYRKV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 12:10:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1XtJd4-0002A1-Lz
	for linux-media@vger.kernel.org; Tue, 25 Nov 2014 18:10:18 +0100
Received: from 94.197.119.37.threembb.co.uk ([94.197.119.37])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 18:10:18 +0100
Received: from tvboxspy by 94.197.119.37.threembb.co.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 18:10:18 +0100
To: linux-media@vger.kernel.org
From: Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: [PATCH] [media] lmed04: add missing breaks
Date: Tue, 25 Nov 2014 17:10:00 +0000
Message-ID: <5474B7E8.5020402@gmail.com>
References: <d442b15fb4deb2b5d516e2dae1f569b1d5472399.1416914348.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <d442b15fb4deb2b5d516e2dae1f569b1d5472399.1416914348.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/11/14 11:19, Mauro Carvalho Chehab wrote:
> drivers/media/usb/dvb-usb-v2/lmedm04.c:828 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'
> drivers/media/usb/dvb-usb-v2/lmedm04.c:849 lme_firmware_switch() warn: missing break? reassigning 'st->dvb_usb_lme2510_firmware'
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> index 9f2c5459b73a..99587418f4f0 100644
> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> @@ -826,6 +826,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
>   				break;
>   			}
>   			st->dvb_usb_lme2510_firmware = TUNER_LG;
> +			break;
>   		case TUNER_LG:
>   			fw_lme = fw_lg;
>   			ret = request_firmware(&fw, fw_lme, &udev->dev);
> @@ -847,6 +848,7 @@ static const char *lme_firmware_switch(struct dvb_usb_device *d, int cold)
>   				break;
>   			}
>   			st->dvb_usb_lme2510_firmware = TUNER_LG;
> +			break;
>   		case TUNER_LG:
>   			fw_lme = fw_c_lg;
>   			ret = request_firmware(&fw, fw_lme, &udev->dev);
>
The break is not missing it's three lines above.

All these switches are fall through until it finds firmware the user has.

The switch comes into play when the firmware needs to changed.

Malcolm



