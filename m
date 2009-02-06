Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n161sRlU017936
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 20:54:27 -0500
Received: from mail-in-10.arcor-online.net (mail-in-10.arcor-online.net
	[151.189.21.50])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n161s69f015148
	for <video4linux-list@redhat.com>; Thu, 5 Feb 2009 20:54:06 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Yves Le Feuvre <yves.lefeuvre@inserm.fr>
In-Reply-To: <4989A883.8050305@inserm.fr>
References: <497979FF.5090600@inserm.fr>
	<1232755686.5451.7.camel@pc10.localdom.local>	<497D71BB.4050306@inserm.fr>
	<1233179327.4396.42.camel@pc10.localdom.local>
	<4982B64C.3010608@inserm.fr> <4989A883.8050305@inserm.fr>
Content-Type: text/plain; charset=utf-8
Date: Fri, 06 Feb 2009 02:54:51 +0100
Message-Id: <1233885291.2689.22.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: asus Europa2 OEM regression ?
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

Am Mittwoch, den 04.02.2009, 15:38 +0100 schrieb Yves Le Feuvre:
> Hi,
> 
> What should I try next ? I'll try to hack the driver source code, but my 
> knowledge in linux drivers and v4l is very limited...
> If you have some ideas where to start, they will be welcome.
> 
> yves

I don't understand it at this point for now.

The tuner in digital mode takes the instructions.

There is another clash between digital and analog again.

Hermann

