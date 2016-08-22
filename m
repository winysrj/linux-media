Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33998 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753678AbcHVJGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 05:06:40 -0400
Received: by mail-wm0-f66.google.com with SMTP id q128so12453295wma.1
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 02:06:40 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCH] cec-follower: check for Routing Information from TV
Date: Mon, 22 Aug 2016 11:06:33 +0200
Message-Id: <1471856793-14263-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A TV shall not send a Routing Information message as initiator.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-follower/cec-processing.cpp | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/utils/cec-follower/cec-processing.cpp b/utils/cec-follower/cec-processing.cpp
index 771eb2d..34d65e4 100644
--- a/utils/cec-follower/cec-processing.cpp
+++ b/utils/cec-follower/cec-processing.cpp
@@ -408,6 +408,12 @@ static void processMsg(struct node *node, struct cec_msg &msg, unsigned me)
 		dev_info("Stream Path is directed to this device\n");
 		return;
 	}
+	case CEC_MSG_ROUTING_INFORMATION: {
+		__u8 la = cec_msg_initiator(&msg);
+
+		if (cec_has_tv(1 << la) && la_info[la].phys_addr == 0)
+			warn("TV (0) at 0.0.0.0 sent Routing Information.");
+	}
 
 
 		/* System Information */
-- 
2.7.4

