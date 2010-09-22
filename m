Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44180 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab0IVLVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Sep 2010 07:21:10 -0400
Received: by gxk9 with SMTP id 9so102034gxk.19
        for <linux-media@vger.kernel.org>; Wed, 22 Sep 2010 04:21:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285110780.5561.18.camel@pc07.localdom.local>
References: <AANLkTikf0hp8nXzovvdn0j_80Dcirr1a-EMH9sDDGEoX@mail.gmail.com> <1285110780.5561.18.camel@pc07.localdom.local>
From: Dejan Rodiger <dejan.rodiger@gmail.com>
Date: Wed, 22 Sep 2010 13:20:48 +0200
Message-ID: <AANLkTinm=P-VoSLgMEKTh6QNMPBKhKM1AibM-eBerkrW@mail.gmail.com>
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Herman,

here is dmesg output without forcing card=78.
As I see it uses card=112, autodetected

[   16.043345] IR RC6 protocol handler initialized
[   16.173473] IR JVC protocol handler initialized
[   16.236641] IR Sony protocol handler initialized
[   16.433187] lirc_dev: IR Remote Control driver registered, major 250
[   16.572705] IR LIRC bridge handler initialized
[   16.894983] Linux video capture interface: v2.00
[   16.957585] saa7130/34: v4l2 driver version 0.2.16 loaded
[   16.958300] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   16.958306]   alloc irq_desc for 18 on node 0
[   16.958309]   alloc kstat_irqs on node 0
[   16.958320] saa7134 0000:01:06.0: PCI INT A -> Link[APC3] -> GSI 18
(level, low) -> IRQ 18
[   16.958327] saa7133[0]: found at 0000:01:06.0, rev: 209, irq: 18,
latency: 32, mmio: 0xfdeff000
[   16.958334] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131
Hybrid [card=112,autodetected]
[   16.958378] saa7133[0]: board init: gpio is 0
[   17.010075] Registered IR keymap rc-asus-pc39
[   17.010197] input: saa7134 IR (ASUSTeK P7131 Hybri as
/devices/pci0000:00/0000:00:09.0/0000:01:06.0/rc/rc0/input4
[   17.010268] rc0: saa7134 IR (ASUSTeK P7131 Hybri as
/devices/pci0000:00/0000:00:09.0/0000:01:06.0/rc/rc0
[   17.190477] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43
43 a9 1c 55 d2 b2 92
[   17.190490] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff
ff ff ff ff ff ff ff
[   17.190502] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08
ff 00 d5 ff ff ff ff
[   17.190513] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190524] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55
50 ff ff ff ff ff ff
[   17.190534] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190545] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190556] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190566] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190577] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190587] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190598] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190609] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190620] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190630] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[   17.190641] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff

[   17.610120] tuner 2-004b: chip found @ 0x96 (saa7133[0])

[   17.780037] tda829x 2-004b: setting tuner address to 61
[   17.940020] tda829x 2-004b: type set to tda8290+75a

[   24.000114] saa7133[0]: registered device video0 [v4l2]
[   24.000150] saa7133[0]: registered device vbi0
[   24.000182] saa7133[0]: registered device radio0
[   24.027730] saa7134 ALSA driver for DMA sound loaded
[   24.027770] saa7133[0]/alsa: saa7133[0] at 0xfdeff000 irq 18
registered as card -2

[   25.900159] DVB: registering new adapter (saa7133[0])
[   25.900165] DVB: registering adapter 0 frontend 0 (Philips
TDA10046H DVB-T)...

[   26.710050] tda1004x: setting up plls for 48MHz sampling clock
[   27.710043] tda1004x: found firmware revision 29 -- ok


--
Dejan Rodiger
M: +385917829076
S: callto://drodiger



On Wed, Sep 22, 2010 at 01:13, hermann pitton <hermann-pitton@arcor.de> wrote:
> Hi Dejan,
>
> Am Dienstag, den 21.09.2010, 10:07 +0200 schrieb Dejan Rodiger:
>> Hi,
>>
>> I am using Ubuntu linux 10.10 with the latest kernel 2.6.35-22-generic
>> on x86_64. I have installed nonfree firmware which should support this
>> card, but to be sure, can somebody confirm that my TV card is
>> supported in Analog or DVB mode?
>>
>> sudo lspci -vnn
>> 01:06.0 Multimedia controller [0480]: Philips Semiconductors
>> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>>         Subsystem: ASUSTeK Computer Inc. My Cinema-P7131 Hybrid
>> [1043:4876]
>>         Flags: bus master, medium devsel, latency 32, IRQ 18
>>         Memory at fdeff000 (32-bit, non-prefetchable) [size=2K]
>>         Capabilities: [40] Power Management version 2
>>         Kernel driver in use: saa7134
>>         Kernel modules: saa7134
>>
>> It says Hybrid, but I put the following in
>> the /etc/modprobe.d/saa7134.conf
>> options saa7134 card=78 tuner=54
>>
>>
>> Thanks
>> --
>> Dejan Rodiger
>> S: callto://drodiger
>
> don't have time to follow this closely anymore.
>
> But forcing it to card=78 is plain wrong. It has an early additional LNA
> in confirmed config = 2 status.
>
> Your card should be auto detected and previously always was, based on
> what we have in saa7134-cards.c and further for it. (saa7134-dvb and
> related tuner/demod stuff)
>
>        }, {
>                .vendor       = PCI_VENDOR_ID_PHILIPS,
>                .device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
>                .subvendor    = 0x1043,
>                .subdevice    = 0x4876,
>                .driver_data  = SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA,
>        },{
>
> I remember for sure, that this card was fully functional for all use
> cases and it was not easy to get it there. I don't have it.
>
> Please provide the "dmesg" for failing auto detection without forcing
> some card = number as a starting point.
>
> I for sure want to see this board fully functional again.
>
> Cheers,
> Hermann
>
