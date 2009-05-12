Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbZELVBP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2009 17:01:15 -0400
Message-Id: <200905122058.n4CKwiCm004396@imap1.linux-foundation.org>
Subject: [patch 3/4] dvb-core: fix potential mutex_unlock without mutex_lock in dvb_dvr_read
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	simon@fire.lp0.eu
From: akpm@linux-foundation.org
Date: Tue, 12 May 2009 13:39:28 -0700
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Simon Arlott <simon@fire.lp0.eu>

dvb_dvr_read may unlock the dmxdev mutex and return -ENODEV, except this
function is a file op and will never be called with the mutex held.

There's existing mutex_lock and mutex_unlock around the actual read but
it's commented out.  These should probably be uncommented but the read
blocks and this could block another non-blocking reader on the mutex
instead.

This change comments out the extra mutex_unlock.

[akpm@linux-foundation.org: cleanups, simplification]
Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/dvb-core/dmxdev.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff -puN drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read drivers/media/dvb/dvb-core/dmxdev.c
--- a/drivers/media/dvb/dvb-core/dmxdev.c~dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read
+++ a/drivers/media/dvb/dvb-core/dmxdev.c
@@ -244,19 +244,13 @@ static ssize_t dvb_dvr_read(struct file 
 {
 	struct dvb_device *dvbdev = file->private_data;
 	struct dmxdev *dmxdev = dvbdev->priv;
-	int ret;
 
-	if (dmxdev->exit) {
-		mutex_unlock(&dmxdev->mutex);
+	if (dmxdev->exit)
 		return -ENODEV;
-	}
 
-	//mutex_lock(&dmxdev->mutex);
-	ret = dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
-				     file->f_flags & O_NONBLOCK,
-				     buf, count, ppos);
-	//mutex_unlock(&dmxdev->mutex);
-	return ret;
+	return dvb_dmxdev_buffer_read(&dmxdev->dvr_buffer,
+				      file->f_flags & O_NONBLOCK,
+				      buf, count, ppos);
 }
 
 static int dvb_dvr_set_buffer_size(struct dmxdev *dmxdev,
_
