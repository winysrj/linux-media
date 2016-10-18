Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58966 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760750AbcJRNY3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 09:24:29 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: stable@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] [media] v4l: rcar-fcp: Don't force users to check for disabled FCP support
Date: Tue, 18 Oct 2016 16:24:20 +0300
Message-Id: <1476797060-8535-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

commit fd44aa9a254b18176ec3792a18e7de6977030ca8 upstream.

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

Fixes: 94fcdf829793 ("[media] v4l: vsp1: Add FCP support")
Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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

