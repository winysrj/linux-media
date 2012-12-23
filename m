Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:32902 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2LWNeL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 08:34:11 -0500
Received: by mail-ea0-f182.google.com with SMTP id a14so2626885eaa.13
        for <linux-media@vger.kernel.org>; Sun, 23 Dec 2012 05:34:10 -0800 (PST)
Message-ID: <50D70864.4070903@googlemail.com>
Date: Sun, 23 Dec 2012 14:34:28 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 16/21] em28xx: rename usb debugging module parameter
 and macro
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com> <1352398313-3698-17-git-send-email-fschaefer.oss@googlemail.com> <20121222181019.775f8c3f@redhat.com>
In-Reply-To: <20121222181019.775f8c3f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 22.12.2012 21:10, schrieb Mauro Carvalho Chehab:
> Em Thu,  8 Nov 2012 20:11:48 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Rename module parameter isoc_debug to usb_debug and macro
>> em28xx_isocdbg to em28xx_usb dbg to reflect that they are
>> used for isoc and bulk USB transfers.
>>
>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
>> ---
>>  drivers/media/usb/em28xx/em28xx-video.c |   58 +++++++++++++++----------------
>>  1 Datei geändert, 28 Zeilen hinzugefügt(+), 30 Zeilen entfernt(-)
>>
>> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
>> index d6de1cc..f435206 100644
>> --- a/drivers/media/usb/em28xx/em28xx-video.c
>> +++ b/drivers/media/usb/em28xx/em28xx-video.c
>> @@ -58,13 +58,13 @@
>>  		printk(KERN_INFO "%s %s :"fmt, \
>>  			 dev->name, __func__ , ##arg); } while (0)
>>  
>> -static unsigned int isoc_debug;
>> -module_param(isoc_debug, int, 0644);
>> -MODULE_PARM_DESC(isoc_debug, "enable debug messages [isoc transfers]");
>> +static unsigned int usb_debug;
>> +module_param(usb_debug, int, 0644);
>> +MODULE_PARM_DESC(usb_debug, "enable debug messages [isoc transfers]");
> NACK: usb_debug is too generic: it could refer to control URB's, stream
> URB's, and other non-URB related USB debugging.

Depends on what you think should be the role of this debug parameter.

> Also, it can cause some harm for the ones using it.
>
> As the rest of this series don't depend on this one, I'll just skip it.
>
> IMHO, the better is to either live it as-is, to avoid breaking for
> someone with "isoc_debug" parameter on their /etc/modprobe.d, or to
> do a "deprecate" path:
>
> 	- adding a new one called "stream_debug" (or something like that);
> 	- keep the old one for a while, printing a warning message to
> point that this got removed; 
> 	- after a few kernel cycles, remove the legacy one.

So module parameters are part of the API ? Hmmm... that's new to me.

> Even better: simply unify all debug params into a single one, where 
> each bit means one type of debug, like what was done on other drivers.

Yeah, I agree, that would be the best solution.
The whole debugging code could need an overhault, but I really can't do
that all at once.

Regards,
Frank


