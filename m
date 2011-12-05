Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44839 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab1LET5H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Dec 2011 14:57:07 -0500
Received: by bkbzv3 with SMTP id zv3so2288326bkb.19
        for <linux-media@vger.kernel.org>; Mon, 05 Dec 2011 11:57:05 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	hverkuil@xs3all.nl, riverful.kim@samsung.com,
	s.nawrocki@samsung.com, Sylwester Nawrocki <snjw23@gmail.com>
Subject: [RFC/PATCH] v4l: Add V4L2_CID_FLASH_HW_STROBE_MODE control
Date: Mon,  5 Dec 2011 20:56:46 +0100
Message-Id: <1323115006-4385-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_CID_FLASH_HW_STROBE_MODE mode control is intended
for devices that are source of an external flash strobe for flash
devices. This part seems to be missing in current Flash control
class, i.e. a means for configuring devices that are not camera
flash drivers but involve a flash related functionality.

The V4L2_CID_FLASH_HW_STROBE_MODE control enables the user
to determine the flash control behavior, for instance, at an image
sensor device.

The control has effect only when V4L2_CID_FLASH_STROBE_SOURCE control
is set to V4L2_FLASH_STROBE_SOURCE_EXTERNAL at a flash subdev, if
a flash subdev is present in the system.

Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---

Hi Sakari,

My apologies for not bringing this earlier when you were designing
the Flash control API.
It seems like a use case were a sensor controller drives a strobe
signal for a Flash and the sensor side requires some set up doesn't
quite fit in the Flash Control API.

Or is there already a control allowing to set Flash strobe mode at
the sensor to: OFF, ON (per each exposed frame), AUTO ?

--

Regards,
Sylwester
---
 Documentation/DocBook/media/v4l/controls.xml |   30 ++++++++++++++++++++++++++
 drivers/media/video/v4l2-ctrls.c             |    2 +
 include/linux/videodev2.h                    |    7 ++++++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 48a0434..1745187 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3462,6 +3462,36 @@ interface and may change in the future.</para>
 	    after strobe during which another strobe will not be
 	    possible. This is a read-only control.</entry>
 	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FLASH_HW_STROBE_MODE</constant></entry>
+	    <entry>menu</entry>
+	  </row>
+	  <row id="v4l2-flash-hw-strobe-mode">
+	    <entry spanname="descr">Determines the mode of hardware flash strobe
+	    at the device external to a flash controller, e.g. image sensor. This
+	    control has effect only when <constant>V4L2_CID_FLASH_STROBE_SOURCE
+	    </constant> is set to <constant>V4L2_FLASH_STROBE_SOURCE_EXTERNAL
+	    </constant> at the flash controller.
+            </entry>
+	  </row>
+	  <row>
+	    <entrytbl spanname="descr" cols="2">
+	      <tbody valign="top">
+		<row>
+		  <entry><constant>V4L2_FLASH_HW_STROBE_MODE_OFF</constant></entry>
+		  <entry>Flash strobe disabled.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_HW_STROBE_MODE_ON</constant></entry>
+		  <entry>Flash strobe enabled for each exposed frame.</entry>
+		</row>
+		<row>
+		  <entry><constant>V4L2_FLASH_HW_STROBE_MODE_AUTO</constant></entry>
+		  <entry>Flash strobe determined automatically.</entry>
+		</row>
+	      </tbody>
+	    </entrytbl>
+	  </row>
 	  <row><entry></entry></row>
 	</tbody>
       </tgroup>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 96ec73d..0d188e3 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -619,6 +619,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_FAULT:		return "Faults";
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
+	case V4L2_CID_FLASH_HW_STROBE_MODE:	return "Hardware strobe mode";

 	default:
 		return NULL;
@@ -699,6 +700,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_TUNE_PREEMPHASIS:
 	case V4L2_CID_FLASH_LED_MODE:
 	case V4L2_CID_FLASH_STROBE_SOURCE:
+	case V4L2_CID_FLASH_HW_STROBE_MODE:
 	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
 	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
 	case V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index d43149c..7ffb47d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1705,6 +1705,13 @@ enum v4l2_flash_strobe_source {
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)

+#define V4L2_CID_FLASH_HW_STROBE_MODE		(V4L2_CID_FLASH_CLASS_BASE + 13)
+enum v4l2_flash_hw_strobe_mode {
+	V4L2_FLASH_HW_STROBE_OFF,
+	V4L2_FLASH_HW_STROBE_ON,
+	V4L2_FLASH_HW_STROBE_AUTO,
+};
+
 /*
  *	T U N I N G
  */
--
1.7.4.1

