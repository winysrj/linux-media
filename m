Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:59658 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751388AbcLFO4J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 09:56:09 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.10] cec: fix report_current_latency
Message-ID: <44693fc8-5953-0ca7-3157-592da8b5ee87@xs4all.nl>
Date: Tue, 6 Dec 2016 15:54:35 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the (very) small print of the REPORT_CURRENT_LATENCY message there is a
line that says that the last byte of the message (audio out delay) is only
present if the 'audio out compensated' value is 3.

I missed this, and so if this message was sent with a total length of 6 
(i.e.
without the audio out delay byte), then it was rejected by the framework
since a minimum length of 7 was expected.

Fix this minimum length check and update wrappers in cec-funcs.h to do the
right thing based on the message length.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
  drivers/media/cec/cec-adap.c   |  2 +-
  include/uapi/linux/cec-funcs.h | 10 +++++++---
  2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 0ea4efb..f15f6ff 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -851,7 +851,7 @@ static const u8 cec_msg_size[256] = {
  	[CEC_MSG_REQUEST_ARC_TERMINATION] = 2 | DIRECTED,
  	[CEC_MSG_TERMINATE_ARC] = 2 | DIRECTED,
  	[CEC_MSG_REQUEST_CURRENT_LATENCY] = 4 | BCAST,
-	[CEC_MSG_REPORT_CURRENT_LATENCY] = 7 | BCAST,
+	[CEC_MSG_REPORT_CURRENT_LATENCY] = 6 | BCAST,
  	[CEC_MSG_CDC_MESSAGE] = 2 | BCAST,
  };

diff --git a/include/uapi/linux/cec-funcs.h b/include/uapi/linux/cec-funcs.h
index 3cbc327..c451eec 100644
--- a/include/uapi/linux/cec-funcs.h
+++ b/include/uapi/linux/cec-funcs.h
@@ -1665,14 +1665,15 @@ static inline void 
cec_msg_report_current_latency(struct cec_msg *msg,
  						  __u8 audio_out_compensated,
  						  __u8 audio_out_delay)
  {
-	msg->len = 7;
+	msg->len = 6;
  	msg->msg[0] |= 0xf; /* broadcast */
  	msg->msg[1] = CEC_MSG_REPORT_CURRENT_LATENCY;
  	msg->msg[2] = phys_addr >> 8;
  	msg->msg[3] = phys_addr & 0xff;
  	msg->msg[4] = video_latency;
  	msg->msg[5] = (low_latency_mode << 2) | audio_out_compensated;
-	msg->msg[6] = audio_out_delay;
+	if (audio_out_compensated == 3)
+		msg->msg[msg->len++] = audio_out_delay;
  }

  static inline void cec_ops_report_current_latency(const struct cec_msg 
*msg,
@@ -1686,7 +1687,10 @@ static inline void 
cec_ops_report_current_latency(const struct cec_msg *msg,
  	*video_latency = msg->msg[4];
  	*low_latency_mode = (msg->msg[5] >> 2) & 1;
  	*audio_out_compensated = msg->msg[5] & 3;
-	*audio_out_delay = msg->msg[6];
+	if (*audio_out_compensated == 3 && msg->len >= 7)
+		*audio_out_delay = msg->msg[6];
+	else
+		*audio_out_delay = 0;
  }

  static inline void cec_msg_request_current_latency(struct cec_msg *msg,
-- 
2.10.2

