Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:59895 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751419AbdB0OYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 09:24:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 9/9] cec: log reason for returning -EINVAL
Date: Mon, 27 Feb 2017 15:20:42 +0100
Message-Id: <20170227142042.37085-10-hverkuil@xs4all.nl>
In-Reply-To: <20170227142042.37085-1-hverkuil@xs4all.nl>
References: <20170227142042.37085-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When validating the struct cec_s_log_addrs input a debug message is printed
for all except two of the 'return -EINVAL' paths.

Also log the reason for the missing two paths.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-adap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 9e25ba20f4d1..46b7da6df9b5 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1461,12 +1461,16 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
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
-- 
2.11.0
