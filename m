Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbcCXX2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:08 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 18/51] v4l: vsp1: Enable display list support for the HS[IT], LUT, SRU and UDS
Date: Fri, 25 Mar 2016 01:27:14 +0200
Message-Id: <1458862067-19525-19-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those modules were left out of display list integration as they're not
used by the DRM pipeline. To prepare for display list support in non-DRM
pipelines use the module write API to set registers.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_hsit.c | 2 +-
 drivers/media/platform/vsp1/vsp1_lut.c  | 2 +-
 drivers/media/platform/vsp1/vsp1_sru.c  | 2 +-
 drivers/media/platform/vsp1/vsp1_uds.c  | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index ce42ce2e4847..e971dfa9714d 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -28,7 +28,7 @@
 
 static inline void vsp1_hsit_write(struct vsp1_hsit *hsit, u32 reg, u32 data)
 {
-	vsp1_write(hsit->entity.vsp1, reg, data);
+	vsp1_mod_write(&hsit->entity, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index f0cd4f79fbff..c24712fe5f2c 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -29,7 +29,7 @@
 
 static inline void vsp1_lut_write(struct vsp1_lut *lut, u32 reg, u32 data)
 {
-	vsp1_write(lut->entity.vsp1, reg, data);
+	vsp1_mod_write(&lut->entity, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index a97541492af8..7de62be37cff 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -28,7 +28,7 @@
 
 static inline void vsp1_sru_write(struct vsp1_sru *sru, u32 reg, u32 data)
 {
-	vsp1_write(sru->entity.vsp1, reg, data);
+	vsp1_mod_write(&sru->entity, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index b1881a0a314f..7eaf42a2b036 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -31,8 +31,8 @@
 
 static inline void vsp1_uds_write(struct vsp1_uds *uds, u32 reg, u32 data)
 {
-	vsp1_write(uds->entity.vsp1,
-		   reg + uds->entity.index * VI6_UDS_OFFSET, data);
+	vsp1_mod_write(&uds->entity, reg + uds->entity.index * VI6_UDS_OFFSET,
+		       data);
 }
 
 /* -----------------------------------------------------------------------------
-- 
2.7.3

