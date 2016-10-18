Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51403 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754258AbcJRUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 07/58] cx18: don't break long lines
Date: Tue, 18 Oct 2016 18:45:19 -0200
Message-Id: <1e18eabdcbefea472e7054a3ba4ac7f9c64f53e9.1476822924.git.mchehab@s-opensource.com>
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
 drivers/media/pci/cx18/cx18-alsa-main.c   |  8 +++----
 drivers/media/pci/cx18/cx18-av-core.c     | 17 ++++++--------
 drivers/media/pci/cx18/cx18-av-firmware.c |  3 +--
 drivers/media/pci/cx18/cx18-controls.c    |  9 +++----
 drivers/media/pci/cx18/cx18-driver.c      | 35 ++++++++++++---------------
 drivers/media/pci/cx18/cx18-dvb.c         |  6 ++---
 drivers/media/pci/cx18/cx18-fileops.c     |  6 ++---
 drivers/media/pci/cx18/cx18-ioctl.c       |  6 ++---
 drivers/media/pci/cx18/cx18-irq.c         |  4 ++--
 drivers/media/pci/cx18/cx18-mailbox.c     | 39 +++++++++++--------------------
 drivers/media/pci/cx18/cx18-queue.c       |  8 +++----
 drivers/media/pci/cx18/cx18-streams.c     |  7 +++---
 12 files changed, 58 insertions(+), 90 deletions(-)

diff --git a/drivers/media/pci/cx18/cx18-alsa-main.c b/drivers/media/pci/cx18/cx18-alsa-main.c
index 0b0e8015ad34..a2f80ed8684f 100644
--- a/drivers/media/pci/cx18/cx18-alsa-main.c
+++ b/drivers/media/pci/cx18/cx18-alsa-main.c
@@ -217,8 +217,8 @@ static int cx18_alsa_load(struct cx18 *cx)
 
 	s = &cx->streams[CX18_ENC_STREAM_TYPE_PCM];
 	if (s->video_dev.v4l2_dev == NULL) {
-		CX18_DEBUG_ALSA_INFO("%s: PCM stream for card is disabled - "
-				     "skipping\n", __func__);
+		CX18_DEBUG_ALSA_INFO("%s: PCM stream for card is disabled - skipping\n",
+				     __func__);
 		return 0;
 	}
 
@@ -232,8 +232,8 @@ static int cx18_alsa_load(struct cx18 *cx)
 		CX18_ALSA_ERR("%s: failed to create struct snd_cx18_card\n",
 			      __func__);
 	} else {
-		CX18_DEBUG_ALSA_INFO("%s: created cx18 ALSA interface instance "
-				     "\n", __func__);
+		CX18_DEBUG_ALSA_INFO("%s: created cx18 ALSA interface instance \n",
+				     __func__);
 	}
 	return 0;
 }
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index 30bbe8d1ea55..7f7306fd9a7f 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -468,21 +468,19 @@ void cx18_av_std_setup(struct cx18 *cx)
 		CX18_DEBUG_INFO_DEV(sd, "Pixel rate = %d.%06d Mpixel/sec\n",
 				    pll / 8000000, (pll / 8) % 1000000);
 
-		CX18_DEBUG_INFO_DEV(sd, "ADC XTAL/pixel clock decimation ratio "
-				    "= %d.%03d\n", src_decimation / 256,
+		CX18_DEBUG_INFO_DEV(sd, "ADC XTAL/pixel clock decimation ratio = %d.%03d\n",
+				    src_decimation / 256,
 				    ((src_decimation % 256) * 1000) / 256);
 
 		tmp = 28636360 * (u64) sc;
 		do_div(tmp, src_decimation);
 		fsc = tmp >> 13;
 		CX18_DEBUG_INFO_DEV(sd,
-				    "Chroma sub-carrier initial freq = %d.%06d "
-				    "MHz\n", fsc / 1000000, fsc % 1000000);
+				    "Chroma sub-carrier initial freq = %d.%06d MHz\n",
+				    fsc / 1000000, fsc % 1000000);
 
