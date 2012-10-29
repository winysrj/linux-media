Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39299 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761028Ab2J2WPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Oct 2012 18:15:00 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2354326eek.19
        for <linux-media@vger.kernel.org>; Mon, 29 Oct 2012 15:14:58 -0700 (PDT)
Message-ID: <508EF1CF.8090602@googlemail.com>
Date: Mon, 29 Oct 2012 23:14:55 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com> <20121028175752.447c39d5@redhat.com> <508EA1B8.3070304@googlemail.com> <20121029180348.7e7967aa@redhat.com>
In-Reply-To: <20121029180348.7e7967aa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 29.10.2012 22:03, schrieb Mauro Carvalho Chehab:
> Em Mon, 29 Oct 2012 17:33:12 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 28.10.2012 21:57, schrieb Mauro Carvalho Chehab:
>>> Em Sun, 21 Oct 2012 19:52:05 +0300
>>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>>>
>>>> This patch series adds support for USB bulk transfers to the em28xx driver.
>>>>
>>>> Patch 1 is a bugfix for the image data processing with non-interlaced devices (webcams)
>>>> that should be considered for stable (see commit message).
>>>>
>>>> Patches 2-21 extend the driver to support USB bulk transfers.
>>>> USB endpoint mapping had to be extended and is a bit tricky.
>>>> It might still not be sufficient to handle ALL isoc/bulk endpoints of ALL existing devices,
>>>> but it should work with the devices we have seen so far and (most important !) 
>>>> preserves backwards compatibility to the current driver behavior.
>>>> Isoc endpoints/transfers are preffered by default, patch 21 adds a module parameter to change this behavior.
>>>>
>>>> The last two patches are follow-up patches not really related to USB tranfers.
>>>> Patch 22 reduces the code size in em28xx-video by merging the two URB data processing functions 
>>>> and patch 23 enables VBI-support for em2840-devices.
>>>>
>>>> Please note that I could test the changes with an analog non-interlaced non-VBI device only !
>>>> So further tests with DVB/interlaced/VBI devices are strongly recommended !
>>> Did a quick test here with all applied, with analog TV with xawtv and tvtime. 
>>> Didn't work.
>> Ok, thanks for testing.
>>
>>> I'll need to postpone it, until I have more time to double check it and bisect.
>> I would also need further informations about the test you've made (did
>> you enable bulk ?) and the device you used (supports VBI ?).
> I used a WinTV HVR-950/980. Logs enclosed.
>
> Regards,
> Mauro

Thanks.
Did you load the module with prefer_bulk=1 ?
You just started xawtv/tvtime but got no picture, right ?

There is nothing unusual in the log, except...

...
> [ 8412.464698] xc2028 3-0061: Can't find firmware for type=BASE INIT1 F8MHZ MTS (4007), id 0000000000000000.
...
> [ 8412.464709] xc2028 3-0061: Can't find firmware for type=BASE INIT1 MTS (4005), id 0000000000000000.
...
> [ 8412.490804] xc2028 3-0061: Can't find firmware for type=MTS SCODE (20000004), id 0000000100000007.

and

...
> [ 8454.966006] xc2028 3-0061: xc2028_get_reg 0002 called
> [ 8454.990113] xc2028 3-0061: i2c input error: rc = -19 (should be 2)
> [ 8454.996282] xc2028 3-0061: xc2028_signal called
> [ 8454.997656] xc2028 3-0061: xc2028_get_reg 0002 called
> [ 8455.021846] xc2028 3-0061: i2c input error: rc = -19 (should be 2)

Are these errors normal ?
Are you sure the device is working properly without my patches ?

You could try to load the em28xx module with usb_debug=1.

Regards,
Frank


