Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:56684 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbbCOUv7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2015 16:51:59 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 2A5C72A0083
	for <linux-media@vger.kernel.org>; Sun, 15 Mar 2015 21:51:54 +0100 (CET)
Message-ID: <5505F0EA.3090901@xs4all.nl>
Date: Sun, 15 Mar 2015 21:51:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: DocBook media: fix VIDIOC_CROPCAP type description
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The type field of VIDIOC_CROPCAP does not allow the MPLANE variants, just
as all the other crop/selection related ioctls.

Fix the description of CROPCAP and G_CROP and make the text describing
this consistent for all selection ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
index 1f5ed64..50cb940 100644
--- a/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-cropcap.xml
@@ -59,6 +59,11 @@ constant except when switching the video standard. Remember this
 switch can occur implicit when switching the video input or
 output.</para>
 
+<para>Do not use the multiplanar buffer types.  Use <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>
+instead of <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>
+and use <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> instead of
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>.</para>
+
     <para>This ioctl must be implemented for video capture or output devices that
 support cropping and/or scaling and/or have non-square pixels, and for overlay devices.</para>
 
@@ -73,9 +78,7 @@ support cropping and/or scaling and/or have non-square pixels, and for overlay d
 	    <entry>Type of the data stream, set by the application.
 Only these types are valid here:
 <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
-<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant> and
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> and
 <constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>. See <xref linkend="v4l2-buf-type" />.</entry>
 	  </row>
 	  <row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
index 75c6a93..e6c4efb 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-crop.xml
@@ -70,6 +70,11 @@ structure or returns the &EINVAL; if cropping is not supported.</para>
 <constant>VIDIOC_S_CROP</constant> ioctl with a pointer to this
 structure.</para>
 
+<para>Do not use the multiplanar buffer types.  Use <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>
+instead of <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>
+and use <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> instead of
+<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>.</para>
+
     <para>The driver first adjusts the requested dimensions against
 hardware limits, &ie; the bounds given by the capture/output window,
 and it rounds to the closest possible values of horizontal and
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
index 9c04ac8..0bb5c06 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
@@ -60,8 +60,8 @@
 
 <para>To query the cropping (composing) rectangle set &v4l2-selection;
 <structfield> type </structfield> field to the respective buffer type.
-Do not use multiplanar buffers.  Use <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>
-instead of <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>.  Use
+Do not use the multiplanar buffer types.  Use <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>
+instead of <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant> and use
 <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> instead of
 <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>.  The next step is
 setting the value of &v4l2-selection; <structfield>target</structfield> field
