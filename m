Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4139 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab3LNL3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:29:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 14/15] saa6588: add support for non-blocking mode.
Date: Sat, 14 Dec 2013 12:28:36 +0100
Message-Id: <1387020517-26242-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
References: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

saa6588 always blocked while waiting for data, even if the filehandle
was in non-blocking mode.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa6588.c               | 45 +++++++++++++++++--------------
 drivers/media/pci/bt8xx/bttv-driver.c     |  4 ++-
 drivers/media/pci/saa7134/saa7134-video.c |  1 +
 include/media/saa6588.h                   |  1 +
 4 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index 21cf940..2960b5a 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -150,14 +150,14 @@ static inline struct saa6588 *to_saa6588(struct v4l2_subdev *sd)
 
 /* ---------------------------------------------------------------------- */
 
-static int block_to_user_buf(struct saa6588 *s, unsigned char __user *user_buf)
+static bool block_from_buf(struct saa6588 *s, unsigned char *buf)
 {
 	int i;
 
 	if (s->rd_index == s->wr_index) {
 		if (debug > 2)
 			dprintk(PREFIX "Read: buffer empty.\n");
-		return 0;
+		return false;
 	}
 
 	if (debug > 2) {
@@ -166,8 +166,7 @@ static int block_to_user_buf(struct saa6588 *s, unsigned char __user *user_buf)
 			dprintk("0x%02x ", s->buffer[i]);
 	}
 
-	if (copy_to_user(user_buf, &s->buffer[s->rd_index], 3))
-		return -EFAULT;
+	memcpy(buf, &s->buffer[s->rd_index], 3);
 
 	s->rd_index += 3;
 	if (s->rd_index >= s->buf_size)
@@ -177,22 +176,22 @@ static int block_to_user_buf(struct saa6588 *s, unsigned char __user *user_buf)
 	if (debug > 2)
 		dprintk("%d blocks total.\n", s->block_count);
 
-	return 1;
+	return true;
 }
 
 static void read_from_buf(struct saa6588 *s, struct saa6588_command *a)
 {
-	unsigned long flags;
-
 	unsigned char __user *buf_ptr = a->buffer;
-	unsigned int i;
+	unsigned char buf[3];
+	unsigned long flags;
 	unsigned int rd_blocks;
+	unsigned int i;
 
 	a->result = 0;
 	if (!a->buffer)
 		return;
 
-	while (!s->data_available_for_read) {
+	while (!a->nonblocking && !s->data_available_for_read) {
 		int ret = wait_event_interruptible(s->read_queue,
 					     s->data_available_for_read);
 		if (ret == -ERESTARTSYS) {
@@ -201,24 +200,31 @@ static void read_from_buf(struct saa6588 *s, struct saa6588_command *a)
 		}
 	}
 
-	spin_lock_irqsave(&s->lock, flags);
 	rd_blocks = a->block_count;
+	spin_lock_irqsave(&s->lock, flags);
 	if (rd_blocks > s->block_count)
 		rd_blocks = s->block_count;
+	spin_unlock_irqrestore(&s->lock, flags);
 
-	if (!rd_blocks) {
-		spin_unlock_irqrestore(&s->lock, flags);
+	if (!rd_blocks)
 		return;
-	}
 
 	for (i = 0; i < rd_blocks; i++) {
-		if (block_to_user_buf(s, buf_ptr)) {
-			buf_ptr += 3;
-			a->result++;
-		} else
+		bool got_block;
+
+		spin_lock_irqsave(&s->lock, flags);
+		got_block = block_from_buf(s, buf);
+		spin_unlock_irqrestore(&s->lock, flags);
+		if (!got_block)
 			break;
+		if (copy_to_user(buf_ptr, buf, 3)) {
+			a->result = -EFAULT;
+			return;
+		}
+		buf_ptr += 3;
+		a->result += 3;
 	}
-	a->result *= 3;
+	spin_lock_irqsave(&s->lock, flags);
 	s->data_available_for_read = (s->block_count > 0);
 	spin_unlock_irqrestore(&s->lock, flags);
 }
@@ -408,9 +414,8 @@ static long saa6588_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 		/* --- poll() for /dev/radio --- */
 	case SAA6588_CMD_POLL:
 		a->result = 0;
-		if (s->data_available_for_read) {
+		if (s->data_available_for_read)
 			a->result |= POLLIN | POLLRDNORM;
-		}
 		poll_wait(a->instance, &s->read_queue, a->event_list);
 		break;
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 92a06fd..c2aaadc 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3266,7 +3266,9 @@ static ssize_t radio_read(struct file *file, char __user *data,
 	struct bttv_fh *fh = file->private_data;
 	struct bttv *btv = fh->btv;
 	struct saa6588_command cmd;
-	cmd.block_count = count/3;
+
+	cmd.block_count = count / 3;
+	cmd.nonblocking = file->f_flags & O_NONBLOCK;
 	cmd.buffer = data;
 	cmd.instance = file;
 	cmd.result = -ENODEV;
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 88e6405..36026b1 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1285,6 +1285,7 @@ static ssize_t radio_read(struct file *file, char __user *data,
 	struct saa6588_command cmd;
 
 	cmd.block_count = count/3;
+	cmd.nonblocking = file->f_flags & O_NONBLOCK;
 	cmd.buffer = data;
 	cmd.instance = file;
 	cmd.result = -ENODEV;
diff --git a/include/media/saa6588.h b/include/media/saa6588.h
index 1489a52..b5ec1aa 100644
--- a/include/media/saa6588.h
+++ b/include/media/saa6588.h
@@ -27,6 +27,7 @@
 
 struct saa6588_command {
 	unsigned int  block_count;
+	bool          nonblocking;
 	int           result;
 	unsigned char __user *buffer;
 	struct file   *instance;
-- 
1.8.4.3

