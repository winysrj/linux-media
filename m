Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3598 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab2IGN3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 16/28] v4l2: make vidioc_s_fbuf const.
Date: Fri,  7 Sep 2012 15:29:16 +0200
Message-Id: <6adca8757d94f0a16558a07a7f3d7a1340f13009.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Write-only ioctls should have a const argument in the ioctl op.

Do this conversion for vidioc_s_fbuf.

Adding const for write-only ioctls was decided during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146/saa7146_video.c |    2 +-
 drivers/media/pci/bt8xx/bttv-driver.c        |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c          |    4 ++--
 drivers/media/pci/saa7134/saa7134-video.c    |    2 +-
 drivers/media/pci/zoran/zoran_driver.c       |    2 +-
 drivers/media/platform/fsl-viu.c             |    2 +-
 drivers/media/platform/omap/omap_vout.c      |    2 +-
 include/media/v4l2-ioctl.h                   |    2 +-
 8 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 6d14785..4143d61 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -479,7 +479,7 @@ static int vidioc_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *f
 	return 0;
 }
 
-static int vidioc_s_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *fb)
+static int vidioc_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *fb)
 {
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 	struct saa7146_vv *vv = dev->vv_data;
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index b58ff87..26bf309 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2740,7 +2740,7 @@ static int bttv_overlay(struct file *file, void *f, unsigned int on)
 }
 
 static int bttv_s_fbuf(struct file *file, void *f,
-				struct v4l2_framebuffer *fb)
+				const struct v4l2_framebuffer *fb)
 {
 	struct bttv_fh *fh = f;
 	struct bttv *btv = fh->btv;
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 32a5910..d3b32c2 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -1427,7 +1427,7 @@ static int ivtv_g_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *fb)
 	return 0;
 }
 
-static int ivtv_s_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *fb)
+static int ivtv_s_fbuf(struct file *file, void *fh, const struct v4l2_framebuffer *fb)
 {
 	struct ivtv_open_id *id = fh2id(fh);
 	struct ivtv *itv = id->itv;
@@ -1444,7 +1444,7 @@ static int ivtv_s_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *fb)
 	itv->osd_chroma_key_state = (fb->flags & V4L2_FBUF_FLAG_CHROMAKEY) != 0;
 	ivtv_set_osd_alpha(itv);
 	yi->track_osd = (fb->flags & V4L2_FBUF_FLAG_OVERLAY) != 0;
-	return ivtv_g_fbuf(file, fh, fb);
+	return 0;
 }
 
 static int ivtv_overlay(struct file *file, void *fh, unsigned int on)
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 6de10b1..bac4386 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2158,7 +2158,7 @@ static int saa7134_g_fbuf(struct file *file, void *f,
 }
 
 static int saa7134_s_fbuf(struct file *file, void *f,
-					struct v4l2_framebuffer *fb)
+					const struct v4l2_framebuffer *fb)
 {
 	struct saa7134_fh *fh = f;
 	struct saa7134_dev *dev = fh->dev;
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index c6ccdeb..f91b551 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -1978,7 +1978,7 @@ static int zoran_g_fbuf(struct file *file, void *__fh,
 }
 
 static int zoran_s_fbuf(struct file *file, void *__fh,
-		struct v4l2_framebuffer *fb)
+		const struct v4l2_framebuffer *fb)
 {
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 20f9810..897250b 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -860,7 +860,7 @@ int vidioc_g_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
 	return 0;
 }
 
-int vidioc_s_fbuf(struct file *file, void *priv, struct v4l2_framebuffer *arg)
+int vidioc_s_fbuf(struct file *file, void *priv, const struct v4l2_framebuffer *arg)
 {
 	struct viu_fh  *fh = priv;
 	struct viu_dev *dev = fh->dev;
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 88cf9d9..92845f8 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1744,7 +1744,7 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 }
 
 static int vidioc_s_fbuf(struct file *file, void *fh,
-				struct v4l2_framebuffer *a)
+				const struct v4l2_framebuffer *a)
 {
 	int enable = 0;
 	struct omap_overlay *ovl;
diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
index 0bc1444..73ae24a 100644
--- a/include/media/v4l2-ioctl.h
+++ b/include/media/v4l2-ioctl.h
@@ -120,7 +120,7 @@ struct v4l2_ioctl_ops {
 	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
 				struct v4l2_framebuffer *a);
 	int (*vidioc_s_fbuf)   (struct file *file, void *fh,
-				struct v4l2_framebuffer *a);
+				const struct v4l2_framebuffer *a);
 
 		/* Stream on/off */
 	int (*vidioc_streamon) (struct file *file, void *fh, enum v4l2_buf_type i);
-- 
1.7.10.4

