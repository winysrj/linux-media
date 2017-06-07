Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:50105 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751817AbdFGRpd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 13:45:33 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for 4.12] cec: race fix: don't return -ENONET in cec_receive()
Message-ID: <c468850e-262e-6131-e182-761bb9b4b4bf@xs4all.nl>
Date: Wed, 7 Jun 2017 19:45:26 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When calling CEC_RECEIVE do not check if the adapter is configured.
Typically CEC_RECEIVE is called after a select() and if that indicates
that there are messages in the receive queue, then you should always be
able to dequeue a message.

The race condition here is that a message has been received and is
queued, so select() tells userspace that a message is available. But
before the application calls CEC_RECEIVE the adapter is unconfigured
(e.g. the HDMI cable is removed). Now select will always report that
there is a message, but calling CEC_RECEIVE will always return -ENONET
because the adapter is no longer configured and so will never actually
dequeue the message.

There is really no need for this check, and in fact the ENONET error
code was never documented for CEC_RECEIVE. This may have been a left-over
of old code that was never updated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v4.10 and up
---
 drivers/media/cec/cec-api.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 1359c3977101..f7eb4c54a354 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -272,16 +272,10 @@ static long cec_receive(struct cec_adapter *adap, struct cec_fh *fh,
 			bool block, struct cec_msg __user *parg)
 {
 	struct cec_msg msg = {};
-	long err = 0;
+	long err;

 	if (copy_from_user(&msg, parg, sizeof(msg)))
 		return -EFAULT;
-	mutex_lock(&adap->lock);
-	if (!adap->is_configured && fh->mode_follower < CEC_MODE_MONITOR)
-		err = -ENONET;
-	mutex_unlock(&adap->lock);
-	if (err)
-		return err;

 	err = cec_receive_msg(fh, &msg, block);
 	if (err)
-- 
2.11.0
