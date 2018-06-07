Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51411 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932401AbeFGTze (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 15:55:34 -0400
Received: by mail-wm0-f65.google.com with SMTP id r15-v6so20085391wmc.1
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 12:55:34 -0700 (PDT)
From: Corentin Labbe <clabbe@baylibre.com>
To: mchehab@kernel.org, t.stanislaws@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] media: sii9234: remove unused header
Date: Thu,  7 Jun 2018 19:55:25 +0000
Message-Id: <1528401325-39552-1-git-send-email-clabbe@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The include/linux/platform_data/media/sii9234.h header file is unused,
let's remove it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 include/linux/platform_data/media/sii9234.h | 24 ------------------------
 1 file changed, 24 deletions(-)
 delete mode 100644 include/linux/platform_data/media/sii9234.h

diff --git a/include/linux/platform_data/media/sii9234.h b/include/linux/platform_data/media/sii9234.h
deleted file mode 100644
index 6a4a809fe9a3..000000000000
--- a/include/linux/platform_data/media/sii9234.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/*
- * Driver header for SII9234 MHL converter chip.
- *
- * Copyright (c) 2011 Samsung Electronics, Co. Ltd
- * Contact: Tomasz Stanislawski <t.stanislaws@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef SII9234_H
-#define SII9234_H
-
-/**
- * @gpio_n_reset: GPIO driving nRESET pin
- */
-
-struct sii9234_platform_data {
-	int gpio_n_reset;
-};
-
-#endif /* SII9234_H */
-- 
2.16.4
