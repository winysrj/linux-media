Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0R80j7K031129
	for <video4linux-list@redhat.com>; Tue, 27 Jan 2009 03:00:45 -0500
Received: from aneto.bordeaux.inserm.fr (aneto.bordeaux.inserm.fr
	[195.221.150.9])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0R80RFK013545
	for <video4linux-list@redhat.com>; Tue, 27 Jan 2009 03:00:28 -0500
Received: from aneto.bordeaux.inserm.fr (localhost.localdomain [127.0.0.1])
	by localhost.bordeaux.inserm.fr (SrvInserm) with SMTP id 830CC5F8EB
	for <video4linux-list@redhat.com>; Tue, 27 Jan 2009 09:00:26 +0100 (CET)
Received: from localhost.localdomain (unknown [195.221.147.159])
	by aneto.bordeaux.inserm.fr (SrvInserm) with ESMTP id 70CF35F8E8
	for <video4linux-list@redhat.com>; Tue, 27 Jan 2009 09:00:26 +0100 (CET)
Message-ID: <497EBE82.9050502@inserm.fr>
Date: Tue, 27 Jan 2009 08:57:54 +0100
From: Yves Le Feuvre <yves.lefeuvre@inserm.fr>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <497979FF.5090600@inserm.fr> <49797D63.1090501@inserm.fr>
In-Reply-To: <49797D63.1090501@inserm.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
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

with same kernel configuration, and gcc4.3.2, Asus Europa2 OEM works
perfectly on kernel 2.6.25.19 and doesn't work on kernel 2.6.26 (forgot 
to test 2.6.25.20)

Any suggestions how to solve the problem?

yves


