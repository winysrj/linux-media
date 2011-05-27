Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:36900 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab1E0M6Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:58:16 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LLU0096EUOYJTU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLU00DYAUOY16@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Date: Fri, 27 May 2011 21:58:14 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH 4/5] m5mols: rename m5mols_capture_error_handler() to proper
 name
In-reply-to: <20110525135435.GA3547@valkosipuli.localdomain>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1306501095-28267-5-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <20110525135435.GA3547@valkosipuli.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The m5mols_capture_post_work() is collecting works after capture. The order should
be kept, and it's safe to say success of capture when all this conditions are fine.

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_capture.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 751f459..8436105 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -31,22 +31,29 @@
 #include "m5mols.h"
 #include "m5mols_reg.h"
 
-static int m5mols_capture_error_handler(struct m5mols_info *info,
-					int timeout)
+/**
+ * m5mols_capture_post_work - Handle post work after capture interrupt occur
+ *
+ * Return 0 if all condition associated with capture is fine.
+ */
+static int m5mols_capture_post_work(struct m5mols_info *info, int timeout)
 {
 	int ret;
 
-	/* Disable all interrupts and clear relevant interrupt staus bits */
+	/* First, disable capture interrupt */
 	ret = m5mols_write(&info->sd, SYSTEM_INT_ENABLE,
 			   info->interrupt & ~(REG_INT_CAPTURE));
 	if (ret)
 		return ret;
 
+	/* Then, if timeout is exhasted, return ETIMEDOUT */
 	if (timeout == 0)
 		return -ETIMEDOUT;
 
+	/* All condition is satisfied, return 0 */
 	return 0;
 }
+
 /**
  * m5mols_read_rational - I2C read of a rational number
  *
@@ -150,7 +157,7 @@ int m5mols_start_capture(struct m5mols_info *info)
 					   test_bit(ST_CAPT_IRQ, &info->flags),
 					   msecs_to_jiffies(2000));
 		if (test_and_clear_bit(ST_CAPT_IRQ, &info->flags))
-			ret = m5mols_capture_error_handler(info, timeout);
+			ret = m5mols_capture_post_work(info, timeout);
 	}
 	if (!ret)
 		ret = m5mols_lock_3a(info, false);
@@ -187,5 +194,5 @@ int m5mols_start_capture(struct m5mols_info *info)
 		}
 	}
 
-	return m5mols_capture_error_handler(info, timeout);
+	return m5mols_capture_post_work(info, timeout);
 }
-- 
1.7.0.4

