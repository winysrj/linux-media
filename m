Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54968 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab0LSPjm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 10:39:42 -0500
Received: by wyb28 with SMTP id 28so2142627wyb.19
        for <linux-media@vger.kernel.org>; Sun, 19 Dec 2010 07:39:41 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: linux-media@vger.kernel.org
Subject: Re: Problem with sound on SAA7134 TV card
Date: Sun, 19 Dec 2010 15:39:36 +0000
References: <201012172109.06744.chris2553@googlemail.com> <201012181243.00576.chris2553@googlemail.com>
In-Reply-To: <201012181243.00576.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012191539.36842.chris2553@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday 18 December 2010, Chris Clayton wrote:

<snip>

> [chris:~]$ dmesg | grep saa7
> saa7130/34: v4l2 driver version 0.2.16 loaded
> saa7134 0000:03:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
> saa7133[0]: found at 0000:03:00.0, rev: 209, irq: 20, latency: 32, mmio:
> 0xe1605000
> saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1120
> DVB-T/Hybrid [card=156,autodetected]
> saa7133[0]: board init: gpio is 440100
> saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b0 ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 20 00 ff ff ff
> saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 c4 ce 6e f0 73 05 29 00
> saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 39 8d 72 07 70 73 09
> saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 01 72 0f 45 72
> saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 95 00 00 00 00 00
> saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: hauppauge eeprom: model=67209
> tuner 1-004b: chip found @ 0x96 (saa7133[0])
> saa7133[0]: dsp access error
> saa7133[0]: dsp access error
> saa7133[0]: registered device video1 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> DVB: registering new adapter (saa7133[0])
> saa7134 ALSA driver for DMA sound loaded
> saa7133[0]/alsa: saa7133[0] at 0xe1605000 irq 20 registered as card -1
>
> That last line looks a little suspicious to me with the card being
> registered as -1. The two "dsp access error" lines might mean something
> too.
>

After looking at the code I see that the report that the card is registered 
as -1 isn't actually a problem, although the message is a bit deceptive.

The two dsp access error message are emitted by saa_dsp_wait_bit() in 
saa7134_tvaudio.c, but the message sdon't appear every boot and even when they 
don't the sound output is of the poor quality that I have reported.

I shoulfd also mention that  I get the same problem with 2.6.37-rc{5,6}+ or 
2.6.36.2. With 2 6 .35.9, mplayer reports an error opening a device.

That's the end of my debugging capablities reached, so I would be grateful for 
any help that can be offered.

<snip>

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
