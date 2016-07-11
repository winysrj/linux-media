Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:56276 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932328AbcGKIwk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 04:52:40 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id D586718013E
	for <linux-media@vger.kernel.org>; Mon, 11 Jul 2016 10:52:34 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: CEC_RECEIVE is allowed in monitor mode
Message-ID: <10844873-225e-046b-4332-28c94b7b36cb@xs4all.nl>
Date: Mon, 11 Jul 2016 10:52:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the device is in monitor mode, then you should always be able to
call CEC_RECEIVE, even if the device is unconfigured.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/cec/cec-api.c b/drivers/staging/media/cec/cec-api.c
index d7cba7a..9151b1f 100644
--- a/drivers/staging/media/cec/cec-api.c
+++ b/drivers/staging/media/cec/cec-api.c
@@ -263,7 +263,7 @@ static long cec_receive(struct cec_adapter *adap, struct cec_fh *fh,
 	if (copy_from_user(&msg, parg, sizeof(msg)))
 		return -EFAULT;
 	mutex_lock(&adap->lock);
-	if (!adap->is_configured)
+	if (!adap->is_configured && fh->mode_follower < CEC_MODE_MONITOR)
 		err = -ENONET;
 	mutex_unlock(&adap->lock);
 	if (err)
-- 
2.8.1

