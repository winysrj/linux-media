Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36616 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbcHSI4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:56:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id i138so2559606wmf.3
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2016 01:56:09 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH] cec-follower/cec-compliance: fix bug in string conversion
Date: Fri, 19 Aug 2016 10:56:06 +0200
Message-Id: <1471596966-6164-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In all_dev_types2s: don't try to erase the last two characters in the
string if it is empty.

This was fixed in cec-ctl, so the same fix is applied to cec-compliance
and cec-follower.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-compliance/cec-compliance.cpp | 4 +++-
 utils/cec-follower/cec-follower.cpp     | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/utils/cec-compliance/cec-compliance.cpp b/utils/cec-compliance/cec-compliance.cpp
index c40d4b1..519c572 100644
--- a/utils/cec-compliance/cec-compliance.cpp
+++ b/utils/cec-compliance/cec-compliance.cpp
@@ -358,7 +358,9 @@ std::string all_dev_types2s(unsigned types)
 		s += "Audio System, ";
 	if (types & CEC_OP_ALL_DEVTYPE_SWITCH)
 		s += "Switch, ";
-	return s.erase(s.length() - 2, 2);
+	if (s.length())
+		return s.erase(s.length() - 2, 2);
+	return s;
 }
 
 std::string rc_src_prof2s(unsigned prof)
diff --git a/utils/cec-follower/cec-follower.cpp b/utils/cec-follower/cec-follower.cpp
index abb06a8..7850ecd 100644
--- a/utils/cec-follower/cec-follower.cpp
+++ b/utils/cec-follower/cec-follower.cpp
@@ -305,7 +305,9 @@ std::string all_dev_types2s(unsigned types)
 		s += "Audio System, ";
 	if (types & CEC_OP_ALL_DEVTYPE_SWITCH)
 		s += "Switch, ";
-	return s.erase(s.length() - 2, 2);
+	if (s.length())
+		return s.erase(s.length() - 2, 2);
+	return s;
 }
 
 std::string rc_src_prof2s(unsigned prof)
-- 
2.7.4

