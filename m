Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61921 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0FIGbX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 02:31:23 -0400
Received: by vws17 with SMTP id 17so2075662vws.19
        for <linux-media@vger.kernel.org>; Tue, 08 Jun 2010 23:31:22 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Jun 2010 16:31:22 +1000
Message-ID: <AANLkTili6s6TSeWCzLOKyg3J2jVZSG8RnTJ05wvPg8pb@mail.gmail.com>
Subject: Leadtek DTV2000DS Support
From: Mark Arnold <marnold7772@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently purchased a Leadtek DTV2000DS PCI tuner to go in my mythtv pc.
This is a AF9015 + AF9013  + NXP TDA18211 based PCI card.

My PC previously had 2 Leadtek DTV1000S tuners and I was hoping to
replace one or possibly both of them with the DTV2000DS which is dual
tuner.

I was just wondering if the DTV2000DS is supported by v4l-dvb and if
there are any known issues?

My PC is running an up to date Fedora13

(uname -a output)
     Linux mediabox 2.6.33.5-112.fc13.x86_64 #1 SMP Thu May 27
02:28:31 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux

I have also installed the current hg v4b-dvb source from here
http://linuxtv.org/hg/v4l-dvb and downloaded the latest firmware for
this card
The problem I am seeing is that I have a lot of messages like this in
/var/log/messages

    af9015: command failed:2
    af9013: I2C read failed reg:d2e6
    af9015: command failed:2
    af9013: I2C read failed reg:d330
    af9015: command failed:2
    af9013: I2C read failed reg:d330
    af9015: command failed:2
    af9013: I2C read failed reg:d330
    af9015: command failed:2
    af9013: I2C read failed reg:9bee

I also couldn't get the card to tune with mythtv, although it did seem
to get a lock and record a picture using scan/tzap.

Below is my the relevant parts of my dmesg output (my PC current has
both a DTV1000S and the DTV200DS installed)

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.16 loaded
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
  alloc irq_desc for 17 on node 0
  alloc kstat_irqs on node 0
