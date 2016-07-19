Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:39410 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbcGSTs5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 15:48:57 -0400
From: "Uwe D." <dollydl@arcor.de>
To: <mchehab@s-opensource.com>
Cc: <linux-media@vger.kernel.org>
Subject: =?us-ascii?Q?System_freeze_when_going_into_suspend_after_=22modprobe_-r_c?=
	=?us-ascii?Q?x23885_cx25840=22?=
Date: Tue, 19 Jul 2016 21:48:50 +0200
Message-ID: <000001d1e1f6$93030c70$b9092550$@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When my system (with last upstream kernel) goes into suspend (hybrid-sleep
with systemd), I get sometimes (around every third to fifth time) a system
freeze, when systemd removes the modules cx23885 cx25840 for my DVB-C/T card
DVBSky T982. The modules are not used at the moment (e.g. by tvheadend).

Kernel version from /proc/version:
Linux version 4.7.0-040700rc7-generic (kernel@gloin) (gcc version 5.4.0
20160609 (Ubuntu 5.4.0-6ubuntu1) ) #201607110032 SMP Mon Jul 11 04:34:25 UTC
2016


Command to remove DVB modules in a systemd/systemctl script:
modprobe -r cx23885 cx25840


Whole conf for systemd/systemctl in /etc/systemd/system/dvb.service:
[Unit]
Description=Restart DVB services
Before=sleep.target
StopWhenUnneeded=yes

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/sbin/modprobe -r cx23885 cx25840
ExecStop=/sbin/modprobe cx25840 ; /sbin/modprobe cx23885

[Install]
WantedBy=sleep.target


