Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61814 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758261AbaDIIg3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 04:36:29 -0400
Received: by mail-ob0-f171.google.com with SMTP id wn1so2324092obc.2
        for <linux-media@vger.kernel.org>; Wed, 09 Apr 2014 01:36:29 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Apr 2014 09:36:29 +0100
Message-ID: <CA+d4A-_qqjKVq3amo3kRMLpVYP-KE=CLxhC76rFFaKZ31a=Khw@mail.gmail.com>
Subject: Kworld PlusTV All in One PI610 - need help
From: Julian Day <julianfday@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have this board which I think is about 2007 vintange. It has a PLX
PCI6140 PCI-PCI bridge, with both a TI TSB43AB22 IEEE1394 FireWire
controller and an NXP SAA7131E on the far side.

The tuner is a TDA8275A and the DVB-T decoder is the TDA10046A. It
reports a subsystem ID of 17de:7256.

The card has inputs for DVB-T/ATV, FM, S-Video, composite, stereo
audio and IR remote in addition to two Firewire ports.

In saa7134-cards.c I added an entry to the saa7134_pci_tbl so that it
is recognised. I also created a new entry in saa7134_boards, so that I
can experiment with the settings for this card, as I don't know that
it is going to be exactly the same as anything else:

[SAA7134_BOARD_KWORLD_PI610] = {
    .name          = "Kworld PlusTV All in One (PI610)",
    .tuner_type    = TUNER_PHILIPS_TDA8290,
    .radio_type    = UNSET,
    .tuner_addr    = ADDR_UNSET,
    .radio_addr    = ADDR_UNSET,
    .mpeg          = SAA7134_MPEG_DVB,
    .inputs = {{
        .name = name_tv,
        .vmux = 1,
        .amux = TV,
        .tv   = 1,
    }},
    .radio = {
        .name = name_radio,
        .amux = TV,
    }

I know I could probably add more inputs for the Composite/S-Video
inputs, but I don't know which mux settings they would be on yet, I
suspect that is trial and error. Also probably a bit more is needed to
get the IR remote working. Is there any wisdom for determining GPIO
settings?

So, next in saa7134-dvb.c, I think I need a tda1004x_config for this
board, so that I can use that in dvb_init(), which is where I'm really
stuck. I've no idea where to get the parameters for this struct.
I presume that agc_config will be TDA_10046_AGC_TDA827x and
.request_firmware will need to be set to
philips_tda1004x_request_firmware.

It seems that existing implementations are either 4MHz or 16MHz
xtal_freq. On this board there is what I take to be a 20.000 MHz
oscillator, (It's just marked 20.000) right next to the TDA10046A, no
sign of either a 4MHz or 16MHz source. How does this relate to
xtal_freq and if_freq? Looking at the dvb frontend for tda1004x.c, it
seems like a PLL is used to generate either a 48MHz or 53MHz clock
from this xtal. I would suppose that 48MHz is correct, in that it
should be like the 16MHz source, but with an N of 4 instead of 3,
which I think would imply that if_freq would be 045.

I guess demod_address is likely to be 0x8 and tuner_address is likely
to be 0x61 or 0x60. I think 0x61 seems more like it. What else needs
to be set there and is there any guidance on how to probe this type of
info?

With these mods scan shows tuning failed for every channel:
>>> tune to: 474000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_AUTO:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!

and:
julian@pabay:~$ dmesg |grep -i saa
[   19.248098] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   19.248462] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16,
latency: 64, mmio: 0xfe6fb000
[   19.248467] saa7133[0]: subsystem: 17de:7256, board: Kworld PlusTV
All in One (PI610) [card=193,autodetected]
[   19.248482] saa7133[0]: board init: gpio is 100
[   19.400046] saa7133[0]: i2c eeprom 00: de 17 56 72 54 20 1c 00 43
43 a9 1c 55 d2 b2 92
[   19.400058] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff
ff ff ff ff ff ff 01
[   19.400068] saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08
ff 00 fe ff ff ff ff
[   19.400077] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400087] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15
56 ff ff ff ff ff ff
[   19.400096] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400106] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400115] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400124] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400134] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400143] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400153] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400162] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400171] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400181] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   19.400190] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   24.053223] saa7133[0]: dsp access wait timeout [bit=WRR]
[   24.053764] saa7133[0]: dsp access wait timeout [bit=WRR]
[   24.116116] saa7133[0]: registered device video0 [v4l2]
[   24.116202] saa7133[0]: registered device vbi0
[   24.116260] saa7133[0]: registered device radio0
[   24.174563] saa7134 ALSA driver for DMA sound loaded
[   24.174590] saa7133[0]/alsa: saa7133[0] at 0xfe6fb000 irq 16
registered as card -2
[   24.179995] saa7133[0]: dsp access wait timeout [bit=WRR]
[   24.180539] saa7133[0]: dsp access wait timeout [bit=WRR]
[   24.185216] saa7133[0]: dsp access wait timeout [bit=WRR]
[   24.185756] saa7133[0]: dsp access wait timeout [bit=WRR]
[   24.640035] DVB: registering new adapter (saa7133[0])
[   24.640043] saa7134 0000:04:08.0: DVB: registering adapter 0
frontend 0 (Philips TDA10046H DVB-T)...
[   25.632561] saa7133[0]: dsp access wait timeout [bit=WRR]

That timeout messages keeps repeating


Thanks,

Julian
