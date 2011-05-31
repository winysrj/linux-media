Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:46744 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab1EaHgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 03:36:11 -0400
Received: from epcpsbgm1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LM100L4AUFN61G0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 May 2011 16:36:09 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LM10099JUG9EC@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 May 2011 16:36:09 +0900 (KST)
Date: Tue, 31 May 2011 16:35:59 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH v2 1/4] m5mols: Fix capture image size register definition
In-reply-to: <1306501095-28267-1-git-send-email-riverful.kim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1306827362-4064-2-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <1306501095-28267-1-git-send-email-riverful.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The main capture and the thumbnail image size registers were
erroneously defined to have 1 byte width, resulting in wrong
reported image size. Fix this by changing the registers width
to correct value.

Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols_reg.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index b83e36f..8260f50 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -382,8 +382,8 @@
 #define REG_CAP_START_MAIN	0x01
 #define REG_CAP_START_THUMB	0x03
 
-#define CAPC_IMAGE_SIZE		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_IMAGE_SIZE, 1)
-#define CAPC_THUMB_SIZE		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_THUMB_SIZE, 1)
+#define CAPC_IMAGE_SIZE		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_IMAGE_SIZE, 4)
+#define CAPC_THUMB_SIZE		I2C_REG(CAT_CAPT_CTRL, CATC_CAP_THUMB_SIZE, 4)
 
 /*
  * Category F - Flash
-- 
1.7.0.4

