Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:36900 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1E0M6R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 08:58:17 -0400
Received: from epcpsbgm1.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LLU0096EUOYJTU0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLU00DYAUOY16@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 May 2011 21:58:10 +0900 (KST)
Date: Fri, 27 May 2011 21:58:15 +0900
From: "HeungJun, Kim" <riverful.kim@samsung.com>
Subject: [PATCH 5/5] m5mols: add parenthesis <> for the head and back of email
 address
In-reply-to: <20110525135435.GA3547@valkosipuli.localdomain>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1306501095-28267-6-git-send-email-riverful.kim@samsung.com>
Content-transfer-encoding: 7BIT
References: <20110525135435.GA3547@valkosipuli.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: HeungJun, Kim <riverful.kim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |    4 ++--
 drivers/media/video/m5mols/m5mols_capture.c  |    4 ++--
 drivers/media/video/m5mols/m5mols_controls.c |    4 ++--
 drivers/media/video/m5mols/m5mols_core.c     |    4 ++--
 drivers/media/video/m5mols/m5mols_reg.h      |    4 ++--
 include/media/m5mols.h                       |    4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 9ae1709..89d09a8 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -2,10 +2,10 @@
  * Header for M-5MOLS 8M Pixel camera sensor with ISP
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- * Author: HeungJun Kim, riverful.kim@samsung.com
+ * Author: HeungJun Kim <riverful.kim@samsung.com>
  *
  * Copyright (C) 2009 Samsung Electronics Co., Ltd.
- * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ * Author: Dongsoo Nathaniel Kim <dongsoo45.kim@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/m5mols/m5mols_capture.c b/drivers/media/video/m5mols/m5mols_capture.c
index 8436105..d91a67e 100644
--- a/drivers/media/video/m5mols/m5mols_capture.c
+++ b/drivers/media/video/m5mols/m5mols_capture.c
@@ -2,10 +2,10 @@
  * The Capture code for Fujitsu M-5MOLS ISP
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- * Author: HeungJun Kim, riverful.kim@samsung.com
+ * Author: HeungJun Kim <riverful.kim@samsung.com>
  *
  * Copyright (C) 2009 Samsung Electronics Co., Ltd.
- * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ * Author: Dongsoo Nathaniel Kim <dongsoo45.kim@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index d392c83..d135d20 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -2,10 +2,10 @@
  * Controls for M-5MOLS 8M Pixel camera sensor with ISP
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- * Author: HeungJun Kim, riverful.kim@samsung.com
+ * Author: HeungJun Kim <riverful.kim@samsung.com>
  *
  * Copyright (C) 2009 Samsung Electronics Co., Ltd.
- * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ * Author: Dongsoo Nathaniel Kim <dongsoo45.kim@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 8ccab95..e2c8a10 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -2,10 +2,10 @@
  * Driver for M-5MOLS 8M Pixel camera sensor with ISP
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- * Author: HeungJun Kim, riverful.kim@samsung.com
+ * Author: HeungJun Kim <riverful.kim@samsung.com>
  *
  * Copyright (C) 2009 Samsung Electronics Co., Ltd.
- * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ * Author: Dongsoo Nathaniel Kim <dongsoo45.kim@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index 5f5bdcf..c755bd6 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -2,10 +2,10 @@
  * Register map for M-5MOLS 8M Pixel camera sensor with ISP
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- * Author: HeungJun Kim, riverful.kim@samsung.com
+ * Author: HeungJun Kim <riverful.kim@samsung.com>
  *
  * Copyright (C) 2009 Samsung Electronics Co., Ltd.
- * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ * Author: Dongsoo Nathaniel Kim <dongsoo45.kim@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/include/media/m5mols.h b/include/media/m5mols.h
index 2d7e7ca..aac2c0e 100644
--- a/include/media/m5mols.h
+++ b/include/media/m5mols.h
@@ -2,10 +2,10 @@
  * Driver header for M-5MOLS 8M Pixel camera sensor with ISP
  *
  * Copyright (C) 2011 Samsung Electronics Co., Ltd.
- * Author: HeungJun Kim, riverful.kim@samsung.com
+ * Author: HeungJun Kim <riverful.kim@samsung.com>
  *
  * Copyright (C) 2009 Samsung Electronics Co., Ltd.
- * Author: Dongsoo Nathaniel Kim, dongsoo45.kim@samsung.com
+ * Author: Dongsoo Nathaniel Kim <dongsoo45.kim@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
-- 
1.7.0.4

