Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35983 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbcGQQIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 12:08:41 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id DB628180C37
	for <linux-media@vger.kernel.org>; Sun, 17 Jul 2016 18:08:35 +0200 (CEST)
Subject: [PATCH 8/7] cec: poll should check if there is room in the tx queue
To: linux-media@vger.kernel.org
References: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
 <1468767754-48542-8-git-send-email-hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <821ffc17-452e-21aa-0303-a9328bf5da5f@xs4all.nl>
Date: Sun, 17 Jul 2016 18:08:35 +0200
MIME-Version: 1.0
In-Reply-To: <1468767754-48542-8-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For POLLOUT poll only checked if the adapter was configured, not
if there was room in the transmit queue. Add that check.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index 559f650..7be7615 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -52,7 +52,8 @@ static unsigned int cec_poll(struct file *filp,
 	if (!devnode->registered)
 		return POLLERR | POLLHUP;
 	mutex_lock(&adap->lock);
-	if (adap->is_configured)
+	if (adap->is_configured &&
+	    adap->transmit_queue_sz < CEC_MAX_MSG_TX_QUEUE_SZ)
 		res |= POLLOUT | POLLWRNORM;
 	if (fh->queued_msgs)
 		res |= POLLIN | POLLRDNORM;
-- 
2.8.1
