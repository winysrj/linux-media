Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44046 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaIXXiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 19:38:10 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan McCrohan <jmccrohan@gmail.com>,
	ivtv-devel@ivtvdriver.org
Subject: [PATCH 2/3] [media] pci drivers: use %zu instead of %zd
Date: Wed, 24 Sep 2014 20:37:43 -0300
Message-Id: <6843e18853dc80bec96978fd3fa6f68bdeee056e.1411601849.git.mchehab@osg.samsung.com>
In-Reply-To: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
References: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
In-Reply-To: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
References: <2d1780eb72dac499b9d44aa38961b8716e8857b3.1411601849.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

size_t is unsigned.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/cx18/cx18-alsa-pcm.c b/drivers/media/pci/cx18/cx18-alsa-pcm.c
index 180077c49123..ffb6acdc575f 100644
--- a/drivers/media/pci/cx18/cx18-alsa-pcm.c
+++ b/drivers/media/pci/cx18/cx18-alsa-pcm.c
@@ -80,7 +80,7 @@ void cx18_alsa_announce_pcm_data(struct snd_cx18_card *cxsc, u8 *pcm_data,
 	int period_elapsed = 0;
 	int length;
 
-	dprintk("cx18 alsa announce ptr=%p data=%p num_bytes=%zd\n", cxsc,
+	dprintk("cx18 alsa announce ptr=%p data=%p num_bytes=%zu\n", cxsc,
 		pcm_data, num_bytes);
 
 	substream = cxsc->capture_pcm_substream;
diff --git a/drivers/media/pci/cx18/cx18-firmware.c b/drivers/media/pci/cx18/cx18-firmware.c
index 53a7578d525b..c6c83445f8bf 100644
--- a/drivers/media/pci/cx18/cx18-firmware.c
+++ b/drivers/media/pci/cx18/cx18-firmware.c
@@ -130,7 +130,7 @@ static int load_cpu_fw_direct(const char *fn, u8 __iomem *mem, struct cx18 *cx)
 		}
 	}
 	if (!test_bit(CX18_F_I_LOADED_FW, &cx->i_flags))
-		CX18_INFO("loaded %s firmware (%zd bytes)\n", fn, fw->size);
+		CX18_INFO("loaded %s firmware (%zu bytes)\n", fn, fw->size);
 	size = fw->size;
 	release_firmware(fw);
 	cx18_setup_page(cx, SCB_OFFSET);
@@ -202,7 +202,7 @@ static int load_apu_fw_direct(const char *fn, u8 __iomem *dst, struct cx18 *cx,
 		offset += seghdr.size;
 	}
 	if (!test_bit(CX18_F_I_LOADED_FW, &cx->i_flags))
-		CX18_INFO("loaded %s firmware V%08x (%zd bytes)\n",
+		CX18_INFO("loaded %s firmware V%08x (%zu bytes)\n",
 				fn, apu_version, fw->size);
 	size = fw->size;
 	release_firmware(fw);
diff --git a/drivers/media/pci/cx18/cx18-queue.c b/drivers/media/pci/cx18/cx18-queue.c
index 8884537bd62f..2a247d264b87 100644
--- a/drivers/media/pci/cx18/cx18-queue.c
+++ b/drivers/media/pci/cx18/cx18-queue.c
@@ -364,7 +364,7 @@ int cx18_stream_alloc(struct cx18_stream *s)
 					((char __iomem *)cx->scb->cpu_mdl));
 
 		CX18_ERR("Too many buffers, cannot fit in SCB area\n");
-		CX18_ERR("Max buffers = %zd\n",
+		CX18_ERR("Max buffers = %zu\n",
 			bufsz / sizeof(struct cx18_mdl_ent));
 		return -ENOMEM;
 	}
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 6973055f0814..3948db386fb5 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -942,7 +942,7 @@ static int cx23885_load_firmware(struct cx23885_dev *dev)
 
 	if (firmware->size != CX23885_FIRM_IMAGE_SIZE) {
 		printk(KERN_ERR "ERROR: Firmware size mismatch "
-			"(have %zd, expected %d)\n",
+			"(have %zu, expected %d)\n",
 			firmware->size, CX23885_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
 		return -1;
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index 7a9b98bc208b..7bf9cbca4fa6 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -81,7 +81,7 @@ static void ivtv_alsa_announce_pcm_data(struct snd_ivtv_card *itvsc,
 	int period_elapsed = 0;
 	int length;
 
-	dprintk("ivtv alsa announce ptr=%p data=%p num_bytes=%zd\n", itvsc,
+	dprintk("ivtv alsa announce ptr=%p data=%p num_bytes=%zu\n", itvsc,
 		pcm_data, num_bytes);
 
 	substream = itvsc->capture_pcm_substream;
diff --git a/drivers/media/pci/ivtv/ivtv-firmware.c b/drivers/media/pci/ivtv/ivtv-firmware.c
index ed73edd2bcd3..4b0e758a7bce 100644
--- a/drivers/media/pci/ivtv/ivtv-firmware.c
+++ b/drivers/media/pci/ivtv/ivtv-firmware.c
@@ -65,7 +65,7 @@ retry:
 			   the wrong file was sometimes loaded. So we check filesizes to
 			   see if at least the right-sized file was loaded. If not, then we
 			   retry. */
-			IVTV_INFO("Retry: file loaded was not %s (expected size %ld, got %zd)\n", fn, size, fw->size);
+			IVTV_INFO("Retry: file loaded was not %s (expected size %ld, got %zu)\n", fn, size, fw->size);
 			release_firmware(fw);
 			retries--;
 			goto retry;
@@ -76,7 +76,7 @@ retry:
 			dst++;
 			src++;
 		}
-		IVTV_INFO("Loaded %s firmware (%zd bytes)\n", fn, fw->size);
+		IVTV_INFO("Loaded %s firmware (%zu bytes)\n", fn, fw->size);
 		release_firmware(fw);
 		return size;
 	}
-- 
1.9.3

