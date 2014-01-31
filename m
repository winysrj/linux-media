Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1196 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaAaJ5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 04:57:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 32/32] go7007: add motion detection support.
Date: Fri, 31 Jan 2014 10:56:30 +0100
Message-Id: <1391162190-8620-33-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
References: <1391162190-8620-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch adds motion detection support to the go7007 driver using the new
motion detection controls, events.

The global motion detection works fine, but the regional motion detection
support probably needs more work. There seems to be some interaction between
regions that makes setting correct thresholds difficult. The exact meaning of
the thresholds isn't entirely clear either.

I do not have any documentation, the only information I have is the custom code
in the driver and a modet.c application.

My suspicion is that the internal motion detection bitmap is only updated for
a region if motion is detected for that region. This means that additional work
has to be done to check if the motion bits for a region have changed, and if not,
then that region should be discarded from the region_mask.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-driver.c  | 119 +++++++---
 drivers/staging/media/go7007/go7007-fw.c      |  28 ++-
 drivers/staging/media/go7007/go7007-priv.h    |  16 ++
 drivers/staging/media/go7007/go7007-v4l2.c    | 319 ++++++++++++++++++--------
 drivers/staging/media/go7007/go7007.h         |  40 ----
 drivers/staging/media/go7007/saa7134-go7007.c |   1 -
 6 files changed, 339 insertions(+), 184 deletions(-)
 delete mode 100644 drivers/staging/media/go7007/go7007.h

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 3640df0..c322c98 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -33,6 +33,7 @@
 #include <linux/videodev2.h>
 #include <media/tuner.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
 
 #include "go7007-priv.h"
 
