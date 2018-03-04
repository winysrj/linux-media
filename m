Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:42595 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751819AbeCDImG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 4 Mar 2018 03:42:06 -0500
Received: from localhost.localdomain ([92.75.40.49]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LwrPM-1ectZU1qXo-016Piy for
 <linux-media@vger.kernel.org>; Sun, 04 Mar 2018 09:42:04 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH v1] libdvbv5: add optional copy of TEMP_FAILURE_RETRY macro (fix musl compile)
Date: Sun,  4 Mar 2018 09:42:04 +0100
Message-Id: <20180304084204.15820-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes:

  ../../lib/libdvbv5/.libs/libdvbv5.so: undefined reference to `TEMP_FAILURE_RETRY'

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 lib/libdvbv5/dvb-dev-local.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/lib/libdvbv5/dvb-dev-local.c b/lib/libdvbv5/dvb-dev-local.c
index 8bc99d1..7a76d65 100644
--- a/lib/libdvbv5/dvb-dev-local.c
+++ b/lib/libdvbv5/dvb-dev-local.c
@@ -44,6 +44,15 @@
 # define _(string) string
 #endif
 
+/* taken from glibc unistd.h */
+#ifndef TEMP_FAILURE_RETRY
+#define TEMP_FAILURE_RETRY(expression) \
+    ({ long int __result;                                                     \
+       do __result = (long int) (expression);                                 \
+       while (__result == -1L && errno == EINTR);                             \
+       __result; })
+#endif
+
 struct dvb_dev_local_priv {
 	dvb_dev_change_t notify_dev_change;
 
-- 
2.16.2
