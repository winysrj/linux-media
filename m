Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49323 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab0KQFVF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 00:21:05 -0500
Date: Wed, 17 Nov 2010 08:20:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jarod Wilson <jarod@redhat.com>,
	Zimny Lech <napohybelskurwysynom2010@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 3/3] [media] lirc_dev: fixes in lirc_dev_fop_read()
Message-ID: <20101117052015.GF31724@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This makes several changes but they're in one function and sort of
related:

"buf" was leaked on error.  The leak if we try to read an invalid
length is the main concern because it could be triggered over and
over.

If the copy_to_user() failed, then the original code returned the 
number of bytes remaining.  read() is supposed to be the opposite way,
where we return the number of bytes copied.  I changed it to just return
-EFAULT on errors.

Also I changed the debug output from "-EFAULT" to just "<fail>" because
it isn't -EFAULT necessarily.  And since we go though that path if the
length is invalid now, there was another debug print that I removed.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
index fbca94f..6b9fc74 100644
--- a/drivers/media/IR/lirc_dev.c
+++ b/drivers/media/IR/lirc_dev.c
@@ -647,18 +647,18 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	if (mutex_lock_interruptible(&ir->irctl_lock))
-		return -ERESTARTSYS;
+	if (mutex_lock_interruptible(&ir->irctl_lock)) {
+		ret = -ERESTARTSYS;
+		goto out_unlocked;
+	}
 	if (!ir->attached) {
-		mutex_unlock(&ir->irctl_lock);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto out_locked;
 	}
 
 	if (length % ir->chunk_size) {
-		dev_dbg(ir->d.dev, LOGHEAD "read result = -EINVAL\n",
-			ir->d.name, ir->d.minor);
-		mutex_unlock(&ir->irctl_lock);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_locked;
 	}
 
 	/*
@@ -709,18 +709,23 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			lirc_buffer_read(ir->buf, buf);
 			ret = copy_to_user((void *)buffer+written, buf,
 					   ir->buf->chunk_size);
-			written += ir->buf->chunk_size;
+			if (!ret)
+				written += ir->buf->chunk_size;
+			else
+				ret = -EFAULT;
 		}
 	}
 
 	remove_wait_queue(&ir->buf->wait_poll, &wait);
 	set_current_state(TASK_RUNNING);
+
+out_locked:
 	mutex_unlock(&ir->irctl_lock);
 
 out_unlocked:
 	kfree(buf);
 	dev_dbg(ir->d.dev, LOGHEAD "read result = %s (%d)\n",
-		ir->d.name, ir->d.minor, ret ? "-EFAULT" : "OK", ret);
+		ir->d.name, ir->d.minor, ret ? "<fail>" : "<ok>", ret);
 
 	return ret ? ret : written;
 }
