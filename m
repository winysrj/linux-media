Return-path: <linux-media-owner@vger.kernel.org>
Received: from [206.15.93.42] ([206.15.93.42]:11783 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754355Ab0AHXAl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Jan 2010 18:00:41 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] drivers/media/common: remove unnecessary casts of void *
Date: Fri, 8 Jan 2010 15:51:42 -0700
Cc: michael@mihu.de, mchehab@infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001081551.42264.hartleys@visionengravers.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/common: Remove unnecessary casts of void *

void pointers do not need to be cast to other pointer types.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Michael Hunold <michael@mihu.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

---

 drivers/media/common/saa7146_vbi.c   |    6 +++---
 drivers/media/common/saa7146_video.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
index 74e2b56..301a795 100644
--- a/drivers/media/common/saa7146_vbi.c
+++ b/drivers/media/common/saa7146_vbi.c
@@ -3,7 +3,7 @@
 static int vbi_pixel_to_capture = 720 * 2;
 
 static int vbi_workaround(struct saa7146_dev *dev)
-{
+{.remove_casts.hhs~
 	struct saa7146_vv *vv = dev->vv_data;
 
 	u32          *cpu;
@@ -375,7 +375,7 @@ static void vbi_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 
 static int vbi_open(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 
 	u32 arbtr_ctrl	= saa7146_read(dev, PCI_BT_V1);
 	int ret = 0;
@@ -437,7 +437,7 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 
 static void vbi_close(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_vv *vv = dev->vv_data;
 	DEB_VBI(("dev:%p, fh:%p\n",dev,fh));
 
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index becbaad..cfc8634 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -1368,7 +1368,7 @@ static void video_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 
 static int video_open(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_format *sfmt;
 
 	fh->video_fmt.width = 384;
@@ -1392,7 +1392,7 @@ static int video_open(struct saa7146_dev *dev, struct file *file)
 
 static void video_close(struct saa7146_dev *dev, struct file *file)
 {
-	struct saa7146_fh *fh = (struct saa7146_fh *)file->private_data;
+	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_vv *vv = dev->vv_data;
 	struct videobuf_queue *q = &fh->video_q;
 	int err;
