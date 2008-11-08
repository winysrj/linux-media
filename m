Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA8Iij2X014532
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 13:44:45 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mA8IiUFR015205
	for <video4linux-list@redhat.com>; Sat, 8 Nov 2008 13:44:30 -0500
Date: Sat, 8 Nov 2008 19:44:43 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0811081916170.8956@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: 
Subject: [PATCH 2/3] soc-camera: formatting fixes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Minor formatting fixes

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index f406042..2d1f474 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -35,8 +35,8 @@ static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);
 static DEFINE_MUTEX(video_lock);
 
-const static struct soc_camera_data_format*
-format_by_fourcc(struct soc_camera_device *icd, unsigned int fourcc)
+const static struct soc_camera_data_format *format_by_fourcc(
+	struct soc_camera_device *icd, unsigned int fourcc)
 {
 	unsigned int i;
 
@@ -47,7 +47,7 @@ format_by_fourcc(struct soc_camera_device *icd, unsigned int fourcc)
 }
 
 static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
-				  struct v4l2_format *f)
+				      struct v4l2_format *f)
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
@@ -260,7 +260,7 @@ static int soc_camera_close(struct inode *inode, struct file *file)
 }
 
 static ssize_t soc_camera_read(struct file *file, char __user *buf,
-			   size_t count, loff_t *ppos)
+			       size_t count, loff_t *ppos)
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
@@ -305,7 +305,6 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 	return ici->ops->poll(file, pt);
 }
 
-
 static struct file_operations soc_camera_fops = {
 	.owner		= THIS_MODULE,
 	.open		= soc_camera_open,
@@ -317,9 +316,8 @@ static struct file_operations soc_camera_fops = {
 	.llseek		= no_llseek,
 };
 
-
 static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
+				    struct v4l2_format *f)
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
@@ -366,7 +364,7 @@ static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 }
 
 static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
-				   struct v4l2_fmtdesc *f)
+				       struct v4l2_fmtdesc *f)
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
@@ -385,7 +383,7 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 }
 
 static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
-				struct v4l2_format *f)
+				    struct v4l2_format *f)
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-- 
1.5.4

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
