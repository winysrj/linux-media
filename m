Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3953 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab3AaKZw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:52 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 16/18] tlg2300: allow multiple opens.
Date: Thu, 31 Jan 2013 11:25:34 +0100
Message-Id: <b4fbf6957c11847887cc13bb62281ef43fe8249d.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Due to a poor administration of the driver state it wasn't possible to open
a video or vbi device multiple times.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-common.h |    1 -
 drivers/media/usb/tlg2300/pd-video.c  |   40 +++++++++++++--------------------
 2 files changed, 15 insertions(+), 26 deletions(-)

diff --git a/drivers/media/usb/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
index cb5cb0f..3010496 100644
--- a/drivers/media/usb/tlg2300/pd-common.h
+++ b/drivers/media/usb/tlg2300/pd-common.h
@@ -26,7 +26,6 @@
 #define POSEIDON_STATE_ANALOG		(0x0001)
 #define POSEIDON_STATE_FM		(0x0002)
 #define POSEIDON_STATE_DVBT		(0x0004)
-#define POSEIDON_STATE_VBI		(0x0008)
 #define POSEIDON_STATE_DISCONNECT	(0x0080)
 
 #define PM_SUSPEND_DELAY	3
diff --git a/drivers/media/usb/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
index 4c045b3..834428d 100644
--- a/drivers/media/usb/tlg2300/pd-video.c
+++ b/drivers/media/usb/tlg2300/pd-video.c
@@ -1352,12 +1352,14 @@ static int pd_video_open(struct file *file)
 	mutex_lock(&pd->lock);
 	usb_autopm_get_interface(pd->interface);
 
-	if (vfd->vfl_type == VFL_TYPE_GRABBER
-		&& !(pd->state & POSEIDON_STATE_ANALOG)) {
-		front = kzalloc(sizeof(struct front_face), GFP_KERNEL);
-		if (!front)
-			goto out;
-
+	if (pd->state && !(pd->state & POSEIDON_STATE_ANALOG)) {
+		ret = -EBUSY;
+		goto out;
+	}
+	front = kzalloc(sizeof(struct front_face), GFP_KERNEL);
+	if (!front)
+		goto out;
+	if (vfd->vfl_type == VFL_TYPE_GRABBER) {
 		pd->cur_transfer_mode	= usb_transfer_mode;/* bulk or iso */
 		init_video_context(&pd->video_data.context);
 
@@ -1368,7 +1370,6 @@ static int pd_video_open(struct file *file)
 			goto out;
 		}
 
-		pd->state		|= POSEIDON_STATE_ANALOG;
 		front->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		pd->video_data.users++;
 		set_debug_mode(vfd, debug_mode);
@@ -1379,13 +1380,7 @@ static int pd_video_open(struct file *file)
 				V4L2_FIELD_INTERLACED,/* video is interlacd */
 				sizeof(struct videobuf_buffer),/*it's enough*/
 				front, NULL);
-	} else if (vfd->vfl_type == VFL_TYPE_VBI
-		&& !(pd->state & POSEIDON_STATE_VBI)) {
-		front = kzalloc(sizeof(struct front_face), GFP_KERNEL);
-		if (!front)
-			goto out;
-
-		pd->state	|= POSEIDON_STATE_VBI;
+	} else {
 		front->type	= V4L2_BUF_TYPE_VBI_CAPTURE;
 		pd->vbi_data.front = front;
 		pd->vbi_data.users++;
@@ -1396,19 +1391,15 @@ static int pd_video_open(struct file *file)
 				V4L2_FIELD_NONE, /* vbi is NONE mode */
 				sizeof(struct videobuf_buffer),
 				front, NULL);
-	} else {
-		/* maybe add FM support here */
-		log("other ");
-		ret = -EINVAL;
-		goto out;
 	}
 
-	front->pd		= pd;
-	front->curr_frame	= NULL;
+	pd->state |= POSEIDON_STATE_ANALOG;
+	front->pd = pd;
+	front->curr_frame = NULL;
 	INIT_LIST_HEAD(&front->active);
 	spin_lock_init(&front->queue_lock);
 
-	file->private_data	= front;
+	file->private_data = front;
 	kref_get(&pd->kref);
 
 	mutex_unlock(&pd->lock);
@@ -1429,8 +1420,6 @@ static int pd_video_release(struct file *file)
 	mutex_lock(&pd->lock);
 
 	if (front->type	== V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		pd->state &= ~POSEIDON_STATE_ANALOG;
-
 		/* stop the device, and free the URBs */
 		usb_transfer_stop(&pd->video_data);
 		free_all_urb(&pd->video_data);
@@ -1442,10 +1431,11 @@ static int pd_video_release(struct file *file)
 		pd->file_for_stream = NULL;
 		pd->video_data.users--;
 	} else if (front->type	== V4L2_BUF_TYPE_VBI_CAPTURE) {
-		pd->state &= ~POSEIDON_STATE_VBI;
 		pd->vbi_data.front = NULL;
 		pd->vbi_data.users--;
 	}
+	if (!pd->vbi_data.users && !pd->video_data.users)
+		pd->state &= ~POSEIDON_STATE_ANALOG;
 	videobuf_stop(&front->q);
 	videobuf_mmap_free(&front->q);
 
-- 
1.7.10.4

