Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:40163 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728326AbeKBIiM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Nov 2018 04:38:12 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 17/30] v4l: subdev: compat: Implement handling for VIDIOC_SUBDEV_[GS]_ROUTING
Date: Fri,  2 Nov 2018 00:31:31 +0100
Message-Id: <20181101233144.31507-18-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181101233144.31507-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

Implement compat IOCTL handling for VIDIOC_SUBDEV_G_ROUTING and
VIDIOC_SUBDEV_S_ROUTING IOCTLs.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 77 +++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 6481212fda772c73..83af332763f41a6b 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1045,6 +1045,66 @@ static int put_v4l2_event32(struct v4l2_event __user *p64,
 	return 0;
 }
 
+struct v4l2_subdev_routing32 {
+	compat_caddr_t routes;
+	__u32 num_routes;
+	__u32 reserved[5];
+};
+
+static int get_v4l2_subdev_routing(struct v4l2_subdev_routing __user *p64,
+				   struct v4l2_subdev_routing32 __user *p32)
+{
+	struct v4l2_subdev_route __user *routes;
+	compat_caddr_t p;
+	u32 num_routes;
+
+	if (!access_ok(VERIFY_READ, p32, sizeof(*p32)) ||
+	    get_user(p, &p32->routes) ||
+	    get_user(num_routes, &p32->num_routes) ||
+	    put_user(num_routes, &p64->num_routes) ||
+	    copy_in_user(&p64->reserved, &p32->reserved,
+			 sizeof(p64->reserved)) ||
+	    num_routes > U32_MAX / sizeof(*p64->routes))
+		return -EFAULT;
+
+	routes = compat_ptr(p);
+
+	if (!access_ok(VERIFY_READ, routes,
+		       num_routes * sizeof(*p64->routes)))
+		return -EFAULT;
+
+	if (put_user((__force struct v4l2_subdev_route *)routes,
+		     &p64->routes))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int put_v4l2_subdev_routing(struct v4l2_subdev_routing __user *p64,
+				   struct v4l2_subdev_routing32 __user *p32)
+{
+	struct v4l2_subdev_route __user *routes;
+	compat_caddr_t p;
+	u32 num_routes;
+
+	if (!access_ok(VERIFY_WRITE, p32, sizeof(*p32)) ||
+	    get_user(p, &p32->routes) ||
+	    get_user(num_routes, &p64->num_routes) ||
+	    put_user(num_routes, &p32->num_routes) ||
+	    copy_in_user(&p32->reserved, &p64->reserved,
+			 sizeof(p64->reserved)) ||
+	    num_routes > U32_MAX / sizeof(*p64->routes))
+		return -EFAULT;
+
+	routes = compat_ptr(p);
+
+	if (!access_ok(VERIFY_WRITE, routes,
+		       num_routes * sizeof(*p64->routes)))
+		return -EFAULT;
+
+	return 0;
+}
+
 struct v4l2_edid32 {
 	__u32 pad;
 	__u32 start_block;
@@ -1117,6 +1177,8 @@ static int put_v4l2_edid32(struct v4l2_edid __user *p64,
 #define VIDIOC_STREAMOFF32	_IOW ('V', 19, s32)
 #define VIDIOC_G_INPUT32	_IOR ('V', 38, s32)
 #define VIDIOC_S_INPUT32	_IOWR('V', 39, s32)
+#define VIDIOC_SUBDEV_G_ROUTING32 _IOWR('V', 38, struct v4l2_subdev_routing32)
+#define VIDIOC_SUBDEV_S_ROUTING32 _IOWR('V', 39, struct v4l2_subdev_routing32)
 #define VIDIOC_G_OUTPUT32	_IOR ('V', 46, s32)
 #define VIDIOC_S_OUTPUT32	_IOWR('V', 47, s32)
 
@@ -1195,6 +1257,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	case VIDIOC_STREAMOFF32: cmd = VIDIOC_STREAMOFF; break;
 	case VIDIOC_G_INPUT32: cmd = VIDIOC_G_INPUT; break;
 	case VIDIOC_S_INPUT32: cmd = VIDIOC_S_INPUT; break;
+	case VIDIOC_SUBDEV_G_ROUTING32: cmd = VIDIOC_SUBDEV_G_ROUTING; break;
+	case VIDIOC_SUBDEV_S_ROUTING32: cmd = VIDIOC_SUBDEV_S_ROUTING; break;
 	case VIDIOC_G_OUTPUT32: cmd = VIDIOC_G_OUTPUT; break;
 	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
 	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
@@ -1227,6 +1291,15 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
+	case VIDIOC_SUBDEV_G_ROUTING:
+	case VIDIOC_SUBDEV_S_ROUTING:
+		err = alloc_userspace(sizeof(struct v4l2_subdev_routing),
+				      0, &new_p64);
+		if (!err)
+			err = get_v4l2_subdev_routing(new_p64, p32);
+		compatible_arg = 0;
+		break;
+
 	case VIDIOC_G_EDID:
 	case VIDIOC_S_EDID:
 		err = alloc_userspace(sizeof(struct v4l2_edid), 0, &new_p64);
@@ -1368,6 +1441,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		if (put_v4l2_edid32(new_p64, p32))
 			err = -EFAULT;
 		break;
+	case VIDIOC_SUBDEV_G_ROUTING:
+	case VIDIOC_SUBDEV_S_ROUTING:
+		err = put_v4l2_subdev_routing(new_p64, p32);
+		break;
 	}
 	if (err)
 		return err;
-- 
2.19.1
