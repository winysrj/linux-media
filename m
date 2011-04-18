Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41550 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab1DRO3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 10:29:00 -0400
Received: by yxs7 with SMTP id 7so1689281yxs.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 07:28:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=brbaZnupYHjwJy=VzdN6BZF9QRw@mail.gmail.com>
References: <BANLkTimKhe05sGJPGUrkD5JgwQKV_83bhQ@mail.gmail.com>
 <BANLkTinCBYFhpjqanV7U3C2a43MZmXZsqw@mail.gmail.com> <BANLkTikma80oNCF68FL8uoLY9-uakegnQw@mail.gmail.com>
 <BANLkTi=brbaZnupYHjwJy=VzdN6BZF9QRw@mail.gmail.com>
From: Madhur Jajoo <jajoo.madhur@gmail.com>
Date: Mon, 18 Apr 2011 19:58:39 +0530
Message-ID: <BANLkTikrT8o92sZ5gYT3Thy10HNYcHpSAQ@mail.gmail.com>
Subject: Re: Wrong tv tuner card detedted
To: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Devin,

       Thanks for the reply. How can i make it work ?
       Is there any wayout?

Thanks
Madhur

On Mon, Apr 18, 2011 at 7:51 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Apr 18, 2011 at 10:11 AM, Madhur Jajoo <jajoo.madhur@gmail.com> wrote:
>> lsusb result is
>>
>> madhur@madhur-desktop:~$ lsusb
>> Bus 005 Device 003: ID 12d1:140b Huawei Technologies Co., Ltd. EC1260
>> Wireless Data Modem HSD USB Card
>> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 001 Device 002: ID eb1a:2860 eMPIA Technology, Inc.
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> madhur@madhur-desktop:~$
>>
>> Also when i am doing dmesg then it saying
>>
>> 712.469413] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
>> [  712.480166] em28xx #0: found i2c device @ 0x4a [saa7113h]
>> [  712.491657] em28xx #0: found i2c device @ 0xa0 [eeprom]
>> [  712.496156] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
>> [  712.504280] em28xx #0: Your board has no unique USB ID.
>>
>> Waiting for your reply
>
> Hello Madhur,
>
> Basically, the dmesg means the device is totally unsupported.  The
> only reason it detects at all is because the vendor used the chipset
> vendor's USB PID/VID instead of issuing their own.
>
> Regards,
>
> Devin
>
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
