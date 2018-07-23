Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39898 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388002AbeGWMEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:45 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 05/35] media: camss: Use SPDX license headers
Date: Mon, 23 Jul 2018 14:02:22 +0300
Message-Id: <1532343772-27382-6-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use SPDX license headers for all files of the Qualcomm CAMSS driver.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c   | 10 +---------
 drivers/media/platform/qcom/camss/camss-csid.h   | 10 +---------
 drivers/media/platform/qcom/camss/camss-csiphy.c | 10 +---------
 drivers/media/platform/qcom/camss/camss-csiphy.h | 10 +---------
 drivers/media/platform/qcom/camss/camss-ispif.c  | 10 +---------
 drivers/media/platform/qcom/camss/camss-ispif.h  | 10 +---------
 drivers/media/platform/qcom/camss/camss-vfe.c    | 10 +---------
 drivers/media/platform/qcom/camss/camss-vfe.h    | 10 +---------
 drivers/media/platform/qcom/camss/camss-video.c  | 10 +---------
 drivers/media/platform/qcom/camss/camss-video.h  | 10 +---------
 drivers/media/platform/qcom/camss/camss.c        | 10 +---------
 drivers/media/platform/qcom/camss/camss.h        | 10 +---------
 12 files changed, 12 insertions(+), 108 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index 39ea27b..c0fef17 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * camss-csid.c
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #include <linux/clk.h>
 #include <linux/completion.h>
diff --git a/drivers/media/platform/qcom/camss/camss-csid.h b/drivers/media/platform/qcom/camss/camss-csid.h
index 8012222..ae1d045 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.h
+++ b/drivers/media/platform/qcom/camss/camss-csid.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * camss-csid.h
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #ifndef QC_MSM_CAMSS_CSID_H
 #define QC_MSM_CAMSS_CSID_H
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.c b/drivers/media/platform/qcom/camss/camss-csiphy.c
index 642de25..b37e691 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.c
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * camss-csiphy.c
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2016-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #include <linux/clk.h>
 #include <linux/delay.h>
diff --git a/drivers/media/platform/qcom/camss/camss-csiphy.h b/drivers/media/platform/qcom/camss/camss-csiphy.h
index 9a42209..76fa239 100644
--- a/drivers/media/platform/qcom/camss/camss-csiphy.h
+++ b/drivers/media/platform/qcom/camss/camss-csiphy.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * camss-csiphy.h
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2016-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #ifndef QC_MSM_CAMSS_CSIPHY_H
 #define QC_MSM_CAMSS_CSIPHY_H
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
index 636d5e7..5ad719d 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * camss-ispif.c
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #include <linux/clk.h>
 #include <linux/completion.h>
diff --git a/drivers/media/platform/qcom/camss/camss-ispif.h b/drivers/media/platform/qcom/camss/camss-ispif.h
index c90e159..a5dfb4f 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.h
+++ b/drivers/media/platform/qcom/camss/camss-ispif.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * camss-ispif.h
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #ifndef QC_MSM_CAMSS_ISPIF_H
 #define QC_MSM_CAMSS_ISPIF_H
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 380b90b..256dc2d 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * camss-vfe.c
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #include <linux/clk.h>
 #include <linux/completion.h>
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index 5aa7407..6b4258d 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * camss-vfe.h
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #ifndef QC_MSM_CAMSS_VFE_H
 #define QC_MSM_CAMSS_VFE_H
diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index 0e7b842..16e74b2 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * camss-video.c
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #include <linux/slab.h>
 #include <media/media-entity.h>
diff --git a/drivers/media/platform/qcom/camss/camss-video.h b/drivers/media/platform/qcom/camss/camss-video.h
index 821c1ef..aa35e8c 100644
--- a/drivers/media/platform/qcom/camss/camss-video.h
+++ b/drivers/media/platform/qcom/camss/camss-video.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * camss-video.h
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #ifndef QC_MSM_CAMSS_VIDEO_H
 #define QC_MSM_CAMSS_VIDEO_H
diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index d1d27fc..45285eb 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * camss.c
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #include <linux/clk.h>
 #include <linux/media-bus-format.h>
diff --git a/drivers/media/platform/qcom/camss/camss.h b/drivers/media/platform/qcom/camss/camss.h
index 0e7cfe6..fb1c2f9 100644
--- a/drivers/media/platform/qcom/camss/camss.h
+++ b/drivers/media/platform/qcom/camss/camss.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * camss.h
  *
@@ -5,15 +6,6 @@
  *
  * Copyright (c) 2015, The Linux Foundation. All rights reserved.
  * Copyright (C) 2015-2018 Linaro Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 and
- * only version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 #ifndef QC_MSM_CAMSS_H
 #define QC_MSM_CAMSS_H
-- 
2.7.4