-		CX18_DEBUG_INFO_DEV(sd, "hblank %i, hactive %i, vblank %i, "
-				    "vactive %i, vblank656 %i, src_dec %i, "
-				    "burst 0x%02x, luma_lpf %i, uv_lpf %i, "
-				    "comb 0x%02x, sc 0x%06x\n",
+		CX18_DEBUG_INFO_DEV(sd,
+				    "hblank %i, hactive %i, vblank %i, vactive %i, vblank656 %i, src_dec %i, burst 0x%02x, luma_lpf %i, uv_lpf %i, comb 0x%02x, sc 0x%06x\n",
 				    hblank, hactive, vblank, vactive, vblank656,
 				    src_decimation, burst, luma_lpf, uv_lpf,
 				    comb, sc);
@@ -1069,8 +1067,7 @@ static void log_video_status(struct cx18 *cx)
 		CX18_INFO_DEV(sd, "Specified video input:     Composite %d\n",
 			      vid_input - CX18_AV_COMPOSITE1 + 1);
 	} else {
-		CX18_INFO_DEV(sd, "Specified video input:     "
-			      "S-Video (Luma In%d, Chroma In%d)\n",
+		CX18_INFO_DEV(sd, "Specified video input:     S-Video (Luma In%d, Chroma In%d)\n",
 			      (vid_input & 0xf0) >> 4,
 			      (vid_input & 0xf00) >> 8);
 	}
diff --git a/drivers/media/pci/cx18/cx18-av-firmware.c b/drivers/media/pci/cx18/cx18-av-firmware.c
index a34fd082b76e..160e2e53383f 100644
--- a/drivers/media/pci/cx18/cx18-av-firmware.c
+++ b/drivers/media/pci/cx18/cx18-av-firmware.c
@@ -61,8 +61,7 @@ static int cx18_av_verifyfw(struct cx18 *cx, const struct firmware *fw)
 		dl_control &= 0xffff3fff; /* ignore top 2 bits of address */
 		expected = 0x0f000000 | ((u32)data[addr] << 16) | addr;
 		if (expected != dl_control) {
-			CX18_ERR_DEV(sd, "verification of %s firmware load "
-				     "failed: expected %#010x got %#010x\n",
+			CX18_ERR_DEV(sd, "verification of %s firmware load failed: expected %#010x got %#010x\n",
 				     FWFILE, expected, dl_control);
 			ret = -EIO;
 			break;
diff --git a/drivers/media/pci/cx18/cx18-controls.c b/drivers/media/pci/cx18/cx18-controls.c
index adb5a8c72c06..812a2507945a 100644
--- a/drivers/media/pci/cx18/cx18-controls.c
+++ b/drivers/media/pci/cx18/cx18-controls.c
@@ -44,8 +44,7 @@ static int cx18_s_stream_vbi_fmt(struct cx2341x_handler *cxhdl, u32 fmt)
 	      type == V4L2_MPEG_STREAM_TYPE_MPEG2_SVCD)) {
 		/* Only IVTV fmt VBI insertion & only MPEG-2 PS type streams */
 		cx->vbi.insert_mpeg = V4L2_MPEG_STREAM_VBI_FMT_NONE;
-		CX18_DEBUG_INFO("disabled insertion of sliced VBI data into "
-				"the MPEG stream\n");
+		CX18_DEBUG_INFO("disabled insertion of sliced VBI data into the MPEG stream\n");
 		return 0;
 	}
 
@@ -63,16 +62,14 @@ static int cx18_s_stream_vbi_fmt(struct cx2341x_handler *cxhdl, u32 fmt)
 				}
 				cx->vbi.insert_mpeg =
 						  V4L2_MPEG_STREAM_VBI_FMT_NONE;
-				CX18_WARN("Unable to allocate buffers for "
-					  "sliced VBI data insertion\n");
+				CX18_WARN("Unable to allocate buffers for sliced VBI data insertion\n");
 				return -ENOMEM;
 			}
 		}
 	}
 
 	cx->vbi.insert_mpeg = fmt;
