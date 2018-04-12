Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34295 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753954AbeDLPYa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Hans Verkuil <hansverk@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 09/17] media: platform: fix some 64-bits warnings
Date: Thu, 12 Apr 2018 11:24:01 -0400
Message-Id: <04fe60ef9cdd0c046a7d0dab0ac4e1caeec33895.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
In-Reply-To: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
References: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The omap/omap3 and viu drivers are for 32 bit platforms only.
There, a pointer has 32 bits. Now that those drivers build
for 64 bits with COMPILE_TEST, they produce the following
warnings:

drivers/media/platform/omap/omap_vout_vrfb.c: In function 'omap_vout_allocate_vrfb_buffers':
drivers/media/platform/omap/omap_vout_vrfb.c:57:10: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   memset((void *) vout->smsshado_virt_addr[i], 0,
          ^
drivers/media/platform/fsl-viu.c: In function 'viu_setup_preview':
drivers/media/platform/fsl-viu.c:753:28: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  reg_val.field_base_addr = (u32)dev->ovbuf.base;
                            ^
drivers/media/platform/omap/omap_vout.c: In function 'omap_vout_get_userptr':
drivers/media/platform/omap/omap_vout.c:209:25: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   *physp = virt_to_phys((void *)virtp);
                         ^
drivers/media/platform/omap3isp/ispccdc.c: In function 'ccdc_config':
drivers/media/platform/omap3isp/ispccdc.c:738:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
         (__force void __user *)fpc.fpcaddr,
         ^

Add some typecasts to remove those warnings when building for
64 bits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/fsl-viu.c             | 2 +-
 drivers/media/platform/omap/omap_vout.c      | 2 +-
 drivers/media/platform/omap/omap_vout_vrfb.c | 4 ++--
 drivers/media/platform/omap3isp/ispccdc.c    | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 5b6bfcafc2a4..e41510ce69a4 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -750,7 +750,7 @@ static int viu_setup_preview(struct viu_dev *dev, struct viu_fh *fh)
 	reg_val.status_cfg |= DMA_ACT | INT_DMA_END_EN | INT_FIELD_EN;
 
 	/* setup the base address of the overlay buffer */
-	reg_val.field_base_addr = (u32)dev->ovbuf.base;
+	reg_val.field_base_addr = (u32)(long)dev->ovbuf.base;
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index e2723fedac8d..5700b7818621 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -198,7 +198,7 @@ static int omap_vout_try_format(struct v4l2_pix_format *pix)
  * omap_vout_get_userptr: Convert user space virtual address to physical
  * address.
  */
-static int omap_vout_get_userptr(struct videobuf_buffer *vb, u32 virtp,
+static int omap_vout_get_userptr(struct videobuf_buffer *vb, long virtp,
 				 u32 *physp)
 {
 	struct frame_vector *vec;
diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index 1d8508237220..29e3f5da59c1 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -54,8 +54,8 @@ static int omap_vout_allocate_vrfb_buffers(struct omap_vout_device *vout,
 			*count = 0;
 			return -ENOMEM;
 		}
-		memset((void *) vout->smsshado_virt_addr[i], 0,
-				vout->smsshado_size);
+		memset((void *)(long)vout->smsshado_virt_addr[i], 0,
+		       vout->smsshado_size);
 	}
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index b66276ab5765..77b73e27a274 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -735,7 +735,7 @@ static int ccdc_config(struct isp_ccdc_device *ccdc,
 				return -ENOMEM;
 
 			if (copy_from_user(fpc_new.addr,
-					   (__force void __user *)fpc.fpcaddr,
+					   (__force void __user *)(long)fpc.fpcaddr,
 					   size)) {
 				dma_free_coherent(isp->dev, size, fpc_new.addr,
 						  fpc_new.dma);
-- 
2.14.3
