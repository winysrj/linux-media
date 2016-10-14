Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59231 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757106AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 14/57] [media] ivtv: don't break long lines
Date: Fri, 14 Oct 2016 17:20:02 -0300
Message-Id: <5e8eb4e718e77e4b9f1781b42808dcb3af328e3a.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ivtv/ivtv-alsa-main.c |  9 +++------
 drivers/media/pci/ivtv/ivtv-driver.c    | 36 +++++++++++----------------------
 drivers/media/pci/ivtv/ivtv-firmware.c  |  3 +--
 drivers/media/pci/ivtv/ivtv-yuv.c       |  6 ++----
 drivers/media/pci/ivtv/ivtvfb.c         |  3 +--
 5 files changed, 19 insertions(+), 38 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index 8a86b61a896d..5bb28aa9a328 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -177,8 +177,7 @@ static int snd_ivtv_init(struct v4l2_device *v4l2_dev)
 #if 0
 	ret = snd_ivtv_mixer_create(itvsc);
 	if (ret) {
-		IVTV_ALSA_WARN("%s: snd_ivtv_mixer_create() failed with err %d:"
-			       " proceeding anyway\n", __func__, ret);
+		IVTV_ALSA_WARN("%s: snd_ivtv_mixer_create() failed with err %d: proceeding anyway\n", __func__, ret);
 	}
 #endif
 
@@ -235,8 +234,7 @@ static int ivtv_alsa_load(struct ivtv *itv)
 
 	s = &itv->streams[IVTV_ENC_STREAM_TYPE_PCM];
 	if (s->vdev.v4l2_dev == NULL) {
-		IVTV_DEBUG_ALSA_INFO("%s: PCM stream for card is disabled - "
-				     "skipping\n", __func__);
+		IVTV_DEBUG_ALSA_INFO("%s: PCM stream for card is disabled - skipping\n", __func__);
 		return 0;
 	}
 
@@ -250,8 +248,7 @@ static int ivtv_alsa_load(struct ivtv *itv)
 		IVTV_ALSA_ERR("%s: failed to create struct snd_ivtv_card\n",
 			      __func__);
 	} else {
-		IVTV_DEBUG_ALSA_INFO("%s: created ivtv ALSA interface instance "
-				     "\n", __func__);
+		IVTV_DEBUG_ALSA_INFO("%s: created ivtv ALSA interface instance \n", __func__);
 	}
 	return 0;
 }
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 374033a5bdaf..7f52b2ac6ada 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -885,8 +885,7 @@ static int ivtv_setup_pci(struct ivtv *itv, struct pci_dev *pdev,
 	pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &pci_latency);
 
 	if (pci_latency < 64 && ivtv_pci_latency) {
-		IVTV_INFO("Unreasonably low latency timer, "
-			       "setting to 64 (was %d)\n", pci_latency);
+		IVTV_INFO("Unreasonably low latency timer, setting to 64 (was %d)\n", pci_latency);
 		pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
 		pci_read_config_byte(pdev, PCI_LATENCY_TIMER, &pci_latency);
 	}
