Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34516 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbcHXKv2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 06:51:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so2067149wma.1
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2016 03:51:12 -0700 (PDT)
From: Johan Fjeldtvedt <jaffe1@gmail.com>
To: linux-media@vger.kernel.org
Cc: Johan Fjeldtvedt <jaffe1@gmail.com>
Subject: [PATCHv2] cec tools: exit if device is disconnected
Date: Wed, 24 Aug 2016 12:51:03 +0200
Message-Id: <1472035863-14763-1-git-send-email-jaffe1@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the CEC device is disconnected, ioctl will return ENODEV. This is
checked for in cec-ctl (when monitoring), cec-follower and
cec-compliance, to make these exit when the CEC device disappears.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
---
 utils/cec-compliance/cec-compliance.h |  9 +++++++--
 utils/cec-ctl/cec-ctl.cpp             |  7 ++++++-
 utils/cec-follower/cec-processing.cpp | 14 ++++++++++++--
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/utils/cec-compliance/cec-compliance.h b/utils/cec-compliance/cec-compliance.h
index cb236fd..d59ec1d 100644
--- a/utils/cec-compliance/cec-compliance.h
+++ b/utils/cec-compliance/cec-compliance.h
@@ -334,10 +334,15 @@ static inline bool transmit_timeout(struct node *node, struct cec_msg *msg,
 				    unsigned timeout = 2000)
 {
 	struct cec_msg original_msg = *msg;
+	int res;
 
 	msg->timeout = timeout;
-	if (doioctl(node, CEC_TRANSMIT, msg) ||
-	    !(msg->tx_status & CEC_TX_STATUS_OK))
+	res = doioctl(node, CEC_TRANSMIT, msg);
+	if (res == ENODEV) {
+		printf("Device was disconnected.\n");
+		exit(1);
+	}
+	if (res || !(msg->tx_status & CEC_TX_STATUS_OK))
 		return false;
 
 	if (((msg->rx_status & CEC_RX_STATUS_OK) || (msg->rx_status & CEC_RX_STATUS_FEATURE_ABORT))
diff --git a/utils/cec-ctl/cec-ctl.cpp b/utils/cec-ctl/cec-ctl.cpp
index 2d0d9e5..5938971 100644
--- a/utils/cec-ctl/cec-ctl.cpp
+++ b/utils/cec-ctl/cec-ctl.cpp
@@ -1945,7 +1945,12 @@ skip_la:
 				struct cec_msg msg = { };
 				__u8 from, to;
 
-				if (doioctl(&node, CEC_RECEIVE, &msg))
+				res = doioctl(&node, CEC_RECEIVE, &msg);
+				if (res == ENODEV) {
+					printf("Device was disconnected.\n");
+					break;
+				}
+				if (res)
 					continue;
 
 				from = cec_msg_initiator(&msg);
diff --git a/utils/cec-follower/cec-processing.cpp b/utils/cec-follower/cec-processing.cpp
index 34d65e4..c20fa49 100644
--- a/utils/cec-follower/cec-processing.cpp
+++ b/utils/cec-follower/cec-processing.cpp
@@ -979,7 +979,12 @@ void testProcessing(struct node *node)
 		if (FD_ISSET(fd, &ex_fds)) {
 			struct cec_event ev;
 
-			if (doioctl(node, CEC_DQEVENT, &ev))
+			res = doioctl(node, CEC_DQEVENT, &ev);
+			if (res == ENODEV) {
+				printf("Device was disconnected.\n");
+				break;
+			}
+			if (res)
 				continue;
 			log_event(ev);
 			if (ev.event == CEC_EVENT_STATE_CHANGE) {
@@ -995,7 +1000,12 @@ void testProcessing(struct node *node)
 		if (FD_ISSET(fd, &rd_fds)) {
 			struct cec_msg msg = { };
 
-			if (doioctl(node, CEC_RECEIVE, &msg))
+			res = doioctl(node, CEC_RECEIVE, &msg);
+			if (res == ENODEV) {
+				printf("Device was disconnected.\n");
+				break;
+			}
+			if (res)
 				continue;
 
 			__u8 from = cec_msg_initiator(&msg);
-- 
2.7.4

