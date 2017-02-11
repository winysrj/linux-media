Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33892 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753317AbdBKLYw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Feb 2017 06:24:52 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.10] cec: initiator should be the same as the
 destination for, poll
Message-ID: <cd914a2a-9156-d3a9-066a-94383bcbf731@xs4all.nl>
Date: Sat, 11 Feb 2017 12:24:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Poll messages that are used to allocate a logical address should
use the same initiator as the destination. Instead, it expected that
the initiator was 0xf which is not according to the standard.

This also had consequences for the message checks in cec_transmit_msg_fh
that incorrectly rejected poll messages with the same initiator and
destination.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.10
---
 drivers/media/cec/cec-adap.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index ebb5e391b800..289767a1f031 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -612,8 +612,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	}
 	memset(msg->msg + msg->len, 0, sizeof(msg->msg) - msg->len);
 	if (msg->len == 1) {
-		if (cec_msg_initiator(msg) != 0xf ||
-		    cec_msg_destination(msg) == 0xf) {
+		if (cec_msg_destination(msg) == 0xf) {
 			dprintk(1, "cec_transmit_msg: invalid poll message\n");
 			return -EINVAL;
 		}
@@ -638,7 +637,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 		dprintk(1, "cec_transmit_msg: destination is the adapter itself\n");
 		return -EINVAL;
 	}
-	if (cec_msg_initiator(msg) != 0xf &&
+	if (msg->len > 1 && adap->is_configured &&
 	    !cec_has_log_addr(adap, cec_msg_initiator(msg))) {
 		dprintk(1, "cec_transmit_msg: initiator has unknown logical address %d\n",
 			cec_msg_initiator(msg));
@@ -1072,7 +1071,7 @@ static int cec_config_log_addr(struct cec_adapter *adap,

 	/* Send poll message */
 	msg.len = 1;
-	msg.msg[0] = 0xf0 | log_addr;
+	msg.msg[0] = (log_addr << 4) | log_addr;
 	err = cec_transmit_msg_fh(adap, &msg, NULL, true);

 	/*
-- 
2.11.0

