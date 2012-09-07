Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1853 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab2IGN3h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 09:29:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 API PATCH 10/28] Rename V4L2_(IN|OUT)_CAP_CUSTOM_TIMINGS.
Date: Fri,  7 Sep 2012 15:29:10 +0200
Message-Id: <0c01d1164be688b20ae03f51c700a31a7f154acc.1347023744.git.hans.verkuil@cisco.com>
In-Reply-To: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
References: <ea8cc4841a79893a29bafb9af7df2cb0f72af169.1347023744.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The 'custom' timings are no longer just for custom timings, but also for standard
CEA/VESA timings. So rename to V4L2_IN/OUT_CAP_DV_TIMINGS.

The old define is still kept for backwards compatibility.

This decision was taken during the 2012 Media Workshop.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/vidioc-enuminput.xml    |    2 +-
 Documentation/DocBook/media/v4l/vidioc-enumoutput.xml   |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml |    2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                    |    8 ++++----
 include/linux/videodev2.h                               |    6 ++++--
 5 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
index 46d5a04..3c9a813 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
@@ -283,7 +283,7 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
 	    <entry>This input supports setting DV presets by using VIDIOC_S_DV_PRESET.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_IN_CAP_CUSTOM_TIMINGS</constant></entry>
+	    <entry><constant>V4L2_IN_CAP_DV_TIMINGS</constant></entry>
 	    <entry>0x00000002</entry>
 	    <entry>This input supports setting video timings by using VIDIOC_S_DV_TIMINGS.</entry>
 	  </row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
index 4280200..f4ab079 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
@@ -168,7 +168,7 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
 	    <entry>This output supports setting DV presets by using VIDIOC_S_DV_PRESET.</entry>
 	  </row>
 	  <row>
-	    <entry><constant>V4L2_OUT_CAP_CUSTOM_TIMINGS</constant></entry>
+	    <entry><constant>V4L2_OUT_CAP_DV_TIMINGS</constant></entry>
 	    <entry>0x00000002</entry>
 	    <entry>This output supports setting video timings by using VIDIOC_S_DV_TIMINGS.</entry>
 	  </row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index feaa180..7236970 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -57,7 +57,7 @@ or the timing values are not correct, the driver returns &EINVAL;.</para>
 <para>The <filename>linux/v4l2-dv-timings.h</filename> header can be used to get the
 timings of the formats in the <xref linkend="cea861" /> and <xref linkend="vesadmt" />
 standards. If the current input or output does not support DV timings (e.g. if
-&VIDIOC-ENUMINPUT; does not set the <constant>V4L2_IN_CAP_CUSTOM_TIMINGS</constant> flag), then
+&VIDIOC-ENUMINPUT; does not set the <constant>V4L2_IN_CAP_DV_TIMINGS</constant> flag), then
 &ENODATA; is returned.</para>
   </refsect1>
 
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 473ebea..99a8ad7 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -982,7 +982,7 @@ static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_input *p = arg;
 
 	/*
-	 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
+	 * We set the flags for CAP_PRESETS, CAP_DV_TIMINGS &
 	 * CAP_STD here based on ioctl handler provided by the
 	 * driver. If the driver doesn't support these
 	 * for a specific input, it must override these flags.
@@ -992,7 +992,7 @@ static int v4l_enuminput(const struct v4l2_ioctl_ops *ops,
 	if (ops->vidioc_s_dv_preset)
 		p->capabilities |= V4L2_IN_CAP_PRESETS;
 	if (ops->vidioc_s_dv_timings)
-		p->capabilities |= V4L2_IN_CAP_CUSTOM_TIMINGS;
+		p->capabilities |= V4L2_IN_CAP_DV_TIMINGS;
 
 	return ops->vidioc_enum_input(file, fh, p);
 }
@@ -1003,7 +1003,7 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
 	struct v4l2_output *p = arg;
 
 	/*
-	 * We set the flags for CAP_PRESETS, CAP_CUSTOM_TIMINGS &
+	 * We set the flags for CAP_PRESETS, CAP_DV_TIMINGS &
 	 * CAP_STD here based on ioctl handler provided by the
 	 * driver. If the driver doesn't support these
 	 * for a specific output, it must override these flags.
@@ -1013,7 +1013,7 @@ static int v4l_enumoutput(const struct v4l2_ioctl_ops *ops,
 	if (ops->vidioc_s_dv_preset)
 		p->capabilities |= V4L2_OUT_CAP_PRESETS;
 	if (ops->vidioc_s_dv_timings)
-		p->capabilities |= V4L2_OUT_CAP_CUSTOM_TIMINGS;
+		p->capabilities |= V4L2_OUT_CAP_DV_TIMINGS;
 
 	return ops->vidioc_enum_output(file, fh, p);
 }
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index b06342b..47d58ed 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1190,7 +1190,8 @@ struct v4l2_input {
 
 /* capabilities flags */
 #define V4L2_IN_CAP_PRESETS		0x00000001 /* Supports S_DV_PRESET */
-#define V4L2_IN_CAP_CUSTOM_TIMINGS	0x00000002 /* Supports S_DV_TIMINGS */
+#define V4L2_IN_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
+#define V4L2_IN_CAP_CUSTOM_TIMINGS	V4L2_IN_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_IN_CAP_STD			0x00000004 /* Supports S_STD */
 
 /*
@@ -1213,7 +1214,8 @@ struct v4l2_output {
 
 /* capabilities flags */
 #define V4L2_OUT_CAP_PRESETS		0x00000001 /* Supports S_DV_PRESET */
-#define V4L2_OUT_CAP_CUSTOM_TIMINGS	0x00000002 /* Supports S_DV_TIMINGS */
+#define V4L2_OUT_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
+#define V4L2_OUT_CAP_CUSTOM_TIMINGS	V4L2_OUT_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_OUT_CAP_STD		0x00000004 /* Supports S_STD */
 
 /*
-- 
1.7.10.4

