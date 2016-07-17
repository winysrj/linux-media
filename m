Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:60319 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbcGQPCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:02:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/7] cec: don't set fh to NULL in CEC_TRANSMIT
Date: Sun, 17 Jul 2016 17:02:30 +0200
Message-Id: <1468767754-48542-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
References: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The filehandle was set to NULL when in non-blocking mode or when
no reply is needed.

This is wrong: the filehandle is needed in non-blocking mode to ensure
that the result of the transmit can be obtained through CEC_RECEIVE.

And the 'reply' check was also incorrect since it should have checked the
timeout field (the reply can be 0). In any case, when in blocking mode
there is no need to set the fh to NULL either.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-api.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 879f7d9..559f650 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -189,15 +189,12 @@ static long cec_transmit(struct cec_adapter *adap, struct cec_fh *fh,
 	if (copy_from_user(&msg, parg, sizeof(msg)))
 		return -EFAULT;
 	mutex_lock(&adap->lock);
-	if (!adap->is_configured) {
+	if (!adap->is_configured)
 		err = -ENONET;
-	} else if (cec_is_busy(adap, fh)) {
+	else if (cec_is_busy(adap, fh))
 		err = -EBUSY;
-	} else {
-		if (!block || !msg.reply)
-			fh = NULL;
+	else
 		err = cec_transmit_msg_fh(adap, &msg, fh, block);
-	}
 	mutex_unlock(&adap->lock);
 	if (err)
 		return err;
-- 
2.8.1

