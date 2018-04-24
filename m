Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:43505 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbeDXUmR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 16:42:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: zoran: move to dma-mapping interface
Date: Tue, 24 Apr 2018 22:40:45 +0200
Message-Id: <20180424204158.2764095-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

No drivers should use virt_to_bus() any more. This converts
one of the few remaining ones to the DMA mapping interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/zoran/Kconfig        |  2 +-
 drivers/media/pci/zoran/zoran.h        | 10 +++++--
 drivers/media/pci/zoran/zoran_card.c   | 10 +++++--
 drivers/media/pci/zoran/zoran_device.c | 16 +++++-----
 drivers/media/pci/zoran/zoran_driver.c | 54 +++++++++++++++++++++++++---------
 5 files changed, 63 insertions(+), 29 deletions(-)

diff --git a/drivers/media/pci/zoran/Kconfig b/drivers/media/pci/zoran/Kconfig
index 39ec35bd21a5..26f40e124a32 100644
--- a/drivers/media/pci/zoran/Kconfig
+++ b/drivers/media/pci/zoran/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_ZORAN
 	tristate "Zoran ZR36057/36067 Video For Linux"
-	depends on PCI && I2C_ALGOBIT && VIDEO_V4L2 && VIRT_TO_BUS
+	depends on PCI && I2C_ALGOBIT && VIDEO_V4L2
 	depends on !ALPHA
 	help
 	  Say Y for support for MJPEG capture cards based on the Zoran
diff --git a/drivers/media/pci/zoran/zoran.h b/drivers/media/pci/zoran/zoran.h
index 9bb3c21aa275..9ff3a9acb60a 100644
--- a/drivers/media/pci/zoran/zoran.h
+++ b/drivers/media/pci/zoran/zoran.h
@@ -183,13 +183,14 @@ struct zoran_buffer {
 	struct zoran_sync bs;		/* DONE: info to return to application */
 	union {
 		struct {
-			__le32 *frag_tab;	/* addresses of frag table */
-			u32 frag_tab_bus;	/* same value cached to save time in ISR */
+			__le32 *frag_tab;	/* DMA addresses of frag table */
+			void **frag_virt_tab;	/* virtual addresses of frag table */
+			dma_addr_t frag_tab_dma;/* same value cached to save time in ISR */
 		} jpg;
 		struct {
 			char *fbuffer;		/* virtual address of frame buffer */
 			unsigned long fbuffer_phys;/* physical address of frame buffer */
-			unsigned long fbuffer_bus;/* bus address of frame buffer */
+			dma_addr_t fbuffer_dma;/* bus address of frame buffer */
 		} v4l;
 	};
 };
