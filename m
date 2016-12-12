Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sg2apc01on0054.outbound.protection.outlook.com ([104.47.125.54]:48466
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751171AbcLLFu0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Dec 2016 00:50:26 -0500
From: Greg Whiteley <greg.whiteley@atomos.com>
To: <linux-media@vger.kernel.org>
CC: Greg Whiteley <greg.whiteley@atomos.com>
Subject: [PATCH v4l-utils] ir-ctl: `strndupa' undefined with --disable-nls
Date: Mon, 12 Dec 2016 15:16:48 +1100
Message-ID: <1481516208-31254-1-git-send-email-greg.whiteley@atomos.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Greg Whiteley <greg.whiteley@atomos.com>
---
 utils/ir-ctl/ir-ctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/ir-ctl/ir-ctl.c b/utils/ir-ctl/ir-ctl.c
index f19bd05..707aa1f 100644
--- a/utils/ir-ctl/ir-ctl.c
+++ b/utils/ir-ctl/ir-ctl.c
@@ -37,6 +37,7 @@
 # include <langinfo.h>
 # include <iconv.h>
 #else
+# include <string.h>
 # define _(string) string
 #endif
 
-- 
1.9.1

