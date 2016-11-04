Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49540 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933470AbcKDOUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 10:20:25 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: an inner loop clobbered the outer loop variable
Message-ID: <fe7ce973-0d4b-1d70-94dc-e7d3f8fc8e6f@xs4all.nl>
Date: Fri, 4 Nov 2016 15:20:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

An inner for-loop reused the outer loop variable. This was
only noticeable with CEC adapters supporting more than one
logical address.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
  drivers/media/cec/cec-adap.c | 9 +++++----
  1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index bcd19d4..ed76d70 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1416,6 +1416,7 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
  		const u8 feature_sz = ARRAY_SIZE(log_addrs->features[0]);
  		u8 *features = log_addrs->features[i];
  		bool op_is_dev_features = false;
+		unsigned j;

  		log_addrs->log_addr[i] = CEC_LOG_ADDR_INVALID;
  		if (type_mask & (1 << log_addrs->log_addr_type[i])) {
@@ -1442,19 +1443,19 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
  			dprintk(1, "unknown logical address type\n");
  			return -EINVAL;
  		}
-		for (i = 0; i < feature_sz; i++) {
-			if ((features[i] & 0x80) == 0) {
+		for (j = 0; j < feature_sz; j++) {
+			if ((features[j] & 0x80) == 0) {
  				if (op_is_dev_features)
  					break;
  				op_is_dev_features = true;
  			}
  		}
-		if (!op_is_dev_features || i == feature_sz) {
+		if (!op_is_dev_features || j == feature_sz) {
  			dprintk(1, "malformed features\n");
  			return -EINVAL;
  		}
  		/* Zero unused part of the feature array */
-		memset(features + i + 1, 0, feature_sz - i - 1);
+		memset(features + j + 1, 0, feature_sz - j - 1);
  	}

  	if (log_addrs->cec_version >= CEC_OP_CEC_VERSION_2_0) {
-- 
2.10.1

