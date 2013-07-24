Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51219 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3GXPbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 11:31:40 -0400
Received: by mail-ea0-f170.google.com with SMTP id h10so335659eaj.1
        for <linux-media@vger.kernel.org>; Wed, 24 Jul 2013 08:31:39 -0700 (PDT)
Message-ID: <51EFF3E2.4080707@googlemail.com>
Date: Wed, 24 Jul 2013 17:33:54 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Alban Browaeys <alban.browaeys@gmail.com>
CC: m.chehab@samsung.com, linux-media@vger.kernel.org,
	Alban Browaeys <prahal@yahoo.com>
Subject: Re: [PATCH 3/4] [media] em28xx: usb power config is in the low byte.
References: <1374015983-27615-1-git-send-email-prahal@yahoo.com> <51E80958.2000701@googlemail.com> <CAMhY2AXOk+poaxcqTiDvGCWcUEQFTT025=h3WdhrOB3bQKPEoQ@mail.gmail.com> <CAMhY2AUZAFPykoxt+fw7XzzNPftcOOAXws4mwMOJrq7hzpdvUw@mail.gmail.com>
In-Reply-To: <CAMhY2AUZAFPykoxt+fw7XzzNPftcOOAXws4mwMOJrq7hzpdvUw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[2nd try - vger.kernel.org rejects html content]

Am 24.07.2013 16:16, schrieb Alban Browaeys:
> sorry the weater is getting really warm there. I will take a closer
> look at that . But mind that we grab two bytes and '<usb config for
> audio and power> <usb transfer rates>' thus I guessed we had to shift
> 4 bits the left byte (08H) to get 0:3 .

True, but with le16_to_cpu conversion everything is fine. ;)
Apart from that: a byte usually has 8 bits, not 4... ;)

Regards,
Frank

>
>
> 2013/7/24 Alban Browaeys <alban.browaeys@gmail.com
> <mailto:alban.browaeys@gmail.com>>
>
>     Agreed 4:7 are fo usb "audio" class config cofiguration and 0:3
>     are for usb configuration ... that is wat I told and what I coded
>     i the patch:
>     08H Chip Configuration Low Byte
>     D[7] Class audio or vendor audio
>     0 – Inform the host that the chip is USB audio class device
>     1 – Inform the host that the chip is vendor specific audio device
>     D[6] USB audio class volume control capability when audio source
>     is I2S device.
>     When audio source is AC97, the chip is always capable of volume
>     control
>     regardless of the state of this bit.
>     0 – Inform the host that the chip is not capable of volume control.
>     1 – Inform the host that the chip is capable of volume control.
>     D[5:4] Audio Configuration
>     00 – No audio on board.
>     01 – AC97 audio on board with 5 sample rates: 48K, 44.1K, 32K,
>     16K, and 8K.
>     2
>     10 – I S audio on board with 3 sample rate: 32K, 16K, and 8K.
>     11 – I2S audio on board with 5 sample rates: 48K, 44.1K, and 32K,
>     16K, and 8K.
>     D[3] USB Remote Wakeup Capable when set to 1
>     D[2] USB Self Power Capable when set to 1. If the chip is
>     configured to be Self Power
>     Capable, PIO7 becomes self power status input.
>     D[1:0] USB Max Power Select
>     00 – USB Max Power 500 mA
>     01 – USB Max Power 400 mA
>     10 – USB Max Power 300 mA
>     11 – USB Max Power 200 mA
>
>
>     But you current code attempt to read the usb configuration 09H . 
>
>
>     2013/7/18 Frank Schäfer <fschaefer.oss@googlemail.com
>     <mailto:fschaefer.oss@googlemail.com>>
>
>         Am 17.07.2013 01:06, schrieb Alban Browaeys:
>         > According to the em2860 datasheet, eeprom byte 08H is Chip
>         > Configuration Low Byte and 09H is High Byte.
>         > Usb power configuration is in the Low byte (same as the usb
>         audio
>         >  class config).
>         >
>         > Signed-off-by: Alban Browaeys <prahal@yahoo.com
>         <mailto:prahal@yahoo.com>>
>         > ---
>         >  drivers/media/usb/em28xx/em28xx-i2c.c | 6 +++---
>         >  1 file changed, 3 insertions(+), 3 deletions(-)
>         >
>         > diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c
>         b/drivers/media/usb/em28xx/em28xx-i2c.c
>         > index c4ff973..6ff7415 100644
>         > --- a/drivers/media/usb/em28xx/em28xx-i2c.c
>         > +++ b/drivers/media/usb/em28xx/em28xx-i2c.c
>         > @@ -743,13 +743,13 @@ static int em28xx_i2c_eeprom(struct
>         em28xx *dev, unsigned bus,
>         >               break;
>         >       }
>         >
>         > -     if (le16_to_cpu(dev_config->chip_conf) & 1 << 3)
>         > +     if (le16_to_cpu(dev_config->chip_conf) >> 4 & 1 << 3)
>         >               em28xx_info("\tUSB Remote wakeup capable\n");
>         >
>         > -     if (le16_to_cpu(dev_config->chip_conf) & 1 << 2)
>         > +     if (le16_to_cpu(dev_config->chip_conf) >> 4 & 1 << 2)
>         >               em28xx_info("\tUSB Self power capable\n");
>         >
>         > -     switch (le16_to_cpu(dev_config->chip_conf) & 0x3) {
>         > +     switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
>         >       case 0:
>         >               em28xx_info("\t500mA max power\n");
>         >               break;
>
>         NACK.
>         According to my datasheet excerpt (EM2860 Hardware Specification
>         8/18/2004), bits 0:3 are used for USB configuration and bits
>         4:7 for
>         audio configuration.
>         So the current code is correct.
>
>         Regards,
>         Frank
>
>
>

