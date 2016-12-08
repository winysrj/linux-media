Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-painless.mh.aa.net.uk ([81.187.30.51]:34090 "EHLO
        a-painless.mh.aa.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbcLHNHm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 08:07:42 -0500
Received: from [37.26.72.106] (helo=[192.168.1.218])
        by a-painless.mh.aa.net.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <linux-media@destevenson.freeserve.co.uk>)
        id 1cExri-0008EK-U0
        for linux-media@vger.kernel.org; Thu, 08 Dec 2016 12:31:59 +0000
To: linux-media@vger.kernel.org
From: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Subject: uvcvideo logging kernel warnings on device disconnect
Message-ID: <ab3241e7-c525-d855-ecb6-ba04dbdb030f@destevenson.freeserve.co.uk>
Date: Thu, 8 Dec 2016 12:31:55 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

I'm working with a USB webcam which has been seen to spontaneously 
disconnect when in use. That's a separate issue, but when it does it 
throws a load of warnings into the kernel log if there is a file handle 
on the device open at the time, even if not streaming.

I've reproduced this with a generic Logitech C270 webcam on:
- Ubuntu 16.04 (kernel 4.4.0-51) vanilla, and with the latest media tree 
from linuxtv.org
- Ubuntu 14.04 (kernel 4.4.0-42) vanilla
- an old 3.10.x tree on an embedded device.

To reproduce:
- connect USB webcam.
- run a simple app that opens /dev/videoX, sleeps for a while, and then 
closes the handle.
- disconnect the webcam whilst the app is running.
- read kernel logs - observe warnings. We get the disconnect logged as 
it occurs, but the warnings all occur when the file descriptor is 
closed. (A copy of the logs from my Ubuntu 14.04 machine are below).

I can fully appreciate that the open file descriptor is holding 
references to a now invalid device, but is there a way to avoid them? Or 
do we really not care and have to put up with the log noise when doing 
such silly things?

Thanks in advance.
   Dave

[157877.297617] usb 1-1: new high-speed USB device number 12 using xhci_hcd
[157877.698744] usb 1-1: New USB device found, idVendor=046d, idProduct=0825
[157877.698747] usb 1-1: New USB device strings: Mfr=0, Product=0, 
SerialNumber=2
[157877.698749] usb 1-1: SerialNumber: E989E680
[157877.699314] uvcvideo: Found UVC 1.00 device <unnamed> (046d:0825)
[157877.789891] input: UVC Camera (046d:0825) as 
/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/input/input688
[157879.135333] usb 1-1: set resolution quirk: cval->res = 384

[157885.686043] usb 1-1: USB disconnect, device number 12

