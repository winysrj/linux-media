Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:22609 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcGGNCk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 09:02:40 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-1.cisco.com (8.14.5/8.14.5) with ESMTP id u67D26I1026004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 7 Jul 2016 13:02:06 GMT
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] cec-funcs.h: add missing 'reply' for short audio descriptor
To: linux-media <linux-media@vger.kernel.org>
Message-ID: <577E52CE.2060702@cisco.com>
Date: Thu, 7 Jul 2016 15:02:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cec_msg_request_short_audio_descriptor function was missing the reply
argument. That's needed if you want the framework to wait for the reply
message.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 19486009..763d0fe 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -1495,6 +1495,7 @@ static inline void cec_ops_report_short_audio_descriptor(const struct cec_msg *m

 static inline void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
 					__u8 num_descriptors,
+					bool reply,
 					const __u8 *audio_format_id,
 					const __u8 *audio_format_code)
 {
@@ -1504,6 +1505,7 @@ static inline void cec_msg_request_short_audio_descriptor(struct cec_msg *msg,
 		num_descriptors = 4;
 	msg->len = 2 + num_descriptors;
 	msg->msg[1] = CEC_MSG_REQUEST_SHORT_AUDIO_DESCRIPTOR;
+	msg->reply = reply ? CEC_MSG_REPORT_SHORT_AUDIO_DESCRIPTOR : 0;
 	for (i = 0; i < num_descriptors; i++)
 		msg->msg[2 + i] = (audio_format_id[i] << 6) |
 				  (audio_format_code[i] & 0x3f);
