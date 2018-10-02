Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:45262 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbeJBNBN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Oct 2018 09:01:13 -0400
Subject: Re: [PATCH] MAINTAINERS: Remove stale file entry for the Atmel ISI
 driver
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Joe Perches <joe@perches.com>, Josh Wu <josh.wu@atmel.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
References: <20180930065448.5019-1-laurent.pinchart@ideasonboard.com>
 <20180930063034.1dab99d9@coco.lan>
 <7150c1de00db05ec3c1a53611c156fb823d7f345.camel@perches.com>
 <20181001135101.536b4c22@coco.lan>
From: Eugen Hristev <eugen.hristev@microchip.com>
Message-ID: <0a181f1b-9720-d041-55c5-9df5bde3b920@microchip.com>
Date: Tue, 2 Oct 2018 09:15:45 +0300
MIME-Version: 1.0
In-Reply-To: <20181001135101.536b4c22@coco.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01.10.2018 19:51, Mauro Carvalho Chehab wrote:
> Em Sun, 30 Sep 2018 02:40:35 -0700
> Joe Perches <joe@perches.com> escreveu:
> 
>> On Sun, 2018-09-30 at 06:30 -0300, Mauro Carvalho Chehab wrote:
>>> Em Sun, 30 Sep 2018 09:54:48 +0300
>>> Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:
>>>    
>>>> include/media/atmel-isi got removed three years ago without the
>>>> MAINTAINERS file being updated. Remove the stale entry.
>>>>
>>>> Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for platform data")
>>>> Reported-by: Joe Perches <joe@perches.com>
>>>> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> ---
>>>>   MAINTAINERS | 1 -
>>>>   1 file changed, 1 deletion(-)
>>>>
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>> []
>>>> @@ -2497,7 +2497,6 @@ M:	Ludovic Desroches <ludovic.desroches@microchip.com>
>>>>   L:	linux-media@vger.kernel.org
>>>>   S:	Supported
>>>>   F:	drivers/media/platform/atmel/atmel-isi.c
>>>> -F:	include/media/atmel-isi.h
>>>
>>> I guess the right fix would be to replace it by:
>>>
>>> F: drivers/media/platform/atmel/atmel-isi.h
>>
>> Or replace both F entries with:
>>
>> F:	drivers/media/platform/atmel/atmel-isi.*
>>
>> Or combine the 2 MICROCHIP sections into one
>>
>> MICROCHIP ISC DRIVER
>> M:	Eugen Hristev <eugen.hristev@microchip.com>
>> L:	linux-media@vger.kernel.org
>> S:	Supported
>> F:	drivers/media/platform/atmel/atmel-isc.c
>> F:	drivers/media/platform/atmel/atmel-isc-regs.h
>> F:	devicetree/bindings/media/atmel-isc.txt
>>
>> MICROCHIP ISI DRIVER
>> M:	Eugen Hristev <eugen.hristev@microchip.com>
>> L:	linux-media@vger.kernel.org
>> S:	Supported
>> F:	drivers/media/platform/atmel/atmel-isi.c
>> F:	include/media/atmel-isi.h
>>
>> and maybe use something like:
>>
>> MICROCHIP MEDIA DRIVERS
>> M:	Eugen Hristev <eugen.hristev@microchip.com>
>> L:	
>> linux-media@vger.kernel.org
>> S:	Supported
>> F:	drivers/media/platform/atmel/
>> F:	devicetree/bindings/media/atmel-isc.txt
> 
> Yeah, combining both of them seems a good alternative to me.
> 
> Eugen/Ludovic/Josh,
> 
> Comments?

I am OK with combining them.

Thanks
> 
> Regards,
> Mauro
> 
>>
>>
> 
> 
> 
> Thanks,
> Mauro
> 
