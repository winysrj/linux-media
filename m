Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26141 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab1FBKN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jun 2011 06:13:29 -0400
Date: Thu, 02 Jun 2011 12:12:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 7/7] s5p-fimc: Update copyright notices
In-reply-to: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307009524-1208-8-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307009524-1208-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-capture.c |    4 ++--
 drivers/media/video/s5p-fimc/fimc-core.c    |    7 +++----
 drivers/media/video/s5p-fimc/fimc-core.h    |    4 +---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
index 6901643..81b4a82 100644
--- a/drivers/media/video/s5p-fimc/fimc-capture.c
+++ b/drivers/media/video/s5p-fimc/fimc-capture.c
@@ -1,7 +1,7 @@
 /*
- * Samsung S5P SoC series camera interface (camera capture) driver
+ * Samsung S5P/EXYNOS4 SoC series camera interface (camera capture) driver
  *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd
+ * Copyright (C) 2010 - 2011 Samsung Electronics Co., Ltd.
  * Author: Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 873a879..bdf19ad 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -1,9 +1,8 @@
 /*
- * S5P camera interface (video postprocessor) driver
+ * Samsung S5P/EXYNOS4 SoC series camera interface (video postprocessor) driver
  *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd
- *
- * Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
+ * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index 8f0f168..1f70772 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -1,7 +1,5 @@
 /*
- * Copyright (c) 2010 Samsung Electronics
- *
- * Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ * Copyright (C) 2010 - 2011 Samsung Electronics Co., Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.7.5.2

