Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44995 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcHQNb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 09:31:59 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Geert Uytterhoeven <geert@glider.be>
Subject: [PATCH] v4l: rcar-fcp: Don't force users to check for disabled FCP support
Date: Wed, 17 Aug 2016 16:32:08 +0300
Message-Id: <1471440728-16931-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The rcar_fcp_enable() function immediately returns successfully when the
FCP device pointer is NULL to avoid forcing the users to check the FCP
device manually before every call. However, the stub version of the
function used when the FCP driver is disabled returns -ENOSYS
unconditionally, resulting in a different API contract for the two
versions of the function.

As a user that requires FCP support will fail at probe time when calling
rcar_fcp_get() if the FCP driver is disabled, the stub version of the
rcar_fcp_enable() function will only be called with a NULL FCP device.
We can thus return 0 unconditionally to align the behaviour with the
normal version of the function.

Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 include/media/rcar-fcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/rcar-fcp.h b/include/media/rcar-fcp.h
index 4c7fc77eaf29..8723f05c6321 100644
--- a/include/media/rcar-fcp.h
+++ b/include/media/rcar-fcp.h
@@ -29,7 +29,7 @@ static inline struct rcar_fcp_device *rcar_fcp_get(const struct device_node *np)
 static inline void rcar_fcp_put(struct rcar_fcp_device *fcp) { }
 static inline int rcar_fcp_enable(struct rcar_fcp_device *fcp)
 {
-	return -ENOSYS;
+	return 0;
 }
 static inline void rcar_fcp_disable(struct rcar_fcp_device *fcp) { }
 #endif
-- 
Regards,

Laurent Pinchart

