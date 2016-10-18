Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51411 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754659AbcJRUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Stephen Backway <stev391@gmail.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        Inki Dae <inki.dae@samsung.com>,
        Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v2 08/58] cx23885: don't break long lines
Date: Tue, 18 Oct 2016 18:45:20 -0200
Message-Id: <c801fa6742874da6f3b72804dcb9d32dae5bc2e9.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/pci/cx23885/cimax2.c        |  5 ++---
 drivers/media/pci/cx23885/cx23885-417.c   | 17 +++++++----------
 drivers/media/pci/cx23885/cx23885-alsa.c  | 15 +++++++--------
 drivers/media/pci/cx23885/cx23885-cards.c |  8 +++-----
 drivers/media/pci/cx23885/cx23885-core.c  | 15 +++++++--------
 drivers/media/pci/cx23885/cx23885-dvb.c   |  3 +--
 drivers/media/pci/cx23885/cx23885-video.c |  3 +--
 drivers/media/pci/cx23885/cx23888-ir.c    |  7 +++----
 8 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
index 631e4f24aea6..43febef2f649 100644
--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -365,9 +365,8 @@ static void netup_read_ci_status(struct work_struct *work)
 		if (ret != 0)
 			return;
 
-		ci_dbg_print("%s: Slot Status Addr=[0x%04x], "
-				"Reg=[0x%02x], data=%02x, "
-				"TS config = %02x\n", __func__,
+		ci_dbg_print("%s: Slot Status Addr=[0x%04x], Reg=[0x%02x], data=%02x, TS config = %02x\n",
+			     __func__,
 				state->ci_i2c_addr, 0, buf[0],
 				buf[0]);
 
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index da892f3e3c29..0444db081b5c 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -770,8 +770,8 @@ static int cx23885_mbox_func(void *priv,
 	mc417_memory_read(dev, dev->cx23417_mailbox - 4, &value);
 	if (value != 0x12345678) {
 		printk(KERN_ERR
-			"Firmware and/or mailbox pointer not initialized "
-			"or corrupted, signature = 0x%x, cmd = %s\n", value,
+			"Firmware and/or mailbox pointer not initialized or corrupted, signature = 0x%x, cmd = %s\n",
+value,
 			cmd_to_str(command));
 		return -1;
 	}
@@ -781,8 +781,8 @@ static int cx23885_mbox_func(void *priv,
 	 */
 	mc417_memory_read(dev, dev->cx23417_mailbox, &flag);
 	if (flag) {
-		printk(KERN_ERR "ERROR: Mailbox appears to be in use "
-			"(%x), cmd = %s\n", flag, cmd_to_str(command));
+		printk(KERN_ERR "ERROR: Mailbox appears to be in use (%x), cmd = %s\n",
+		       flag, cmd_to_str(command));
 		return -1;
 	}
 
@@ -935,14 +935,12 @@ static int cx23885_load_firmware(struct cx23885_dev *dev)
 		printk(KERN_ERR
 			"ERROR: Hotplug firmware request failed (%s).\n",
 			CX23885_FIRM_IMAGE_NAME);
-		printk(KERN_ERR "Please fix your hotplug setup, the board will "
-			"not work without firmware loaded!\n");
+		printk(KERN_ERR "Please fix your hotplug setup, the board will not work without firmware loaded!\n");
 		return -1;
 	}
 
 	if (firmware->size != CX23885_FIRM_IMAGE_SIZE) {
-		printk(KERN_ERR "ERROR: Firmware size mismatch "
-			"(have %zu, expected %d)\n",
+		printk(KERN_ERR "ERROR: Firmware size mismatch (have %zu, expected %d)\n",
 			firmware->size, CX23885_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
 		return -1;
@@ -1077,8 +1075,7 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev, int startencoder)
 		retval = cx23885_api_cmd(dev, CX2341X_ENC_GET_VERSION, 0, 1,
 			&version);
 		if (retval < 0) {
-			printk(KERN_ERR "ERROR: cx23417 firmware get encoder :"
-				"version failed!\n");
+			printk(KERN_ERR "ERROR: cx23417 firmware get encoder :version failed!\n");
 			return -1;
 		}
 		dprintk(1, "cx23417 firmware version is 0x%08x\n", version);
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index 6115d4e148ba..9d2a4e2dc54f 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -186,8 +186,8 @@ static int cx23885_start_audio_dma(struct cx23885_audio_dev *chip)
 	cx_write(AUD_INT_A_GPCNT_CTL, GP_COUNT_CONTROL_RESET);
 	atomic_set(&chip->count, 0);
 
-	dprintk(1, "Start audio DMA, %d B/line, %d lines/FIFO, %d periods, %d "
-		"byte buffer\n", buf->bpl, cx_read(audio_ch->cmds_start+12)>>1,
+	dprintk(1, "Start audio DMA, %d B/line, %d lines/FIFO, %d periods, %d byte buffer\n",
+		buf->bpl, cx_read(audio_ch->cmds_start+12)>>1,
 		chip->num_periods, buf->bpl * chip->num_periods);
 
 	/* Enables corresponding bits at AUD_INT_STAT */
@@ -327,8 +327,7 @@ static int snd_cx23885_pcm_open(struct snd_pcm_substream *substream)
 	int err;
 
 	if (!chip) {
-		printk(KERN_ERR "BUG: cx23885 can't find device struct."
-				" Can't proceed with open\n");
+		printk(KERN_ERR "BUG: cx23885 can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
@@ -555,8 +554,8 @@ struct cx23885_audio_dev *cx23885_audio_register(struct cx23885_dev *dev)
 		return NULL;
 
 	if (dev->sram_channels[AUDIO_SRAM_CHANNEL].cmds_start == 0) {
-		printk(KERN_WARNING "%s(): Missing SRAM channel configuration "
-			"for analog TV Audio\n", __func__);
+		printk(KERN_WARNING "%s(): Missing SRAM channel configuration for analog TV Audio\n",
+		       __func__);
 		return NULL;
 	}
 
@@ -590,8 +589,8 @@ struct cx23885_audio_dev *cx23885_audio_register(struct cx23885_dev *dev)
 
 error:
 	snd_card_free(card);
-	printk(KERN_ERR "%s(): Failed to register analog "
-			"audio adapter\n", __func__);
+	printk(KERN_ERR "%s(): Failed to register analog audio adapter\n",
+	       __func__);
 
 	return NULL;
 }
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 99ba8d6328f0..e2c4edbfbdb7 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1304,8 +1304,7 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 		 */
 		break;
 	default:
-		printk(KERN_WARNING "%s: warning: "
-			"unknown hauppauge model #%d\n",
+		printk(KERN_WARNING "%s: warning: unknown hauppauge model #%d\n",
 			dev->name, tv.model);
 		break;
 	}
@@ -2342,9 +2341,8 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 
 		ret = request_firmware(&fw, filename, &dev->pci->dev);
 		if (ret != 0)
-			printk(KERN_ERR "did not find the firmware file. (%s) "
-			"Please see linux/Documentation/dvb/ for more details "
-			"on firmware-problems.", filename);
+			printk(KERN_ERR "did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems.",
+			       filename);
 		else
 			altera_init(&netup_config, fw);
 
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index c86b1093ab99..5020a60a4f1f 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -915,8 +915,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 		cx23885_init_tsport(dev, &dev->ts2, 2);
 
 	if (get_resources(dev) < 0) {
-		printk(KERN_ERR "CORE %s No more PCIe resources for "
-		       "subsystem: %04x:%04x\n",
+		printk(KERN_ERR "CORE %s No more PCIe resources for subsystem: %04x:%04x\n",
 		       dev->name, dev->pci->subsystem_vendor,
 		       dev->pci->subsystem_device);
 
@@ -980,8 +979,8 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 
 	if (cx23885_boards[dev->board].porta == CX23885_ANALOG_VIDEO) {
 		if (cx23885_video_register(dev) < 0) {
-			printk(KERN_ERR "%s() Failed to register analog "
-				"video adapters on VID_A\n", __func__);
+			printk(KERN_ERR "%s() Failed to register analog video adapters on VID_A\n",
+			       __func__);
 		}
 	}
 
@@ -1579,8 +1578,8 @@ int cx23885_irq_417(struct cx23885_dev *dev, u32 status)
 		(status & VID_B_MSK_VBI_SYNC)    ||
 		(status & VID_B_MSK_OF)          ||
 		(status & VID_B_MSK_VBI_OF)) {
-		printk(KERN_ERR "%s: V4L mpeg risc op code error, status "
-			"= 0x%x\n", dev->name, status);
+		printk(KERN_ERR "%s: V4L mpeg risc op code error, status = 0x%x\n",
+		       dev->name, status);
 		if (status & VID_B_MSK_BAD_PKT)
 			dprintk(1, "        VID_B_MSK_BAD_PKT\n");
 		if (status & VID_B_MSK_OPC_ERR)
@@ -1995,8 +1994,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, "
-	       "latency: %d, mmio: 0x%llx\n", dev->name,
+	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+	       dev->name,
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,
 		(unsigned long long)pci_resource_start(pci_dev, 0));
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 818f3c2fc98d..42413fa423b4 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -2482,8 +2482,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		break;
 
 	default:
-		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
-		       " isn't supported yet\n",
+		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card  isn't supported yet\n",
 		       dev->name);
 		break;
 	}
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 33d168ef278d..92ff452e5886 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1065,8 +1065,7 @@ int cx23885_video_irq(struct cx23885_dev *dev, u32 status)
 		}
 
 		if (status & VID_BC_MSK_SYNC)
-			dprintk(7, " (VID_BC_MSK_SYNC 0x%08x) "
-				"video lines miss-match\n",
+			dprintk(7, " (VID_BC_MSK_SYNC 0x%08x) video lines miss-match\n",
 				VID_BC_MSK_SYNC);
 
 		if (status & VID_BC_MSK_OF)
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index c1aa888af705..3115cfddab95 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -1015,8 +1015,8 @@ static int cx23888_ir_log_status(struct v4l2_subdev *sd)
 			j = 0;
 			break;
 		}
-		v4l2_info(sd, "\tNext carrier edge window:          16 clocks "
-			  "-%1d/+%1d, %u to %u Hz\n", i, j,
+		v4l2_info(sd, "\tNext carrier edge window:	    16 clocks -%1d/+%1d, %u to %u Hz\n",
+			  i, j,
 			  clock_divider_to_freq(rxclk, 16 + j),
 			  clock_divider_to_freq(rxclk, 16 - i));
 	}
@@ -1026,8 +1026,7 @@ static int cx23888_ir_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "\tLow pass filter:                   %s\n",
 		  filtr ? "enabled" : "disabled");
 	if (filtr)
-		v4l2_info(sd, "\tMin acceptable pulse width (LPF):  %u us, "
-			  "%u ns\n",
+		v4l2_info(sd, "\tMin acceptable pulse width (LPF):  %u us, %u ns\n",
 			  lpf_count_to_us(filtr),
 			  lpf_count_to_ns(filtr));
 	v4l2_info(sd, "\tPulse width timer timed-out:       %s\n",
-- 
2.7.4


