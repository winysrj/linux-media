Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:37429 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753215AbaGHJl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Jul 2014 05:41:26 -0400
From: Ian Molton <ian.molton@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: linux-kernel@lists.codethink.co.uk, ian.molton@codethink.co.uk,
	g.liakhovetski@gmx.de, m.chehab@samsung.com,
	vladimir.barinov@cogentembedded.com, magnus.damm@gmail.com,
	horms@verge.net.au, linux-sh@vger.kernel.org
Subject: [PATCH 1/4] media: rcar_vin: Dont aggressively retire buffers
Date: Tue,  8 Jul 2014 10:41:11 +0100
Message-Id: <1404812474-7627-2-git-send-email-ian.molton@codethink.co.uk>
In-Reply-To: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rcar_vin_videobuf_release() is called once per buffer from the buf_cleanup hook.

There is no need to look up the queue and free all buffers at this point.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index e594230..7154500 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -493,17 +493,11 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
 		 * to release could be any of the current buffers in use, so
 		 * release all buffers that are in use by HW
 		 */
-		for (i = 0; i < MAX_BUFFER_NUM; i++) {
-			if (priv->queue_buf[i]) {
-				vb2_buffer_done(priv->queue_buf[i],
-					VB2_BUF_STATE_ERROR);
-				priv->queue_buf[i] = NULL;
-			}
-		}
-	} else {
-		list_del_init(to_buf_list(vb));
+		priv->queue_buf[i] = NULL;
 	}
 
+	list_del_init(to_buf_list(vb));
+
 	spin_unlock_irq(&priv->lock);
 }
 
-- 
1.9.1

