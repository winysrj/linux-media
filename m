Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4714 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab2EKHz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 10/16] saa7146: remove the unneeded type field from saa7146_fh
Date: Fri, 11 May 2012 09:55:04 +0200
Message-Id: <58547f483de54776dd1a8daba3572fa082d3132f.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This information can also be retrieved from struct video_device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c |   30 +++++++++++++++++-------------
 include/media/saa7146_vv.h          |    2 --
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index db724a9..2ea67da 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -229,9 +229,8 @@ static int fops_open(struct file *file)
 
 	file->private_data = fh;
 	fh->dev = dev;
-	fh->type = type;
 
-	if( fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
+	if (vdev->vfl_type == VFL_TYPE_VBI) {
 		DEB_S("initializing vbi...\n");
 		if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
 			result = saa7146_vbi_uops.open(dev,file);
@@ -263,6 +262,7 @@ out:
 
 static int fops_release(struct file *file)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh  *fh  = file->private_data;
 	struct saa7146_dev *dev = fh->dev;
 
@@ -271,7 +271,7 @@ static int fops_release(struct file *file)
 	if (mutex_lock_interruptible(&saa7146_devices_lock))
 		return -ERESTARTSYS;
 
-	if( fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
+	if (vdev->vfl_type == VFL_TYPE_VBI) {
 		if (dev->ext_vv_data->capabilities & V4L2_CAP_VBI_CAPTURE)
 			saa7146_vbi_uops.release(dev,file);
 		if (dev->ext_vv_data->vbi_fops.release)
@@ -291,17 +291,18 @@ static int fops_release(struct file *file)
 
 static int fops_mmap(struct file *file, struct vm_area_struct * vma)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh *fh = file->private_data;
 	struct videobuf_queue *q;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE: {
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER: {
 		DEB_EE("V4L2_BUF_TYPE_VIDEO_CAPTURE: file:%p, vma:%p\n",
 		       file, vma);
 		q = &fh->video_q;
 		break;
 		}
-	case V4L2_BUF_TYPE_VBI_CAPTURE: {
+	case VFL_TYPE_VBI: {
 		DEB_EE("V4L2_BUF_TYPE_VBI_CAPTURE: file:%p, vma:%p\n",
 		       file, vma);
 		q = &fh->vbi_q;
@@ -317,13 +318,14 @@ static int fops_mmap(struct file *file, struct vm_area_struct * vma)
 
 static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh *fh = file->private_data;
 	struct videobuf_buffer *buf = NULL;
 	struct videobuf_queue *q;
 
 	DEB_EE("file:%p, poll:%p\n", file, wait);
 
-	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
+	if (vdev->vfl_type == VFL_TYPE_VBI) {
 		if( 0 == fh->vbi_q.streaming )
 			return videobuf_poll_stream(file, &fh->vbi_q, wait);
 		q = &fh->vbi_q;
@@ -352,16 +354,17 @@ static unsigned int fops_poll(struct file *file, struct poll_table_struct *wait)
 
 static ssize_t fops_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh *fh = file->private_data;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 /*
 		DEB_EE("V4L2_BUF_TYPE_VIDEO_CAPTURE: file:%p, data:%p, count:%lun",
 		       file, data, (unsigned long)count);
 */
 		return saa7146_video_uops.read(file,data,count,ppos);
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 /*
 		DEB_EE("V4L2_BUF_TYPE_VBI_CAPTURE: file:%p, data:%p, count:%lu\n",
 		       file, data, (unsigned long)count);
@@ -377,12 +380,13 @@ static ssize_t fops_read(struct file *file, char __user *data, size_t count, lof
 
 static ssize_t fops_write(struct file *file, const char __user *data, size_t count, loff_t *ppos)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7146_fh *fh = file->private_data;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 		return -EINVAL;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 		if (fh->dev->ext_vv_data->vbi_fops.write)
 			return fh->dev->ext_vv_data->vbi_fops.write(file, data, count, ppos);
 		else
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index 658ae83..e9f434c 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -85,8 +85,6 @@ struct saa7146_overlay {
 /* per open data */
 struct saa7146_fh {
 	struct saa7146_dev	*dev;
-	/* if this is a vbi or capture open */
-	enum v4l2_buf_type	type;
 
 	/* video capture */
 	struct videobuf_queue	video_q;
-- 
1.7.10

