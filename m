Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47743 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017AbcHAK35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 06:29:57 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: David Binderman <linuxdev.baldrick@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.8] cec-funcs.h: fix typo: && should be &
Message-ID: <3c1ddbdb-1d56-0a7b-c7fa-9ef8c31ca773@xs4all.nl>
Date: Mon, 1 Aug 2016 12:29:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix typo where logical AND was used instead of bitwise AND.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: David Binderman <linuxdev.baldrick@gmail.com>
---
diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 82c3d3b..9e054aa 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -227,7 +227,7 @@ static inline void cec_set_digital_service_id(__u8 *msg,
 	if (digital->service_id_method == CEC_OP_SERVICE_ID_METHOD_BY_CHANNEL) {
 		*msg++ = (digital->channel.channel_number_fmt << 2) |
 			 (digital->channel.major >> 8);
-		*msg++ = digital->channel.major && 0xff;
+		*msg++ = digital->channel.major & 0xff;
 		*msg++ = digital->channel.minor >> 8;
 		*msg++ = digital->channel.minor & 0xff;
 		*msg++ = 0;
@@ -1277,7 +1277,7 @@ static inline void cec_msg_user_control_pressed(struct cec_msg *msg,
 		msg->len += 4;
 		msg->msg[3] = (ui_cmd->channel_identifier.channel_number_fmt << 2) |
 			      (ui_cmd->channel_identifier.major >> 8);
-		msg->msg[4] = ui_cmd->channel_identifier.major && 0xff;
+		msg->msg[4] = ui_cmd->channel_identifier.major & 0xff;
 		msg->msg[5] = ui_cmd->channel_identifier.minor >> 8;
 		msg->msg[6] = ui_cmd->channel_identifier.minor & 0xff;
 		break;
