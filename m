Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54419 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbbEFG5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 May 2015 02:57:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 3/8] videodev2.h: add V4L2_CAP_ENTITY to querycap
Date: Wed,  6 May 2015 08:57:18 +0200
Message-Id: <1430895443-41839-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
References: <1430895443-41839-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add a capability to indicate that this device is a media entity.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-querycap.xml | 6 ++++++
 drivers/media/v4l2-core/v4l2-ioctl.c                | 5 +++++
 include/uapi/linux/videodev2.h                      | 1 +
 3 files changed, 12 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index 20fda75..aaa5067 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -308,6 +308,12 @@ modulator programming see
 fields.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CAP_ENTITY</constant></entry>
+	    <entry>0x00400000</entry>
+	    <entry>The device is a media controller entity. If this
+capability is set, then you can call &MEDIA-IOC-DEVICE-INFO;.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CAP_READWRITE</constant></entry>
 	    <entry>0x01000000</entry>
 	    <entry>The device supports the <link
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 1476602..343f3e2 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1011,6 +1011,7 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
 static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
 	int ret;
 
@@ -1019,6 +1020,10 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 	ret = ops->vidioc_querycap(file, fh, cap);
 
 	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (vfd->entity.parent)
+		cap->capabilities |= V4L2_CAP_ENTITY;
+#endif
 	/*
 	 * Drivers MUST fill in device_caps, so check for this and
 	 * warn if it was forgotten.
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fa376f7..31cf9f1 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -348,6 +348,7 @@ struct v4l2_capability {
 
 #define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
 #define V4L2_CAP_EXT_PIX_FORMAT		0x00200000  /* Supports the extended pixel format */
+#define V4L2_CAP_ENTITY                 0x00400000  /* This is a Media Controller entity */
 
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
-- 
2.1.4

