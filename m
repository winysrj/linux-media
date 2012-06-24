Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3465 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab2FXL3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 07:29:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/26] dt3155v4l: remove V4L2_FL_LOCK_ALL_FOPS
Date: Sun, 24 Jun 2012 13:26:00 +0200
Message-Id: <9d2c4dab5a81cad58d5a7d10df3366854066d423.1340536092.git.hans.verkuil@cisco.com>
In-Reply-To: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
References: <f854d2a0a932187cd895bf9cd81d2da8343b52c9.1340536092.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add proper locking to the file operations, allowing for the removal
of the V4L2_FL_LOCK_ALL_FOPS flag.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/dt3155v4l/dt3155v4l.c |   29 ++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
index c365cdf..f10ac45 100644
--- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
+++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
@@ -381,6 +381,8 @@ dt3155_open(struct file *filp)
 	int ret = 0;
 	struct dt3155_priv *pd = video_drvdata(filp);
 
+	if (mutex_lock_interruptible(&pd->mux))
+		return -ERESTARTSYS;
 	if (!pd->users) {
 		pd->q = kzalloc(sizeof(*pd->q), GFP_KERNEL);
 		if (!pd->q) {
@@ -411,6 +413,7 @@ err_request_irq:
 	kfree(pd->q);
 	pd->q = NULL;
 err_alloc_queue:
+	mutex_unlock(&pd->mux);
 	return ret;
 }
 
@@ -419,6 +422,7 @@ dt3155_release(struct file *filp)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
 
+	mutex_lock(&pd->mux);
 	pd->users--;
 	BUG_ON(pd->users < 0);
 	if (!pd->users) {
@@ -429,6 +433,7 @@ dt3155_release(struct file *filp)
 		kfree(pd->q);
 		pd->q = NULL;
 	}
+	mutex_unlock(&pd->mux);
 	return 0;
 }
 
@@ -436,24 +441,38 @@ static ssize_t
 dt3155_read(struct file *filp, char __user *user, size_t size, loff_t *loff)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
+	ssize_t res;
 
-	return vb2_read(pd->q, user, size, loff, filp->f_flags & O_NONBLOCK);
+	if (mutex_lock_interruptible(&pd->mux))
+		return -ERESTARTSYS;
+	res = vb2_read(pd->q, user, size, loff, filp->f_flags & O_NONBLOCK);
+	mutex_unlock(&pd->mux);
+	return res;
 }
 
 static unsigned int
 dt3155_poll(struct file *filp, struct poll_table_struct *polltbl)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
+	unsigned int res;
 
-	return vb2_poll(pd->q, filp, polltbl);
+	mutex_lock(&pd->mux);
+	res = vb2_poll(pd->q, filp, polltbl);
+	mutex_unlock(&pd->mux);
+	return res;
 }
 
 static int
 dt3155_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	struct dt3155_priv *pd = video_drvdata(filp);
+	int res;
 
-	return vb2_mmap(pd->q, vma);
+	if (mutex_lock_interruptible(&pd->mux))
+		return -ERESTARTSYS;
+	res = vb2_mmap(pd->q, vma);
+	mutex_unlock(&pd->mux);
+	return res;
 }
 
 static const struct v4l2_file_operations dt3155_fops = {
@@ -898,10 +917,6 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&pd->dmaq);
 	mutex_init(&pd->mux);
 	pd->vdev->lock = &pd->mux; /* for locking v4l2_file_operations */
-	/* Locking in file operations other than ioctl should be done
-	   by the driver, not the V4L2 core.
-	   This driver needs auditing so that this flag can be removed. */
-	set_bit(V4L2_FL_LOCK_ALL_FOPS, &pd->vdev->flags);
 	spin_lock_init(&pd->lock);
 	pd->csr2 = csr2_init;
 	pd->config = config_init;
-- 
1.7.10

