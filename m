Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbcBDSNT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 13:13:19 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] saa7134-alsa: Only frees registered sound cards
Date: Thu,  4 Feb 2016 16:12:04 -0200
Message-Id: <faf29e3907b4365a12277c99c3f9e5f4bfe601dd.1454609519.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That prevents this bug:
[ 2382.269496] BUG: unable to handle kernel NULL pointer dereference at 0000000000000540
[ 2382.270013] IP: [<ffffffffa01fe616>] snd_card_free+0x36/0x70 [snd]
[ 2382.270013] PGD 0
[ 2382.270013] Oops: 0002 [#1] SMP
[ 2382.270013] Modules linked in: saa7134_alsa(-) tda1004x saa7134_dvb videobuf2_dvb dvb_core tda827x tda8290 tuner saa7134 tveeprom videobuf2_dma_sg videobuf2_memops videobuf2_v4l2 videobuf2_core v4l2_common videodev media auth_rpcgss nfsv4 dns_resolver nfs lockd grace sunrpc tun bridge stp llc ebtables ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack it87 hwmon_vid snd_hda_codec_idt snd_hda_codec_generic iTCO_wdt iTCO_vendor_support snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core snd_seq pcspkr i2c_i801 snd_seq_device snd_pcm snd_timer lpc_ich snd mfd_core soundcore binfmt_misc i915 video i2c_algo_bit drm_kms_helper drm r8169 ata_generic serio_raw pata_acpi mii i2c_core [last unloaded: videobuf2_memops]
[ 2382.270013] CPU: 0 PID: 4899 Comm: rmmod Not tainted 4.5.0-rc1+ #4
[ 2382.270013] Hardware name: PCCHIPS P17G/P17G, BIOS 080012  05/14/2008
[ 2382.270013] task: ffff880039c38000 ti: ffff88003c764000 task.ti: ffff88003c764000
[ 2382.270013] RIP: 0010:[<ffffffffa01fe616>]  [<ffffffffa01fe616>] snd_card_free+0x36/0x70 [snd]
[ 2382.270013] RSP: 0018:ffff88003c767ea0  EFLAGS: 00010286
[ 2382.270013] RAX: ffff88003c767eb8 RBX: 0000000000000000 RCX: 0000000000006260
[ 2382.270013] RDX: ffffffffa020a060 RSI: ffffffffa0206de1 RDI: ffff88003c767eb0
[ 2382.270013] RBP: ffff88003c767ed8 R08: 0000000000019960 R09: ffffffff811a5412
[ 2382.270013] R10: ffffea0000d7c200 R11: 0000000000000000 R12: ffff88003c767ea8
[ 2382.270013] R13: 00007ffe760617f7 R14: 0000000000000000 R15: 0000557625d7f1e0
[ 2382.270013] FS:  00007f80bb1c0700(0000) GS:ffff88003f400000(0000) knlGS:0000000000000000
[ 2382.270013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2382.270013] CR2: 0000000000000540 CR3: 000000003c00f000 CR4: 00000000000006f0
[ 2382.270013] Stack:
[ 2382.270013]  000000003c767ed8 ffffffff00000000 ffff880000000000 ffff88003c767eb8
[ 2382.270013]  ffff88003c767eb8 ffffffffa049a890 00007ffe76060060 ffff88003c767ef0
[ 2382.270013]  ffffffffa049889d ffffffffa049a500 ffff88003c767f48 ffffffff8111079c
[ 2382.270013] Call Trace:
[ 2382.270013]  [<ffffffffa049889d>] saa7134_alsa_exit+0x1d/0x780 [saa7134_alsa]
[ 2382.270013]  [<ffffffff8111079c>] SyS_delete_module+0x19c/0x1f0
[ 2382.270013]  [<ffffffff8170fc2e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 2382.270013] Code: 20 a0 48 c7 c6 e1 6d 20 a0 48 89 e5 41 54 53 4c 8d 65 d0 48 89 fb 48 83 ec 28 c7 45 d0 00 00 00 00 49 8d 7c 24 08 e8 7a 55 ed e0 <4c> 89 a3 40 05 00 00 48 89 df e8 eb fd ff ff 85 c0 75 1a 48 8d
[ 2382.270013] RIP  [<ffffffffa01fe616>] snd_card_free+0x36/0x70 [snd]
[ 2382.270013]  RSP <ffff88003c767ea0>
[ 2382.270013] CR2: 0000000000000540

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/saa7134/saa7134-alsa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-alsa.c b/drivers/media/pci/saa7134/saa7134-alsa.c
index 1d2c310ce838..94f816244407 100644
--- a/drivers/media/pci/saa7134/saa7134-alsa.c
+++ b/drivers/media/pci/saa7134/saa7134-alsa.c
@@ -1211,6 +1211,8 @@ static int alsa_device_init(struct saa7134_dev *dev)
 
 static int alsa_device_exit(struct saa7134_dev *dev)
 {
+	if (!snd_saa7134_cards[dev->nr])
+		return 1;
 
 	snd_card_free(snd_saa7134_cards[dev->nr]);
 	snd_saa7134_cards[dev->nr] = NULL;
@@ -1260,7 +1262,8 @@ static void saa7134_alsa_exit(void)
 	int idx;
 
 	for (idx = 0; idx < SNDRV_CARDS; idx++) {
-		snd_card_free(snd_saa7134_cards[idx]);
+		if (snd_saa7134_cards[idx])
+			snd_card_free(snd_saa7134_cards[idx]);
 	}
 
 	saa7134_dmasound_init = NULL;
-- 
2.5.0

