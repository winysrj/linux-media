Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6I8qct2014735
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 04:52:38 -0400
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.180])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6I8qSIN000325
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 04:52:28 -0400
Received: by py-out-1112.google.com with SMTP id a29so184586pyi.0
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 01:52:27 -0700 (PDT)
Message-ID: <f56b605d0807180152r7461a03aj25924486ce117068@mail.gmail.com>
Date: Fri, 18 Jul 2008 10:52:27 +0200
From: "Carlos Bessa" <carlos.bessa@gmail.com>
To: "hermann pitton" <hermann-pitton@arcor.de>
In-Reply-To: <1216331689.2659.102.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f56b605d0807170840x3d6a0116hc817caff4760c5ec@mail.gmail.com>
	<1216331689.2659.102.camel@pc10.localdom.local>
Cc: video4linux-list@redhat.com
Subject: Re: TV card Lifeview DVB-T Hybrid (saa7134) not working. Wrong
	tuner.
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,
thanks for the explanation.
Now you have a report :)
That "set the correct tuner in the source code and recompile..." looks
a bit to complicated for my linux skills at the moment, so i may just
have to wait until it gets fixed. But could you anyway can you somehow
point me to were i should start trying? I don't mind learning a bit
more about linux :)
regards,
Carlos

On Thu, Jul 17, 2008 at 11:54 PM, hermann pitton
<hermann-pitton@arcor.de> wrote:
>
> Am Donnerstag, den 17.07.2008, 18:40 +0300 schrieb Carlos Bessa:
>> This was tested on openSuSE 11 (64bit).
>> The card in question is a DVB-T card from Targa, that came with my laptop (also
>> from Targa). It is the same as the LifeView DVB-T Hybrid Cardbus. The problem
>> is that is mis-identifies it self as being a LifeView DVB-T Dual Cardbus so i
>> have to configure it manually.
>>
>> When using openSuSE 10.3 i could do that through cli, by specifing the
>> correct card and tuner:
>> rmmod saa7134_dvb
>> rmmod saa7134
>> modprobe saa7134 card=94 tuner=54
>>
>> Start up kaffeine/dvb-t and it would work perfectly. In openSuSE 11
>> that does not
>> work anymore. The autodetection is still wrong unfortunately:
>>
>> #dmesg
>> pccard: CardBus card inserted into slot 1
>> saa7130/34: v4l2 driver version 0.2.14 loaded
>> PCI: Enabling device 0000:04:00.0 (0000 -> 0002)
>> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 20 (level, low) -> IRQ 20
>> saa7133[0]: found at 0000:04:00.0, rev: 240, irq: 20, latency: 0, mmio:
>> 0x98000000
>> PCI: Setting latency timer of device 0000:04:00.0 to 64
>> saa7133[0]: subsystem: 5168:0502, board: LifeView/Typhoon/Genius FlyDVB-T Duo
>> Cardbus [card=60,autodetected]
>> saa7133[0]: board init: gpio is 210000
>> saa7133[0]: i2c eeprom 00: 68 51 02 05 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>> saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e4 ff ff ff ff
>> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff
>> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> tuner' 1-004b: chip found @ 0x96 (saa7133[0])
>> tda8290 1-004b: setting tuner address to 61
>> tda8290 1-004b: type set to tda8290+75
>> saa7133[0]: registered device video1 [v4l2]
>> saa7133[0]: registered device vbi0
>> saa7133[0]: registered device radio0
>> DVB: registering new adapter (saa7133[0])
>> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
>> tda1004x: setting up plls for 48MHz sampling clock
>> tda1004x: found firmware revision ff -- invalid
>> tda1004x: trying to boot from eeprom
>> tda1004x: found firmware revision ff -- invalid
>> tda1004x: waiting for firmware upload...
>> tda1004x: no firmware upload (timeout or file not found?)
>> tda1004x: firmware upload failed
>> tda827x_probe_version: could not read from tuner at addr: 0xc0
>>
>>
>> But loading the saa7134 module with the correct card and tuner parameters does
>> not work either:
>>
>> #dmesg
>> saa7130/34: v4l2 driver version 0.2.14 loaded
>> saa7133[0]: found at 0000:04:00.0, rev: 240, irq: 20, latency: 64, mmio:
>> 0x98000000
>> saa7133[0]: subsystem: 5168:0502, board: LifeView FlyDVB-T Hybrid Cardbus/MSI
>> TV @nywhere A/D NB [card=94,insmod option]
>> saa7133[0]: board init: gpio is 10000
>> tuner' 1-004b: chip found @ 0x96 (saa7133[0])
>> tda8290 1-004b: setting tuner address to 61
>> tda8290 1-004b: type set to tda8290+75
>> saa7133[0]: i2c eeprom 00: 68 51 02 05 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>> saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e4 ff ff ff ff
>> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 40: ff 24 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff
>> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> saa7133[0]: registered device video1 [v4l2]
>> saa7133[0]: registered device vbi0
>> saa7133[0]: registered device radio0
>> DVB: registering new adapter (saa7133[0])
>> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
>> tda1004x: setting up plls for 48MHz sampling clock
>> tda1004x: found firmware revision ff -- invalid
>> tda1004x: trying to boot from eeprom
>> tda1004x: found firmware revision ff -- invalid
>> tda1004x: waiting for firmware upload...
>> tda1004x: no firmware upload (timeout or file not found?)
>> tda1004x: firmware upload failed
>> tda827x_probe_version: could not read from tuner at addr: 0xc2
>>
>>
>> The problem seems to be that even though i specify the correct tuner parameter
>> (54) another is used (61). The card is correct though (94).
>>
>> I tested this with the 32bit version of openSuSE 11 (kernel 2.6.25)
>> and 32bit version of
>> Kubuntu 8.04 (kernel 2.6.24), using live cds, and it also does not work.
>> Re-tested on openSuSE 10.3 32/64bit (kernel 2.6.22.5) and Kubuntu 7.10
>> (kernel 2.6.22-14), also using live cds, and
>> it works perfectly. So i guess something changed in the saa7134 driver(?) in
>> the newer kernel versions(?) ?
>>
>> Thanks for any help!
>> I'll be happy to provide any other info, or test any solution.
>>
>> regards,
>> Carlos Bessa
>>
>
> Hi Carlos,
>
> thanks for the report.
>
> It is a known issue, since the initial v4l submit for 2.6.26,
> that was for the price of fixing the eeprom detection for some tuners,
> pointed out by me, but users can't set the tuner anymore by will.
>
> Nobody to blame so far, since tuner eeprom detection was already broken
> previously, but for sure this needs to be addressed.
>
> Currently there is no other way for lots of affected devices, I was
> joking on it recently on LKML that we still don't have a single report,
> than to set the correct tuner in the source code and recompile ...
>
> Cheers,
> Hermann
>
>
>
>
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
