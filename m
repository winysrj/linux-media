Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web55613.mail.re4.yahoo.com ([206.190.58.237])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <trevor_boon@yahoo.com>) id 1JnmJ8-0004NE-S3
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 05:03:08 +0200
Date: Mon, 21 Apr 2008 13:02:16 +1000 (EST)
From: Trevor Boon <trevor_boon@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <909585.95795.qm@web55613.mail.re4.yahoo.com>
Subject: Re: [linux-dvb] HVR1200 / HVR1700 / TDA10048 support
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

Hi,

I have a Leadtek DTV1000s, which uses the tda10048,
and after compiling the latest build of v4l-dvb which
include the tda10048 support, the driver crashes upon
boot. 

I know the DTV100s is not yet officially supported,
however now that the nxp18271 and the tda10048 drivers
have been implemented, I thought I'd give it a go.

Using Kernel 2.6.25 on Ubuntu Hardy 8.04

I've already tried blacklisting the saa7134-alsa from
a previous driver crash. (I believe that has been
fixed however?)

As the dmesg output shows, I specified card=21 as this
worked for composite input previously. I've tried
other card numbers as well with the same result. No
card number just returns 0=autodetected (as expected)
but it doesn't try to load the tda10048 module and
therefore doesn't crash.

Is there anything else I can do to try and help
troubleshoot this issue/ expediate official dtv1000s
support?

Here's the dmesg output.

