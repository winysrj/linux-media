Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41288 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab3DDNbC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 09:31:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] MAINTAINERS: Mark the SH VOU driver as Odd Fixes
Date: Thu,  4 Apr 2013 15:31:58 +0200
Message-Id: <1365082318-22628-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver isn't actively maintained anymore, update its status.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 154b02c..098eb7d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7175,7 +7175,7 @@ F:	drivers/media/platform/sh_veu.c
 SH_VOU V4L2 OUTPUT DRIVER
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
 L:	linux-media@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 F:	drivers/media/platform/sh_vou.c
 F:	include/media/sh_vou.h
 
-- 
Regards,

Laurent Pinchart

