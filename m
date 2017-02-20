Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51745 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751342AbdBTUds (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 15:33:48 -0500
Received: from linux.local ([88.67.44.205]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0Lm2lZ-1c6Ztw1HLl-00ZcL3 for
 <linux-media@vger.kernel.org>; Mon, 20 Feb 2017 21:33:45 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH v1 2/2] ir-ctl: add optional copy of TEMP_FAILURE_RETRY macro (fix musl compile)
Date: Mon, 20 Feb 2017 21:33:44 +0100
Message-Id: <20170220203344.17530-2-ps.report@gmx.net>
In-Reply-To: <20170220203344.17530-1-ps.report@gmx.net>
References: <20170220203344.17530-1-ps.report@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes buildroot musl compile (see [1], [2]):

  ir-ctl.c:(.text+0xe01): undefined reference to `TEMP_FAILURE_RETRY'

[1] http://autobuild.buildroot.net/results/b8b96c7bbf2147dacac62485cbfdbcfd758271a5
[2] http://lists.busybox.net/pipermail/buildroot/2017-February/184048.html

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
---
 utils/ir-ctl/ir-ctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index f938b429..e9da7778 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -44,6 +44,15 @@
 
 # define N_(string) string
 
+/* taken from glibc unistd.h */
+#ifndef TEMP_FAILURE_RETRY
+#define TEMP_FAILURE_RETRY(expression) \
+  (__extension__                                                              \
+    ({ long int __result;                                                     \
+       do __result = (long int) (expression);                                 \
+       while (__result == -1L && errno == EINTR);                             \
+       __result; }))
+#endif
 
 /* See drivers/media/rc/ir-lirc-codec.c line 23 */
 #define LIRCBUF_SIZE	512
-- 
2.11.0
