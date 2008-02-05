Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m152D68J014189
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 21:13:06 -0500
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m152CV8s019238
	for <video4linux-list@redhat.com>; Mon, 4 Feb 2008 21:12:31 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <88a377fb918b28696d08.1202176998@localhost>
In-Reply-To: <patchbomb.1202176995@localhost>
Date: Mon, 04 Feb 2008 18:03:18 -0800
From: Brandon Philips <brandon@ifup.org>
To: mchehab@infradead.org, laurent.pinchart@skynet.be
Cc: v4l-dvb-maintainer@linuxtv.org,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	video4linux-list@redhat.com
Subject: [PATCH 3 of 3] [v4l] Add camera class control definitions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

# HG changeset patch
# User Brandon Philips <brandon@ifup.org>
# Date 1201510166 28800
# Node ID 88a377fb918b28696d086194cb25951667b0c7f9
# Parent  a030ada87143b0e559aecb0bbd9fc1ed7384d0be
[v4l] Add camera class control definitions

Add all of the recently proposed camera class controls.  These controls
should appear in the next version of the v4l2spec.

Signed-off-by: Brandon Philips <bphilips@suse.de>

diff --git a/linux/include/linux/videodev2.h b/linux/include/linux/videodev2.h
--- a/linux/include/linux/videodev2.h
+++ b/linux/include/linux/videodev2.h
@@ -792,6 +792,7 @@ struct v4l2_ext_controls
 /*  Values for ctrl_class field */
 #define V4L2_CTRL_CLASS_USER 0x00980000	/* Old-style 'user' controls */
 #define V4L2_CTRL_CLASS_MPEG 0x00990000	/* MPEG-compression controls */
+#define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1063,6 +1064,32 @@ enum v4l2_mpeg_cx2341x_video_median_filt
 #define V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP 	(V4L2_CID_MPEG_CX2341X_BASE+10)
 #define V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS 	(V4L2_CID_MPEG_CX2341X_BASE+11)
 
+/*  Camera class control IDs */
+#define V4L2_CID_CAMERA_CLASS_BASE 	(V4L2_CTRL_CLASS_CAMERA | 0x900)
+#define V4L2_CID_CAMERA_CLASS 		(V4L2_CTRL_CLASS_CAMERA | 1)
+
+#define V4L2_CID_EXPOSURE_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+1)
+enum  v4l2_exposure_auto_type {
+	V4L2_EXPOSURE_AUTO = 0,
+	V4L2_EXPOSURE_MANUAL = 1,
+	V4L2_EXPOSURE_SHUTTER_PRIORITY = 2,
+	V4L2_EXPOSURE_APERTURE_PRIORITY = 3
+};
+#define V4L2_CID_EXPOSURE_ABSOLUTE		(V4L2_CID_CAMERA_CLASS_BASE+2)
+#define V4L2_CID_EXPOSURE_AUTO_PRIORITY		(V4L2_CID_CAMERA_CLASS_BASE+3)
+
+#define V4L2_CID_PAN_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+4)
+#define V4L2_CID_TILT_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+5)
+#define V4L2_CID_PAN_RESET			(V4L2_CID_CAMERA_CLASS_BASE+6)
+#define V4L2_CID_TILT_RESET			(V4L2_CID_CAMERA_CLASS_BASE+7)
+
+#define V4L2_CID_PAN_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+8)
+#define V4L2_CID_TILT_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+9)
+
+#define V4L2_CID_FOCUS_ABSOLUTE			(V4L2_CID_CAMERA_CLASS_BASE+10)
+#define V4L2_CID_FOCUS_RELATIVE			(V4L2_CID_CAMERA_CLASS_BASE+11)
+#define V4L2_CID_FOCUS_AUTO			(V4L2_CID_CAMERA_CLASS_BASE+12)
+
 /*
  *	T U N I N G
  */

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