@@ -333,20 +334,33 @@ EXPORT_SYMBOL(go7007_register_encoder);
 int go7007_start_encoder(struct go7007 *go)
 {
 	u8 *fw;
-	int fw_len, rv = 0, i;
+	int fw_len, rv = 0, i, x, y;
 	u16 intr_val, intr_data;
 
 	go->modet_enable = 0;
-	if (!go->dvd_mode)
-		for (i = 0; i < 4; ++i) {
-			if (go->modet[i].enable) {
-				go->modet_enable = 1;
-				continue;
+	for (i = 0; i < 4; i++)
+		go->modet[i].enable = 0;
+
+	switch (v4l2_ctrl_g_ctrl(go->modet_mode)) {
+	case V4L2_DETECT_MD_MODE_GLOBAL:
+		memset(go->modet_map, 0, sizeof(go->modet_map));
+		go->modet[0].enable = 1;
+		go->modet_enable = 1;
+		break;
+	case V4L2_DETECT_MD_MODE_REGION_GRID:
+		for (y = 0; y < go->height / 16; y++) {
+			for (x = 0; x < go->width / 16; x++) {
+				int idx = y * go->width / 16 + x;
+
+				go->modet[go->modet_map[idx]].enable = 1;
 			}
-			go->modet[i].pixel_threshold = 32767;
-			go->modet[i].motion_threshold = 32767;
-			go->modet[i].mb_threshold = 32767;
 		}
+		go->modet_enable = 1;
+		break;
+	}
+
+	if (go->dvd_mode)
+		go->modet_enable = 0;
 
 	if (go7007_construct_fw_image(go, &fw, &fw_len) < 0)
 		return -1;
@@ -385,43 +399,80 @@ static inline void store_byte(struct go7007_buffer *vb, u8 byte)
 }
 
 /*
- * Deliver the last video buffer and get a new one to start writing to.
+ * Determine regions with motion and send a motion detection event
+ * in case of changes.
  */
-static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buffer *vb)
+static void go7007_motion_regions(struct go7007 *go, struct go7007_buffer *vb)
 {
-	struct go7007_buffer *vb_tmp = NULL;
 	u32 *bytesused = &vb->vb.v4l2_planes[0].bytesused;
+	unsigned motion[4] = { 0, 0, 0, 0 };
+	u32 motion_regions = 0;
+	unsigned stride = (go->width + 7) >> 3;
+	unsigned x, y;
 	int i;
 
-	if (vb) {
-		if (vb->modet_active) {
-			if (*bytesused + 216 < GO7007_BUF_SIZE) {
-				for (i = 0; i < 216; ++i)
-					store_byte(vb, go->active_map[i]);
-				*bytesused -= 216;
-			} else
-				vb->modet_active = 0;
+	for (i = 0; i < 216; ++i)
+		store_byte(vb, go->active_map[i]);
+	for (y = 0; y < go->height / 16; y++) {
+		for (x = 0; x < go->width / 16; x++) {
+			if (!(go->active_map[y * stride + (x >> 3)] & (1 << (x & 7))))
+				continue;
+			motion[go->modet_map[y * (go->width / 16) + x]]++;
 		}
-		vb->vb.v4l2_buf.sequence = go->next_seq++;
-		v4l2_get_timestamp(&vb->vb.v4l2_buf.timestamp);
-		vb_tmp = vb;
+	}
+	motion_regions = ((motion[0] > 0) << 0) |
+			 ((motion[1] > 0) << 1) |
+			 ((motion[2] > 0) << 2) |
+			 ((motion[3] > 0) << 3);
+	*bytesused -= 216;
+	if (motion_regions != go->modet_event_status) {
+		struct v4l2_event ev = {
+			.type = V4L2_EVENT_MOTION_DET,
+			.u.motion_det = {
+				.flags = V4L2_EVENT_MD_FL_HAVE_FRAME_SEQ,
+				.frame_sequence = vb->vb.v4l2_buf.sequence,
+				.region_mask = motion_regions,
+			},
+		};
+
+		v4l2_event_queue(&go->vdev, &ev);
+		go->modet_event_status = motion_regions;
+	}
+}
+
+/*
+ * Deliver the last video buffer and get a new one to start writing to.
+ */
+static struct go7007_buffer *frame_boundary(struct go7007 *go, struct go7007_buffer *vb)
+{
+	u32 *bytesused = &vb->vb.v4l2_planes[0].bytesused;
+	struct go7007_buffer *vb_tmp = NULL;
+
+	if (vb == NULL) {
 		spin_lock(&go->spinlock);
-		list_del(&vb->list);
-		if (list_empty(&go->vidq_active))
-			vb = NULL;
-		else
-			vb = list_first_entry(&go->vidq_active, struct go7007_buffer, list);
-		go->active_buf = vb;
+		if (!list_empty(&go->vidq_active))
+			vb = go->active_buf =
+				list_first_entry(&go->vidq_active, struct go7007_buffer, list);
 		spin_unlock(&go->spinlock);
-		vb2_buffer_done(&vb_tmp->vb, VB2_BUF_STATE_DONE);
+		go->next_seq++;
 		return vb;
 	}
+
+	vb->vb.v4l2_buf.sequence = go->next_seq++;
+	if (vb->modet_active && *bytesused + 216 < GO7007_BUF_SIZE)
+		go7007_motion_regions(go, vb);
+
+	v4l2_get_timestamp(&vb->vb.v4l2_buf.timestamp);
+	vb_tmp = vb;
 	spin_lock(&go->spinlock);
-	if (!list_empty(&go->vidq_active))
-		vb = go->active_buf =
-			list_first_entry(&go->vidq_active, struct go7007_buffer, list);
+	list_del(&vb->list);
+	if (list_empty(&go->vidq_active))
+		vb = NULL;
+	else
+		vb = list_first_entry(&go->vidq_active, struct go7007_buffer, list);
+	go->active_buf = vb;
 	spin_unlock(&go->spinlock);
-	go->next_seq++;
+	vb2_buffer_done(&vb_tmp->vb, VB2_BUF_STATE_DONE);
 	return vb;
 }
 
diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
index c2d0e58af..43cb634 100644
--- a/drivers/staging/media/go7007/go7007-fw.c
+++ b/drivers/staging/media/go7007/go7007-fw.c
@@ -1432,22 +1432,26 @@ static int audio_to_package(struct go7007 *go, __le16 *code, int space)
 
 static int modet_to_package(struct go7007 *go, __le16 *code, int space)
 {
+	bool has_modet0 = go->modet[0].enable;
+	bool has_modet1 = go->modet[1].enable;
+	bool has_modet2 = go->modet[2].enable;
+	bool has_modet3 = go->modet[3].enable;
 	int ret, mb, i, addr, cnt = 0;
 	u16 pack[32];
 	u16 thresholds[] = {
 		0x200e,		0,
-		0xbf82,		go->modet[0].pixel_threshold,
-		0xbf83,		go->modet[1].pixel_threshold,
-		0xbf84,		go->modet[2].pixel_threshold,
-		0xbf85,		go->modet[3].pixel_threshold,
-		0xbf86,		go->modet[0].motion_threshold,
-		0xbf87,		go->modet[1].motion_threshold,
-		0xbf88,		go->modet[2].motion_threshold,
-		0xbf89,		go->modet[3].motion_threshold,
-		0xbf8a,		go->modet[0].mb_threshold,
-		0xbf8b,		go->modet[1].mb_threshold,
-		0xbf8c,		go->modet[2].mb_threshold,
-		0xbf8d,		go->modet[3].mb_threshold,
+		0xbf82,		has_modet0 ? go->modet[0].pixel_threshold : 32767,
+		0xbf83,		has_modet1 ? go->modet[1].pixel_threshold : 32767,
+		0xbf84,		has_modet2 ? go->modet[2].pixel_threshold : 32767,
+		0xbf85,		has_modet3 ? go->modet[3].pixel_threshold : 32767,
+		0xbf86,		has_modet0 ? go->modet[0].motion_threshold : 32767,
+		0xbf87,		has_modet1 ? go->modet[1].motion_threshold : 32767,
+		0xbf88,		has_modet2 ? go->modet[2].motion_threshold : 32767,
+		0xbf89,		has_modet3 ? go->modet[3].motion_threshold : 32767,
+		0xbf8a,		has_modet0 ? go->modet[0].mb_threshold : 32767,
+		0xbf8b,		has_modet1 ? go->modet[1].mb_threshold : 32767,
+		0xbf8c,		has_modet2 ? go->modet[2].mb_threshold : 32767,
+		0xbf8d,		has_modet3 ? go->modet[3].mb_threshold : 32767,
 		0xbf8e,		0,
 		0xbf8f,		0,
 		0,		0,
diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 6e16af7..a8aefed 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -75,6 +75,20 @@ struct go7007;
 #define GO7007_AUDIO_I2S_MASTER		(1<<16)
 #define GO7007_AUDIO_OKI_MODE		(1<<17)
 
+#define GO7007_CID_CUSTOM_BASE		(V4L2_CID_DETECT_CLASS_BASE + 0x1000)
+#define V4L2_CID_PIXEL_THRESHOLD0	(GO7007_CID_CUSTOM_BASE+1)
+#define V4L2_CID_MOTION_THRESHOLD0	(GO7007_CID_CUSTOM_BASE+2)
+#define V4L2_CID_MB_THRESHOLD0		(GO7007_CID_CUSTOM_BASE+3)
+#define V4L2_CID_PIXEL_THRESHOLD1	(GO7007_CID_CUSTOM_BASE+4)
+#define V4L2_CID_MOTION_THRESHOLD1	(GO7007_CID_CUSTOM_BASE+5)
+#define V4L2_CID_MB_THRESHOLD1		(GO7007_CID_CUSTOM_BASE+6)
+#define V4L2_CID_PIXEL_THRESHOLD2	(GO7007_CID_CUSTOM_BASE+7)
+#define V4L2_CID_MOTION_THRESHOLD2	(GO7007_CID_CUSTOM_BASE+8)
+#define V4L2_CID_MB_THRESHOLD2		(GO7007_CID_CUSTOM_BASE+9)
+#define V4L2_CID_PIXEL_THRESHOLD3	(GO7007_CID_CUSTOM_BASE+10)
+#define V4L2_CID_MOTION_THRESHOLD3	(GO7007_CID_CUSTOM_BASE+11)
+#define V4L2_CID_MB_THRESHOLD3		(GO7007_CID_CUSTOM_BASE+12)
+
 struct go7007_board_info {
 	unsigned int flags;
 	int hpi_buffer_cap;
@@ -168,6 +182,7 @@ struct go7007 {
 	struct v4l2_ctrl *mpeg_video_aspect_ratio;
 	struct v4l2_ctrl *mpeg_video_b_frames;
 	struct v4l2_ctrl *mpeg_video_rep_seqheader;
+	struct v4l2_ctrl *modet_mode;
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
 	spinlock_t spinlock;
 	struct mutex hw_lock;
@@ -216,6 +231,7 @@ struct go7007 {
 	} modet[4];
 	unsigned char modet_map[1624];
 	unsigned char active_map[216];
+	u32 modet_event_status;
 
 	/* Video streaming */
 	struct mutex queue_lock;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 50eb69a..c45799e 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -37,7 +37,6 @@
 #include <media/videobuf2-vmalloc.h>
 #include <media/saa7115.h>
 
-#include "go7007.h"
 #include "go7007-priv.h"
 
 #define call_all(dev, o, f, args...) \
@@ -190,7 +189,7 @@ static void set_formatting(struct go7007 *go)
 static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 {
 	int sensor_height = 0, sensor_width = 0;
-	int width, height, i;
+	int width, height;
 
 	if (fmt != NULL && !valid_pixelformat(fmt->fmt.pix.pixelformat))
 		return -EINVAL;
@@ -254,10 +253,6 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 	go->height = height;
 	go->encoder_h_offset = go->board_info->sensor_h_offset;
 	go->encoder_v_offset = go->board_info->sensor_v_offset;
-	for (i = 0; i < 4; ++i)
-		go->modet[i].enable = 0;
-	for (i = 0; i < 1624; ++i)
-		go->modet_map[i] = 0;
 
 	if (go->board_info->sensor_flags & GO7007_SENSOR_SCALING) {
 		struct v4l2_mbus_framefmt mbus_fmt;
@@ -287,64 +282,6 @@ static int set_capture_size(struct go7007 *go, struct v4l2_format *fmt, int try)
 	return 0;
 }
 
-#if 0
-static int clip_to_modet_map(struct go7007 *go, int region,
-		struct v4l2_clip *clip_list)
-{
-	struct v4l2_clip clip, *clip_ptr;
-	int x, y, mbnum;
-
-	/* Check if coordinates are OK and if any macroblocks are already
-	 * used by other regions (besides 0) */
-	clip_ptr = clip_list;
-	while (clip_ptr) {
-		if (copy_from_user(&clip, clip_ptr, sizeof(clip)))
-			return -EFAULT;
-		if (clip.c.left < 0 || (clip.c.left & 0xF) ||
-				clip.c.width <= 0 || (clip.c.width & 0xF))
-			return -EINVAL;
-		if (clip.c.left + clip.c.width > go->width)
-			return -EINVAL;
-		if (clip.c.top < 0 || (clip.c.top & 0xF) ||
-				clip.c.height <= 0 || (clip.c.height & 0xF))
-			return -EINVAL;
-		if (clip.c.top + clip.c.height > go->height)
-			return -EINVAL;
-		for (y = 0; y < clip.c.height; y += 16)
-			for (x = 0; x < clip.c.width; x += 16) {
-				mbnum = (go->width >> 4) *
-						((clip.c.top + y) >> 4) +
-					((clip.c.left + x) >> 4);
-				if (go->modet_map[mbnum] != 0 &&
-						go->modet_map[mbnum] != region)
-					return -EBUSY;
-			}
-		clip_ptr = clip.next;
-	}
-
-	/* Clear old region macroblocks */
-	for (mbnum = 0; mbnum < 1624; ++mbnum)
-		if (go->modet_map[mbnum] == region)
-			go->modet_map[mbnum] = 0;
-
-	/* Claim macroblocks in this list */
-	clip_ptr = clip_list;
-	while (clip_ptr) {
-		if (copy_from_user(&clip, clip_ptr, sizeof(clip)))
-			return -EFAULT;
-		for (y = 0; y < clip.c.height; y += 16)
-			for (x = 0; x < clip.c.width; x += 16) {
-				mbnum = (go->width >> 4) *
-						((clip.c.top + y) >> 4) +
-					((clip.c.left + x) >> 4);
-				go->modet_map[mbnum] = region;
-			}
-		clip_ptr = clip.next;
-	}
-	return 0;
-}
-#endif
-
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
@@ -496,6 +433,7 @@ static int go7007_start_streaming(struct vb2_queue *q, unsigned int count)
 	mutex_lock(&go->hw_lock);
 	go->next_seq = 0;
 	go->active_buf = NULL;
+	go->modet_event_status = 0;
 	q->streaming = 1;
 	if (go7007_start_encoder(go) < 0)
 		ret = -EIO;
@@ -849,41 +787,76 @@ static int vidioc_log_status(struct file *file, void *priv)
 	return call_all(&go->v4l2_dev, core, log_status);
 }
 
-/* FIXME:
-	Those ioctls are private, and not needed, since several standard
-	extended controls already provide streaming control.
-	So, those ioctls should be converted into vidioc_g_ext_ctrls()
-	and vidioc_s_ext_ctrls()
- */
-
-#if 0
-	case GO7007IOC_S_MD_PARAMS:
-	{
-		struct go7007_md_params *mdp = arg;
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+				const struct v4l2_event_subscription *sub)
+{
 
-		if (mdp->region > 3)
-			return -EINVAL;
-		if (mdp->trigger > 0) {
-			go->modet[mdp->region].pixel_threshold =
-					mdp->pixel_threshold >> 1;
-			go->modet[mdp->region].motion_threshold =
-					mdp->motion_threshold >> 1;
-			go->modet[mdp->region].mb_threshold =
-					mdp->trigger >> 1;
-			go->modet[mdp->region].enable = 1;
-		} else
-			go->modet[mdp->region].enable = 0;
-		/* fall-through */
+	switch (sub->type) {
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subscribe_event(fh, sub);
+	case V4L2_EVENT_MOTION_DET:
+		/* Allow for up to 30 events (1 second for NTSC) to be
+		 * stored. */
+		return v4l2_event_subscribe(fh, sub, 30, NULL);
 	}
-	case GO7007IOC_S_MD_REGION:
-	{
-		struct go7007_md_region *region = arg;
+	return -EINVAL;
+}
 
-		if (region->region < 1 || region->region > 3)
-			return -EINVAL;
-		return clip_to_modet_map(go, region->region, region->clips);
+
+static int go7007_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct go7007 *go =
+		container_of(ctrl->handler, struct go7007, hdl);
+	unsigned y;
+	u8 *mt;
+
+	switch (ctrl->id) {
+	case V4L2_CID_PIXEL_THRESHOLD0:
+		go->modet[0].pixel_threshold = ctrl->val;
+		break;
+	case V4L2_CID_MOTION_THRESHOLD0:
+		go->modet[0].motion_threshold = ctrl->val;
+		break;
+	case V4L2_CID_MB_THRESHOLD0:
+		go->modet[0].mb_threshold = ctrl->val;
+		break;
+	case V4L2_CID_PIXEL_THRESHOLD1:
+		go->modet[1].pixel_threshold = ctrl->val;
+		break;
+	case V4L2_CID_MOTION_THRESHOLD1:
+		go->modet[1].motion_threshold = ctrl->val;
+		break;
+	case V4L2_CID_MB_THRESHOLD1:
+		go->modet[1].mb_threshold = ctrl->val;
+		break;
+	case V4L2_CID_PIXEL_THRESHOLD2:
+		go->modet[2].pixel_threshold = ctrl->val;
+		break;
+	case V4L2_CID_MOTION_THRESHOLD2:
+		go->modet[2].motion_threshold = ctrl->val;
+		break;
+	case V4L2_CID_MB_THRESHOLD2:
+		go->modet[2].mb_threshold = ctrl->val;
+		break;
+	case V4L2_CID_PIXEL_THRESHOLD3:
+		go->modet[3].pixel_threshold = ctrl->val;
+		break;
+	case V4L2_CID_MOTION_THRESHOLD3:
+		go->modet[3].motion_threshold = ctrl->val;
+		break;
+	case V4L2_CID_MB_THRESHOLD3:
+		go->modet[3].mb_threshold = ctrl->val;
+		break;
+	case V4L2_CID_DETECT_MD_REGION_GRID:
+		mt = go->modet_map;
+		for (y = 0; y < go->height / 16; y++, mt += go->width / 16)
+			memcpy(mt, ctrl->new.p_u8 + y * (720 / 16), go->width / 16);
+		break;
+	default:
+		return -EINVAL;
 	}
-#endif
+	return 0;
+}
 
 static struct v4l2_file_operations go7007_fops = {
 	.owner		= THIS_MODULE,
@@ -925,7 +898,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_framesizes   = vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 	.vidioc_log_status        = vidioc_log_status,
-	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
+	.vidioc_subscribe_event   = vidioc_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
@@ -937,12 +910,146 @@ static struct video_device go7007_template = {
 	.tvnorms	= V4L2_STD_ALL,
 };
 
+static const struct v4l2_ctrl_ops go7007_ctrl_ops = {
+	.s_ctrl = go7007_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config go7007_pixel_threshold0_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_PIXEL_THRESHOLD0,
+	.name = "Pixel Threshold Region 0",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 50,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_motion_threshold0_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_MOTION_THRESHOLD0,
+	.name = "Motion Threshold Region 0",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 4000,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_mb_threshold0_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_MB_THRESHOLD0,
+	.name = "MB Threshold Region 0",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 10,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_pixel_threshold1_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_PIXEL_THRESHOLD1,
+	.name = "Pixel Threshold Region 1",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 50,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_motion_threshold1_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_MOTION_THRESHOLD1,
+	.name = "Motion Threshold Region 1",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 4000,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_mb_threshold1_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_MB_THRESHOLD1,
+	.name = "MB Threshold Region 1",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 10,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_pixel_threshold2_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_PIXEL_THRESHOLD2,
+	.name = "Pixel Threshold Region 2",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 50,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_motion_threshold2_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_MOTION_THRESHOLD2,
+	.name = "Motion Threshold Region 2",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 4000,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_mb_threshold2_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_MB_THRESHOLD2,
+	.name = "MB Threshold Region 2",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 10,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_pixel_threshold3_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_PIXEL_THRESHOLD3,
+	.name = "Pixel Threshold Region 3",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 50,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_motion_threshold3_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_MOTION_THRESHOLD3,
+	.name = "Motion Threshold Region 3",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 4000,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_mb_threshold3_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_MB_THRESHOLD3,
+	.name = "MB Threshold Region 3",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.def = 10,
+	.max = 32767,
+	.step = 1,
+};
+
+static const struct v4l2_ctrl_config go7007_mb_regions_ctrl = {
+	.ops = &go7007_ctrl_ops,
+	.id = V4L2_CID_DETECT_MD_REGION_GRID,
+	.rows = 576 / 16,
+	.cols = 720 / 16,
+	.elem_size = 1,
+	.max = 3,
+	.step = 1,
+};
+
 int go7007_v4l2_ctrl_init(struct go7007 *go)
 {
 	struct v4l2_ctrl_handler *hdl = &go->hdl;
 	struct v4l2_ctrl *ctrl;
 
-	v4l2_ctrl_handler_init(hdl, 13);
+	v4l2_ctrl_handler_init(hdl, 22);
 	go->mpeg_video_gop_size = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, 34, 1, 15);
 	go->mpeg_video_gop_closure = v4l2_ctrl_new_std(hdl, NULL,
@@ -965,6 +1072,24 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
 			V4L2_JPEG_ACTIVE_MARKER_DQT | V4L2_JPEG_ACTIVE_MARKER_DHT);
 	if (ctrl)
 		ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	v4l2_ctrl_new_custom(hdl, &go7007_pixel_threshold0_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_motion_threshold0_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_mb_threshold0_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_pixel_threshold1_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_motion_threshold1_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_mb_threshold1_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_pixel_threshold2_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_motion_threshold2_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_mb_threshold2_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_pixel_threshold3_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_motion_threshold3_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_mb_threshold3_ctrl, NULL);
+	v4l2_ctrl_new_custom(hdl, &go7007_mb_regions_ctrl, NULL);
+	go->modet_mode = v4l2_ctrl_new_std_menu(hdl, NULL,
+			V4L2_CID_DETECT_MD_MODE,
+			V4L2_DETECT_MD_MODE_REGION_GRID,
+			V4L2_DETECT_MD_MODE_THRESHOLD_GRID,
+			V4L2_DETECT_MD_MODE_DISABLED);
 	if (hdl->error) {
 		int rv = hdl->error;
 
diff --git a/drivers/staging/media/go7007/go7007.h b/drivers/staging/media/go7007/go7007.h
deleted file mode 100644
index 54b9897..0000000
--- a/drivers/staging/media/go7007/go7007.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * Copyright (C) 2005-2006 Micronas USA Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and the associated README documentation file (the
- * "Software"), to deal in the Software without restriction, including
- * without limitation the rights to use, copy, modify, merge, publish,
- * distribute, sublicense, and/or sell copies of the Software, and to
- * permit persons to whom the Software is furnished to do so.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
- * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
- * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
- * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
- * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
- * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
- */
-
-struct go7007_md_params {
-	__u16 region;
-	__u16 trigger;
-	__u16 pixel_threshold;
-	__u16 motion_threshold;
-	__u32 reserved[8];
-};
-
-struct go7007_md_region {
-	__u16 region;
-	__u16 flags;
-	struct v4l2_clip *clips;
-	__u32 reserved[8];
-};
-
-#define	GO7007IOC_S_MD_PARAMS	_IOWR('V', BASE_VIDIOC_PRIVATE + 6, \
-					struct go7007_md_params)
-#define	GO7007IOC_G_MD_PARAMS	_IOR('V', BASE_VIDIOC_PRIVATE + 7, \
-					struct go7007_md_params)
-#define	GO7007IOC_S_MD_REGION	_IOW('V', BASE_VIDIOC_PRIVATE + 8, \
-					struct go7007_md_region)
diff --git a/drivers/staging/media/go7007/saa7134-go7007.c b/drivers/staging/media/go7007/saa7134-go7007.c
index d80b235..e0eab32 100644
--- a/drivers/staging/media/go7007/saa7134-go7007.c
+++ b/drivers/staging/media/go7007/saa7134-go7007.c
@@ -33,7 +33,6 @@
 
 #include "saa7134.h"
 #include "saa7134-reg.h"
-#include "go7007.h"
 #include "go7007-priv.h"
 
 /*#define GO7007_HPI_DEBUG*/
-- 
1.8.5.2

