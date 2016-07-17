Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42090 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750959AbcGQPCo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:02:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/7] cec: CEC_RECEIVE overwrote the timeout field
Date: Sun, 17 Jul 2016 17:02:28 +0200
Message-Id: <1468767754-48542-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
References: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When CEC_RECEIVE returns a message the original timeout field
was overwritten. Restore the timeout field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 9151b1f..879f7d9 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -209,6 +209,7 @@ static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
 /* Called by CEC_RECEIVE: wait for a message to arrive */
 static int cec_receive_msg(struct cec_fh *fh, struct cec_msg *msg, bool block)
 {
+	u32 timeout = msg->timeout;
 	int res;
 
 	do {
@@ -225,6 +226,8 @@ static int cec_receive_msg(struct cec_fh *fh, struct cec_msg *msg, bool block)
 			kfree(entry);
 			fh->queued_msgs--;
 			mutex_unlock(&fh->lock);
+			/* restore original timeout value */
+			msg->timeout = timeout;
 			return 0;
 		}
 
-- 
2.8.1