saa7134 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
saa7130[0]: found at 0000:01:07.0, rev: 1, irq: 17, latency: 32, mmio:
0xfdeff000
saa7130[0]: subsystem: 107d:6655, board: Leadtek Winfast DTV1000S
[card=175,autodetected]
saa7130[0]: board init: gpio is 2020000
dvb-usb: found a 'Leadtek WinFast DTV2000DS' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Leadtek WinFast DTV2000DS)
k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
IR NEC protocol handler initialized
Registered IR keymap rc-winfast
input: saa7134 IR (Leadtek Winfast DTV as
/devices/pci0000:00/0000:00:08.0/0000:01:07.0/rc/rc0/input5
rc0: saa7134 IR (Leadtek Winfast DTV as
/devices/pci0000:00/0000:00:08.0/0000:01:07.0/rc/rc0
IRQ 17/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
af9013: firmware version:5.1.0
DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
IR JVC protocol handler initialized
saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff
saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff
saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
HDA Intel 0000:00:07.0: PCI INT A -> Link[AAZA] -> GSI 22 (level, low) -> IRQ 22
hda_intel: Disable MSI for Nvidia chipset
hda_intel: position_fix set to 1 for device 1458:a022
HDA Intel 0000:00:07.0: setting latency timer to 64
IR Sony protocol handler initialized
hda_codec: ALC888: BIOS auto-probing.
ALSA sound/pci/hda/hda_codec.c:4284: autoconfig: line_outs=4
(0x14/0x15/0x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:4288:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4292:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:4293:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:4296:    dig-out=0x1e/0x0
ALSA sound/pci/hda/hda_codec.c:4304:    inputs: mic=0x18, fmic=0x19,
line=0x1a, fline=0x0, cd=0x1c, aux=0x0
tda18271 4-00c0: creating new instance
TDA18271HD/C2 detected @ 4-00c0
ALSA sound/pci/hda/patch_realtek.c:1313: realtek: Enabling init
ASM_ID=0xe601 CODEC_ID=10ec0888
Chip ID is not zero. It is not a TEA5767
tuner 6-0060: chip found @ 0xc0 (saa7130[0])
tda8290: no gate control were provided!
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Leadtek WinFast DTV2000DS)
dvb_init() allocating 1 frontend
tda18271 6-0060: creating new instance
TDA18271HD/C1 detected @ 6-0060
af9013: found a 'Afatech AF9013 DVB-T' in warm state.
af9013: firmware version:5.1.0
DVB: registering adapter 1 frontend 0 (Afatech AF9013 DVB-T)...
DVB: registering new adapter (saa7130[0])
tda18271 5-00c0: creating new instance
DVB: registering adapter 2 frontend 0 (NXP TDA10048HN DVB-T)...
af9015: command failed:2
tda18271_read_regs: [5-00c0|M] ERROR: i2c_transfer returned: -1
Unknown device detected @ 5-00c0, device not supported.
af9015: command failed:2
tda18271_read_regs: [5-00c0|M] ERROR: i2c_transfer returned: -1
Unknown device detected @ 5-00c0, device not supported.
tda18271_attach: [5-00c0|M] error -22 on line 1272
tda18271 5-00c0: destroying instance
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:08.0/0000:01:08.2/usb3/3-1/input/input6
dvb-usb: schedule remote query interval to 150 msecs.
dvb-usb: Leadtek WinFast DTV2000DS successfully initialized and connected.
tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
saa7134 0000:01:07.0: firmware: requesting dvb-fe-tda10048-1.0.fw
usbcore: registered new interface driver dvb_usb_af9015
tda10048_firmware_upload: firmware read 24878 bytes.
tda10048_firmware_upload: firmware uploading
vboxguest: VirtualBox Guest PCI device not found.
vboxsf: Unknown symbol RTSemFastMutexCreate
vboxsf: Unknown symbol VBoxGuestIDCCall
vboxsf: Unknown symbol RTMemTmpFree
vboxsf: Unknown symbol RTErrConvertToErrno
vboxsf: Unknown symbol RTSemFastMutexRequest
vboxsf: Unknown symbol RTMemTmpAlloc
vboxsf: Unknown symbol RTLogRelDefaultInstance
vboxsf: Unknown symbol RTMemContAlloc
vboxsf: Unknown symbol RTSemFastMutexRelease
vboxsf: Unknown symbol VBoxGuestIDCOpen
vboxsf: Unknown symbol AssertMsg2
vboxsf: Unknown symbol RTMemContFree
vboxsf: Unknown symbol RTAssertShouldPanic
vboxsf: Unknown symbol RTLogLoggerEx
vboxsf: Unknown symbol VBoxGuestIDCClose
vboxsf: Unknown symbol AssertMsg1
vboxsf: Unknown symbol RTSemFastMutexDestroy
vboxdrv: Trying to deactivate the NMI watchdog permanently...
vboxdrv: Warning: 2.6.31+ kernel detected. Most likely the hardware performance
vboxdrv: counter framework which can generate NMIs is active. You have
to prevent
vboxdrv: the usage of hardware performance counters by
vboxdrv:   echo 2 > /proc/sys/kernel/perf_counter_paranoid
vboxdrv: Found 2 processor cores.
VBoxDrv: dbg - g_abExecMemory=ffffffffa030c580
vboxdrv: fAsync=1 offMin=0x2b1e8 offMax=0x2b1e8
vboxdrv: TSC mode is 'asynchronous', kernel timer mode is 'normal'.
vboxdrv: Successfully loaded version 3.1.8_OSE (interface 0x00100001).
tda10048_firmware_upload: firmware uploaded
EXT4-fs (sda1): mounted filesystem with ordered data mode
EXT4-fs (dm-2): mounted filesystem with ordered data mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sdb1): warning: maximal mount count reached, running e2fsck
is recommended
EXT3-fs (sdb1): using internal journal
EXT3-fs (sdb1): mounted filesystem with ordered data mode
Adding 6160376k swap on /dev/mapper/vg_mediabox-lv_swap.  Priority:-1
extents:1 across:6160376k
powernow-k8: Found 1 AMD Athlon(tm) Dual Core Processor 5050e
processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0xc
powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xe
powernow-k8:    2 : fid 0xe (2200 MHz), vid 0x10
powernow-k8:    3 : fid 0xc (2000 MHz), vid 0x12
powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x14
powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x1a
Clocksource tsc unstable (delta = -97201585 ns)
r8169: eth0: link up
r8169: eth0: link up
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tda18271: performing RF tracking filter calibration
[drm] nouveau 0000:02:00.0: Allocating FIFO number 1
[drm] nouveau 0000:02:00.0: nouveau_channel_alloc: initialised FIFO 1
fuse init (API version 7.13)
tda18271: RF tracking filter calibration complete
eth0: no IPv6 routers present
af9015: command failed:2
af9013: I2C read failed reg:d2e6
af9015: command failed:2
af9013: I2C read failed reg:d330

>From this point on there are lots of I2C read failures most of which
are for "reg:d330"

Any ideas?


Thanks, Mark
