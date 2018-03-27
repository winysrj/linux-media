Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:45616 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753116AbeC0RIg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 13:08:36 -0400
Received: by mail-pl0-f66.google.com with SMTP id n15-v6so14472668plp.12
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 10:08:36 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, Akihiro Tsukada <tskd08@gmail.com>
Subject: [PATCH 1/4] dvb-frontends/tc90522: use SPDX License Identifier
Date: Wed, 28 Mar 2018 02:08:19 +0900
Message-Id: <20180327170822.21921-2-tskd08@gmail.com>
In-Reply-To: <20180327170822.21921-1-tskd08@gmail.com>
References: <20180327170822.21921-1-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-frontends/tc90522.c | 11 +----------
 drivers/media/dvb-frontends/tc90522.h | 11 +----------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index 04fb4922332..7abf6b0916e 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -1,17 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
 /*
  * Toshiba TC90522 Demodulator
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
diff --git a/drivers/media/dvb-frontends/tc90522.h b/drivers/media/dvb-frontends/tc90522.h
index 10e585f3249..ac0e2ab5192 100644
--- a/drivers/media/dvb-frontends/tc90522.h
+++ b/drivers/media/dvb-frontends/tc90522.h
@@ -1,17 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Toshiba TC90522 Demodulator
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
-- 
2.16.3
