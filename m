Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4545 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2FJK0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:26:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pawel Osciak <pawel@osciak.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 21/32] ivtv: don't mess with vfd->debug.
Date: Sun, 10 Jun 2012 12:25:43 +0200
Message-Id: <b18fa58f225c9b17f7956d4642ca91630ef149fa.1339321562.git.hans.verkuil@cisco.com>
In-Reply-To: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
References: <1339323954-1404-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
References: <ef490f7ebca5b6df91db6b1acfb9928ada3bcd70.1339321562.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is now controlled by sysfs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/ivtv/ivtv-ioctl.c   |   12 ------------
 drivers/media/video/ivtv/ivtv-ioctl.h   |    1 -
 drivers/media/video/ivtv/ivtv-streams.c |    4 ++--
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
index f7d57b3..32a5910 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.c
+++ b/drivers/media/video/ivtv/ivtv-ioctl.c
@@ -1830,18 +1830,6 @@ static long ivtv_default(struct file *file, void *fh, bool valid_prio,
 	return 0;
 }
 
-long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
-{
-	struct video_device *vfd = video_devdata(filp);
-	long ret;
-
-	if (ivtv_debug & IVTV_DBGFLG_IOCTL)
-		vfd->debug = V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
-	ret = video_ioctl2(filp, cmd, arg);
-	vfd->debug = 0;
-	return ret;
-}
-
 static const struct v4l2_ioctl_ops ivtv_ioctl_ops = {
 	.vidioc_querycap    		    = ivtv_querycap,
 	.vidioc_s_audio     		    = ivtv_s_audio,
diff --git a/drivers/media/video/ivtv/ivtv-ioctl.h b/drivers/media/video/ivtv/ivtv-ioctl.h
index 89185ca..7c553d1 100644
--- a/drivers/media/video/ivtv/ivtv-ioctl.h
+++ b/drivers/media/video/ivtv/ivtv-ioctl.h
@@ -31,6 +31,5 @@ void ivtv_s_std_enc(struct ivtv *itv, v4l2_std_id *std);
 void ivtv_s_std_dec(struct ivtv *itv, v4l2_std_id *std);
 int ivtv_s_frequency(struct file *file, void *fh, struct v4l2_frequency *vf);
 int ivtv_s_input(struct file *file, void *fh, unsigned int inp);
-long ivtv_v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 
 #endif
diff --git a/drivers/media/video/ivtv/ivtv-streams.c b/drivers/media/video/ivtv/ivtv-streams.c
index 6738592..87990c5 100644
--- a/drivers/media/video/ivtv/ivtv-streams.c
+++ b/drivers/media/video/ivtv/ivtv-streams.c
@@ -50,7 +50,7 @@ static const struct v4l2_file_operations ivtv_v4l2_enc_fops = {
 	.read = ivtv_v4l2_read,
 	.write = ivtv_v4l2_write,
 	.open = ivtv_v4l2_open,
-	.unlocked_ioctl = ivtv_v4l2_ioctl,
+	.unlocked_ioctl = video_ioctl2,
 	.release = ivtv_v4l2_close,
 	.poll = ivtv_v4l2_enc_poll,
 };
@@ -60,7 +60,7 @@ static const struct v4l2_file_operations ivtv_v4l2_dec_fops = {
 	.read = ivtv_v4l2_read,
 	.write = ivtv_v4l2_write,
 	.open = ivtv_v4l2_open,
-	.unlocked_ioctl = ivtv_v4l2_ioctl,
+	.unlocked_ioctl = video_ioctl2,
 	.release = ivtv_v4l2_close,
 	.poll = ivtv_v4l2_dec_poll,
 };
-- 
1.7.10

