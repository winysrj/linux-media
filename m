Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934710AbdEVOT2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 10:19:28 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, kieran.bingham@ideasonboard.com
Subject: [PATCH v3 2/5] v4l: rcar-fcp: Add an API to retrieve the FCP device
Date: Mon, 22 May 2017 15:19:19 +0100
Message-Id: <e80dfee851a2c92a72d9e02ad1f5faac867efead.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.d1f5942e1a0b688b3527bb7998b184d3c0b0e9b1.1495461942.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The new rcar_fcp_get_device() function retrieves the struct device
related to the FCP device. This is useful to handle DMA mapping through
the right device.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 6 ++++++
 include/media/rcar-fcp.h          | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index e9f609edf513..2988031d285d 100644
--- a/drivers/media/platform/rcar-fcp.c
+++ b/drivers/media/platform/rcar-fcp.c
@@ -78,6 +78,12 @@ void rcar_fcp_put(struct rcar_fcp_device *fcp)
 }
 EXPORT_SYMBOL_GPL(rcar_fcp_put);
 
+struct device *rcar_fcp_get_device(struct rcar_fcp_device *fcp)
+{
+	return fcp->dev;
+}
+EXPORT_SYMBOL_GPL(rcar_fcp_get_device);
+
 /**
  * rcar_fcp_enable - Enable an FCP
  * @fcp: The FCP instance
diff --git a/include/media/rcar-fcp.h b/include/media/rcar-fcp.h
index 8723f05c6321..b60a7b176c37 100644
--- a/include/media/rcar-fcp.h
+++ b/include/media/rcar-fcp.h
@@ -19,6 +19,7 @@ struct rcar_fcp_device;
 #if IS_ENABLED(CONFIG_VIDEO_RENESAS_FCP)
 struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np);
 void rcar_fcp_put(struct rcar_fcp_device *fcp);
+struct device *rcar_fcp_get_device(struct rcar_fcp_device *fcp);
 int rcar_fcp_enable(struct rcar_fcp_device *fcp);
 void rcar_fcp_disable(struct rcar_fcp_device *fcp);
 #else
@@ -27,6 +28,10 @@ static inline struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np)
 	return ERR_PTR(-ENOENT);
 }
 static inline void rcar_fcp_put(struct rcar_fcp_device *fcp) { }
+static inline struct device *rcar_fcp_get_device(struct rcar_fcp_device *fcp)
+{
+	return NULL;
+}
 static inline int rcar_fcp_enable(struct rcar_fcp_device *fcp)
 {
 	return 0;
-- 
git-series 0.9.1
