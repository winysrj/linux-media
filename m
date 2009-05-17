Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110813.mail.gq1.yahoo.com ([67.195.13.236]:34240 "HELO
	web110813.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753426AbZEQI7g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 04:59:36 -0400
Message-ID: <169030.30544.qm@web110813.mail.gq1.yahoo.com>
Date: Sun, 17 May 2009 01:59:37 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0905_24] Siano: smscore - fix get_common_buffer bug
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242331867 -10800
# Node ID fc839f80e81fed027a4721f5c679b9af7e27c867
# Parent  415ca02f74b960c02ddfa7ee719cf87726d97490
[0905_24] Siano: smscore - fix get_common_buffer bug

From: Uri Shkolnik <uris@siano-ms.com>

get common buffers() should block operation until valid buffer
is avaliable.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 415ca02f74b9 -r fc839f80e81f linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 23:02:05 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Thu May 14 23:11:07 2009 +0300
@@ -30,6 +30,7 @@
 #include <linux/io.h>
 
 #include <linux/firmware.h>
+#include <linux/wait.h>
 
 #include "smscoreapi.h"
 #include "smsendian.h"
@@ -356,6 +357,9 @@ int smscore_register_device(struct smsde
 	init_completion(&dev->gpio_set_level_done);
 	init_completion(&dev->gpio_get_level_done);
 	init_completion(&dev->ir_init_done);
+
+	/* Buffer management */
+	init_waitqueue_head(&dev->buffer_mng_waitq);
 
 	/* alloc common buffer */
 	dev->common_buffer_size = params->buffer_size * params->num_buffers;
@@ -694,7 +698,9 @@ void smscore_unregister_device(struct sm
 	 * onresponse must no longer be called */
 
 	while (1) {
-		while ((cb = smscore_getbuffer(coredev))) {
+		while (!list_empty(&coredev->buffers)) {
+			cb = (struct smscore_buffer_t *) coredev->buffers.next;
+			list_del(&cb->entry);
 			kfree(cb);
 			num_buffers++;
 		}
@@ -715,8 +721,10 @@ void smscore_unregister_device(struct sm
 
 	if (coredev->common_buffer)
 		dma_free_coherent(NULL, coredev->common_buffer_size,
-				  coredev->common_buffer,
-				  coredev->common_buffer_phys);
+			coredev->common_buffer, coredev->common_buffer_phys);
+
+	if (coredev->fw_buf != NULL)
+		kfree(coredev->fw_buf);
 
 	list_del(&coredev->entry);
 	kfree(coredev);
@@ -1105,12 +1113,24 @@ struct smscore_buffer_t *smscore_getbuff
 	struct smscore_buffer_t *cb = NULL;
 	unsigned long flags;
 
+	DEFINE_WAIT(wait);
+
 	spin_lock_irqsave(&coredev->bufferslock, flags);
 
-	if (!list_empty(&coredev->buffers)) {
-		cb = (struct smscore_buffer_t *) coredev->buffers.next;
-		list_del(&cb->entry);
-	}
+	/* This function must return a valid buffer, since the buffer list is
+	 * finite, we check that there is an available buffer, if not, we wait
+	 * until such buffer become available.
+	 */
+
+	prepare_to_wait(&coredev->buffer_mng_waitq, &wait, TASK_INTERRUPTIBLE);
+
+	if (list_empty(&coredev->buffers))
+		schedule();
+
+	finish_wait(&coredev->buffer_mng_waitq, &wait);
+
+	cb = (struct smscore_buffer_t *) coredev->buffers.next;
+	list_del(&cb->entry);
 
 	spin_unlock_irqrestore(&coredev->bufferslock, flags);
 
@@ -1127,8 +1147,8 @@ EXPORT_SYMBOL_GPL(smscore_getbuffer);
  *
  */
 void smscore_putbuffer(struct smscore_device_t *coredev,
-		       struct smscore_buffer_t *cb)
-{
+		struct smscore_buffer_t *cb) {
+	wake_up_interruptible(&coredev->buffer_mng_waitq);
 	list_add_locked(&cb->entry, &coredev->buffers, &coredev->bufferslock);
 }
 EXPORT_SYMBOL_GPL(smscore_putbuffer);



      
