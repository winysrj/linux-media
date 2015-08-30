Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48504 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbbH3DHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: [PATCH v8 54/55] [media] au0828: unregister MC at the end
Date: Sun, 30 Aug 2015 00:07:05 -0300
Message-Id: <14e1926c1fdb883abc4d200913cd02371be694f4.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

au0828_analog_unregister() calls video_unregister_device(),
with, in turn, calls media_devnode_remove() in order to drop
the media interfaces.

We can't release the media controller before that, or an
OOPS will occur:

[  176.938752] usb 1-4.4: Media device released
[  176.938753] usb 1-4.4: Media device unregistered
[  177.091235] general protection fault: 0000 [#1] SMP
[  177.091253] Modules linked in: ir_lirc_codec ir_xmp_decoder lirc_dev ir_mce_kbd_decoder ir_sharp_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_nec_decoder ir_rc5_decoder au8522_dig xc5000 tuner au8522_decoder au8522_common au0828(-) videobuf2_vmalloc videobuf2_memops tveeprom videobuf2_core dvb_core rc_core v4l2_common videodev media cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport snd_hda_codec_hdmi i915 x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm_intel kvm btusb crct10dif_pclmul snd_hda_codec_realtek crc32_pclmul btrtl crc32c_intel btbcm snd_hda_codec_generic ghash_clmulni_intel btintel i2c_algo_bit drm_kms_helper bluetooth iTCO_wdt snd_usb_audio snd_hda_intel iTCO_vendor_support jitterentropy_rng
[  177.091455]  snd_hda_codec evdev sha256_ssse3 drm sha256_generic hmac snd_usbmidi_lib snd_hwdep snd_hda_core snd_rawmidi drbg snd_seq_device snd_pcm aesni_intel aes_x86_64 lrw gf128mul mei_me glue_helper snd_timer ablk_helper cryptd mei rfkill snd psmouse sg shpchp soundcore lpc_ich serio_raw i2c_i801 pcspkr mfd_core tpm_tis tpm battery dw_dmac video i2c_designware_platform dw_dmac_core i2c_designware_core acpi_pad processor button ext4 crc16 mbcache jbd2 dm_mod sd_mod ahci libahci libata e1000e scsi_mod ptp pps_core ehci_pci xhci_pci ehci_hcd xhci_hcd thermal fan thermal_sys sdhci_acpi sdhci mmc_core i2c_hid hid [last unloaded: rc_core]
[  177.091632] CPU: 1 PID: 18040 Comm: rmmod Tainted: G        W       4.2.0-rc2+ #9
[  177.091648] Hardware name: \xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff \xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff\xffffffff/NUC5i7RYB, BIOS RYBDWi35.86A.0246.2015.0309.1355 03/09/2015
[  177.091677] task: ffff88040811b080 ti: ffff880036b88000 task.ti: ffff880036b88000
[  177.091693] RIP: 0010:[<ffffffff810aecc3>]  [<ffffffff810aecc3>] native_queued_spin_lock_slowpath+0x103/0x180
[  177.091718] RSP: 0018:ffff880036b8bcd8  EFLAGS: 00010202
[  177.091730] RAX: 0000000000003ffe RBX: ffff880407e11b70 RCX: ffff88041ec962c0
[  177.091745] RDX: 7463656a62506357 RSI: 0000000000080000 RDI: ffff880407e11b74
[  177.091760] RBP: ffff880407e11b74 R08: 0000000000000001 R09: ffffffff812bf4e0
[  177.091776] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88040811b080
[  177.091791] R13: ffff88003601cec8 R14: ffff8804084b8890 R15: ffff8804084b8800
[  177.091807] FS:  00007f2f9bab1700(0000) GS:ffff88041ec80000(0000) knlGS:0000000000000000
[  177.091824] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  177.091837] CR2: 00007fe8c0f900e0 CR3: 0000000035c47000 CR4: 00000000003407e0
[  177.091852] Stack:
[  177.091857]  ffffffff81562e3d ffffffff815613b3 0000000000000000 0000000000000000
[  177.091876]  ffff88040b6d3240 ffff8804084b8890 ffff880407e11b70 ffff88003601cd30
[  177.091895]  ffff88003601ce28 ffff88003601cec8 ffff8804084b8890 ffffffff8156148b
[  177.091914] Call Trace:
[  177.091923]  [<ffffffff81562e3d>] ? _raw_spin_lock+0x1d/0x20
[  177.091936]  [<ffffffff815613b3>] ? __mutex_lock_slowpath+0x43/0x100
[  177.091951]  [<ffffffff8156148b>] ? mutex_lock+0x1b/0x30
[  177.091965]  [<ffffffffa028480d>] ? media_remove_intf_links+0x1d/0x40 [media]
[  177.091981]  [<ffffffffa028483e>] ? media_devnode_remove+0xe/0x20 [media]
[  177.091997]  [<ffffffffa063d875>] ? v4l2_device_release+0x95/0x100 [videodev]
[  177.092014]  [<ffffffff813ca19d>] ? device_release+0x2d/0x90
[  177.092028]  [<ffffffff812be5e9>] ? kobject_release+0x79/0x1b0
[  177.092042]  [<ffffffffa07b19ea>] ? au0828_analog_unregister+0x2a/0x60 [au0828]
[  177.092059]  [<ffffffffa07ac10e>] ? au0828_usb_disconnect+0x9e/0xd0 [au0828]
[  177.092075]  [<ffffffff8140e609>] ? usb_unbind_interface+0x79/0x270
[  177.092090]  [<ffffffff813cf285>] ? __device_release_driver+0x95/0x130
[  177.092105]  [<ffffffff813cf41b>] ? driver_detach+0xab/0xb0
[  177.092120]  [<ffffffff813ce4c5>] ? bus_remove_driver+0x55/0xd0
[  177.092134]  [<ffffffff8140d951>] ? usb_deregister+0x71/0xc0
[  177.092148]  [<ffffffff810e438a>] ? SyS_delete_module+0x1aa/0x250
[  177.092163]  [<ffffffff81088ee9>] ? task_work_run+0x89/0xc0
[  177.092176]  [<ffffffff815631f2>] ? entry_SYSCALL_64_fastpath+0x16/0x75
[  177.092191] Code: 87 47 02 c1 e0 10 85 c0 74 38 48 89 c2 c1 e8 12 48 c1 ea 0c 83 e8 01 83 e2 30 48 98 48 81 c2 c0 62 01 00 48 03 14 c5 c0 62 90 81 <48> 89 0a 8b 41 08 85 c0 75 0d f3 90 8b 41 08 85 c0 74 f7 eb 02
[  177.092281] RIP  [<ffffffff810aecc3>] native_queued_spin_lock_slowpath+0x103/0x180
[  177.092299]  RSP <ffff880036b8bcd8>
[  177.097721] ---[ end trace b12d5a66f4c6f1c1 ]---
[  177.243899] lirc_dev: module unloaded

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 7f645bcb7463..e28cabe65934 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -175,8 +175,6 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 	*/
 	dev->dev_state = DEV_DISCONNECTED;
 
-	au0828_unregister_media_device(dev);
-
 	au0828_rc_unregister(dev);
 	/* Digital TV */
 	au0828_dvb_unregister(dev);
@@ -193,6 +191,8 @@ static void au0828_usb_disconnect(struct usb_interface *interface)
 		return;
 	}
 #endif
+	au0828_unregister_media_device(dev);
+
 	au0828_usb_release(dev);
 }
 
-- 
2.4.3

