Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:50309 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727348AbeIMR7J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 13:59:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] cec: integrate cec_validate_phys_addr() in cec-api.c
Date: Thu, 13 Sep 2018 14:49:42 +0200
Message-Id: <20180913124944.39863-3-hverkuil@xs4all.nl>
In-Reply-To: <20180913124944.39863-1-hverkuil@xs4all.nl>
References: <20180913124944.39863-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cec_phys_addr_validate() function will be moved to V4L2,
so use a simplified variant of that function in cec-api.c.
cec now no longer calls cec_phys_addr_validate() and it can
be safely moved to V4L2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/cec/cec-api.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 19170b1073fa..391b6fd483e1 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -101,6 +101,23 @@ static long cec_adap_g_phys_addr(struct cec_adapter *adap,
 	return 0;
 }
 
+static int cec_validate_phys_addr(u16 phys_addr)
+{
+	int i;
+
+	if (phys_addr == CEC_PHYS_ADDR_INVALID)
+		return 0;
+	for (i = 0; i < 16; i += 4)
+		if (phys_addr & (0xf << i))
+			break;
+	if (i == 16)
+		return 0;
+	for (i += 4; i < 16; i += 4)
+		if ((phys_addr & (0xf << i)) == 0)
+			return -EINVAL;
+	return 0;
+}
+
 static long cec_adap_s_phys_addr(struct cec_adapter *adap, struct cec_fh *fh,
 				 bool block, __u16 __user *parg)
 {
@@ -112,7 +129,7 @@ static long cec_adap_s_phys_addr(struct cec_adapter *adap, struct cec_fh *fh,
 	if (copy_from_user(&phys_addr, parg, sizeof(phys_addr)))
 		return -EFAULT;
 
-	err = cec_phys_addr_validate(phys_addr, NULL, NULL);
+	err = cec_validate_phys_addr(phys_addr);
 	if (err)
 		return err;
 	mutex_lock(&adap->lock);
-- 
2.18.0
