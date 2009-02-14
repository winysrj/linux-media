Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35979 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751581AbZBNPDm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 10:03:42 -0500
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="iso-8859-1"
Date: Sat, 14 Feb 2009 16:03:40 +0100
From: "Guenther Sohler" <guenther.sohler@gmx.at>
Message-ID: <20090214150340.123380@gmx.net>
MIME-Version: 1.0
Subject: TwinHan PCI-Sat Card Problem
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hallo,

my configuration is

* Fujitsu Siemens HTPC
* MythDora 5.0(FC 8)
* TwinHan PCI-Sat
* Technisat Multytenne(4 Satelite positions 13.0 19.2,23.5, 28) dual

This mulitytenne is once connected to a technisat receiver and once to
the HTPC. I can watch on the receiver, but I did not success with
my htpc so far.

The card is recognized in mythtv-setup, but it cant determine its parameters,
so I tried to use it manually, first.

I got installed 2 tv cards in my HTPC, I am concentrating on the Twinhan Vision
Plus DVB

In my /etc/modprobe.conf there is not yet anything mentioned about my dvb card

ls /dev/dvb/adapter0/ shows
ca0  demux0  dvr0  frontend0  net0

I successfully generated a channels.conf with valid and real channels.
When I run 

[mythtv@localhost szap]$ ./szap -a 0 -r N24
reading channels from file '/home/mythtv/.szap/channels.conf'
zapping to 17 'N24':
sat 0, frequency = 12640 MHz V, symbolrate 22000000, vpid = 0x03ff, apid = 0x0400
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_SET_VOLTAGE failed: Input/output error
status 1f | signal fffe | snr fffe | ber fffffffe | unc fffffffe | FE_HAS_LOCK
status 1f | signal fffe | snr 22ef | ber fffffffe | unc fffffffe | FE_HAS_LOCK
status 1f | signal 3d00 | snr 22f3 | ber fffffffe | unc fffffffe | FE_HAS_LOCK
...

The error message about FE_SET_VOLTAGE does sometimes appear

if i try then/during

mplayer /dev/dvb/adapter0/dvr0

I get nothing, dvr does not output any byte

Relevant modules loaded are

saa7134_alsa           14689  1 
tda1004x               17477  1 
saa7134_dvb            22221  0 
videobuf_dvb            8517  1 saa7134_dvb
dst_ca                 14913  1 
tuner_simple           15953  2 
tuner_types            17857  1 tuner_simple
tda9887                13509  1 
tda8290                15685  0 
dst                    27593  2 dst_ca
dvb_bt8xx              17605  0 
dvb_core               68673  5 saa7134_dvb,videobuf_dvb,dst_ca,dst,dvb_bt8xx
saa7134               128789  2 saa7134_alsa,saa7134_dvb
bt878                  12793  2 dst,dvb_bt8xx
tuner                  26249  0 
bttv                  152661  2 dvb_bt8xx,bt878
videodev               31425  3 saa7134,tuner,bttv


The important passages of dmesg look like

bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt 0000:01:0b.0[A] -> GSI 16 (level, low) -> IRQ 16
bttv0: Bt878 (rev 17) at 0000:01:0b.0, irq: 16, latency: 32, mmio: 0xfdcff000
bttv0: detected: Twinhan VisionPlus DVB [card=113], PCI subsystem ID is 1822:0001
bttv0: using: Twinhan DST + clones [card=113,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00f5fffd [init]
input: i2c IR (Hauppauge) as /class/input/input8
ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-1/1-001a/ir0 [bt878 #0 [hw]]
bttv0: tuner absent
bttv0: add subdevice "dvb0"
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
ACPI: PCI Interrupt 0000:01:0b.1[A] -> GSI 16 (level, low) -> IRQ 16
bt878_probe: card id=[0x11822],[ Twinhan VisionPlus DVB ] has DVB functions.
bt878(0): Bt878 (rev 17) at 01:0b.1, irq: 16, latency: 32, memory: 0xfdcfe000
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 19 (level, low) -> IRQ 19
saa7134[0]: found at 0000:01:04.0, rev: 1, irq: 19, latency: 32, mmio: 0xfddff000
saa7134[0]: subsystem: 021a:0001, board: Medion 7134 [card=12,insmod option]
saa7134[0]: board init: gpio is 0
DVB: registering new adapter (bttv0)
tuner' 2-0043: chip found @ 0x86 (saa7134[0])
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
tuner' 2-0061: chip found @ 0xc2 (saa7134[0])
saa7134[0]: i2c eeprom 00: a0 12 02 00 54 20 08 00 43 43 28 0c 00 52 20 12
saa7134[0]: i2c eeprom 10: 00 87 82 0f ff 20 2a 00 00 50 12 00 00 18 0a 10
saa7134[0]: i2c eeprom 20: 01 00 00 02 02 03 01 00 06 ad 00 10 02 51 00 08
saa7134[0]: i2c eeprom 30: 01 18 48 07 03 00 00 0c d2 00 00 10 00 00 12 3c
saa7134[0]: i2c eeprom 40: 60 00 00 c0 82 10 00 00 00 00 01 58 40 1b 02 8d
saa7134[0]: i2c eeprom 50: 7d 56 65 3f 00 5b 06 02 00 00 04 00 0c 00 04 00
saa7134[0]: i2c eeprom 60: 2b a6 7d 38 2b d4 d3 5b 3a 51 e5 5e c6 87 f2 ff
saa7134[0]: i2c eeprom 70: ff a6 2a 58 3a 5b 13 86 b2 58 1a d4 d3 58 5a 5d
saa7134[0]: i2c eeprom 80: 02 22 50 1f 21 8f 80 87 bf 5b fb 5b 3f ad 28 50
saa7134[0]: i2c eeprom 90: 16 7d 28 1c 41 18 48 87 f3 00 01 8d f3 00 01 50
saa7134[0]: i2c eeprom a0: 22 58 12 7f 60 00 91 5e 18 ff ff a6 7d da d8 79
saa7134[0]: i2c eeprom b0: 29 52 96 d4 d3 5b 3a ad 2b 41 84 22 a6 58 66 00
saa7134[0]: i2c eeprom c0: 93 26 29 a6 2a 58 3a 5b 13 a6 29 58 1a 61 2b d4
saa7134[0]: i2c eeprom d0: d3 49 82 8f ba 49 82 8f f2 00 01 5d 12 22 7e 1f
saa7134[0]: i2c eeprom e0: 21 8f 80 87 bf 5b fb 5b 3f ad 28 50 16 7d 28 1c
saa7134[0]: i2c eeprom f0: 41 18 48 87 f3 00 01 8d f3 00 01 50 22 60 29 7f
saa7134[0] Cant determine tuner type 1000 from EEPROM
saa7134[0] Tuner type is 63
tuner-simple 2-0061: creating new instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
saa7134[0]: Overlay support disabled.
saa7134[0]: registered device video0 [v4l2]
saa7134[0]: registered device vbi0
saa7134[0]: registered device radio0
dst(0) dst_get_device_id: Recognise [DSTMCI]
dst(0) dst_get_device_id: Unsupported
dst(0) dst_check_mb86a15: Cmd=[0x10], failed
dst(0) dst_get_device_id: Unsupported
DST type flags : 0x1 newtuner 0x1000 VLF 0x10 firmware version = 2
dst(0) dst_get_mac: MAC Address=[00:08:ca:11:e6:00]
dst(0) dst_get_tuner_info: DST TYpe = MULTI FE
dst_ca_attach: registering DST-CA device
DVB: registering frontend 0 (DST DVB-S)...
tuner-simple 2-0061: attaching existing instance
tuner-simple 2-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (saa7134[0])
DVB: registering frontend 1 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 26 -- ok
saa7134 ALSA driver for DMA sound loaded
saa7134[0]/alsa: saa7134[0] at 0xfddff000 irq 19 registered as card -1

...
...
dst_ca_open:  Device opened [f21dfa00] 
dst_ca_ioctl:  Getting Slot capabilities
put_checksum:  Computing string checksum.
put_checksum:   -> string length : 0x07
put_checksum:   -> checksum      : 0xb5
dst_put_ci:  Put Command
i2c IR (Hauppauge): unknown key: key=0x3f raw=0x1fff down=1
dst_ci_command:  8820 not ready
dst_put_ci:  Put Command
dst_ci_command:  8820 not ready
dst_put_ci:  Put Command
dst_ci_command:  Write not successful, trying to recover
dst_put_ci:  Put Command
dst_ci_command:  Write not successful, trying to recover
dst_put_ci:  Put Command
dst_ci_command:  Write not successful, trying to recover
ca_get_slot_caps:  -->dst_put_ci FAILED !
dst_ca_ioctl:  -->CA_GET_CAP Failed !
dst_ca_release:  Device closed.
i2c IR (Hauppauge): unknown key: key=0x3f raw=0x1fff down=0
dst_ca_open:  Device opened [f459ab00] 
dst_ca_ioctl:  Getting Slot capabilities
put_checksum:  Computing string checksum.
put_checksum:   -> string length : 0x07
put_checksum:   -> checksum      : 0xb5
dst_put_ci:  Put Command
i2c IR (Hauppauge): unknown key: key=0x3f raw=0x1fff down=1
dst_ci_command:  Write not successful, trying to recover
dst_put_ci:  Put Command
dst_ci_command:  Write not successful, trying to recover
dst_put_ci:  Put Command
dst_ci_command:  Write not successful, trying to recover
dst_put_ci:  Put Command
dst_ci_command:  Write not successful, trying to recover
dst_put_ci:  Put Command
dst_ci_command:  Write not successful, trying to recover
ca_get_slot_caps:  -->dst_put_ci FAILED !
dst_ca_ioctl:  -->CA_GET_CAP Failed !
dst_ca_release:  Device closed.
[drm] Initialized drm 1.1.0 20060810
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
...
tda1004x: setting up plls for 53MHz sampling clock
tda1004x: found firmware revision 26 -- ok

==================================

Can somebody see the real error/misconfiguration ?

-- 
Jetzt 1 Monat kostenlos! GMX FreeDSL - Telefonanschluss + DSL 
für nur 17,95 Euro/mtl.!* http://dsl.gmx.de/?ac=OM.AD.PD003K11308T4569a

-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört? Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger01
