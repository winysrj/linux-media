Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaIXW1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH 17/18] [media] s3c-camif: fix dma_addr_t printks
Date: Wed, 24 Sep 2014 19:27:17 -0300
Message-Id: <4749fc9fe2ece4e42627b27b01d6939c536fbcea.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media//platform/s3c-camif/camif-capture.c: In function ‘camif_prepare_addr’:
include/linux/dynamic_debug.h:64:16: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘dma_addr_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:266:2: note: in expansion of macro ‘dynamic_pr_debug’
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
drivers/media//platform/s3c-camif/camif-capture.c:283:2: note: in expansion of macro ‘pr_debug’
  pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
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
drivers/media//platform/s3c-camif/camif-capture.c:283:2: note: in expansion of macro ‘pr_debug’
  pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 7 has type ‘dma_addr_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:266:2: note: in expansion of macro ‘dynamic_pr_debug’
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
drivers/media//platform/s3c-camif/camif-capture.c:283:2: note: in expansion of macro ‘pr_debug’
  pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format ‘%X’ expects argument of type ‘unsigned int’, but argument 6 has type ‘dma_addr_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:266:2: note: in expansion of macro ‘dynamic_pr_debug’
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
drivers/media//platform/s3c-camif/camif-regs.c:217:2: note: in expansion of macro ‘pr_debug’
  pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format ‘%X’ expects argument of type ‘unsigned int’, but argument 7 has type ‘dma_addr_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:266:2: note: in expansion of macro ‘dynamic_pr_debug’
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
drivers/media//platform/s3c-camif/camif-regs.c:217:2: note: in expansion of macro ‘pr_debug’
  pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
  ^
include/linux/dynamic_debug.h:64:16: warning: format ‘%X’ expects argument of type ‘unsigned int’, but argument 8 has type ‘dma_addr_t’ [-Wformat=]
  static struct _ddebug  __aligned(8)   \
                ^
include/linux/dynamic_debug.h:76:2: note: in expansion of macro ‘DEFINE_DYNAMIC_DEBUG_METADATA’
  DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
  ^
include/linux/printk.h:266:2: note: in expansion of macro ‘dynamic_pr_debug’
  dynamic_pr_debug(fmt, ##__VA_ARGS__)
  ^
drivers/media//platform/s3c-camif/camif-regs.c:217:2: note: in expansion of macro ‘pr_debug’
  pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
  ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index f33641384e15..4f81b4c9d113 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -280,8 +280,8 @@ static int camif_prepare_addr(struct camif_vp *vp, struct vb2_buffer *vb,
 		return -EINVAL;
 	}
 
-	pr_debug("DMA address: y: %#x  cb: %#x cr: %#x\n",
-		 paddr->y, paddr->cb, paddr->cr);
+	pr_debug("DMA address: y: %pad  cb: %pad cr: %pad\n",
+		 &paddr->y, &paddr->cb, &paddr->cr);
 
 	return 0;
 }
diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
index ebf5b184cce4..6e0c9988a191 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.c
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -214,8 +214,8 @@ void camif_hw_set_output_addr(struct camif_vp *vp,
 								paddr->cr);
 	}
 
-	pr_debug("dst_buf[%d]: %#X, cb: %#X, cr: %#X\n",
-		 i, paddr->y, paddr->cb, paddr->cr);
+	pr_debug("dst_buf[%d]: %pad, cb: %pad, cr: %pad\n",
+		 i, &paddr->y, &paddr->cb, &paddr->cr);
 }
 
 static void camif_hw_set_out_dma_size(struct camif_vp *vp)
-- 
1.9.3

