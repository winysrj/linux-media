Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaIYBYa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 21:24:30 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH] [media] exynos4-is: fix some warnings when compiling on arm64
Date: Wed, 24 Sep 2014 22:24:04 -0300
Message-Id: <416b6af26812eb995333c5bd5a9263775b8c4699.1411607687.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Got those warnings when compiling with gcc 4.9.1 for arm64:

drivers/media/platform/exynos4-is/fimc-isp-video.c: In function ‘isp_video_capture_buffer_queue’:
drivers/media/platform/exynos4-is/fimc-isp-video.c:221:4: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 7 has type ‘dma_addr_t’ [-Wformat=]
    isp_dbg(2, &video->ve.vdev,
    ^
drivers/media/platform/exynos4-is/fimc-is.c: In function ‘fimc_is_load_firmware’:
drivers/media/platform/exynos4-is/fimc-is.c:391:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘size_t’ [-Wformat=]
   dev_err(dev, "wrong firmware size: %d\n", fw->size);
   ^
In file included from include/linux/printk.h:260:0,
                 from include/linux/kernel.h:13,
                 from include/linux/kernfs.h:10,
                 from include/linux/sysfs.h:15,
                 from include/linux/kobject.h:21,
                 from include/linux/device.h:17,
                 from drivers/media/platform/exynos4-is/fimc-is.c:15:
include/linux/dynamic_debug.h:64:16: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:84:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/device.h:1106:2: note: in expansion of macro ‘dynamic_dev_dbg’
  dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
  ^
drivers/media/platform/exynos4-is/fimc-is.c:419:2: note: in expansion of macro ‘dev_dbg’
  dev_dbg(dev, "FW size: %d, paddr: %#x\n", fw->size, is->memory.paddr);
  ^
include/linux/dynamic_debug.h:64:16: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘dma_addr_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:84:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/device.h:1106:2: note: in expansion of macro ‘dynamic_dev_dbg’
  dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
  ^
drivers/media/platform/exynos4-is/fimc-is.c:419:2: note: in expansion of macro ‘dev_dbg’
  dev_dbg(dev, "FW size: %d, paddr: %#x\n", fw->size, is->memory.paddr);
  ^
drivers/media/platform/exynos4-is/fimc-is.c: In function ‘fimc_is_hw_initialize’:
include/linux/dynamic_debug.h:64:16: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘dma_addr_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:266:2: note: in expansion of macro ‘dynamic_pr_debug’
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
drivers/media/platform/exynos4-is/fimc-is.c:696:2: note: in expansion of macro ‘pr_debug’
  pr_debug("shared region: %#x, parameter region: %#x\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 6 has type ‘dma_addr_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:266:2: note: in expansion of macro ‘dynamic_pr_debug’
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
drivers/media/platform/exynos4-is/fimc-is.c:696:2: note: in expansion of macro ‘pr_debug’
  pr_debug("shared region: %#x, parameter region: %#x\n",
  ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/exynos4-is/fimc-is.c b/drivers/media/platform/exynos4-is/fimc-is.c
index 5476dce3ad29..22162b2567da 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -388,7 +388,7 @@ static void fimc_is_load_firmware(const struct firmware *fw, void *context)
 	mutex_lock(&is->lock);
 
 	if (fw->size < FIMC_IS_FW_SIZE_MIN || fw->size > FIMC_IS_FW_SIZE_MAX) {
-		dev_err(dev, "wrong firmware size: %d\n", fw->size);
+		dev_err(dev, "wrong firmware size: %zu\n", fw->size);
 		goto done;
 	}
 
@@ -416,7 +416,7 @@ static void fimc_is_load_firmware(const struct firmware *fw, void *context)
 
 	dev_info(dev, "loaded firmware: %s, rev. %s\n",
 		 is->fw.info, is->fw.version);
-	dev_dbg(dev, "FW size: %d, paddr: %#x\n", fw->size, is->memory.paddr);
+	dev_dbg(dev, "FW size: %zu, paddr: %pad\n", fw->size, &is->memory.paddr);
 
 	is->is_shared_region->chip_id = 0xe4412;
 	is->is_shared_region->chip_rev_no = 1;
@@ -693,9 +693,9 @@ int fimc_is_hw_initialize(struct fimc_is *is)
 		return -EIO;
 	}
 
-	pr_debug("shared region: %#x, parameter region: %#x\n",
-		 is->memory.paddr + FIMC_IS_SHARED_REGION_OFFSET,
-		 is->is_dma_p_region);
+	pr_debug("shared region: %pad, parameter region: %pad\n",
+		 &is->memory.paddr + FIMC_IS_SHARED_REGION_OFFSET,
+		 &is->is_dma_p_region);
 
 	is->setfile.sub_index = 0;
 
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 9d8d885558e5..76b6b4d14616 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -219,9 +219,9 @@ static void isp_video_capture_buffer_queue(struct vb2_buffer *vb)
 							ivb->dma_addr[i];
 
 			isp_dbg(2, &video->ve.vdev,
-				"dma_buf %d (%d/%d/%d) addr: %#x\n",
-				buf_index, ivb->index, i, vb->v4l2_buf.index,
-				ivb->dma_addr[i]);
+				"dma_buf %pad (%d/%d/%d) addr: %pad\n",
+				&buf_index, ivb->index, i, vb->v4l2_buf.index,
+				&ivb->dma_addr[i]);
 		}
 
 		if (++video->buf_count < video->reqbufs_count)
-- 
1.9.3

