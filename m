Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:65101 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbaGFSVD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jul 2014 14:21:03 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so3424801wes.24
        for <linux-media@vger.kernel.org>; Sun, 06 Jul 2014 11:21:01 -0700 (PDT)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH] libdvbv5: provide crc32 to c++
Date: Sun,  6 Jul 2014 20:20:30 +0200
Message-Id: <1404670830-6863-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

allow C++ apps to use crc32

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/libdvbv5/crc32.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/include/libdvbv5/crc32.h b/lib/include/libdvbv5/crc32.h
index d1968e8..4261bda 100644
--- a/lib/include/libdvbv5/crc32.h
+++ b/lib/include/libdvbv5/crc32.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2011-2012 - Mauro Carvalho Chehab
- * Copyright (c) 2012 - Andre Roth <neolynx@gmail.com>
+ * Copyright (c) 2012-2014 - Andre Roth <neolynx@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -25,7 +25,15 @@
 #include <stdint.h>
 #include <unistd.h> /* size_t */
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 uint32_t crc32(uint8_t *data, size_t datalen, uint32_t crc);
 
+#ifdef __cplusplus
+}
+#endif
+
 #endif
 
-- 
1.9.1

