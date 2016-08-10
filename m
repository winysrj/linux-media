Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:36047 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351AbcHJSNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2016 14:13:34 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id u7AB1cKd032709
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 10 Aug 2016 11:01:39 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.8] cec-funcs.h: add reply argument for Record On/Off
Message-ID: <57AB0992.5080503@cisco.com>
Date: Wed, 10 Aug 2016 13:01:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A reply parameter is added to the cec_msg_record_on/off functions in
cec-funcs.h. The standard mandates that Record Status shall be replied
to Record On, and it may be replied to Record Off.

Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/cec-funcs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 82c3d3b..43104db 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -162,10 +162,11 @@ static inline void cec_msg_standby(struct cec_msg *msg)


 /* One Touch Record Feature */
-static inline void cec_msg_record_off(struct cec_msg *msg)
+static inline void cec_msg_record_off(struct cec_msg *msg, bool reply)
 {
 	msg->len = 2;
 	msg->msg[1] = CEC_MSG_RECORD_OFF;
+	msg->reply = reply ? CEC_MSG_RECORD_STATUS : 0;
 }

 struct cec_op_arib_data {
@@ -323,6 +324,7 @@ static inline void cec_msg_record_on_phys_addr(struct cec_msg *msg,
 }

 static inline void cec_msg_record_on(struct cec_msg *msg,
+				     bool reply,
 				     const struct cec_op_record_src *rec_src)
 {
 	switch (rec_src->type) {
@@ -346,6 +348,7 @@ static inline void cec_msg_record_on(struct cec_msg *msg,
 					    rec_src->ext_phys_addr.phys_addr);
 		break;
 	}
+	msg->reply = reply ? CEC_MSG_RECORD_STATUS : 0;
 }

 static inline void cec_ops_record_on(const struct cec_msg *msg,
-- 
2.7.0

