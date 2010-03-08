Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:63723 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0CHT1M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Mar 2010 14:27:12 -0500
Received: by fxm19 with SMTP id 19so6691712fxm.21
        for <linux-media@vger.kernel.org>; Mon, 08 Mar 2010 11:27:10 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 8 Mar 2010 20:27:09 +0100
Message-ID: <bcb3ef431003081127y43d6d785jdc34e845fa07e746@mail.gmail.com>
Subject: s2-liplianin, mantis: sysfs: cannot create duplicate filename
	'/devices/virtual/irrcv'
From: MartinG <gronslet@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I'm using a Terratec Cinergy C HD PCI (Mantis VP-2040) using the
mantis driver from s2-liplianin:

changeset:   14355:4dc29dc9ec91
tag:         tip
user:        Igor M. Liplianin <liplianin@me.by>
date:        Sat Feb 27 10:18:52 2010 +0200

My kernel is:
2.6.30.10-105.2.23.fc11.x86_64

If I remove and reload the module, dmesg reports some conflicting
filenames, see output below.
I guess this has something to do with the IR module. Any more info I
can provide to get this fixed? Or have I configured things wrong?

best,
MartinG

------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xd9/0xf3() (Tainted: G        W )
Hardware name: P5E-VM HDMI
sysfs: cannot create duplicate filename '/devices/virtual/irrcv'
Modules linked in: mantis(+) lnbp21 mb86a16 ir_common stb6100 tda10021
tda10023 stb0899 stv0299 dvb_core ir_core fuse sha256_generic cryptd
aes_x86_64 aes_generic cbc dm_crypt nfs fscache nfsd sco nfs_acl
auth_rpcgss bridge stp llc bnep exportfs l2cap bluetooth lockd sunrpc
autofs4 w83627ehf hwmon_vid coretemp ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq
freq_table jfs dm_multipath lirc_serial uinput snd_hda_codec_intelhdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec firewire_ohci atl1
snd_seq snd_usb_audio snd_usb_lib snd_rawmidi lirc_imon iTCO_wdt
uvcvideo videodev v4l1_compat mii lirc_dev serio_raw pcspkr
iTCO_vendor_support snd_hwdep snd_seq_device v4l2_compat_ioctl32
firewire_core pata_jmicron i2c_i801 asus_atk0110 snd_pcm snd_timer snd
soundcore snd_page_alloc crc_itu_t hwmon ata_generic pata_acpi i915
drm i2c_algo_bit video output i2c_core [last unloaded: ir_core]
Pid: 5399, comm: work_for_cpu Tainted: G        W
2.6.30.10-105.2.23.fc11.x86_64 #1
Call Trace:
 [<ffffffff81049509>] warn_slowpath_common+0x84/0x9c
 [<ffffffff81049578>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff8113558f>] sysfs_add_one+0xd9/0xf3
 [<ffffffff81135606>] create_dir+0x5d/0x8d
 [<ffffffff81135673>] sysfs_create_dir+0x3d/0x50
 [<ffffffff811c9432>] kobject_add_internal+0x116/0x1f3
 [<ffffffff811c95e5>] kobject_add_varg+0x41/0x50
 [<ffffffff811c96af>] kobject_add+0x64/0x66
 [<ffffffff811c8f38>] ? kobject_init+0x43/0x83
 [<ffffffff8126f141>] get_device_parent+0x11e/0x14a
 [<ffffffff8127007c>] device_add+0x100/0x599
 [<ffffffff811d0a2f>] ? kvasprintf+0x5e/0x6e
 [<ffffffff81270533>] device_register+0x1e/0x23
 [<ffffffff812705f7>] device_create_vargs+0xbf/0xf0
 [<ffffffff81270659>] device_create+0x31/0x33
 [<ffffffffa001083a>] ir_register_class+0x62/0xc5 [ir_core]
 [<ffffffffa0010309>] ir_input_register+0x1fb/0x249 [ir_core]
 [<ffffffffa0518ca9>] mantis_rc_init+0x173/0x1c8 [mantis]
 [<ffffffffa05192d7>] mantis_core_init+0x2f8/0x35d [mantis]
 [<ffffffffa051961a>] mantis_pci_probe+0x2b9/0x3d4 [mantis]
 [<ffffffff811ddb31>] local_pci_probe+0x17/0x1b
 [<ffffffff81059d30>] do_work_for_cpu+0x18/0x2a
 [<ffffffff81059d18>] ? do_work_for_cpu+0x0/0x2a
 [<ffffffff8105d330>] kthread+0x5a/0x85
 [<ffffffff81011d4a>] child_rip+0xa/0x20
 [<ffffffff8105d2d6>] ? kthread+0x0/0x85
 [<ffffffff81011d40>] ? child_rip+0x0/0x20
