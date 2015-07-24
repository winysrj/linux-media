Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:54518 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880AbbGXKXC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 06:23:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 7/7] cpia2/si470x: simplify open
Date: Fri, 24 Jul 2015 12:21:36 +0200
Message-Id: <1437733296-38198-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
References: <1437733296-38198-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

With the new v4l2_fh_open_is_first function the check whether a file
open is the first is now much easier. Implement this in these two
drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 21 +++++++--------------
 drivers/media/usb/cpia2/cpia2_v4l.c           |  5 +----
 2 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 471d6a8..aa05ffd 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -182,16 +182,15 @@ static int si470x_get_all_registers(struct si470x_device *radio)
 int si470x_fops_open(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = v4l2_fh_open(file);
+	int retval;
 
-	if (retval)
-		return retval;
-
-	if (v4l2_fh_is_singular_file(file)) {
+	if (v4l2_fh_open_is_first(file, &retval)) {
 		/* start radio */
 		retval = si470x_start(radio);
-		if (retval < 0)
-			goto done;
+		if (retval < 0) {
+			v4l2_fh_release(file);
+			return retval;
+		}
 
 		/* enable RDS / STC interrupt */
 		radio->registers[SYSCONFIG1] |= SYSCONFIG1_RDSIEN;
@@ -200,10 +199,6 @@ int si470x_fops_open(struct file *file)
 		radio->registers[SYSCONFIG1] |= 0x1 << 2;
 		retval = si470x_set_register(radio, SYSCONFIG1);
 	}
-
-done:
-	if (retval)
-		v4l2_fh_release(file);
 	return retval;
 }
 
@@ -215,11 +210,9 @@ int si470x_fops_release(struct file *file)
 {
 	struct si470x_device *radio = video_drvdata(file);
 
-	if (v4l2_fh_is_singular_file(file))
+	if (v4l2_fh_release_is_last(file))
 		/* stop radio */
 		si470x_stop(radio);
-
-	return v4l2_fh_release(file);
 }
 
 
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 9caea83..30f89ba 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -88,11 +88,8 @@ static int cpia2_open(struct file *file)
 
 	if (mutex_lock_interruptible(&cam->v4l2_lock))
 		return -ERESTARTSYS;
-	retval = v4l2_fh_open(file);
-	if (retval)
-		goto open_unlock;
 
-	if (v4l2_fh_is_singular_file(file)) {
+	if (v4l2_fh_open_is_first(file, &retval)) {
 		if (cpia2_allocate_buffers(cam)) {
 			v4l2_fh_release(file);
 			retval = -ENOMEM;
-- 
2.1.4

