Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:48142 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966234AbdIYXwh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 19:52:37 -0400
Received: by mail-wr0-f174.google.com with SMTP id 108so10612918wra.5
        for <linux-media@vger.kernel.org>; Mon, 25 Sep 2017 16:52:36 -0700 (PDT)
MIME-Version: 1.0
From: Alexandre-Xavier L-L <axdoomer@gmail.com>
Date: Mon, 25 Sep 2017 19:52:34 -0400
Message-ID: <CAKTMqxvhbTyP5iq-tQSRPt8S8aguiBng-XQuS4g+SLij=bMftQ@mail.gmail.com>
Subject: fs/sysfs/group.c:237 device_del+0x54/0x260 and fs/sysfs/group.c:237 sysfs_remove_groups+0x29/0x40
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I've been notified of this error shortly after unplugging my webcam,
so I'm reporting it to you.

Regards,
Alexandre-Xavier

===========================================================
[ 4675.198429] usb 1-2: new high-speed USB device number 3 using xhci_hcd
[ 4675.359123] usb 1-2: New USB device found, idVendor=041e, idProduct=4083
[ 4675.359125] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 4675.359135] usb 1-2: Product: VF0640 Live! Cam Socialize
[ 4675.359136] usb 1-2: Manufacturer: Creative Labs
[ 4675.359137] usb 1-2: SerialNumber: 0E310820
[ 4675.360321] uvcvideo: Found UVC 1.00 device VF0640 Live! Cam
Socialize (041e:4083)
[ 4675.362251] uvcvideo 1-2:1.0: Entity type for entity Processing 2
was not initialized!
[ 4675.362256] uvcvideo 1-2:1.0: Entity type for entity Camera 1 was
not initialized!
[ 4675.362267] uvcvideo 1-2:1.0: Entity type for entity Extension 4
was not initialized!
[ 4675.362375] input: VF0640 Live! Cam Socialize as
/devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/input/input16
[ 4675.467806] usbcore: registered new interface driver snd-usb-audio
[ 4762.157762] [drm:intel_pipe_update_end [i915]] *ERROR* Atomic
update failure on pipe A (start=226453 end=226454) time 229 us, min
763, max 767, scanline start 755, end 777
[ 6613.407294] [drm:intel_pipe_update_end [i915]] *ERROR* Atomic
update failure on pipe A (start=336957 end=336958) time 138 us, min
763, max 767, scanline start 752, end 768
[ 6641.875041] usb 1-2: USB disconnect, device number 3
[ 6641.913026] ------------[ cut here ]------------
[ 6641.913035] WARNING: CPU: 2 PID: 4087 at
/build/linux-cRtIym/linux-4.9.30/fs/sysfs/group.c:237
device_del+0x54/0x260
[ 6641.913036] sysfs group 'power' not found for kobject 'event15'
[ 6641.913037] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_rawmidi nfnetlink_queue nfnetlink_log nfnetlink snd_hrtimer
snd_seq snd_seq_device cpufreq_userspace cpufreq_powersave
cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) bnep
vboxnetflt(O) vboxdrv(O) binfmt_misc ip6t_REJECT nf_reject_ipv6 ext4
jbd2 fscrypto ecb nf_log_ipv6 xt_hl mbcache ip6t_rt uvcvideo
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4
videobuf2_vmalloc videobuf2_memops nf_log_ipv4 nf_log_common
rtsx_usb_ms memstick xt_LOG btusb btrtl btbcm videobuf2_v4l2 btintel
videobuf2_core bluetooth videodev crc16 media intel_rapl
x86_pkg_temp_thermal intel_powerclamp xt_limit xt_tcpudp dell_wmi
xt_addrtype iTCO_wdt kvm_intel sparse_keymap kvm iTCO_vendor_support
dell_laptop dell_smbios snd_hda_codec_hdmi irqbypass
[ 6641.913077]  intel_cstate joydev evdev dcdbas serio_raw
snd_hda_codec_conexant snd_hda_codec_generic wl(PO) dell_smm_hwmon
intel_uncore snd_hda_intel intel_rapl_perf snd_hda_codec
nf_conntrack_ipv4 snd_hda_core snd_hwdep snd_pcm snd_timer i915
drm_kms_helper drm i2c_algo_bit pcspkr cfg80211 wmi nf_defrag_ipv4 sg
rfkill battery xt_conntrack shpchp ac video dell_smo8800 snd soundcore
button mei_me mei lpc_ich ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack iptable_filter coretemp ip_tables
x_tables autofs4 btrfs crc32c_generic xor raid6_pq algif_skcipher
af_alg rtsx_usb_sdmmc mmc_core rtsx_usb mfd_core dm_crypt dm_mod
hid_generic usbhid hid sr_mod cdrom sd_mod crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_i801
[ 6641.913121]  i2c_smbus psmouse aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd ahci libahci ehci_pci ehci_hcd xhci_pci
libata scsi_mod xhci_hcd alx mdio usbcore usb_common thermal
[ 6641.913137] CPU: 2 PID: 4087 Comm: cheese Tainted: P           O
4.9.0-3-amd64 #1 Debian 4.9.30-2+deb9u5
[ 6641.913138] Hardware name: Dell Inc.          Vostro 3460/0J1V31,
BIOS A16 04/18/2013
[ 6641.913140]  0000000000000000 ffffffffa51285b4 ffffb3d7025cfd18
0000000000000000
[ 6641.913143]  ffffffffa4e76ebe ffff8b3786e87800 ffffb3d7025cfd70
ffff8b387421e228
[ 6641.913146]  ffff8b3786ff51e0 ffff8b37880c7840 ffff8b37cb0b16e8
ffffffffa4e76f3f
[ 6641.913148] Call Trace:
[ 6641.913154]  [<ffffffffa51285b4>] ? dump_stack+0x5c/0x78
[ 6641.913158]  [<ffffffffa4e76ebe>] ? __warn+0xbe/0xe0
[ 6641.913161]  [<ffffffffa4e76f3f>] ? warn_slowpath_fmt+0x5f/0x80
[ 6641.913164]  [<ffffffffa5270a24>] ? device_del+0x54/0x260
[ 6641.913168]  [<ffffffffc115c1ae>] ? evdev_disconnect+0x1e/0x50 [evdev]
[ 6641.913172]  [<ffffffffa52a6226>] ? __input_unregister_device+0xb6/0x160
[ 6641.913175]  [<ffffffffa52a6f71>] ? input_unregister_device+0x41/0x70
[ 6641.913179]  [<ffffffffc13b11c5>] ? uvc_delete+0x15/0x160 [uvcvideo]
[ 6641.913182]  [<ffffffffa527028d>] ? device_release+0x2d/0x90
[ 6641.913185]  [<ffffffffa512ab85>] ? kobject_release+0x65/0x180
[ 6641.913194]  [<ffffffffc12a5419>] ? v4l2_release+0x49/0x80 [videodev]
[ 6641.913197]  [<ffffffffa5003ea5>] ? __fput+0xd5/0x220
[ 6641.913199]  [<ffffffffa4e94af9>] ? task_work_run+0x79/0xa0
[ 6641.913202]  [<ffffffffa4e03284>] ? exit_to_usermode_loop+0xa4/0xb0
[ 6641.913204]  [<ffffffffa4e03a94>] ? syscall_return_slowpath+0x54/0x60
[ 6641.913207]  [<ffffffffa5406408>] ? system_call_fast_compare_end+0x99/0x9b
[ 6641.913209] ---[ end trace 895ed7ae7694c37a ]---
[ 6641.941050] ------------[ cut here ]------------
[ 6641.941061] WARNING: CPU: 2 PID: 4087 at
/build/linux-cRtIym/linux-4.9.30/fs/sysfs/group.c:237
device_del+0x54/0x260
[ 6641.941063] sysfs group 'power' not found for kobject 'input16'
[ 6641.941064] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_rawmidi nfnetlink_queue nfnetlink_log nfnetlink snd_hrtimer
snd_seq snd_seq_device cpufreq_userspace cpufreq_powersave
cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) bnep
vboxnetflt(O) vboxdrv(O) binfmt_misc ip6t_REJECT nf_reject_ipv6 ext4
jbd2 fscrypto ecb nf_log_ipv6 xt_hl mbcache ip6t_rt uvcvideo
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4
videobuf2_vmalloc videobuf2_memops nf_log_ipv4 nf_log_common
rtsx_usb_ms memstick xt_LOG btusb btrtl btbcm videobuf2_v4l2 btintel
videobuf2_core bluetooth videodev crc16 media intel_rapl
x86_pkg_temp_thermal intel_powerclamp xt_limit xt_tcpudp dell_wmi
xt_addrtype iTCO_wdt kvm_intel sparse_keymap kvm iTCO_vendor_support
dell_laptop dell_smbios snd_hda_codec_hdmi irqbypass
[ 6641.941120]  intel_cstate joydev evdev dcdbas serio_raw
snd_hda_codec_conexant snd_hda_codec_generic wl(PO) dell_smm_hwmon
intel_uncore snd_hda_intel intel_rapl_perf snd_hda_codec
nf_conntrack_ipv4 snd_hda_core snd_hwdep snd_pcm snd_timer i915
drm_kms_helper drm i2c_algo_bit pcspkr cfg80211 wmi nf_defrag_ipv4 sg
rfkill battery xt_conntrack shpchp ac video dell_smo8800 snd soundcore
button mei_me mei lpc_ich ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack iptable_filter coretemp ip_tables
x_tables autofs4 btrfs crc32c_generic xor raid6_pq algif_skcipher
af_alg rtsx_usb_sdmmc mmc_core rtsx_usb mfd_core dm_crypt dm_mod
hid_generic usbhid hid sr_mod cdrom sd_mod crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_i801
[ 6641.941182]  i2c_smbus psmouse aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd ahci libahci ehci_pci ehci_hcd xhci_pci
libata scsi_mod xhci_hcd alx mdio usbcore usb_common thermal
[ 6641.941203] CPU: 2 PID: 4087 Comm: cheese Tainted: P        W  O
4.9.0-3-amd64 #1 Debian 4.9.30-2+deb9u5
[ 6641.941204] Hardware name: Dell Inc.          Vostro 3460/0J1V31,
BIOS A16 04/18/2013
[ 6641.941207]  0000000000000000 ffffffffa51285b4 ffffb3d7025cfd58
0000000000000000
[ 6641.941212]  ffffffffa4e76ebe ffff8b387421e000 ffffb3d7025cfdb0
ffff8b38421f3030
[ 6641.941215]  ffff8b3786ff51e0 ffff8b37880c7840 ffff8b37cb0b16e8
ffffffffa4e76f3f
[ 6641.941219] Call Trace:
[ 6641.941227]  [<ffffffffa51285b4>] ? dump_stack+0x5c/0x78
[ 6641.941233]  [<ffffffffa4e76ebe>] ? __warn+0xbe/0xe0
[ 6641.941237]  [<ffffffffa4e76f3f>] ? warn_slowpath_fmt+0x5f/0x80
[ 6641.941240]  [<ffffffffa5270a24>] ? device_del+0x54/0x260
[ 6641.941246]  [<ffffffffa52a6f71>] ? input_unregister_device+0x41/0x70
[ 6641.941254]  [<ffffffffc13b11c5>] ? uvc_delete+0x15/0x160 [uvcvideo]
[ 6641.941257]  [<ffffffffa527028d>] ? device_release+0x2d/0x90
[ 6641.941261]  [<ffffffffa512ab85>] ? kobject_release+0x65/0x180
[ 6641.941273]  [<ffffffffc12a5419>] ? v4l2_release+0x49/0x80 [videodev]
[ 6641.941277]  [<ffffffffa5003ea5>] ? __fput+0xd5/0x220
[ 6641.941281]  [<ffffffffa4e94af9>] ? task_work_run+0x79/0xa0
[ 6641.941285]  [<ffffffffa4e03284>] ? exit_to_usermode_loop+0xa4/0xb0
[ 6641.941289]  [<ffffffffa4e03a94>] ? syscall_return_slowpath+0x54/0x60
[ 6641.941294]  [<ffffffffa5406408>] ? system_call_fast_compare_end+0x99/0x9b
[ 6641.941296] ---[ end trace 895ed7ae7694c37b ]---
[ 6641.941308] ------------[ cut here ]------------
[ 6641.941312] WARNING: CPU: 2 PID: 4087 at
/build/linux-cRtIym/linux-4.9.30/fs/sysfs/group.c:237
sysfs_remove_groups+0x29/0x40
[ 6641.941313] sysfs group 'id' not found for kobject 'input16'
[ 6641.941313] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_rawmidi nfnetlink_queue nfnetlink_log nfnetlink snd_hrtimer
snd_seq snd_seq_device cpufreq_userspace cpufreq_powersave
cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) bnep
vboxnetflt(O) vboxdrv(O) binfmt_misc ip6t_REJECT nf_reject_ipv6 ext4
jbd2 fscrypto ecb nf_log_ipv6 xt_hl mbcache ip6t_rt uvcvideo
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4
videobuf2_vmalloc videobuf2_memops nf_log_ipv4 nf_log_common
rtsx_usb_ms memstick xt_LOG btusb btrtl btbcm videobuf2_v4l2 btintel
videobuf2_core bluetooth videodev crc16 media intel_rapl
x86_pkg_temp_thermal intel_powerclamp xt_limit xt_tcpudp dell_wmi
xt_addrtype iTCO_wdt kvm_intel sparse_keymap kvm iTCO_vendor_support
dell_laptop dell_smbios snd_hda_codec_hdmi irqbypass
[ 6641.941360]  intel_cstate joydev evdev dcdbas serio_raw
snd_hda_codec_conexant snd_hda_codec_generic wl(PO) dell_smm_hwmon
intel_uncore snd_hda_intel intel_rapl_perf snd_hda_codec
nf_conntrack_ipv4 snd_hda_core snd_hwdep snd_pcm snd_timer i915
drm_kms_helper drm i2c_algo_bit pcspkr cfg80211 wmi nf_defrag_ipv4 sg
rfkill battery xt_conntrack shpchp ac video dell_smo8800 snd soundcore
button mei_me mei lpc_ich ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack iptable_filter coretemp ip_tables
x_tables autofs4 btrfs crc32c_generic xor raid6_pq algif_skcipher
af_alg rtsx_usb_sdmmc mmc_core rtsx_usb mfd_core dm_crypt dm_mod
hid_generic usbhid hid sr_mod cdrom sd_mod crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_i801
[ 6641.941416]  i2c_smbus psmouse aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd ahci libahci ehci_pci ehci_hcd xhci_pci
libata scsi_mod xhci_hcd alx mdio usbcore usb_common thermal
[ 6641.941428] CPU: 2 PID: 4087 Comm: cheese Tainted: P        W  O
4.9.0-3-amd64 #1 Debian 4.9.30-2+deb9u5
[ 6641.941429] Hardware name: Dell Inc.          Vostro 3460/0J1V31,
BIOS A16 04/18/2013
[ 6641.941429]  0000000000000000 ffffffffa51285b4 ffffb3d7025cfd10
0000000000000000
[ 6641.941432]  ffffffffa4e76ebe 0000000000000002 ffffb3d7025cfd68
ffff8b387421e238
[ 6641.941434]  ffffffffa5acc700 ffff8b37880c7840 ffff8b37cb0b16e8
ffffffffa4e76f3f
[ 6641.941437] Call Trace:
[ 6641.941439]  [<ffffffffa51285b4>] ? dump_stack+0x5c/0x78
[ 6641.941442]  [<ffffffffa4e76ebe>] ? __warn+0xbe/0xe0
[ 6641.941445]  [<ffffffffa4e76f3f>] ? warn_slowpath_fmt+0x5f/0x80
[ 6641.941447]  [<ffffffffa50843d9>] ? sysfs_remove_groups+0x29/0x40
[ 6641.941449]  [<ffffffffa52701d8>] ? device_remove_attrs+0x58/0x80
[ 6641.941451]  [<ffffffffa5270aef>] ? device_del+0x11f/0x260
[ 6641.941454]  [<ffffffffa52a6f71>] ? input_unregister_device+0x41/0x70
[ 6641.941473]  [<ffffffffc13b11c5>] ? uvc_delete+0x15/0x160 [uvcvideo]
[ 6641.941476]  [<ffffffffa527028d>] ? device_release+0x2d/0x90
[ 6641.941480]  [<ffffffffa512ab85>] ? kobject_release+0x65/0x180
[ 6641.941491]  [<ffffffffc12a5419>] ? v4l2_release+0x49/0x80 [videodev]
[ 6641.941495]  [<ffffffffa5003ea5>] ? __fput+0xd5/0x220
[ 6641.941498]  [<ffffffffa4e94af9>] ? task_work_run+0x79/0xa0
[ 6641.941501]  [<ffffffffa4e03284>] ? exit_to_usermode_loop+0xa4/0xb0
[ 6641.941504]  [<ffffffffa4e03a94>] ? syscall_return_slowpath+0x54/0x60
[ 6641.941508]  [<ffffffffa5406408>] ? system_call_fast_compare_end+0x99/0x9b
[ 6641.941510] ---[ end trace 895ed7ae7694c37c ]---
[ 6641.941512] ------------[ cut here ]------------
[ 6641.941514] WARNING: CPU: 2 PID: 4087 at
/build/linux-cRtIym/linux-4.9.30/fs/sysfs/group.c:237
sysfs_remove_groups+0x29/0x40
[ 6641.941515] sysfs group 'capabilities' not found for kobject 'input16'
[ 6641.941516] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_rawmidi nfnetlink_queue nfnetlink_log nfnetlink snd_hrtimer
snd_seq snd_seq_device cpufreq_userspace cpufreq_powersave
cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) bnep
vboxnetflt(O) vboxdrv(O) binfmt_misc ip6t_REJECT nf_reject_ipv6 ext4
jbd2 fscrypto ecb nf_log_ipv6 xt_hl mbcache ip6t_rt uvcvideo
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4
videobuf2_vmalloc videobuf2_memops nf_log_ipv4 nf_log_common
rtsx_usb_ms memstick xt_LOG btusb btrtl btbcm videobuf2_v4l2 btintel
videobuf2_core bluetooth videodev crc16 media intel_rapl
x86_pkg_temp_thermal intel_powerclamp xt_limit xt_tcpudp dell_wmi
xt_addrtype iTCO_wdt kvm_intel sparse_keymap kvm iTCO_vendor_support
dell_laptop dell_smbios snd_hda_codec_hdmi irqbypass
[ 6641.941561]  intel_cstate joydev evdev dcdbas serio_raw
snd_hda_codec_conexant snd_hda_codec_generic wl(PO) dell_smm_hwmon
intel_uncore snd_hda_intel intel_rapl_perf snd_hda_codec
nf_conntrack_ipv4 snd_hda_core snd_hwdep snd_pcm snd_timer i915
drm_kms_helper drm i2c_algo_bit pcspkr cfg80211 wmi nf_defrag_ipv4 sg
rfkill battery xt_conntrack shpchp ac video dell_smo8800 snd soundcore
button mei_me mei lpc_ich ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack iptable_filter coretemp ip_tables
x_tables autofs4 btrfs crc32c_generic xor raid6_pq algif_skcipher
af_alg rtsx_usb_sdmmc mmc_core rtsx_usb mfd_core dm_crypt dm_mod
hid_generic usbhid hid sr_mod cdrom sd_mod crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_i801
[ 6641.941611]  i2c_smbus psmouse aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd ahci libahci ehci_pci ehci_hcd xhci_pci
libata scsi_mod xhci_hcd alx mdio usbcore usb_common thermal
[ 6641.941627] CPU: 2 PID: 4087 Comm: cheese Tainted: P        W  O
4.9.0-3-amd64 #1 Debian 4.9.30-2+deb9u5
[ 6641.941628] Hardware name: Dell Inc.          Vostro 3460/0J1V31,
BIOS A16 04/18/2013
[ 6641.941629]  0000000000000000 ffffffffa51285b4 ffffb3d7025cfd10
0000000000000000
[ 6641.941633]  ffffffffa4e76ebe 0000000000000003 ffffb3d7025cfd68
ffff8b387421e238
[ 6641.941636]  ffffffffa5acc700 ffff8b37880c7840 ffff8b37cb0b16e8
ffffffffa4e76f3f
[ 6641.941640] Call Trace:
[ 6641.941643]  [<ffffffffa51285b4>] ? dump_stack+0x5c/0x78
[ 6641.941647]  [<ffffffffa4e76ebe>] ? __warn+0xbe/0xe0
[ 6641.941651]  [<ffffffffa4e76f3f>] ? warn_slowpath_fmt+0x5f/0x80
[ 6641.941653]  [<ffffffffa50843d9>] ? sysfs_remove_groups+0x29/0x40
[ 6641.941656]  [<ffffffffa52701d8>] ? device_remove_attrs+0x58/0x80
[ 6641.941659]  [<ffffffffa5270aef>] ? device_del+0x11f/0x260
[ 6641.941663]  [<ffffffffa52a6f71>] ? input_unregister_device+0x41/0x70
[ 6641.941668]  [<ffffffffc13b11c5>] ? uvc_delete+0x15/0x160 [uvcvideo]
[ 6641.941671]  [<ffffffffa527028d>] ? device_release+0x2d/0x90
[ 6641.941674]  [<ffffffffa512ab85>] ? kobject_release+0x65/0x180
[ 6641.941684]  [<ffffffffc12a5419>] ? v4l2_release+0x49/0x80 [videodev]
[ 6641.941688]  [<ffffffffa5003ea5>] ? __fput+0xd5/0x220
[ 6641.941691]  [<ffffffffa4e94af9>] ? task_work_run+0x79/0xa0
[ 6641.941694]  [<ffffffffa4e03284>] ? exit_to_usermode_loop+0xa4/0xb0
[ 6641.941697]  [<ffffffffa4e03a94>] ? syscall_return_slowpath+0x54/0x60
[ 6641.941701]  [<ffffffffa5406408>] ? system_call_fast_compare_end+0x99/0x9b
[ 6641.941702] ---[ end trace 895ed7ae7694c37d ]---
[ 6641.941785] ------------[ cut here ]------------
[ 6641.941788] WARNING: CPU: 2 PID: 4087 at
/build/linux-cRtIym/linux-4.9.30/fs/sysfs/group.c:237
device_del+0x54/0x260
[ 6641.941789] sysfs group 'power' not found for kobject 'media1'
[ 6641.941789] Modules linked in: snd_usb_audio snd_usbmidi_lib
snd_rawmidi nfnetlink_queue nfnetlink_log nfnetlink snd_hrtimer
snd_seq snd_seq_device cpufreq_userspace cpufreq_powersave
cpufreq_conservative pci_stub vboxpci(O) vboxnetadp(O) bnep
vboxnetflt(O) vboxdrv(O) binfmt_misc ip6t_REJECT nf_reject_ipv6 ext4
jbd2 fscrypto ecb nf_log_ipv6 xt_hl mbcache ip6t_rt uvcvideo
nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT nf_reject_ipv4
videobuf2_vmalloc videobuf2_memops nf_log_ipv4 nf_log_common
rtsx_usb_ms memstick xt_LOG btusb btrtl btbcm videobuf2_v4l2 btintel
videobuf2_core bluetooth videodev crc16 media intel_rapl
x86_pkg_temp_thermal intel_powerclamp xt_limit xt_tcpudp dell_wmi
xt_addrtype iTCO_wdt kvm_intel sparse_keymap kvm iTCO_vendor_support
dell_laptop dell_smbios snd_hda_codec_hdmi irqbypass
[ 6641.941821]  intel_cstate joydev evdev dcdbas serio_raw
snd_hda_codec_conexant snd_hda_codec_generic wl(PO) dell_smm_hwmon
intel_uncore snd_hda_intel intel_rapl_perf snd_hda_codec
nf_conntrack_ipv4 snd_hda_core snd_hwdep snd_pcm snd_timer i915
drm_kms_helper drm i2c_algo_bit pcspkr cfg80211 wmi nf_defrag_ipv4 sg
rfkill battery xt_conntrack shpchp ac video dell_smo8800 snd soundcore
button mei_me mei lpc_ich ip6table_filter ip6_tables
nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat
nf_conntrack_ftp nf_conntrack iptable_filter coretemp ip_tables
x_tables autofs4 btrfs crc32c_generic xor raid6_pq algif_skcipher
af_alg rtsx_usb_sdmmc mmc_core rtsx_usb mfd_core dm_crypt dm_mod
hid_generic usbhid hid sr_mod cdrom sd_mod crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel i2c_i801
[ 6641.941855]  i2c_smbus psmouse aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd ahci libahci ehci_pci ehci_hcd xhci_pci
libata scsi_mod xhci_hcd alx mdio usbcore usb_common thermal
[ 6641.941867] CPU: 2 PID: 4087 Comm: cheese Tainted: P        W  O
4.9.0-3-amd64 #1 Debian 4.9.30-2+deb9u5
[ 6641.941868] Hardware name: Dell Inc.          Vostro 3460/0J1V31,
BIOS A16 04/18/2013
[ 6641.941868]  0000000000000000 ffffffffa51285b4 ffffb3d7025cfd20
0000000000000000
[ 6641.941871]  ffffffffa4e76ebe ffff8b37765f4400 ffffb3d7025cfd78
ffff8b38421f3030
[ 6641.941873]  ffff8b37a75fd1a8 ffff8b37a75fd168 ffff8b37cb0b16e8
ffffffffa4e76f3f
[ 6641.941875] Call Trace:
[ 6641.941878]  [<ffffffffa51285b4>] ? dump_stack+0x5c/0x78
[ 6641.941881]  [<ffffffffa4e76ebe>] ? __warn+0xbe/0xe0
[ 6641.941883]  [<ffffffffa4e76f3f>] ? warn_slowpath_fmt+0x5f/0x80
[ 6641.941885]  [<ffffffffa5270a24>] ? device_del+0x54/0x260
[ 6641.941887]  [<ffffffffa500622f>] ? cdev_default_release+0xf/0x20
[ 6641.941891]  [<ffffffffc129baba>] ?
media_devnode_unregister+0x3a/0x50 [media]
[ 6641.941894]  [<ffffffffc129b123>] ?
media_device_unregister+0x123/0x160 [media]
[ 6641.941898]  [<ffffffffc13b121a>] ? uvc_delete+0x6a/0x160 [uvcvideo]
[ 6641.941900]  [<ffffffffa527028d>] ? device_release+0x2d/0x90
[ 6641.941902]  [<ffffffffa512ab85>] ? kobject_release+0x65/0x180
[ 6641.941909]  [<ffffffffc12a5419>] ? v4l2_release+0x49/0x80 [videodev]
[ 6641.941911]  [<ffffffffa5003ea5>] ? __fput+0xd5/0x220
[ 6641.941913]  [<ffffffffa4e94af9>] ? task_work_run+0x79/0xa0
[ 6641.941916]  [<ffffffffa4e03284>] ? exit_to_usermode_loop+0xa4/0xb0
[ 6641.941917]  [<ffffffffa4e03a94>] ? syscall_return_slowpath+0x54/0x60
[ 6641.941920]  [<ffffffffa5406408>] ? system_call_fast_compare_end+0x99/0x9b
[ 6641.941921] ---[ end trace 895ed7ae7694c37e ]---
