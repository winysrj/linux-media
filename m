Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51413 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754786AbcJRUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH v2 09/58] cx88: don't break long lines
Date: Tue, 18 Oct 2016 18:45:21 -0200
Message-Id: <8a242e8c9fdc721e5d840e74e74991bf7f026914.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/pci/cx88/cx88-alsa.c    | 15 ++++++---------
 drivers/media/pci/cx88/cx88-cards.c   | 14 ++++++--------
 drivers/media/pci/cx88/cx88-dsp.c     | 12 ++++++------
 drivers/media/pci/cx88/cx88-dvb.c     |  6 ++----
 drivers/media/pci/cx88/cx88-i2c.c     |  3 +--
 drivers/media/pci/cx88/cx88-mpeg.c    | 15 +++++++--------
 drivers/media/pci/cx88/cx88-tvaudio.c |  6 ++----
 drivers/media/pci/cx88/cx88-video.c   |  4 ++--
 8 files changed, 32 insertions(+), 43 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 723f06462104..c2efd14293bf 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -120,9 +120,7 @@ MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(CX88_VERSION);
 
-MODULE_SUPPORTED_DEVICE("{{Conexant,23881},"
-			"{{Conexant,23882},"
-			"{{Conexant,23883}");
+MODULE_SUPPORTED_DEVICE("{{Conexant,23881},{{Conexant,23882},{{Conexant,23883}");
 static unsigned int debug;
 module_param(debug,int,0644);
 MODULE_PARM_DESC(debug,"enable debug messages");
@@ -154,8 +152,8 @@ static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
 	cx_write(MO_AUDD_GPCNTRL, GP_COUNT_CONTROL_RESET);
 	atomic_set(&chip->count, 0);
 
-	dprintk(1, "Start audio DMA, %d B/line, %d lines/FIFO, %d periods, %d "
-		"byte buffer\n", buf->bpl, cx_read(audio_ch->cmds_start + 8)>>1,
+	dprintk(1, "Start audio DMA, %d B/line, %d lines/FIFO, %d periods, %d byte buffer\n",
+		buf->bpl, cx_read(audio_ch->cmds_start + 8)>>1,
 		chip->num_periods, buf->bpl * chip->num_periods);
 
 	/* Enables corresponding bits at AUD_INT_STAT */
@@ -425,8 +423,7 @@ static int snd_cx88_pcm_open(struct snd_pcm_substream *substream)
 	int err;
 
 	if (!chip) {
-		printk(KERN_ERR "BUG: cx88 can't find device struct."
-				" Can't proceed with open\n");
+		printk(KERN_ERR "BUG: cx88 can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
@@ -914,8 +911,8 @@ static int snd_cx88_create(struct snd_card *card, struct pci_dev *pci,
 	/* print pci info */
 	pci_read_config_byte(pci, PCI_LATENCY_TIMER, &pci_lat);
 
-	dprintk(1,"ALSA %s/%i: found at %s, rev: %d, irq: %d, "
-	       "latency: %d, mmio: 0x%llx\n", core->name, devno,
+	dprintk(1,"ALSA %s/%i: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+		core->name, devno,
 	       pci_name(pci), pci->revision, pci->irq,
 	       pci_lat, (unsigned long long)pci_resource_start(pci,0));
 
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 8f2556ec3971..31295b36dafc 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -2847,8 +2847,7 @@ static void leadtek_eeprom(struct cx88_core *core, u8 *eeprom_data)
 		break;
 	}
 
-	info_printk(core, "Leadtek Winfast 2000XP Expert config: "
-		    "tuner=%d, eeprom[0]=0x%02x\n",
+	info_printk(core, "Leadtek Winfast 2000XP Expert config: tuner=%d, eeprom[0]=0x%02x\n",
 		    core->board.tuner_type, eeprom_data[0]);
 }
 
@@ -3107,8 +3106,8 @@ static void dvico_fusionhdtv_hybrid_init(struct cx88_core *core)
 		msg.len = (i != 12 ? 5 : 2);
 		err = i2c_transfer(&core->i2c_adap, &msg, 1);
 		if (err != 1) {
-			warn_printk(core, "dvico_fusionhdtv_hybrid_init buf %d "
-					  "failed (err = %d)!\n", i, err);
+			warn_printk(core, "dvico_fusionhdtv_hybrid_init buf %d failed (err = %d)!\n",
+				    i, err);
 			return;
 		}
 	}
@@ -3284,8 +3283,7 @@ static void cx88_card_list(struct cx88_core *core, struct pci_dev *pci)
 		       "%s: version might help as well.\n",
 		       core->name,core->name,core->name,core->name);
 	}
-	err_printk(core, "Here is a list of valid choices for the card=<n> "
-		   "insmod option:\n");
+	err_printk(core, "Here is a list of valid choices for the card=<n> insmod option:\n");
 	for (i = 0; i < ARRAY_SIZE(cx88_boards); i++)
 		printk(KERN_ERR "%s:    card=%d -> %s\n",
 		       core->name, i, cx88_boards[i].name);
@@ -3510,8 +3508,8 @@ static void cx88_card_setup(struct cx88_core *core)
 			for (i = 0; i < ARRAY_SIZE(buffer); i++)
 				if (2 != i2c_master_send(&core->i2c_client,
 							buffer[i],2))
-					warn_printk(core, "Unable to enable "
-						    "tuner(%i).\n", i);
+					warn_printk(core, "Unable to enable tuner(%i).\n",
+						    i);
 		}
 		break;
 	case CX88_BOARD_MSI_TVANYWHERE_MASTER:
