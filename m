Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35352 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbbCPQMA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 12:12:00 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v2] media: soc_camera: rcar_vin: Fix wait_for_completion
Date: Tue, 17 Mar 2015 01:11:33 +0900
Message-Id: <1426522293-25700-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

When stopping abnormally, a driver can't return from wait_for_completion.
This patch resolved this problem by changing wait_for_completion_timeout
from wait_for_completion.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

This patch is against master branch of linuxtv.org/media_tree.git.

v2 [Yoshihiro Kaneko]
* remove the original line that I forgot.
* fix an indent to make it easy to read.

 drivers/media/platform/soc_camera/rcar_vin.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 279ab9f..e55d7ba 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -135,6 +135,8 @@
 #define VIN_MAX_WIDTH		2048
 #define VIN_MAX_HEIGHT		2048
 
+#define TIMEOUT_MS		100
+
 enum chip_id {
 	RCAR_GEN2,
 	RCAR_H1,
@@ -820,7 +822,10 @@ static void rcar_vin_wait_stop_streaming(struct rcar_vin_priv *priv)
 		if (priv->state == STOPPING) {
 			priv->request_to_stop = true;
 			spin_unlock_irq(&priv->lock);
-			wait_for_completion(&priv->capture_stop);
+			if (!wait_for_completion_timeout(
+					&priv->capture_stop,
+					msecs_to_jiffies(TIMEOUT_MS)))
+				priv->state = STOPPED;
 			spin_lock_irq(&priv->lock);
 		}
 	}
-- 
1.9.1

