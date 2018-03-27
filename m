Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:44631 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbeC0RIm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 13:08:42 -0400
Received: by mail-pl0-f66.google.com with SMTP id 9-v6so14477362ple.11
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 10:08:42 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 3/4] tuners/mxl301rf: use SPDX License Identifier
Date: Wed, 28 Mar 2018 02:08:21 +0900
Message-Id: <20180327170822.21921-4-tskd08@gmail.com>
In-Reply-To: <20180327170822.21921-1-tskd08@gmail.com>
References: <20180327170822.21921-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/tuners/mxl301rf.c | 11 +----------
 drivers/media/tuners/mxl301rf.h | 11 +----------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/media/tuners/mxl301rf.c b/drivers/media/tuners/mxl301rf.c
index 1575a5db776..57b0e4862aa 100644
--- a/drivers/media/tuners/mxl301rf.c
+++ b/drivers/media/tuners/mxl301rf.c
@@ -1,17 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * MaxLinear MxL301RF OFDM tuner driver
  *
  * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 /*
diff --git a/drivers/media/tuners/mxl301rf.h b/drivers/media/tuners/mxl301rf.h
index d32d4e8dc44..1d5bb10ba07 100644
--- a/drivers/media/tuners/mxl301rf.h
+++ b/drivers/media/tuners/mxl301rf.h
@@ -1,17 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * MaxLinear MxL301RF OFDM tuner driver
  *
  * Copyright (C) 2014 Akihiro Tsukada <tskd08@gmail.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  */
 
 #ifndef MXL301RF_H
-- 
2.16.3
