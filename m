Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55536 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754311AbcI1VQ4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:16:56 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 04/35] media: ti-vpe: vpdma: Fix bus error when vpdma is writing a descriptor
Date: Wed, 28 Sep 2016 16:16:12 -0500
Message-ID: <20160928211643.26298-5-bparrot@ti.com>
In-Reply-To: <20160928211643.26298-1-bparrot@ti.com>
References: <20160928211643.26298-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On DRA7 since l3_noc event are being reported it was found that
when the write descriptor was being written it was consistently
causing bus error events.

The write address was improperly programmed.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma_priv.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma_priv.h b/drivers/media/platform/ti-vpe/vpdma_priv.h
index 65f0c067bed1..aeade5edc8ac 100644
--- a/drivers/media/platform/ti-vpe/vpdma_priv.h
+++ b/drivers/media/platform/ti-vpe/vpdma_priv.h
@@ -212,6 +212,7 @@ struct vpdma_dtd {
 #define DTD_V_START_MASK	0xffff
 #define DTD_V_START_SHFT	0
 
+#define DTD_DESC_START_MASK	0xffffffe0
 #define DTD_DESC_START_SHIFT	5
 #define DTD_WRITE_DESC_MASK	0x01
 #define DTD_WRITE_DESC_SHIFT	2
@@ -294,7 +295,7 @@ static inline u32 dtd_frame_width_height(int width, int height)
 static inline u32 dtd_desc_write_addr(unsigned int addr, bool write_desc,
 			bool drop_data, bool use_desc)
 {
-	return (addr << DTD_DESC_START_SHIFT) |
+	return (addr & DTD_DESC_START_MASK) |
 		(write_desc << DTD_WRITE_DESC_SHIFT) |
 		(drop_data << DTD_DROP_DATA_SHIFT) |
 		use_desc;
@@ -399,7 +400,7 @@ static inline int dtd_get_frame_height(struct vpdma_dtd *dtd)
 
 static inline int dtd_get_desc_write_addr(struct vpdma_dtd *dtd)
 {
-	return dtd->desc_write_addr >> DTD_DESC_START_SHIFT;
+	return dtd->desc_write_addr & DTD_DESC_START_MASK;
 }
 
 static inline bool dtd_get_write_desc(struct vpdma_dtd *dtd)
-- 
2.9.0

