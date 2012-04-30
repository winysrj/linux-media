Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23770 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab2D3QOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 12:14:47 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3A006ZZVSGNE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:40 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3A00GV8VSLMM@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 17:14:46 +0100 (BST)
Date: Mon, 30 Apr 2012 18:14:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 11/12] s5p-fimc: Update copyright notices
In-reply-to: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335802481-18153-12-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1335802481-18153-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    4 ++--
 drivers/media/video/s5p-fimc/fimc-core.c    |    4 ++--
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.h |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 3e3ab85..bcf9c1e 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1,8 +1,8 @@
 /*
  * Samsung S5P/EXYNOS4 SoC series camera interface (camera capture) driver
  *
- * Copyright (C) 2010 - 2011 Samsung Electronics Co., Ltd.
- * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index d59d8c1..8d066c5 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1,8 +1,8 @@
 /*
  * Samsung S5P/EXYNOS4 SoC series FIMC (CAMIF) driver
  *
- * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
- * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2010-2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 600cf52..8b7e122 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010 - 2011 Samsung Electronics Co., Ltd.
+ * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.h b/drivers/media/video/s5p-fimc/fimc-mdevice.h
index 3524c19..3b8a349 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.h
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.7.10

