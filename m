Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59999 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497AbcECU2W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2016 16:28:22 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	<stable@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] s5p-mfc: Add release callback for memory region devs
Date: Tue,  3 May 2016 16:27:17 -0400
Message-Id: <1462307238-21815-3-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
References: <1462307238-21815-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When s5p_mfc_remove() calls put_device() for the reserved memory region
devs, the driver core warns that the dev doesn't have a release callback:

WARNING: CPU: 0 PID: 591 at drivers/base/core.c:251 device_release+0x8c/0x90
Device 's5p-mfc-l' does not have a release() function, it is broken and must be fixed.

Also, the declared DMA memory using dma_declare_coherent_memory() isn't
relased so add a dev .release that calls dma_release_declared_memory().

Cc: <stable@vger.kernel.org>
Fixes: 6e83e6e25eb4 ("[media] s5p-mfc: Fix kernel warning on memory init")
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/platform/s5p-mfc/s5p_mfc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8fc1fd4ee2ed..beb4fd5bd326 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1050,6 +1050,11 @@ static int match_child(struct device *dev, void *data)
 	return !strcmp(dev_name(dev), (char *)data);
 }
 
+static void s5p_mfc_memdev_release(struct device *dev)
+{
+	dma_release_declared_memory(dev);
+}
+
 static void *mfc_get_drv_data(struct platform_device *pdev);
 
 static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
@@ -1064,6 +1069,7 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 	}
 
 	dev_set_name(dev->mem_dev_l, "%s", "s5p-mfc-l");
+	dev->mem_dev_l->release = s5p_mfc_memdev_release;
 	device_initialize(dev->mem_dev_l);
 	of_property_read_u32_array(dev->plat_dev->dev.of_node,
 			"samsung,mfc-l", mem_info, 2);
@@ -1083,6 +1089,7 @@ static int s5p_mfc_alloc_memdevs(struct s5p_mfc_dev *dev)
 	}
 
 	dev_set_name(dev->mem_dev_r, "%s", "s5p-mfc-r");
+	dev->mem_dev_r->release = s5p_mfc_memdev_release;
 	device_initialize(dev->mem_dev_r);
 	of_property_read_u32_array(dev->plat_dev->dev.of_node,
 			"samsung,mfc-r", mem_info, 2);
-- 
2.5.5