-	CX18_DEBUG_INFO("enabled insertion of sliced VBI data into the MPEG PS,"
-			"when sliced VBI is enabled\n");
+	CX18_DEBUG_INFO("enabled insertion of sliced VBI data into the MPEG PS,when sliced VBI is enabled\n");
 
 	/*
 	 * If our current settings have no lines set for capture, store a valid,
diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 2f23b26b16c0..b8eedbe51c8f 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -405,8 +405,8 @@ static void cx18_process_eeprom(struct cx18 *cx)
 		CX18_ERR("Invalid EEPROM\n");
 		return;
 	default:
-		CX18_ERR("Unknown model %d, defaulting to original HVR-1600 "
-			 "(cardtype=1)\n", tv.model);
+		CX18_ERR("Unknown model %d, defaulting to original HVR-1600 (cardtype=1)\n",
+			 tv.model);
 		cx->card = cx18_get_card(CX18_CARD_HVR_1600_ESMT);
 		break;
 	}
@@ -635,8 +635,8 @@ static void cx18_process_options(struct cx18 *cx)
 			/* convert from kB to bytes */
 			cx->stream_buf_size[i] *= 1024;
 		}
-		CX18_DEBUG_INFO("Stream type %d options: %d MB, %d buffers, "
-				"%d bytes\n", i, cx->options.megabytes[i],
+		CX18_DEBUG_INFO("Stream type %d options: %d MB, %d buffers, %d bytes\n",
+				i, cx->options.megabytes[i],
 				cx->stream_buffers[i], cx->stream_buf_size[i]);
 	}
 
@@ -838,14 +838,13 @@ static int cx18_setup_pci(struct cx18 *cx, struct pci_dev *pci_dev,
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER, &pci_latency);
 
 	if (pci_latency < 64 && cx18_pci_latency) {
-		CX18_INFO("Unreasonably low latency timer, "
-			       "setting to 64 (was %d)\n", pci_latency);
+		CX18_INFO("Unreasonably low latency timer, setting to 64 (was %d)\n",
+			  pci_latency);
 		pci_write_config_byte(pci_dev, PCI_LATENCY_TIMER, 64);
 		pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER, &pci_latency);
 	}
 
