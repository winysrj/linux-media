Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1293 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaDQKjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 06:39:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org,
	#@tschai.lan, for@tschai.lan, v3.14@tschai.lan, and@tschai.lan,
	up@tschai.lan
Subject: [REVIEWv2 PATCH 01/11] saa7134: fix regression with tvtime
Date: Thu, 17 Apr 2014 12:39:04 +0200
Message-Id: <1397731154-34337-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
References: <1397731154-34337-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This solves this bug:

https://bugzilla.kernel.org/show_bug.cgi?id=73361

The problem is that when you quit tvtime it calls STREAMOFF, but then it queues a
bunch of buffers for no good reason before closing the file descriptor.

In the past closing the fd would free the vb queue since that was part of the file
handle struct. Since that was moved to the global struct that no longer happened.

This wouldn't be a problem, but the extra QBUF calls that tvtime does meant that
the buffer list in videobuf (q->stream) contained buffers, so REQBUFS would fail
with -EBUSY.

The solution is to init the list head explicitly when releasing the file
descriptor and to not free the video resource when calling streamoff.

The real fix will hopefully go into kernel 3.16 when the vb2 conversion is
merged. Basically the saa7134 driver with the old videobuf is so full of holes it
ain't funny anymore, so consider this a band-aid for kernels 3.14 and 15.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org      # for v3.14 and up
---
 drivers/media/pci/saa7134/saa7134-video.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index eb472b5..40396e8 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1243,6 +1243,7 @@ static int video_release(struct file *file)
 		videobuf_streamoff(&dev->cap);
 		res_free(dev, fh, RESOURCE_VIDEO);
 		videobuf_mmap_free(&dev->cap);
+		INIT_LIST_HEAD(&dev->cap.stream);
 	}
 	if (dev->cap.read_buf) {
 		buffer_release(&dev->cap, dev->cap.read_buf);
@@ -1254,6 +1255,7 @@ static int video_release(struct file *file)
 		videobuf_stop(&dev->vbi);
 		res_free(dev, fh, RESOURCE_VBI);
 		videobuf_mmap_free(&dev->vbi);
+		INIT_LIST_HEAD(&dev->vbi.stream);
 	}
 
 	/* ts-capture will not work in planar mode, so turn it off Hac: 04.05*/
@@ -1987,17 +1989,12 @@ int saa7134_streamoff(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
-	int err;
 	int res = saa7134_resource(file);
 
 	if (res != RESOURCE_EMPRESS)
 		pm_qos_remove_request(&dev->qos_request);
 
-	err = videobuf_streamoff(saa7134_queue(file));
-	if (err < 0)
-		return err;
-	res_free(dev, priv, res);
-	return 0;
+	return videobuf_streamoff(saa7134_queue(file));
 }
 EXPORT_SYMBOL_GPL(saa7134_streamoff);
 
-- 
1.9.2

