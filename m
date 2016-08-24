Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:15772 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753384AbcHXKRy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 06:17:54 -0400
Received: from [10.47.79.81] ([10.47.79.81])
        (authenticated bits=0)
        by aer-core-2.cisco.com (8.14.5/8.14.5) with ESMTP id u7OAHMH9020013
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2016 10:17:23 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.8] cec: fix ioctl return code when not registered
Message-ID: <57BD7432.9090502@cisco.com>
Date: Wed, 24 Aug 2016 12:17:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't return the confusing -EIO error code when the device is not registered,
instead return -ENODEV which is the proper thing to do in this situation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 7be7615..049f171 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -435,7 +435,7 @@ static long cec_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	void __user *parg = (void __user *)arg;

 	if (!devnode->registered)
-		return -EIO;
+		return -ENODEV;

 	switch (cmd) {
 	case CEC_ADAP_G_CAPS:
