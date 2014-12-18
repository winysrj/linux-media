Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:52141 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaLROtP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 09:49:15 -0500
Message-ID: <1418914152.22813.14.camel@xylophone.i.decadent.org.uk>
Subject: [RFC PATCH 1/5] media: rcar_vin: Dont aggressively retire buffers
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 18 Dec 2014 14:49:12 +0000
In-Reply-To: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

rcar_vin_videobuf_release() is called once per buffer from the buf_cleanup hook.

There is no need to look up the queue and free all buffers at this point.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 8d8438b..773de53 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -496,17 +496,11 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
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
1.7.10.4