@@ -896,8 +895,7 @@ static int ivtv_setup_pci(struct ivtv *itv, struct pci_dev *pdev,
 	   these problems. */
 	pci_write_config_dword(pdev, 0x40, 0xffff);
 
-	IVTV_DEBUG_INFO("%d (rev %d) at %02x:%02x.%x, "
-		   "irq: %d, latency: %d, memory: 0x%llx\n",
+	IVTV_DEBUG_INFO("%d (rev %d) at %02x:%02x.%x, irq: %d, latency: %d, memory: 0x%llx\n",
 		   pdev->device, pdev->revision, pdev->bus->number,
 		   PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
 		   pdev->irq, pci_latency, (u64)itv->base_addr);
@@ -1047,13 +1045,10 @@ static int ivtv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	itv->enc_mem = ioremap_nocache(itv->base_addr + IVTV_ENCODER_OFFSET,
 				       IVTV_ENCODER_SIZE);
 	if (!itv->enc_mem) {
-		IVTV_ERR("ioremap failed. Can't get a window into CX23415/6 "
-			 "encoder memory\n");
-		IVTV_ERR("Each capture card with a CX23415/6 needs 8 MB of "
-			 "vmalloc address space for this window\n");
+		IVTV_ERR("ioremap failed. Can't get a window into CX23415/6 encoder memory\n");
+		IVTV_ERR("Each capture card with a CX23415/6 needs 8 MB of vmalloc address space for this window\n");
 		IVTV_ERR("Check the output of 'grep Vmalloc /proc/meminfo'\n");
-		IVTV_ERR("Use the vmalloc= kernel command line option to set "
-			 "VmallocTotal to a larger value\n");
+		IVTV_ERR("Use the vmalloc= kernel command line option to set VmallocTotal to a larger value\n");
 		retval = -ENOMEM;
 		goto free_mem;
 	}
@@ -1064,14 +1059,10 @@ static int ivtv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 		itv->dec_mem = ioremap_nocache(itv->base_addr + IVTV_DECODER_OFFSET,
 				IVTV_DECODER_SIZE);
 		if (!itv->dec_mem) {
-			IVTV_ERR("ioremap failed. Can't get a window into "
-				 "CX23415 decoder memory\n");
-			IVTV_ERR("Each capture card with a CX23415 needs 8 MB "
-				 "of vmalloc address space for this window\n");
-			IVTV_ERR("Check the output of 'grep Vmalloc "
-				 "/proc/meminfo'\n");
-			IVTV_ERR("Use the vmalloc= kernel command line option "
-				 "to set VmallocTotal to a larger value\n");
+			IVTV_ERR("ioremap failed. Can't get a window into CX23415 decoder memory\n");
+			IVTV_ERR("Each capture card with a CX23415 needs 8 MB of vmalloc address space for this window\n");
+			IVTV_ERR("Check the output of 'grep Vmalloc /proc/meminfo'\n");
+			IVTV_ERR("Use the vmalloc= kernel command line option to set VmallocTotal to a larger value\n");
 			retval = -ENOMEM;
 			goto free_mem;
 		}
@@ -1086,13 +1077,10 @@ static int ivtv_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 	itv->reg_mem =
 	    ioremap_nocache(itv->base_addr + IVTV_REG_OFFSET, IVTV_REG_SIZE);
 	if (!itv->reg_mem) {
-		IVTV_ERR("ioremap failed. Can't get a window into CX23415/6 "
-			 "register space\n");
-		IVTV_ERR("Each capture card with a CX23415/6 needs 64 kB of "
-			 "vmalloc address space for this window\n");
+		IVTV_ERR("ioremap failed. Can't get a window into CX23415/6 register space\n");
+		IVTV_ERR("Each capture card with a CX23415/6 needs 64 kB of vmalloc address space for this window\n");
 		IVTV_ERR("Check the output of 'grep Vmalloc /proc/meminfo'\n");
-		IVTV_ERR("Use the vmalloc= kernel command line option to set "
-			 "VmallocTotal to a larger value\n");
+		IVTV_ERR("Use the vmalloc= kernel command line option to set VmallocTotal to a larger value\n");
 		retval = -ENOMEM;
 		goto free_io;
 	}
diff --git a/drivers/media/pci/ivtv/ivtv-firmware.c b/drivers/media/pci/ivtv/ivtv-firmware.c
index 5b3095f65dce..4288f763c90c 100644
--- a/drivers/media/pci/ivtv/ivtv-firmware.c
+++ b/drivers/media/pci/ivtv/ivtv-firmware.c
@@ -376,8 +376,7 @@ int ivtv_firmware_check(struct ivtv *itv, char *where)
 	/* If something failed & currently idle, try to reload */
 	if (res && !atomic_read(&itv->capturing) &&
 						!atomic_read(&itv->decoding)) {
-		IVTV_INFO("Detected in %s that firmware had failed - "
-			  "Reloading\n", where);
+		IVTV_INFO("Detected in %s that firmware had failed - Reloading\n", where);
 		res = ivtv_firmware_restart(itv);
 		/*
 		 * Even if restarted ok, still signal a problem had occurred.
diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index b094054cda6e..373bbb53f323 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -88,8 +88,7 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
 
 		if (y_pages == y_dma.page_count) {
 			IVTV_DEBUG_WARN
-				("failed to map uv user pages, returned %d "
-				 "expecting %d\n", uv_pages, uv_dma.page_count);
+				("failed to map uv user pages, returned %d expecting %d\n", uv_pages, uv_dma.page_count);
 
 			if (uv_pages >= 0) {
 				for (i = 0; i < uv_pages; i++)
@@ -100,8 +99,7 @@ static int ivtv_yuv_prep_user_dma(struct ivtv *itv, struct ivtv_user_dma *dma,
 			}
 		} else {
 			IVTV_DEBUG_WARN
-				("failed to map y user pages, returned %d "
-				 "expecting %d\n", y_pages, y_dma.page_count);
+				("failed to map y user pages, returned %d expecting %d\n", y_pages, y_dma.page_count);
 		}
 		if (y_pages >= 0) {
 			for (i = 0; i < y_pages; i++)
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 8b95eefb610b..612a8402cf4d 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -293,8 +293,7 @@ static int ivtvfb_prep_dec_dma_to_device(struct ivtv *itv,
 	/* Map User DMA */
 	if (ivtv_udma_setup(itv, ivtv_dest_addr, userbuf, size_in_bytes) <= 0) {
 		mutex_unlock(&itv->udma.lock);
-		IVTVFB_WARN("ivtvfb_prep_dec_dma_to_device, "
-			       "Error with get_user_pages: %d bytes, %d pages returned\n",
+		IVTVFB_WARN("ivtvfb_prep_dec_dma_to_device, Error with get_user_pages: %d bytes, %d pages returned\n",
 			       size_in_bytes, itv->udma.page_count);
 
 		/* get_user_pages must have failed completely */
-- 
2.7.4


