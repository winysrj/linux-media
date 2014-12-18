Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:52174 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLROtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 09:49:36 -0500
Message-ID: <1418914173.22813.15.camel@xylophone.i.decadent.org.uk>
Subject: [RFC PATCH 2/5] media: rcar_vin: Ensure all in-flight buffers are
 returned to error state before stopping.
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 18 Dec 2014 14:49:33 +0000
In-Reply-To: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ian Molton <ian.molton@codethink.co.uk>

Videobuf2 complains about buffers that are still marked ACTIVE (in use by the driver) following a call to stop_streaming().

This patch returns all active buffers to state ERROR prior to stopping.

Note: this introduces a (non fatal) race condition as the stream is not guaranteed to be stopped at this point.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 773de53..7069176 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -516,8 +516,14 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct rcar_vin_priv *priv = ici->priv;
 	struct list_head *buf_head, *tmp;
+	int i;
 
 	spin_lock_irq(&priv->lock);
+
+	for (i = 0; i < vq->num_buffers; ++i)
+		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
+			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
+
 	list_for_each_safe(buf_head, tmp, &priv->capture)
 		list_del_init(buf_head);
 	spin_unlock_irq(&priv->lock);
-- 
1.7.10.4




