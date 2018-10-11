Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:54707 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726656AbeJKSFM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Oct 2018 14:05:12 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: increase debug level for 'queue full'
Message-ID: <3a521fce-3657-e2e4-9f9b-94adf39875d3@xs4all.nl>
Date: Thu, 11 Oct 2018 12:38:27 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "transmit queue full" message doesn't warrant debug level 1 since
it is already clear from the error code what's going on.

Bump to level 2.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 0c0d9107383e..b21f80c20fb2 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -807,7 +807,7 @@ int cec_transmit_msg_fh(struct cec_adapter *adap, struct cec_msg *msg,
 	}

 	if (adap->transmit_queue_sz >= CEC_MAX_MSG_TX_QUEUE_SZ) {
-		dprintk(1, "%s: transmit queue full\n", __func__);
+		dprintk(2, "%s: transmit queue full\n", __func__);
 		return -EBUSY;
 	}
