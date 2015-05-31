Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:38310 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758215AbbEaNME (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2015 09:12:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 9/9] vivid.txt: update the vivid documentation
Date: Sun, 31 May 2015 15:11:39 +0200
Message-Id: <1433077899-18516-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
References: <1433077899-18516-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document the new Transfer Function control (and fix the documentation for
the other colorspace controls which were not quite correct).

Mention the support for 4:2:0 and more multiplanar formats.

Update the TODO list at the end.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/vivid.txt | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index cd4b5a1..0c1b3a6 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -631,26 +631,33 @@ Timestamp Source: selects when the timestamp for each buffer is taken.
 
 Colorspace: selects which colorspace should be used when generating the image.
 	This only applies if the CSC Colorbar test pattern is selected,
-	otherwise the test pattern will go through unconverted (except for
-	the so-called 'Transfer Function' corrections and the R'G'B' to Y'CbCr
-	conversion). This behavior is also what you want, since a 75% Colorbar
+	otherwise the test pattern will go through unconverted.
+	This behavior is also what you want, since a 75% Colorbar
 	should really have 75% signal intensity and should not be affected
 	by colorspace conversions.
 
 	Changing the colorspace will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a detected colorspace change.
 
+Transfer Function: selects which colorspace transfer function should be used when
+	generating an image. This only applies if the CSC Colorbar test pattern is
+	selected, otherwise the test pattern will go through unconverted.
+        This behavior is also what you want, since a 75% Colorbar
+        should really have 75% signal intensity and should not be affected
+        by colorspace conversions.
+
+	Changing the transfer function will result in the V4L2_EVENT_SOURCE_CHANGE
+	to be sent since it emulates a detected colorspace change.
+
 Y'CbCr Encoding: selects which Y'CbCr encoding should be used when generating
-	a Y'CbCr image.	This only applies if the CSC Colorbar test pattern is
-	selected, and if the format is set to a Y'CbCr format as opposed to an
-	RGB format.
+	a Y'CbCr image.	This only applies if the format is set to a Y'CbCr format
+	as opposed to an RGB format.
 
 	Changing the Y'CbCr encoding will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a detected colorspace change.
 
 Quantization: selects which quantization should be used for the RGB or Y'CbCr
-	encoding when generating the test pattern. This only applies if the CSC
-	Colorbar test pattern is selected.
+	encoding when generating the test pattern.
 
 	Changing the quantization will result in the V4L2_EVENT_SOURCE_CHANGE
 	to be sent since it emulates a detected colorspace change.
@@ -985,8 +992,9 @@ to change crop and compose rectangles on the fly.
 Section 12: Formats
 -------------------
 
-The driver supports all the regular packed YUYV formats, 16, 24 and 32 RGB
-packed formats and two multiplanar formats (one luma and one chroma plane).
+The driver supports all the regular packed and planar 4:4:4, 4:2:2 and 4:2:0
+YUYV formats, 8, 16, 24 and 32 RGB packed formats and various multiplanar
+formats.
 
 The alpha component can be set through the 'Alpha Component' User control
 for those formats that support it. If the 'Apply Alpha To Red Only' control
@@ -1119,11 +1127,9 @@ Just as a reminder and in no particular order:
 - Use per-queue locks and/or per-device locks to improve throughput
 - Add support to loop from a specific output to a specific input across
   vivid instances
-- Add support for VIDIOC_EXPBUF once support for that has been added to vb2
 - The SDR radio should use the same 'frequencies' for stations as the normal
   radio receiver, and give back noise if the frequency doesn't match up with
   a station frequency
-- Improve the sine generation of the SDR radio.
 - Make a thread for the RDS generation, that would help in particular for the
   "Controls" RDS Rx I/O Mode as the read-only RDS controls could be updated
   in real-time.
-- 
2.1.4

