Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaBFRlh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 12:41:37 -0500
Received: from avalon.ideasonboard.com (unknown [91.178.242.26])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E075935ADE
	for <linux-media@vger.kernel.org>; Thu,  6 Feb 2014 18:40:37 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] v4l: vsp1: Update copyright notice
Date: Thu,  6 Feb 2014 18:42:31 +0100
Message-Id: <1391708551-8968-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "Renesas Corporation" listed in the copyright notice doesn't exist.
Replace it with "Renesas Electronics Corporation" and update the
copyright years.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h        | 2 +-
 drivers/media/platform/vsp1/vsp1_drv.c    | 2 +-
 drivers/media/platform/vsp1/vsp1_entity.c | 2 +-
 drivers/media/platform/vsp1/vsp1_entity.h | 2 +-
 drivers/media/platform/vsp1/vsp1_lif.c    | 2 +-
 drivers/media/platform/vsp1/vsp1_lif.h    | 2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.c   | 2 +-
 drivers/media/platform/vsp1/vsp1_rwpf.h   | 2 +-
 drivers/media/platform/vsp1/vsp1_uds.c    | 2 +-
 drivers/media/platform/vsp1/vsp1_uds.h    | 2 +-
 drivers/media/platform/vsp1/vsp1_video.c  | 2 +-
 drivers/media/platform/vsp1/vsp1_video.h  | 2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index d6c6ecd..cc6c5db 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -1,7 +1,7 @@
 /*
  * vsp1.h  --  R-Car VSP1 Driver
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index d16bf0f..b8505fc 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_drv.c  --  R-Car VSP1 Driver
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 9028f9d..f8896e8 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_entity.c  --  R-Car VSP1 Base Entity
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index c4feab2c..2ec5a18 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -1,7 +1,7 @@
 /*
  * vsp1_entity.h  --  R-Car VSP1 Base Entity
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 74a32e6..135a789 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_lif.c  --  R-Car VSP1 LCD Controller Interface
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_lif.h b/drivers/media/platform/vsp1/vsp1_lif.h
index 89b93af..7b35879 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.h
+++ b/drivers/media/platform/vsp1/vsp1_lif.h
@@ -1,7 +1,7 @@
 /*
  * vsp1_lif.h  --  R-Car VSP1 LCD Controller Interface
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 254871d..4498106 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_rpf.c  --  R-Car VSP1 Read Pixel Formatter
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 9752d55..386828d 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_rwpf.c  --  R-Car VSP1 Read and Write Pixel Formatters
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index c182d85..ac768c0 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -1,7 +1,7 @@
 /*
  * vsp1_rwpf.h  --  R-Car VSP1 Read and Write Pixel Formatters
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 0e50b37..622342a 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_uds.c  --  R-Car VSP1 Up and Down Scaler
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
index 972a285..479d12d 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.h
+++ b/drivers/media/platform/vsp1/vsp1_uds.h
@@ -1,7 +1,7 @@
 /*
  * vsp1_uds.h  --  R-Car VSP1 Up and Down Scaler
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 4b0ac07..0c545c4 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_video.c  --  R-Car VSP1 Video Node
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index d8612a3..53e4b37 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -1,7 +1,7 @@
 /*
  * vsp1_video.h  --  R-Car VSP1 Video Node
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index db4b85e..6b54ece 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -1,7 +1,7 @@
 /*
  * vsp1_wpf.c  --  R-Car VSP1 Write Pixel Formatter
  *
- * Copyright (C) 2013 Renesas Corporation
+ * Copyright (C) 2013-2014 Renesas Electronics Corporation
  *
  * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  *
-- 
1.8.3.2

