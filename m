Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483Ab3CSRBq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 13:01:46 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 38/46] [media] siano: add support for .poll on debugfs
Date: Tue, 19 Mar 2013 13:49:27 -0300
Message-Id: <1363711775-2120-39-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement poll() method for debugfs and be sure that the
debug_data won't be freed on ir or on read().

With this change, poll() will return POLLIN if either data was
filled or if data was read. That allows read() to return 0
to indicate EOF in the latter case.

As poll() is now provided, fix support for non-block mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/smsdvb-debugfs.c | 77 ++++++++++++++++++++++-------
 1 file changed, 59 insertions(+), 18 deletions(-)

diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 59c7323..0219be3 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -352,6 +352,14 @@ static int smsdvb_stats_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static void smsdvb_debugfs_data_release(struct kref *ref)
+{
+	struct smsdvb_debugfs *debug_data;
+
+	debug_data = container_of(ref, struct smsdvb_debugfs, refcount);
+	kfree(debug_data);
+}
+
 static int smsdvb_stats_wait_read(struct smsdvb_debugfs *debug_data)
 {
 	int rc = 1;
@@ -368,33 +376,65 @@ exit:
 	return rc;
 }
 
-static ssize_t smsdvb_stats_read(struct file *file, char __user *user_buf,
-				      size_t nbytes, loff_t *ppos)
+static unsigned int smsdvb_stats_poll(struct file *file, poll_table *wait)
 {
-	int rc = 0;
 	struct smsdvb_debugfs *debug_data = file->private_data;
+	int rc;
 
-	rc = wait_event_interruptible(debug_data->stats_queue,
-				      smsdvb_stats_wait_read(debug_data));
-	if (rc < 0)
-		return rc;
+	kref_get(&debug_data->refcount);
 
-	rc = simple_read_from_buffer(user_buf, nbytes, ppos,
-				     debug_data->stats_data,
-				     debug_data->stats_count);
-	spin_lock(&debug_data->lock);
-	debug_data->stats_was_read = true;
-	spin_unlock(&debug_data->lock);
+	poll_wait(file, &debug_data->stats_queue, wait);
+
+	rc = smsdvb_stats_wait_read(debug_data);
+	if (rc > 0)
+		rc = POLLIN | POLLRDNORM;
+
+	kref_put(&debug_data->refcount, smsdvb_debugfs_data_release);
 
 	return rc;
 }
 
-static void smsdvb_debugfs_data_release(struct kref *ref)
+static ssize_t smsdvb_stats_read(struct file *file, char __user *user_buf,
+				      size_t nbytes, loff_t *ppos)
 {
-	struct smsdvb_debugfs *debug_data;
+	int rc = 0, len;
+	struct smsdvb_debugfs *debug_data = file->private_data;
 
-	debug_data = container_of(ref, struct smsdvb_debugfs, refcount);
-	kfree(debug_data);
+	kref_get(&debug_data->refcount);
+
+	if (file->f_flags & O_NONBLOCK) {
+		rc = smsdvb_stats_wait_read(debug_data);
+		if (!rc) {
+			rc = -EWOULDBLOCK;
+			goto ret;
+		}
+	} else {
+		rc = wait_event_interruptible(debug_data->stats_queue,
+				      smsdvb_stats_wait_read(debug_data));
+		if (rc < 0)
+			goto ret;
+	}
+
+	if (debug_data->stats_was_read) {
+		rc = 0;	/* EOF */
+		goto ret;
+	}
+
+	len = debug_data->stats_count - *ppos;
+	if (len >= 0)
+		rc = simple_read_from_buffer(user_buf, nbytes, ppos,
+					     debug_data->stats_data, len);
+	else
+		rc = 0;
+
+	if (*ppos >= debug_data->stats_count) {
+		spin_lock(&debug_data->lock);
+		debug_data->stats_was_read = true;
+		spin_unlock(&debug_data->lock);
+	}
+ret:
+	kref_put(&debug_data->refcount, smsdvb_debugfs_data_release);
+	return rc;
 }
 
 static int smsdvb_stats_release(struct inode *inode, struct file *file)
@@ -402,7 +442,7 @@ static int smsdvb_stats_release(struct inode *inode, struct file *file)
 	struct smsdvb_debugfs *debug_data = file->private_data;
 
 	spin_lock(&debug_data->lock);
-	debug_data->stats_was_read = true;
+	debug_data->stats_was_read = true;	/* return EOF to read() */
 	spin_unlock(&debug_data->lock);
 	wake_up_interruptible_sync(&debug_data->stats_queue);
 
@@ -414,6 +454,7 @@ static int smsdvb_stats_release(struct inode *inode, struct file *file)
 
 static const struct file_operations debugfs_stats_ops = {
 	.open = smsdvb_stats_open,
+	.poll = smsdvb_stats_poll,
 	.read = smsdvb_stats_read,
 	.release = smsdvb_stats_release,
 	.llseek = generic_file_llseek,
-- 
1.8.1.4

