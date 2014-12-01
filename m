Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52750 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212AbaLALqS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 06:46:18 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DBD622A008F
	for <linux-media@vger.kernel.org>; Mon,  1 Dec 2014 12:46:02 +0100 (CET)
Message-ID: <547C54FA.10509@xs4all.nl>
Date: Mon, 01 Dec 2014 12:46:02 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2] omap_vout: fix compile warnings
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When compiling under COMPILE_TEST on a x86_64 the following warnings
appear:

drivers/media/platform/omap/omap_vout.c: In function 'omap_vout_uservirt_to_phys':
drivers/media/platform/omap/omap_vout.c:209:23: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   return virt_to_phys((void *) virtp);
                       ^
drivers/media/platform/omap/omap_vout.c: In function 'omapvid_setup_overlay':
drivers/media/platform/omap/omap_vout.c:420:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
  v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
  ^
drivers/media/platform/omap/omap_vout.c: In function 'omap_vout_buffer_prepare':
drivers/media/platform/omap/omap_vout.c:794:34: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   vout->queued_buf_addr[vb->i] = (u8 *)
                                  ^
In file included from arch/x86/include/asm/dma-mapping.h:44:0,
                 from include/linux/dma-mapping.h:82,
                 from drivers/media/platform/omap/omap_vout.c:40:
drivers/media/platform/omap/omap_vout.c:803:58: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   dma_addr = dma_map_single(vout->vid_dev->v4l2_dev.dev, (void *) addr,
                                                          ^
include/asm-generic/dma-mapping-common.h:174:60: note: in definition of macro 'dma_map_single'
 #define dma_map_single(d, a, s, r) dma_map_single_attrs(d, a, s, r, NULL)
                                                            ^

These are fixed by this patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/omap/omap_vout.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index d39e2b4..ba2d8f9 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -198,7 +198,7 @@ static int omap_vout_try_format(struct v4l2_pix_format *pix)
  * omap_vout_uservirt_to_phys: This inline function is used to convert user
  * space virtual address to physical address.
  */
-static u32 omap_vout_uservirt_to_phys(u32 virtp)
+static unsigned long omap_vout_uservirt_to_phys(unsigned long virtp)
 {
 	unsigned long physp = 0;
 	struct vm_area_struct *vma;
@@ -418,10 +418,10 @@ static int omapvid_setup_overlay(struct omap_vout_device *vout,
 	}
 
 	v4l2_dbg(1, debug, &vout->vid_dev->v4l2_dev,
-		"%s enable=%d addr=%x width=%d\n height=%d color_mode=%d\n"
+		"%s enable=%d addr=%pad width=%d\n height=%d color_mode=%d\n"
 		"rotation=%d mirror=%d posx=%d posy=%d out_width = %d \n"
 		"out_height=%d rotation_type=%d screen_width=%d\n",
-		__func__, ovl->is_enabled(ovl), info.paddr, info.width, info.height,
+		__func__, ovl->is_enabled(ovl), &info.paddr, info.width, info.height,
 		info.color_mode, info.rotation, info.mirror, info.pos_x,
 		info.pos_y, info.out_width, info.out_height, info.rotation_type,
 		info.screen_width);
@@ -794,7 +794,7 @@ static int omap_vout_buffer_prepare(struct videobuf_queue *q,
 		vout->queued_buf_addr[vb->i] = (u8 *)
 			omap_vout_uservirt_to_phys(vb->baddr);
 	} else {
-		u32 addr, dma_addr;
+		unsigned long addr, dma_addr;
 		unsigned long size;
 
 		addr = (unsigned long) vout->buf_virt_addr[vb->i];
-- 
2.1.3

