Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:39024 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab3AFUgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 15:36:18 -0500
Received: by mail-bk0-f52.google.com with SMTP id w5so8006216bku.39
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 12:36:17 -0800 (PST)
Message-ID: <50E9E05D.9090403@googlemail.com>
Date: Sun, 06 Jan 2013 21:36:45 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: BUG: bttv does not load module ir-kbd-i2c for Hauppauge model
 37284, rev B421
References: <50E831F2.70400@googlemail.com> <20130105135734.237068c5@redhat.com>
In-Reply-To: <20130105135734.237068c5@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.01.2013 16:57, schrieb Mauro Carvalho Chehab:
> Em Sat, 05 Jan 2013 15:00:18 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> While we are at it ;) :
>>
>> [   15.280772] bttv: Bt8xx card found (0)
>> [   15.281349] bttv: 0: Bt878 (rev 17) at 0000:01:08.0, irq: 18,
>> latency: 32, mmio: 0xfdfff000
>> [   15.281386] bttv: 0: detected: Hauppauge WinTV [card=10], PCI
>> subsystem ID is 0070:13eb
>> [   15.281391] bttv: 0: using: Hauppauge (bt878) [card=10,insmod option]
>> [   15.283964] bttv: 0: Hauppauge/Voodoo msp34xx: reset line init [5]
>> [   15.316043] tveeprom 4-0050: Hauppauge model 37284, rev B421, serial#
>> 5111944
>> [   15.316049] tveeprom 4-0050: tuner model is Philips FM1216 (idx 21,
>> type 5)
>> [   15.316054] tveeprom 4-0050: TV standards PAL(B/G) (eeprom 0x04)
>> [   15.316059] tveeprom 4-0050: audio processor is MSP3410D (idx 5)
>> [   15.316063] tveeprom 4-0050: has radio
>> [   15.316066] bttv: 0: Hauppauge eeprom indicates model#37284
>> [   15.316071] bttv: 0: tuner type=5
>> [   16.178816] bttv: 0: registered device video0
>> [   16.179071] bttv: 0: registered device vbi0
>> [   16.180587] bttv: 0: registered device radio0
>>
>> When I load module ir-kbd-i2c manually:
>>
>> Registered IR keymap rc-hauppauge
>> input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input6
>> rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
>> ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-4/4-0018/ir0 [bt878 #0 [sw]]
>>
>> Remote control works fine then.
> Yeah, this is a known misfeature of bttv, and very likely documented on
> several wiki pages like those:
> 	http://linuxtv.org/wiki/index.php/Remote_controllers-V4L
> (btw, this wiki page is very likely outdated)
> 	http://www.mythtv.org/wiki/Ir-kbd-i2c
> 	http://www.linuxtv.org/wiki/index.php/Prolink_Pixelview_PlayTV_Pro
>
> I can't remember if this were always this way, or if this was
> caused by the I2C core redesign (2006?). I think it was always like that,
> and, as I2C comes with a cost (polling can affect video processing with
> old machines), so, we decided to not do the auto-load on the older
> drivers that weren't doing it already.

I'm not sure I understand you. Is it a misfeature or intentional ?
Does polling 3 bytes every 100ms really affect the performance of video
processing in a perceptable manner ?

> Btw, the fact that there's no clear indication about what bttv boards
> require I2C made hard to remove the get_key codes from ir-kbd-i2c.

See my previous post, I thought the intention is to do the opposite.

> It probably makes sense to add a "has_ir_i2c" field at bttv, add a flag
> there at modprobe to prevent the autoload, and start tagging the boards
> with I2C IR with such tag.

Without having looked into the code, it seems that the driver detects
the i2c rc already without a board flag.
Otherwise it wouldn't register the i2c device. Unfortunately, it doesn't
display a message.

> If you care enough, feel free to send us such patch.

I care enough, but it has a low priority for me at the moment.

Regards,
Frank

> Cheers,
> Mauro

