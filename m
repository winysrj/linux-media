Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:16752 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761048Ab3DBOoG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Apr 2013 10:44:06 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MKM00MM5U9G07P0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Apr 2013 23:44:04 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] V4L: Remove incorrect EXPORT_SYMBOL() usage at v4l2-of.c
Date: Tue, 02 Apr 2013 16:43:38 +0200
Message-id: <1364913818-7970-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_of_parse_parallel_bus() function is now static and
EXPORT_SYMBOL() doesn't apply to it any more. Drop this
meaningless statement, which was supposed to be done in
the original merged patch.

While at it, edit the copyright notice so it is sorted in
both the v4l2-of.c and v4l2-of.h file in newest entries
on top order, and state clearly I'm just the author of
parts of the code, not the copyright owner.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/v4l2-of.c |    3 +--
 include/media/v4l2-of.h           |    6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index e38e210..aa59639 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -2,7 +2,7 @@
  * V4L2 OF binding parsing library
  *
  * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * Copyright (C) 2012 Renesas Electronics Corp.
  * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
@@ -103,7 +103,6 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 	bus->flags = flags;
 
 }
-EXPORT_SYMBOL(v4l2_of_parse_parallel_bus);
 
 /**
  * v4l2_of_parse_endpoint() - parse all endpoint node properties
diff --git a/include/media/v4l2-of.h b/include/media/v4l2-of.h
index 00f9147..3a8a841 100644
--- a/include/media/v4l2-of.h
+++ b/include/media/v4l2-of.h
@@ -1,12 +1,12 @@
 /*
  * V4L2 OF binding parsing library
  *
+ * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
+ *
  * Copyright (C) 2012 Renesas Electronics Corp.
  * Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
  *
- * Copyright (C) 2012 - 2013 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki <s.nawrocki@samsung.com>
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
-- 
1.7.9.5

