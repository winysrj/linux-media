Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:5006 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbcGFIta (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jul 2016 04:49:30 -0400
To: linux-media <linux-media@vger.kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] cec-funcs.h: add length checks
Message-ID: <577CC616.7060002@cisco.com>
Date: Wed, 6 Jul 2016 10:49:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add msg->len sanity checks to fix static checker warning:

	include/linux/cec-funcs.h:1154 cec_ops_set_osd_string()
	warn: setting length 'msg->len - 3' to negative one

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/cec-funcs.h b/include/linux/cec-funcs.h
index 19486009..8d217ce 100644
--- a/include/linux/cec-funcs.h
+++ b/include/linux/cec-funcs.h
@@ -788,7 +788,7 @@ static inline void cec_msg_set_timer_program_title(struct cec_msg *msg,
 static inline void cec_ops_set_timer_program_title(const struct cec_msg *msg,
 						   char *prog_title)
 {
-	unsigned int len = msg->len - 2;
+	unsigned int len = msg->len > 2 ? msg->len - 2 : 0;

 	if (len > 14)
 		len = 14;
@@ -1167,7 +1167,7 @@ static inline void cec_ops_set_osd_string(const struct cec_msg *msg,
 					  __u8 *disp_ctl,
 					  char *osd)
 {
-	unsigned int len = msg->len - 3;
+	unsigned int len = msg->len > 3 ? msg->len - 3 : 0;

 	*disp_ctl = msg->msg[2];
 	if (len > 13)
@@ -1192,7 +1192,7 @@ static inline void cec_msg_set_osd_name(struct cec_msg *msg, const char *name)
 static inline void cec_ops_set_osd_name(const struct cec_msg *msg,
 					char *name)
 {
-	unsigned int len = msg->len - 2;
+	unsigned int len = msg->len > 2 ? msg->len - 2 : 0;

 	if (len > 14)
 		len = 14;
