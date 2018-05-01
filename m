Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0064.outbound.protection.outlook.com ([104.47.34.64]:14611
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752056AbeEABfY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Apr 2018 21:35:24 -0400
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Rohit Athavale <rathaval@xilinx.com>,
        Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
Subject: [PATCH v4 07/10] media: Add new dt-bindings/vf_codes for supported formats
Date: Mon, 30 Apr 2018 18:35:10 -0700
Message-ID: <17a5f753d3a580971e6802775a237e501597ddbc.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
In-Reply-To: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
References: <cover.1524955156.git.satish.nagireddy.nagireddy@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rohit Athavale <rathaval@xilinx.com>

This commit adds new entries to the exisiting vf_codes that are used
to describe the media bus formats in the DT bindings. The newly added
8-bit and 10-bit color depth related formats will need these updates.

Signed-off-by: Rohit Athavale <rathaval@xilinx.com>
Signed-off-by: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
---
 include/dt-bindings/media/xilinx-vip.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/media/xilinx-vip.h b/include/dt-bindings/media/xilinx-vip.h
index 6298fec..fcd34d7 100644
--- a/include/dt-bindings/media/xilinx-vip.h
+++ b/include/dt-bindings/media/xilinx-vip.h
@@ -35,5 +35,7 @@
 #define XVIP_VF_CUSTOM2			13
 #define XVIP_VF_CUSTOM3			14
 #define XVIP_VF_CUSTOM4			15
+#define XVIP_VF_VUY_422			16
+#define XVIP_VF_XBGR			17
 
 #endif /* __DT_BINDINGS_MEDIA_XILINX_VIP_H__ */
-- 
2.1.1
