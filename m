Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:36990 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2HJLVc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 07:21:32 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, Soby Mathew <soby.mathew@st.com>,
	mats.randgaard@cisco.com, manjunath.hadli@ti.com,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	dri-devel@lists.freedesktop.org
Subject: [RFCv3 PATCH 1/8] v4l2 core: add the missing pieces to support DVI/HDMI/DisplayPort.
Date: Fri, 10 Aug 2012 13:21:17 +0200
Message-Id: <bf682233fde61ca77ed4512ba77271f6daeedb31.1344592468.git.hans.verkuil@cisco.com>
In-Reply-To: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
References: <1344597684-8413-1-git-send-email-hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These new controls and two new ioctls make it possible to properly support
VGA, DVI-A/D/I, HDMI and DisplayPort connectors. All these controls and the
ioctls are all at the sub-device level. They are meant for V4L2 bridge/platform
drivers or to be accessed on embedded systems through /dev/v4l-subdev* device
nodes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/linux/v4l2-subdev.h |   10 ++++++++++
 include/linux/videodev2.h   |   23 +++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
index 8c57ee9..a426a78 100644
--- a/include/linux/v4l2-subdev.h
+++ b/include/linux/v4l2-subdev.h
@@ -148,6 +148,14 @@ struct v4l2_subdev_selection {
 	__u32 reserved[8];
 };
 
+struct v4l2_subdev_edid {
+	__u32 pad;
+	__u32 start_block;
+	__u32 blocks;
+	__u32 reserved[5];
+	__u8 __user *edid;
+};
+
 #define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
 #define VIDIOC_SUBDEV_G_FRAME_INTERVAL \
@@ -166,5 +174,7 @@ struct v4l2_subdev_selection {
 	_IOWR('V', 61, struct v4l2_subdev_selection)
 #define VIDIOC_SUBDEV_S_SELECTION \
 	_IOWR('V', 62, struct v4l2_subdev_selection)
+#define VIDIOC_SUBDEV_G_EDID	_IOWR('V', 63, struct v4l2_subdev_edid)
+#define VIDIOC_SUBDEV_S_EDID	_IOWR('V', 64, struct v4l2_subdev_edid)
 
 #endif
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 7a147c8..91939a7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1250,6 +1250,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_JPEG 0x009d0000		/* JPEG-compression controls */
 #define V4L2_CTRL_CLASS_IMAGE_SOURCE 0x009e0000	/* Image source controls */
 #define V4L2_CTRL_CLASS_IMAGE_PROC 0x009f0000	/* Image processing controls */
+#define V4L2_CTRL_CLASS_DV 0x00a00000		/* Digital Video controls */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1993,6 +1994,28 @@ enum v4l2_jpeg_chroma_subsampling {
 #define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
 #define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
 
+/*  DV-class control IDs defined by V4L2 */
+#define V4L2_CID_DV_CLASS_BASE			(V4L2_CTRL_CLASS_DV | 0x900)
+#define V4L2_CID_DV_CLASS			(V4L2_CTRL_CLASS_DV | 1)
+
+#define	V4L2_CID_DV_TX_HOTPLUG			(V4L2_CID_DV_CLASS_BASE + 1)
+#define	V4L2_CID_DV_TX_RXSENSE			(V4L2_CID_DV_CLASS_BASE + 2)
+#define	V4L2_CID_DV_TX_EDID_PRESENT		(V4L2_CID_DV_CLASS_BASE + 3)
+#define	V4L2_CID_DV_TX_MODE			(V4L2_CID_DV_CLASS_BASE + 4)
+enum v4l2_dv_tx_mode {
+	V4L2_DV_TX_MODE_DVI_D	= 0,
+	V4L2_DV_TX_MODE_HDMI	= 1,
+};
+#define V4L2_CID_DV_TX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 5)
+enum v4l2_dv_rgb_range {
+	V4L2_DV_RGB_RANGE_AUTO	  = 0,
+	V4L2_DV_RGB_RANGE_LIMITED = 1,
+	V4L2_DV_RGB_RANGE_FULL	  = 2,
+};
+
+#define	V4L2_CID_DV_RX_POWER_PRESENT		(V4L2_CID_DV_CLASS_BASE + 100)
+#define V4L2_CID_DV_RX_RGB_RANGE		(V4L2_CID_DV_CLASS_BASE + 101)
+
 /*
  *	T U N I N G
  */
-- 
1.7.10.4

