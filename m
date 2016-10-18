Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51617 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935296AbcJRUqY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 18/58] ttpci: don't break long lines
Date: Tue, 18 Oct 2016 18:45:30 -0200
Message-Id: <ebeb6b8948107a252cc78564c497c3c9737a64e8.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476822924.git.mchehab@s-opensource.com>
References: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols restrictions, and latter due to checkpatch
warnings, several strings were broken into multiple lines. This
is not considered a good practice anymore, as it makes harder
to grep for strings at the source code.

As we're right now fixing other drivers due to KERN_CONT, we need
to be able to identify what printk strings don't end with a "\n".
It is a way easier to detect those if we don't break long lines.

So, join those continuation lines.

The patch was generated via the script below, and manually
adjusted if needed.

</script>
use Text::Tabs;
while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			$n = expand($next);
			$funpos = index($n, '(');
			$pos = index($c2, '",');
			if ($funpos && $pos > 0) {
				$s1 = substr $c2, 0, $pos + 2;
				$s2 = ' ' x ($funpos + 1) . substr $c2, $pos + 2;
				$s2 =~ s/^\s+//;

				$s2 = ' ' x ($funpos + 1) . $s2 if ($s2 ne "");

				print unexpand("$next$s1\n");
				print unexpand("$s2\n") if ($s2 ne "");
			} else {
				print "$next$c2\n";
			}
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}
</script>

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ttpci/av7110.c       | 29 +++++++++++------------------
 drivers/media/pci/ttpci/av7110_hw.c    | 12 ++++--------
 drivers/media/pci/ttpci/budget-av.c    |  3 +--
 drivers/media/pci/ttpci/budget-ci.c    |  4 +---
 drivers/media/pci/ttpci/budget-patch.c |  3 +--
 drivers/media/pci/ttpci/budget.c       |  3 +--
 drivers/media/pci/ttpci/ttpci-eeprom.c |  3 +--
 7 files changed, 20 insertions(+), 37 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 382caf200ba1..de84aa1b41f1 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -100,8 +100,7 @@ MODULE_PARM_DESC(adac,"audio DAC type: 0 TI, 1 CRYSTAL, 2 MSP (use if autodetect
 module_param(hw_sections, int, 0444);
 MODULE_PARM_DESC(hw_sections, "0 use software section filter, 1 use hardware");
 module_param(rgb_on, int, 0444);
-MODULE_PARM_DESC(rgb_on, "For Siemens DVB-C cards only: Enable RGB control"
-		" signal on SCART pin 16 to switch SCART video mode from CVBS to RGB");
+MODULE_PARM_DESC(rgb_on, "For Siemens DVB-C cards only: Enable RGB control signal on SCART pin 16 to switch SCART video mode from CVBS to RGB");
 module_param(volume, int, 0444);
 MODULE_PARM_DESC(volume, "initial volume: default 255 (range 0-255)");
 module_param(budgetpatch, int, 0444);
@@ -833,8 +832,7 @@ static int StartHWFilter(struct dvb_demux_filter *dvbdmxfilter)
 
 	ret = av7110_fw_request(av7110, buf, 20, &handle, 1);
 	if (ret != 0 || handle >= 32) {
-		printk("dvb-ttpci: %s error  buf %04x %04x %04x %04x  "
-				"ret %d  handle %04x\n",
+		printk("dvb-ttpci: %s error  buf %04x %04x %04x %04x  ret %d  handle %04x\n",
 				__func__, buf[0], buf[1], buf[2], buf[3],
 				ret, handle);
 		dvbdmxfilter->hw_handle = 0xffff;
@@ -876,8 +874,7 @@ static int StopHWFilter(struct dvb_demux_filter *dvbdmxfilter)
 	buf[2] = handle;
 	ret = av7110_fw_request(av7110, buf, 3, answ, 2);
 	if (ret != 0 || answ[1] != handle) {
-		printk("dvb-ttpci: %s error  cmd %04x %04x %04x  ret %x  "
-				"resp %04x %04x  pid %d\n",
+		printk("dvb-ttpci: %s error  cmd %04x %04x %04x  ret %x  resp %04x %04x  pid %d\n",
 				__func__, buf[0], buf[1], buf[2], ret,
 				answ[0], answ[1], dvbdmxfilter->feed->pid);
 		if (!ret)
@@ -1532,15 +1529,12 @@ static int get_firmware(struct av7110* av7110)
 	ret = request_firmware(&fw, "dvb-ttpci-01.fw", &av7110->dev->pci->dev);
 	if (ret) {
 		if (ret == -ENOENT) {
-			printk(KERN_ERR "dvb-ttpci: could not load firmware,"
-			       " file not found: dvb-ttpci-01.fw\n");
-			printk(KERN_ERR "dvb-ttpci: usually this should be in "
-			       "/usr/lib/hotplug/firmware or /lib/firmware\n");
-			printk(KERN_ERR "dvb-ttpci: and can be downloaded from"
-			       " https://linuxtv.org/download/dvb/firmware/\n");
+			printk(KERN_ERR "dvb-ttpci: could not load firmware, file not found: dvb-ttpci-01.fw\n");
+			printk(KERN_ERR "dvb-ttpci: usually this should be in /usr/lib/hotplug/firmware or /lib/firmware\n");
+			printk(KERN_ERR "dvb-ttpci: and can be downloaded from https://linuxtv.org/download/dvb/firmware/\n");
 		} else
-			printk(KERN_ERR "dvb-ttpci: cannot request firmware"
-			       " (error %i)\n", ret);
+			printk(KERN_ERR "dvb-ttpci: cannot request firmware (error %i)\n",
+			       ret);
 		return -EINVAL;
 	}
 
@@ -2700,8 +2694,8 @@ static int av7110_attach(struct saa7146_dev* dev,
 		goto err_stop_arm_9;
 
 	if (FW_VERSION(av7110->arm_app)<0x2501)
-		printk ("dvb-ttpci: Warning, firmware version 0x%04x is too old. "
-			"System might be unstable!\n", FW_VERSION(av7110->arm_app));
+		printk ("dvb-ttpci: Warning, firmware version 0x%04x is too old. System might be unstable!\n",
+			FW_VERSION(av7110->arm_app));
 
 	thread = kthread_run(arm_thread, (void *) av7110, "arm_mon");
 	if (IS_ERR(thread)) {
@@ -2944,7 +2938,6 @@ static void __exit av7110_exit(void)
 module_init(av7110_init);
 module_exit(av7110_exit);
 
-MODULE_DESCRIPTION("driver for the SAA7146 based AV110 PCI DVB cards by "
-		   "Siemens, Technotrend, Hauppauge");
+MODULE_DESCRIPTION("driver for the SAA7146 based AV110 PCI DVB cards by Siemens, Technotrend, Hauppauge");
 MODULE_AUTHOR("Ralph Metzler, Marcus Metzler, others");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/pci/ttpci/av7110_hw.c b/drivers/media/pci/ttpci/av7110_hw.c
index 0583d56ef5ef..520414cbe087 100644
--- a/drivers/media/pci/ttpci/av7110_hw.c
+++ b/drivers/media/pci/ttpci/av7110_hw.c
@@ -235,8 +235,7 @@ int av7110_bootarm(struct av7110 *av7110)
 	iwdebi(av7110, DEBISWAP, DPRAM_BASE, 0x76543210, 4);
 
 	if ((ret=irdebi(av7110, DEBINOSWAP, DPRAM_BASE, 0, 4)) != 0x10325476) {
-		printk(KERN_ERR "dvb-ttpci: debi test in av7110_bootarm() failed: "
-		       "%08x != %08x (check your BIOS 'Plug&Play OS' settings)\n",
+		printk(KERN_ERR "dvb-ttpci: debi test in av7110_bootarm() failed: %08x != %08x (check your BIOS 'Plug&Play OS' settings)\n",
 		       ret, 0x10325476);
 		return -1;
 	}
@@ -262,8 +261,7 @@ int av7110_bootarm(struct av7110 *av7110)
 	iwdebi(av7110, DEBINOSWAP, AV7110_BOOT_STATE, BOOTSTATE_BUFFER_FULL, 2);
 
 	if (saa7146_wait_for_debi_done(av7110->dev, 1)) {
-		printk(KERN_ERR "dvb-ttpci: av7110_bootarm(): "
-		       "saa7146_wait_for_debi_done() timed out\n");
+		printk(KERN_ERR "dvb-ttpci: av7110_bootarm(): saa7146_wait_for_debi_done() timed out\n");
 		return -ETIMEDOUT;
 	}
 	saa7146_setgpio(dev, RESET_LINE, SAA7146_GPIO_OUTHI);
@@ -271,8 +269,7 @@ int av7110_bootarm(struct av7110 *av7110)
 
 	dprintk(1, "load dram code\n");
 	if (load_dram(av7110, (u32 *)av7110->bin_root, av7110->size_root) < 0) {
-		printk(KERN_ERR "dvb-ttpci: av7110_bootarm(): "
-		       "load_dram() failed\n");
+		printk(KERN_ERR "dvb-ttpci: av7110_bootarm(): load_dram() failed\n");
 		return -1;
 	}
 
@@ -283,8 +280,7 @@ int av7110_bootarm(struct av7110 *av7110)
 	mwdebi(av7110, DEBISWAB, DPRAM_BASE, av7110->bin_dpram, av7110->size_dpram);
 
 	if (saa7146_wait_for_debi_done(av7110->dev, 1)) {
-		printk(KERN_ERR "dvb-ttpci: av7110_bootarm(): "
-		       "saa7146_wait_for_debi_done() timed out after loading DRAM\n");
+		printk(KERN_ERR "dvb-ttpci: av7110_bootarm(): saa7146_wait_for_debi_done() timed out after loading DRAM\n");
 		return -ETIMEDOUT;
 	}
 	saa7146_setgpio(dev, RESET_LINE, SAA7146_GPIO_OUTHI);
diff --git a/drivers/media/pci/ttpci/budget-av.c b/drivers/media/pci/ttpci/budget-av.c
index 6f0d0161970e..896c66d4b3ae 100644
--- a/drivers/media/pci/ttpci/budget-av.c
+++ b/drivers/media/pci/ttpci/budget-av.c
@@ -1636,5 +1636,4 @@ module_exit(budget_av_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ralph Metzler, Marcus Metzler, Michael Hunold, others");
-MODULE_DESCRIPTION("driver for the SAA7146 based so-called "
-		   "budget PCI DVB w/ analog input and CI-module (e.g. the KNC cards)");
+MODULE_DESCRIPTION("driver for the SAA7146 based so-called budget PCI DVB w/ analog input and CI-module (e.g. the KNC cards)");
diff --git a/drivers/media/pci/ttpci/budget-ci.c b/drivers/media/pci/ttpci/budget-ci.c
index 7b27af4d9658..20ad93bf0f54 100644
--- a/drivers/media/pci/ttpci/budget-ci.c
+++ b/drivers/media/pci/ttpci/budget-ci.c
@@ -1586,6 +1586,4 @@ module_exit(budget_ci_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Hunold, Jack Thomasson, Andrew de Quincey, others");
-MODULE_DESCRIPTION("driver for the SAA7146 based so-called "
-		   "budget PCI DVB cards w/ CI-module produced by "
-		   "Siemens, Technotrend, Hauppauge");
+MODULE_DESCRIPTION("driver for the SAA7146 based so-called budget PCI DVB cards w/ CI-module produced by Siemens, Technotrend, Hauppauge");
diff --git a/drivers/media/pci/ttpci/budget-patch.c b/drivers/media/pci/ttpci/budget-patch.c
index 591dbdfa2a13..f152eda0123a 100644
--- a/drivers/media/pci/ttpci/budget-patch.c
+++ b/drivers/media/pci/ttpci/budget-patch.c
@@ -679,5 +679,4 @@ module_exit(budget_patch_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Emard, Roberto Deza, Holger Waechtler, Michael Hunold, others");
-MODULE_DESCRIPTION("Driver for full TS modified DVB-S SAA7146+AV7110 "
-		   "based so-called Budget Patch cards");
+MODULE_DESCRIPTION("Driver for full TS modified DVB-S SAA7146+AV7110 based so-called Budget Patch cards");
diff --git a/drivers/media/pci/ttpci/budget.c b/drivers/media/pci/ttpci/budget.c
index fb8ede5a1531..3091b480ce22 100644
--- a/drivers/media/pci/ttpci/budget.c
+++ b/drivers/media/pci/ttpci/budget.c
@@ -897,5 +897,4 @@ module_exit(budget_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ralph Metzler, Marcus Metzler, Michael Hunold, others");
-MODULE_DESCRIPTION("driver for the SAA7146 based so-called "
-		   "budget PCI DVB cards by Siemens, Technotrend, Hauppauge");
+MODULE_DESCRIPTION("driver for the SAA7146 based so-called budget PCI DVB cards by Siemens, Technotrend, Hauppauge");
diff --git a/drivers/media/pci/ttpci/ttpci-eeprom.c b/drivers/media/pci/ttpci/ttpci-eeprom.c
index 079ee098b7e3..9534f29c1ffd 100644
--- a/drivers/media/pci/ttpci/ttpci-eeprom.c
+++ b/drivers/media/pci/ttpci/ttpci-eeprom.c
@@ -171,5 +171,4 @@ EXPORT_SYMBOL(ttpci_eeprom_parse_mac);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ralph Metzler, Marcus Metzler, others");
-MODULE_DESCRIPTION("Decode dvb_net MAC address from EEPROM of PCI DVB cards "
-		"made by Siemens, Technotrend, Hauppauge");
+MODULE_DESCRIPTION("Decode dvb_net MAC address from EEPROM of PCI DVB cards made by Siemens, Technotrend, Hauppauge");
-- 
2.7.4


