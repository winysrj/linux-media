Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:36048 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933396AbcLIMfY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Dec 2016 07:35:24 -0500
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: linux-renesas-soc@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, magnus.damm@gmail.com,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v1.5 2/6] v4l: rcar-fcp: Add an API to retrieve the FCP device
Date: Fri,  9 Dec 2016 13:35:08 +0100
Message-Id: <1481286912-16555-3-git-send-email-ulrich.hecht+renesas@gmail.com>
In-Reply-To: <1481286912-16555-1-git-send-email-ulrich.hecht+renesas@gmail.com>
References: <1481286912-16555-1-git-send-email-ulrich.hecht+renesas@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The new rcar_fcp_get_device() function retrieves the struct device
related to the FCP device. This is useful to handle DMA mapping through
the right device.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-fcp.c | 6 ++++++
 include/media/rcar-fcp.h          | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/media/platform/rcar-fcp.c b/drivers/media/platform/rcar-fcp.c
index e9f609e..2988031 100644
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
index 8723f05..b60a7b1 100644
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
2.7.4

