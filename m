Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab0BHR3e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 12:29:34 -0500
Message-ID: <4B7049F3.8080208@redhat.com>
Date: Mon, 08 Feb 2010 15:29:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Stefan Ringel <stefan.ringel@arcor.de>
CC: linux-media@vger.kernel.org, dheitmueller@kernellabs.com
Subject: Re: [PATCH 5/12] tm6000: update init table and sequence for tm6010
References: <1265410096-11788-1-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-2-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-3-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-4-git-send-email-stefan.ringel@arcor.de> <1265410096-11788-5-git-send-email-stefan.ringel@arcor.de> <4B6FF3C9.2010804@redhat.com> <4B6FF763.1090203@redhat.com> <4B7037D3.5040601@arcor.de>
In-Reply-To: <4B7037D3.5040601@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Ringel wrote:
> Am 08.02.2010 12:37, schrieb Mauro Carvalho Chehab:
>> Mauro Carvalho Chehab wrote:
>>   
>>>> +		tm6000_read_write_usb (dev, 0xc0, 0x10, 0x7f1f, 0x0000, buf, 2);
>>>>       
>>   
>>> Most of the calls there are read (0xc0). I don't know any device that requires
>>> a read for it to work. I suspect that the above code is just probing to check
>>> what i2c devices are found at the board.
>>>     
>> Btw, by looking at drivers/media/dvb/frontends/zl10353_priv.h, we have an idea
>> on what the above does:
>>
>> The register 0x7f is:
>>
>>         CHIP_ID            = 0x7F,
>>
>> So, basically, the above code is reading the ID of the chip, likely to be sure that it
>> is a Zarlink 10353.
>>
>> Cheers,
>> Mauro
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
> 
> yes, but that's for activating Zarlink zl10353 and checking it --> hello
> Zarlink? If doesn't use that sequence, then cannot use Zarlink zl10353.
> 
Are you sure about that? Is this a new bug on tm6000?

Anyway, the proper place for such code is inside zl10353 driver, not outside.

-- 

Cheers,
Mauro
