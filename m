Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54406 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0G0Sms (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jul 2010 14:42:48 -0400
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Roel Kluin <roel.kluin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] dvb: siano: free spinlock before schedule()
Date: Tue, 27 Jul 2010 22:42:40 +0400
Message-Id: <1280256161-7971-1-git-send-email-segooon@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calling schedule() holding spinlock with disables irqs is improper. As
spinlock protects list coredev->buffers, it can be unlocked untill wakeup.
This bug was introduced in a9349315f65cd6a16e8fab1f6cf0fd40f379c4db.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/media/dvb/siano/smscoreapi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index 7f2c94a..d93468c 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -1113,9 +1113,11 @@ struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
 	 */
 
 	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
-
-	if (list_empty(&coredev->buffers))
+	if (list_empty(&coredev->buffers)) {
+		spin_unlock_irqrestore(&coredev->bufferslock, flags);
 		schedule();
+		spin_lock_irqsave(&coredev->bufferslock, flags);
+	}
 
 	finish_wait(&coredev->buffer_mng_waitq, &wait);
 
-- 
1.7.0.4

