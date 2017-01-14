Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:33231 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbdANNIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 14 Jan 2017 08:08:13 -0500
Received: by mail-ua0-f174.google.com with SMTP id i68so54591847uad.0
        for <linux-media@vger.kernel.org>; Sat, 14 Jan 2017 05:08:13 -0800 (PST)
MIME-Version: 1.0
From: Chris Rankin <rankincj@gmail.com>
Date: Sat, 14 Jan 2017 13:08:11 +0000
Message-ID: <CAK2bqV+OUtuQFBrSdCwXFC7kQT9cvrmOybOTtnGZnkZdhTYqLA@mail.gmail.com>
Subject: [OOPS] EM28xx with 4.9.x kernel
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This oops has appeared for my PCTV T2 290e adapter when I switched to
the 4.9.x kernel. It does not happen with the 4.8.x kernel.

I believe the problem is that "priv" is NULL in cxd2820r_gpio().

Jan 13 11:19:45 endgame kernel: em28174 #0: EEPROM ID = 26 00 01 00,
EEPROM hash = 0x1eb936d2
Jan 13 11:19:45 endgame kernel: em28174 #0: EEPROM info:
Jan 13 11:19:45 endgame kernel: em28174 #0: #011microcode start
address = 0x0004, boot configuration = 0x01
Jan 13 11:19:45 endgame kernel: em28174 #0: #011No audio on board.
Jan 13 11:19:45 endgame kernel: em28174 #0: #011500mA max power
Jan 13 11:19:45 endgame kernel: em28174 #0: #011Table at offset 0x39,
strings=0x1aa0, 0x14ba, 0x1ace
Jan 13 11:19:45 endgame kernel: em28174 #0: Identified as PCTV
nanoStick T2 290e (card=78)
Jan 13 11:19:45 endgame kernel: em28174 #0: dvb set to isoc mode.
Jan 13 11:19:45 endgame kernel: usbcore: registered new interface driver em28xx
Jan 13 11:19:45 endgame kernel: em28174 #0: Binding DVB extension
Jan 13 11:19:45 endgame kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000000000000549
Jan 13 11:19:45 endgame kernel: IP: [<ffffffff811b9a28>] memcmp+0xb/0x1d
Jan 13 11:19:47 endgame kernel: PGD 0
Jan 13 11:19:47 endgame kernel:
Jan 13 11:19:47 endgame kernel: Oops: 0000 [#1] PREEMPT SMP
Jan 13 11:19:47 endgame kernel: Modules linked in: cxd2820r
em28xx_dvb(+) dvb_core btbcm snd_rawmidi snd_hda_core joydev coretemp
btintel snd_seq kvm_intel snd_seq_device bluetooth kvm snd_pcm rfkill
snd_hrtimer em28xx tveeprom snd_timer v4l2_common videodev irqbypass
iTCO_wdt psmouse mxm_wmi pcspkr lpc_ich snd r8169 i7core_edac i2c_i801
i2c_smbus button wmi mfd_core mii edac_core acpi_cpufreq soundcore
processor binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl lockd
grace sunrpc ip_tables x_tables ext4 crc16 jbd2 mbcache sr_mod cdrom
sd_mod usbhid radeon i2c_algo_bit uhci_hcd crc32c_intel ehci_pci
drm_kms_helper serio_raw ehci_hcd ahci xhci_pci cfbfillrect
syscopyarea cfbimgblt sysfillrect sysimgblt fb_sys_fops pata_jmicron
libahci cfbcopyarea libata firewire_ohci ttm scsi_mod xhci_hcd
firewire_core crc_itu_t drm
Jan 13 11:19:47 endgame kernel: usbcore usb_common ipv6
Jan 13 11:19:47 endgame kernel: CPU: 5 PID: 639 Comm: modprobe
Tainted: G          I    4.9.2 #2
Jan 13 11:19:47 endgame kernel: Hardware name: Gigabyte Technology
Co., Ltd. EX58-UD3R/EX58-UD3R, BIOS FB  05/04/2009
Jan 13 11:19:47 endgame kernel: task: ffff8801c34acec0 task.stack:
ffffc900004f8000
Jan 13 11:19:47 endgame kernel: RIP: 0010:[<ffffffff811b9a28>]
[<ffffffff811b9a28>] memcmp+0xb/0x1d
Jan 13 11:19:47 endgame kernel: RSP: 0018:ffffc900004fb888  EFLAGS: 00010206
Jan 13 11:19:47 endgame kernel: RAX: 0000000000000001 RBX:
ffff8801c1ef2800 RCX: 0000000000000000
Jan 13 11:19:47 endgame kernel: RDX: 0000000000000003 RSI:
0000000000000549 RDI: ffffc900004fb8b9
Jan 13 11:19:47 endgame kernel: RBP: 0000000000000000 R08:
ffff8801c80fc8c0 R09: 0000000000000000
Jan 13 11:19:47 endgame kernel: R10: ffffc900004fb708 R11:
0000000000018ca0 R12: 0000000000000549
Jan 13 11:19:47 endgame kernel: R13: ffffc900004fb8b9 R14:
ffff8801c1ef2828 R15: ffffc900004fba68
Jan 13 11:19:47 endgame kernel: FS:  00007f3c74c195c0(0000)
GS:ffff8801cfd40000(0000) knlGS:0000000000000000
Jan 13 11:19:47 endgame kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jan 13 11:19:47 endgame kernel: CR2: 0000000000000549 CR3:
00000001c35a7000 CR4: 00000000000006e0
Jan 13 11:19:47 endgame kernel: Stack:
Jan 13 11:19:47 endgame kernel: ffffffffa04f344c ffff8801c1ef2800
ffff8801c4bef000 0000000000000000
Jan 13 11:19:47 endgame kernel: ffff8801c324bd64 ffffffffa04f3662
000000e1000001ed ffffffffa04f5280
Jan 13 11:19:47 endgame kernel: ffff8801c4bef020 ffff8801c4bef000
ffff8801c4bef004 ffffffffa04f3514
Jan 13 11:19:47 endgame kernel: Call Trace:
Jan 13 11:19:47 endgame kernel: [<ffffffffa04f344c>] ?
cxd2820r_gpio+0x27/0xef [cxd2820r]
Jan 13 11:19:47 endgame kernel: [<ffffffffa04f3662>] ?
cxd2820r_probe+0x14e/0x1df [cxd2820r]
Jan 13 11:19:47 endgame kernel: [<ffffffffa04f3514>] ?
cxd2820r_gpio+0xef/0xef [cxd2820r]
Jan 13 11:19:47 endgame kernel: [<ffffffff8128ebda>] ?
i2c_device_probe+0xc6/0xfa
Jan 13 11:19:47 endgame kernel: [<ffffffff8126946e>] ?
driver_probe_device+0x10b/0x249
Jan 13 11:19:47 endgame kernel: [<ffffffff81269655>] ?
driver_allows_async_probing+0x24/0x24
Jan 13 11:19:47 endgame kernel: [<ffffffff81267e19>] ?
bus_for_each_drv+0x6c/0x7b
Jan 13 11:19:47 endgame kernel: [<ffffffff812692ec>] ? __device_attach+0x96/0xf5
Jan 13 11:19:47 endgame kernel: [<ffffffff81268a04>] ?
bus_probe_device+0x28/0x84
Jan 13 11:19:47 endgame kernel: [<ffffffff8126709a>] ? device_add+0x2ad/0x51e
Jan 13 11:19:47 endgame kernel: [<ffffffff813618dd>] ?
_raw_spin_unlock_irqrestore+0xf/0x20
Jan 13 11:19:47 endgame kernel: [<ffffffff81290b49>] ?
i2c_new_device+0x172/0x1c9
Jan 13 11:19:47 endgame kernel: [<ffffffffa04f313e>] ?
cxd2820r_attach+0x8a/0xc0 [cxd2820r]
Jan 13 11:19:47 endgame kernel: [<ffffffffa058d461>] ?
em28xx_dvb_init.part.3+0xa01/0x2d20 [em28xx_dvb]
Jan 13 11:19:47 endgame kernel: [<ffffffff8105761d>] ?
check_preempt_curr+0x41/0x5e
Jan 13 11:19:47 endgame kernel: [<ffffffff81057647>] ? ttwu_do_wakeup+0xd/0x81
Jan 13 11:19:47 endgame kernel: [<ffffffff813618dd>] ?
_raw_spin_unlock_irqrestore+0xf/0x20
Jan 13 11:19:47 endgame kernel: [<ffffffff8105831c>] ?
try_to_wake_up+0x1f7/0x208
Jan 13 11:19:47 endgame kernel: [<ffffffff81069b2e>] ?
__wake_up_common+0x47/0x73
Jan 13 11:19:47 endgame kernel: [<ffffffff813618dd>] ?
_raw_spin_unlock_irqrestore+0xf/0x20
Jan 13 11:19:47 endgame kernel: [<ffffffff811424cb>] ?
ep_poll_callback+0x151/0x17a
Jan 13 11:19:47 endgame kernel: [<ffffffff81069b2e>] ?
__wake_up_common+0x47/0x73
Jan 13 11:19:47 endgame kernel: [<ffffffff81056343>] ?
preempt_count_add+0x72/0x91
Jan 13 11:19:47 endgame kernel: [<ffffffff8135fdc5>] ?
__mutex_lock_slowpath+0x277/0x29c
Jan 13 11:19:47 endgame kernel: [<ffffffffa052007a>] ?
em28xx_register_extension+0x51/0x82 [em28xx]
Jan 13 11:19:47 endgame kernel: [<ffffffffa007d000>] ? 0xffffffffa007d000
Jan 13 11:19:47 endgame kernel: [<ffffffff81000440>] ?
do_one_initcall+0x93/0x124
Jan 13 11:19:47 endgame kernel: [<ffffffff810c0b36>] ? do_init_module+0x51/0x1d3
Jan 13 11:19:47 endgame kernel: [<ffffffff81096b5a>] ? load_module+0x19ef/0x1f1d
Jan 13 11:19:47 endgame kernel: [<ffffffff8110dd2c>] ? __vfs_read+0xc6/0xe9
Jan 13 11:19:47 endgame kernel: [<ffffffff81093db5>] ? show_coresize+0x1c/0x1c
Jan 13 11:19:47 endgame kernel: [<ffffffff810971e2>] ?
SyS_finit_module+0x78/0x83
Jan 13 11:19:47 endgame kernel: [<ffffffff810971e2>] ?
SyS_finit_module+0x78/0x83
Jan 13 11:19:47 endgame kernel: [<ffffffff810011ae>] ? do_syscall_64+0x49/0x98
Jan 13 11:19:47 endgame kernel: [<ffffffff81361d86>] ?
entry_SYSCALL64_slow_path+0x25/0x25
Jan 13 11:19:47 endgame kernel: Code: 8b 3c c1 48 85 ff 74 10 4c 89 d6
e8 03 fe ff ff 85 c0 74 09 ff c1 eb df b9 ea ff ff ff 89 c8 c3 31 c9
48 39 ca 74 13 0f b6 04 0f <44> 0f b6 04 0e 48 ff c1 44 29 c0 74 ea eb
02 31 c0 c3 48 01 fa
Jan 13 11:19:47 endgame kernel: RIP  [<ffffffff811b9a28>] memcmp+0xb/0x1d
Jan 13 11:19:47 endgame kernel: RSP <ffffc900004fb888>
Jan 13 11:19:48 endgame kernel: CR2: 0000000000000549
Jan 13 11:19:48 endgame kernel: ---[ end trace 2104ca820a3ff414 ]---

Cheers,
Chris
