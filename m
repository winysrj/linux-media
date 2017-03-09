Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59439 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdCIUSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 15:18:31 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] [media] coda: fix warnings when compiling with 64 bits
Date: Thu,  9 Mar 2017 17:17:59 -0300
Message-Id: <731ad204e54e3c0092668b79c8b3df47502333c6.1489090677.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/coda/coda-common.c: In function ‘coda_alloc_aux_buf’:
./include/linux/kern_levels.h:4:18: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘size_t {aka long unsigned int}’ [-Wformat=]
 #define KERN_SOH "\001"  /* ASCII Start Of Header */
                  ^
./include/media/v4l2-common.h:69:9: note: in definition of macro ‘v4l2_printk’
  printk(level "%s: " fmt, (dev)->name , ## arg)
         ^~~~~
./include/linux/kern_levels.h:10:18: note: in expansion of macro ‘KERN_SOH’
 #define KERN_ERR KERN_SOH "3" /* error conditions */
                  ^~~~~~~~
./include/media/v4l2-common.h:72:14: note: in expansion of macro ‘KERN_ERR’
  v4l2_printk(KERN_ERR, dev, fmt , ## arg)
              ^~~~~~~~
drivers/media/platform/coda/coda-common.c:1341:3: note: in expansion of macro ‘v4l2_err’
   v4l2_err(&dev->v4l2_dev,
   ^~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index cb76c96759b9..dc51ae2050cc 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1339,7 +1339,7 @@ int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
 					GFP_KERNEL);
 	if (!buf->vaddr) {
 		v4l2_err(&dev->v4l2_dev,
-			 "Failed to allocate %s buffer of size %u\n",
+			 "Failed to allocate %s buffer of size %zd\n",
 			 name, size);
 		return -ENOMEM;
 	}
-- 
2.9.3
