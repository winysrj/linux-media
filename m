Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52349 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbbIMU5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:24 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 19/32] v4l: vsp1: Remove unused module write functions
Date: Sun, 13 Sep 2015 23:56:57 +0300
Message-Id: <1442177830-24536-20-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several module write functions are not used, remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c | 5 -----
 drivers/media/platform/vsp1/vsp1_lif.c | 5 -----
 drivers/media/platform/vsp1/vsp1_lut.c | 5 -----
 drivers/media/platform/vsp1/vsp1_rpf.c | 6 ------
 drivers/media/platform/vsp1/vsp1_uds.c | 6 ------
 5 files changed, 27 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index b4cc9bc478af..841bc6664bca 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -28,11 +28,6 @@
  * Device Access
  */
 
-static inline u32 vsp1_bru_read(struct vsp1_bru *bru, u32 reg)
-{
-	return vsp1_read(bru->entity.vsp1, reg);
-}
-
 static inline void vsp1_bru_write(struct vsp1_bru *bru, u32 reg, u32 data)
 {
 	vsp1_write(bru->entity.vsp1, reg, data);
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 39fa5ef20fbb..b868bce08982 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -26,11 +26,6 @@
  * Device Access
  */
 
-static inline u32 vsp1_lif_read(struct vsp1_lif *lif, u32 reg)
-{
-	return vsp1_read(lif->entity.vsp1, reg);
-}
-
 static inline void vsp1_lif_write(struct vsp1_lif *lif, u32 reg, u32 data)
 {
 	vsp1_write(lif->entity.vsp1, reg, data);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 656ec272a414..9e33caa9c616 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -27,11 +27,6 @@
  * Device Access
  */
 
-static inline u32 vsp1_lut_read(struct vsp1_lut *lut, u32 reg)
-{
-	return vsp1_read(lut->entity.vsp1, reg);
-}
-
 static inline void vsp1_lut_write(struct vsp1_lut *lut, u32 reg, u32 data)
 {
 	vsp1_write(lut->entity.vsp1, reg, data);
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index c0b7f76cd0b5..b9c39f9e4458 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -26,12 +26,6 @@
  * Device Access
  */
 
-static inline u32 vsp1_rpf_read(struct vsp1_rwpf *rpf, u32 reg)
-{
-	return vsp1_read(rpf->entity.vsp1,
-			 reg + rpf->entity.index * VI6_RPF_OFFSET);
-}
-
 static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
 {
 	vsp1_write(rpf->entity.vsp1,
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index ccc8243e3493..27ad07466ebd 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -29,12 +29,6 @@
  * Device Access
  */
 
-static inline u32 vsp1_uds_read(struct vsp1_uds *uds, u32 reg)
-{
-	return vsp1_read(uds->entity.vsp1,
-			 reg + uds->entity.index * VI6_UDS_OFFSET);
-}
-
 static inline void vsp1_uds_write(struct vsp1_uds *uds, u32 reg, u32 data)
 {
 	vsp1_write(uds->entity.vsp1,
-- 
2.4.6

