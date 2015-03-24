Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:63424 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271AbbCXOw3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 10:52:29 -0400
Message-ID: <55117A22.6010302@gmx.com>
Date: Tue, 24 Mar 2015 15:52:18 +0100
From: Ole Ernst <olebowle@gmx.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, Nibble Max <nibble.max@gmail.com>
CC: "olli.salonen" <olli.salonen@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: cx23885: DVBSky S952 dvb_register failed err = -22
References: <5504920C.7080806@gmx.com>, <55055E66.6040600@gmx.com>, <550563B2.9010306@iki.fi>, <201503170953368436904@gmail.com> <201503180940386096906@gmail.com> <55093FFC.9050602@gmx.com> <55105683.40809@iki.fi> <551081CF.3080901@gmx.com> <5510992C.8060608@iki.fi> <551157AB.1090704@gmx.com> <55115E93.7030405@iki.fi>
In-Reply-To: <55115E93.7030405@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.03.2015 um 13:54 schrieb Antti Palosaari:
> Looks strange as firmware is not downloaded. It is downloaded on when
> first tuning attempt is done, so nodes are created in any case. TS2020
> tuner is detected correctly, which looks somehow promising. Could you
> test my patches again as I have done some changes (tree is rebased).

Hi Antti,

I don't know what went wrong on first try, but after enabling some debug
output I can see the firmware being downloaded.
Mär 24 15:15:47 htpc kernel: cx23885 driver version 0.0.4 loaded
Mär 24 15:15:47 htpc kernel: cx23885 0000:04:00.0: enabling device (0000
-> 0002)
Mär 24 15:15:47 htpc kernel: CORE cx23885[0]: subsystem: 4254:0952,
board: DVBSky S952 [card=50,autodetected]
Mär 24 15:15:47 htpc kernel: cx25840 3-0044: cx23885 A/V decoder found @
0x88 (cx23885[0])
Mär 24 15:15:48 htpc kernel: cx25840 3-0044: loaded
v4l-cx23885-avcore-01.fw firmware (16382 bytes)
Mär 24 15:15:48 htpc kernel: cx23885_dvb_register() allocating 1 frontend(s)
Mär 24 15:15:48 htpc kernel: cx23885[0]: cx23885 based dvb card
Mär 24 15:15:48 htpc kernel: i2c i2c-2: m88ds3103_attach: chip_id=70
Mär 24 15:15:48 htpc kernel: i2c i2c-2: Added multiplexed i2c bus 4
Mär 24 15:15:48 htpc kernel: ts2020 4-0060: Montage Technology TS2020
successfully identified
Mär 24 15:15:48 htpc kernel: DVB: registering new adapter (cx23885[0])
Mär 24 15:15:48 htpc kernel: cx23885 0000:04:00.0: DVB: registering
adapter 0 frontend 0 (Montage M88DS3103)...
Mär 24 15:15:48 htpc kernel: DVBSky S952 port 1 MAC address:
ff:ff:ff:ff:ff:ff
Mär 24 15:15:48 htpc kernel: cx23885_dvb_register() allocating 1 frontend(s)
Mär 24 15:15:48 htpc kernel: cx23885[0]: cx23885 based dvb card
Mär 24 15:15:48 htpc kernel: i2c i2c-1: m88ds3103_attach: chip_id=70
Mär 24 15:15:48 htpc kernel: i2c i2c-1: Added multiplexed i2c bus 5
Mär 24 15:15:48 htpc kernel: ts2020 5-0060: Montage Technology TS2020
successfully identified
Mär 24 15:15:48 htpc kernel: DVB: registering new adapter (cx23885[0])
Mär 24 15:15:48 htpc kernel: cx23885 0000:04:00.0: DVB: registering
adapter 1 frontend 0 (Montage M88DS3103)...
Mär 24 15:15:48 htpc kernel: DVBSky S952 port 2 MAC address:
ff:ff:ff:ff:ff:ff
Mär 24 15:15:48 htpc kernel: cx23885_dev_checkrevision() Hardware
revision = 0xa5
Mär 24 15:15:48 htpc kernel: cx23885[0]/0: found at 0000:04:00.0, rev:
4, irq: 17, latency: 0, mmio: 0xf7200000
Mär 24 15:15:52 htpc kernel: i2c i2c-2: m88ds3103_init:
Mär 24 15:15:52 htpc kernel: i2c i2c-2: m88ds3103_init: firmware=00
Mär 24 15:15:52 htpc kernel: i2c i2c-2: m88ds3103: found a 'Montage
M88DS3103' in cold state
Mär 24 15:15:52 htpc kernel: i2c i2c-2: m88ds3103: downloading firmware
from file 'dvb-demod-m88ds3103.fw'
Mär 24 15:15:53 htpc kernel: i2c i2c-2: m88ds3103: found a 'Montage
M88DS3103' in warm state
Mär 24 15:15:53 htpc kernel: i2c i2c-2: m88ds3103: firmware version 3.B
Mär 24 15:15:53 htpc vdr[388]: [388] DVB API version is 0x050A (VDR was
built with 0x050A)
Mär 24 15:15:53 htpc vdr[388]: [388] frontend 0/0 provides DVB-S,DVB-S2
with QPSK ("Montage M88DS3103")
Mär 24 15:15:53 htpc kernel: i2c i2c-1: m88ds3103_init:
Mär 24 15:15:53 htpc kernel: i2c i2c-1: m88ds3103_init: firmware=00
Mär 24 15:15:53 htpc kernel: i2c i2c-1: m88ds3103: found a 'Montage
M88DS3103' in cold state
Mär 24 15:15:53 htpc kernel: i2c i2c-1: m88ds3103: downloading firmware
from file 'dvb-demod-m88ds3103.fw'
Mär 24 15:15:54 htpc kernel: i2c i2c-1: m88ds3103: found a 'Montage
M88DS3103' in warm state
Mär 24 15:15:54 htpc kernel: i2c i2c-1: m88ds3103: firmware version 3.B
Mär 24 15:15:54 htpc vdr[388]: [388] frontend 1/0 provides DVB-S,DVB-S2
with QPSK ("Montage M88DS3103")
Mär 24 15:15:54 htpc vdr[388]: [388] found 2 DVB devices

