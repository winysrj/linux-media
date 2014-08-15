Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:32819 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaHORKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Aug 2014 13:10:14 -0400
Received: by mail-la0-f42.google.com with SMTP id pv20so2543432lab.15
        for <linux-media@vger.kernel.org>; Fri, 15 Aug 2014 10:10:12 -0700 (PDT)
From: Andreas Ruprecht <rupran@einserver.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH] drivers: media: platform: Makefile: Add build dependency for davinci/
Date: Fri, 15 Aug 2014 19:10:29 +0200
Message-Id: <1408122629-19634-1-git-send-email-rupran@einserver.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the davinci/ subdirectory, all drivers but one depend on
CONFIG_ARCH_DAVINCI. The only exception, selected by CONFIG_VIDEO_DM6446_CCDC,
is also available on CONFIG_ARCH_OMAP3.

Thus, it is not necessary to always descend into davinci/. It is sufficient to
do this only if CONFIG_ARCH_OMAP3 or CONFIG_ARCH_DAVINCI is selected. While the
latter is already present, this patch changes the dependency from obj-y to
obj-$(CONFIG_ARCH_OMAP3).

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
---
 drivers/media/platform/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e5269da..d32e79a 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
 
 obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 
-obj-y	+= davinci/
+obj-$(CONFIG_ARCH_OMAP3)	+= davinci/
 
 obj-$(CONFIG_ARCH_OMAP)	+= omap/
 
-- 
1.9.1

