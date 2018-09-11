Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbeIKSlm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:41:42 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 01/13] udmabuf: sort headers, drop uapi/ path prefix
Date: Tue, 11 Sep 2018 15:42:04 +0200
Message-Id: <20180911134216.9760-2-kraxel@redhat.com>
In-Reply-To: <20180911134216.9760-1-kraxel@redhat.com>
References: <20180911134216.9760-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/dma-buf/udmabuf.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 2e8502250a..155050c741 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -1,17 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/init.h>
-#include <linux/module.h>
+#include <linux/cred.h>
 #include <linux/device.h>
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/miscdevice.h>
 #include <linux/dma-buf.h>
 #include <linux/highmem.h>
-#include <linux/cred.h>
-#include <linux/shmem_fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/memfd.h>
-
-#include <uapi/linux/udmabuf.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/shmem_fs.h>
+#include <linux/slab.h>
+#include <linux/udmabuf.h>
 
 struct udmabuf {
 	u32 pagecount;
-- 
2.9.3