---[ end trace dc78e456fbecab73 ]---
kobject_add_internal failed for irrcv with -EEXIST, don't try to
register things with the same name in the same directory.
Pid: 5399, comm: work_for_cpu Tainted: G        W
2.6.30.10-105.2.23.fc11.x86_64 #1
Call Trace:
 [<ffffffff811c94c3>] kobject_add_internal+0x1a7/0x1f3
 [<ffffffff811c95e5>] kobject_add_varg+0x41/0x50
 [<ffffffff811c96af>] kobject_add+0x64/0x66
 [<ffffffff811c8f38>] ? kobject_init+0x43/0x83
 [<ffffffff8126f141>] get_device_parent+0x11e/0x14a
 [<ffffffff8127007c>] device_add+0x100/0x599
 [<ffffffff811d0a2f>] ? kvasprintf+0x5e/0x6e
 [<ffffffff81270533>] device_register+0x1e/0x23
 [<ffffffff812705f7>] device_create_vargs+0xbf/0xf0
 [<ffffffff81270659>] device_create+0x31/0x33
 [<ffffffffa001083a>] ir_register_class+0x62/0xc5 [ir_core]
 [<ffffffffa0010309>] ir_input_register+0x1fb/0x249 [ir_core]
 [<ffffffffa0518ca9>] mantis_rc_init+0x173/0x1c8 [mantis]
 [<ffffffffa05192d7>] mantis_core_init+0x2f8/0x35d [mantis]
 [<ffffffffa051961a>] mantis_pci_probe+0x2b9/0x3d4 [mantis]
 [<ffffffff811ddb31>] local_pci_probe+0x17/0x1b
 [<ffffffff81059d30>] do_work_for_cpu+0x18/0x2a
 [<ffffffff81059d18>] ? do_work_for_cpu+0x0/0x2a
 [<ffffffff8105d330>] kthread+0x5a/0x85
 [<ffffffff81011d4a>] child_rip+0xa/0x20
 [<ffffffff8105d2d6>] ? kthread+0x0/0x85
 [<ffffffff81011d40>] ? child_rip+0x0/0x20
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xd9/0xf3() (Tainted: G        W )
Hardware name: P5E-VM HDMI
sysfs: cannot create duplicate filename '/devices/irrcv0'
Modules linked in: mantis(+) lnbp21 mb86a16 ir_common stb6100 tda10021
tda10023 stb0899 stv0299 dvb_core ir_core fuse sha256_generic cryptd
aes_x86_64 aes_generic cbc dm_crypt nfs fscache nfsd sco nfs_acl
auth_rpcgss bridge stp llc bnep exportfs l2cap bluetooth lockd sunrpc
autofs4 w83627ehf hwmon_vid coretemp ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq
freq_table jfs dm_multipath lirc_serial uinput snd_hda_codec_intelhdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec firewire_ohci atl1
snd_seq snd_usb_audio snd_usb_lib snd_rawmidi lirc_imon iTCO_wdt
uvcvideo videodev v4l1_compat mii lirc_dev serio_raw pcspkr
iTCO_vendor_support snd_hwdep snd_seq_device v4l2_compat_ioctl32
firewire_core pata_jmicron i2c_i801 asus_atk0110 snd_pcm snd_timer snd
soundcore snd_page_alloc crc_itu_t hwmon ata_generic pata_acpi i915
drm i2c_algo_bit video output i2c_core [last unloaded: ir_core]
Pid: 5399, comm: work_for_cpu Tainted: G        W
2.6.30.10-105.2.23.fc11.x86_64 #1
Call Trace:
 [<ffffffff81049509>] warn_slowpath_common+0x84/0x9c
 [<ffffffff81049578>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff8113558f>] sysfs_add_one+0xd9/0xf3
 [<ffffffff81135606>] create_dir+0x5d/0x8d
 [<ffffffff81135673>] sysfs_create_dir+0x3d/0x50
 [<ffffffff811c9432>] kobject_add_internal+0x116/0x1f3
 [<ffffffff811c95e5>] kobject_add_varg+0x41/0x50
 [<ffffffff811c96af>] kobject_add+0x64/0x66
 [<ffffffff8126f152>] ? get_device_parent+0x12f/0x14a
 [<ffffffff812700ab>] device_add+0x12f/0x599
 [<ffffffff811d0a2f>] ? kvasprintf+0x5e/0x6e
 [<ffffffff81270533>] device_register+0x1e/0x23
 [<ffffffff812705f7>] device_create_vargs+0xbf/0xf0
 [<ffffffff81270659>] device_create+0x31/0x33
 [<ffffffffa001083a>] ir_register_class+0x62/0xc5 [ir_core]
 [<ffffffffa0010309>] ir_input_register+0x1fb/0x249 [ir_core]
 [<ffffffffa0518ca9>] mantis_rc_init+0x173/0x1c8 [mantis]
 [<ffffffffa05192d7>] mantis_core_init+0x2f8/0x35d [mantis]
 [<ffffffffa051961a>] mantis_pci_probe+0x2b9/0x3d4 [mantis]
 [<ffffffff811ddb31>] local_pci_probe+0x17/0x1b
 [<ffffffff81059d30>] do_work_for_cpu+0x18/0x2a
 [<ffffffff81059d18>] ? do_work_for_cpu+0x0/0x2a
 [<ffffffff8105d330>] kthread+0x5a/0x85
 [<ffffffff81011d4a>] child_rip+0xa/0x20
 [<ffffffff8105d2d6>] ? kthread+0x0/0x85
 [<ffffffff81011d40>] ? child_rip+0x0/0x20
