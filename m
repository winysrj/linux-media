Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34886 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbcHZIcT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 04:32:19 -0400
Received: by mail-lf0-f67.google.com with SMTP id l89so3440885lfi.2
        for <linux-media@vger.kernel.org>; Fri, 26 Aug 2016 01:32:06 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH] cec-compliance: recognize PRESUMED_OK and REFUSED as ok
Date: Fri, 26 Aug 2016 10:31:48 +0200
Message-Id: <1472200308-20842-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is only checked for PRESUMED_OK and REFUSED when performing remote
tests, but these test result codes are also used elsewhere, so checking
for them is moved to the ok function.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-compliance/cec-compliance.cpp | 9 +++++++--
 utils/cec-compliance/cec-test.cpp       | 4 ----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/utils/cec-compliance/cec-compliance.cpp b/utils/cec-compliance/cec-compliance.cpp
index 519c572..ccfa3ba 100644
--- a/utils/cec-compliance/cec-compliance.cpp
+++ b/utils/cec-compliance/cec-compliance.cpp
@@ -842,9 +842,14 @@ const char *ok(int res)
 	if (res == NOTSUPPORTED) {
 		strcpy(buf, "OK (Not Supported)");
 		res = 0;
-	} else {
+	} else if (res == PRESUMED_OK) {
+		strcpy(buf, "OK (Presumed)");
+		res = 0;
+	} else if (res == REFUSED) {
+		strcpy(buf, "OK (Refused)");
+		res = 0;
+	} else
 		strcpy(buf, "OK");
-	}
 	tests_total++;
 	if (res) {
 		app_result = res;
diff --git a/utils/cec-compliance/cec-test.cpp b/utils/cec-compliance/cec-test.cpp
index 5fac04a..07ba4b6 100644
--- a/utils/cec-compliance/cec-test.cpp
+++ b/utils/cec-compliance/cec-test.cpp
@@ -1479,10 +1479,6 @@ void testRemote(struct node *node, unsigned me, unsigned la, unsigned test_tags,
 				printf("\t    %s: OK (Unexpected)\n",
 				       tests[i].subtests[j].name);
 			}
-			else if (ret == PRESUMED_OK)
-				printf("\t    %s: OK (Presumed)\n", tests[i].subtests[j].name);
-			else if (ret == REFUSED)
-				printf("\t    %s: OK (Refused)\n", tests[i].subtests[j].name);
 			else if (ret != NOTAPPLICABLE)
 				printf("\t    %s: %s\n", tests[i].subtests[j].name, ok(ret));
 			if (ret == FAIL_CRITICAL)
-- 
2.7.4

