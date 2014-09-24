Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34168 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaIXW1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:55 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Archit Taneja <archit@ti.com>,
	Kamil Debski <k.debski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 18/18] [media] ti-vpe: Fix typecast
Date: Wed, 24 Sep 2014 19:27:18 -0300
Message-Id: <a77e94eb08a2c8881228d0ed6cb0660a0666493c.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Addresses have the same size of unsigned long, and not u32.

That removes a warning on 64 bits compilation:
drivers/media//platform/ti-vpe/vpdma.c:332:11: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  WARN_ON(((u32) buf->addr & VPDMA_DESC_ALIGN) != 0);
           ^
include/asm-generic/bug.h:86:25: note: in definition of macro ‘WARN_ON’
  int __ret_warn_on = !!(condition);    \
                         ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 684ba19bbedd..3e2e3a33e6ed 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -329,7 +329,7 @@ int vpdma_alloc_desc_buf(struct vpdma_buf *buf, size_t size)
 	if (!buf->addr)
 		return -ENOMEM;
 
-	WARN_ON(((u32) buf->addr & VPDMA_DESC_ALIGN) != 0);
+	WARN_ON(((unsigned long)buf->addr & VPDMA_DESC_ALIGN) != 0);
 
 	return 0;
 }
-- 
1.9.3

