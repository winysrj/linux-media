Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:44795 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbbBXS07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Feb 2015 13:26:59 -0500
Received: by wesk11 with SMTP id k11so26935366wes.11
        for <linux-media@vger.kernel.org>; Tue, 24 Feb 2015 10:26:58 -0800 (PST)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: omap/omap_vout: fix type of input members to omap_vout_setup_vrfb_bufs()
Date: Tue, 24 Feb 2015 18:25:00 +0000
Message-Id: <1424802300-30357-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

the declaration for omap_vout_setup_vrfb_bufs() said it
needed 'u32 static_vrfb_allocation' but definition
took 'bool static_vrfb_allocation', this patch fixes the
declaration so that it matches with the definition and
pass a bool instead of int to the call, also included
omap_vout_vrfb.h in omap_vout_vrfb.c file so that sparse doesn't
complain of making omap_vout_setup_vrfb_bufs() as static function.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/omap/omap_vout.c      | 2 +-
 drivers/media/platform/omap/omap_vout_vrfb.c | 1 +
 drivers/media/platform/omap/omap_vout_vrfb.h | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index ba2d8f9..17b189a 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1978,7 +1978,7 @@ static int __init omap_vout_setup_video_bufs(struct platform_device *pdev,
 	vout->cropped_offset = 0;
 
 	if (ovid->rotation_type == VOUT_ROT_VRFB) {
-		int static_vrfb_allocation = (vid_num == 0) ?
+		bool static_vrfb_allocation = (vid_num == 0) ?
 			vid1_static_vrfb_alloc : vid2_static_vrfb_alloc;
 		ret = omap_vout_setup_vrfb_bufs(pdev, vid_num,
 				static_vrfb_allocation);
diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index aa39306..c6e2527 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -21,6 +21,7 @@
 
 #include "omap_voutdef.h"
 #include "omap_voutlib.h"
+#include "omap_vout_vrfb.h"
 
 #define OMAP_DMA_NO_DEVICE	0
 
diff --git a/drivers/media/platform/omap/omap_vout_vrfb.h b/drivers/media/platform/omap/omap_vout_vrfb.h
index 4c23148..c976975 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.h
+++ b/drivers/media/platform/omap/omap_vout_vrfb.h
@@ -15,7 +15,7 @@
 #ifdef CONFIG_VIDEO_OMAP2_VOUT_VRFB
 void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout);
 int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
-			u32 static_vrfb_allocation);
+			bool static_vrfb_allocation);
 void omap_vout_release_vrfb(struct omap_vout_device *vout);
 int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
 			unsigned int *count, unsigned int startindex);
@@ -25,7 +25,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout);
 #else
 static inline void omap_vout_free_vrfb_buffers(struct omap_vout_device *vout) { };
 static inline int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
-			u32 static_vrfb_allocation)
+			bool static_vrfb_allocation)
 		{ return 0; };
 static inline void omap_vout_release_vrfb(struct omap_vout_device *vout) { };
 static inline int omap_vout_vrfb_buffer_setup(struct omap_vout_device *vout,
-- 
1.9.1

