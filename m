Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53505 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755021AbcIINVN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Sep 2016 09:21:13 -0400
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: hans.verkuil@cisco.com, mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org,
        Andrey Utkin <andrey_utkin@fastmail.com>
Subject: [PATCH] v4l2-ctl: Fix unneeded dot in "no hsync lock"
Date: Fri,  9 Sep 2016 16:21:04 +0300
Message-Id: <20160909132104.31476-1-andrey.utkin@corp.bluecherry.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrey Utkin <andrey_utkin@fastmail.com>

Signed-off-by: Andrey Utkin <andrey_utkin@fastmail.com>
---
 utils/v4l2-ctl/v4l2-ctl-io.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-io.cpp b/utils/v4l2-ctl/v4l2-ctl-io.cpp
index e778569..30798ea 100644
--- a/utils/v4l2-ctl/v4l2-ctl-io.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-io.cpp
@@ -53,7 +53,7 @@ static const flag_def in_status_def[] = {
 	{ V4L2_IN_ST_NO_COLOR,    "no color" },
 	{ V4L2_IN_ST_HFLIP,       "hflip" },
 	{ V4L2_IN_ST_VFLIP,       "vflip" },
-	{ V4L2_IN_ST_NO_H_LOCK,   "no hsync lock." },
+	{ V4L2_IN_ST_NO_H_LOCK,   "no hsync lock" },
 	{ V4L2_IN_ST_COLOR_KILL,  "color kill" },
 	{ V4L2_IN_ST_NO_SYNC,     "no sync lock" },
 	{ V4L2_IN_ST_NO_EQU,      "no equalizer lock" },
-- 
2.9.2

