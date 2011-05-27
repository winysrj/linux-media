Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:36900 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab1E0M6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:58:12 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LLU0096EUOYJTU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLU00DYAUOY16@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Date: Fri, 27 May 2011 21:58:11 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH 1/5] m5mols: fix reading wrong size of captured main/thumb image
In-reply-to: <20110525135435.GA3547@valkosipuli.localdomain>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1306501095-28267-2-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <20110525135435.GA3547@valkosipuli.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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