[   16.420527] Linux video capture interface: v2.00
[   16.668573] saa7130/34: v4l2 driver version 0.2.14
loaded
[   16.668681] ACPI: PCI Interrupt 0000:02:03.0[A] ->
GSI 18 (level, low) -> IRQ 18
[   16.668773] saa7130[0]: found at 0000:02:03.0, rev:
1, irq: 18, latency: 32, mmio: 0xc0021000
[   16.668836] saa7130[0]: subsystem: 107d:6655,
board: 10MOONS PCI TV CAPTURE CARD [card=21,insmod
option]
[   16.668903] saa7130[0]: board init: gpio is 22000
[   16.836163] saa7130[0]: i2c eeprom 00: 7d 10 55 66
54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   16.836719] saa7130[0]: i2c eeprom 10: 00 ff 82 0e
ff 20 ff ff ff ff ff ff ff ff ff ff
[   16.837268] saa7130[0]: i2c eeprom 20: 01 40 01 01
01 ff 01 03 08 ff 00 8a ff ff ff ff
[   16.837816] saa7130[0]: i2c eeprom 30: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.838366] saa7130[0]: i2c eeprom 40: ff 35 00 c0
00 10 03 02 ff 04 ff ff ff ff ff ff
[   16.838919] saa7130[0]: i2c eeprom 50: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.839466] saa7130[0]: i2c eeprom 60: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.840011] saa7130[0]: i2c eeprom 70: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.840606] saa7130[0]: i2c eeprom 80: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.841152] saa7130[0]: i2c eeprom 90: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.841697] saa7130[0]: i2c eeprom a0: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.842242] saa7130[0]: i2c eeprom b0: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.842789] saa7130[0]: i2c eeprom c0: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.843334] saa7130[0]: i2c eeprom d0: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.843881] saa7130[0]: i2c eeprom e0: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   16.844457] saa7130[0]: i2c eeprom f0: ff ff ff ff
ff ff ff ff ff ff ff ff ff ff ff ff
[   17.169977] Chip ID is not zero. It is not a
TEA5767
[   17.169977] tuner' 0-0060: chip found @ 0xc0
(saa7130[0])
[   16.692386] BUG: unable to handle kernel NULL
pointer dereference at 00000000
[   16.692386] IP: [<c020c2ea>] strlen+0xa/0x20
[   16.692386] *pde = 00000000 
[   16.692386] Oops: 0000 [#1] SMP 
[   16.692386] Modules linked in: tuner(+) tea5767
tda8290 tda18271 tda827x tuner_xc2028 xc5000 tda9887
tuner_simple mt20xx tea5761 serio_raw(+) psmouse
saa7134(+) videodev v4l1_compat compat_ioctl32
v4l2_common videobuf_dma_sg videobuf_core ir_kbd_i2c
ir_common tveeprom pcspkr i2c_core button iTCO_wdt
iTCO_vendor_support intel_agp shpchp pci_hotplug
agpgart evdev ext3 jbd mbcache sg sr_mod sd_mod cdrom
pata_acpi ata_piix ata_generic libata scsi_mod dock
r8169 ehci_hcd uhci_hcd usbcore thermal processor fan
fuse fbcon tileblit font bitblit softcursor
[   16.692386] 
[   16.692386] Pid: 3755, comm: modprobe Not tainted
(2.6.25-custom #1)
[   16.692386] EIP: 0060:[<c020c2ea>] EFLAGS: 00010246
CPU: 1
[   16.692386] EIP is at strlen+0xa/0x20
[   16.692386] EAX: 00000000 EBX: 00000014 ECX:
ffffffff EDX: 00000000
[   16.692386] ESI: 00000000 EDI: 00000000 EBP:
f7a44404 ESP: f7a79cfc
[   16.692386]  DS: 007b ES: 007b FS: 00d8 GS: 0033
SS: 0068
[   16.692386] Process modprobe (pid: 3755,
ti=f7a78000 task=f7bb0bc0 task.ti=f7a78000)
[   16.692386] Stack: f7a44400 c020a40f f795f400
f795f400 f7a44400 f795f400 f89f3f27 f7a79d48 
[   16.692386]        f79d3240 f4c06000 c01cd600
f4fbd978 c01cdc44 f7a79d58 f79d30f0 f79d3240 
[   16.692386]        00000004 00000036 f7a44400
f795f648 f89938b0 00000000 f7a44420 f7a44454 
[   16.692386] Call Trace:
[   16.692386]  [<c020a40f>] strlcpy+0x1f/0x60
[   16.692386]  [<f89f3f27>] set_type+0xd7/0x7d0
[tuner]
[   16.692386]  [<c01cd600>]
sysfs_ilookup_test+0x0/0x10
[   16.692386]  [<c01cdc44>]
sysfs_addrm_finish+0x14/0x1c0
[   16.692386]  [<f89938b0>]
saa7134_tuner_callback+0x0/0x100 [saa7134]
[   16.692386]  [<f89f55e8>]
tuner_command+0x6a8/0x1380 [tuner]
[   16.692386]  [<f89938b0>]
saa7134_tuner_callback+0x0/0x100 [saa7134]
[   16.692386]  [<c0303b6e>] klist_add_tail+0x1e/0x40
[   16.692386]  [<c02073bf>] kobject_get+0xf/0x20
[   16.692386]  [<c026bfce>] get_device+0xe/0x20
[   16.692386]  [<f899404e>] attach_inform+0x15e/0x200
[saa7134]
[   16.692386]  [<c026c44a>] device_add+0x2a/0x570
[   16.692386]  [<f89938b0>]
saa7134_tuner_callback+0x0/0x100 [saa7134]
[   16.692386]  [<f892eff4>]
i2c_attach_client+0xd4/0x150 [i2c_core]
[   16.692386]  [<f898d3f0>] v4l2_i2c_attach+0x60/0x90
[v4l2_common]
[   16.692386]  [<f89f46be>]
v4l2_i2c_drv_attach_legacy+0x1e/0x30 [tuner]
[   16.692386]  [<f89f4b10>] tuner_probe+0x0/0x430
[tuner]
[   16.692386]  [<f892ec1e>]
i2c_probe_address+0x3e/0x130 [i2c_core]
[   16.692386]  [<f892fcbb>] i2c_probe+0x1fb/0x210
[i2c_core]
[   16.692386]  [<f89f46a0>]
v4l2_i2c_drv_attach_legacy+0x0/0x30 [tuner]
[   16.692386]  [<f892fa70>]
i2c_device_remove+0x0/0x50 [i2c_core]
[   16.692386]  [<f89f46a0>]
v4l2_i2c_drv_attach_legacy+0x0/0x30 [tuner]
[   16.692386]  [<f892f315>]
i2c_register_driver+0xc5/0x120 [i2c_core]
[   16.692386]  [<f894a06a>]
v4l2_i2c_drv_init+0x6a/0xc9 [tuner]
[   16.692386]  [<c014a4bc>]
sys_init_module+0x11c/0x1b20
[   16.692386]  [<f892ed60>] i2c_master_send+0x0/0x50
[i2c_core]
[   16.692386]  [<c01087db>] sys_mmap2+0xcb/0xd0
[   16.692386]  [<c0104da4>]
sysenter_past_esp+0x6d/0xa9
[   16.692386]  [<c013007b>]
ptrace_request+0x22b/0x2c0
[   16.692386]  =======================
[   16.692386] Code: 00 56 89 c6 89 d0 88 c4 ac 38 e0
74 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e c3 8d b6
00 00 00 00 57 b9 ff ff ff ff 89 c7 31 c0 <f2> ae f7
d1 49 5f 89 c8 c3 8d b6 00 00 00 00 8d bc 27 00 00 00 
[   16.692386] EIP: [<c020c2ea>] strlen+0xa/0x20
SS:ESP 0068:f7a79cfc
[   16.692391] ---[ end trace 3b4b6fb9b74102ec ]---
[   16.692530] tuner' 0-0060: Tuner has no way to set
tv freq
[   16.692581] tuner' 0-0060: Tuner has no way to set
tv freq
[   16.692675] saa7130[0]: registered device video0
[v4l2]
[   16.692754] saa7130[0]: registered device vbi0
[   16.692831] saa7130[0]: registered device radio0
[  191.107696] tuner' 0-0060: tuner has no way to set
radio frequency
[  191.839518] tuner' 0-0060: Tuner has no way to set
tv freq
[  191.129201] tuner' 0-0060: Tuner has no way to set
tv freq


      Get the name you always wanted with the new y7mail email address.
www.yahoo7.com.au/y7mail



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
