Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35359 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2HCLVk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 07:21:40 -0400
Received: by bkwj10 with SMTP id j10so205129bkw.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 04:21:39 -0700 (PDT)
Message-ID: <501BB43D.70907@gmail.com>
Date: Fri, 03 Aug 2012 13:21:33 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [BUG] Re: dvb_usb_lmedm04 crash Kernel (rs2000)
References: <501AE90E.2020201@iki.fi> <1343950313.11458.10.camel@router7789>
In-Reply-To: <1343950313.11458.10.camel@router7789>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2012 01:31 AM, Malcolm Priestley wrote:
> On Thu, 2012-08-02 at 23:54 +0300, Antti Palosaari wrote:
>> Moi Malcolm,
>> Any idea why this seems to crash Kernel just when device is plugged?
>>
> Hi Antti
> 
> Yes, there missing error handling when no firmware file found.
> 
> It seems that this is more of a problem with udev-182+.
> 
> However, so far udev-182 is only a problem on first ever plug.
> 
> Regards
> 
> 
> Malcolm 
> 
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/media/dvb/dvb-usb/lmedm04.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> index 25d1031..26ba5bc 100644
> --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> @@ -878,6 +878,10 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
>  		fw_lme = fw_c_rs2000;
>  		ret = request_firmware(&fw, fw_lme, &udev->dev);
>  		dvb_usb_lme2510_firmware = TUNER_RS2000;
> +		if (ret == 0)
> +			break;
> +		info("FRM No Firmware Found - please install");
> +		cold_fw = 0;
>  		break;
>  	default:
>  		fw_lme = fw_c_s7395;
> 

Do we need fw blob anymore!?
http://www.spinics.net/lists/hotplug/msg05257.html
…
"Firmware is loaded natively by udev now, the external 'firmware' binary
is no longer used."
…

Cheers,
poma
