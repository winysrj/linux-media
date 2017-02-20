Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53795 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751454AbdBTUTU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 15:19:20 -0500
To: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: log reason for returning -EINVAL
Message-ID: <26fa2907-87ed-301c-b45a-7ea8d86e5305@xs4all.nl>
Date: Mon, 20 Feb 2017 12:19:13 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When validating the struct cec_s_log_addrs input a debug message is printed
for all except two of the 'return -EINVAL' paths.

Also log the reason for the missing two paths.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index ebb5e391..72f9bba 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1436,12 +1436,16 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 	 * within the correct range.
 	 */
 	if (log_addrs->vendor_id != CEC_VENDOR_ID_NONE &&
-	    (log_addrs->vendor_id & 0xff000000) != 0)
+	    (log_addrs->vendor_id & 0xff000000) != 0) {
+		dprintk(1, "invalid vendor ID\n");
 		return -EINVAL;
+	}
 
 	if (log_addrs->cec_version != CEC_OP_CEC_VERSION_1_4 &&
-	    log_addrs->cec_version != CEC_OP_CEC_VERSION_2_0)
+	    log_addrs->cec_version != CEC_OP_CEC_VERSION_2_0) {
+		dprintk(1, "invalid CEC version\n");
 		return -EINVAL;
+	}
 
 	if (log_addrs->num_log_addrs > 1)
 		for (i = 0; i < log_addrs->num_log_addrs; i++)
