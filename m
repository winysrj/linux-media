Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <mcbeagle@gmx.de>) id 1Jp4Eo-0003pt-FV
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 18:23:59 +0200
From: Peter Klar <mcbeagle@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Apr 2008 18:23:23 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804241823.23796.mcbeagle@gmx.de>
Subject: [linux-dvb] af9015 remote control receiver
Reply-To: mcbeagle@gmx.de
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I installed the latest drivers and the video device works fine, only the ir 
receiver seems to be recognized but doesn't work.
The driver creates the corresponding event device node but when using
cat /dev/input/eventX
there's no data received when pressing the rc keys.

As far as I understood the ir receiver events should be mapped to keyboard 
events, means pressing the '1' on the remote should be like pressing 
the '1' on the keyboard. Doesn't work either.

Do I miss something or is the ir receiver currently not supported?
There's also a bttv card installed and the remote works in Windows, btw ...

Thanks & Regards
Peter


Driver: 7402
Firmware: 4.95

$> cat /proc/version
Linux version 2.6.22-14-rt (buildd@terranova) (gcc version 4.1.3 20070929 
(prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1 SMP PREEMPT RT Tue Feb 12 
09:57:10 UTC 2008

$> dmesg
...
Linux video capture interface: v2.00
parport_pc 00:03: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 0 
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 18
bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 18, latency: 32, mmio: 
0xdfdfe000
bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
bttv0: using: Hauppauge (bt878) [card=10,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
af9015_usb_probe: interface:0
af9015_identify_state: reply:02
dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
af9015_eeprom_dump:
tveeprom 1-0050: Hauppauge model 44804, rev C148, serial# 3976927
tveeprom 1-0050: tuner model is LG TP18PSB11D (idx 48, type 29)
tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
tveeprom 1-0050: audio processor is None (idx 0)
tveeprom 1-0050: has no radio
bttv0: Hauppauge eeprom indicates model#44804
bttv0: tuner type=29
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... 00: 2d 57 9f 0b 00 00 00 00 a4 15 
16 90 00 02 01 02
not found
10: 03 80 00 fa fa 10 40 ef 01 30 31 30 31 30 31 31
20: 30 30 37 30 30 30 30 31 ff ff ff ff ff ff ff ff
30: 00 00 3a 01 00 08 02 00 1d 8d c4 04 82 ff ff ff
40: ff ff ff ff ff 08 02 00 1d 8d c4 04 82 ff ff ff
50: ff ff ff ff ff 24 00 00 04 03 09 04 14 03 47 00
60: 65 00 6e 00 69 00 61 00 74 00 65 00 63 00 68 00
70: 10 03 44 00 56 00 42 00 2d 00 54 00 20 00 32 00
80: 20 03 30 00 31 00 30 00 31 00 30 00 31 00 30 00
90: 31 00 30 00 36 00 30 00 30 00 30 00 30 00 31 00
a0: 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner' 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 29 (LG PAL_BG (TPI8PSB11D))
e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .f0: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
af9015_read_config: xtal:2 set adc_clock:28000
.af9015_read_config: IF1:36125
af9015_read_config: MT2060 IF1:1220
af9015_read_config: tuner id1:130
af9015_read_config: spectral inversion:0
ok
ACPI: PCI Interrupt 0000:00:0b.1[A] -> GSI 19 (level, low) -> IRQ 18
af9013: firmware version:4.65.0
DVB: registering frontend 0 (Afatech AF9013 DVB-T)...
af9015_tuner_attach:
af9015_set_gpio: gpio:3 gpioval:03
ACPI: PCI Interrupt 0000:00:0a.0[A] -> GSI 18 (level, low) -> IRQ 19
MT2060: successfully identified (IF1 = 1220)
dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized and 
connected.
af9015_init:
af9015_init_endpoint: USB speed:3
af9015_download_ir_table:
usbcore: registered new interface driver dvb_usb_af9015
...

$> cat /proc/bus/input/devices
...
I: Bus=0003 Vendor=15a4 Product=9016 Version=0101
N: Name="Geniatech DVB-T 2"
P: Phys=usb-0000:00:10.3-4/input1
S: Sysfs=/class/input/input1
U: Uniq=010101010600001
H: Handlers=kbd event1
B: EV=120003
B: KEY=10000 7 ff87207a c14057ff febeffdf ffefffff ffffffff fffffffe
B: LED=7
...

$> ls /dev/input/by-id/
...
usb-Geniatech_DVB-T_2_010101010600001-event-ir -> ../event1
...

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
