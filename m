Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kolorific.com ([61.63.28.39]:48292 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407AbZERCcI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 22:32:08 -0400
Subject: [PATCH]media/video: minor have assigned value twice
From: "figo.zhang" <figo.zhang@kolorific.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	figo1802@126.com, kraxel@bytesex.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 18 May 2009 10:31:55 +0800
Message-Id: <1242613915.3442.29.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The variable minor have assigned value twice, the first time is in the initial "video_device"data struct in
those drivers,pls see saa7134-video.c,line 2503.

Signed-off-by: Figo.zhang <figo.zhang@kolorific.com>
 ---
 drivers/media/video/bt8xx/bttv-driver.c    |    1 -
 drivers/media/video/cx23885/cx23885-417.c  |    1 -
 drivers/media/video/cx88/cx88-core.c       |    1 -
 drivers/media/video/saa7134/saa7134-core.c |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 23b7499..539ae45 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -4166,7 +4166,6 @@ static struct video_device *vdev_init(struct bttv *btv,
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->minor   = -1;
 	vfd->v4l2_dev = &btv->c.v4l2_dev;
 	vfd->release = video_device_release;
 	vfd->debug   = bttv_debug;
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index 6f5df90..2943bfd 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1742,7 +1742,6 @@ static struct video_device *cx23885_video_dev_alloc(
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->minor   = -1;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)", dev->name,
 		type, cx23885_boards[tsport->dev->board].name);
 	vfd->parent  = &pci->dev;
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index 0e149b2..b4049de 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -1010,7 +1010,6 @@ struct video_device *cx88_vdev_init(struct cx88_core *core,
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->minor   = -1;
 	vfd->v4l2_dev = &core->v4l2_dev;
 	vfd->parent = &pci->dev;
 	vfd->release = video_device_release;
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 2def6fe..37b1452 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -775,7 +775,6 @@ static struct video_device *vdev_init(struct saa7134_dev *dev,
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->minor   = -1;
 	vfd->v4l2_dev  = &dev->v4l2_dev;
 	vfd->release = video_device_release;
 	vfd->debug   = video_debug;


