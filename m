Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:35429 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751984AbdCBVpc (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 16:45:32 -0500
Received: by mail-qk0-f178.google.com with SMTP id m67so31731209qkf.2
        for <linux-media@vger.kernel.org>; Thu, 02 Mar 2017 13:45:32 -0800 (PST)
From: Laura Abbott <labbott@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Riley Andrews <riandrews@android.com>, arve@android.com
Cc: Laura Abbott <labbott@redhat.com>, romlem@google.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-mm@kvack.org
Subject: [RFC PATCH 12/12] staging; android: ion: Enumerate all available heaps
Date: Thu,  2 Mar 2017 13:44:44 -0800
Message-Id: <1488491084-17252-13-git-send-email-labbott@redhat.com>
In-Reply-To: <1488491084-17252-1-git-send-email-labbott@redhat.com>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Practiaclly speaking, most Ion heaps are either going to be available
all the time (system heaps) or found based off of the reserved-memory
node. Parse the CMA and reserved-memory nodes to assign the heaps.

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/staging/android/ion/Makefile        |  2 +-
 drivers/staging/android/ion/ion_enumerate.c | 89 +++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100644 drivers/staging/android/ion/ion_enumerate.c

diff --git a/drivers/staging/android/ion/Makefile b/drivers/staging/android/ion/Makefile
index eef022b..4ebf655 100644
--- a/drivers/staging/android/ion/Makefile
+++ b/drivers/staging/android/ion/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_ION) +=	ion.o ion-ioctl.o ion_heap.o
+obj-$(CONFIG_ION) +=	ion.o ion-ioctl.o ion_heap.o ion_enumerate.o
 obj-$(CONFIG_ION_SYSTEM_HEAP) += ion_system_heap.o ion_page_pool.o
 obj-$(CONFIG_ION_CARVEOUT_HEAP) += ion_carveout_heap.o
 obj-$(CONFIG_ION_CHUNK_HEAP) += ion_chunk_heap.o
diff --git a/drivers/staging/android/ion/ion_enumerate.c b/drivers/staging/android/ion/ion_enumerate.c
new file mode 100644
index 0000000..21344c7
--- /dev/null
+++ b/drivers/staging/android/ion/ion_enumerate.c
@@ -0,0 +1,89 @@
+#include <linux/kernel.h>
+#include <linux/cma.h>
+
+#include "ion.h"
+#include "ion_priv.h"
+
+static struct ion_device *internal_dev;
+static int heap_id = 2;
+
+static int ion_add_system_heap(void)
+{
+#ifdef CONFIG_ION_SYSTEM_HEAP
+	struct ion_platform_heap pheap;
+	struct ion_heap *heap;
+
+	pheap.type = ION_HEAP_TYPE_SYSTEM;
+	pheap.id = heap_id++;
+	pheap.name = "ion_system_heap";
+
+	heap = ion_heap_create(&pheap);
+	if (!heap)
+		return -ENODEV;
+
+	ion_device_add_heap(internal_dev, heap);
+#endif
+	return 0;
+}
+
+static int ion_add_system_contig_heap(void)
+{
+#ifdef CONFIG_ION_SYSTEM_HEAP
+	struct ion_platform_heap pheap;
+	struct ion_heap *heap;
+
+	pheap.type = ION_HEAP_TYPE_SYSTEM_CONTIG;
+	pheap.id = heap_id++;
+	pheap.name = "ion_system_contig_heap";
+
+	heap = ion_heap_create(&pheap);
+	if (!heap)
+		return -ENODEV;
+
+	ion_device_add_heap(internal_dev, heap);
+#endif
+	return 0;
+}
+
+#ifdef CONFIG_ION_CMA_HEAP
+int __ion_add_cma_heaps(struct cma *cma, void *data)
+{
+	struct ion_heap *heap;
+	struct ion_platform_heap pheap;
+
+	pheap.type = ION_HEAP_TYPE_DMA;
+	pheap.id = heap_id++;
+	pheap.name = cma_get_name(cma);
+	pheap.priv = cma;
+
+	heap = ion_heap_create(&pheap);
+	if (!heap)
+		return -ENODEV;
+
+	ion_device_add_heap(internal_dev, heap);
+	return 0;
+}
+#endif
+
+
+static int ion_add_cma_heaps(void)
+{
+#ifdef CONFIG_ION_CMA_HEAP
+	cma_for_each_area(__ion_add_cma_heaps, NULL);
+#endif
+	return 0;
+}
+
+int ion_enumerate(void)
+{
+	internal_dev = ion_device_create(NULL);
+	if (IS_ERR(internal_dev))
+		return PTR_ERR(internal_dev);
+
+	ion_add_system_heap();
+	ion_add_system_contig_heap();
+
+	ion_add_cma_heaps();
+	return 0;
+}
+subsys_initcall(ion_enumerate);
-- 
2.7.4
