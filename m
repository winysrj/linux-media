Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38627 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750769AbdEBRAV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 13:00:21 -0400
Subject: Re: [PATCH 1/2] em28xx: allow setting the eeprom bus at cards struct
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <05c4899146e7f2cfa1d0bc7a5118e3f2294ede40.1493638682.git.mchehab@s-opensource.com>
 <2431f8bf-1bbd-ffa6-1e72-488c31c9c2a7@googlemail.com>
 <20170501145425.10388b37@vento.lan>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <6c672c61-9dde-a8c7-c660-c5659d093bce@googlemail.com>
Date: Tue, 2 May 2017 19:00:39 +0200
MIME-Version: 1.0
In-Reply-To: <20170501145425.10388b37@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 01.05.2017 um 19:54 schrieb Mauro Carvalho Chehab:
> Hi Frank,
>
> Em Mon, 1 May 2017 16:11:51 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 01.05.2017 um 13:38 schrieb Mauro Carvalho Chehab:
>>> Right now, all devices use bus 0 for eeprom. However, newer
>>> versions of Terratec H6 use a different buffer for eeprom.
>>>
>>> So, add support to use a different I2C address for eeprom.  
>> Has this been tested ?
>> Did you read my reply to the previous patch version ?:
>> See http://www.spinics.net/lists/linux-media/msg114860.html
>>
>> I doubt it will work. At least not for the device from the thread in the
>> Kodi-forum.
> Yes. Someone at IRC were complaining about this device (his nick is
> buxy81). 
Ahh, you are in contact with him ? That's good.

> According with the tests he did, with both patches his
> device is now working.
I guess it works because (due to the first patch) no eeprom is detected
anymore.
In this case the driver prints a "board has no eeprom" message to the
log and continues.

> That's said, it would be great if he could provide us more details
> about the tests he did, with the logs enabled, in order for us to see
> if the eeprom contents is properly read.
Yes, further tests/details are required.
Can you ask him to join the list ?

Regards,
Frank



>
>
> Thanks,
> Mauro
