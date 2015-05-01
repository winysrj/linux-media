Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57273 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbbEALeX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2015 07:34:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 3/3] videodev2.h: add entity_id to struct v4l2_capability
Date: Fri,  1 May 2015 13:33:50 +0200
Message-Id: <1430480030-29136-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430480030-29136-1-git-send-email-hverkuil@xs4all.nl>
References: <1430480030-29136-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Export the entity ID (if any) of the video device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-querycap.xml | 16 +++++++++++++++-
 drivers/media/v4l2-core/v4l2-ioctl.c                |  7 +++++++
 include/uapi/linux/videodev2.h                      |  5 ++++-
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index c1ed844..4a7737c 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -154,7 +154,14 @@ printf ("Version: %u.%u.%u\n",
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[3]</entry>
+	    <entry><structfield>entity_id</structfield></entry>
+	    <entry>The media controller entity ID of the device. This is only valid if
+	    the <constant>V4L2_CAP_ENTITY</constant> capability is set.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[2]</entry>
 	    <entry>Reserved for future extensions. Drivers must set
 this array to zero.</entry>
 	  </row>
@@ -308,6 +315,13 @@ modulator programming see
 fields.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CAP_ENTITY</constant></entry>
+	    <entry>0x00400000</entry>
+	    <entry>The device is a media controller entity and
+	    the <structfield>entity_id</structfield> field of &v4l2-capability;
+	    is valid.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CAP_READWRITE</constant></entry>
 	    <entry>0x01000000</entry>
 	    <entry>The device supports the <link
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 1476602..5179611 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1011,6 +1011,7 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
 static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
+	struct video_device *vfd = video_devdata(file);
 	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
 	int ret;
 
@@ -1019,6 +1020,12 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 	ret = ops->vidioc_querycap(file, fh, cap);
 
 	cap->capabilities |= V4L2_CAP_EXT_PIX_FORMAT;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	if (vfd->entity.parent) {
+		cap->capabilities |= V4L2_CAP_ENTITY;
+		cap->entity_id = vfd->entity.id;
+	}
+#endif
 	/*
 	 * Drivers MUST fill in device_caps, so check for this and
 	 * warn if it was forgotten.
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fa376f7..af7a667 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -307,6 +307,7 @@ struct v4l2_fract {
   * @version:	   KERNEL_VERSION
   * @capabilities: capabilities of the physical device as a whole
   * @device_caps:  capabilities accessed via this particular device (node)
+  * @entity_id:    the media controller entity ID
   * @reserved:	   reserved fields for future extensions
   */
 struct v4l2_capability {
@@ -316,7 +317,8 @@ struct v4l2_capability {
 	__u32   version;
 	__u32	capabilities;
 	__u32	device_caps;
-	__u32	reserved[3];
+	__u32	entity_id;
+	__u32	reserved[2];
 };
 
 /* Values for 'capabilities' field */
@@ -348,6 +350,7 @@ struct v4l2_capability {
 
 #define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
 #define V4L2_CAP_EXT_PIX_FORMAT		0x00200000  /* Supports the extended pixel format */
+#define V4L2_CAP_ENTITY                 0x00400000  /* This is a Media Controller entity */
 
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
-- 
2.1.4

