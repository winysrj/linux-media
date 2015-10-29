Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33867 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbbJ2KKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 06:10:40 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2 2/6] media/core: Replace ctrl_class with which
Date: Thu, 29 Oct 2015 11:10:28 +0100
Message-Id: <1446113432-27390-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the obsolete field ctrl_class with "which".

Make sure it not used in future modules by commenting out the field with
ifndef __KERNEL_ .

The field cannot be simply removed because that would be change on the
kenel API to the userspace (and we don't like that).

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |  6 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  6 +++---
 drivers/media/v4l2-core/v4l2-ctrls.c               | 24 +++++++++++-----------
 drivers/media/v4l2-core/v4l2-ioctl.c               | 14 ++++++-------
 include/uapi/linux/videodev2.h                     |  5 +++++
 7 files changed, 32 insertions(+), 27 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 842536aae8b4..47f9fee91442 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -61,7 +61,7 @@ must belong to the same control class.</para>
 
     <para>Applications must always fill in the
 <structfield>count</structfield>,
-<structfield>ctrl_class</structfield>,
+<structfield>which</structfield>,
 <structfield>controls</structfield> and
 <structfield>reserved</structfield> fields of &v4l2-ext-controls;, and
 initialize the &v4l2-ext-control; array pointed to by the
@@ -109,7 +109,7 @@ the driver whether wrong values are automatically adjusted to a valid
 value or if an error is returned.</para>
 
     <para>When the <structfield>id</structfield> or
-<structfield>ctrl_class</structfield> is invalid drivers return an
+<structfield>which</structfield> is invalid drivers return an
 &EINVAL;. When the value is out of bounds drivers can choose to take
 the closest valid value or return an &ERANGE;, whatever seems more
 appropriate. In the first case the new value is set in
@@ -390,7 +390,7 @@ These controls are described in <xref linkend="rf-tuner-controls" />.</entry>
 	<listitem>
 	  <para>The &v4l2-ext-control; <structfield>id</structfield>
 is invalid, the &v4l2-ext-controls;
-<structfield>ctrl_class</structfield> is invalid, or the &v4l2-ext-control;
+<structfield>which</structfield> is invalid, or the &v4l2-ext-control;
 <structfield>value</structfield> was inappropriate (e.g. the given menu
 index is not supported by the driver). This error code is
 also returned by the <constant>VIDIOC_S_EXT_CTRLS</constant> and
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 8c5060a7534f..1c4998c221a2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1119,7 +1119,7 @@ const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void)
 	return &s5p_mfc_dec_ioctl_ops;
 }
 
-#define IS_MFC51_PRIV(x) ((V4L2_CTRL_ID2CLASS(x) == V4L2_CTRL_CLASS_MPEG) \
+#define IS_MFC51_PRIV(x) ((V4L2_CTRL_ID2WHICH(x) == V4L2_CTRL_CLASS_MPEG) \
 						&& V4L2_CTRL_DRIVER_PRIV(x))
 
 int s5p_mfc_dec_ctrls_setup(struct s5p_mfc_ctx *ctx)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 5c678ec9c9f2..115b7dac1d4c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -2067,7 +2067,7 @@ const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void)
 	return &s5p_mfc_enc_ioctl_ops;
 }
 
-#define IS_MFC51_PRIV(x) ((V4L2_CTRL_ID2CLASS(x) == V4L2_CTRL_CLASS_MPEG) \
+#define IS_MFC51_PRIV(x) ((V4L2_CTRL_ID2WHICH(x) == V4L2_CTRL_CLASS_MPEG) \
 						&& V4L2_CTRL_DRIVER_PRIV(x))
 
 int s5p_mfc_enc_ctrls_setup(struct s5p_mfc_ctx *ctx)
diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 327e83ac2469..8fd84a67478a 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -630,7 +630,7 @@ static inline int put_v4l2_input32(struct v4l2_input *kp, struct v4l2_input32 __
 }
 
 struct v4l2_ext_controls32 {
-	__u32 ctrl_class;
+	__u32 which;
 	__u32 count;
 	__u32 error_idx;
 	__u32 reserved[2];
@@ -673,7 +673,7 @@ static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	compat_caddr_t p;
 
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_ext_controls32)) ||
-		get_user(kp->ctrl_class, &up->ctrl_class) ||
+		get_user(kp->which, &up->which) ||
 		get_user(kp->count, &up->count) ||
 		get_user(kp->error_idx, &up->error_idx) ||
 		copy_from_user(kp->reserved, up->reserved,
@@ -723,7 +723,7 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
 	compat_caddr_t p;
 
 	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_ext_controls32)) ||