> 
> Yves Le Feuvre a écrit :
> > Hello again,
> >
> > First, thanks for your help. I wonder if anybody else using that card 
> > has experienced similar regression.
> > here is the output of a few commands, each time after cold boot 
> > (unplugged power supply...). I am sorry the mesg is quite long
> > <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
> > << REAL COLD BOOT 2.6.25.19 ! >>
> > >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
> >
> > [root@computer]# uname -sr
> > Linux 2.6.25.19
> > [root@computer]# dmesg -c 2>&1>/dev/null
> > [root@computer]# /sbin/rmmod tuner
> > [root@computer]# /sbin/rmmod tda9887
> > [root@computer]# /sbin/modprobe tda9887 debug=2
> > [root@computer]# /sbin/modprobe tuner debug=2
> > [root@computer]# dmesg
> > tuner' 2-0043: chip found @ 0x86 (saa7134[0])
> > tda9887 2-0043: tda988[5/6/7] found
> > tuner' 2-0043: type set to tda9887
> > tuner' 2-0043: tv freq set to 0.00
> > tuner' 2-0043: TV freq (0.00) out of range (44-958)
> > tda9887 2-0043: Unsupported tvnorm entry - audio muted
> > tda9887 2-0043: writing: b=0xc0 c=0x00 e=0x00
> > tda9887 2-0043: write: byte B 0xc0
> > tda9887 2-0043:   B0   video mode      : sound trap
> > tda9887 2-0043:   B1   auto mute fm    : no
> > tda9887 2-0043:   B2   carrier mode    : Intercarrier
> > tda9887 2-0043:   B3-4 tv sound/radio  : AM/TV
> > tda9887 2-0043:   B5   force mute audio: no
> > tda9887 2-0043:   B6   output port 1   : high (inactive)
> > tda9887 2-0043:   B7   output port 2   : high (inactive)
> > tda9887 2-0043: write: byte C 0x00
> > tda9887 2-0043:   C0-4 top adjustment  : -16 dB
> > tda9887 2-0043:   C5-6 de-emphasis     : no
> > tda9887 2-0043:   C7   audio gain      : 0
> > tda9887 2-0043: write: byte E 0x00
> > tda9887 2-0043:   E0-1 sound carrier   : 4.5 MHz
> > tda9887 2-0043:   E6   l pll gating   : 13
> > tda9887 2-0043:   E2-4 video if        : 58.75 MHz
> > tda9887 2-0043:   E5   tuner gain      : normal
> > tda9887 2-0043:   E7   vif agc output  : pin3+pin22 port
> > tda9887 2-0043: --
> > tuner' 2-0043: saa7134[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
> > tuner' 2-0043: v4l2_int ioctl TUNER_SET_TYPE_ADDR, dir=-w (0x4004645a)
> > tuner' 2-0043: Calling set_type_addr for type=63, addr=0xff, 
> > mode=0x04, config=0x00
> > tuner' 2-0043: set addr for type 74
> > tuner' 2-0061: Setting mode_mask to 0x0e
> > tuner' 2-0061: chip found @ 0xc2 (saa7134[0])
> > tuner' 2-0061: tuner 0x61: Tuner type absent
> > tuner' 2-0061: v4l2_int ioctl TUNER_SET_TYPE_ADDR, dir=-w (0x4004645a)
> > tuner' 2-0061: Calling set_type_addr for type=63, addr=0xff, 
> > mode=0x04, config=0x00
> > tuner' 2-0061: set addr for type -1
> > tuner' 2-0061: defining GPIO callback
> > tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> > tuner' 2-0061: type set to Philips FMD1216ME M
> > tuner' 2-0061: tv freq set to 400.00
> > tuner-simple 2-0061: tv: param 0, range 1
> > tuner-simple 2-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 
> > MHz, div=7023
> > tuner' 2-0043: v4l2_int ioctl TUNER_SET_CONFIG, dir=-w (0x4008645c)
> > tda9887 2-0043: Unsupported tvnorm entry - audio muted
> > tda9887 2-0043: writing: b=0x00 c=0x00 e=0x00
> > tda9887 2-0043: write: byte B 0x00
> > tda9887 2-0043:   B0   video mode      : sound trap
> > tda9887 2-0043:   B1   auto mute fm    : no
> > tda9887 2-0043:   B2   carrier mode    : Intercarrier
> > tda9887 2-0043:   B3-4 tv sound/radio  : AM/TV
> > tda9887 2-0043:   B5   force mute audio: no
> > tda9887 2-0043:   B6   output port 1   : low (active)
> > tda9887 2-0043:   B7   output port 2   : low (active)
> > tda9887 2-0043: write: byte C 0x00
> > tda9887 2-0043:   C0-4 top adjustment  : -16 dB
> > tda9887 2-0043:   C5-6 de-emphasis     : no
> > tda9887 2-0043:   C7   audio gain      : 0
> > tda9887 2-0043: write: byte E 0x00
> > tda9887 2-0043:   E0-1 sound carrier   : 4.5 MHz
> > tda9887 2-0043:   E6   l pll gating   : 13
> > tda9887 2-0043:   E2-4 video if        : 58.75 MHz
> > tda9887 2-0043:   E5   tuner gain      : normal
> > tda9887 2-0043:   E7   vif agc output  : pin3+pin22 port
> > tda9887 2-0043: --
> > tuner' 2-0061: v4l2_int ioctl TUNER_SET_CONFIG, dir=-w (0x4008645c)
> > tuner-simple 2-0061: tv 0x1b 0x6f 0x86 0x52
> > tuner' 2-0061: saa7134[0] tuner' I2C addr 0xc2 with type 63 used for 0x0e
> > [root@computer]# tzap -a 1 ARTE
> > using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'
> > tuning to 490167000 Hz
> > video pid 0x0208, audio pid 0x0212
> > status 00 | signal a7a7 | snr c3c3 | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr 3030 | ber 0001fffe | unc 00000000 |
> > status 00 | signal a9a9 | snr 4c4c | ber 0001fffe | unc 00000000 |
> > status 05 | signal a8a8 | snr f8f8 | ber 000081d2 | unc ffffffff |
> > status 1f | signal a9a9 | snr fefe | ber 00008204 | unc 00000000 | 
> > FE_HAS_LOCK
> > status 1f | signal a8a8 | snr fdfd | ber 00007a7e | unc 00000000 | 
> > FE_HAS_LOCK
> > ^C
> > [root@hppavillon yves]# dmesg
> > tuner' 2-0043: chip found @ 0x86 (saa7134[0])
> > tda9887 2-0043: tda988[5/6/7] found
> > tuner' 2-0043: type set to tda9887
> > tuner' 2-0043: tv freq set to 0.00
> > tuner' 2-0043: TV freq (0.00) out of range (44-958)
> > tda9887 2-0043: Unsupported tvnorm entry - audio muted
> > tda9887 2-0043: writing: b=0xc0 c=0x00 e=0x00
> > tda9887 2-0043: write: byte B 0xc0
> > tda9887 2-0043:   B0   video mode      : sound trap
> > tda9887 2-0043:   B1   auto mute fm    : no
> > tda9887 2-0043:   B2   carrier mode    : Intercarrier
> > tda9887 2-0043:   B3-4 tv sound/radio  : AM/TV
> > tda9887 2-0043:   B5   force mute audio: no
> > tda9887 2-0043:   B6   output port 1   : high (inactive)
> > tda9887 2-0043:   B7   output port 2   : high (inactive)
> > tda9887 2-0043: write: byte C 0x00
> > tda9887 2-0043:   C0-4 top adjustment  : -16 dB
> > tda9887 2-0043:   C5-6 de-emphasis     : no
> > tda9887 2-0043:   C7   audio gain      : 0
> > tda9887 2-0043: write: byte E 0x00
> > tda9887 2-0043:   E0-1 sound carrier   : 4.5 MHz
> > tda9887 2-0043:   E6   l pll gating   : 13
> > tda9887 2-0043:   E2-4 video if        : 58.75 MHz
> > tda9887 2-0043:   E5   tuner gain      : normal
> > tda9887 2-0043:   E7   vif agc output  : pin3+pin22 port
> > tda9887 2-0043: --
> > tuner' 2-0043: saa7134[0] tuner' I2C addr 0x86 with type 74 used for 0x0e
> > tuner' 2-0043: v4l2_int ioctl TUNER_SET_TYPE_ADDR, dir=-w (0x4004645a)
> > tuner' 2-0043: Calling set_type_addr for type=63, addr=0xff, 
> > mode=0x04, config=0x00
> > tuner' 2-0043: set addr for type 74
> > tuner' 2-0061: Setting mode_mask to 0x0e
> > tuner' 2-0061: chip found @ 0xc2 (saa7134[0])
> > tuner' 2-0061: tuner 0x61: Tuner type absent
> > tuner' 2-0061: v4l2_int ioctl TUNER_SET_TYPE_ADDR, dir=-w (0x4004645a)
> > tuner' 2-0061: Calling set_type_addr for type=63, addr=0xff, 
> > mode=0x04, config=0x00
> > tuner' 2-0061: set addr for type -1
> > tuner' 2-0061: defining GPIO callback
> > tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> > tuner' 2-0061: type set to Philips FMD1216ME M
> > tuner' 2-0061: tv freq set to 400.00
> > tuner-simple 2-0061: tv: param 0, range 1
> > tuner-simple 2-0061: Freq= 400.00 MHz, V_IF=38.93 MHz, Offset=0.00 
> > MHz, div=7023
> > tuner' 2-0043: v4l2_int ioctl TUNER_SET_CONFIG, dir=-w (0x4008645c)
> > tda9887 2-0043: Unsupported tvnorm entry - audio muted
> > tda9887 2-0043: writing: b=0x00 c=0x00 e=0x00
> > tda9887 2-0043: write: byte B 0x00
> > tda9887 2-0043:   B0   video mode      : sound trap
> > tda9887 2-0043:   B1   auto mute fm    : no
> > tda9887 2-0043:   B2   carrier mode    : Intercarrier
> > tda9887 2-0043:   B3-4 tv sound/radio  : AM/TV
> > tda9887 2-0043:   B5   force mute audio: no
> > tda9887 2-0043:   B6   output port 1   : low (active)
> > tda9887 2-0043:   B7   output port 2   : low (active)
> > tda9887 2-0043: write: byte C 0x00
> > tda9887 2-0043:   C0-4 top adjustment  : -16 dB
> > tda9887 2-0043:   C5-6 de-emphasis     : no
> > tda9887 2-0043:   C7   audio gain      : 0
> > tda9887 2-0043: write: byte E 0x00
> > tda9887 2-0043:   E0-1 sound carrier   : 4.5 MHz
> > tda9887 2-0043:   E6   l pll gating   : 13
> > tda9887 2-0043:   E2-4 video if        : 58.75 MHz
> > tda9887 2-0043:   E5   tuner gain      : normal
> > tda9887 2-0043:   E7   vif agc output  : pin3+pin22 port
> > tda9887 2-0043: --
> > tuner' 2-0061: v4l2_int ioctl TUNER_SET_CONFIG, dir=-w (0x4008645c)
> > tuner-simple 2-0061: tv 0x1b 0x6f 0x86 0x52
> > tuner' 2-0061: saa7134[0] tuner' I2C addr 0xc2 with type 63 used for 0x0e
> > tda1004x: setting up plls for 53MHz sampling clock
> > tda1004x: found firmware revision 20 -- ok
> > [root@computer]# cat /proc/interrupts
> >           CPU0       CPU1       0:        265          0   
> > IO-APIC-edge      timer
> >  1:       2135        378   IO-APIC-edge      i8042
> >  7:          0          0   IO-APIC-edge      parport0
> >  8:          3          0   IO-APIC-edge      rtc
> >  9:          0          0   IO-APIC-fasteoi   acpi
> > 12:      12702          0   IO-APIC-edge      i8042
> > 14:       4826          0   IO-APIC-edge      ata_piix
> > 15:          0          0   IO-APIC-edge      ata_piix
> > 16:      57711        870   IO-APIC-fasteoi   uhci_hcd:usb5, HDA 
> > Intel, saa7134[0], nvidia
> > 17:       1854      69635   IO-APIC-fasteoi   cx88[0], cx88[0]
> > 18:         37          0   IO-APIC-fasteoi   uhci_hcd:usb4
> > 19:      13053          0   IO-APIC-fasteoi   uhci_hcd:usb3, ata_piix
> > 20:        347          0   IO-APIC-fasteoi   ohci1394, eth0
> > 23:        894      24123   IO-APIC-fasteoi   ehci_hcd:usb1, 
> > uhci_hcd:usb2
> > NMI:          0          0   Non-maskable interrupts
> > LOC:      59452      60268   Local timer interrupts
> > RES:       1477       1179   Rescheduling interrupts
> > CAL:        273        399   function call interrupts
> > TLB:        282        608   TLB shootdowns
> > TRM:          0          0   Thermal event interrupts
> > SPU:          0          0   Spurious interrupts
> > ERR:          0
> > MIS:          0
> > [root@computer]#
> >
> >
> >
> >
> >
> > <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
> > << REAL COLD BOOT with 2.6.28.1 vanilla (not v4l-dvb git! >>
> > >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
> >
> >
> > [root@computer]$ dmesg -c 2>&1>/dev/null
> > [root@computer]$ uname -sr
> > Linux 2.6.28.1
> > [root@computer]# lsmod | grep tda
> > tda1004x               17156  1
> > i2c_core               21908  14 
> > dvb_pll,cx22702,tuner_simple,tda1004x,saa7134_dvb,cx88_vp3054_i2c,tuner,saa7134,nvidia,i2c_i801,v4l2_common,cx88xx,i2c_algo_bit,tveeprom 
> >
> > [root@computer]# lsmod | grep tuner
> > tuner_simple           15376  1
> > tuner_types            17792  1 tuner_simple
> > tuner                  25540  0
> > v4l2_common            16896  3 tuner,saa7134,cx8800
> > i2c_core               21908  14 
> > dvb_pll,cx22702,tuner_simple,tda1004x,saa7134_dvb,cx88_vp3054_i2c,tuner,saa7134,nvidia,i2c_i801,v4l2_common,cx88xx,i2c_algo_bit,tveeprom 
> >
> > videodev               37632  5 tuner,saa7134,cx8800,v4l2_common,cx88xx
> > [root@computer]# modprobe -r tda9887
> > [root@computer]# modprobe -r tuner
> > [root@computer]# modprobe -r saa7134_dvb
> > [root@computer]# modprobe -r saa7134
> > [root@computer]# modprobe -r tuner_simple
> > [root@computer]# lsmod | grep tuner
> > [root@computer]# lsmod | grep tda
> > tda1004x               17156  0
> > i2c_core               21908  10 
> > dvb_pll,cx22702,tda1004x,cx88_vp3054_i2c,nvidia,i2c_i801,v4l2_common,cx88xx,i2c_algo_bit,tveeprom 
> >
> > [root@computer]# /sbin/modprobe tda9887 debug=2
> > [root@computer]# /sbin/modprobe tuner_simple debug=2
> > [root@computer]# /sbin/modprobe saa7134
> > [root@computer]# /sbin/modprobe saa7134_dvb
> > [root@computer]# dmesg
> > tuner-simple 2-0061: destroying instance
> > saa7130/34: v4l2 driver version 0.2.14 loaded
> > saa7134[0]: found at 0000:02:04.0, rev: 1, irq: 16, latency: 32, mmio: 
> > 0xf9ffe000
> > saa7134[0]: subsystem: 1043:4860, board: Asus Europa2 OEM 
> > [card=100,autodetected]
> > saa7134[0]: board init: gpio is 0
> > saa7134[0]: i2c eeprom 00: 43 10 60 48 54 20 1c 00 43 43 a9 1c 55 d2 
> > b2 92
> > saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 20: 01 40 01 03 03 02 03 04 08 ff 00 4c ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 0d 01 ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: registered device video1 [v4l2]
> > saa7134[0]: registered device vbi1
> > saa7134[0]: registered device radio0
> > dvb_init() allocating 1 frontend
> > saa7134[0]/irq[10,350637]: r=0x20 s=0x00 PE
> > saa7134[0]/irq: looping -- clearing PE (parity error!) enable bit
> > tuner-simple 2-0061: creating new instance
> > tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> > tuner-simple 2-0061: tuner 0 atv rf input will be autoselected
> > tuner-simple 2-0061: tuner 0 dtv rf input will be autoselected
> > DVB: registering new adapter (saa7134[0])
> > DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> > tda1004x: setting up plls for 53MHz sampling clock
> > tda1004x: found firmware revision 20 -- ok
> > [root@computer]#  tzap -a 0 ARTE
> > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> > tuning to 490167000 Hz
> > video pid 0x0208, audio pid 0x0212
> > status 00 | signal a7a7 | snr 6d6d | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr 3636 | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr 4a4a | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr 6b6b | ber 0001fffe | unc 00000000 |
> > status 00 | signal a9a9 | snr a3a3 | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr ffff | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr 4747 | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr f1f1 | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr 3939 | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr 5454 | ber 0001fffe | unc 00000000 |
> > status 00 | signal a8a8 | snr 8c8c | ber 0001fffe | unc 00000000 |
> > ^C
> > [root@computer]# dmesg
> > tuner-simple 2-0061: destroying instance
> > saa7130/34: v4l2 driver version 0.2.14 loaded
> > saa7134[0]: found at 0000:02:04.0, rev: 1, irq: 16, latency: 32, mmio: 
> > 0xf9ffe000
> > saa7134[0]: subsystem: 1043:4860, board: Asus Europa2 OEM 
> > [card=100,autodetected]
> > saa7134[0]: board init: gpio is 0
> > saa7134[0]: i2c eeprom 00: 43 10 60 48 54 20 1c 00 43 43 a9 1c 55 d2 
> > b2 92
> > saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 20: 01 40 01 03 03 02 03 04 08 ff 00 4c ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 0d 01 ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
> > ff ff
> > saa7134[0]: registered device video1 [v4l2]
> > saa7134[0]: registered device vbi1
> > saa7134[0]: registered device radio0
> > dvb_init() allocating 1 frontend
> > saa7134[0]/irq[10,350637]: r=0x20 s=0x00 PE
> > saa7134[0]/irq: looping -- clearing PE (parity error!) enable bit
> > tuner-simple 2-0061: creating new instance
> > tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
> > tuner-simple 2-0061: tuner 0 atv rf input will be autoselected
> > tuner-simple 2-0061: tuner 0 dtv rf input will be autoselected
> > DVB: registering new adapter (saa7134[0])
> > DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> > tda1004x: setting up plls for 53MHz sampling clock
> > tda1004x: found firmware revision 20 -- ok
> > tda1004x: setting up plls for 53MHz sampling clock
> > tda1004x: found firmware revision 20 -- ok
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > tuner-simple 2-0061: using tuner params #1 (digital)
> > tuner-simple 2-0061: freq = 490.12 (7842), range = 4, config = 0xbc, 
> > cb = 0x44
> > tuner-simple 2-0061: Philips FMD1216ME MK3 Hybrid Tuner: div=3157 | 
> > buf=0x0c,0x55,0xbc,0x4c
> > [root@computer]# cat /proc/interrupts
> >           CPU0       CPU1       0:        136          0   
> > IO-APIC-edge      timer
> >  1:       1031       1246   IO-APIC-edge      i8042
> >  7:          0          0   IO-APIC-edge      parport0
> >  8:         47          0   IO-APIC-edge      rtc0
> >  9:          0          0   IO-APIC-fasteoi   acpi
> > 12:      46389       4068   IO-APIC-edge      i8042
> > 14:       6022          1   IO-APIC-edge      ata_piix
> > 15:          0          0   IO-APIC-edge      ata_piix
> > 16:      69585        830   IO-APIC-fasteoi   uhci_hcd:usb5, HDA 
> > Intel, nvidia, saa7134[0]
> > 17:       1824      85487   IO-APIC-fasteoi   cx88[0], cx88[0]
> > 18:         38          0   IO-APIC-fasteoi   uhci_hcd:usb4
> > 19:      12800          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb3
> > 20:         22        419   IO-APIC-fasteoi   firewire_ohci, eth0
> > 23:       8635      23285   IO-APIC-fasteoi   ehci_hcd:usb1, 
> > uhci_hcd:usb2
> > NMI:          0          0   Non-maskable interrupts
> > LOC:      83434      81129   Local timer interrupts
> > RES:       1222       1489   Rescheduling interrupts
> > CAL:         10        173   Function call interrupts
> > TLB:        363        541   TLB shootdowns
> > TRM:          0          0   Thermal event interrupts
> > SPU:          0          0   Spurious interrupts
> > ERR:          0
> > MIS:          0
> > [root@computer]# tail -3 /etc/modprobe.d/modprobe.conf.dist
> > options tuner_simple debug=2
> > options tda9887 debug=2
> > options tuner debug=2
> >
> >
> >
> > Hope this helps. If you need more debug with saa7134 module, please 
> > tell me (coredebug, video_debug,i2c_debug?)
> >
> >
> > Thanks again for your help
> >
> >
> > hermann pitton a écrit :
> >> Hi,
> >>
> >> Am Montag, den 26.01.2009, 09:18 +0100 schrieb Yves Le Feuvre:
> >>  
> >>> Hello,
> >>>
> >>> [...]
> >>>  > Please try as root "modprobe -vr saa7134-dvb saa7134-alsa"
> >>>  > and "modprobe -v saa7134".
> >>>  >
> >>>  > Is the tda9887 detected now and the card usable again?
> >>>
> >>> This doesn't change anything. I still have the parity error and the 
> >>> card is unsusable.
> >>> If I remember well (I'll check when I'm back home this evening),
> >>> lsmod  reports that tda9887 is loaded, but used by cx88 or cx88_dvb, 
> >>> and not by any of the saa7134 modules.
> >>>     
> >>
> >> it belongs to saa7134[0] and the FMD1216ME MK3 hybrid tuner there.
> >> I don't have your card, but the tda9887 is the analog demodulator and it
> >> has two ports which can be used for switching.
> >>
> >> You need it in any case for analog TV from the tuner.
> >> Try "modinfo tda9887". With tda9887 debug=2 it becomes quite verbose.
> >> It was on the older kernels integrated in the tuner module and becomes
> >> there verbose with tuner debug=2.
> >>
> >> If it is not present in dmesg after a cold boot, prior to 2.6.27
> >> reloading the tuner module does activate it, since then reloading the
> >> saa7134 driver like above should make it visible and functional.
> >>
> >> For your card Hartmut added some special initialization code to make the
> >> tuner visible behind the extra i2c bridge of the tda10046, but it is
> >> detected and only the tda9887 fails for now like on other cards with
> >> that tuner.
> >>  
> >>>  > If your hardware is unchanged compared to Fedora 7 and you have some
> >>>  > time for it, you might try to prove if you get the parity errors 
> >>> also on
> >>>  > a vanilla 2.6.27 with the same kernel config.
> >>>
> >>> on fedora 10, with gcc-4.3.2-7
> >>> with vanilla kernel 2.6.25
> >>> both cards are working: Nova-T DVB-T [card=18], and  Asus Europa2 
> >>> OEM [card=100]
> >>>
> >>> with vanilla kernel 2.6.28.1
> >>> Asus Europa2 OEM does not work anymore (parity error)
> >>>
> >>> (however, there may be some differences in kernel configs, as 
> >>> config-2.6.25 comes from an
> >>> updated fedora 7 kernel config (make oldconfig), and 2.6.28.1 comes 
> >>> rom installed fedora 10 kernel.
> >>>     
> >>
> >> That is why I'm late on it, but I now have a vanilla 2.6.28.2 on Fedora
> >> 10 with the Fedora config of a recent 2.6.27 x86_64.
> >> No issues for me, but I don't have your card.
> >>
> >>  
> >>> I'll try 2.6.26 and 2.6.27 tonight, with same config as 2.6.25, 
> >>> unless you estimate there are better other things to test before
> >>> I also tested v4l-dvb git tree with vanilla-2.6.28.1, but the card 
> >>> doesn't work either.
> >>>
> >>>     
> >>
> >> According to your latest posting only 2.6.25 works for you and 2.6.26,
> >> 2.6.27 and 2.6.28 "fail" including latest git or v4l-dvb from the
> >> mercurial repo at linuxtv.org.
> >>
> >> Hmm, does that mean that in all cases the parity errors are that heavy,
> >> that you can't access the device for any tuning of DVB-T, because you
> >> are flooded by errors or are there also tuning issues?
> >>
> >> Dmesg looked ok for DVB-T tuning including firmware upload.
> >>
> >> Anything changed on "cat /proc/interrupts" ?
> >> Maybe sharing the interrupt with the display driver now?
> >>
> >> I don't know what should be going on.
> >> Please try to activate the tda9887.
> >>
> >> Most strange is that you can use Composite without problems.
> >> Needs to look closer and/or more debug enabled. No clue yet.
> >>
> >> Cheers,
> >> Hermann
> >>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
