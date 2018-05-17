Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:18077 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752446AbeEQObM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 10:31:12 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2 2/2] v4l: Add support for STD ioctls on subdev nodes
Date: Thu, 17 May 2018 16:30:16 +0200
Message-Id: <20180517143016.13501-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180517143016.13501-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no way to control the standard of subdevices which are part of
a media device. The ioctls which exists all target video devices
explicitly and the idea is that the video device should talk to the
subdevice. For subdevices part of a media graph this is not possible and
the standard must be controlled on the subdev device directly.

Add four new ioctls to be able to directly interact with subdevices and
control the video standard; VIDIOC_SUBDEV_ENUMSTD, VIDIOC_SUBDEV_G_STD,
VIDIOC_SUBDEV_S_STD and VIDIOC_SUBDEV_QUERYSTD.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---

* Changes since v1
- Added VIDIOC_SUBDEV_ENUMSTD.
---
 .../media/uapi/v4l/vidioc-enumstd.rst         | 11 ++++++----
 Documentation/media/uapi/v4l/vidioc-g-std.rst | 14 ++++++++----
 .../media/uapi/v4l/vidioc-querystd.rst        | 11 ++++++----
 drivers/media/v4l2-core/v4l2-subdev.c         | 22 +++++++++++++++++++
 include/uapi/linux/v4l2-subdev.h              |  4 ++++
 5 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index b7fda29f46a139a0..2644a62acd4b6822 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -2,14 +2,14 @@
 
 .. _VIDIOC_ENUMSTD:
 
-********************
-ioctl VIDIOC_ENUMSTD
-********************
+*******************************************
+ioctl VIDIOC_ENUMSTD, VIDIOC_SUBDEV_ENUMSTD
+*******************************************
 
 Name
 ====
 
-VIDIOC_ENUMSTD - Enumerate supported video standards
+VIDIOC_ENUMSTD - VIDIOC_SUBDEV_ENUMSTD - Enumerate supported video standards
 
 
 Synopsis
@@ -18,6 +18,9 @@ Synopsis
 .. c:function:: int ioctl( int fd, VIDIOC_ENUMSTD, struct v4l2_standard *argp )
     :name: VIDIOC_ENUMSTD
 
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_ENUMSTD, struct v4l2_standard *argp )
+    :name: VIDIOC_SUBDEV_ENUMSTD
+
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
index 90791ab51a5371b8..8d94f0404df270db 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
@@ -2,14 +2,14 @@
 
 .. _VIDIOC_G_STD:
 
-********************************
-ioctl VIDIOC_G_STD, VIDIOC_S_STD
-********************************
+**************************************************************************
+ioctl VIDIOC_G_STD, VIDIOC_S_STD, VIDIOC_SUBDEV_G_STD, VIDIOC_SUBDEV_S_STD
+**************************************************************************
 
 Name
 ====
 
-VIDIOC_G_STD - VIDIOC_S_STD - Query or select the video standard of the current input
+VIDIOC_G_STD - VIDIOC_S_STD - VIDIOC_SUBDEV_G_STD - VIDIOC_SUBDEV_S_STD - Query or select the video standard of the current input
 
 
 Synopsis
@@ -21,6 +21,12 @@ Synopsis
 .. c:function:: int ioctl( int fd, VIDIOC_S_STD, const v4l2_std_id *argp )
     :name: VIDIOC_S_STD
 
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_STD, v4l2_std_id *argp )
+    :name: VIDIOC_SUBDEV_G_STD
+
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_STD, const v4l2_std_id *argp )
+    :name: VIDIOC_SUBDEV_S_STD
+
 
 Arguments
 =========
diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
index cf40bca19b9f8665..a8385cc7481869dd 100644
--- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
@@ -2,14 +2,14 @@
 
 .. _VIDIOC_QUERYSTD:
 
-*********************
-ioctl VIDIOC_QUERYSTD
-*********************
+*********************************************
+ioctl VIDIOC_QUERYSTD, VIDIOC_SUBDEV_QUERYSTD
+*********************************************
 
 Name
 ====
 
-VIDIOC_QUERYSTD - Sense the video standard received by the current input
+VIDIOC_QUERYSTD - VIDIOC_SUBDEV_QUERYSTD - Sense the video standard received by the current input
 
 
 Synopsis
@@ -18,6 +18,9 @@ Synopsis
 .. c:function:: int ioctl( int fd, VIDIOC_QUERYSTD, v4l2_std_id *argp )
     :name: VIDIOC_QUERYSTD
 
+.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_QUERYSTD, v4l2_std_id *argp )
+    :name: VIDIOC_SUBDEV_QUERYSTD
+
 
 Arguments
 =========
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index f9eed938d3480b74..27a2c633f2323f5f 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -494,6 +494,28 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 	case VIDIOC_SUBDEV_S_DV_TIMINGS:
 		return v4l2_subdev_call(sd, video, s_dv_timings, arg);
+
+	case VIDIOC_SUBDEV_G_STD:
+		return v4l2_subdev_call(sd, video, g_std, arg);
+
+	case VIDIOC_SUBDEV_S_STD: {
+		v4l2_std_id *std = arg;
+
+		return v4l2_subdev_call(sd, video, s_std, *std);
+	}
+
+	case VIDIOC_SUBDEV_ENUMSTD: {
+		struct v4l2_standard *p = arg;
+		v4l2_std_id id;
+
+		if (v4l2_subdev_call(sd, video, g_tvnorms, &id))
+			return -EINVAL;
+
+		return v4l_video_std_enumstd(p, id);
+	}
+
+	case VIDIOC_SUBDEV_QUERYSTD:
+		return v4l2_subdev_call(sd, video, querystd, arg);
 #endif
 	default:
 		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
index c95a53e6743cb040..03970ce3074193e6 100644
--- a/include/uapi/linux/v4l2-subdev.h
+++ b/include/uapi/linux/v4l2-subdev.h
@@ -170,8 +170,12 @@ struct v4l2_subdev_selection {
 #define VIDIOC_SUBDEV_G_SELECTION		_IOWR('V', 61, struct v4l2_subdev_selection)
 #define VIDIOC_SUBDEV_S_SELECTION		_IOWR('V', 62, struct v4l2_subdev_selection)
 /* The following ioctls are identical to the ioctls in videodev2.h */
+#define VIDIOC_SUBDEV_G_STD			_IOR('V', 23, v4l2_std_id)
+#define VIDIOC_SUBDEV_S_STD			_IOW('V', 24, v4l2_std_id)
+#define VIDIOC_SUBDEV_ENUMSTD			_IOWR('V', 25, struct v4l2_standard)
 #define VIDIOC_SUBDEV_G_EDID			_IOWR('V', 40, struct v4l2_edid)
 #define VIDIOC_SUBDEV_S_EDID			_IOWR('V', 41, struct v4l2_edid)
+#define VIDIOC_SUBDEV_QUERYSTD			_IOR('V', 63, v4l2_std_id)
 #define VIDIOC_SUBDEV_S_DV_TIMINGS		_IOWR('V', 87, struct v4l2_dv_timings)
 #define VIDIOC_SUBDEV_G_DV_TIMINGS		_IOWR('V', 88, struct v4l2_dv_timings)
 #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum_dv_timings)
-- 
2.17.0
