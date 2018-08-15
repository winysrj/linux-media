Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38212 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729348AbeHOQdL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 12:33:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/5] vidioc-g-dv-timings.rst: document V4L2_DV_FL_CAN_DETECT_REDUCED_FPS
Date: Wed, 15 Aug 2018 15:40:52 +0200
Message-Id: <20180815134056.98830-2-hverkuil@xs4all.nl>
In-Reply-To: <20180815134056.98830-1-hverkuil@xs4all.nl>
References: <20180815134056.98830-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new V4L2_DV_FL_CAN_DETECT_REDUCED_FPS flag and
update the V4L2_DV_FL_REDUCED_FPS description since it can now
also be used with receivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../media/uapi/v4l/vidioc-g-dv-timings.rst    | 27 +++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index 1a034e825161..35cba2c8d459 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -257,14 +257,19 @@ EBUSY
 	will also be cleared. This is a read-only flag, applications must
 	not set this.
     * - ``V4L2_DV_FL_REDUCED_FPS``
-      - CEA-861 specific: only valid for video transmitters, the flag is
-	cleared by receivers. It is also only valid for formats with the
-	``V4L2_DV_FL_CAN_REDUCE_FPS`` flag set, for other formats the
-	flag will be cleared by the driver. If the application sets this
-	flag, then the pixelclock used to set up the transmitter is
-	divided by 1.001 to make it compatible with NTSC framerates. If
-	the transmitter can't generate such frequencies, then the flag
-	will also be cleared.
+      - CEA-861 specific: only valid for video transmitters or video
+        receivers that have the ``V4L2_DV_FL_CAN_DETECT_REDUCED_FPS``
+	set. This flag is cleared otherwise. It is also only valid for
+	formats with the ``V4L2_DV_FL_CAN_REDUCE_FPS`` flag set, for other
+	formats the flag will be cleared by the driver.
+
+	If the application sets this flag for a transmitter, then the
+	pixelclock used to set up the transmitter is divided by 1.001 to
+	make it compatible with NTSC framerates. If the transmitter can't
+	generate such frequencies, then the flag will be cleared.
+
+	If a video receiver detects that the format uses a reduced framerate,
+	then it will set this flag to signal this to the application.
     * - ``V4L2_DV_FL_HALF_LINE``
       - Specific to interlaced formats: if set, then the vertical
 	backporch of field 1 (aka the odd field) is really one half-line
@@ -294,3 +299,9 @@ EBUSY
       - If set, then the hdmi_vic field is valid and contains the Video
         Identification Code as per the HDMI standard (HDMI Vendor Specific
 	InfoFrame).
+    * - ``V4L2_DV_FL_CAN_DETECT_REDUCED_FPS``
+      - CEA-861 specific: only valid for video receivers, the flag is
+        cleared by transmitters.
+        If set, then the hardware can detect the difference between
+	regular framerates and framerates reduced by 1000/1001. E.g.:
+	60 vs 59.94 Hz, 30 vs 29.97 Hz or 24 vs 23.976 Hz.
-- 
2.18.0