-	CX18_DEBUG_INFO("cx%d (rev %d) at %02x:%02x.%x, "
-		   "irq: %d, latency: %d, memory: 0x%llx\n",
+	CX18_DEBUG_INFO("cx%d (rev %d) at %02x:%02x.%x, irq: %d, latency: %d, memory: 0x%llx\n",
 		   cx->pci_dev->device, cx->card_rev, pci_dev->bus->number,
 		   PCI_SLOT(pci_dev->devfn), PCI_FUNC(pci_dev->devfn),
 		   cx->pci_dev->irq, pci_latency, (u64)cx->base_addr);
@@ -910,8 +909,8 @@ static int cx18_probe(struct pci_dev *pci_dev,
 	/* FIXME - module parameter arrays constrain max instances */
 	i = atomic_inc_return(&cx18_instance) - 1;
 	if (i >= CX18_MAX_CARDS) {
-		printk(KERN_ERR "cx18: cannot manage card %d, driver has a "
-		       "limit of 0 - %d\n", i, CX18_MAX_CARDS - 1);
+		printk(KERN_ERR "cx18: cannot manage card %d, driver has a limit of 0 - %d\n",
+		       i, CX18_MAX_CARDS - 1);
 		return -ENOMEM;
 	}
 
@@ -926,8 +925,8 @@ static int cx18_probe(struct pci_dev *pci_dev,
 
 	retval = v4l2_device_register(&pci_dev->dev, &cx->v4l2_dev);
 	if (retval) {
-		printk(KERN_ERR "cx18: v4l2_device_register of card %d failed"
-		       "\n", cx->instance);
+		printk(KERN_ERR "cx18: v4l2_device_register of card %d failed\n",
+		       cx->instance);
 		kfree(cx);
 		return retval;
 	}
@@ -958,13 +957,10 @@ static int cx18_probe(struct pci_dev *pci_dev,
 	cx->enc_mem = ioremap_nocache(cx->base_addr + CX18_MEM_OFFSET,
 				       CX18_MEM_SIZE);
 	if (!cx->enc_mem) {
-		CX18_ERR("ioremap failed. Can't get a window into CX23418 "
-			 "memory and register space\n");
-		CX18_ERR("Each capture card with a CX23418 needs 64 MB of "
-			 "vmalloc address space for the window\n");
+		CX18_ERR("ioremap failed. Can't get a window into CX23418 memory and register space\n");
+		CX18_ERR("Each capture card with a CX23418 needs 64 MB of vmalloc address space for the window\n");
 		CX18_ERR("Check the output of 'grep Vmalloc /proc/meminfo'\n");
-		CX18_ERR("Use the vmalloc= kernel command line option to set "
-			 "VmallocTotal to a larger value\n");
+		CX18_ERR("Use the vmalloc= kernel command line option to set VmallocTotal to a larger value\n");
 		retval = -ENOMEM;
 		goto free_mem;
 	}
@@ -1000,8 +996,7 @@ static int cx18_probe(struct pci_dev *pci_dev,
 	/* Initialize GPIO Reset Controller to do chip resets during i2c init */
 	if (cx->card->hw_all & CX18_HW_GPIO_RESET_CTRL) {
 		if (cx18_gpio_register(cx, CX18_HW_GPIO_RESET_CTRL) != 0)
-			CX18_WARN("Could not register GPIO reset controller"
-				  "subdevice; proceeding anyway.\n");
+			CX18_WARN("Could not register GPIO reset controllersubdevice; proceeding anyway.\n");
 		else
 			cx->hw_flags |= CX18_HW_GPIO_RESET_CTRL;
 	}
diff --git a/drivers/media/pci/cx18/cx18-dvb.c b/drivers/media/pci/cx18/cx18-dvb.c
index 3eac59c51231..03d0478170a7 100644
--- a/drivers/media/pci/cx18/cx18-dvb.c
+++ b/drivers/media/pci/cx18/cx18-dvb.c
@@ -155,10 +155,8 @@ static int yuan_mpc718_mt352_reqfw(struct cx18_stream *stream,
 	}
 
 	if (ret) {
-		CX18_ERR("The MPC718 board variant with the MT352 DVB-T"
-			  "demodualtor will not work without it\n");
-		CX18_ERR("Run 'linux/Documentation/dvb/get_dvb_firmware "
-			  "mpc718' if you need the firmware\n");
+		CX18_ERR("The MPC718 board variant with the MT352 DVB-Tdemodualtor will not work without it\n");
+		CX18_ERR("Run 'linux/Documentation/dvb/get_dvb_firmware mpc718' if you need the firmware\n");
 	}
 	return ret;
 }
diff --git a/drivers/media/pci/cx18/cx18-fileops.c b/drivers/media/pci/cx18/cx18-fileops.c
index df837408efd5..78b399b8613e 100644
--- a/drivers/media/pci/cx18/cx18-fileops.c
+++ b/drivers/media/pci/cx18/cx18-fileops.c
@@ -49,8 +49,7 @@ int cx18_claim_stream(struct cx18_open_id *id, int type)
 
 	/* Nothing should ever try to directly claim the IDX stream */
 	if (type == CX18_ENC_STREAM_TYPE_IDX) {
-		CX18_WARN("MPEG Index stream cannot be claimed "
-			  "directly, but something tried.\n");
+		CX18_WARN("MPEG Index stream cannot be claimed directly, but something tried.\n");
 		return -EINVAL;
 	}
 
@@ -728,8 +727,7 @@ void cx18_stop_capture(struct cx18_open_id *id, int gop_end)
 			/* Stop internal use associated VBI and IDX streams */
 			if (test_bit(CX18_F_S_STREAMING, &s_vbi->s_flags) &&
 			    !test_bit(CX18_F_S_APPL_IO, &s_vbi->s_flags)) {
-				CX18_DEBUG_INFO("close stopping embedded VBI "
-						"capture\n");
+				CX18_DEBUG_INFO("close stopping embedded VBI capture\n");
 				cx18_stop_v4l2_encode_stream(s_vbi, 0);
 			}
 			if (test_bit(CX18_F_S_STREAMING, &s_idx->s_flags)) {
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index fecca2a63891..0faeb979ceb9 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -951,8 +951,7 @@ static int cx18_encoder_cmd(struct file *file, void *fh,
 			return 0;
 		h = cx18_find_handle(cx);
 		if (h == CX18_INVALID_TASK_HANDLE) {
-			CX18_ERR("Can't find valid task handle for "
-				 "V4L2_ENC_CMD_PAUSE\n");
+			CX18_ERR("Can't find valid task handle for V4L2_ENC_CMD_PAUSE\n");
 			return -EBADFD;
 		}
 		cx18_mute(cx);
@@ -968,8 +967,7 @@ static int cx18_encoder_cmd(struct file *file, void *fh,
 			return 0;
 		h = cx18_find_handle(cx);
 		if (h == CX18_INVALID_TASK_HANDLE) {
-			CX18_ERR("Can't find valid task handle for "
-				 "V4L2_ENC_CMD_RESUME\n");
+			CX18_ERR("Can't find valid task handle for V4L2_ENC_CMD_RESUME\n");
 			return -EBADFD;
 		}
 		cx18_vapi(cx, CX18_CPU_CAPTURE_RESUME, 1, h);
diff --git a/drivers/media/pci/cx18/cx18-irq.c b/drivers/media/pci/cx18/cx18-irq.c
index 80edfe93a3d8..361426485e98 100644
--- a/drivers/media/pci/cx18/cx18-irq.c
+++ b/drivers/media/pci/cx18/cx18-irq.c
@@ -59,8 +59,8 @@ irqreturn_t cx18_irq_handler(int irq, void *dev_id)
 		cx18_write_reg_expect(cx, hw2, HW2_INT_CLR_STATUS, ~hw2, hw2);
 
 	if (sw1 || sw2 || hw2)
-		CX18_DEBUG_HI_IRQ("received interrupts "
-				  "SW1: %x  SW2: %x  HW2: %x\n", sw1, sw2, hw2);
+		CX18_DEBUG_HI_IRQ("received interrupts SW1: %x	SW2: %x  HW2: %x\n",
+				  sw1, sw2, hw2);
 
 	/*
 	 * SW1 responses have to happen first.  The sending XPU times out the
diff --git a/drivers/media/pci/cx18/cx18-mailbox.c b/drivers/media/pci/cx18/cx18-mailbox.c
index 1f8aa9a749a1..271b05ce2de7 100644
--- a/drivers/media/pci/cx18/cx18-mailbox.c
+++ b/drivers/media/pci/cx18/cx18-mailbox.c
@@ -123,8 +123,8 @@ static void dump_mb(struct cx18 *cx, struct cx18_mailbox *mb, char *name)
 	if (!(cx18_debug & CX18_DBGFLG_API))
 		return;
 
-	CX18_DEBUG_API("%s: req %#010x ack %#010x cmd %#010x err %#010x args%s"
-		       "\n", name, mb->request, mb->ack, mb->cmd, mb->error,
+	CX18_DEBUG_API("%s: req %#010x ack %#010x cmd %#010x err %#010x args%s\n",
+		       name, mb->request, mb->ack, mb->cmd, mb->error,
 		       u32arr2hex(mb->args, MAX_MB_ARGUMENTS, argstr));
 }
 
@@ -255,8 +255,8 @@ static void epu_dma_done(struct cx18 *cx, struct cx18_in_work_order *order)
 	s = cx18_handle_to_stream(cx, handle);
 
 	if (s == NULL) {
-		CX18_WARN("Got DMA done notification for unknown/inactive"
-			  " handle %d, %s mailbox seq no %d\n", handle,
+		CX18_WARN("Got DMA done notification for unknown/inactive handle %d, %s mailbox seq no %d\n",
+			  handle,
 			  (order->flags & CX18_F_EWO_MB_STALE_UPON_RECEIPT) ?
 			  "stale" : "good", mb->request);
 		return;
@@ -290,9 +290,8 @@ static void epu_dma_done(struct cx18 *cx, struct cx18_in_work_order *order)
 		if ((order->flags & CX18_F_EWO_MB_STALE_UPON_RECEIPT) &&
 		    !(id >= s->mdl_base_idx &&
 		      id < (s->mdl_base_idx + s->buffers))) {
-			CX18_WARN("Fell behind! Ignoring stale mailbox with "
-				  " inconsistent data. Lost MDL for mailbox "
-				  "seq no %d\n", mb->request);
+			CX18_WARN("Fell behind! Ignoring stale mailbox with  inconsistent data. Lost MDL for mailbox seq no %d\n",
+				  mb->request);
 			break;
 		}
 		mdl = cx18_queue_get_mdl(s, id, mdl_ack->data_used);
@@ -418,9 +417,7 @@ static void mb_ack_irq(struct cx18 *cx, struct cx18_in_work_order *order)
 	/* Don't ack if the RPU has gotten impatient and timed us out */
 	if (req != cx18_readl(cx, &ack_mb->request) ||
 	    req == cx18_readl(cx, &ack_mb->ack)) {
-		CX18_DEBUG_WARN("Possibly falling behind: %s self-ack'ed our "
-				"incoming %s to EPU mailbox (sequence no. %u) "
-				"while processing\n",
+		CX18_DEBUG_WARN("Possibly falling behind: %s self-ack'ed our incoming %s to EPU mailbox (sequence no. %u) while processing\n",
 				rpu_str[order->rpu], rpu_str[order->rpu], req);
 		order->flags |= CX18_F_EWO_MB_STALE_WHILE_PROC;
 		return;
@@ -555,8 +552,7 @@ void cx18_api_epu_cmd_irq(struct cx18 *cx, int rpu)
 
 	order = alloc_in_work_order_irq(cx);
 	if (order == NULL) {
-		CX18_WARN("Unable to find blank work order form to schedule "
-			  "incoming mailbox command processing\n");
+		CX18_WARN("Unable to find blank work order form to schedule incoming mailbox command processing\n");
 		return;
 	}
 
@@ -573,9 +569,7 @@ void cx18_api_epu_cmd_irq(struct cx18 *cx, int rpu)
 		(&order_mb->request)[i] = cx18_readl(cx, &mb->request + i);
 
 	if (order_mb->request == order_mb->ack) {
-		CX18_DEBUG_WARN("Possibly falling behind: %s self-ack'ed our "
-				"incoming %s to EPU mailbox (sequence no. %u)"
-				"\n",
+		CX18_DEBUG_WARN("Possibly falling behind: %s self-ack'ed our incoming %s to EPU mailbox (sequence no. %u)\n",
 				rpu_str[rpu], rpu_str[rpu], order_mb->request);
 		if (cx18_debug & CX18_DBGFLG_WARN)
 			dump_mb(cx, order_mb, "incoming");
@@ -663,8 +657,8 @@ static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 	if (req != ack) {
 		/* waited long enough, make the mbox "not busy" from our end */
 		cx18_writel(cx, req, &mb->ack);
-		CX18_ERR("mbox was found stuck busy when setting up for %s; "
-			 "clearing busy and trying to proceed\n", info->name);
+		CX18_ERR("mbox was found stuck busy when setting up for %s; clearing busy and trying to proceed\n",
+			 info->name);
 	} else if (ret != timeout)
 		CX18_DEBUG_API("waited %u msecs for busy mbox to be acked\n",
 			       jiffies_to_msecs(timeout-ret));
@@ -707,14 +701,10 @@ static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 		mutex_unlock(mb_lock);
 		if (ret >= timeout) {
 			/* Timed out */
-			CX18_DEBUG_WARN("sending %s timed out waiting %d msecs "
-					"for RPU acknowledgement\n",
+			CX18_DEBUG_WARN("sending %s timed out waiting %d msecs for RPU acknowledgement\n",
 					info->name, jiffies_to_msecs(ret));
 		} else {
-			CX18_DEBUG_WARN("woken up before mailbox ack was ready "
-					"after submitting %s to RPU.  only "
-					"waited %d msecs on req %u but awakened"
-					" with unmatched ack %u\n",
+			CX18_DEBUG_WARN("woken up before mailbox ack was ready after submitting %s to RPU.  only waited %d msecs on req %u but awakened with unmatched ack %u\n",
 					info->name,
 					jiffies_to_msecs(ret),
 					req, ack);
@@ -723,8 +713,7 @@ static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 	}
 
 	if (ret >= timeout)
-		CX18_DEBUG_WARN("failed to be awakened upon RPU acknowledgment "
-				"sending %s; timed out waiting %d msecs\n",
+		CX18_DEBUG_WARN("failed to be awakened upon RPU acknowledgment sending %s; timed out waiting %d msecs\n",
 				info->name, jiffies_to_msecs(ret));
 	else
 		CX18_DEBUG_HI_API("waited %u msecs for %s to be acked\n",
diff --git a/drivers/media/pci/cx18/cx18-queue.c b/drivers/media/pci/cx18/cx18-queue.c
index 2a247d264b87..13e96d6055eb 100644
--- a/drivers/media/pci/cx18/cx18-queue.c
+++ b/drivers/media/pci/cx18/cx18-queue.c
@@ -164,9 +164,8 @@ struct cx18_mdl *cx18_queue_get_mdl(struct cx18_stream *s, u32 id,
 			mdl->skipped++;
 			if (mdl->skipped >= atomic_read(&s->q_busy.depth)-1) {
 				/* mdl must have fallen out of rotation */
-				CX18_WARN("Skipped %s, MDL %d, %d "
-					  "times - it must have dropped out of "
-					  "rotation\n", s->name, mdl->id,
+				CX18_WARN("Skipped %s, MDL %d, %d times - it must have dropped out of rotation\n",
+					  s->name, mdl->id,
 					  mdl->skipped);
 				/* Sweep it up to put it back into rotation */
 				list_move_tail(&mdl->list, &sweep_up);
@@ -352,8 +351,7 @@ int cx18_stream_alloc(struct cx18_stream *s)
 	if (s->buffers == 0)
 		return 0;
 
-	CX18_DEBUG_INFO("Allocate %s stream: %d x %d buffers "
-			"(%d.%02d kB total)\n",
+	CX18_DEBUG_INFO("Allocate %s stream: %d x %d buffers (%d.%02d kB total)\n",
 		s->name, s->buffers, s->buf_size,
 		s->buffers * s->buf_size / 1024,
 		(s->buffers * s->buf_size * 100 / 1024) % 100);
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index f3802ec1b383..7f699f0ee76c 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -353,8 +353,8 @@ static int cx18_prep_dev(struct cx18 *cx, int type)
 		if (cx->card->hw_all & CX18_HW_DVB) {
 			s->dvb = kzalloc(sizeof(struct cx18_dvb), GFP_KERNEL);
 			if (s->dvb == NULL) {
-				CX18_ERR("Couldn't allocate cx18_dvb structure"
-					 " for %s\n", s->name);
+				CX18_ERR("Couldn't allocate cx18_dvb structure for %s\n",
+					 s->name);
 				return -ENOMEM;
 			}
 		} else {
@@ -462,8 +462,7 @@ static int cx18_reg_dev(struct cx18 *cx, int type)
 
 	case VFL_TYPE_VBI:
 		if (cx->stream_buffers[type])
-			CX18_INFO("Registered device %s for %s "
-				  "(%d x %d bytes)\n",
+			CX18_INFO("Registered device %s for %s (%d x %d bytes)\n",
 				  name, s->name, cx->stream_buffers[type],
 				  cx->stream_buf_size[type]);
 		else
-- 
2.7.4


