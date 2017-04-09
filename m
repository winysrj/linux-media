Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35068 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbdDIBeR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:34:17 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] [media] saa7134: use setup_timer
Date: Sun,  9 Apr 2017 09:33:57 +0800
Message-Id: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/pci/saa7134/saa7134-ts.c    | 5 ++---
 drivers/media/pci/saa7134/saa7134-vbi.c   | 5 ++---
 drivers/media/pci/saa7134/saa7134-video.c | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-ts.c b/drivers/media/pci/saa7134/saa7134-ts.c
index 578e03f..7414878 100644
--- a/drivers/media/pci/saa7134/saa7134-ts.c
+++ b/drivers/media/pci/saa7134/saa7134-ts.c
@@ -223,9 +223,8 @@ int saa7134_ts_init1(struct saa7134_dev *dev)
 	dev->ts.nr_packets = ts_nr_packets;
 
 	INIT_LIST_HEAD(&dev->ts_q.queue);
-	init_timer(&dev->ts_q.timeout);
-	dev->ts_q.timeout.function = saa7134_buffer_timeout;
-	dev->ts_q.timeout.data     = (unsigned long)(&dev->ts_q);
+	setup_timer(&dev->ts_q.timeout, saa7134_buffer_timeout,
+		    (unsigned long)(&dev->ts_q));
 	dev->ts_q.dev              = dev;
 	dev->ts_q.need_two         = 1;
 	dev->ts_started            = 0;
diff --git a/drivers/media/pci/saa7134/saa7134-vbi.c b/drivers/media/pci/saa7134/saa7134-vbi.c
index 4619337..bcad9b2 100644
--- a/drivers/media/pci/saa7134/saa7134-vbi.c
+++ b/drivers/media/pci/saa7134/saa7134-vbi.c
@@ -181,9 +181,8 @@ struct vb2_ops saa7134_vbi_qops = {
 int saa7134_vbi_init1(struct saa7134_dev *dev)
 {
 	INIT_LIST_HEAD(&dev->vbi_q.queue);
-	init_timer(&dev->vbi_q.timeout);
-	dev->vbi_q.timeout.function = saa7134_buffer_timeout;
-	dev->vbi_q.timeout.data     = (unsigned long)(&dev->vbi_q);
+	setup_timer(&dev->vbi_q.timeout, saa7134_buffer_timeout,
+		    (unsigned long)(&dev->vbi_q));
 	dev->vbi_q.dev              = dev;
 
 	if (vbibufs < 2)
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4b1c432..51d42bb 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2145,9 +2145,8 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	dev->automute       = 0;
 
 	INIT_LIST_HEAD(&dev->video_q.queue);
-	init_timer(&dev->video_q.timeout);
-	dev->video_q.timeout.function = saa7134_buffer_timeout;
-	dev->video_q.timeout.data     = (unsigned long)(&dev->video_q);
+	setup_timer(&dev->video_q.timeout, saa7134_buffer_timeout,
+		    (unsigned long)(&dev->video_q));
 	dev->video_q.dev              = dev;
 	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 	dev->width    = 720;
-- 
2.9.3
