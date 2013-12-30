Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40611 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3L3OD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 09:03:57 -0500
Received: by mail-ee0-f53.google.com with SMTP id b57so5017995eek.26
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 06:03:56 -0800 (PST)
Message-ID: <52C17D8C.3070308@googlemail.com>
Date: Mon, 30 Dec 2013 15:05:00 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [BUG] em28xx oops when closing a diconnected device
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I just noticed the following em28xx bug:


Steps to reproduce:
1) open device with qv4l2
2) start streaming
3) unplugg the device
4) close qv4l2


Result:


[19188.227756] ------------[ cut here ]------------
[19188.227766] WARNING: CPU: 0 PID: 12773 at fs/sysfs/group.c:214
sysfs_remove_group+0xc9/0xd0()
[19188.227769] sysfs group c0a10100 not found for kobject 'vbi1'
[19188.227771] Modules linked in: tuner_xc2028(O) em28xx_rc zl10353
em28xx_dvb dvb_core snd_usb_audio snd_usbmidi_lib snd_rawmidi tvp5150
em28xx videobuf2_core videobuf2_vmalloc videobuf2_memops xt_tcpudp
xt_pkttype af_packet xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
ip6table_filter ip6_tables x_tables fuse arc4 rtl8187 mac80211
snd_hda_codec_hdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec
rc_hauppauge ir_kbd_i2c snd_hwdep cfg80211 tuner_simple tuner_types
snd_pcm tda9887 tda8290 rfkill usb_storage snd_seq usblp tuner msp3400
eeprom_93cx6 bttv snd_timer snd_seq_device v4l2_common videodev snd
videobuf_dma_sg videobuf_core firewire_ohci sg btcx_risc firewire_core
sr_mod cdrom soundcore snd_page_alloc rc_core tveeprom forcedeth k8temp
serio_raw shpchp crc_itu_t i2c_nforce2 powernow_k8 pcspkr kvm_amd kvm
ppdev parport_pc parport floppy asus_atk0110 button autofs4 radeon ttm
drm_kms_helper drm i2c_algo_bit thermal fan processor thermal_sys
scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh ata_generic
pata_amd pata_jmicron sata_nv [last unloaded: tuner_xc2028]
[19188.227858] CPU: 0 PID: 12773 Comm: qv4l2 Tainted: G           O
3.13.0-rc5-0.1-desktop+ #58
[19188.227861] Hardware name: System manufacturer System Product
Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
[19188.227863]  00000000 00000000 d876be38 c077957b d876be78 d876be68
c02401bf c092ae20
[19188.227871]  d876be94 000031e5 c0934ca6 000000d6 c03afec9 c03afec9
00000000 c0a10100
[19188.227877]  d853d80c d876be80 c024025e 00000009 d876be78 c092ae20
d876be94 d876bea8
[19188.227883] Call Trace:
[19188.227890]  [<c077957b>] dump_stack+0x48/0x69
[19188.227895]  [<c02401bf>] warn_slowpath_common+0x7f/0xa0
[19188.227900]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.227904]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.227908]  [<c024025e>] warn_slowpath_fmt+0x2e/0x30
[19188.227912]  [<c03afec9>] sysfs_remove_group+0xc9/0xd0
[19188.227918]  [<c059c26d>] dpm_sysfs_remove+0x2d/0x30
[19188.227922]  [<c0593fec>] device_del+0x2c/0x150
[19188.227926]  [<c059412c>] device_unregister+0x1c/0x60
[19188.227929]  [<c07761ea>] ? printk+0x48/0x4a
[19188.227943]  [<f95126e8>] video_unregister_device+0x38/0x40 [videodev]
[19188.227952]  [<f9bf28a4>] em28xx_release_analog_resources+0xc4/0x100
[em28xx]
[19188.227959]  [<f9bf572b>] em28xx_release_resources+0xb/0x70 [em28xx]
[19188.227964]  [<f9bf0c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
[19188.227974]  [<f951302e>] v4l2_release+0x2e/0x70 [videodev]
[19188.227980]  [<c034df1b>] __fput+0xab/0x1d0
[19188.227984]  [<c034e078>] ____fput+0x8/0x10
[19188.227989]  [<c025a6e9>] task_work_run+0x79/0x90
[19188.227994]  [<c0202141>] do_notify_resume+0x51/0x80
[19188.227998]  [<c077fd1b>] work_notifysig+0x24/0x29
[19188.228028] ---[ end trace e8fa0efd13bec3a1 ]---
[19188.228132] em2882/3 #0: V4L2 device video1 deregistered
[19188.228142] ------------[ cut here ]------------
[19188.228155] WARNING: CPU: 0 PID: 12773 at fs/sysfs/group.c:214
sysfs_remove_group+0xc9/0xd0()
[19188.228165] sysfs group c0a10100 not found for kobject 'video1'
[19188.228175] Modules linked in: tuner_xc2028(O) em28xx_rc zl10353
em28xx_dvb dvb_core snd_usb_audio snd_usbmidi_lib snd_rawmidi tvp5150
em28xx videobuf2_core videobuf2_vmalloc videobuf2_memops xt_tcpudp
xt_pkttype af_packet xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
ip6table_filter ip6_tables x_tables fuse arc4 rtl8187 mac80211
snd_hda_codec_hdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec
rc_hauppauge ir_kbd_i2c snd_hwdep cfg80211 tuner_simple tuner_types
snd_pcm tda9887 tda8290 rfkill usb_storage snd_seq usblp tuner msp3400
eeprom_93cx6 bttv snd_timer snd_seq_device v4l2_common videodev snd
videobuf_dma_sg videobuf_core firewire_ohci sg btcx_risc firewire_core
sr_mod cdrom soundcore snd_page_alloc rc_core tveeprom forcedeth k8temp
serio_raw shpchp crc_itu_t i2c_nforce2 powernow_k8 pcspkr kvm_amd kvm
ppdev parport_pc parport floppy asus_atk0110 button autofs4 radeon ttm
drm_kms_helper drm i2c_algo_bit thermal fan processor thermal_sys
scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh ata_generic
pata_amd pata_jmicron sata_nv [last unloaded: tuner_xc2028]
[19188.228250] CPU: 0 PID: 12773 Comm: qv4l2 Tainted: G        W  O
3.13.0-rc5-0.1-desktop+ #58
[19188.228253] Hardware name: System manufacturer System Product
Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
[19188.228255]  00000000 00000000 d876be38 c077957b d876be78 d876be68
c02401bf c092ae20
[19188.228261]  d876be94 000031e5 c0934ca6 000000d6 c03afec9 c03afec9
00000000 c0a10100
[19188.228266]  d9f9f40c d876be80 c024025e 00000009 d876be78 c092ae20
d876be94 d876bea8
[19188.228272] Call Trace:
[19188.228286]  [<c077957b>] dump_stack+0x48/0x69
[19188.228297]  [<c02401bf>] warn_slowpath_common+0x7f/0xa0
[19188.228302]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.228306]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.228310]  [<c024025e>] warn_slowpath_fmt+0x2e/0x30
[19188.228314]  [<c03afec9>] sysfs_remove_group+0xc9/0xd0
[19188.228318]  [<c059c26d>] dpm_sysfs_remove+0x2d/0x30
[19188.228322]  [<c0593fec>] device_del+0x2c/0x150
[19188.228332]  [<c059412c>] device_unregister+0x1c/0x60
[19188.228342]  [<c07761ea>] ? printk+0x48/0x4a
[19188.228353]  [<f95126e8>] video_unregister_device+0x38/0x40 [videodev]
[19188.228359]  [<f9bf2867>] em28xx_release_analog_resources+0x87/0x100
[em28xx]
[19188.228366]  [<f9bf572b>] em28xx_release_resources+0xb/0x70 [em28xx]
[19188.228378]  [<f9bf0c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
[19188.228388]  [<f951302e>] v4l2_release+0x2e/0x70 [videodev]
[19188.228397]  [<c034df1b>] __fput+0xab/0x1d0
[19188.228401]  [<c034e078>] ____fput+0x8/0x10
[19188.228410]  [<c025a6e9>] task_work_run+0x79/0x90
[19188.228413]  [<c0202141>] do_notify_resume+0x51/0x80
[19188.228421]  [<c077fd1b>] work_notifysig+0x24/0x29
[19188.228424] ---[ end trace e8fa0efd13bec3a2 ]---
[19188.228460] ------------[ cut here ]------------
[19188.228465] WARNING: CPU: 0 PID: 12773 at fs/sysfs/group.c:214
sysfs_remove_group+0xc9/0xd0()
[19188.228468] sysfs group c0a10100 not found for kobject '10-005c'
[19188.228469] Modules linked in: tuner_xc2028(O) em28xx_rc zl10353
em28xx_dvb dvb_core snd_usb_audio snd_usbmidi_lib snd_rawmidi tvp5150
em28xx videobuf2_core videobuf2_vmalloc videobuf2_memops xt_tcpudp
xt_pkttype af_packet xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
ip6table_filter ip6_tables x_tables fuse arc4 rtl8187 mac80211
snd_hda_codec_hdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec
rc_hauppauge ir_kbd_i2c snd_hwdep cfg80211 tuner_simple tuner_types
snd_pcm tda9887 tda8290 rfkill usb_storage snd_seq usblp tuner msp3400
eeprom_93cx6 bttv snd_timer snd_seq_device v4l2_common videodev snd
videobuf_dma_sg videobuf_core firewire_ohci sg btcx_risc firewire_core
sr_mod cdrom soundcore snd_page_alloc rc_core tveeprom forcedeth k8temp
serio_raw shpchp crc_itu_t i2c_nforce2 powernow_k8 pcspkr kvm_amd kvm
ppdev parport_pc parport floppy asus_atk0110 button autofs4 radeon ttm
drm_kms_helper drm i2c_algo_bit thermal fan processor thermal_sys
scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh ata_generic
pata_amd pata_jmicron sata_nv [last unloaded: tuner_xc2028]
[19188.228534] CPU: 0 PID: 12773 Comm: qv4l2 Tainted: G        W  O
3.13.0-rc5-0.1-desktop+ #58
[19188.228536] Hardware name: System manufacturer System Product
Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
[19188.228538]  00000000 00000000 d876bde8 c077957b d876be28 d876be18
c02401bf c092ae20
[19188.228544]  d876be44 000031e5 c0934ca6 000000d6 c03afec9 c03afec9
00000000 c0a10100
[19188.228550]  d8e00624 d876be30 c024025e 00000009 d876be28 c092ae20
d876be44 d876be58
[19188.228555] Call Trace:
[19188.228559]  [<c077957b>] dump_stack+0x48/0x69
[19188.228563]  [<c02401bf>] warn_slowpath_common+0x7f/0xa0
[19188.228568]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.228572]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.228576]  [<c024025e>] warn_slowpath_fmt+0x2e/0x30
[19188.228580]  [<c03afec9>] sysfs_remove_group+0xc9/0xd0
[19188.228584]  [<c059c26d>] dpm_sysfs_remove+0x2d/0x30
[19188.228587]  [<c0593fec>] device_del+0x2c/0x150
[19188.228592]  [<c064b7d0>] ? __unregister_dummy+0x30/0x30
[19188.228595]  [<c059412c>] device_unregister+0x1c/0x60
[19188.228599]  [<c064b4eb>] i2c_unregister_device+0xb/0x10
[19188.228603]  [<c064b803>] __unregister_client+0x33/0x40
[19188.228606]  [<c05935fc>] device_for_each_child+0x2c/0x60
[19188.228610]  [<c064ca88>] i2c_del_adapter+0x158/0x2c0
[19188.228614]  [<c064b790>] ? __process_removed_driver+0x30/0x30
[19188.228617]  [<c07761ea>] ? printk+0x48/0x4a
[19188.228625]  [<f9bf42b7>] em28xx_i2c_unregister+0x17/0x30 [em28xx]
[19188.228631]  [<f9bf573e>] em28xx_release_resources+0x1e/0x70 [em28xx]
[19188.228636]  [<f9bf0c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
[19188.228647]  [<f951302e>] v4l2_release+0x2e/0x70 [videodev]
[19188.228651]  [<c034df1b>] __fput+0xab/0x1d0
[19188.228656]  [<c034e078>] ____fput+0x8/0x10
[19188.228660]  [<c025a6e9>] task_work_run+0x79/0x90
[19188.228663]  [<c0202141>] do_notify_resume+0x51/0x80
[19188.228667]  [<c077fd1b>] work_notifysig+0x24/0x29
[19188.228670] ---[ end trace e8fa0efd13bec3a3 ]---
[19188.228695] ------------[ cut here ]------------
[19188.228700] WARNING: CPU: 0 PID: 12773 at fs/sysfs/group.c:214
sysfs_remove_group+0xc9/0xd0()
[19188.228702] sysfs group c0a10100 not found for kobject '10-0061'
[19188.228704] Modules linked in: tuner_xc2028(O) em28xx_rc zl10353
em28xx_dvb dvb_core snd_usb_audio snd_usbmidi_lib snd_rawmidi tvp5150
em28xx videobuf2_core videobuf2_vmalloc videobuf2_memops xt_tcpudp
xt_pkttype af_packet xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
ip6table_filter ip6_tables x_tables fuse arc4 rtl8187 mac80211
snd_hda_codec_hdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec
rc_hauppauge ir_kbd_i2c snd_hwdep cfg80211 tuner_simple tuner_types
snd_pcm tda9887 tda8290 rfkill usb_storage snd_seq usblp tuner msp3400
eeprom_93cx6 bttv snd_timer snd_seq_device v4l2_common videodev snd
videobuf_dma_sg videobuf_core firewire_ohci sg btcx_risc firewire_core
sr_mod cdrom soundcore snd_page_alloc rc_core tveeprom forcedeth k8temp
serio_raw shpchp crc_itu_t i2c_nforce2 powernow_k8 pcspkr kvm_amd kvm
ppdev parport_pc parport floppy asus_atk0110 button autofs4 radeon ttm
drm_kms_helper drm i2c_algo_bit thermal fan processor thermal_sys
scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh ata_generic
pata_amd pata_jmicron sata_nv [last unloaded: tuner_xc2028]
[19188.228768] CPU: 0 PID: 12773 Comm: qv4l2 Tainted: G        W  O
3.13.0-rc5-0.1-desktop+ #58
[19188.228770] Hardware name: System manufacturer System Product
Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
[19188.228772]  00000000 00000000 d876bde8 c077957b d876be28 d876be18
c02401bf c092ae20
[19188.228778]  d876be44 000031e5 c0934ca6 000000d6 c03afec9 c03afec9
00000000 c0a10100
[19188.228783]  f6aeac24 d876be30 c024025e 00000009 d876be28 c092ae20
d876be44 d876be58
[19188.228789] Call Trace:
[19188.228793]  [<c077957b>] dump_stack+0x48/0x69
[19188.228797]  [<c02401bf>] warn_slowpath_common+0x7f/0xa0
[19188.228801]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.228805]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.228809]  [<c024025e>] warn_slowpath_fmt+0x2e/0x30
[19188.228813]  [<c03afec9>] sysfs_remove_group+0xc9/0xd0
[19188.228817]  [<c059c26d>] dpm_sysfs_remove+0x2d/0x30
[19188.228820]  [<c0593fec>] device_del+0x2c/0x150
[19188.228824]  [<c064b7d0>] ? __unregister_dummy+0x30/0x30
[19188.228828]  [<c059412c>] device_unregister+0x1c/0x60
[19188.228831]  [<c059333f>] ? put_device+0xf/0x20
[19188.228834]  [<c059335b>] ? klist_children_put+0xb/0x10
[19188.228838]  [<c064b4eb>] i2c_unregister_device+0xb/0x10
[19188.228841]  [<c064b803>] __unregister_client+0x33/0x40
[19188.228845]  [<c05935fc>] device_for_each_child+0x2c/0x60
[19188.228849]  [<c064ca88>] i2c_del_adapter+0x158/0x2c0
[19188.228853]  [<c064b790>] ? __process_removed_driver+0x30/0x30
[19188.228856]  [<c07761ea>] ? printk+0x48/0x4a
[19188.228863]  [<f9bf42b7>] em28xx_i2c_unregister+0x17/0x30 [em28xx]
[19188.228868]  [<f9bf573e>] em28xx_release_resources+0x1e/0x70 [em28xx]
[19188.228873]  [<f9bf0c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
[19188.228884]  [<f951302e>] v4l2_release+0x2e/0x70 [videodev]
[19188.228890]  [<c034df1b>] __fput+0xab/0x1d0
[19188.228894]  [<c034e078>] ____fput+0x8/0x10
[19188.228910]  [<c025a6e9>] task_work_run+0x79/0x90
[19188.228913]  [<c0202141>] do_notify_resume+0x51/0x80
[19188.228915]  [<c077fd1b>] work_notifysig+0x24/0x29
[19188.228917] ---[ end trace e8fa0efd13bec3a4 ]---
[19188.228930] xc2028 10-0061: destroying instance
[19188.228945] ------------[ cut here ]------------
[19188.228948] WARNING: CPU: 0 PID: 12773 at fs/sysfs/group.c:214
sysfs_remove_group+0xc9/0xd0()
[19188.228949] sysfs group c0a10100 not found for kobject 'i2c-10'
[19188.228974] Modules linked in: tuner_xc2028(O) em28xx_rc zl10353
em28xx_dvb dvb_core snd_usb_audio snd_usbmidi_lib snd_rawmidi tvp5150
em28xx videobuf2_core videobuf2_vmalloc videobuf2_memops xt_tcpudp
xt_pkttype af_packet xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 ip6table_raw ipt_REJECT iptable_raw xt_CT iptable_filter
ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast
nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack
ip6table_filter ip6_tables x_tables fuse arc4 rtl8187 mac80211
snd_hda_codec_hdmi snd_hda_codec_analog snd_hda_intel snd_hda_codec
rc_hauppauge ir_kbd_i2c snd_hwdep cfg80211 tuner_simple tuner_types
snd_pcm tda9887 tda8290 rfkill usb_storage snd_seq usblp tuner msp3400
eeprom_93cx6 bttv snd_timer snd_seq_device v4l2_common videodev snd
videobuf_dma_sg videobuf_core firewire_ohci sg btcx_risc firewire_core
sr_mod cdrom soundcore snd_page_alloc rc_core tveeprom forcedeth k8temp
serio_raw shpchp crc_itu_t i2c_nforce2 powernow_k8 pcspkr kvm_amd kvm
ppdev parport_pc parport floppy asus_atk0110 button autofs4 radeon ttm
drm_kms_helper drm i2c_algo_bit thermal fan processor thermal_sys
scsi_dh_alua scsi_dh_hp_sw scsi_dh_emc scsi_dh_rdac scsi_dh ata_generic
pata_amd pata_jmicron sata_nv [last unloaded: tuner_xc2028]
[19188.228995] CPU: 0 PID: 12773 Comm: qv4l2 Tainted: G        W  O
3.13.0-rc5-0.1-desktop+ #58
[19188.228996] Hardware name: System manufacturer System Product
Name/M2N-VM DH, BIOS ASUS M2N-VM DH ACPI BIOS Revision 1503 09/16/2010
[19188.229018]  00000000 00000000 d876be18 c077957b d876be58 d876be48
c02401bf c092ae20
[19188.229022]  d876be74 000031e5 c0934ca6 000000d6 c03afec9 c03afec9
00000000 c0a10100
[19188.229026]  eed2e220 d876be60 c024025e 00000009 d876be58 c092ae20
d876be74 d876be88
[19188.229026] Call Trace:
[19188.229029]  [<c077957b>] dump_stack+0x48/0x69
[19188.229032]  [<c02401bf>] warn_slowpath_common+0x7f/0xa0
[19188.229035]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.229038]  [<c03afec9>] ? sysfs_remove_group+0xc9/0xd0
[19188.229040]  [<c024025e>] warn_slowpath_fmt+0x2e/0x30
[19188.229043]  [<c03afec9>] sysfs_remove_group+0xc9/0xd0
[19188.229045]  [<c059c26d>] dpm_sysfs_remove+0x2d/0x30
[19188.229048]  [<c0593fec>] device_del+0x2c/0x150
[19188.229050]  [<c059412c>] device_unregister+0x1c/0x60
[19188.229052]  [<c03af3f1>] ? sysfs_remove_link+0x11/0x30
[19188.229055]  [<c0597b9f>] ? class_compat_remove_link+0x2f/0x50
[19188.229058]  [<c064cae4>] i2c_del_adapter+0x1b4/0x2c0
[19188.229061]  [<c064b790>] ? __process_removed_driver+0x30/0x30
[19188.229062]  [<c07761ea>] ? printk+0x48/0x4a
[19188.229068]  [<f9bf42b7>] em28xx_i2c_unregister+0x17/0x30 [em28xx]
[19188.229073]  [<f9bf573e>] em28xx_release_resources+0x1e/0x70 [em28xx]
[19188.229077]  [<f9bf0c6f>] em28xx_v4l2_close+0xcf/0x150 [em28xx]
[19188.229086]  [<f951302e>] v4l2_release+0x2e/0x70 [videodev]
[19188.229089]  [<c034df1b>] __fput+0xab/0x1d0
[19188.229092]  [<c034e078>] ____fput+0x8/0x10
[19188.229095]  [<c025a6e9>] task_work_run+0x79/0x90
[19188.229097]  [<c0202141>] do_notify_resume+0x51/0x80
[19188.229100]  [<c077fd1b>] work_notifysig+0x24/0x29
[19188.229101] ---[ end trace e8fa0efd13bec3a5 ]---



It also occurs with the latest em28xx-experimental code (analog support
moved to it's own separate module).

Regards,
Frank


