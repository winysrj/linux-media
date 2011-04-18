Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36328 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab1DROLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 10:11:38 -0400
Received: by gwaa18 with SMTP id a18so1678385gwa.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 07:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinCBYFhpjqanV7U3C2a43MZmXZsqw@mail.gmail.com>
References: <BANLkTimKhe05sGJPGUrkD5JgwQKV_83bhQ@mail.gmail.com> <BANLkTinCBYFhpjqanV7U3C2a43MZmXZsqw@mail.gmail.com>
From: Madhur Jajoo <jajoo.madhur@gmail.com>
Date: Mon, 18 Apr 2011 19:41:17 +0530
Message-ID: <BANLkTikma80oNCF68FL8uoLY9-uakegnQw@mail.gmail.com>
Subject: Re: Wrong tv tuner card detedted
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

lsusb result is

madhur@madhur-desktop:~$ lsusb
Bus 005 Device 003: ID 12d1:140b Huawei Technologies Co., Ltd. EC1260
Wireless Data Modem HSD USB Card
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID eb1a:2860 eMPIA Technology, Inc.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
madhur@madhur-desktop:~$

Also when i am doing dmesg then it saying

712.469413] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
[  712.480166] em28xx #0: found i2c device @ 0x4a [saa7113h]
[  712.491657] em28xx #0: found i2c device @ 0xa0 [eeprom]
[  712.496156] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
[  712.504280] em28xx #0: Your board has no unique USB ID.

Waiting for your reply

Thanks
Madhur


On Sat, Apr 9, 2011 at 9:51 PM, Another Sillyname
<anothersname@googlemail.com> wrote:
> On 09/04/2011, Madhur Jajoo <jajoo.madhur@gmail.com> wrote:
>> Hi,
>>
>>     I am using Ubuntu 10.10. I have Gadmei UTV300 USB TV Tuner card.
>>
>>     When i am trying to do "dmesg" it saying card is detected as gadmei
>> UTV330+
>>     I have attached full log of the command.
>>     I am using tvtime software. I see that my tvtuner card is getting
>> started (through LED) when i start tvtime. But it says "No signal".
>>  Can you please help me out of this ?
>>
>>    Please find attached
>>
>> [ 3523.461728] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x274ad199
>> [ 3523.461731] em28xx #0: EEPROM info:
>> [ 3523.461733] em28xx #0:     No audio on board.
>> [ 3523.461736] em28xx #0:     500mA max power
>> [ 3523.461739] em28xx #0:     Table at 0x06, strings=0x226a, 0x108c, 0x0000
>> [ 3523.472475] em28xx #0: Identified as Unknown EM2750/28xx video
>> grabber (card=1)
>> [ 3523.484848] em28xx #0: found i2c device @ 0x4a [saa7113h]
>> [ 3523.499345] em28xx #0: found i2c device @ 0xa0 [eeprom]
>> [ 3523.503842] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
>> [ 3523.515217] em28xx #0: Your board has no unique USB ID.
>> [ 3523.515222] em28xx #0: A hint were successfully done, based on i2c
>> devicelist hash.
>> [ 3523.515225] em28xx #0: This method is not 100% failproof.
>> [ 3523.515228] em28xx #0: If the board were missdetected, please email
>> this log to:
>> [ 3523.515230] em28xx #0:     V4L Mailing List  <linux-media@vger.kernel.org>
>> [ 3523.515233] em28xx #0: Board detected as Gadmei UTV330+
>> [ 3523.876422] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a
>> (em28xx #0)
>> [ 3524.588691] All bytes are equal. It is not a TEA5767
>> [ 3524.588904] tuner 1-0060: chip found @ 0xc0 (em28xx #0)
>> [ 3524.589567] tuner-simple 1-0060: creating new instance
>> [ 3524.589572] tuner-simple 1-0060: type set to 69 (Tena TNF 5335 and
>> similar models)
>> [ 3524.624020] Registered IR keymap rc-gadmei-rm008z
>> [ 3524.624199] input: em28xx IR (em28xx #0) as
>> /devices/pci0000:00/0000:00:1d.7/usb1/1-7/rc/rc0/input7
>> [ 3524.624378] rc0: em28xx IR (em28xx #0) as
>> /devices/pci0000:00/0000:00:1d.7/usb1/1-7/rc/rc0
>> [ 3524.636187] em28xx #0: Config register raw data: 0xc0
>> [ 3524.684030] em28xx #0: v4l2 driver version 0.1.2
>> [ 3525.176259] em28xx #0: V4L2 video device registered as video0
>> [ 3525.176266] em28xx #0: V4L2 VBI device registered as vbi0
>>
>> Waiting for your reply.
>>
>> Thanks
>> Madhur
>>
> Can you do a lsusb and report the results.
>
