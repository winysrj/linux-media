Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34356 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754407AbcEaOLv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 10:11:51 -0400
Received: from [64.103.36.133] (proxy-ams-1.cisco.com [64.103.36.133])
	by tschai.lan (Postfix) with ESMTPSA id 1E07B180068
	for <linux-media@vger.kernel.org>; Tue, 31 May 2016 16:11:45 +0200 (CEST)
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: fix comment and inverted condition
Message-ID: <574D9B9F.1000000@xs4all.nl>
Date: Tue, 31 May 2016 16:11:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The inverted condition caused received events to be replied to with
Feature Abort, even though they were the reply to an earlier transmit
that the caller was waiting for and so they would be processed and
Feature Abort was inappropriate.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---

This patch sits on top of the CEC pull request.
---
diff --git a/drivers/staging/media/cec/cec.c b/drivers/staging/media/cec/cec.c
index c2a876e..65a3cb3 100644
--- a/drivers/staging/media/cec/cec.c
+++ b/drivers/staging/media/cec/cec.c
@@ -1143,13 +1143,13 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	}

 skip_processing:
-	/* If this was not a reply, then we're done */
+	/* If this was a reply, then we're done */
 	if (is_reply)
 		return 0;

 	/*
 	 * Send to the exclusive follower if there is one, otherwise send
-	 * to all followerd.
+	 * to all followers.
 	 */
 	if (adap->cec_follower)
 		cec_queue_msg_fh(adap->cec_follower, msg);
@@ -1791,7 +1791,7 @@ static long cec_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
 		} else if (cec_is_busy(adap, fh)) {
 			err = -EBUSY;
 		} else {
-			if (block || !msg.reply)
+			if (!block || !msg.reply)
 				fh = NULL;
 			err = cec_transmit_msg_fh(adap, &msg, fh, block);
 		}