However, the tuner still times out even with your rebase. I sometimes
also get this output from vdr:
Mär 24 15:22:20 htpc vdr[388]: [407] ERROR (dvbdevice.c,727): Die
Wartezeit für die Verbindung ist abgelaufen
Which basically says the waiting time has exceeded.

I was playing a bit with femon plugin and often there will be a regained
lock, with no picture though. Two times I also got a divide error:

Mär 24 15:21:27 htpc vdr[388]: [407] frontend 0/0 regained lock on
channel 2 (ZDF HD), tp 111361
Mär 24 15:21:28 htpc vdr[388]: [407] frontend 0/0 lost lock on channel 2
(ZDF HD), tp 111361
Mär 24 15:21:28 htpc vdr[388]: [407] frontend 0/0 regained lock on
channel 2 (ZDF HD), tp 111361
Mär 24 15:21:29 htpc vdr[388]: [407] frontend 0/0 lost lock on channel 2
(ZDF HD), tp 111361
Mär 24 15:21:30 htpc kernel: divide error: 0000 [#1] PREEMPT SMP
Mär 24 15:21:30 htpc kernel: Modules linked in: uinput cfg80211 rfkill
ts2020(O) m88ds3103(O) i2c_mux snd_hda_codec_hdmi cx25840(O) iTCO_wdt
iTCO_vendor_support gpio_ich joydev mousedev ppdev evdev mac_hid
intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp kvm_intel
snd_hda_codec_realtek snd_hda_codec_generic kvm psmouse pcspkr serio_raw
nvidia(PO) nls_iso8859_1 nls_cp437 vfat fat cx23885(O) altera_ci(O)
tda18271(O) altera_stapl(O) i2c_i801 videobuf2_dvb(O) hid_logitech_hidpp
videobuf2_dma_sg(O) ir_xmp_decoder(O) tveeprom(O) ir_lirc_codec(O)
cx2341x(O) lirc_dev(O) ir_sharp_decoder(O) ir_mce_kbd_decoder(O)
dvb_core(O) ir_sanyo_decoder(O) videobuf2_memops(O) ir_jvc_decoder(O)
videobuf2_core(O) ir_sony_decoder(O) v4l2_common(O) ir_rc6_decoder(O)
lpc_ich snd_usb_audio ir_rc5_decoder(O) drm ir_nec_decoder(O) videodev(O)
Mär 24 15:21:30 htpc kernel:  snd_usbmidi_lib snd_rawmidi snd_seq_device
media(O) snd_hda_intel i2c_core snd_hda_controller rc_rc6_mce(O)
snd_hda_codec nuvoton_cir(O) snd_hwdep snd_pcm parport_pc e1000e
snd_timer parport rc_core(O) snd mei_me ptp mei soundcore pps_core
shpchp button processor sch_fq_codel w83627ehf hwmon_vid coretemp hwmon
xts gf128mul algif_skcipher af_alg dm_crypt dm_mod sr_mod cdrom sd_mod
hid_logitech_dj usbhid hid uas usb_storage ata_generic pata_acpi atkbd
libps2 crct10dif_pclmul crc32_pclmul crc32c_intel firewire_ohci ehci_pci
ata_piix ghash_clmulni_intel cryptd firewire_core libata scsi_mod
xhci_pci crc_itu_t xhci_hcd ehci_hcd usbcore usb_common i8042 serio ext4
crc16 mbcache jbd2
Mär 24 15:21:30 htpc kernel: CPU: 1 PID: 512 Comm: femon osd Tainted: P
          O   3.19.1-1-ARCH #1
Mär 24 15:21:30 htpc kernel: Hardware name:                  /DP67DE,
BIOS BAP6710H.86A.0072.2011.0927.1425 09/27/2011
Mär 24 15:21:30 htpc kernel: task: ffff8801fcbb1dd0 ti: ffff8800dd9a0000
task.ti: ffff8800dd9a0000
Mär 24 15:21:30 htpc kernel: RIP: 0010:[<ffffffffa0ee4335>]
[<ffffffffa0ee4335>] m88ds3103_read_snr+0x205/0x2a0 [m88ds3103]
Mär 24 15:21:30 htpc kernel: RSP: 0018:ffff8800dd9a3ba8  EFLAGS: 00010246
Mär 24 15:21:30 htpc kernel: RAX: 0000000000000036 RBX: ffff88020975e800
RCX: 00000000aaaaaaab
Mär 24 15:21:30 htpc kernel: RDX: 0000000000000000 RSI: ffff8800dd9a3b5f
RDI: ffff88020975e808
Mär 24 15:21:30 htpc kernel: RBP: ffff8800dd9a3bf8 R08: 0000000000000000
R09: 0000000000000003
Mär 24 15:21:30 htpc kernel: R10: ffff8800dd9a3b38 R11: 0000000000000246
R12: 0000000000000000
Mär 24 15:21:30 htpc kernel: R13: ffff8800dd9a3bbd R14: 00000000000000a2
R15: 0000000000000000
Mär 24 15:21:30 htpc kernel: FS:  00007ff4edd84700(0000)
GS:ffff880217500000(0000) knlGS:0000000000000000
Mär 24 15:21:30 htpc kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Mär 24 15:21:30 htpc kernel: CR2: 00007ff868bef000 CR3: 00000000dd858000
CR4: 00000000000407e0
Mär 24 15:21:30 htpc kernel: Stack:
Mär 24 15:21:30 htpc kernel:  ffff8800dd9a3de0 ffff8800dd9a3de0
1200000000000000 000000001ddfd430
Mär 24 15:21:30 htpc kernel:  ffff8800dd9a3bf8 ffff8800dd9a3de0
0000000080026f48 ffff8801fcb69100
Mär 24 15:21:30 htpc kernel:  ffff880209773400 ffff88020975e838
ffff8800dd9a3d38 ffffffffa054f1a6
Mär 24 15:21:30 htpc kernel: Call Trace:
Mär 24 15:21:30 htpc kernel:  [<ffffffffa054f1a6>]
dvb_frontend_ioctl_legacy.isra.8+0xa6/0xc80 [dvb_core]
Mär 24 15:21:30 htpc kernel:  [<ffffffff810dd199>] ?
lock_hrtimer_base.isra.22+0x29/0x60
Mär 24 15:21:30 htpc kernel:  [<ffffffff810dd263>] ?
hrtimer_try_to_cancel+0x93/0x120
Mär 24 15:21:30 htpc kernel:  [<ffffffff810dd312>] ?
hrtimer_cancel+0x22/0x30
Mär 24 15:21:30 htpc kernel:  [<ffffffff811e5930>] ?
poll_select_copy_remaining+0x150/0x150
Mär 24 15:21:30 htpc kernel:  [<ffffffffa054fe54>]
dvb_frontend_ioctl+0xd4/0x1310 [dvb_core]
Mär 24 15:21:30 htpc kernel:  [<ffffffffa0545da5>]
dvb_usercopy+0x115/0x190 [dvb_core]
Mär 24 15:21:30 htpc kernel:  [<ffffffffa054fd80>] ?
dvb_frontend_ioctl_legacy.isra.8+0xc80/0xc80 [dvb_core]
Mär 24 15:21:30 htpc kernel:  [<ffffffff810f0672>] ? do_futex+0x132/0xad0
Mär 24 15:21:30 htpc kernel:  [<ffffffff8155e328>] ? __schedule+0x908/0xa30
Mär 24 15:21:30 htpc kernel:  [<ffffffffa0545e43>]
dvb_generic_ioctl+0x23/0x40 [dvb_core]
Mär 24 15:21:30 htpc kernel:  [<ffffffff811e4c98>] do_vfs_ioctl+0x2f8/0x500
Mär 24 15:21:30 htpc kernel:  [<ffffffff811ef3e2>] ? __fget+0x72/0xb0
Mär 24 15:21:30 htpc kernel:  [<ffffffff811e4f21>] SyS_ioctl+0x81/0xa0
Mär 24 15:21:30 htpc kernel:  [<ffffffff815622e9>]
system_call_fastpath+0x12/0x17
Mär 24 15:21:30 htpc kernel: Code: 48 c7 c2 79 52 ee a0 48 c7 c7 20 67
ee a0 48 8d 70 48 31 c0 e8 4d af 3f e0 e9 48 fe ff ff 0f 1f 84 00 00 00
00 00 31 d2 45 31 e4 <66> 41 f7 f7 0f b7 f8 e8 5f 03 67 ff 89 c0 48 8b
7d b8 48 8d 04
Mär 24 15:21:30 htpc kernel: RIP  [<ffffffffa0ee4335>]
m88ds3103_read_snr+0x205/0x2a0 [m88ds3103]
Mär 24 15:21:30 htpc kernel:  RSP <ffff8800dd9a3ba8>
Mär 24 15:21:30 htpc kernel: ---[ end trace 7e7bc66b3dd96971 ]---

Don't know if it matters, but I'm using SCR/Unicable for getting several
transponders through to my dvb card. Thus, proper diseqc commands are
essential. Maybe that is the issue?

Thanks,
Ole
