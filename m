Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35854 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbbCOOjp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 10:39:45 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH/RFC] media: soc_camera: rcar_vin: Fix wait_for_completion
Date: Sun, 15 Mar 2015 23:39:33 +0900
Message-Id: <1426430373-3443-1-git-send-email-ykaneko0929@gmail.com>
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

 drivers/media/platform/soc_camera/rcar_vin.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 279ab9f..ff0359b 100644
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
@@ -821,6 +823,10 @@ static void rcar_vin_wait_stop_streaming(struct rcar_vin_priv *priv)
 			priv->request_to_stop = true;
 			spin_unlock_irq(&priv->lock);
 			wait_for_completion(&priv->capture_stop);
+			if (!wait_for_completion_timeout(
+				&priv->capture_stop,
+				msecs_to_jiffies(TIMEOUT_MS)))
+				priv->state = STOPPED;
 			spin_lock_irq(&priv->lock);
 		}
 	}
-- 
1.9.1

