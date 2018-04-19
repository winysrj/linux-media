Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42530 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753230AbeDSPnw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 11:43:52 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: [PATCH v2 04/10] media: vim2m: Implement media request complete op to schedule m2m run
Date: Thu, 19 Apr 2018 17:41:18 +0200
Message-Id: <20180419154124.17512-5-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
References: <20180419154124.17512-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds an implementation of the media request complete operation for
the vim2m driver, that ensures that the driver will try to schedule a
m2m run whenever a request was completed. Without this operation, no m2m
device run will be scheduled in many scenarios.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/media/platform/vim2m.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 2dcf0ea85705..08c4c5566614 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -453,6 +453,17 @@ static void device_isr(struct timer_list *t)
 	schedule_work(&vim2m_dev->work_run);
 }
 
+static void request_complete(struct media_request *req)
+{
+	struct vim2m_ctx *curr_ctx;
+
+	curr_ctx = (struct vim2m_ctx *) vb2_core_request_find_buffer_priv(req);
+	if (curr_ctx == NULL)
+		return;
+
+	v4l2_m2m_try_schedule(curr_ctx->fh.m2m_ctx);
+}
+
 /*
  * video ioctls
  */
@@ -1025,6 +1036,7 @@ static const struct v4l2_m2m_ops m2m_ops = {
 
 static const struct media_device_ops m2m_media_ops = {
 	.req_queue = vb2_request_queue,
+	.req_complete = request_complete,
 };
 
 static int vim2m_probe(struct platform_device *pdev)
-- 
2.16.3
