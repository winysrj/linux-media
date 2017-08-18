Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:43908 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750739AbdHRIQ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 04:16:58 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: hans.verkuil@cisco.com
Cc: mchehab@kernel.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 2/2] media: camss: Add abbreviations explanation
Date: Fri, 18 Aug 2017 11:16:34 +0300
Message-Id: <1503044194-7405-2-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1503044194-7405-1-git-send-email-todor.tomov@linaro.org>
References: <1503044194-7405-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add abbreviations explanation at the top header blocks in source files.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss-8x16/camss-csid.c  | 2 +-
 drivers/media/platform/qcom/camss-8x16/camss-csid.h  | 2 +-
 drivers/media/platform/qcom/camss-8x16/camss-ispif.c | 2 +-
 drivers/media/platform/qcom/camss-8x16/camss-ispif.h | 2 +-
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c   | 2 +-
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h   | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.c b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
index 792c14a..64df828 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.c
@@ -1,7 +1,7 @@
 /*
  * camss-csid.c
  *
- * Qualcomm MSM Camera Subsystem - CSID Module
+ * Qualcomm MSM Camera Subsystem - CSID (CSI Decoder) Module
  *
  * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2017 Linaro Ltd.
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csid.h b/drivers/media/platform/qcom/camss-8x16/camss-csid.h
index 4df7018..8682d30 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-csid.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csid.h
@@ -1,7 +1,7 @@
 /*
  * camss-csid.h
  *
- * Qualcomm MSM Camera Subsystem - CSID Module
+ * Qualcomm MSM Camera Subsystem - CSID (CSI Decoder) Module
  *
  * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2017 Linaro Ltd.
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c b/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
index 54d1946..24da529 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-ispif.c
@@ -1,7 +1,7 @@
 /*
  * camss-ispif.c
  *
- * Qualcomm MSM Camera Subsystem - ISPIF Module
+ * Qualcomm MSM Camera Subsystem - ISPIF (ISP Interface) Module
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2017 Linaro Ltd.
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-ispif.h b/drivers/media/platform/qcom/camss-8x16/camss-ispif.h
index 6659020..f668306 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-ispif.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-ispif.h
@@ -1,7 +1,7 @@
 /*
  * camss-ispif.h
  *
- * Qualcomm MSM Camera Subsystem - ISPIF Module
+ * Qualcomm MSM Camera Subsystem - ISPIF (ISP Interface) Module
  *
  * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2017 Linaro Ltd.
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
index 1c86b10..94d635e 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
@@ -1,7 +1,7 @@
 /*
  * camss-vfe.c
  *
- * Qualcomm MSM Camera Subsystem - VFE Module
+ * Qualcomm MSM Camera Subsystem - VFE (Video Front End) Module
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2017 Linaro Ltd.
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
index 88c29d0..53d5b66 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
@@ -1,7 +1,7 @@
 /*
  * camss-vfe.h
  *
- * Qualcomm MSM Camera Subsystem - VFE Module
+ * Qualcomm MSM Camera Subsystem - VFE (Video Front End) Module
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2017 Linaro Ltd.
-- 
2.7.4
