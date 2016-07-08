Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58913 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065AbcGHIwj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jul 2016 04:52:39 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CC8F5180C71
	for <linux-media@vger.kernel.org>; Fri,  8 Jul 2016 10:52:34 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] cec-funcs.h: add missing 'reply' for short audio descriptor
Message-ID: <6979f617-fc6a-b679-2085-f11c94095fa2@xs4all.nl>
Date: Fri, 8 Jul 2016 10:52:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cec_msg_request_short_audio_descriptor function was missing the reply
argument. That's needed if you want the framework to wait for the reply
message.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
The bool reply should come after the msg argument, not the num_descriptors argument as was
the case in v1 of this patch.
---
diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 1948600..506bca9 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -1494,6 +1494,7 @@ static inline void cec_ops_report_short_audio_descriptor(const struct cec_msg *m
 }

 static inline void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
+					bool reply,
 					__u8 num_descriptors,
 					const __u8 *audio_format_id,
 					const __u8 *audio_format_code)
@@ -1504,6 +1505,7 @@ static inline void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
 		num_descriptors = 4;
 	msg->len = 2 + num_descriptors;
 	msg->msg[1] = CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR;
+	msg->reply = reply ? CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR : 0;
 	for (i = 0; i < num_descriptors; i++)
 		msg->msg[2 + i] = (audio_format_id[i] << 6) |
 				  (audio_format_code[i] & 0x3f);
