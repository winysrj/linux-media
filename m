Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42413 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaEYTyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 May 2014 15:54:43 -0400
Received: from avalon.ideasonboard.com (254.20-200-80.adsl-dyn.isp.belgacom.be [80.200.20.254])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4943C35A40
	for <linux-media@vger.kernel.org>; Sun, 25 May 2014 21:54:32 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] m5mols: Replace missing header
Date: Sun, 25 May 2014 21:54:55 +0200
Message-Id: <1401047695-2046-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The include/media/s5p_fimc.h header has been removed in commit
49b2f4c56fbf70ca693d6df1c491f0566d516aea ("exynos4-is: Remove support
for non-dt platforms"). This broke compilation of the m5mols driver.

Include the include/media/exynos-fimc.h header instead, which contains
the S5P_FIMC_TX_END_NOTIFY definition required by the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/m5mols/m5mols_capture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

(Resending to linux-media has the original patch seems not to have made it to
the list for an unknown reason.)

This is a regression in Mauro's latest master branch.

diff --git a/drivers/media/i2c/m5mols/m5mols_capture.c b/drivers/media/i2c/m5mols/m5mols_capture.c
index ab34cce..1a03d02 100644
--- a/drivers/media/i2c/m5mols/m5mols_capture.c
+++ b/drivers/media/i2c/m5mols/m5mols_capture.c
@@ -26,7 +26,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 #include <media/m5mols.h>
-#include <media/s5p_fimc.h>
+#include <media/exynos-fimc.h>
 
 #include "m5mols.h"
 #include "m5mols_reg.h"
-- 
Regards,

Laurent Pinchart

