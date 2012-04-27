Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29704 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997Ab2D0JxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 05:53:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3400D7XU3WSD00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:52:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3400J0BU4SNO@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 10:53:16 +0100 (BST)
Date: Fri, 27 Apr 2012 11:53:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 12/13] s5p-fimc: Update copyright notices
In-reply-to: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	sungchun.kang@samsung.com, subash.ramaswamy@linaro.org,
	s.nawrocki@samsung.com
Message-id: <1335520386-20835-13-git-send-email-s.nawrocki@samsung.com>
References: <1335520386-20835-1-git-send-email-s.nawrocki@samsung.com>
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
index fde7033..9a6224f 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1,8 +1,8 @@
 /*
  * Samsung S5P/EXYNOS4 SoC series camera interface (camera capture) driver
  *
- * Copyright (C) 2010 - 2011 Samsung Electronics Co., Ltd.
- * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index f67c3b6..d5872e6 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1,8 +1,8 @@
 /*
  * Samsung S5P/EXYNOS4 SoC series FIMC (CAMIF) driver
  *
- * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
- * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2010-2012 Samsung Electronics Co., Ltd.
+ * Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index c42bbc9..a4fe52c 100644
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

