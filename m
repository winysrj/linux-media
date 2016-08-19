Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51092 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755070AbcHSIja (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:39:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 4/6] v4l: rcar-fcp: Add an API to retrieve the FCP device
Date: Fri, 19 Aug 2016 11:39:32 +0300
Message-Id: <1471595974-28960-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new rcar_fcp_get_device() function retrieves the struct device
related to the FCP device. This is useful to handle DMA mapping through
the right device.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 6 ++++++
 include/media/rcar-fcp.h          | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index 7427be1c3741..60e7ec17d4e2 100644
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
Regards,

Laurent Pinchart

