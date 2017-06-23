Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0089.outbound.protection.outlook.com ([104.47.33.89]:18217
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752066AbdFWN4a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 09:56:30 -0400
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <soren.brinkmann@xilinx.com>)
        id 1dOP4Q-00071Q-9s
        for linux-media@vger.kernel.org; Fri, 23 Jun 2017 06:56:22 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <soren.brinkmann@xilinx.com>)
        id 1dOP4Q-0004am-6t
        for linux-media@vger.kernel.org; Fri, 23 Jun 2017 06:56:22 -0700
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: <linux-media@vger.kernel.org>
CC: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH v4l2-utils] v4l2-ctl: Print numerical control ID
Date: Fri, 23 Jun 2017 06:56:12 -0700
Message-ID: <20170623135612.23922-1-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Print the numerical ID for each control in list commands.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
I was trying to set controls from a userspace application and was hence looking
for an easy way to find the control IDs to use with VIDIOC_(G|S)_EXT_CTRLS. The
-l/-L options of v4l2-ctl already provide most information needed, hence I
thought I'd add the numerical ID too.

	Sören

 utils/v4l2-ctl/v4l2-ctl-common.cpp | 45 +++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-common.cpp b/utils/v4l2-ctl/v4l2-ctl-common.cpp
index 6d9371eacbb7..149053bbbd4a 100644
--- a/utils/v4l2-ctl/v4l2-ctl-common.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-common.cpp
@@ -313,67 +313,68 @@ static void print_qctrl(int fd, struct v4l2_query_ext_ctrl *queryctrl,
 	qmenu.id = queryctrl->id;
 	switch (queryctrl->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
-		printf("%31s (int)    : min=%lld max=%lld step=%lld default=%lld",
-				s.c_str(),
+		printf("%31s/%#8.8x (int)    : min=%lld max=%lld step=%lld default=%lld",
+				s.c_str(), qmenu.id,
 				queryctrl->minimum, queryctrl->maximum,
 				queryctrl->step, queryctrl->default_value);
 		break;
 	case V4L2_CTRL_TYPE_INTEGER64:
-		printf("%31s (int64)  : min=%lld max=%lld step=%lld default=%lld",
-				s.c_str(),
+		printf("%31s/%#8.8x (int64)  : min=%lld max=%lld step=%lld default=%lld",
+				s.c_str(), qmenu.id,
 				queryctrl->minimum, queryctrl->maximum,
 				queryctrl->step, queryctrl->default_value);
 		break;
 	case V4L2_CTRL_TYPE_STRING:
-		printf("%31s (str)    : min=%lld max=%lld step=%lld",
-				s.c_str(),
+		printf("%31s/%#8.8x (str)    : min=%lld max=%lld step=%lld",
+				s.c_str(), qmenu.id,
 				queryctrl->minimum, queryctrl->maximum,
 				queryctrl->step);
 		break;
 	case V4L2_CTRL_TYPE_BOOLEAN:
-		printf("%31s (bool)   : default=%lld",
-				s.c_str(), queryctrl->default_value);
+		printf("%31s/%#8.8x (bool)   : default=%lld",
+				s.c_str(), qmenu.id, queryctrl->default_value);
 		break;
 	case V4L2_CTRL_TYPE_MENU:
-		printf("%31s (menu)   : min=%lld max=%lld default=%lld",
-				s.c_str(),
+		printf("%31s/%#8.8x (menu)   : min=%lld max=%lld default=%lld",
+				s.c_str(), qmenu.id,
 				queryctrl->minimum, queryctrl->maximum,
 				queryctrl->default_value);
 		break;
 	case V4L2_CTRL_TYPE_INTEGER_MENU:
-		printf("%31s (intmenu): min=%lld max=%lld default=%lld",
-				s.c_str(),
+		printf("%31s/%#8.8x (intmenu): min=%lld max=%lld default=%lld",
+				s.c_str(), qmenu.id,
 				queryctrl->minimum, queryctrl->maximum,
 				queryctrl->default_value);
 		break;
 	case V4L2_CTRL_TYPE_BUTTON:
-		printf("%31s (button) :", s.c_str());
+		printf("%31s/%#8.8x (button) :", s.c_str(), qmenu.id);
 		break;
 	case V4L2_CTRL_TYPE_BITMASK:
-		printf("%31s (bitmask): max=0x%08llx default=0x%08llx",
-				s.c_str(), queryctrl->maximum,
+		printf("%31s/%#8.8x (bitmask): max=0x%08llx default=0x%08llx",
+				s.c_str(), qmenu.id, queryctrl->maximum,
 				queryctrl->default_value);
 		break;
 	case V4L2_CTRL_TYPE_U8:
-		printf("%31s (u8)     : min=%lld max=%lld step=%lld default=%lld",
-				s.c_str(),
+		printf("%31s/%#8.8x (u8)     : min=%lld max=%lld step=%lld default=%lld",
+				s.c_str(), qmenu.id,
 				queryctrl->minimum, queryctrl->maximum,
 				queryctrl->step, queryctrl->default_value);
 		break;
 	case V4L2_CTRL_TYPE_U16:
-		printf("%31s (u16)    : min=%lld max=%lld step=%lld default=%lld",
-				s.c_str(),
+		printf("%31s/%#8.8x (u16)    : min=%lld max=%lld step=%lld default=%lld",
+				s.c_str(), qmenu.id,
 				queryctrl->minimum, queryctrl->maximum,
 				queryctrl->step, queryctrl->default_value);
 		break;
 	case V4L2_CTRL_TYPE_U32:
-		printf("%31s (u32)    : min=%lld max=%lld step=%lld default=%lld",
-				s.c_str(),
+		printf("%31s/%#8.8x (u32)    : min=%lld max=%lld step=%lld default=%lld",
+				s.c_str(), qmenu.id,
 				queryctrl->minimum, queryctrl->maximum,
 				queryctrl->step, queryctrl->default_value);
 		break;
 	default:
-		printf("%31s (unknown): type=%x", s.c_str(), queryctrl->type);
+		printf("%31s/%#8.8x (unknown): type=%x",
+				s.c_str(), qmenu.id, queryctrl->type);
 		break;
 	}
 	if (queryctrl->nr_of_dims == 0) {
-- 
2.13.1.3.g25490cb03
