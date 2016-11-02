Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:33768 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753029AbcKBMqj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Nov 2016 08:46:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/11] cec: filter invalid messages
Date: Wed,  2 Nov 2016 13:46:29 +0100
Message-Id: <20161102124635.11989-6-hverkuil@xs4all.nl>
In-Reply-To: <20161102124635.11989-1-hverkuil@xs4all.nl>
References: <20161102124635.11989-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

As per the CEC specification:

- CEC messages with a too-small payload should be ignored.
- Broadcast messages that are only allowed as directed messages
  should be ignored.
- Directed messages that are only allowed as broadcast messages
  should be ignored.

Implement this in the core CEC framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 157 ++++++++++++++++++++++++++++++++++-
 1 file changed, 155 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 6aceb1d..93b53e6 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -762,14 +762,105 @@ EXPORT_SYMBOL_GPL(cec_transmit_msg);
 static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 			      bool is_reply);
 
+#define DIRECTED	0x80
+#define BCAST1_4	0x40
+#define BCAST2_0	0x20	/* broadcast only allowed for >= 2.0 */
+#define BCAST		(BCAST1_4 | BCAST2_0)
+#define BOTH		(BCAST | DIRECTED)
+
+/*
+ * Specify minimum length and whether the message is directed, broadcast
+ * or both. Messages that do not match the criteria are ignored as per
+ * the CEC specification.
+ */
+static const u8 cec_msg_size[256] = {
+	[CEC_MSG_ACTIVE_SOURCE] = 4 | BCAST,
+	[CEC_MSG_IMAGE_VIEW_ON] = 2 | DIRECTED,
+	[CEC_MSG_TEXT_VIEW_ON] = 2 | DIRECTED,
+	[CEC_MSG_INACTIVE_SOURCE] = 4 | DIRECTED,
+	[CEC_MSG_REQUEST_ACTIVE_SOURCE] = 2 | BCAST,
+	[CEC_MSG_ROUTING_CHANGE] = 6 | BCAST,
+	[CEC_MSG_ROUTING_INFORMATION] = 4 | BCAST,
+	[CEC_MSG_SET_STREAM_PATH] = 4 | BCAST,
+	[CEC_MSG_STANDBY] = 2 | BOTH,
+	[CEC_MSG_RECORD_OFF] = 2 | DIRECTED,
+	[CEC_MSG_RECORD_ON] = 3 | DIRECTED,
+	[CEC_MSG_RECORD_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_RECORD_TV_SCREEN] = 2 | DIRECTED,
+	[CEC_MSG_CLEAR_ANALOGUE_TIMER] = 13 | DIRECTED,
+	[CEC_MSG_CLEAR_DIGITAL_TIMER] = 16 | DIRECTED,
+	[CEC_MSG_CLEAR_EXT_TIMER] = 13 | DIRECTED,
+	[CEC_MSG_SET_ANALOGUE_TIMER] = 13 | DIRECTED,
+	[CEC_MSG_SET_DIGITAL_TIMER] = 16 | DIRECTED,
+	[CEC_MSG_SET_EXT_TIMER] = 13 | DIRECTED,
+	[CEC_MSG_SET_TIMER_PROGRAM_TITLE] = 2 | DIRECTED,
+	[CEC_MSG_TIMER_CLEARED_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_TIMER_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_CEC_VERSION] = 3 | DIRECTED,
+	[CEC_MSG_GET_CEC_VERSION] = 2 | DIRECTED,
+	[CEC_MSG_GIVE_PHYSICAL_ADDR] = 2 | DIRECTED,
+	[CEC_MSG_GET_MENU_LANGUAGE] = 2 | DIRECTED,
+	[CEC_MSG_REPORT_PHYSICAL_ADDR] = 5 | BCAST,
+	[CEC_MSG_SET_MENU_LANGUAGE] = 5 | BCAST,
+	[CEC_MSG_REPORT_FEATURES] = 6 | BCAST,
+	[CEC_MSG_GIVE_FEATURES] = 2 | DIRECTED,
+	[CEC_MSG_DECK_CONTROL] = 3 | DIRECTED,
+	[CEC_MSG_DECK_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_GIVE_DECK_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_PLAY] = 3 | DIRECTED,
+	[CEC_MSG_GIVE_TUNER_DEVICE_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_SELECT_ANALOGUE_SERVICE] = 6 | DIRECTED,
+	[CEC_MSG_SELECT_DIGITAL_SERVICE] = 9 | DIRECTED,
+	[CEC_MSG_TUNER_DEVICE_STATUS] = 7 | DIRECTED,
+	[CEC_MSG_TUNER_STEP_DECREMENT] = 2 | DIRECTED,
+	[CEC_MSG_TUNER_STEP_INCREMENT] = 2 | DIRECTED,
+	[CEC_MSG_DEVICE_VENDOR_ID] = 5 | BCAST,
+	[CEC_MSG_GIVE_DEVICE_VENDOR_ID] = 2 | DIRECTED,
+	[CEC_MSG_VENDOR_COMMAND] = 2 | DIRECTED,
+	[CEC_MSG_VENDOR_COMMAND_WITH_ID] = 5 | BOTH,
+	[CEC_MSG_VENDOR_REMOTE_BUTTON_DOWN] = 2 | BOTH,
+	[CEC_MSG_VENDOR_REMOTE_BUTTON_UP] = 2 | BOTH,
+	[CEC_MSG_SET_OSD_STRING] = 3 | DIRECTED,
+	[CEC_MSG_GIVE_OSD_NAME] = 2 | DIRECTED,
+	[CEC_MSG_SET_OSD_NAME] = 2 | DIRECTED,
+	[CEC_MSG_MENU_REQUEST] = 3 | DIRECTED,
+	[CEC_MSG_MENU_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_USER_CONTROL_PRESSED] = 3 | DIRECTED,
+	[CEC_MSG_USER_CONTROL_RELEASED] = 2 | DIRECTED,
+	[CEC_MSG_GIVE_DEVICE_POWER_STATUS] = 2 | DIRECTED,
+	[CEC_MSG_REPORT_POWER_STATUS] = 3 | DIRECTED | BCAST2_0,
+	[CEC_MSG_FEATURE_ABORT] = 4 | DIRECTED,
+	[CEC_MSG_ABORT] = 2 | DIRECTED,
+	[CEC_MSG_GIVE_AUDIO_STATUS] = 2 | DIRECTED,
+	[CEC_MSG_GIVE_SYSTEM_AUDIO_MODE_STATUS] = 2 | DIRECTED,
+	[CEC_MSG_REPORT_AUDIO_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR] = 2 | DIRECTED,
+	[CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR] = 2 | DIRECTED,
+	[CEC_MSG_SET_SYSTEM_AUDIO_MODE] = 3 | BOTH,
+	[CEC_MSG_SYSTEM_AUDIO_MODE_REQUEST] = 2 | DIRECTED,
+	[CEC_MSG_SYSTEM_AUDIO_MODE_STATUS] = 3 | DIRECTED,
+	[CEC_MSG_SET_AUDIO_RATE] = 3 | DIRECTED,
+	[CEC_MSG_INITIATE_ARC] = 2 | DIRECTED,
+	[CEC_MSG_REPORT_ARC_INITIATED] = 2 | DIRECTED,
+	[CEC_MSG_REPORT_ARC_TERMINATED] = 2 | DIRECTED,
+	[CEC_MSG_REQUEST_ARC_INITIATION] = 2 | DIRECTED,
+	[CEC_MSG_REQUEST_ARC_TERMINATION] = 2 | DIRECTED,
+	[CEC_MSG_TERMINATE_ARC] = 2 | DIRECTED,
+	[CEC_MSG_REQUEST_CURRENT_LATENCY] = 4 | BCAST,
+	[CEC_MSG_REPORT_CURRENT_LATENCY] = 7 | BCAST,
+	[CEC_MSG_CDC_MESSAGE] = 2 | BCAST,
+};
+
 /* Called by the CEC adapter if a message is received */
 void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 {
 	struct cec_data *data;
 	u8 msg_init = cec_msg_initiator(msg);
 	u8 msg_dest = cec_msg_destination(msg);
+	u8 cmd = msg->msg[1];
 	bool is_reply = false;
 	bool valid_la = true;
+	u8 min_len = 0;
 
 	if (WARN_ON(!msg->len || msg->len > CEC_MAX_MSG_SIZE))
 		return;
@@ -789,9 +880,71 @@ void cec_received_msg(struct cec_adapter *adap, struct cec_msg *msg)
 	if (!cec_msg_is_broadcast(msg))
 		valid_la = cec_has_log_addr(adap, msg_dest);
 
+	/*
+	 * Check if the length is not too short or if the message is a
+	 * broadcast message where a directed message was expected or
+	 * vice versa. If so, then the message has to be ignored (according
+	 * to section CEC 7.3 and CEC 12.2).
+	 */
+	if (valid_la && msg->len > 1 && cec_msg_size[cmd]) {
+		u8 dir_fl = cec_msg_size[cmd] & BOTH;
+
+		min_len = cec_msg_size[cmd] & 0x1f;
+		if (msg->len < min_len)
+			valid_la = false;
+		else if (!cec_msg_is_broadcast(msg) && !(dir_fl & DIRECTED))
+			valid_la = false;
+		else if (cec_msg_is_broadcast(msg) && !(dir_fl & BCAST1_4))
+			valid_la = false;
+		else if (cec_msg_is_broadcast(msg) &&
+			 adap->log_addrs.cec_version >= CEC_OP_CEC_VERSION_2_0 &&
+			 !(dir_fl & BCAST2_0))
+			valid_la = false;
+	}
+	if (valid_la && min_len) {
+		/* These messages have special length requirements */
+		switch (cmd) {
+		case CEC_MSG_TIMER_STATUS:
+			if (msg->msg[2] & 0x10) {
+				switch (msg->msg[2] & 0xf) {
+				case CEC_OP_PROG_INFO_NOT_ENOUGH_SPACE:
+				case CEC_OP_PROG_INFO_MIGHT_NOT_BE_ENOUGH_SPACE:
+					if (msg->len < 5)
+						valid_la = false;
+					break;
+				}
+			} else if ((msg->msg[2] & 0xf) == CEC_OP_PROG_ERROR_DUPLICATE) {
+				if (msg->len < 5)
+					valid_la = false;
+			}
+			break;
+		case CEC_MSG_RECORD_ON:
+			switch (msg->msg[2]) {
+			case CEC_OP_RECORD_SRC_OWN:
+				break;
+			case CEC_OP_RECORD_SRC_DIGITAL:
+				if (msg->len < 10)
+					valid_la = false;
+				break;
+			case CEC_OP_RECORD_SRC_ANALOG:
+				if (msg->len < 7)
+					valid_la = false;
+				break;
+			case CEC_OP_RECORD_SRC_EXT_PLUG:
+				if (msg->len < 4)
+					valid_la = false;
+				break;
+			case CEC_OP_RECORD_SRC_EXT_PHYS_ADDR:
+				if (msg->len < 5)
+					valid_la = false;
+				break;
+			}
+			break;
+		}
+	}
+
 	/* It's a valid message and not a poll or CDC message */
-	if (valid_la && msg->len > 1 && msg->msg[1] != CEC_MSG_CDC_MESSAGE) {
-		u8 cmd = msg->msg[1];
+	if (valid_la && msg->len > 1 && cmd != CEC_MSG_CDC_MESSAGE) {
 		bool abort = cmd == CEC_MSG_FEATURE_ABORT;
 
 		/* The aborted command is in msg[2] */
-- 
2.10.1

