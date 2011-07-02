Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1943 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1GBOCE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jul 2011 10:02:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: qv4l2 version with control event support
Date: Sat, 2 Jul 2011 16:01:56 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107021601.56164.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

For those who want to test the control event with qv4l2 I have updated my
v4l-utils tree.

The top two patches in this repository:

http://git.linuxtv.org/hverkuil/v4l-utils.git?a=shortlog;h=refs/heads/qv4l2

add support for the control event and for the bitmask control type.

In order to use qv4l2 with drivers that support the read/write API you also
need to apply the patch below to your kernel as long as the poll() function
in the kernel doesn't provide the poll mask to the driver.

Regards,

	Hans

diff --git a/drivers/media/video/ivtv/ivtv-fileops.c b/drivers/media/video/ivtv/ivtv-fileops.c
index 38f0522..a96b62a 100644
--- a/drivers/media/video/ivtv/ivtv-fileops.c
+++ b/drivers/media/video/ivtv/ivtv-fileops.c
@@ -753,7 +753,8 @@ unsigned int ivtv_v4l2_enc_poll(struct file *filp, poll_table * wait)
 	unsigned res = 0;
 
 	/* Start a capture if there is none */
-	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags)) {
+	if (!eof && !test_bit(IVTV_F_S_STREAMING, &s->s_flags) &&
+			list_empty(&id->fh.subscribed)) {
 		int rc;
 
 		mutex_lock(&itv->serialize_lock);
diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
index 6ba1461..5b5cbc8 100644
--- a/drivers/media/video/videobuf2-core.c
+++ b/drivers/media/video/videobuf2-core.c
@@ -20,6 +20,8 @@
 #include <linux/sched.h>
 
 #include <media/videobuf2-core.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-fh.h>
 
 static int debug;
 module_param(debug, int, 0644);
@@ -1379,12 +1381,22 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * Start file I/O emulator only if streaming API has not been used yet.
 	 */
 	if (q->num_buffers == 0 && q->fileio == NULL) {
-		if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)) {
+		struct video_device *vfd = video_devdata(file);
+		bool has_no_events = true;
+
+		if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags)) {
+			struct v4l2_fh *fh = file->private_data;
+
+			has_no_events = list_empty(&fh->subscribed);
+		}
+		if (has_no_events && !V4L2_TYPE_IS_OUTPUT(q->type) &&
+						(q->io_modes & VB2_READ)) {
 			ret = __vb2_init_fileio(q, 1);
 			if (ret)
 				return POLLERR;
 		}
-		if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)) {
+		if (has_no_events && V4L2_TYPE_IS_OUTPUT(q->type) &&
+						(q->io_modes & VB2_WRITE)) {
 			ret = __vb2_init_fileio(q, 0);
 			if (ret)
 				return POLLERR;
