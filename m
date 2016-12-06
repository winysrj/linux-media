Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50807
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752475AbcLFPlq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2016 10:41:46 -0500
Date: Tue, 6 Dec 2016 13:41:38 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: em28xx broken 4.9.0-rc6+
Message-ID: <20161206134138.1b000552@vento.lan>
In-Reply-To: <790c8863-757c-cd2e-3878-2900df93a694@iki.fi>
References: <790c8863-757c-cd2e-3878-2900df93a694@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Dec 2016 01:06:17 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Hello Mauro
> I just noticed current em28xx driver seem to be broken. When I plug 
> device first time it loads correctly, but when I re-plug it, it does not 
> work anymore but yells a lot of noise to message log. Tested with PCTV 
> 290e and 292e both same. Other USB DVB devices are working so it is very 
> likely em28xx driver bug.
> 
> Easy to reproduce:
> plug device
> unplug device
> plug device


Are you referring to those:

[ 1010.310320] WARNING: CPU: 3 PID: 119 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x7b/0x90
[ 1010.310323] sysfs: cannot create duplicate filename '/bus/usb/devices/1-3.3'
[ 1010.310325] Modules linked in: lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core em28xx tveeprom v4l2_common videodev media xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cmac bnep cpufreq_powersave cpufreq_conservative cpufreq_userspace binfmt_misc parport_pc ppdev lp parport snd_hda_codec_hdmi iTCO_wdt snd_hda_codec_realtek iTCO_vendor_support snd_hda_codec_generic arc4 intel_rapl x86_pkg_temp_thermal iwlmvm intel_powerclamp coretemp kvm_intel mac80211 kvm i915
[ 1010.310383]  irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iwlwifi pl2303 aesni_intel btusb aes_x86_64 usbserial lrw btrtl gf128mul glue_helper btbcm ablk_helper cryptd btintel bluetooth drm_kms_helper cfg80211 drm psmouse pcspkr i2c_i801 e1000e serio_raw snd_hda_intel snd_soc_rt5640 snd_hda_codec snd_soc_rl6231 snd_soc_ssm4567 mei_me i2c_smbus rfkill snd_hda_core ptp mei snd_soc_core ehci_pci sg lpc_ich shpchp mfd_core ehci_hcd pps_core snd_hwdep i2c_algo_bit snd_compress snd_pcm sdhci_acpi snd_timer battery snd sdhci elan_i2c snd_soc_sst_acpi mmc_core fjes dw_dmac i2c_hid soundcore snd_soc_sst_match i2c_designware_platform video i2c_designware_core acpi_pad acpi_als kfifo_buf tpm_tis button industrialio tpm_tis_core tpm ext4 crc16 jbd2 fscrypto mbcache dm_mod joydev evdev hid_logitech_hidpp
[ 1010.310449]  sd_mod hid_logitech_dj usbhid hid ahci libahci crc32c_intel libata xhci_pci xhci_hcd scsi_mod usbcore fan thermal
[ 1010.310464] CPU: 3 PID: 119 Comm: kworker/3:2 Not tainted 4.9.0-rc8+ #14
[ 1010.310466] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[ 1010.310487] Workqueue: usb_hub_wq hub_event [usbcore]
[ 1010.310490]  0000000000000000 ffffffff848f56c5 ffff8803b1f7f858 0000000000000000
[ 1010.310496]  ffffffff8414f8f8 ffff88030000001f ffffed00763eff07 ffff8803b1f7f8f0
[ 1010.310501]  ffff8803b3ea1e60 0000000000000001 ffffffffffffffef ffff8803b45c6840
[ 1010.310505] Call Trace:
[ 1010.310517]  [<ffffffff848f56c5>] ? dump_stack+0x5c/0x77
[ 1010.310522]  [<ffffffff8414f8f8>] ? __warn+0x168/0x1a0
[ 1010.310526]  [<ffffffff8414f9e4>] ? warn_slowpath_fmt+0xb4/0xf0
[ 1010.310529]  [<ffffffff8414f930>] ? __warn+0x1a0/0x1a0
[ 1010.310534]  [<ffffffff845436c6>] ? kasan_kmalloc+0xa6/0xd0
[ 1010.310539]  [<ffffffff846ec2fa>] ? kernfs_path_from_node+0x4a/0x60
[ 1010.310543]  [<ffffffff846f66eb>] ? sysfs_warn_dup+0x7b/0x90
[ 1010.310547]  [<ffffffff846f6f26>] ? sysfs_do_create_link_sd.isra.2+0xb6/0xd0
[ 1010.310553]  [<ffffffff84cd5a08>] ? bus_add_device+0x318/0x6b0
[ 1010.310557]  [<ffffffff846f8693>] ? sysfs_create_groups+0x83/0x110
[ 1010.310562]  [<ffffffff84ccff87>] ? device_add+0x777/0x1350
[ 1010.310567]  [<ffffffff84ccf810>] ? device_private_init+0x180/0x180
[ 1010.310583]  [<ffffffffc00c0f77>] ? usb_new_device+0x707/0x1030 [usbcore]
[ 1010.310598]  [<ffffffffc00c58c5>] ? hub_event+0x1d65/0x3280 [usbcore]
[ 1010.310604]  [<ffffffff841eb4ab>] ? account_entity_dequeue+0x30b/0x4a0
[ 1010.310618]  [<ffffffffc00c3b60>] ? hub_port_debounce+0x280/0x280 [usbcore]
[ 1010.310624]  [<ffffffff8407ccd0>] ? compat_start_thread+0x80/0x80
[ 1010.310629]  [<ffffffff851f5cb4>] ? __schedule+0x704/0x1770
[ 1010.310633]  [<ffffffff851f55b0>] ? io_schedule_timeout+0x390/0x390
[ 1010.310638]  [<ffffffff84541783>] ? cache_reap+0x173/0x200
[ 1010.310642]  [<ffffffff84197bed>] ? process_one_work+0x4ed/0xe60
[ 1010.310646]  [<ffffffff84198642>] ? worker_thread+0xe2/0xfd0
[ 1010.310650]  [<ffffffff8421f76c>] ? __wake_up_common+0xbc/0x160
[ 1010.310654]  [<ffffffff84198560>] ? process_one_work+0xe60/0xe60
[ 1010.310658]  [<ffffffff841a837c>] ? kthread+0x1cc/0x220
[ 1010.310663]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.310667]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.310671]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.310675]  [<ffffffff852016f5>] ? ret_from_fork+0x25/0x30
[ 1010.310698] ---[ end trace 49b46eb633ff1197 ]---
[ 1010.311298] usb 1-3.3: can't device_add, error -17
[ 1010.390703] usb 1-3.3: new high-speed USB device number 9 using xhci_hcd
[ 1010.496337] usb 1-3.3: New USB device found, idVendor=2040, idProduct=6513
[ 1010.496343] usb 1-3.3: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[ 1010.496345] usb 1-3.3: Product: WinTV HVR-980
[ 1010.496347] usb 1-3.3: SerialNumber: 4028449018
[ 1010.497259] ------------[ cut here ]------------
[ 1010.497264] WARNING: CPU: 3 PID: 119 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x7b/0x90
[ 1010.497266] sysfs: cannot create duplicate filename '/bus/usb/devices/1-3.3'
[ 1010.497267] Modules linked in: lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core em28xx tveeprom v4l2_common videodev media xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cmac bnep cpufreq_powersave cpufreq_conservative cpufreq_userspace binfmt_misc parport_pc ppdev lp parport snd_hda_codec_hdmi iTCO_wdt snd_hda_codec_realtek iTCO_vendor_support snd_hda_codec_generic arc4 intel_rapl x86_pkg_temp_thermal iwlmvm intel_powerclamp coretemp kvm_intel mac80211 kvm i915
[ 1010.497307]  irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iwlwifi pl2303 aesni_intel btusb aes_x86_64 usbserial lrw btrtl gf128mul glue_helper btbcm ablk_helper cryptd btintel bluetooth drm_kms_helper cfg80211 drm psmouse pcspkr i2c_i801 e1000e serio_raw snd_hda_intel snd_soc_rt5640 snd_hda_codec snd_soc_rl6231 snd_soc_ssm4567 mei_me i2c_smbus rfkill snd_hda_core ptp mei snd_soc_core ehci_pci sg lpc_ich shpchp mfd_core ehci_hcd pps_core snd_hwdep i2c_algo_bit snd_compress snd_pcm sdhci_acpi snd_timer battery snd sdhci elan_i2c snd_soc_sst_acpi mmc_core fjes dw_dmac i2c_hid soundcore snd_soc_sst_match i2c_designware_platform video i2c_designware_core acpi_pad acpi_als kfifo_buf tpm_tis button industrialio tpm_tis_core tpm ext4 crc16 jbd2 fscrypto mbcache dm_mod joydev evdev hid_logitech_hidpp
[ 1010.497352]  sd_mod hid_logitech_dj usbhid hid ahci libahci crc32c_intel libata xhci_pci xhci_hcd scsi_mod usbcore fan thermal
[ 1010.497362] CPU: 3 PID: 119 Comm: kworker/3:2 Tainted: G        W       4.9.0-rc8+ #14
[ 1010.497363] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[ 1010.497377] Workqueue: usb_hub_wq hub_event [usbcore]
[ 1010.497379]  0000000000000000 ffffffff848f56c5 ffff8803b1f7f858 0000000000000000
[ 1010.497382]  ffffffff8414f8f8 ffff88030000001f ffffed00763eff07 ffff8803b1f7f8f0
[ 1010.497385]  ffff8803b3ea1e60 0000000000000001 ffffffffffffffef ffff8803b45c6840
[ 1010.497387] Call Trace:
[ 1010.497395]  [<ffffffff848f56c5>] ? dump_stack+0x5c/0x77
[ 1010.497398]  [<ffffffff8414f8f8>] ? __warn+0x168/0x1a0
[ 1010.497400]  [<ffffffff8414f9e4>] ? warn_slowpath_fmt+0xb4/0xf0
[ 1010.497402]  [<ffffffff8414f930>] ? __warn+0x1a0/0x1a0
[ 1010.497405]  [<ffffffff845436c6>] ? kasan_kmalloc+0xa6/0xd0
[ 1010.497408]  [<ffffffff846ec2fa>] ? kernfs_path_from_node+0x4a/0x60
[ 1010.497410]  [<ffffffff846f66eb>] ? sysfs_warn_dup+0x7b/0x90
[ 1010.497412]  [<ffffffff846f6f26>] ? sysfs_do_create_link_sd.isra.2+0xb6/0xd0
[ 1010.497416]  [<ffffffff84cd5a08>] ? bus_add_device+0x318/0x6b0
[ 1010.497419]  [<ffffffff846f8693>] ? sysfs_create_groups+0x83/0x110
[ 1010.497421]  [<ffffffff84ccff87>] ? device_add+0x777/0x1350
[ 1010.497424]  [<ffffffff84ccf810>] ? device_private_init+0x180/0x180
[ 1010.497433]  [<ffffffffc00c0f77>] ? usb_new_device+0x707/0x1030 [usbcore]
[ 1010.497441]  [<ffffffffc00c58c5>] ? hub_event+0x1d65/0x3280 [usbcore]
[ 1010.497445]  [<ffffffff841eb4ab>] ? account_entity_dequeue+0x30b/0x4a0
[ 1010.497454]  [<ffffffffc00c3b60>] ? hub_port_debounce+0x280/0x280 [usbcore]
[ 1010.497457]  [<ffffffff8407ccd0>] ? compat_start_thread+0x80/0x80
[ 1010.497460]  [<ffffffff851f5cb4>] ? __schedule+0x704/0x1770
[ 1010.497462]  [<ffffffff851f55b0>] ? io_schedule_timeout+0x390/0x390
[ 1010.497465]  [<ffffffff84541783>] ? cache_reap+0x173/0x200
[ 1010.497468]  [<ffffffff84197bed>] ? process_one_work+0x4ed/0xe60
[ 1010.497470]  [<ffffffff84198642>] ? worker_thread+0xe2/0xfd0
[ 1010.497473]  [<ffffffff8421f76c>] ? __wake_up_common+0xbc/0x160
[ 1010.497475]  [<ffffffff84198560>] ? process_one_work+0xe60/0xe60
[ 1010.497477]  [<ffffffff841a837c>] ? kthread+0x1cc/0x220
[ 1010.497480]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.497482]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.497485]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.497487]  [<ffffffff852016f5>] ? ret_from_fork+0x25/0x30
[ 1010.497489] ---[ end trace 49b46eb633ff1198 ]---
[ 1010.497829] usb 1-3.3: can't device_add, error -17
[ 1010.578707] usb 1-3.3: new high-speed USB device number 10 using xhci_hcd
[ 1010.604448] usb 1-3.3: New USB device found, idVendor=2040, idProduct=6513
[ 1010.604452] usb 1-3.3: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[ 1010.604454] usb 1-3.3: Product: WinTV HVR-980
[ 1010.604456] usb 1-3.3: SerialNumber: 4028449018
[ 1010.605369] ------------[ cut here ]------------
[ 1010.605374] WARNING: CPU: 3 PID: 119 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x7b/0x90
[ 1010.605375] sysfs: cannot create duplicate filename '/bus/usb/devices/1-3.3'
[ 1010.605376] Modules linked in: lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core em28xx tveeprom v4l2_common videodev media xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cmac bnep cpufreq_powersave cpufreq_conservative cpufreq_userspace binfmt_misc parport_pc ppdev lp parport snd_hda_codec_hdmi iTCO_wdt snd_hda_codec_realtek iTCO_vendor_support snd_hda_codec_generic arc4 intel_rapl x86_pkg_temp_thermal iwlmvm intel_powerclamp coretemp kvm_intel mac80211 kvm i915
[ 1010.605415]  irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iwlwifi pl2303 aesni_intel btusb aes_x86_64 usbserial lrw btrtl gf128mul glue_helper btbcm ablk_helper cryptd btintel bluetooth drm_kms_helper cfg80211 drm psmouse pcspkr i2c_i801 e1000e serio_raw snd_hda_intel snd_soc_rt5640 snd_hda_codec snd_soc_rl6231 snd_soc_ssm4567 mei_me i2c_smbus rfkill snd_hda_core ptp mei snd_soc_core ehci_pci sg lpc_ich shpchp mfd_core ehci_hcd pps_core snd_hwdep i2c_algo_bit snd_compress snd_pcm sdhci_acpi snd_timer battery snd sdhci elan_i2c snd_soc_sst_acpi mmc_core fjes dw_dmac i2c_hid soundcore snd_soc_sst_match i2c_designware_platform video i2c_designware_core acpi_pad acpi_als kfifo_buf tpm_tis button industrialio tpm_tis_core tpm ext4 crc16 jbd2 fscrypto mbcache dm_mod joydev evdev hid_logitech_hidpp
[ 1010.605459]  sd_mod hid_logitech_dj usbhid hid ahci libahci crc32c_intel libata xhci_pci xhci_hcd scsi_mod usbcore fan thermal
[ 1010.605469] CPU: 3 PID: 119 Comm: kworker/3:2 Tainted: G        W       4.9.0-rc8+ #14
[ 1010.605471] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[ 1010.605484] Workqueue: usb_hub_wq hub_event [usbcore]
[ 1010.605486]  0000000000000000 ffffffff848f56c5 ffff8803b1f7f858 0000000000000000
[ 1010.605490]  ffffffff8414f8f8 ffff88030000001f ffffed00763eff07 ffff8803b1f7f8f0
[ 1010.605492]  ffff8803b3ea1e60 0000000000000001 ffffffffffffffef ffff8803b45c6840
[ 1010.605495] Call Trace:
[ 1010.605502]  [<ffffffff848f56c5>] ? dump_stack+0x5c/0x77
[ 1010.605505]  [<ffffffff8414f8f8>] ? __warn+0x168/0x1a0
[ 1010.605508]  [<ffffffff8414f9e4>] ? warn_slowpath_fmt+0xb4/0xf0
[ 1010.605510]  [<ffffffff8414f930>] ? __warn+0x1a0/0x1a0
[ 1010.605513]  [<ffffffff845436c6>] ? kasan_kmalloc+0xa6/0xd0
[ 1010.605516]  [<ffffffff846ec2fa>] ? kernfs_path_from_node+0x4a/0x60
[ 1010.605518]  [<ffffffff846f66eb>] ? sysfs_warn_dup+0x7b/0x90
[ 1010.605520]  [<ffffffff846f6f26>] ? sysfs_do_create_link_sd.isra.2+0xb6/0xd0
[ 1010.605524]  [<ffffffff84cd5a08>] ? bus_add_device+0x318/0x6b0
[ 1010.605527]  [<ffffffff846f8693>] ? sysfs_create_groups+0x83/0x110
[ 1010.605529]  [<ffffffff84ccff87>] ? device_add+0x777/0x1350
[ 1010.605532]  [<ffffffff84ccf810>] ? device_private_init+0x180/0x180
[ 1010.605542]  [<ffffffffc00c0f77>] ? usb_new_device+0x707/0x1030 [usbcore]
[ 1010.605550]  [<ffffffffc00c58c5>] ? hub_event+0x1d65/0x3280 [usbcore]
[ 1010.605554]  [<ffffffff841eb4ab>] ? account_entity_dequeue+0x30b/0x4a0
[ 1010.605563]  [<ffffffffc00c3b60>] ? hub_port_debounce+0x280/0x280 [usbcore]
[ 1010.605566]  [<ffffffff8407ccd0>] ? compat_start_thread+0x80/0x80
[ 1010.605569]  [<ffffffff851f5cb4>] ? __schedule+0x704/0x1770
[ 1010.605572]  [<ffffffff851f55b0>] ? io_schedule_timeout+0x390/0x390
[ 1010.605574]  [<ffffffff84541783>] ? cache_reap+0x173/0x200
[ 1010.605577]  [<ffffffff84197bed>] ? process_one_work+0x4ed/0xe60
[ 1010.605579]  [<ffffffff84198642>] ? worker_thread+0xe2/0xfd0
[ 1010.605581]  [<ffffffff8421f76c>] ? __wake_up_common+0xbc/0x160
[ 1010.605584]  [<ffffffff84198560>] ? process_one_work+0xe60/0xe60
[ 1010.605586]  [<ffffffff841a837c>] ? kthread+0x1cc/0x220
[ 1010.605589]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.605591]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.605594]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.605596]  [<ffffffff852016f5>] ? ret_from_fork+0x25/0x30
[ 1010.605598] ---[ end trace 49b46eb633ff1199 ]---
[ 1010.605948] usb 1-3.3: can't device_add, error -17
[ 1010.686729] usb 1-3.3: new high-speed USB device number 11 using xhci_hcd
[ 1010.712761] usb 1-3.3: New USB device found, idVendor=2040, idProduct=6513
[ 1010.712768] usb 1-3.3: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[ 1010.712772] usb 1-3.3: Product: WinTV HVR-980
[ 1010.712775] usb 1-3.3: SerialNumber: 4028449018
[ 1010.714339] ------------[ cut here ]------------
[ 1010.714347] WARNING: CPU: 3 PID: 119 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x7b/0x90
[ 1010.714349] sysfs: cannot create duplicate filename '/bus/usb/devices/1-3.3'
[ 1010.714351] Modules linked in: lgdt330x em28xx_dvb dvb_core em28xx_alsa tuner_xc2028 tuner tvp5150 em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core em28xx tveeprom v4l2_common videodev media xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables x_tables cmac bnep cpufreq_powersave cpufreq_conservative cpufreq_userspace binfmt_misc parport_pc ppdev lp parport snd_hda_codec_hdmi iTCO_wdt snd_hda_codec_realtek iTCO_vendor_support snd_hda_codec_generic arc4 intel_rapl x86_pkg_temp_thermal iwlmvm intel_powerclamp coretemp kvm_intel mac80211 kvm i915
[ 1010.714409]  irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iwlwifi pl2303 aesni_intel btusb aes_x86_64 usbserial lrw btrtl gf128mul glue_helper btbcm ablk_helper cryptd btintel bluetooth drm_kms_helper cfg80211 drm psmouse pcspkr i2c_i801 e1000e serio_raw snd_hda_intel snd_soc_rt5640 snd_hda_codec snd_soc_rl6231 snd_soc_ssm4567 mei_me i2c_smbus rfkill snd_hda_core ptp mei snd_soc_core ehci_pci sg lpc_ich shpchp mfd_core ehci_hcd pps_core snd_hwdep i2c_algo_bit snd_compress snd_pcm sdhci_acpi snd_timer battery snd sdhci elan_i2c snd_soc_sst_acpi mmc_core fjes dw_dmac i2c_hid soundcore snd_soc_sst_match i2c_designware_platform video i2c_designware_core acpi_pad acpi_als kfifo_buf tpm_tis button industrialio tpm_tis_core tpm ext4 crc16 jbd2 fscrypto mbcache dm_mod joydev evdev hid_logitech_hidpp
[ 1010.714475]  sd_mod hid_logitech_dj usbhid hid ahci libahci crc32c_intel libata xhci_pci xhci_hcd scsi_mod usbcore fan thermal
[ 1010.714490] CPU: 3 PID: 119 Comm: kworker/3:2 Tainted: G        W       4.9.0-rc8+ #14
[ 1010.714493] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[ 1010.714513] Workqueue: usb_hub_wq hub_event [usbcore]
[ 1010.714517]  0000000000000000 ffffffff848f56c5 ffff8803b1f7f858 0000000000000000
[ 1010.714522]  ffffffff8414f8f8 ffff88030000001f ffffed00763eff07 ffff8803b1f7f8f0
[ 1010.714527]  ffff8803b3ea1e60 0000000000000001 ffffffffffffffef ffff8803b45c6840
[ 1010.714532] Call Trace:
[ 1010.714543]  [<ffffffff848f56c5>] ? dump_stack+0x5c/0x77
[ 1010.714547]  [<ffffffff8414f8f8>] ? __warn+0x168/0x1a0
[ 1010.714551]  [<ffffffff8414f9e4>] ? warn_slowpath_fmt+0xb4/0xf0
[ 1010.714555]  [<ffffffff8414f930>] ? __warn+0x1a0/0x1a0
[ 1010.714560]  [<ffffffff845436c6>] ? kasan_kmalloc+0xa6/0xd0
[ 1010.714565]  [<ffffffff846ec2fa>] ? kernfs_path_from_node+0x4a/0x60
[ 1010.714568]  [<ffffffff846f66eb>] ? sysfs_warn_dup+0x7b/0x90
[ 1010.714573]  [<ffffffff846f6f26>] ? sysfs_do_create_link_sd.isra.2+0xb6/0xd0
[ 1010.714579]  [<ffffffff84cd5a08>] ? bus_add_device+0x318/0x6b0
[ 1010.714583]  [<ffffffff846f8693>] ? sysfs_create_groups+0x83/0x110
[ 1010.714587]  [<ffffffff84ccff87>] ? device_add+0x777/0x1350
[ 1010.714592]  [<ffffffff84ccf810>] ? device_private_init+0x180/0x180
[ 1010.714608]  [<ffffffffc00c0f77>] ? usb_new_device+0x707/0x1030 [usbcore]
[ 1010.714623]  [<ffffffffc00c58c5>] ? hub_event+0x1d65/0x3280 [usbcore]
[ 1010.714628]  [<ffffffff841eb4ab>] ? account_entity_dequeue+0x30b/0x4a0
[ 1010.714643]  [<ffffffffc00c3b60>] ? hub_port_debounce+0x280/0x280 [usbcore]
[ 1010.714648]  [<ffffffff8407ccd0>] ? compat_start_thread+0x80/0x80
[ 1010.714653]  [<ffffffff851f5cb4>] ? __schedule+0x704/0x1770
[ 1010.714657]  [<ffffffff851f55b0>] ? io_schedule_timeout+0x390/0x390
[ 1010.714661]  [<ffffffff84541783>] ? cache_reap+0x173/0x200
[ 1010.714666]  [<ffffffff84197bed>] ? process_one_work+0x4ed/0xe60
[ 1010.714670]  [<ffffffff84198642>] ? worker_thread+0xe2/0xfd0
[ 1010.714674]  [<ffffffff8421f76c>] ? __wake_up_common+0xbc/0x160
[ 1010.714678]  [<ffffffff84198560>] ? process_one_work+0xe60/0xe60
[ 1010.714682]  [<ffffffff841a837c>] ? kthread+0x1cc/0x220
[ 1010.714686]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.714691]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.714695]  [<ffffffff841a81b0>] ? kthread_park+0x80/0x80
[ 1010.714699]  [<ffffffff852016f5>] ? ret_from_fork+0x25/0x30
[ 1010.714719] ---[ end trace 49b46eb633ff119a ]---
[ 1010.715706] usb 1-3.3: can't device_add, error -17
[ 1010.716223] usb 1-3-port3: unable to enumerate USB device



If so, it seems that the device was not properly unregistered. That's
weird, since everything sounded ok at device unregister:

[  999.740335] usb 1-3.3: em2882!3#0: USB disconnect, device number 7
[  999.742857] usb 1-3.3: em2882!3#0: Disconnecting
[  999.742874] usb 1-3.3: em2882!3#0: Closing video extension
[  999.743058] usb 1-3.3: em2882!3#0: V4L2 device vbi0 deregistered
[  999.744327] usb 1-3.3: em2882!3#0: V4L2 device video0 deregistered
[  999.747938] tvp5150 6-005c: tvp5150.c: removing tvp5150 adapter on address 0xb8
[  999.750085] xc2028 6-0061: xc2028_dvb_release called
[  999.750852] usb 1-3.3: em2882!3#0: Closing audio extension
[  999.754253] usb 1-3.3: em2882!3#0: Closing DVB extension
[  999.760360] xc2028 6-0061: xc2028_dvb_release called
[  999.760362] xc2028 6-0061: free_firmware called
[  999.760958] xc2028 6-0061: destroying instance

I'll try to bisect this.

Regards,
Mauro


Thanks,
Mauro