---[ end trace dc78e456fbecab74 ]---
kobject_add_internal failed for irrcv0 with -EEXIST, don't try to
register things with the same name in the same directory.
Pid: 5399, comm: work_for_cpu Tainted: G        W
2.6.30.10-105.2.23.fc11.x86_64 #1
Call Trace:
 [<ffffffff811c94c3>] kobject_add_internal+0x1a7/0x1f3
 [<ffffffff811c95e5>] kobject_add_varg+0x41/0x50
 [<ffffffff811c96af>] kobject_add+0x64/0x66
 [<ffffffff8126f152>] ? get_device_parent+0x12f/0x14a
 [<ffffffff812700ab>] device_add+0x12f/0x599
 [<ffffffff811d0a2f>] ? kvasprintf+0x5e/0x6e
 [<ffffffff81270533>] device_register+0x1e/0x23
 [<ffffffff812705f7>] device_create_vargs+0xbf/0xf0
 [<ffffffff81270659>] device_create+0x31/0x33
 [<ffffffffa001083a>] ir_register_class+0x62/0xc5 [ir_core]
 [<ffffffffa0010309>] ir_input_register+0x1fb/0x249 [ir_core]
 [<ffffffffa0518ca9>] mantis_rc_init+0x173/0x1c8 [mantis]
 [<ffffffffa05192d7>] mantis_core_init+0x2f8/0x35d [mantis]
 [<ffffffffa051961a>] mantis_pci_probe+0x2b9/0x3d4 [mantis]
 [<ffffffff811ddb31>] local_pci_probe+0x17/0x1b
 [<ffffffff81059d30>] do_work_for_cpu+0x18/0x2a
 [<ffffffff81059d18>] ? do_work_for_cpu+0x0/0x2a
 [<ffffffff8105d330>] kthread+0x5a/0x85
 [<ffffffff81011d4a>] child_rip+0xa/0x20
 [<ffffffff8105d2d6>] ? kthread+0x0/0x85
 [<ffffffff81011d40>] ? child_rip+0x0/0x20
