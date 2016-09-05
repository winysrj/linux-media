Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55019 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932560AbcIEKcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v2 10/12] [media] cx231xx-cards: unregister IR earlier
Date: Mon,  5 Sep 2016 07:32:38 -0300
Message-Id: <f49fcd95b6a939e0d25eb1afb3bc71300d267c87.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ 1417.425863] cx231xx 1-3.1.4:1.1: Cx231xx dvb Extension removed
[ 1417.571923] BUG: unable to handle kernel paging request at ffffffffc081a024
[ 1417.571962] IP: [<ffffffff813da854>] string+0x24/0x80
[ 1417.571987] PGD 1c09067 PUD 1c0b067 PMD 88e653067 PTE 0
[ 1417.572013] Oops: 0000 [#1] SMP
[ 1417.572026] Modules linked in: mb86a20s dvb_core cx231xx_alsa ir_kbd_i2c(-) tda18271 tea5767 tuner cx25840 cx231xx i2c_mux videobuf_vmalloc tveeprom cx2341x videobuf_core rc_core v4l2_common videodev media bnep usblp fuse xt_CHECKSUM iptable_mangle tun ebtable_filter ebtables ip6table_filter ip6_tables xt_physdev br_netfilter bridge nf_log_ipv4 nf_log_common xt_LOG xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack cpufreq_stats vfat fat snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel snd_hda_intel snd_hda_codec kvm snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm irqbypass crct10dif_pclmul iTCO_wdt crc32_pclmul nfsd hci_uart iTCO_vendor_support
[ 1417.572317]  snd_timer ghash_clmulni_intel btbcm intel_cstate btqca snd intel_uncore btintel intel_rapl_perf mei_me bluetooth mei shpchp soundcore pcspkr i2c_i801 auth_rpcgss wmi acpi_als kfifo_buf nfs_acl industrialio rfkill lockd pinctrl_sunrisepoint pinctrl_intel tpm_tis tpm intel_lpss_acpi intel_lpss acpi_pad grace sunrpc binfmt_misc hid_logitech_hidpp hid_logitech_dj 8021q garp stp llc mrp i915 i2c_algo_bit drm_kms_helper drm e1000e sdhci_pci sdhci mmc_core crc32c_intel ptp pps_core video i2c_hid fjes analog gameport joydev [last unloaded: rc_pixelview_002t]
[ 1417.572487] CPU: 4 PID: 24493 Comm: rmmod Tainted: G        W       4.7.0+ #2
[ 1417.572504] Hardware name:                  /NUC6i7KYB, BIOS KYSKLi70.86A.0041.2016.0817.1130 08/17/2016
[ 1417.572526] task: ffff880894b81e80 ti: ffff880896bdc000 task.ti: ffff880896bdc000
[ 1417.572544] RIP: 0010:[<ffffffff813da854>]  [<ffffffff813da854>] string+0x24/0x80
[ 1417.572564] RSP: 0018:ffff880896bdfbe8  EFLAGS: 00010286
[ 1417.572577] RAX: ffffffffc081a025 RBX: ffff8808935aa15c RCX: ffff0a00ffffff04
[ 1417.572594] RDX: ffffffffc081a024 RSI: ffffffffffffffff RDI: ffff8808935aa15c
[ 1417.572610] RBP: ffff880896bdfbe8 R08: fffffffffffffffe R09: ffff8808935aa91c
[ 1417.572628] R10: ffffffffc07b85d6 R11: 0000000000000000 R12: ffff8808935aa91c
[ 1417.572644] R13: 00000000000007c5 R14: ffffffffc07b85dd R15: ffffffffc07b85dd
[ 1417.572662] FS:  00007f5a5392d700(0000) GS:ffff8808bed00000(0000) knlGS:0000000000000000
[ 1417.572681] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1417.572705] CR2: ffffffffc081a024 CR3: 0000000897188000 CR4: 00000000003406e0
[ 1417.572735] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1417.572761] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1417.572778] Stack:
[ 1417.572785]  ffff880896bdfc48 ffffffff813dcf77 0000000000000005 ffff8808935aa157
[ 1417.572806]  ffff880896bdfc58 ffff0a00ffffff04 000000009d27375e ffff8808935aa000
[ 1417.572829]  0000000000000800 ffff880896182800 0000000000000000 ffff88089e898ae0
[ 1417.572850] Call Trace:
[ 1417.572860]  [<ffffffff813dcf77>] vsnprintf+0x2d7/0x500
[ 1417.572873]  [<ffffffff813d3e12>] add_uevent_var+0x82/0x120
[ 1417.572890]  [<ffffffffc07b534d>] rc_dev_uevent+0x2d/0x60 [rc_core]
[ 1417.572907]  [<ffffffff81515969>] dev_uevent+0xd9/0x2d0
[ 1417.572921]  [<ffffffff813d4309>] kobject_uevent_env+0x2d9/0x4f0
[ 1417.572938]  [<ffffffff813d452b>] kobject_uevent+0xb/0x10
[ 1417.572954]  [<ffffffff81513a3f>] device_del+0x18f/0x260
[ 1417.572974]  [<ffffffff813d2db7>] ? kobject_put+0x27/0x50
[ 1417.572998]  [<ffffffffc07b5e25>] rc_unregister_device+0x75/0xb0 [rc_core]
[ 1417.573028]  [<ffffffffc07e6023>] ir_remove+0x23/0x30 [ir_kbd_i2c]
[ 1417.573055]  [<ffffffff8162bf88>] i2c_device_remove+0x58/0xb0
[ 1417.573078]  [<ffffffff81518191>] __device_release_driver+0xa1/0x160
[ 1417.573102]  [<ffffffff81518de6>] driver_detach+0xa6/0xb0
[ 1417.573122]  [<ffffffff81517b25>] bus_remove_driver+0x55/0xd0
[ 1417.573146]  [<ffffffff815195bc>] driver_unregister+0x2c/0x50
[ 1417.573168]  [<ffffffff8162cf62>] i2c_del_driver+0x22/0x50
[ 1417.573194]  [<ffffffffc07e6ba4>] ir_kbd_driver_exit+0x10/0x46c [ir_kbd_i2c]
[ 1417.573227]  [<ffffffff81126348>] SyS_delete_module+0x1b8/0x220
[ 1417.573254]  [<ffffffff817debf2>] entry_SYSCALL_64_fastpath+0x1a/0xa4
[ 1417.573279] Code: eb e9 76 ff ff ff 90 55 49 89 f1 48 89 ce 48 c1 fe 30 48 81 fa ff 0f 00 00 48 89 e5 4c 8d 46 ff 76 40 48 85 f6 74 4e 48 8d 42 01 <0f> b6 12 84 d2 74 43 49 01 c0 31 f6 eb 0c 48 83 c0 01 0f b6 50
[ 1417.573437] RIP  [<ffffffff813da854>] string+0x24/0x80
[ 1417.573455]  RSP <ffff880896bdfbe8>
[ 1417.573465] CR2: ffffffffc081a024
[ 1417.580053] ---[ end trace 4ca9e2eced326a62 ]---

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 72c246bfaa1c..36bc25494319 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1186,12 +1186,12 @@ static void cx231xx_unregister_media_device(struct cx231xx *dev)
 */
 void cx231xx_release_resources(struct cx231xx *dev)
 {
+	cx231xx_ir_exit(dev);
+
 	cx231xx_release_analog_resources(dev);
 
 	cx231xx_remove_from_devlist(dev);
 
-	cx231xx_ir_exit(dev);
-
 	/* Release I2C buses */
 	cx231xx_dev_uninit(dev);
 
-- 
2.7.4


