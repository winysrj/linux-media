Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46229 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaIYMYs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 08:24:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: Fix division by 0
Date: Thu, 25 Sep 2014 15:24:47 +0300
Message-Id: <1411647887-5593-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the requested clock rate passed to the XCLK set_rate or round_rate
operation is 0, the driver will try to divide by 0. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 72265e5..6019156 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -220,6 +220,9 @@ static u32 isp_xclk_calc_divider(unsigned long *rate, unsigned long parent_rate)
 		return ISPTCTRL_CTRL_DIV_BYPASS;
 	}
 
+	if (*rate == 0)
+		*rate = 1;
+
 	divider = DIV_ROUND_CLOSEST(parent_rate, *rate);
 	if (divider >= ISPTCTRL_CTRL_DIV_BYPASS)
 		divider = ISPTCTRL_CTRL_DIV_BYPASS - 1;
-- 
Regards,

Laurent Pinchart

