Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbcCYKpP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:15 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 54/54] v4l: vsp1: Update WPF and LIF maximum sizes for Gen3
Date: Fri, 25 Mar 2016 12:44:28 +0200
Message-Id: <1458902668-1141-55-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The maximum image size supported by the WPF is 2048x2048 on Gen2 and
8190x8190 on Gen3. Update the code accordingly, and fix the maximum LIF
size for both Gen2 and Gen3.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lif.c |  2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c | 15 +++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index d1d52a25c15b..4275ec3d2043 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -21,7 +21,7 @@
 #include "vsp1_lif.h"
 
 #define LIF_MIN_SIZE				2U
-#define LIF_MAX_SIZE				2048U
+#define LIF_MAX_SIZE				8190U
 
 /* -----------------------------------------------------------------------------
  * Device Access
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index a88ed0fc69ac..a50624477d5f 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -21,8 +21,10 @@
 #include "vsp1_rwpf.h"
 #include "vsp1_video.h"
 
-#define WPF_MAX_WIDTH				2048
-#define WPF_MAX_HEIGHT				2048
+#define WPF_GEN2_MAX_WIDTH			2048U
+#define WPF_GEN2_MAX_HEIGHT			2048U
+#define WPF_GEN3_MAX_WIDTH			8190U
+#define WPF_GEN3_MAX_HEIGHT			8190U
 
 /* -----------------------------------------------------------------------------
  * Device Access
@@ -201,8 +203,13 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	if (wpf == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	wpf->max_width = WPF_MAX_WIDTH;
-	wpf->max_height = WPF_MAX_HEIGHT;
+	if (vsp1->info->gen == 2) {
+		wpf->max_width = WPF_GEN2_MAX_WIDTH;
+		wpf->max_height = WPF_GEN2_MAX_HEIGHT;
+	} else {
+		wpf->max_width = WPF_GEN3_MAX_WIDTH;
+		wpf->max_height = WPF_GEN3_MAX_HEIGHT;
+	}
 
 	wpf->entity.ops = &wpf_entity_ops;
 	wpf->entity.type = VSP1_ENTITY_WPF;
-- 
2.7.3

