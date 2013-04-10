Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3154 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab3DJLP6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 07:15:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/2] dt3155v4l: fix incorrect mutex locking.
Date: Wed, 10 Apr 2013 13:15:46 +0200
Message-Id: <1365592547-21951-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365592547-21951-1-git-send-email-hverkuil@xs4all.nl>
References: <1365592547-21951-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

A mutex_unlock was missing in the 'success' path of the open() call,
and also at one error path in the same function.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index 073b3b3..57fadea 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -398,7 +398,7 @@ dt3155_open(struct file *filp)
 		pd->field_count = 0;
 		ret = vb2_queue_init(pd->q);
 		if (ret < 0)
-			return ret;
+			goto err_request_irq;
 		INIT_LIST_HEAD(&pd->dmaq);
 		spin_lock_init(&pd->lock);
 		/* disable all irqs, clear all irq flags */
@@ -410,6 +410,7 @@ dt3155_open(struct file *filp)
 			goto err_request_irq;
 	}
 	pd->users++;
+	mutex_unlock(&pd->mux);
 	return 0; /* success */
 err_request_irq:
 	kfree(pd->q);
-- 
1.7.10.4

