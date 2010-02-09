Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:60470 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab0BIQPh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 11:15:37 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH] v4l: Fix a memory leak caused by zeroing struct device
Date: Tue,  9 Feb 2010 17:15:30 +0100
Message-Id: <1265732130-17929-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit fb069a5d132fb926ed17af3211a114ac7cf27d7a introduced a private
portion in struct device that is dynamically allocated on demand, such
as when a driver stores a private pointer in the device's structure
using dev_set_drvdata.

video_register_device memsets the device structure embedded in the
video_device structure to 0, just in case the caller forgot to do so.
If the caller stored private data in the device structure before
registering the video device, this sets the device's private portion
pointer to NULL without freeing the memory.

Remove the memset to 0. Callers are supposed to have done it already.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/v4l2-dev.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

This is mostly an RFC patch (although it can be applied as-is). Zeroing
the device structure is definitely not a good idea. Of course drivers
need to be reviewed to make sure they zero it themselves before calling
video_set_drvdata.

Another approach would be to add a priv argument to
video_register_device. All drivers would still need to be converted.
I favor the approach taken in this patch (coupled with a review of the
drivers) because drivers should really zero the structure. This is a
good occasion to clean drivers up and fix a few bugs.

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 13a899d..1fec852 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -412,7 +412,6 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	int minor_offset = 0;
 	int minor_cnt = VIDEO_NUM_DEVICES;
 	const char *name_base;
-	void *priv = video_get_drvdata(vdev);
 
 	/* A minor value of -1 marks this video device as never
 	   having been registered */
@@ -536,10 +535,6 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 	}
 
 	/* Part 4: register the device with sysfs */
-	memset(&vdev->dev, 0, sizeof(vdev->dev));
-	/* The memset above cleared the device's drvdata, so
-	   put back the copy we made earlier. */
-	video_set_drvdata(vdev, priv);
 	vdev->dev.class = &video_class;
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
 	if (vdev->parent)
-- 
1.6.4.4

