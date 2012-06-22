Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2214 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846Ab2FVMV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 08:21:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 19/34] v4l2-dev.c: add debug sysfs entry.
Date: Fri, 22 Jun 2012 14:21:13 +0200
Message-Id: <a497cef0c59c8872218faa5d83095fe03c01a430.1340366355.git.hans.verkuil@cisco.com>
In-Reply-To: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
References: <1340367688-8722-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
References: <1cee710ae251aa69bed8e563a94b419ed99bc41a.1340366355.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since this could theoretically change the debug value while in the middle
of v4l2-ioctl.c, we make a copy of vfd->debug to ensure consistent debug
behavior.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/v4l2-dev.c   |   24 ++++++++++++++++++++++++
 drivers/media/video/v4l2-ioctl.c |    9 +++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 1500208..5c0bb18 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -46,6 +46,29 @@ static ssize_t show_index(struct device *cd,
 	return sprintf(buf, "%i\n", vdev->index);
 }
 
+static ssize_t show_debug(struct device *cd,
+			 struct device_attribute *attr, char *buf)
+{
+	struct video_device *vdev = to_video_device(cd);
+
+	return sprintf(buf, "%i\n", vdev->debug);
+}
+
+static ssize_t set_debug(struct device *cd, struct device_attribute *attr,
+		   const char *buf, size_t len)
+{
+	struct video_device *vdev = to_video_device(cd);
+	int res = 0;
+	u16 value;
+
+	res = kstrtou16(buf, 0, &value);
+	if (res)
+		return res;
+
+	vdev->debug = value;
+	return len;
+}
+
 static ssize_t show_name(struct device *cd,
 			 struct device_attribute *attr, char *buf)
 {
@@ -56,6 +79,7 @@ static ssize_t show_name(struct device *cd,
 
 static struct device_attribute video_device_attrs[] = {
 	__ATTR(name, S_IRUGO, show_name, NULL),
+	__ATTR(debug, 0644, show_debug, set_debug),
 	__ATTR(index, S_IRUGO, show_index, NULL),
 	__ATTR_NULL
 };
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 0531d9a..2e1421b 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1998,6 +1998,7 @@ static long __video_do_ioctl(struct file *file,
 	void *fh = file->private_data;
 	struct v4l2_fh *vfh = NULL;
 	int use_fh_prio = 0;
+	int debug = vfd->debug;
 	long ret = -ENOTTY;
 
 	if (ops == NULL) {
@@ -2031,7 +2032,7 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 	write_only = _IOC_DIR(cmd) == _IOC_WRITE;
-	if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
+	if (write_only && debug > V4L2_DEBUG_IOCTL) {
 		v4l_print_ioctl(vfd->name, cmd);
 		pr_cont(": ");
 		info->debug(arg, write_only);
@@ -2053,8 +2054,8 @@ static long __video_do_ioctl(struct file *file,
 	}
 
 done:
-	if (vfd->debug) {
-		if (write_only && vfd->debug > V4L2_DEBUG_IOCTL) {
+	if (debug) {
+		if (write_only && debug > V4L2_DEBUG_IOCTL) {
 			if (ret < 0)
 				printk(KERN_DEBUG "%s: error %ld\n",
 					video_device_node_name(vfd), ret);
@@ -2063,7 +2064,7 @@ done:
 		v4l_print_ioctl(vfd->name, cmd);
 		if (ret < 0)
 			pr_cont(": error %ld\n", ret);
-		else if (vfd->debug == V4L2_DEBUG_IOCTL)
+		else if (debug == V4L2_DEBUG_IOCTL)
 			pr_cont("\n");
 		else if (_IOC_DIR(cmd) == _IOC_NONE)
 			info->debug(arg, write_only);
-- 
1.7.10

