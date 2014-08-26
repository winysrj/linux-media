Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44179 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 16/35] [media] omap: fix compilation if !VIDEO_OMAP2_VOUT_VRFB
Date: Tue, 26 Aug 2014 18:54:52 -0300
Message-Id: <1409090111-8290-17-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When CONFIG_VIDEO_OMAP2_VOUT_VRFB is disabled, the compilation
will fail, as the function stubs are wrong. Also, as they weren't
declared as static inline, lots of warnings will be generated.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/omap/omap_vout_vrfb.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.h b/drivers/media/platform/omap/omap_vout_vrfb.h
index ffde741e0590..4c2314839b48 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.h
+++ b/drivers/media/platform/omap/omap_vout_vrfb.h
@@ -23,18 +23,18 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
 			struct videobuf_buffer *vb);
 void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout);
 #else
-void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout) { }
-int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
+static inline void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout) { };
+static inline int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
 			u32 static_vrfb_allocation)
-		{ return 0; }
-void omap_vout_release_vrfb(struct omap_vout_device *vout) { }
-int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
+		{ return 0; };
+static inline void omap_vout_release_vrfb(struct omap_vout_device *vout) { };
+static inline int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
 			unsigned int *count, unsigned int startindex)
-		{ return 0; }
-int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
+		{ return 0; };
+static inline int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
 			struct videobuf_buffer *vb)
-		{ return 0; }
-void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout) { }
+		{ return 0; };
+static inline void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout) { };
 #endif
 
 #endif
-- 
1.9.3