@@ -221,6 +222,7 @@ struct zoran_fh {
 
 	struct zoran_overlay_settings overlay_settings;
 	u32 *overlay_mask;			/* overlay mask */
+	dma_addr_t overlay_mask_dma;
 	enum zoran_lock_activity overlay_active;/* feature currently in use? */
 
 	struct zoran_buffer_col buffers;	/* buffers' info */
@@ -307,6 +309,7 @@ struct zoran {
 
 	struct zoran_overlay_settings overlay_settings;
 	u32 *overlay_mask;	/* overlay mask */
+	dma_addr_t overlay_mask_dma;
 	enum zoran_lock_activity overlay_active;	/* feature currently in use? */
 
 	wait_queue_head_t v4l_capq;
@@ -346,6 +349,7 @@ struct zoran {
 
 	/* zr36057's code buffer table */
 	__le32 *stat_com;		/* stat_com[i] is indexed by dma_head/tail & BUZ_MASK_STAT_COM */
+	dma_addr_t stat_com_dma;
 
 	/* (value & BUZ_MASK_FRAME) corresponds to index in pend[] queue */
 	int jpg_pend[BUZ_MAX_FRAME];
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index a6b9ebd20263..dabd8bf77472 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -890,6 +890,7 @@ zoran_open_init_params (struct zoran *zr)
 	/* User must explicitly set a window */
 	zr->overlay_settings.is_set = 0;
 	zr->overlay_mask = NULL;
+	zr->overlay_mask_dma = 0;
 	zr->overlay_active = ZORAN_FREE;
 
 	zr->v4l_memgrab_active = 0;
@@ -1028,7 +1029,8 @@ static int zr36057_init (struct zoran *zr)
 
 	/* allocate memory *before* doing anything to the hardware
 	 * in case allocation fails */
-	zr->stat_com = kzalloc(BUZ_NUM_STAT_COM * 4, GFP_KERNEL);
+	zr->stat_com = dma_alloc_coherent(&zr->pci_dev->dev,
+				BUZ_NUM_STAT_COM * 4, &zr->stat_com_dma, GFP_KERNEL);
 	zr->video_dev = video_device_alloc();
 	if (!zr->stat_com || !zr->video_dev) {
 		dprintk(1,
@@ -1072,7 +1074,8 @@ static int zr36057_init (struct zoran *zr)
 	return 0;
 
 exit_free:
-	kfree(zr->stat_com);
+	dma_free_coherent(&zr->pci_dev->dev, BUZ_NUM_STAT_COM * 4,
+			  zr->stat_com, zr->stat_com_dma);
 	kfree(zr->video_dev);
 	return err;
 }
@@ -1107,7 +1110,8 @@ static void zoran_remove(struct pci_dev *pdev)
 	btwrite(0, ZR36057_SPGPPCR);
 	free_irq(zr->pci_dev->irq, zr);
 	/* unmap and free memory */
-	kfree(zr->stat_com);
+	dma_free_coherent(&zr->pci_dev->dev, BUZ_NUM_STAT_COM * 4,
+			  zr->stat_com, zr->stat_com_dma);
 	zoran_proc_cleanup(zr);
 	iounmap(zr->zr36057_mem);
 	pci_disable_device(zr->pci_dev);
diff --git a/drivers/media/pci/zoran/zoran_device.c b/drivers/media/pci/zoran/zoran_device.c
index 40adceebca7e..1ac7810ddd25 100644
--- a/drivers/media/pci/zoran/zoran_device.c
+++ b/drivers/media/pci/zoran/zoran_device.c
@@ -430,9 +430,9 @@ zr36057_set_vfe (struct zoran              *zr,
 		 * zr->overlay_settings.width instead of video_width */
 
 		mask_line_size = (BUZ_MAX_WIDTH + 31) / 32;
-		reg = virt_to_bus(zr->overlay_mask);
+		reg = zr->overlay_mask_dma;
 		btwrite(reg, ZR36057_MMTR);
-		reg = virt_to_bus(zr->overlay_mask + mask_line_size);
+		reg = zr->overlay_mask_dma + mask_line_size;
 		btwrite(reg, ZR36057_MMBR);
 		reg =
 		    mask_line_size - (zr->overlay_settings.width +
@@ -775,7 +775,7 @@ zr36057_set_jpg (struct zoran          *zr,
 	//btor(ZR36057_VFESPFR_VCLKPol, ZR36057_VFESPFR);
 
 	/* code base address */
-	reg = virt_to_bus(zr->stat_com);
+	reg = zr->stat_com_dma;
 	btwrite(reg, ZR36057_JCBA);
 
 	/* FIFO threshold (FIFO is 160. double words) */
@@ -1097,7 +1097,7 @@ zoran_feed_stat_com (struct zoran *zr)
 			if (!(zr->stat_com[i] & cpu_to_le32(1)))
 				break;
 			zr->stat_com[i] =
-			    cpu_to_le32(zr->jpg_buffers.buffer[frame].jpg.frag_tab_bus);
+			    cpu_to_le32(zr->jpg_buffers.buffer[frame].jpg.frag_tab_dma);
 		} else {
 			/* fill 2 stat_com entries */
 			i = ((zr->jpg_dma_head -
@@ -1105,9 +1105,9 @@ zoran_feed_stat_com (struct zoran *zr)
 			if (!(zr->stat_com[i] & cpu_to_le32(1)))
 				break;
 			zr->stat_com[i] =
-			    cpu_to_le32(zr->jpg_buffers.buffer[frame].jpg.frag_tab_bus);
+			    cpu_to_le32(zr->jpg_buffers.buffer[frame].jpg.frag_tab_dma);
 			zr->stat_com[i + 1] =
-			    cpu_to_le32(zr->jpg_buffers.buffer[frame].jpg.frag_tab_bus);
+			    cpu_to_le32(zr->jpg_buffers.buffer[frame].jpg.frag_tab_dma);
 		}
 		zr->jpg_buffers.buffer[frame].state = BUZ_STATE_DMA;
 		zr->jpg_dma_head++;
@@ -1272,7 +1272,7 @@ error_handler (struct zoran *zr,
 		printk(KERN_INFO "stat_com frames:");
 		for (j = 0; j < BUZ_NUM_STAT_COM; j++) {
 			for (i = 0; i < zr->jpg_buffers.num_buffers; i++) {
-				if (le32_to_cpu(zr->stat_com[j]) == zr->jpg_buffers.buffer[i].jpg.frag_tab_bus)
+				if (le32_to_cpu(zr->stat_com[j]) == zr->jpg_buffers.buffer[i].jpg.frag_tab_dma)
 					printk(KERN_CONT "% d->%d", j, i);
 			}
 		}
@@ -1411,7 +1411,7 @@ zoran_irq (int             irq,
 
 					/* Buffer address */
 
-					reg = zr->v4l_buffers.buffer[frame].v4l.fbuffer_bus;
+					reg = zr->v4l_buffers.buffer[frame].v4l.fbuffer_dma;
 					btwrite(reg, ZR36057_VDTR);
 					if (zr->v4l_settings.height > BUZ_MAX_HEIGHT / 2)
 						reg += zr->v4l_settings.bytesperline;
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 4b6466961b41..dad1fb02ced2 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -235,15 +235,20 @@ static int v4l_fbuffer_alloc(struct zoran_fh *fh)
 		}
 		fh->buffers.buffer[i].v4l.fbuffer = mem;
 		fh->buffers.buffer[i].v4l.fbuffer_phys = virt_to_phys(mem);
-		fh->buffers.buffer[i].v4l.fbuffer_bus = virt_to_bus(mem);
+		fh->buffers.buffer[i].v4l.fbuffer_dma =
+			dma_map_single(&zr->pci_dev->dev, mem,
+				       fh->buffers.buffer_size,
+				       DMA_FROM_DEVICE);
+		if (!fh->buffers.buffer[i].v4l.fbuffer_dma)
+			return -ENXIO;
 		for (off = 0; off < fh->buffers.buffer_size;
 		     off += PAGE_SIZE)
 			SetPageReserved(virt_to_page(mem + off));
 		dprintk(4,
 			KERN_INFO
-			"%s: %s - V4L frame %d mem %p (bus: 0x%llx)\n",
+			"%s: %s - V4L frame %d mem %p (bus: %pad)\n",
 			ZR_DEVNAME(zr), __func__, i, mem,
-			(unsigned long long)virt_to_bus(mem));
+			&fh->buffers.buffer[i].v4l.fbuffer_dma);
 	}
 
 	fh->buffers.allocated = 1;
@@ -308,6 +313,7 @@ static int jpg_fbuffer_alloc(struct zoran_fh *fh)
 	struct zoran *zr = fh->zr;
 	int i, j, off;
 	u8 *mem;
+	void **virt_tab;
 
 	for (i = 0; i < fh->buffers.num_buffers; i++) {
 		if (fh->buffers.buffer[i].jpg.frag_tab)
@@ -319,16 +325,19 @@ static int jpg_fbuffer_alloc(struct zoran_fh *fh)
 		/* Allocate fragment table for this buffer */
 
 		mem = (void *)get_zeroed_page(GFP_KERNEL);
-		if (!mem) {
+		virt_tab = (void *)get_zeroed_page(GFP_KERNEL);
+		if (!mem || !virt_tab) {
 			dprintk(1,
 				KERN_ERR
 				"%s: %s - get_zeroed_page (frag_tab) failed for buffer %d\n",
 				ZR_DEVNAME(zr), __func__, i);
+			kfree(mem);
+			kfree(virt_tab);
 			jpg_fbuffer_free(fh);
 			return -ENOBUFS;
 		}
 		fh->buffers.buffer[i].jpg.frag_tab = (__le32 *)mem;
-		fh->buffers.buffer[i].jpg.frag_tab_bus = virt_to_bus(mem);
+		fh->buffers.buffer[i].jpg.frag_virt_tab = virt_tab;
 
 		if (fh->buffers.need_contiguous) {
 			mem = kmalloc(fh->buffers.buffer_size, GFP_KERNEL);
@@ -340,8 +349,9 @@ static int jpg_fbuffer_alloc(struct zoran_fh *fh)
 				jpg_fbuffer_free(fh);
 				return -ENOBUFS;
 			}
+			fh->buffers.buffer[i].jpg.frag_virt_tab[0] = mem;
 			fh->buffers.buffer[i].jpg.frag_tab[0] =
-				cpu_to_le32(virt_to_bus(mem));
+				cpu_to_le32(dma_map_single(&zr->pci_dev->dev, mem, fh->buffers.buffer_size, DMA_FROM_DEVICE));
 			fh->buffers.buffer[i].jpg.frag_tab[1] =
 				cpu_to_le32((fh->buffers.buffer_size >> 1) | 1);
 			for (off = 0; off < fh->buffers.buffer_size; off += PAGE_SIZE)
@@ -359,8 +369,9 @@ static int jpg_fbuffer_alloc(struct zoran_fh *fh)
 					return -ENOBUFS;
 				}
 
+				fh->buffers.buffer[i].jpg.frag_virt_tab[j] = mem;
 				fh->buffers.buffer[i].jpg.frag_tab[2 * j] =
-					cpu_to_le32(virt_to_bus(mem));
+					cpu_to_le32(dma_map_single(&zr->pci_dev->dev, mem, fh->buffers.buffer_size, DMA_FROM_DEVICE));
 				fh->buffers.buffer[i].jpg.frag_tab[2 * j + 1] =
 					cpu_to_le32((PAGE_SIZE >> 2) << 1);
 				SetPageReserved(virt_to_page(mem));
@@ -368,6 +379,8 @@ static int jpg_fbuffer_alloc(struct zoran_fh *fh)
 
 			fh->buffers.buffer[i].jpg.frag_tab[2 * j - 1] |= cpu_to_le32(1);
 		}
+
+		fh->buffers.buffer[i].jpg.frag_tab_dma = dma_map_single(&zr->pci_dev->dev, mem, PAGE_SIZE, DMA_TO_DEVICE);
 	}
 
 	dprintk(4,
@@ -400,9 +413,10 @@ static void jpg_fbuffer_free(struct zoran_fh *fh)
 			frag_tab = buffer->jpg.frag_tab[0];
 
 			if (frag_tab) {
-				mem = bus_to_virt(le32_to_cpu(frag_tab));
+				mem = buffer->jpg.frag_virt_tab[0];
 				for (off = 0; off < fh->buffers.buffer_size; off += PAGE_SIZE)
 					ClearPageReserved(virt_to_page(mem + off));
+				dma_unmap_single(&zr->pci_dev->dev, frag_tab, PAGE_SIZE, DMA_FROM_DEVICE);
 				kfree(mem);
 				buffer->jpg.frag_tab[0] = 0;
 				buffer->jpg.frag_tab[1] = 0;
@@ -413,14 +427,19 @@ static void jpg_fbuffer_free(struct zoran_fh *fh)
 
 				if (!frag_tab)
 					break;
-				ClearPageReserved(virt_to_page(bus_to_virt(le32_to_cpu(frag_tab))));
-				free_page((unsigned long)bus_to_virt(le32_to_cpu(frag_tab)));
+				ClearPageReserved(virt_to_page(buffer->jpg.frag_virt_tab[j]));
+				dma_unmap_single(&zr->pci_dev->dev, le32_to_cpu(frag_tab), PAGE_SIZE, DMA_FROM_DEVICE);
+				free_page((unsigned long)buffer->jpg.frag_virt_tab[j]);
+				buffer->jpg.frag_virt_tab[j] = NULL;
 				buffer->jpg.frag_tab[2 * j] = 0;
 				buffer->jpg.frag_tab[2 * j + 1] = 0;
 			}
 		}
 
+		dma_unmap_single(&zr->pci_dev->dev, buffer->jpg.frag_tab_dma, PAGE_SIZE, DMA_TO_DEVICE);
 		free_page((unsigned long)buffer->jpg.frag_tab);
+		free_page((unsigned long)buffer->jpg.frag_virt_tab);
+		buffer->jpg.frag_virt_tab = NULL;
 		buffer->jpg.frag_tab = NULL;
 	}
 
@@ -873,6 +892,7 @@ static void zoran_close_end_session(struct zoran_fh *fh)
 		if (!zr->v4l_memgrab_active)
 			zr36057_overlay(zr, 0);
 		zr->overlay_mask = NULL;
+		zr->overlay_mask_dma = 0;
 	}
 
 	if (fh->map_mode == ZORAN_MAP_MODE_RAW) {
@@ -940,8 +960,10 @@ static int zoran_open(struct file *file)
 
 	/* used to be BUZ_MAX_WIDTH/HEIGHT, but that gives overflows
 	 * on norm-change! */
-	fh->overlay_mask =
-	    kmalloc(((768 + 31) / 32) * 576 * 4, GFP_KERNEL);
+	fh->overlay_mask = dma_alloc_wc(&zr->pci_dev->dev,
+					((768 + 31) / 32) * 576 * 4,
+					&fh->overlay_mask_dma,
+					GFP_KERNEL);
 	if (!fh->overlay_mask) {
 		dprintk(1,
 			KERN_ERR
@@ -1016,6 +1038,7 @@ zoran_close(struct file  *file)
 		zr->v4l_overlay_active = 0;
 		zr36057_overlay(zr, 0);
 		zr->overlay_mask = NULL;
+		zr->overlay_mask_dma = 0;
 
 		/* capture off */
 		wake_up_interruptible(&zr->v4l_capq);
@@ -1033,7 +1056,8 @@ zoran_close(struct file  *file)
 
 	v4l2_fh_del(&fh->fh);
 	v4l2_fh_exit(&fh->fh);
-	kfree(fh->overlay_mask);
+	dma_free_wc(&zr->pci_dev->dev, ((768 + 31) / 32) * 576 * 4,
+		    fh->overlay_mask, fh->overlay_mask_dma);
 	kfree(fh);
 
 	dprintk(4, KERN_INFO "%s: %s done\n", ZR_DEVNAME(zr), __func__);
@@ -1284,6 +1308,7 @@ static int setup_overlay(struct zoran_fh *fh, int on)
 		if (!zr->v4l_memgrab_active)
 			zr36057_overlay(zr, 0);
 		zr->overlay_mask = NULL;
+		zr->overlay_mask_dma = 0;
 	} else {
 		if (!zr->vbuf_base || !fh->overlay_settings.is_set) {
 			dprintk(1,
@@ -1302,6 +1327,7 @@ static int setup_overlay(struct zoran_fh *fh, int on)
 		zr->overlay_active = fh->overlay_active = ZORAN_LOCKED;
 		zr->v4l_overlay_active = 1;
 		zr->overlay_mask = fh->overlay_mask;
+		zr->overlay_mask_dma = fh->overlay_mask_dma;
 		zr->overlay_settings = fh->overlay_settings;
 		if (!zr->v4l_memgrab_active)
 			zr36057_overlay(zr, 1);
@@ -2763,7 +2789,7 @@ zoran_mmap (struct file           *file,
 				    le32_to_cpu(fh->buffers.
 				    buffer[i].jpg.frag_tab[2 * j]);
 				/* should just be pos on i386 */
-				page = virt_to_phys(bus_to_virt(pos))
+				page = virt_to_phys(fh->buffers.buffer[i].jpg.frag_virt_tab[j])
 								>> PAGE_SHIFT;
 				if (remap_pfn_range(vma, start, page,
 							todo, PAGE_SHARED)) {
-- 
2.9.0