BUG: unable to handle kernel paging request at ffffffffffffffff
IP: [<ffffffffa001083f>] ir_register_class+0x67/0xc5 [ir_core]
PGD 203067 PUD 204067 PMD 0
Oops: 0000 [#1] SMP
last sysfs file:
/sys/devices/pci0000:00/0000:00:1e.0/0000:04:00.0/dvb/dvb0.ca0/dev
CPU 0
Modules linked in: mantis(+) lnbp21 mb86a16 ir_common stb6100 tda10021
tda10023 stb0899 stv0299 dvb_core ir_core fuse sha256_generic cryptd
aes_x86_64 aes_generic cbc dm_crypt nfs fscache nfsd sco nfs_acl
auth_rpcgss bridge stp llc bnep exportfs l2cap bluetooth lockd sunrpc
autofs4 w83627ehf hwmon_vid coretemp ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq
freq_table jfs dm_multipath lirc_serial uinput snd_hda_codec_intelhdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec firewire_ohci atl1
snd_seq snd_usb_audio snd_usb_lib snd_rawmidi lirc_imon iTCO_wdt
uvcvideo videodev v4l1_compat mii lirc_dev serio_raw pcspkr
iTCO_vendor_support snd_hwdep snd_seq_device v4l2_compat_ioctl32
firewire_core pata_jmicron i2c_i801 asus_atk0110 snd_pcm snd_timer snd
soundcore snd_page_alloc crc_itu_t hwmon ata_generic pata_acpi i915
drm i2c_algo_bit video output i2c_core [last unloaded: ir_core]
Pid: 5399, comm: work_for_cpu Tainted: G        W
2.6.30.10-105.2.23.fc11.x86_64 #1 P5E-VM HDMI
RIP: 0010:[<ffffffffa001083f>]  [<ffffffffa001083f>]
ir_register_class+0x67/0xc5 [ir_core]
RSP: 0018:ffff88010397fda0  EFLAGS: 00010282
RAX: ffffffffffffffef RBX: 0000000000000000 RCX: ffff8801188cd730
RDX: 0000000000000000 RSI: ffff88010397fce0 RDI: ffff88010397fc60
RBP: ffff88010397fdc0 R08: ffffffff81847d70 R09: 0000000000000001
R10: ffff88010397fba0 R11: ffff88002f05f360 R12: ffff8800cc0747e0
R13: ffff88011cac4000 R14: 0000000000000030 R15: ffffffffa021d1a0
FS:  0000000000000000(0000) GS:ffff880028022000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: ffffffffffffffff CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process work_for_cpu (pid: 5399, threadinfo ffff88010397e000, task
ffff880112dc9700)
Stack:
 ffff8800cc0747e0 ffffffffa0219290 ffff88011cac4000 0000000000000030
 ffff88010397fe10 ffffffffa0010309 ffff88010397fde0 ffff88011cac4000
 ffff88010397fe10 ffff88011ca40000 ffff88011cac4000 ffff88011ca40888
Call Trace:
 [<ffffffffa0010309>] ir_input_register+0x1fb/0x249 [ir_core]
 [<ffffffffa0518ca9>] mantis_rc_init+0x173/0x1c8 [mantis]
 [<ffffffffa05192d7>] mantis_core_init+0x2f8/0x35d [mantis]
 [<ffffffffa051961a>] mantis_pci_probe+0x2b9/0x3d4 [mantis]
 [<ffffffff811ddb31>] local_pci_probe+0x17/0x1b
 [<ffffffff81059d30>] do_work_for_cpu+0x18/0x2a
 [<ffffffff81059d18>] ? do_work_for_cpu+0x0/0x2a
 [<ffffffff8105d330>] kthread+0x5a/0x85
 [<ffffffff81011d4a>] child_rip+0xa/0x20
 [<ffffffff8105d2d6>] ? kthread+0x0/0x85
 [<ffffffff81011d40>] ? child_rip+0x0/0x20
Code: 01 a0 41 8b 95 30 08 00 00 41 89 c1 48 8b 3d 89 16 00 00 49 c7
c0 16 0d 01 a0 4c 89 e1 31 f6 31 c0 e8 ee fd 25 e1 49 89 44 24 48 <48>
8b 70 10 49 89 c6 48 c7 c7 1e 0d 01 a0 31 c0 e8 01 83 3c e1
RIP  [<ffffffffa001083f>] ir_register_class+0x67/0xc5 [ir_core]
 RSP <ffff88010397fda0>
CR2: ffffffffffffffff
---[ end trace dc78e456fbecab75 ]---
