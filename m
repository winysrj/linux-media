Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:51497 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751174AbeECOx0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 10:53:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv13 07/28] videodev2.h: add request_fd field to v4l2_ext_controls
Date: Thu,  3 May 2018 16:52:57 +0200
Message-Id: <20180503145318.128315-8-hverkuil@xs4all.nl>
In-Reply-To: <20180503145318.128315-1-hverkuil@xs4all.nl>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alexandre Courbot <acourbot@chromium.org>

If 'which' is V4L2_CTRL_WHICH_REQUEST_VAL, then the 'request_fd' field
can be used to specify a request for the G/S/TRY_EXT_CTRLS ioctls.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 5 ++++-
 drivers/media/v4l2-core/v4l2-ioctl.c          | 6 +++---
 include/uapi/linux/videodev2.h                | 4 +++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 6481212fda77..dcce86c1fe40 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -834,7 +834,8 @@ struct v4l2_ext_controls32 {
 	__u32 which;
 	__u32 count;
 	__u32 error_idx;
-	__u32 reserved[2];
+	__s32 request_fd;
+	__u32 reserved[1];
 	compat_caddr_t controls; /* actually struct v4l2_ext_control32 * */
 };
 
@@ -909,6 +910,7 @@ static int get_v4l2_ext_controls32(struct file *file,
 	    get_user(count, &p32->count) ||
 	    put_user(count, &p64->count) ||
 	    assign_in_user(&p64->error_idx, &p32->error_idx) ||
+	    assign_in_user(&p64->request_fd, &p32->request_fd) ||
 	    copy_in_user(p64->reserved, p32->reserved, sizeof(p64->reserved)))
 		return -EFAULT;
 
@@ -974,6 +976,7 @@ static int put_v4l2_ext_controls32(struct file *file,
 	    get_user(count, &p64->count) ||
 	    put_user(count, &p32->count) ||
 	    assign_in_user(&p32->error_idx, &p64->error_idx) ||
+	    assign_in_user(&p32->request_fd, &p64->request_fd) ||
 	    copy_in_user(p32->reserved, p64->reserved, sizeof(p32->reserved)) ||
 	    get_user(kcontrols, &p64->controls))
 		return -EFAULT;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f48c505550e0..9ce23e23c5bf 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -553,8 +553,8 @@ static void v4l_print_ext_controls(const void *arg, bool write_only)
 	const struct v4l2_ext_controls *p = arg;
 	int i;
 
-	pr_cont("which=0x%x, count=%d, error_idx=%d",
-			p->which, p->count, p->error_idx);
+	pr_cont("which=0x%x, count=%d, error_idx=%d, request_fd=%d",
+			p->which, p->count, p->error_idx, p->request_fd);
 	for (i = 0; i < p->count; i++) {
 		if (!p->controls[i].size)
 			pr_cont(", id/val=0x%x/0x%x",
@@ -870,7 +870,7 @@ static int check_ext_ctrls(struct v4l2_ext_controls *c, int allow_priv)
 	__u32 i;
 
 	/* zero the reserved fields */
-	c->reserved[0] = c->reserved[1] = 0;
+	c->reserved[0] = 0;
 	for (i = 0; i < c->count; i++)
 		c->controls[i].reserved2[0] = 0;
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 600877be5c22..16b53b82496c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1592,7 +1592,8 @@ struct v4l2_ext_controls {
 	};
 	__u32 count;
 	__u32 error_idx;
-	__u32 reserved[2];
+	__s32 request_fd;
+	__u32 reserved[1];
 	struct v4l2_ext_control *controls;
 };
 
@@ -1605,6 +1606,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_MAX_DIMS	  (4)
 #define V4L2_CTRL_WHICH_CUR_VAL   0
 #define V4L2_CTRL_WHICH_DEF_VAL   0x0f000000
+#define V4L2_CTRL_WHICH_REQUEST_VAL 0x0f010000
 
 enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_INTEGER	     = 1,
-- 
2.17.0
