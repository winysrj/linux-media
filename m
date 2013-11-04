Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48329 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab3KDAG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Nov 2013 19:06:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sergio Aguirre <sergio.a.aguirre@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 14/18] v4l: omap4iss: Replace udelay/msleep with usleep_range
Date: Mon,  4 Nov 2013 01:06:39 +0100
Message-Id: <1383523603-3907-15-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1383523603-3907-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The only udelay() call takes place in a sleepable context, we can sleep
instead. Use usleep_range().

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 320bfd4..3103093 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -642,11 +642,11 @@ static int iss_reset(struct iss_device *iss)
 
 	while (readl(iss->regs[OMAP4_ISS_MEM_TOP] + ISS_HL_SYSCONFIG) &
 			ISS_HL_SYSCONFIG_SOFTRESET) {
-		if (timeout++ > 10000) {
+		if (timeout++ > 100) {
 			dev_alert(iss->dev, "cannot reset ISS\n");
 			return -ETIMEDOUT;
 		}
-		udelay(1);
+		usleep_range(10, 10);
 	}
 
 	return 0;
@@ -674,7 +674,7 @@ static int iss_isp_reset(struct iss_device *iss)
 			dev_alert(iss->dev, "cannot set ISP5 to standby\n");
 			return -ETIMEDOUT;
 		}
-		msleep(1);
+		usleep_range(1000, 1500);
 	}
 
 	/* Now finally, do the reset */
@@ -689,7 +689,7 @@ static int iss_isp_reset(struct iss_device *iss)
 			dev_alert(iss->dev, "cannot reset ISP5\n");
 			return -ETIMEDOUT;
 		}
-		msleep(1);
+		usleep_range(1000, 1500);
 	}
 
 	return 0;
-- 
1.8.1.5