Yves Le Feuvre a écrit :
> Hi again,
>
> I have to mention that composite input is working on fedora 10 as well 
> as fedora 7 for Asus Europa2 OEM.
> The same firmwares are present in /lib/firmware for fedora 7 and 
> fedora 10
>
>
>
> Yves Le Feuvre a écrit :
>> Hi,
>>
>> I have two DVB cards, an Hauppauge Nova-T DVB-T 
>> [card=18,autodetected], and a Asus Europa2 OEM [card=100,autodetected].
>> Both cards are working fine on fedora 7 (kernel 2.6.22.9), but the 
>> Asus Europa doesn't work anymore on latest fedora 10 or ubuntu 8.10. 
>> I have to say that I have tested only the DVB-T part, as I don't use 
>> the cards for analog TV or radio.
>> If there is any way i can help to solve the problem ?
>>
>> regards
>>
>> Yves
>>
>>
>> Here is what dmesg is saying for both
>>
>>
>> fedora 7
>> [...]
>> Linux video capture interface: v2.00
>> usb 5-2: reset high speed USB device using ehci_hcd and address 2
>> cx2388x cx88-mpeg Driver Manager version 0.0.6 loaded
>> CORE cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T 
>> [card=18,autodetected]
>> TV tuner 4 at 0x1fe, Radio tuner -1 at 0x1fe
>> cx2388x v4l2 driver version 0.0.6 loaded
>> phy0: Selected rate control algorithm 'simple'
>> tveeprom 1-0050: Hauppauge model 90002, rev C176, serial# 238840
>> tveeprom 1-0050: MAC address is 00-0D-FE-03-A4-F8
>> tveeprom 1-0050: tuner model is Thompson DTT7592 (idx 76, type 4)
>> tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
>> tveeprom 1-0050: audio processor is None (idx 0)
>> tveeprom 1-0050: decoder processor is CX882 (idx 25)
>> tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
>> cx88[0]: hauppauge eeprom: model=90002
>> input: cx88 IR (Hauppauge Nova-T DVB-T as /class/input/input3
>> cx88[0]/2: cx2388x 8802 Driver Manager
>> ACPI: PCI Interrupt 0000:02:05.2[A] -> GSI 17 (level, low) -> IRQ 21
>> cx88[0]/2: found at 0000:02:05.2, rev: 5, irq: 21, latency: 32, mmio: 
>> 0xf8000000
>> ACPI: PCI Interrupt 0000:02:05.0[A] -> GSI 17 (level, low) -> IRQ 21
>> cx88[0]/0: found at 0000:02:05.0, rev: 5, irq: 21, latency: 32, mmio: 
>> 0xf6000000
>> cx88[0]/0: registered device video0 [v4l2]
>> cx88[0]/0: registered device vbi0
>> ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
>> PCI: Setting latency timer of device 0000:00:1b.0 to 64
>> zd1211rw_mac80211 5-2:1.0: phy0
>> usbcore: registered new interface driver zd1211rw_mac80211
>> hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
>> cx2388x dvb driver version 0.0.6 loaded
>> cx8802_register_driver() ->registering driver type=dvb access=shared
>> CORE cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T 
>> [card=18]
>> cx88[0]/2: cx2388x based dvb card
>> DVB: registering new adapter (cx88[0]).
>> DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
>> [...]
>> saa7134[0]: subsystem: 1043:4860, board: Asus Europa2 OEM 
>> [card=100,autodetected]
>> saa7134[0]: board init: gpio is 0
>> saa7134[0]: i2c eeprom 00: 43 10 60 48 54 20 1c 00 43 43 a9 1c 55 d2 
>> b2 92
>> saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 20: 01 40 01 03 03 02 03 04 08 ff 00 4c ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 0d 01 ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> tuner 5-0043: chip found @ 0x86 (saa7134[0])
>> tda9887 5-0043: tda988[5/6/7] found @ 0x43 (tuner)
>> tuner 5-0061: chip found @ 0xc2 (saa7134[0])
>> tuner 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
>> tuner 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
>> saa7134[0]: registered device video1 [v4l2]
>> saa7134[0]: registered device vbi1
>> saa7134[0]: registered device radio0
>> DVB: registering new adapter (saa7134[0]).
>> DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
>> tda1004x: setting up plls for 53MHz sampling clock
>> tda1004x: found firmware revision 29 -- ok
>> [...]
>>
>>
>>
>>
>> fedora 10
>> [...]
>>
>> saa7130/34: v4l2 driver version 0.2.14 loaded
>> saa7134 0000:02:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> saa7134[0]: found at 0000:02:04.0, rev: 1, irq: 16, latency: 32, 
>> mmio: 0xf9ffe000
>> saa7134[0]: subsystem: 1043:4860, board: Asus Europa2 OEM 
>> [card=100,autodetected]
>> saa7134[0]: board init: gpio is 0
>> saa7134[0]: i2c eeprom 00: 43 10 60 48 54 20 1c 00 43 43 a9 1c 55 d2 
>> b2 92
>> saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 20: 01 40 01 03 03 02 03 04 08 ff 00 4c ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 40: ff 1d 00 c2 86 10 01 01 0d 01 ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
>> ff ff
>> parport_pc 00:06: reported by Plug and Play ACPI
>> parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
>> Initializing USB Mass Storage driver...
>> scsi4 : SCSI emulation for USB Mass Storage devices
>> usbcore: registered new interface driver usb-storage
>> USB Mass Storage support registered.
>> usb-storage: device found at 2
>> usb-storage: waiting for device to settle before scanning
>> iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
>> iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
>> iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
>> ppdev: user-space parallel port driver
>> usb 1-2: reset high speed USB device using ehci_hcd and address 2
>> nvidia: module license 'NVIDIA' taints kernel.
>> phy0: Selected rate control algorithm 'pid'
>> saa7134[0]: registered device video0 [v4l2]
>> saa7134[0]: registered device vbi0
>> saa7134[0]: registered device radio0
>> firewire_ohci 0000:02:01.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
>> nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> nvidia 0000:01:00.0: setting latency timer to 64
>> firewire_ohci: Added fw-ohci device 0000:02:01.0, OHCI version 1.0
>> NVRM: loading NVIDIA UNIX x86 Kernel Module  180.22  Tue Jan  6 
>> 09:29:08 PST 2009
>> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
>> cx8800 0000:02:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>> cx88[0]: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T 
>> [card=18,autodetected]
>> cx88[0]: TV tuner type 4, Radio tuner type -1
>> cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
>> tveeprom 2-0050: Hauppauge model 90002, rev C176, serial# 238840
>> tveeprom 2-0050: MAC address is 00-0D-FE-03-A4-F8
>> tveeprom 2-0050: tuner model is Thompson DTT7592 (idx 76, type 4)
>> tveeprom 2-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
>> tveeprom 2-0050: audio processor is None (idx 0)
>> tveeprom 2-0050: decoder processor is CX882 (idx 25)
>> tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter
>> cx88[0]: hauppauge eeprom: model=90002
>> input: cx88 IR (Hauppauge Nova-T DVB-T as 
>> /devices/pci0000:00/0000:00:1e.0/0000:02:05.0/input/input6
>> cx88[0]/0: found at 0000:02:05.0, rev: 5, irq: 17, latency: 32, mmio: 
>> 0xf6000000
>> cx88[0]/0: registered device video1 [v4l2]
>> cx88[0]/0: registered device vbi1
>> cx88[0]/2: cx2388x 8802 Driver Manager
>> cx88-mpeg driver manager 0000:02:05.2: PCI INT A -> GSI 17 (level, 
>> low) -> IRQ 17
>> cx88[0]/2: found at 0000:02:05.2, rev: 5, irq: 17, latency: 32, mmio: 
>> 0xf8000000
>> zd1211rw 1-2:1.0: phy0
>> usbcore: registered new interface driver zd1211rw
>> tuner-simple 1-0061: creating new instance
>> tuner-simple 1-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
>> DVB: registering new adapter (saa7134[0])
>> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
>> tda1004x: setting up plls for 53MHz sampling clock
>> HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>> HDA Intel 0000:00:1b.0: setting latency timer to 64
>> hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
>> ALSA sound/pci/hda/hda_codec.c:3021: autoconfig: line_outs=4 
>> (0x14/0x15/0x16/0x17/0x0)
>> ALSA sound/pci/hda/hda_codec.c:3025:    speaker_outs=0 
>> (0x0/0x0/0x0/0x0/0x0)
>> ALSA sound/pci/hda/hda_codec.c:3029:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
>> ALSA sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
>> ALSA sound/pci/hda/hda_codec.c:3038:    inputs: mic=0x18, fmic=0x19, 
>> line=0x1a, fline=0x0, cd=0x1c, aux=0x0
>> tda1004x: found firmware revision 29 -- ok
>> cx88/2: cx2388x dvb driver version 0.0.6 loaded
>> cx88/2: registering cx8802 driver, type: dvb access: shared
>> cx88[0]/2: subsystem: 0070:9002, board: Hauppauge Nova-T DVB-T [card=18]
>> cx88[0]/2: cx2388x based DVB/ATSC card
>> DVB: registering new adapter (cx88[0])
>> DVB: registering frontend 1 (Conexant CX22702 DVB-T)...
>> firewire_core: created device fw0: GUID 0011d800006cad14, S400
>> device-mapper: multipath: version 1.0.5 loaded
>> [...]
>> tda1004x: setting up plls for 53MHz sampling clock
>> tda1004x: found firmware revision 29 -- ok
>> saa7134[0]/irq[10,-151591]: r=0x20 s=0x00 PE
>> saa7134[0]/irq: looping -- clearing PE (parity error!) enable bit
>> tda1004x: setting up plls for 53MHz sampling clock
>> tda1004x: found firmware revision 29 -- ok
>> tda1004x: setting up plls for 53MHz sampling clock
>> tda1004x: found firmware revision 29 -- ok
>> tda1004x: setting up plls for 53MHz sampling clock
>> tda1004x: found firmware revision 29 -- ok
>> tda1004x: setting up plls for 53MHz sampling clock
>> tda1004x: found firmware revision 29 -- ok
>>
>> -- 
>> video4linux-list mailing list
>> Unsubscribe 
>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>
>
> -- 
> video4linux-list mailing list
> Unsubscribe 
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