[157901.378104] ------------[ cut here ]------------
[157901.378111] WARNING: CPU: 2 PID: 21082 at 
/build/linux-lts-xenial-Ev_ZZB/linux-lts-xenial-4.4.0/fs/sysfs/group.c:237 
sysfs_remove_group+0x8d/0x90()
[157901.378113] sysfs group ffffffff81ecb6c0 not found for kobject 'event13'
[157901.378114] Modules linked in: snd_usb_audio snd_usbmidi_lib uas 
usb_storage ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c drbg 
ansi_cprng ctr ccm dm_crypt cmac asus_nb_wmi asus_wmi sparse_keymap 
snd_soc_rt5640 snd_soc_rl6231 snd_soc_core arc4 snd_compress ac97_bus 
snd_pcm_dmaengine uvcvideo snd_seq_midi videobuf2_vmalloc 
videobuf2_memops snd_seq_midi_event videobuf2_v4l2 intel_rapl 
videobuf2_core v4l2_common x86_pkg_temp_thermal videodev 
intel_powerclamp media kvm_intel iwlmvm dm_multipath snd_rawmidi kvm 
mac80211 snd_hda_codec_hdmi irqbypass crct10dif_pclmul crc32_pclmul 
snd_hda_codec_conexant snd_hda_codec_generic btusb rfcomm btrtl btbcm 
bnep snd_hda_intel snd_hda_codec btintel iwlwifi bluetooth snd_seq 
snd_hda_core snd_hwdep aesni_intel aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd input_leds cfg80211 snd_pcm joydev nfsd serio_raw 
mei_me snd_seq_device auth_rpcgss nfs_acl mei processor_thermal_device 
intel_soc_dts_iosf lpc_ich snd_timer binfmt_misc shpchp 
intel_pch_thermal nfs lockd grace sunrpc fscache snd soundcore elan_i2c 
i2c_hid hid int3402_thermal int340x_thermal_zone nls_iso8859_1 dw_dmac 
int3400_thermal snd_soc_sst_acpi dw_dmac_core acpi_als acpi_pad 
i2c_designware_platform kfifo_buf i2c_designware_core 8250_dw 
spi_pxa2xx_platform parport_pc industrialio acpi_thermal_rel ppdev 
coretemp mac_hid lp parport btrfs xor raid6_pq dm_mirror dm_region_hash 
dm_log i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm ahci psmouse libahci wmi video sdhci_acpi 
sdhci fjes
[157901.378184] CPU: 2 PID: 21082 Comm: a.out Not tainted 
4.4.0-42-generic #62~14.04.1-Ubuntu
[157901.378185] Hardware name: ASUSTeK COMPUTER INC.
[157901.378186]  0000000000000000 ffff8800da3a7bb8 ffffffff813d51ec 
ffff8800da3a7c00
[157901.378188]  ffffffff81cdd3b0 ffff8800da3a7bf0 ffffffff8107d886 
0000000000000000
[157901.378190]  ffffffff81ecb6c0 ffff8800bb2e08c0 ffff8800d93f6248 
ffff8801081b9540
[157901.378192] Call Trace:
[157901.378197]  [<ffffffff813d51ec>] dump_stack+0x63/0x87
[157901.378200]  [<ffffffff8107d886>] warn_slowpath_common+0x86/0xc0
[157901.378202]  [<ffffffff8107d90c>] warn_slowpath_fmt+0x4c/0x50
[157901.378204]  [<ffffffff812781c8>] ? kernfs_find_and_get_ns+0x48/0x60
[157901.378206]  [<ffffffff8127b7ad>] sysfs_remove_group+0x8d/0x90
[157901.378209]  [<ffffffff81534e47>] dpm_sysfs_remove+0x57/0x60
[157901.378211]  [<ffffffff815281c8>] device_del+0x58/0x260
[157901.378213]  [<ffffffff814d5fd2>] ? kbd_disconnect+0x22/0x30
[157901.378216]  [<ffffffff8164a093>] evdev_disconnect+0x23/0x60
[157901.378218]  [<ffffffff81646348>] __input_unregister_device+0xb8/0x160
[157901.378219]  [<ffffffff81646497>] input_unregister_device+0x47/0x70
[157901.378223]  [<ffffffffc0a15a62>] uvc_status_cleanup+0x42/0x50 
[uvcvideo]
[157901.378226]  [<ffffffffc0a0b1f8>] uvc_delete+0x18/0x150 [uvcvideo]
[157901.378228]  [<ffffffffc0a0b403>] uvc_release+0x23/0x30 [uvcvideo]
[157901.378233]  [<ffffffffc09df7bb>] v4l2_device_release+0xcb/0x100 
[videodev]
[157901.378236]  [<ffffffff81527a02>] device_release+0x32/0xa0
[157901.378237]  [<ffffffff813d7697>] kobject_cleanup+0x77/0x190
[157901.378239]  [<ffffffff813d77e5>] kobject_put+0x25/0x50
[157901.378240]  [<ffffffff81527cf7>] put_device+0x17/0x20
[157901.378244]  [<ffffffffc09de46d>] v4l2_release+0x4d/0x80 [videodev]
[157901.378246]  [<ffffffff811ffcc4>] __fput+0xe4/0x210
[157901.378248]  [<ffffffff811ffe2e>] ____fput+0xe/0x10
[157901.378251]  [<ffffffff81099fc6>] task_work_run+0x86/0xb0
[157901.378253]  [<ffffffff81078806>] exit_to_usermode_loop+0x73/0xa2
[157901.378255]  [<ffffffff81003a6e>] syscall_return_slowpath+0x4e/0x60
[157901.378258]  [<ffffffff817fa658>] int_ret_from_sys_call+0x25/0x8f
[157901.378259] ---[ end trace f6d203eeef04d0d8 ]---
[157901.398109] ------------[ cut here ]------------
[157901.398117] WARNING: CPU: 2 PID: 21082 at 
/build/linux-lts-xenial-Ev_ZZB/linux-lts-xenial-4.4.0/fs/sysfs/group.c:237 
sysfs_remove_group+0x8d/0x90()
[157901.398119] sysfs group ffffffff81ecb6c0 not found for kobject 
'input688'
[157901.398120] Modules linked in: snd_usb_audio snd_usbmidi_lib uas 
usb_storage ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c drbg 
ansi_cprng ctr ccm dm_crypt cmac asus_nb_wmi asus_wmi sparse_keymap 
snd_soc_rt5640 snd_soc_rl6231 snd_soc_core arc4 snd_compress ac97_bus 
snd_pcm_dmaengine uvcvideo snd_seq_midi videobuf2_vmalloc 
videobuf2_memops snd_seq_midi_event videobuf2_v4l2 intel_rapl 
videobuf2_core v4l2_common x86_pkg_temp_thermal videodev 
intel_powerclamp media kvm_intel iwlmvm dm_multipath snd_rawmidi kvm 
mac80211 snd_hda_codec_hdmi irqbypass crct10dif_pclmul crc32_pclmul 
snd_hda_codec_conexant snd_hda_codec_generic btusb rfcomm btrtl btbcm 
bnep snd_hda_intel snd_hda_codec btintel iwlwifi bluetooth snd_seq 
snd_hda_core snd_hwdep aesni_intel aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd input_leds cfg80211 snd_pcm joydev nfsd serio_raw 
mei_me snd_seq_device auth_rpcgss nfs_acl mei processor_thermal_device 
intel_soc_dts_iosf lpc_ich snd_timer binfmt_misc shpchp 
intel_pch_thermal nfs lockd grace sunrpc fscache snd soundcore elan_i2c 
i2c_hid hid int3402_thermal int340x_thermal_zone nls_iso8859_1 dw_dmac 
int3400_thermal snd_soc_sst_acpi dw_dmac_core acpi_als acpi_pad 
i2c_designware_platform kfifo_buf i2c_designware_core 8250_dw 
spi_pxa2xx_platform parport_pc industrialio acpi_thermal_rel ppdev 
coretemp mac_hid lp parport btrfs xor raid6_pq dm_mirror dm_region_hash 
dm_log i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm ahci psmouse libahci wmi video sdhci_acpi 
sdhci fjes
[157901.398205] CPU: 2 PID: 21082 Comm: a.out Tainted: G W       
4.4.0-42-generic #62~14.04.1-Ubuntu
[157901.398207] Hardware name: ASUSTeK COMPUTER INC.
[157901.398209]  0000000000000000 ffff8800da3a7be0 ffffffff813d51ec 
ffff8800da3a7c28
[157901.398213]  ffffffff81cdd3b0 ffff8800da3a7c18 ffffffff8107d886 
0000000000000000
[157901.398216]  ffffffff81ecb6c0 ffff8800d93f6258 ffff8801322ef430 
ffff8801081b9540
[157901.398218] Call Trace:
[157901.398224]  [<ffffffff813d51ec>] dump_stack+0x63/0x87
[157901.398228]  [<ffffffff8107d886>] warn_slowpath_common+0x86/0xc0
[157901.398231]  [<ffffffff8107d90c>] warn_slowpath_fmt+0x4c/0x50
[157901.398234]  [<ffffffff812781c8>] ? kernfs_find_and_get_ns+0x48/0x60
[157901.398237]  [<ffffffff8127b7ad>] sysfs_remove_group+0x8d/0x90
[157901.398241]  [<ffffffff81534e47>] dpm_sysfs_remove+0x57/0x60
[157901.398244]  [<ffffffff815281c8>] device_del+0x58/0x260
[157901.398248]  [<ffffffff810bd8e4>] ? __wake_up+0x44/0x50
[157901.398251]  [<ffffffff816463d2>] __input_unregister_device+0x142/0x160
[157901.398254]  [<ffffffff81646497>] input_unregister_device+0x47/0x70
[157901.398261]  [<ffffffffc0a15a62>] uvc_status_cleanup+0x42/0x50 
[uvcvideo]
[157901.398264]  [<ffffffffc0a0b1f8>] uvc_delete+0x18/0x150 [uvcvideo]
[157901.398267]  [<ffffffffc0a0b403>] uvc_release+0x23/0x30 [uvcvideo]
[157901.398274]  [<ffffffffc09df7bb>] v4l2_device_release+0xcb/0x100 
[videodev]
[157901.398277]  [<ffffffff81527a02>] device_release+0x32/0xa0
[157901.398280]  [<ffffffff813d7697>] kobject_cleanup+0x77/0x190
[157901.398282]  [<ffffffff813d77e5>] kobject_put+0x25/0x50
[157901.398283]  [<ffffffff81527cf7>] put_device+0x17/0x20
[157901.398290]  [<ffffffffc09de46d>] v4l2_release+0x4d/0x80 [videodev]
[157901.398293]  [<ffffffff811ffcc4>] __fput+0xe4/0x210
[157901.398296]  [<ffffffff811ffe2e>] ____fput+0xe/0x10
[157901.398299]  [<ffffffff81099fc6>] task_work_run+0x86/0xb0
[157901.398302]  [<ffffffff81078806>] exit_to_usermode_loop+0x73/0xa2
[157901.398305]  [<ffffffff81003a6e>] syscall_return_slowpath+0x4e/0x60
[157901.398309]  [<ffffffff817fa658>] int_ret_from_sys_call+0x25/0x8f
[157901.398312] ---[ end trace f6d203eeef04d0d9 ]---
[157901.398320] ------------[ cut here ]------------
[157901.398323] WARNING: CPU: 2 PID: 21082 at 
/build/linux-lts-xenial-Ev_ZZB/linux-lts-xenial-4.4.0/fs/sysfs/group.c:237 
sysfs_remove_group+0x8d/0x90()
[157901.398325] sysfs group ffffffff81ee8de0 not found for kobject 
'input688'
[157901.398326] Modules linked in: snd_usb_audio snd_usbmidi_lib uas 
usb_storage ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c drbg 
ansi_cprng ctr ccm dm_crypt cmac asus_nb_wmi asus_wmi sparse_keymap 
snd_soc_rt5640 snd_soc_rl6231 snd_soc_core arc4 snd_compress ac97_bus 
snd_pcm_dmaengine uvcvideo snd_seq_midi videobuf2_vmalloc 
videobuf2_memops snd_seq_midi_event videobuf2_v4l2 intel_rapl 
videobuf2_core v4l2_common x86_pkg_temp_thermal videodev 
intel_powerclamp media kvm_intel iwlmvm dm_multipath snd_rawmidi kvm 
mac80211 snd_hda_codec_hdmi irqbypass crct10dif_pclmul crc32_pclmul 
snd_hda_codec_conexant snd_hda_codec_generic btusb rfcomm btrtl btbcm 
bnep snd_hda_intel snd_hda_codec btintel iwlwifi bluetooth snd_seq 
snd_hda_core snd_hwdep aesni_intel aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd input_leds cfg80211 snd_pcm joydev nfsd serio_raw 
mei_me snd_seq_device auth_rpcgss nfs_acl mei processor_thermal_device 
intel_soc_dts_iosf lpc_ich snd_timer binfmt_misc shpchp 
intel_pch_thermal nfs lockd grace sunrpc fscache snd soundcore elan_i2c 
i2c_hid hid int3402_thermal int340x_thermal_zone nls_iso8859_1 dw_dmac 
int3400_thermal snd_soc_sst_acpi dw_dmac_core acpi_als acpi_pad 
i2c_designware_platform kfifo_buf i2c_designware_core 8250_dw 
spi_pxa2xx_platform parport_pc industrialio acpi_thermal_rel ppdev 
coretemp mac_hid lp parport btrfs xor raid6_pq dm_mirror dm_region_hash 
dm_log i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm ahci psmouse libahci wmi video sdhci_acpi 
sdhci fjes
[157901.398381] CPU: 2 PID: 21082 Comm: a.out Tainted: G W       
4.4.0-42-generic #62~14.04.1-Ubuntu
[157901.398382] Hardware name: ASUSTeK COMPUTER INC.
[157901.398383]  0000000000000000 ffff8800da3a7ba8 ffffffff813d51ec 
ffff8800da3a7bf0
[157901.398385]  ffffffff81cdd3b0 ffff8800da3a7be0 ffffffff8107d886 
0000000000000000
[157901.398387]  ffffffff81ee8de0 ffff8800d93f6258 ffffffff81ee8bc0 
ffff8801081b9540
[157901.398388] Call Trace:
[157901.398391]  [<ffffffff813d51ec>] dump_stack+0x63/0x87
[157901.398393]  [<ffffffff8107d886>] warn_slowpath_common+0x86/0xc0
[157901.398395]  [<ffffffff8107d90c>] warn_slowpath_fmt+0x4c/0x50
[157901.398397]  [<ffffffff812781c8>] ? kernfs_find_and_get_ns+0x48/0x60
[157901.398399]  [<ffffffff8127b7ad>] sysfs_remove_group+0x8d/0x90
[157901.398400]  [<ffffffff8127b85e>] sysfs_remove_groups+0x2e/0x50
[157901.398403]  [<ffffffff8152794e>] device_remove_attrs+0x5e/0x80
[157901.398404]  [<ffffffff815282a1>] device_del+0x131/0x260
[157901.398406]  [<ffffffff810bd8e4>] ? __wake_up+0x44/0x50
[157901.398408]  [<ffffffff816463d2>] __input_unregister_device+0x142/0x160
[157901.398409]  [<ffffffff81646497>] input_unregister_device+0x47/0x70
[157901.398412]  [<ffffffffc0a15a62>] uvc_status_cleanup+0x42/0x50 
[uvcvideo]
[157901.398415]  [<ffffffffc0a0b1f8>] uvc_delete+0x18/0x150 [uvcvideo]
[157901.398417]  [<ffffffffc0a0b403>] uvc_release+0x23/0x30 [uvcvideo]
[157901.398421]  [<ffffffffc09df7bb>] v4l2_device_release+0xcb/0x100 
[videodev]
[157901.398423]  [<ffffffff81527a02>] device_release+0x32/0xa0
[157901.398425]  [<ffffffff813d7697>] kobject_cleanup+0x77/0x190
[157901.398426]  [<ffffffff813d77e5>] kobject_put+0x25/0x50
[157901.398427]  [<ffffffff81527cf7>] put_device+0x17/0x20
[157901.398431]  [<ffffffffc09de46d>] v4l2_release+0x4d/0x80 [videodev]
[157901.398433]  [<ffffffff811ffcc4>] __fput+0xe4/0x210
[157901.398435]  [<ffffffff811ffe2e>] ____fput+0xe/0x10
[157901.398437]  [<ffffffff81099fc6>] task_work_run+0x86/0xb0
[157901.398439]  [<ffffffff81078806>] exit_to_usermode_loop+0x73/0xa2
[157901.398441]  [<ffffffff81003a6e>] syscall_return_slowpath+0x4e/0x60
[157901.398443]  [<ffffffff817fa658>] int_ret_from_sys_call+0x25/0x8f
[157901.398444] ---[ end trace f6d203eeef04d0da ]---
[157901.398445] ------------[ cut here ]------------
[157901.398447] WARNING: CPU: 2 PID: 21082 at 
/build/linux-lts-xenial-Ev_ZZB/linux-lts-xenial-4.4.0/fs/sysfs/group.c:237 
sysfs_remove_group+0x8d/0x90()
[157901.398448] sysfs group ffffffff81ee8c20 not found for kobject 
'input688'
[157901.398449] Modules linked in: snd_usb_audio snd_usbmidi_lib uas 
usb_storage ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c drbg 
ansi_cprng ctr ccm dm_crypt cmac asus_nb_wmi asus_wmi sparse_keymap 
snd_soc_rt5640 snd_soc_rl6231 snd_soc_core arc4 snd_compress ac97_bus 
snd_pcm_dmaengine uvcvideo snd_seq_midi videobuf2_vmalloc 
videobuf2_memops snd_seq_midi_event videobuf2_v4l2 intel_rapl 
videobuf2_core v4l2_common x86_pkg_temp_thermal videodev 
intel_powerclamp media kvm_intel iwlmvm dm_multipath snd_rawmidi kvm 
mac80211 snd_hda_codec_hdmi irqbypass crct10dif_pclmul crc32_pclmul 
snd_hda_codec_conexant snd_hda_codec_generic btusb rfcomm btrtl btbcm 
bnep snd_hda_intel snd_hda_codec btintel iwlwifi bluetooth snd_seq 
snd_hda_core snd_hwdep aesni_intel aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd input_leds cfg80211 snd_pcm joydev nfsd serio_raw 
mei_me snd_seq_device auth_rpcgss nfs_acl mei processor_thermal_device 
intel_soc_dts_iosf lpc_ich snd_timer binfmt_misc shpchp 
intel_pch_thermal nfs lockd grace sunrpc fscache snd soundcore elan_i2c 
i2c_hid hid int3402_thermal int340x_thermal_zone nls_iso8859_1 dw_dmac 
int3400_thermal snd_soc_sst_acpi dw_dmac_core acpi_als acpi_pad 
i2c_designware_platform kfifo_buf i2c_designware_core 8250_dw 
spi_pxa2xx_platform parport_pc industrialio acpi_thermal_rel ppdev 
coretemp mac_hid lp parport btrfs xor raid6_pq dm_mirror dm_region_hash 
dm_log i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm ahci psmouse libahci wmi video sdhci_acpi 
sdhci fjes
[157901.398495] CPU: 2 PID: 21082 Comm: a.out Tainted: G W       
4.4.0-42-generic #62~14.04.1-Ubuntu
[157901.398496] Hardware name: ASUSTeK COMPUTER INC.
[157901.398497]  0000000000000000 ffff8800da3a7ba8 ffffffff813d51ec 
ffff8800da3a7bf0
[157901.398498]  ffffffff81cdd3b0 ffff8800da3a7be0 ffffffff8107d886 
0000000000000000
[157901.398500]  ffffffff81ee8c20 ffff8800d93f6258 ffffffff81ee8bc0 
ffff8801081b9540
[157901.398502] Call Trace:
[157901.398504]  [<ffffffff813d51ec>] dump_stack+0x63/0x87
[157901.398506]  [<ffffffff8107d886>] warn_slowpath_common+0x86/0xc0
[157901.398508]  [<ffffffff8107d90c>] warn_slowpath_fmt+0x4c/0x50
[157901.398509]  [<ffffffff812781c8>] ? kernfs_find_and_get_ns+0x48/0x60
[157901.398511]  [<ffffffff8127b7ad>] sysfs_remove_group+0x8d/0x90
[157901.398513]  [<ffffffff8127b85e>] sysfs_remove_groups+0x2e/0x50
[157901.398515]  [<ffffffff8152794e>] device_remove_attrs+0x5e/0x80
[157901.398517]  [<ffffffff815282a1>] device_del+0x131/0x260
[157901.398519]  [<ffffffff810bd8e4>] ? __wake_up+0x44/0x50
[157901.398520]  [<ffffffff816463d2>] __input_unregister_device+0x142/0x160
[157901.398522]  [<ffffffff81646497>] input_unregister_device+0x47/0x70
[157901.398524]  [<ffffffffc0a15a62>] uvc_status_cleanup+0x42/0x50 
[uvcvideo]
[157901.398526]  [<ffffffffc0a0b1f8>] uvc_delete+0x18/0x150 [uvcvideo]
[157901.398528]  [<ffffffffc0a0b403>] uvc_release+0x23/0x30 [uvcvideo]
[157901.398532]  [<ffffffffc09df7bb>] v4l2_device_release+0xcb/0x100 
[videodev]
[157901.398535]  [<ffffffff81527a02>] device_release+0x32/0xa0
[157901.398536]  [<ffffffff813d7697>] kobject_cleanup+0x77/0x190
[157901.398537]  [<ffffffff813d77e5>] kobject_put+0x25/0x50
[157901.398538]  [<ffffffff81527cf7>] put_device+0x17/0x20
[157901.398542]  [<ffffffffc09de46d>] v4l2_release+0x4d/0x80 [videodev]
[157901.398544]  [<ffffffff811ffcc4>] __fput+0xe4/0x210
[157901.398546]  [<ffffffff811ffe2e>] ____fput+0xe/0x10
[157901.398548]  [<ffffffff81099fc6>] task_work_run+0x86/0xb0
[157901.398549]  [<ffffffff81078806>] exit_to_usermode_loop+0x73/0xa2
[157901.398551]  [<ffffffff81003a6e>] syscall_return_slowpath+0x4e/0x60
[157901.398553]  [<ffffffff817fa658>] int_ret_from_sys_call+0x25/0x8f
[157901.398554] ---[ end trace f6d203eeef04d0db ]---
[157901.398600] ------------[ cut here ]------------
[157901.398603] WARNING: CPU: 2 PID: 21082 at 
/build/linux-lts-xenial-Ev_ZZB/linux-lts-xenial-4.4.0/fs/sysfs/group.c:237 
sysfs_remove_group+0x8d/0x90()
[157901.398605] sysfs group ffffffff81ecb6c0 not found for kobject 'media1'
[157901.398606] Modules linked in: snd_usb_audio snd_usbmidi_lib uas 
usb_storage ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c drbg 
ansi_cprng ctr ccm dm_crypt cmac asus_nb_wmi asus_wmi sparse_keymap 
snd_soc_rt5640 snd_soc_rl6231 snd_soc_core arc4 snd_compress ac97_bus 
snd_pcm_dmaengine uvcvideo snd_seq_midi videobuf2_vmalloc 
videobuf2_memops snd_seq_midi_event videobuf2_v4l2 intel_rapl 
videobuf2_core v4l2_common x86_pkg_temp_thermal videodev 
intel_powerclamp media kvm_intel iwlmvm dm_multipath snd_rawmidi kvm 
mac80211 snd_hda_codec_hdmi irqbypass crct10dif_pclmul crc32_pclmul 
snd_hda_codec_conexant snd_hda_codec_generic btusb rfcomm btrtl btbcm 
bnep snd_hda_intel snd_hda_codec btintel iwlwifi bluetooth snd_seq 
snd_hda_core snd_hwdep aesni_intel aes_x86_64 lrw gf128mul glue_helper 
ablk_helper cryptd input_leds cfg80211 snd_pcm joydev nfsd serio_raw 
mei_me snd_seq_device auth_rpcgss nfs_acl mei processor_thermal_device 
intel_soc_dts_iosf lpc_ich snd_timer binfmt_misc shpchp 
intel_pch_thermal nfs lockd grace sunrpc fscache snd soundcore elan_i2c 
i2c_hid hid int3402_thermal int340x_thermal_zone nls_iso8859_1 dw_dmac 
int3400_thermal snd_soc_sst_acpi dw_dmac_core acpi_als acpi_pad 
i2c_designware_platform kfifo_buf i2c_designware_core 8250_dw 
spi_pxa2xx_platform parport_pc industrialio acpi_thermal_rel ppdev 
coretemp mac_hid lp parport btrfs xor raid6_pq dm_mirror dm_region_hash 
dm_log i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm ahci psmouse libahci wmi video sdhci_acpi 
sdhci fjes
[157901.398654] CPU: 2 PID: 21082 Comm: a.out Tainted: G W       
4.4.0-42-generic #62~14.04.1-Ubuntu
[157901.398655] Hardware name: ASUSTeK COMPUTER INC.
[157901.398656]  0000000000000000 ffff8800da3a7be0 ffffffff813d51ec 
ffff8800da3a7c28
[157901.398658]  ffffffff81cdd3b0 ffff8800da3a7c18 ffffffff8107d886 
0000000000000000
[157901.398660]  ffffffff81ecb6c0 ffff8800d93f2090 ffff8801322ef430 
ffff8801081b9540
[157901.398661] Call Trace:
[157901.398664]  [<ffffffff813d51ec>] dump_stack+0x63/0x87
[157901.398666]  [<ffffffff8107d886>] warn_slowpath_common+0x86/0xc0
[157901.398668]  [<ffffffff8107d90c>] warn_slowpath_fmt+0x4c/0x50
[157901.398669]  [<ffffffff812781c8>] ? kernfs_find_and_get_ns+0x48/0x60
[157901.398671]  [<ffffffff8127b7ad>] sysfs_remove_group+0x8d/0x90
[157901.398673]  [<ffffffff81534e47>] dpm_sysfs_remove+0x57/0x60
[157901.398675]  [<ffffffff815281c8>] device_del+0x58/0x260
[157901.398676]  [<ffffffff815283ee>] device_unregister+0x1e/0x60
[157901.398680]  [<ffffffffc07c2f11>] media_devnode_unregister+0x41/0x50 
[media]
[157901.398683]  [<ffffffffc07c2315>] media_device_unregister+0x55/0x60 
[media]
[157901.398685]  [<ffffffffc0a0b31d>] uvc_delete+0x13d/0x150 [uvcvideo]
[157901.398687]  [<ffffffffc0a0b403>] uvc_release+0x23/0x30 [uvcvideo]
[157901.398691]  [<ffffffffc09df7bb>] v4l2_device_release+0xcb/0x100 
[videodev]
[157901.398694]  [<ffffffff81527a02>] device_release+0x32/0xa0
[157901.398695]  [<ffffffff813d7697>] kobject_cleanup+0x77/0x190
[157901.398696]  [<ffffffff813d77e5>] kobject_put+0x25/0x50
[157901.398698]  [<ffffffff81527cf7>] put_device+0x17/0x20
[157901.398701]  [<ffffffffc09de46d>] v4l2_release+0x4d/0x80 [videodev]
[157901.398706]  [<ffffffff811ffcc4>] __fput+0xe4/0x210
[157901.398708]  [<ffffffff811ffe2e>] ____fput+0xe/0x10
[157901.398710]  [<ffffffff81099fc6>] task_work_run+0x86/0xb0
[157901.398711]  [<ffffffff81078806>] exit_to_usermode_loop+0x73/0xa2
[157901.398713]  [<ffffffff81003a6e>] syscall_return_slowpath+0x4e/0x60
[157901.398715]  [<ffffffff817fa658>] int_ret_from_sys_call+0x25/0x8f
[157901.398716] ---[ end trace f6d203eeef04d0dc ]---


