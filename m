Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:41636 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328AbZJaWIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 18:08:32 -0400
Received: by pzk26 with SMTP id 26so2553384pzk.4
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 15:08:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <303a8ee30910310948o107387c5g2d89665ea2bcde7e@mail.gmail.com>
References: <4ADED23C.2080002@uq.edu.au>
	 <303a8ee30910211233r111d3378vedc1672f68728717@mail.gmail.com>
	 <1257002647.3333.7.camel@pc07.localdom.local>
	 <303a8ee30910310948o107387c5g2d89665ea2bcde7e@mail.gmail.com>
Date: Sun, 1 Nov 2009 09:08:37 +1100
Message-ID: <ef52a95d0910311508v644e998bke9e7955aa32d5da6@mail.gmail.com>
Subject: Re: Leadtek DTV-1000S
From: Michael Obst <m.obst@ugrad.unimelb.edu.au>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
    Thanks for fixing this, I can confirm that it now compiles and
inserts and the remote works, so does the av input to the tvcard
however the card does not seem to be able to tune any channels, I have
checked the old driver and that is still able to tune in channels. The
output from my dmesg is below.

Thanks
Michael Obst

[  502.761860] saa7130/34: v4l2 driver version 0.2.15 loaded
[  502.761886] saa7130[0]: found at 0000:04:01.0, rev: 1, irq: 17,
latency: 64, mmio: 0xfebffc00
[  502.761890] saa7130[0]: subsystem: 107d:6655, board: Leadtek
Winfast DTV1000S [card=175,autodetected]
[  502.761898] saa7130[0]: board init: gpio is 2121400
[  502.761938] input: saa7134 IR (Leadtek Winfast DTV as
/devices/pci0000:00/0000:00:1e.0/0000:04:01.0/input/input10
[  502.761966] IRQ 17/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[  502.912003] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43
43 a9 1c 55 d2 b2 92
[  502.912009] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff
ff ff ff ff ff ff ff
[  502.912014] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08
ff 00 8a ff ff ff ff
[  502.912019] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912024] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff
04 ff ff ff ff ff ff
[  502.912029] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912034] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912040] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912045] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912050] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912055] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912060] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912065] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912070] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912075] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.912080] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  502.928502] Chip ID is not zero. It is not a TEA5767
[  502.928544] tuner 0-0060: chip found @ 0xc0 (saa7130[0])
[  502.960501] tda8290: no gate control were provided!
[  502.960589] saa7130[0]: registered device video0 [v4l2]
[  502.960602] saa7130[0]: registered device vbi0
[  502.963002] saa7134 ALSA driver for DMA sound loaded
[  502.963003] saa7130[0]/alsa: Leadtek Winfast DTV1000S doesn't
support digital audio
[  502.963600] dvb_init() allocating 1 frontend
[  503.032771] tda18271 0-0060: creating new instance
[  503.040502] TDA18271HD/C2 detected @ 0-0060
[  503.436003] DVB: registering new adapter (saa7130[0])
[  503.436006] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[  503.764502] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[  503.764506] saa7134 0000:04:01.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[  503.766223] tda10048_firmware_upload: firmware read 24878 bytes.
[  503.766224] tda10048_firmware_upload: firmware uploading
[  507.844010] tda10048_firmware_upload: firmware uploaded

2009/11/1 Michael Krufky <mkrufky@kernellabs.com>:
> On Sat, Oct 31, 2009 at 11:24 AM, hermann pitton
> <hermann-pitton@arcor.de> wrote:
>> Hi Mike, Mauro,
>>
>> Am Mittwoch, den 21.10.2009, 15:33 -0400 schrieb Michael Krufky:
>>> On Wed, Oct 21, 2009 at 5:19 AM, Ryan Day <ryan.day@uq.edu.au> wrote:
>>> > Michael-
>>> > I wanted to see if you might be able to assist in getting a DTV-1000S to
>>> > work.  I followed the instructions on the Whirlpool forum (DL the firmware,
>>> > cp it to /lib/firmware, dl the dtv-1000s files from kernellabs.com, untar,
>>> > make, make install, reboot), and everything looks good when I install, but
>>> > when I reboot, the boot up hangs and eventually freezes.
>>> >
>>> > I thought reinstalling might give me a better chance for success with a
>>> > clean slate to work with, but the problem continues.  Unfortunately, I don't
>>> > have any of the error logs or anything, as I reinstalled.
>>> >
>>> > I can't remember the message at the first hang, but the freeze is caused by
>>> > a failure to load the LIRC module.
>>> >
>>> > Also of note is that I'm installing this card as a second tuner.  I have a
>>> > DTV-2000H already installed.  I don't know if that changes anything.
>>> >
>>> > Sorry I can't provide better info, but any advice you can give would be
>>> > great.
>>>
>>
>> there is another report for problems with the DTV-1000S now.
>>
>> Checking the above and the master tree, it turns out that the card's
>> analog entry made it into the #if 0 flyvideo tweaks in saa7134-cards.c
>> and is not valid there.
>>
>> Have to leave the house now, Mike please fix it or I'll send a fix when
>> back later in the evening.
>>
>> Cheers,
>> Hermann
>>
>
> Thanks for spotting this, Hermann ...  I just fixed the problem and
> pushed it to my DTV1000S tree.  I'll issue a pull request to Mauro
> right now.
>
> Cheers,
>
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
