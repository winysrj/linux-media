Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4066 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab2F1Gsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 20/33] ivtv: don't mess with vfd->debug.
Date: Thu, 28 Jun 2012 08:48:14 +0200
Message-Id: <ceecfcce16b60d0433093d73b08423d785256bdb.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
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

