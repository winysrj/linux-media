Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33809 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab2JDHYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 03:24:37 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBC00CTLXVK9PN0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:36 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MBC006I9XWMLU10@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 04 Oct 2012 16:24:35 +0900 (KST)
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: t.stanislaws@samsung.com, inki.dae@samsung.com,
	kyungmin.park@samsung.com, joshi@samsung.com
Subject: [PATCH v1 01/14] media: s5p-hdmi: add HPD GPIO to platform data
Date: Thu, 04 Oct 2012 21:12:39 +0530
Message-id: <1349365372-21417-2-git-send-email-rahul.sharma@samsung.com>
In-reply-to: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
References: <1349365372-21417-1-git-send-email-rahul.sharma@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

This patch extends s5p-hdmi platform data by a GPIO identifier for
Hot-Plug-Detection pin.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/media/s5p_hdmi.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/media/s5p_hdmi.h b/include/media/s5p_hdmi.h
index 361a751..181642b 100644
--- a/include/media/s5p_hdmi.h
+++ b/include/media/s5p_hdmi.h
@@ -20,6 +20,7 @@ struct i2c_board_info;
  * @hdmiphy_info: template for HDMIPHY I2C device
  * @mhl_bus: controller id for MHL control bus
  * @mhl_info: template for MHL I2C device
+ * @hpd_gpio: GPIO for Hot-Plug-Detect pin
  *
  * NULL pointer for *_info fields indicates that
  * the corresponding chip is not present
@@ -29,6 +30,7 @@ struct s5p_hdmi_platform_data {
 	struct i2c_board_info *hdmiphy_info;
 	int mhl_bus;
 	struct i2c_board_info *mhl_info;
+	int hpd_gpio;
 };
 
 #endif /* S5P_HDMI_H */
-- 
1.7.0.4

