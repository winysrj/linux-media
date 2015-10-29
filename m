Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59729 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbbJ2E0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2015 00:26:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: jh1009.sung@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] DocBook media: update VIDIOC_CREATE_BUFS documentation
Date: Thu, 29 Oct 2015 05:24:26 +0100
Message-Id: <1446092666-2313-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1446092666-2313-1-git-send-email-hverkuil@xs4all.nl>
References: <1446092666-2313-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

During the Seoul media workshop we decided to relax the VIDIOC_CREATE_BUFS
specification so it would no longer require drivers to validate the format
field since almost no driver did that anyway.

Instead drivers use the buffer size(s) based on the format type and the
corresponding format fields and will ignore any other fields. If the size
cannot be used an error is returned, otherwise the size is used as-is.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-create-bufs.xml       | 30 ++++++++++------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 8ffe74f..d81fa0d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -58,7 +58,7 @@
     <para>This ioctl is used to create buffers for <link linkend="mmap">memory
 mapped</link> or <link linkend="userp">user pointer</link> or <link
 linkend="dmabuf">DMA buffer</link> I/O. It can be used as an alternative or in
-addition to the <constant>VIDIOC_REQBUFS</constant> ioctl, when a tighter
+addition to the &VIDIOC-REQBUFS; ioctl, when a tighter
 control over buffers is required. This ioctl can be called multiple times to
 create buffers of different sizes.</para>
 
@@ -71,30 +71,28 @@ zeroed.</para>
 
     <para>The <structfield>format</structfield> field specifies the image format
 that the buffers must be able to handle. The application has to fill in this
-&v4l2-format;. Usually this will be done using the
-<constant>VIDIOC_TRY_FMT</constant> or <constant>VIDIOC_G_FMT</constant> ioctl()
-to ensure that the requested format is supported by the driver. Unsupported
-formats will result in an error.</para>
+&v4l2-format;. Usually this will be done using the &VIDIOC-TRY-FMT; or &VIDIOC-G-FMT; ioctls
+to ensure that the requested format is supported by the driver.
+Based on the format's <structfield>type</structfield> field the requested buffer
+size (for single-planar) or plane sizes (for multi-planar formats) will be
+used for the allocated buffers. The driver may return an error if the size(s)
+are not supported by the hardware (usually because they are too small).</para>
 
     <para>The buffers created by this ioctl will have as minimum size the size
-defined by the <structfield>format.pix.sizeimage</structfield> field. If the
+defined by the <structfield>format.pix.sizeimage</structfield> field (or the
+corresponding fields for other format types). Usually if the
 <structfield>format.pix.sizeimage</structfield> field is less than the minimum
-required for the given format, then <structfield>sizeimage</structfield> will be
-increased by the driver to that minimum to allocate the buffers. If it is
-larger, then the value will be used as-is. The same applies to the
-<structfield>sizeimage</structfield> field of the
-<structname>v4l2_plane_pix_format</structname> structure in the case of
-multiplanar formats.</para>
+required for the given format, then an error will be returned since drivers will
+typically not allow this. If it is larger, then the value will be used as-is.
+In other words, the driver may reject the requested size, but if it is accepted
+the driver will use it unchanged.</para>
 
     <para>When the ioctl is called with a pointer to this structure the driver
 will attempt to allocate up to the requested number of buffers and store the
 actual number allocated and the starting index in the
 <structfield>count</structfield> and the <structfield>index</structfield> fields
 respectively. On return <structfield>count</structfield> can be smaller than
-the number requested. The driver may also increase buffer sizes if required,
-however, it will not update <structfield>sizeimage</structfield> field values.
-The user has to use <constant>VIDIOC_QUERYBUF</constant> to retrieve that
-information.</para>
+the number requested.</para>
 
     <table pgwide="1" frame="none" id="v4l2-create-buffers">
       <title>struct <structname>v4l2_create_buffers</structname></title>
-- 
2.1.4

