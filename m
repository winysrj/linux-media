Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61731 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273Ab2HFSqQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 14:46:16 -0400
Received: by lagy9 with SMTP id y9so920792lag.19
        for <linux-media@vger.kernel.org>; Mon, 06 Aug 2012 11:46:15 -0700 (PDT)
Message-ID: <502010EB.7050003@iki.fi>
Date: Mon, 06 Aug 2012 21:46:03 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [BUG] Re: dvb_usb_lmedm04 crash Kernel (rs2000)
References: <501AE90E.2020201@iki.fi> <1343950313.11458.10.camel@router7789>
In-Reply-To: <1343950313.11458.10.camel@router7789>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/03/2012 02:31 AM, Malcolm Priestley wrote:
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


Aug  6 20:56:34 localhost kernel: [19094.248540] LME2510(C): Firmware 
Status: 6 (44)
Aug  6 20:56:34 localhost kernel: [19094.251541] LME2510(C): FRM No 
Firmware Found - please install
Aug  6 20:56:34 localhost kernel: [19094.251559] usbcore: registered new 
interface driver LME2510C_DVB-S

It is good to print needed fw name. I found it from the documentation,
Documentation/dvb/lmedm04.txt.

Could you drop me that firmware privately as I don't wish to install 
Windows drivers in order to extract it.


Tested-by: Antti Palosaari <crope@iki.fi>

> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>   drivers/media/dvb/dvb-usb/lmedm04.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> index 25d1031..26ba5bc 100644
> --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> @@ -878,6 +878,10 @@ static int lme_firmware_switch(struct usb_device *udev, int cold)
>   		fw_lme = fw_c_rs2000;
>   		ret = request_firmware(&fw, fw_lme, &udev->dev);
>   		dvb_usb_lme2510_firmware = TUNER_RS2000;
> +		if (ret == 0)
> +			break;
> +		info("FRM No Firmware Found - please install");
> +		cold_fw = 0;
>   		break;
>   	default:
>   		fw_lme = fw_c_s7395;
>


regards
Antti



-- 
http://palosaari.fi/
