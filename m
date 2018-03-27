Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:42099 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbeC0RIp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 13:08:45 -0400
Received: by mail-pl0-f65.google.com with SMTP id g20-v6so3206713plo.9
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 10:08:44 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 4/4] tuners/qm1d1c0042: use SPDX License Identifier
Date: Wed, 28 Mar 2018 02:08:22 +0900
Message-Id: <20180327170822.21921-5-tskd08@gmail.com>
In-Reply-To: <20180327170822.21921-1-tskd08@gmail.com>
References: <20180327170822.21921-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/tuners/qm1d1c0042.c | 11 +----------
 drivers/media/tuners/qm1d1c0042.h | 11 +----------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 9af2a155cfc..642a065b9a0 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -1,17 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Sharp QM1D1C0042 8PSK tuner driver
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
diff --git a/drivers/media/tuners/qm1d1c0042.h b/drivers/media/tuners/qm1d1c0042.h
index 8331f8baa09..b22fa98bf56 100644
--- a/drivers/media/tuners/qm1d1c0042.h
+++ b/drivers/media/tuners/qm1d1c0042.h
@@ -1,17 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Sharp QM1D1C0042 8PSK tuner driver
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
 
 #ifndef QM1D1C0042_H
-- 
2.16.3