diff --git a/drivers/media/pci/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
index a9907265ff66..7fafd132ccaf 100644
--- a/drivers/media/pci/cx88/cx88-dsp.c
+++ b/drivers/media/pci/cx88/cx88-dsp.c
@@ -186,8 +186,8 @@ static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
 	dual    = freq_magnitude(x, N, dual_freq);
 	noise   = noise_magnitude(x, N, FREQ_NOISE_START, FREQ_NOISE_END);
 
-	dprintk(1, "detect a2/a2m/eiaj: carrier=%d, stereo=%d, dual=%d, "
-		   "noise=%d\n", carrier, stereo, dual, noise);
+	dprintk(1, "detect a2/a2m/eiaj: carrier=%d, stereo=%d, dual=%d, noise=%d\n",
+		carrier, stereo, dual, noise);
 
 	if (stereo > dual)
 		ret = V4L2_TUNER_SUB_STEREO;
@@ -222,8 +222,8 @@ static s32 detect_btsc(struct cx88_core *core, s16 x[], u32 N)
 	s32 sap = freq_magnitude(x, N, FREQ_BTSC_SAP);
 	s32 dual_ref = freq_magnitude(x, N, FREQ_BTSC_DUAL_REF);
 	s32 dual = freq_magnitude(x, N, FREQ_BTSC_DUAL);
-	dprintk(1, "detect btsc: dual_ref=%d, dual=%d, sap_ref=%d, sap=%d"
-		   "\n", dual_ref, dual, sap_ref, sap);
+	dprintk(1, "detect btsc: dual_ref=%d, dual=%d, sap_ref=%d, sap=%d\n",
+		dual_ref, dual, sap_ref, sap);
 	/* FIXME: Currently not supported */
 	return UNSET;
 }
@@ -241,8 +241,8 @@ static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
 	u32 current_address = cx_read(srch->ptr1_reg);
 	u32 offset = (current_address - srch->fifo_start + bpl);
 
