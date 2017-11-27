Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36570 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752282AbdK0NMv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 08:12:51 -0500
Date: Tue, 28 Nov 2017 00:12:41 +1100
From: Simon Shields <simon@lineageos.org>
To: linux-media@vger.kernel.org
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] media: exynos4-is: check pipe is valid before calling subdev
Message-ID: <20171127131241.GA32492@lineageos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

if the subdev is not yet present (probably because the subdev
module has not yet been loaded), the pipe will be NULL. Make sure
that this is not the case before attempting to call the op.

Signed-off-by: Simon Shields <simon@lineageos.org>
---
 include/media/drv-intf/exynos-fimc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/media/drv-intf/exynos-fimc.h b/include/media/drv-intf/exynos-fimc.h
index 69bcd2a07d5c..f9c64338841f 100644
--- a/include/media/drv-intf/exynos-fimc.h
+++ b/include/media/drv-intf/exynos-fimc.h
@@ -155,7 +155,8 @@ static inline struct exynos_video_entity *vdev_to_exynos_video_entity(
 }
 
 #define fimc_pipeline_call(ent, op, args...)				  \
-	(!(ent) ? -ENOENT : (((ent)->pipe->ops && (ent)->pipe->ops->op) ? \
+	((!(ent) || !(ent)->pipe) ? -ENOENT : \
+	(((ent)->pipe->ops && (ent)->pipe->ops->op) ? \
 	(ent)->pipe->ops->op(((ent)->pipe), ##args) : -ENOIOCTLCMD))	  \
 
 #endif /* S5P_FIMC_H_ */
-- 
2.15.0
