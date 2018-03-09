Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49655 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750954AbeCIKKl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 05:10:41 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Icenowy Zheng <icenowy@aosc.xyz>,
        Florent Revest <revestflo@gmail.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Thomas van Kleef <thomas@vitsch.nl>,
        "Signed-off-by : Bob Ham" <rah@settrans.net>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH 1/9] media: vim2m: Try to schedule a m2m device run on request submission
Date: Fri,  9 Mar 2018 11:09:25 +0100
Message-Id: <20180309100933.15922-2-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180309100933.15922-1-paul.kocialkowski@bootlin.com>
References: <20180309100933.15922-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the most basic use scenario, where only one output and one capture
buffers are queued and the request is submitted, there is no provision
to try to schedule a m2m device run.

This adds the appropriate call to the vim2m_request_submit so that it
can start in that scenario.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/media/platform/vim2m.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 02793dd9a330..578c9170083c 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -933,9 +933,20 @@ static int vim2m_request_submit(struct media_request *req,
 				struct media_request_entity_data *_data)
 {
 	struct v4l2_request_entity_data *data;
+	struct vim2m_ctx *ctx;
+	int rc;
 
 	data = to_v4l2_entity_data(_data);
-	return vb2_request_submit(data);
+
+	ctx = container_of(_data->entity, struct vim2m_ctx, req_entity.base);
+
+	rc = vb2_request_submit(data);
+	if (rc)
+		return rc;
+
+	v4l2_m2m_try_schedule(ctx->fh.m2m_ctx);
+
+	return 0;
 }
 
 static const struct media_request_entity_ops vim2m_request_entity_ops = {
-- 
2.16.2