-		put_user(kp->ctrl_class, &up->ctrl_class) ||
+		put_user(kp->which, &up->which) ||
 		put_user(kp->count, &up->count) ||
 		put_user(kp->error_idx, &up->error_idx) ||
 		copy_to_user(up->reserved, kp->reserved, sizeof(up->reserved)))
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 4a1d9fdd14bb..cf8388407d68 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1762,7 +1762,7 @@ static struct v4l2_ctrl_ref *find_private_ref(
 	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
 		/* Search for private user controls that are compatible with
 		   VIDIOC_G/S_CTRL. */
-		if (V4L2_CTRL_ID2CLASS(ref->ctrl->id) == V4L2_CTRL_CLASS_USER &&
+		if (V4L2_CTRL_ID2WHICH(ref->ctrl->id) == V4L2_CTRL_CLASS_USER &&
 		    V4L2_CTRL_DRIVER_PRIV(ref->ctrl->id)) {
 			if (!ref->ctrl->is_int)
 				continue;
@@ -1831,7 +1831,7 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
 	struct v4l2_ctrl_ref *ref;
 	struct v4l2_ctrl_ref *new_ref;
 	u32 id = ctrl->id;
-	u32 class_ctrl = V4L2_CTRL_ID2CLASS(id) | 1;
+	u32 class_ctrl = V4L2_CTRL_ID2WHICH(id) | 1;
 	int bucket = id % hdl->nr_of_buckets;	/* which bucket to use */
 
 	/*
@@ -2253,9 +2253,9 @@ EXPORT_SYMBOL(v4l2_ctrl_add_handler);
 
 bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl)
 {
-	if (V4L2_CTRL_ID2CLASS(ctrl->id) == V4L2_CTRL_CLASS_FM_TX)
+	if (V4L2_CTRL_ID2WHICH(ctrl->id) == V4L2_CTRL_CLASS_FM_TX)
 		return true;
-	if (V4L2_CTRL_ID2CLASS(ctrl->id) == V4L2_CTRL_CLASS_FM_RX)
+	if (V4L2_CTRL_ID2WHICH(ctrl->id) == V4L2_CTRL_CLASS_FM_RX)
 		return true;
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_MUTE:
@@ -2710,7 +2710,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 
 		cs->error_idx = i;
 
-		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
+		if (cs->which && V4L2_CTRL_ID2WHICH(id) != cs->which)
 			return -EINVAL;
 
 		/* Old-style private controls are not allowed for
@@ -2787,11 +2787,11 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
 /* Handles the corner case where cs->count == 0. It checks whether the
    specified control class exists. If that class ID is 0, then it checks
    whether there are any controls at all. */
-static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
+static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
 {
-	if (ctrl_class == 0)
+	if (!which)
 		return list_empty(&hdl->ctrl_refs) ? -EINVAL : 0;
-	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
+	return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
 }
 
 
@@ -2805,13 +2805,13 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
 	int i, j;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	cs->which = V4L2_CTRL_ID2WHICH(cs->which);
 
 	if (hdl == NULL)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return class_check(hdl, cs->which);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
@@ -3064,13 +3064,13 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
 	int ret;
 
 	cs->error_idx = cs->count;
-	cs->ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
+	cs->which = V4L2_CTRL_ID2WHICH(cs->which);
 
 	if (hdl == NULL)
 		return -EINVAL;
 
 	if (cs->count == 0)
-		return class_check(hdl, cs->ctrl_class);
+		return class_check(hdl, cs->which);
 
 	if (cs->count > ARRAY_SIZE(helper)) {
 		helpers = kmalloc_array(cs->count, sizeof(helper[0]),
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7486af2c8ae4..8a018c6dd16a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -565,8 +565,8 @@ static void v4l_print_ext_controls(const void *arg, bool write_only)
 	const struct v4l2_ext_controls *p = arg;
 	int i;
 
-	pr_cont("class=0x%x, count=%d, error_idx=%d",
-			p->ctrl_class, p->count, p->error_idx);
+	pr_cont("which=0x%x, count=%d, error_idx=%d",
+			p->which, p->count, p->error_idx);
 	for (i = 0; i < p->count; i++) {
 		if (!p->controls[i].size)
 			pr_cont(", id/val=0x%x/0x%x",
@@ -902,13 +902,13 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	   Only when passed in through VIDIOC_G_CTRL and VIDIOC_S_CTRL
 	   is it allowed for backwards compatibility.
 	 */
-	if (!allow_priv && c->ctrl_class == V4L2_CID_PRIVATE_BASE)
+	if (!allow_priv && c->which == V4L2_CID_PRIVATE_BASE)
 		return 0;
-	if (c->ctrl_class == 0)
+	if (!c->which)
 		return 1;
 	/* Check that all controls are from the same control class. */
 	for (i = 0; i < c->count; i++) {
-		if (V4L2_CTRL_ID2CLASS(c->controls[i].id) != c->ctrl_class) {
+		if (V4L2_CTRL_ID2WHICH(c->controls[i].id) != c->which) {
 			c->error_idx = i;
 			return 0;
 		}
@@ -1969,7 +1969,7 @@ static int v4l_g_ctrl(const struct v4l2_ioctl_ops *ops,
 	if (ops->vidioc_g_ext_ctrls == NULL)
 		return -ENOTTY;
 
-	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
+	ctrls.which = V4L2_CTRL_ID2WHICH(p->id);
 	ctrls.count = 1;
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
@@ -2003,7 +2003,7 @@ static int v4l_s_ctrl(const struct v4l2_ioctl_ops *ops,
 	if (ops->vidioc_s_ext_ctrls == NULL)
 		return -ENOTTY;
 
-	ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(p->id);
+	ctrls.which = V4L2_CTRL_ID2WHICH(p->id);
 	ctrls.count = 1;
 	ctrls.controls = &ctrl;
 	ctrl.id = p->id;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 4d88ee2d268e..bd2dc9431ac1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1477,7 +1477,9 @@ struct v4l2_ext_control {
 
 struct v4l2_ext_controls {
 	union {
+#ifndef __KERNEL__
 		__u32 ctrl_class;
+#endif
 		__u32 which;
 	};
 	__u32 count;
@@ -1487,7 +1489,10 @@ struct v4l2_ext_controls {
 };
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
+#ifndef __KERNEL__
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
+#endif
+#define V4L2_CTRL_ID2WHICH(id)    ((id) & 0x0fff0000UL)
 #define V4L2_CTRL_DRIVER_PRIV(id) (((id) & 0xffff) >= 0x1000)
 #define V4L2_CTRL_MAX_DIMS	  (4)
 #define V4L2_CTRL_WHICH_CUR_VAL   0
-- 
2.6.1