Syslog output with error during crash/freeze:
Jul 13 14:20:22 HomeServer NetworkManager[783]: <info>  [1468412422.2305]
manager: sleep requested (sleeping: no  enabled: yes)
Jul 13 14:20:22 HomeServer NetworkManager[783]: <info>  [1468412422.2306]
manager: sleeping...
Jul 13 14:20:22 HomeServer NetworkManager[783]: <info>  [1468412422.2307]
manager: NetworkManager state is now ASLEEP
Jul 13 14:20:22 HomeServer whoopsie[814]: [14:20:22] offline
Jul 13 14:20:22 HomeServer com.canonical.indicator.application[1275]:
(process:1466): indicator-application-service-WARNING **: Application
already exists, re-requesting properties.
Jul 13 14:20:22 HomeServer systemd[1]: Starting Restart DVB services...
Jul 13 14:20:22 HomeServer kernel: [  261.815215] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000200
Jul 13 14:20:22 HomeServer kernel: [  261.815291] IP: [<ffffffffc086ecc4>]
dvb_frontend_stop+0x34/0xd0 [dvb_core]
Jul 13 14:20:22 HomeServer kernel: [  261.815356] PGD 0 
Jul 13 14:20:22 HomeServer kernel: [  261.815377] Oops: 0000 [#1] SMP
Jul 13 14:20:22 HomeServer kernel: [  261.815403] Modules linked in:
cx23885(-) altera_ci tda18271 altera_stapl m88ds3103 tveeprom cx2341x
videobuf2_dvb dvb_core rc_core videobuf2_dma_sg videobuf2_memops
videobuf2_v4l2 videobuf2_core cx25840 v4l2_common videodev fuse si2157
si2168 nls_utf8 nls_cp437 vfat fat snd_hda_codec_hdmi snd_hda_intel
snd_hda_codec snd_hda_core i2c_mux snd_hwdep snd_pcm intel_rapl
x86_pkg_temp_thermal intel_powerclamp snd_seq_midi coretemp
snd_seq_midi_event snd_rawmidi kvm_intel kvm irqbypass intel_cstate
intel_rapl_perf snd_seq efi_pstore snd_seq_device snd_timer joydev media
serio_raw efivars lpc_ich sg snd mfd_core soundcore mei_me mei shpchp
battery evdev tpm_tis tpm parport_pc ppdev lp parport efivarfs autofs4 ext4
crc16 jbd2 mbcache xts gf128mul algif_skcipher af_alg dm_crypt dm_mod raid10
raid1 raid0 multipath linear raid456 async_raid6_recov async_memcpy async_pq
async_xor async_tx xor raid6_pq libcrc32c crc32c_generic md_mod sd_mod
hid_logitech_hidpp hid_logitech_dj usbhid hid crct10dif_pclmul crc32_pclmul
ahci libahci crc32c_intel libata ghash_clmulni_intel cryptd scsi_mod psmouse
fan thermal xhci_pci ehci_pci xhci_hcd ehci_hcd e1000e fjes ptp i915
pps_core usbcore video button i2c_algo_bit usb_common drm_kms_helper drm
[last unloaded: videodev]
Jul 13 14:20:22 HomeServer kernel: [  261.816495] CPU: 0 PID: 2789 Comm:
modprobe Not tainted 4.7.0-040700rc7-generic #201607110032
Jul 13 14:20:22 HomeServer kernel: [  261.816555] Hardware name:
/DH87RL, BIOS RLH8710H.86A.0330.2015.0720.1750 07/20/2015
Jul 13 14:20:22 HomeServer kernel: [  261.816620] task: ffff8800d11ef1c0 ti:
ffff8800d6be0000 task.ti: ffff8800d6be0000
Jul 13 14:20:22 HomeServer kernel: [  261.816673] RIP:
0010:[<ffffffffc086ecc4>]  [<ffffffffc086ecc4>] dvb_frontend_stop+0x34/0xd0
[dvb_core]
Jul 13 14:20:22 HomeServer kernel: [  261.816749] RSP: 0018:ffff8800d6be3d78
EFLAGS: 00010293
Jul 13 14:20:22 HomeServer kernel: [  261.816789] RAX: ffff8800d11ef1c0 RBX:
0000000000000000 RCX: ffffea00035bd51f
Jul 13 14:20:22 HomeServer kernel: [  261.816839] RDX: 0000000080000000 RSI:
ffff8800b725b400 RDI: ffff8800590e1830
Jul 13 14:20:22 HomeServer kernel: [  261.816889] RBP: ffff8800590e1830 R08:
ffffea0001459b60 R09: 0000000000000002
Jul 13 14:20:22 HomeServer kernel: [  261.816940] R10: ffffffff81b09300 R11:
ffffffff81b092c0 R12: ffff8800d1a3f280
Jul 13 14:20:22 HomeServer kernel: [  261.820361] R13: ffff880112889768 R14:
ffff880112889778 R15: 00007ffd78781738
Jul 13 14:20:22 HomeServer kernel: [  261.823746] FS:
00007efd7e7d8700(0000) GS:ffff88011fa00000(0000) knlGS:0000000000000000
Jul 13 14:20:22 HomeServer kernel: [  261.827151] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jul 13 14:20:22 HomeServer kernel: [  261.830458] CR2: 0000000000000200 CR3:
00000000343db000 CR4: 00000000000406f0
Jul 13 14:20:22 HomeServer kernel: [  261.833570] Stack:
Jul 13 14:20:22 HomeServer kernel: [  261.836658]  0000000000000000
ffff8800590e1830 ffffffffc086f236 ffffffffc06e1281
Jul 13 14:20:22 HomeServer kernel: [  261.839813]  ffff880112889768
ffff880112889778 00007ffd78781738 0000000000000286
Jul 13 14:20:22 HomeServer kernel: [  261.842851]  00000000d5d01479
ffff8800d1a3f000 ffff880112889768 ffffffffc06e128a
Jul 13 14:20:22 HomeServer kernel: [  261.845741] Call Trace:
Jul 13 14:20:22 HomeServer kernel: [  261.848609]  [<ffffffffc086f236>] ?
dvb_unregister_frontend+0x46/0x130 [dvb_core]
Jul 13 14:20:22 HomeServer kernel: [  261.851522]  [<ffffffffc06e1281>] ?
vb2_dvb_dealloc_frontends+0x81/0xd0 [videobuf2_dvb]
Jul 13 14:20:22 HomeServer kernel: [  261.854607]  [<ffffffffc06e128a>] ?
vb2_dvb_dealloc_frontends+0x8a/0xd0 [videobuf2_dvb]
Jul 13 14:20:22 HomeServer kernel: [  261.857957]  [<ffffffffc06e12de>] ?
vb2_dvb_unregister_bus+0xe/0x20 [videobuf2_dvb]
Jul 13 14:20:22 HomeServer kernel: [  261.861283]  [<ffffffffc095649f>] ?
cx23885_dvb_unregister+0xbf/0x110 [cx23885]
Jul 13 14:20:22 HomeServer kernel: [  261.864564]  [<ffffffffc094da3f>] ?
cx23885_dev_unregister+0xdf/0x140 [cx23885]
Jul 13 14:20:22 HomeServer kernel: [  261.867835]  [<ffffffffc094dcaf>] ?
cx23885_finidev+0x4f/0x80 [cx23885]
Jul 13 14:20:22 HomeServer kernel: [  261.871091]  [<ffffffff813713c6>] ?
pci_device_remove+0x36/0xb0
Jul 13 14:20:22 HomeServer kernel: [  261.874315]  [<ffffffff814576ea>] ?
__device_release_driver+0x9a/0x150
Jul 13 14:20:22 HomeServer kernel: [  261.877493]  [<ffffffff814582ce>] ?
driver_detach+0xae/0xb0
Jul 13 14:20:22 HomeServer kernel: [  261.879501]  [<ffffffff814570c5>] ?
bus_remove_driver+0x55/0xd0
Jul 13 14:20:22 HomeServer kernel: [  261.881506]  [<ffffffff8136fb36>] ?
pci_unregister_driver+0x26/0x70
Jul 13 14:20:22 HomeServer kernel: [  261.883505]  [<ffffffff810f9e8b>] ?
SyS_delete_module+0x1ab/0x260
Jul 13 14:20:22 HomeServer kernel: [  261.885500]  [<ffffffff81003300>] ?
exit_to_usermode_loop+0xa0/0xc0
Jul 13 14:20:22 HomeServer kernel: [  261.887468]  [<ffffffff815ebb36>] ?
entry_SYSCALL_64_fastpath+0x1e/0xa8
Jul 13 14:20:22 HomeServer kernel: [  261.889446] Code: 00 00 04 55 48 89 fd
53 48 8b 9f 18 03 00 00 0f 85 82 00 00 00 83 bd 04 05 00 00 02 74 0a c7 85
04 05 00 00 01 00 00 00 0f ae f0 <48> 8b bb 00 02 00 00 48 85 ff 74 5d e8 bb
89 82 c0 48 8b 93 00 
Jul 13 14:20:22 HomeServer kernel: [  261.893638] RIP  [<ffffffffc086ecc4>]
dvb_frontend_stop+0x34/0xd0 [dvb_core]
Jul 13 14:20:22 HomeServer kernel: [  261.895720]  RSP <ffff8800d6be3d78>
Jul 13 14:20:22 HomeServer kernel: [  261.897784] CR2: 0000000000000200
Jul 13 14:20:22 HomeServer kernel: [  261.914345] ---[ end trace
8acf386d1711ef5a ]---
Jul 13 14:20:22 HomeServer kernel: [  262.043794] PM: Hibernation mode set
to 'suspend'



