Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36893 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549AbcA2RNH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 12:13:07 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/3] [media] em28xx: avoid divide by zero error
Date: Fri, 29 Jan 2016 15:11:59 -0200
Message-Id: <c4a64765cfc77b588efaa8943b468c622efaa487.1454087508.git.mchehab@osg.samsung.com>
In-Reply-To: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
References: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
In-Reply-To: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
References: <759f0a1be7c9e2937056189acdd7338e737d609f.1454087508.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ 1841.243670] divide error: 0000 [#1] SMP KASAN
[ 1841.243994] Modules linked in: em28xx_rc rc_core tda18271 drxk em28xx_dvb dvb_core em28xx_alsa mt9v011 em28xx_v4l videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core em28xx tveeprom v4l2_common videodev media cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha256_ssse3 sha256_generic hmac drbg i915 snd_hda_codec_realtek snd_hda_codec_generic aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd btusb i2c_algo_bit snd_hda_intel btrtl drm_kms_helper btbcm evdev snd_hda_codec btintel psmouse bluetooth pcspkr snd_hwdep sg drm serio_raw
[ 1841.244845]  snd_hda_core snd_pcm mei_me rfkill snd_timer mei snd lpc_ich soundcore shpchp i2c_i801 mfd_core battery dw_dmac i2c_designware_platform i2c_designware_core dw_dmac_core video acpi_pad button tpm_tis tpm ext4 crc16 mbcache jbd2 dm_mod hid_generic usbhid sd_mod ahci libahci libata ehci_pci e1000e xhci_pci ptp scsi_mod ehci_hcd xhci_hcd pps_core fan thermal sdhci_acpi sdhci mmc_core i2c_hid hid [last unloaded: tveeprom]
[ 1841.245342] CPU: 2 PID: 38 Comm: kworker/2:1 Tainted: G        W       4.5.0-rc1+ #43
[ 1841.245413] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
[ 1841.245503] Workqueue: events request_module_async [em28xx]
[ 1841.245557] task: ffff88009df10000 ti: ffff88009df18000 task.ti: ffff88009df18000
[ 1841.245626] RIP: 0010:[<ffffffffa135a0ad>]  [<ffffffffa135a0ad>] size_to_scale+0xed/0x2c0 [em28xx_v4l]
[ 1841.245714] RSP: 0018:ffff88009df1faa8  EFLAGS: 00010246
[ 1841.245756] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8803bb933b38
[ 1841.245815] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8803bb933b00
[ 1841.245879] RBP: ffff88009df1fad8 R08: ffff8803bb933b3c R09: 1ffff10077726760
[ 1841.245944] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 1841.246006] R13: 0000000000000000 R14: dffffc0000000000 R15: ffff8803b391a130
[ 1841.246071] FS:  0000000000000000(0000) GS:ffff8803c6900000(0000) knlGS:0000000000000000
[ 1841.246141] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1841.246194] CR2: 0000000001d97008 CR3: 00000003bdd85000 CR4: 00000000003406e0
[ 1841.246256] Stack:
[ 1841.246278]  0000000000000246 ffff8803bb9321f0 ffff8803bb932270 ffffffffa136f7a0
[ 1841.246359]  0000000000000000 ffff8803bb932130 ffff88009df1fb20 ffffffffa13646a0
[ 1841.246439]  ffffffffa127f206 ffff8803bb932130 ffff8803bb932130 ffff8803b391a130
[ 1841.246517] Call Trace:
[ 1841.246548]  [<ffffffffa13646a0>] em28xx_set_video_format+0x140/0x1e0 [em28xx_v4l]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8c87f3fbd0cf..86db1e1f8ab5 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1232,6 +1232,12 @@ static void scale_to_size(struct em28xx *dev,
 
 	*width = (((unsigned long)maxw) << 12) / (hscale + 4096L);
 	*height = (((unsigned long)maxh) << 12) / (vscale + 4096L);
+
+	/* Don't let width or height to be zero */
+	if (*width < 1)
+		*width = 1;
+	if (*height < 1)
+		*height = 1;
 }
 
 /* ------------------------------------------------------------------
@@ -1307,6 +1313,11 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		v4l_bound_align_image(&width, 48, maxw, 1, &height, 32, maxh,
 				      1, 0);
 	}
+	/* Avoid division by zero at size_to_scale */
+	if (width < 1)
+		width = 1;
+	if (height < 1)
+		height = 1;
 
 	size_to_scale(dev, width, height, &hscale, &vscale);
 	scale_to_size(dev, hscale, vscale, &width, &height);
-- 
2.5.0