-	dprintk(1, "read RDS samples: current_address=%08x (offset=%08x), "
-		"sample_count=%d, aud_intstat=%08x\n", current_address,
+	dprintk(1, "read RDS samples: current_address=%08x (offset=%08x), sample_count=%d, aud_intstat=%08x\n",
+		current_address,
 		current_address - srch->fifo_start, sample_count,
 		cx_read(MO_AUD_INTSTAT));
 
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index ac2392d8887a..fe5fd2a4650b 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -625,8 +625,7 @@ static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 		return -EINVAL;
 
 	if (!fe0->dvb.frontend) {
-		printk(KERN_ERR "%s/2: dvb frontend not attached. "
-				"Can't attach xc3028\n",
+		printk(KERN_ERR "%s/2: dvb frontend not attached. Can't attach xc3028\n",
 		       dev->core->name);
 		return -EINVAL;
 	}
@@ -665,8 +664,7 @@ static int attach_xc4000(struct cx8802_dev *dev, struct xc4000_config *cfg)
 		return -EINVAL;
 
 	if (!fe0->dvb.frontend) {
-		printk(KERN_ERR "%s/2: dvb frontend not attached. "
-				"Can't attach xc4000\n",
+		printk(KERN_ERR "%s/2: dvb frontend not attached. Can't attach xc4000\n",
 		       dev->core->name);
 		return -EINVAL;
 	}
diff --git a/drivers/media/pci/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
index cf2d69615838..8ee9b9802683 100644
--- a/drivers/media/pci/cx88/cx88-i2c.c
+++ b/drivers/media/pci/cx88/cx88-i2c.c
@@ -45,8 +45,7 @@ MODULE_PARM_DESC(i2c_scan,"scan i2c bus at insmod time");
 
 static unsigned int i2c_udelay = 5;
 module_param(i2c_udelay, int, 0644);
-MODULE_PARM_DESC(i2c_udelay,"i2c delay at insmod time, in usecs "
-		"(should be 5 or higher). Lower value means higher bus speed.");
+MODULE_PARM_DESC(i2c_udelay,"i2c delay at insmod time, in usecs (should be 5 or higher). Lower value means higher bus speed.");
 
 #define dprintk(level,fmt, arg...)	if (i2c_debug >= level) \
 	printk(KERN_DEBUG "%s: " fmt, core->name , ## arg)
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 245357adbc25..86b46b62d985 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -401,8 +401,8 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 
 	dev->pci_rev = dev->pci->revision;
 	pci_read_config_byte(dev->pci, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	printk(KERN_INFO "%s/2: found at %s, rev: %d, irq: %d, "
-	       "latency: %d, mmio: 0x%llx\n", dev->core->name,
+	printk(KERN_INFO "%s/2: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+	       dev->core->name,
 	       pci_name(dev->pci), dev->pci_rev, dev->pci->irq,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(dev->pci,0));
 
@@ -690,8 +690,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 				list_del(&d->drvlist);
 				kfree(d);
 			} else
-				printk(KERN_ERR "%s/2: cx8802 driver remove "
-				       "failed (%d)\n", dev->core->name, err);
+				printk(KERN_ERR "%s/2: cx8802 driver remove failed (%d)\n",
+				       dev->core->name, err);
 		}
 
 		mutex_unlock(&dev->core->lock);
@@ -768,8 +768,7 @@ static void cx8802_remove(struct pci_dev *pci_dev)
 		struct cx8802_driver *drv, *tmp;
 		int err;
 
-		printk(KERN_WARNING "%s/2: Trying to remove cx8802 driver "
-		       "while cx8802 sub-drivers still loaded?!\n",
+		printk(KERN_WARNING "%s/2: Trying to remove cx8802 driver while cx8802 sub-drivers still loaded?!\n",
 		       dev->core->name);
 
 		list_for_each_entry_safe(drv, tmp, &dev->drvlist, drvlist) {
@@ -777,8 +776,8 @@ static void cx8802_remove(struct pci_dev *pci_dev)
 			if (err == 0) {
 				list_del(&drv->drvlist);
 			} else
-				printk(KERN_ERR "%s/2: cx8802 driver remove "
-				       "failed (%d)\n", dev->core->name, err);
+				printk(KERN_ERR "%s/2: cx8802 driver remove failed (%d)\n",
+				       dev->core->name, err);
 			kfree(drv);
 		}
 	}
diff --git a/drivers/media/pci/cx88/cx88-tvaudio.c b/drivers/media/pci/cx88/cx88-tvaudio.c
index 6bbce6ad6295..dd8e6f324204 100644
--- a/drivers/media/pci/cx88/cx88-tvaudio.c
+++ b/drivers/media/pci/cx88/cx88-tvaudio.c
@@ -62,8 +62,7 @@ MODULE_PARM_DESC(always_analog,"force analog audio out");
 
 static unsigned int radio_deemphasis;
 module_param(radio_deemphasis,int,0644);
-MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant, "
-		 "0=None, 1=50us (elsewhere), 2=75us (USA)");
+MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant, 0=None, 1=50us (elsewhere), 2=75us (USA)");
 
 #define dprintk(fmt, arg...)	if (audio_debug) \
 	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
@@ -976,8 +975,7 @@ void cx88_set_stereo(struct cx88_core *core, u32 mode, int manual)
 	}
 
 	if (UNSET != ctl) {
-		dprintk("cx88_set_stereo: mask 0x%x, ctl 0x%x "
-			"[status=0x%x,ctl=0x%x,vol=0x%x]\n",
+		dprintk("cx88_set_stereo: mask 0x%x, ctl 0x%x [status=0x%x,ctl=0x%x,vol=0x%x]\n",
 			mask, ctl, cx_read(AUD_STATUS),
 			cx_read(AUD_CTL), cx_sread(SHADOW_AUD_VOL_CTL));
 		cx_andor(AUD_CTL, mask, ctl);
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index d83eb3b10f54..418e2db40b39 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1307,8 +1307,8 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, "
-	       "latency: %d, mmio: 0x%llx\n", core->name,
+	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+	       core->name,
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
 
-- 
2.7.4


