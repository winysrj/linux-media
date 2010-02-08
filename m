Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:43277 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256Ab0BHSxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 13:53:13 -0500
Message-ID: <4B704066.2020906@arcor.de>
Date: Mon, 08 Feb 2010 17:48:38 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 8/12] tm6000: add tuner parameter
References: <1265410631-11955-1-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-2-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-3-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-4-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-5-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-6-git-send-email-stefan.ringel@arcor.de> <1265410631-11955-7-git-send-email-stefan.ringel@arcor.de> <4B6F7D37.50404@redhat.com> <4B7033FC.7000404@arcor.de>
In-Reply-To: <4B7033FC.7000404@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 08.02.2010 16:55, schrieb Stefan Ringel:
> Am 08.02.2010 03:55, schrieb Mauro Carvalho Chehab:
>   
>> stefan.ringel@arcor.de wrote:
>>
>>   
>>     
>>> +		ctl.vhfbw7 = 1;
>>> +		ctl.uhfbw8 = 1;
>>>     
>>>       
>> I don't think you need to set this, as the driver will automatically do the firmware
>> tricks for the firmwares. This will probably just change the default to start
>> wit firmware 7/8.
>>
>>   
>>     
> if it's going to bw 7 it doesn't use DTV 7, it's use DTV 7 not DTV78, I
> have it tested. I think if it's switch between DTV7 and DTV 8 it's not
> always set DTV78. ( it's set DTV 7 DTV 8 or DTV78)
>
>   

    switch (bw) {
    case BANDWIDTH_8_MHZ:
        if (p->frequency < 470000000)
            priv->ctrl.vhfbw7 = 0;
        else
            priv->ctrl.uhfbw8 = 1;
        type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV8;
        type |= F8MHZ;
        break;
    case BANDWIDTH_7_MHZ:
        if (p->frequency < 470000000)
            priv->ctrl.vhfbw7 = 1;
        else
            priv->ctrl.uhfbw8 = 0;
        type |= (priv->ctrl.vhfbw7 && priv->ctrl.uhfbw8) ? DTV78 : DTV7;
        type |= F8MHZ;
        break;
    case BANDWIDTH_6_MHZ:
        type |= DTV6;
        priv->ctrl.vhfbw7 = 0;
        priv->ctrl.uhfbw8 = 0;
        break;
    default:
        tuner_err("error: bandwidth not supported.\n");
    };

That is the actually part from tuner-xc2028.c, but I think here is the
checking wrong if Bandwidth 8 MHz & frequency < 470 MHz then DTV8, and
if Bandwidth 7 MHz & frequency => 470 MHz then DTV7. The first check in
code is OK, but the second check in code is not OK.

-- 
Stefan Ringel <stefan.ringel@arcor.de>

