Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4166 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3DNP1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 03/30] cx25821: fix compiler warning
Date: Sun, 14 Apr 2013 17:26:59 +0200
Message-Id: <1365953246-8972-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/cx25821/cx25821-video.c: In function ‘cx25821_video_register’:
drivers/media/pci/cx25821/cx25821-video.c:518:1: warning: the frame size of 1600 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Fixed by just making the struct video_device template static const.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |    9 ++++-----
 drivers/media/pci/cx25821/cx25821.h       |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 8bf9c89..4eaa67a 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -161,7 +161,7 @@ int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 
 struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
 				       struct pci_dev *pci,
-				       struct video_device *template,
+				       const struct video_device *template,
 				       char *type)
 {
 	struct video_device *vfd;
@@ -447,10 +447,7 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 
 int cx25821_video_register(struct cx25821_dev *dev)
 {
-	int err;
-	int i;
-
-	struct video_device cx25821_video_device = {
+	static const struct video_device cx25821_video_device = {
 		.name = "cx25821-video",
 		.fops = &video_fops,
 		.minor = -1,
@@ -458,6 +455,8 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		.tvnorms = CX25821_NORMS,
 		.current_norm = V4L2_STD_NTSC_M,
 	};
+	int err;
+	int i;
 
 	spin_lock_init(&dev->slock);
 
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 8a9c0c8..85693cd 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -610,6 +610,6 @@ extern void cx25821_set_pixel_format(struct cx25821_dev *dev, int channel,
 extern void cx25821_videoioctl_unregister(struct cx25821_dev *dev);
 extern struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
 					      struct pci_dev *pci,
-					      struct video_device *template,
+					      const struct video_device *template,
 					      char *type);
 #endif
-- 
1.7.10.4

