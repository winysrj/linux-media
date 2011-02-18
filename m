Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:28760 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581Ab1BRBQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:16:42 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1Gdse018942
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:16:39 GMT
Subject: [PATCH 06/13] lirc_zilog: Don't acquire the rx->buf_lock in the
 poll() function
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:16:52 -0500
Message-ID: <1297991812.9399.22.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


There is no need to take the rx->buf_lock in the the poll() function
as all the underling calls made on objects in the rx->buf lirc_buffer object
are protected by spinlocks.

Corrected a bad error return value in poll(): return POLLERR instead
of -ENODEV.

Added some comments to poll() for when, in the future, I forget what
poll() and poll_wait() are supposed to do.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 720ef67..dfa6a42 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -985,19 +985,26 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	unsigned int ret;
 
 	dprintk("poll called\n");
-	if (rx == NULL)
-		return -ENODEV;
 
-	mutex_lock(&rx->buf_lock);
+	if (rx == NULL) {
+		/*
+		 * Revisit this, if our poll function ever reports writeable
+		 * status for Tx
+		 */
+		dprintk("poll result = POLLERR\n");
+		return POLLERR;
+	}
 
+	/*
+	 * Add our lirc_buffer's wait_queue to the poll_table. A wake up on
+	 * that buffer's wait queue indicates we may have a new poll status.
+	 */
 	poll_wait(filep, &rx->buf.wait_poll, wait);
 
-	dprintk("poll result = %s\n",
-		lirc_buffer_empty(&rx->buf) ? "0" : "POLLIN|POLLRDNORM");
-
+	/* Indicate what ops could happen immediately without blocking */
 	ret = lirc_buffer_empty(&rx->buf) ? 0 : (POLLIN|POLLRDNORM);
 
-	mutex_unlock(&rx->buf_lock);
+	dprintk("poll result = %s\n", ret ? "POLLIN|POLLRDNORM" : 0);
 	return ret;
 }
 
-- 
1.7.2.1



