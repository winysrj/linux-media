Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36388 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2KXOVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Nov 2012 09:21:43 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3788808eek.19
        for <linux-media@vger.kernel.org>; Sat, 24 Nov 2012 06:21:42 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH RFC] V4L: Remove deprecated image centering controls
Date: Sat, 24 Nov 2012 15:21:21 +0100
Message-Id: <1353766881-16772-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It has been over 3 years since the V4L2_CID_[HV]CENTER were deprecated.
Clean up the DocBook and remove the V4L2_CID_VCENTER_DEPRECATED,
V4L2_CID_VCENTER_DEPRECATED control related paragraphs.
Remove the V4L2_CID_[HV]CENTER controls definitions from v4l2-controls.h,
these controls are not used by any driver in the mainline now.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |   23 -----------------------
 drivers/media/v4l2-core/v4l2-ctrls.c         |    2 --
 include/uapi/linux/v4l2-controls.h           |    4 ----
 3 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 7fe5be1..9e8f854 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -203,29 +203,6 @@ and should not be used in new drivers and applications.</entry>
 	    <entry>boolean</entry>
 	    <entry>Mirror the picture vertically.</entry>
 	  </row>
-	<row>
-	  <entry><constant>V4L2_CID_HCENTER_DEPRECATED</constant> (formerly <constant>V4L2_CID_HCENTER</constant>)</entry>
-	    <entry>integer</entry>
-	    <entry>Horizontal image centering. This control is
-deprecated. New drivers and applications should use the <link
-linkend="camera-controls">Camera class controls</link>
-<constant>V4L2_CID_PAN_ABSOLUTE</constant>,
-<constant>V4L2_CID_PAN_RELATIVE</constant> and
-<constant>V4L2_CID_PAN_RESET</constant> instead.</entry>
-	  </row>
-	  <row>
-	    <entry><constant>V4L2_CID_VCENTER_DEPRECATED</constant>
-	    (formerly <constant>V4L2_CID_VCENTER</constant>)</entry>
-	    <entry>integer</entry>
-	    <entry>Vertical image centering. Centering is intended to
-<emphasis>physically</emphasis> adjust cameras. For image cropping see
-<xref linkend="crop" />, for clipping <xref linkend="overlay" />. This
-control is deprecated. New drivers and applications should use the
-<link linkend="camera-controls">Camera class controls</link>
-<constant>V4L2_CID_TILT_ABSOLUTE</constant>,
-<constant>V4L2_CID_TILT_RELATIVE</constant> and
-<constant>V4L2_CID_TILT_RESET</constant> instead.</entry>
-	  </row>
 	  <row id="v4l2-power-line-frequency">
 	    <entry><constant>V4L2_CID_POWER_LINE_FREQUENCY</constant></entry>
 	    <entry>enum</entry>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index f6ee201..90f5ca6 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -577,8 +577,6 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_GAIN:			return "Gain";
 	case V4L2_CID_HFLIP:			return "Horizontal Flip";
 	case V4L2_CID_VFLIP:			return "Vertical Flip";
-	case V4L2_CID_HCENTER:			return "Horizontal Center";
-	case V4L2_CID_VCENTER:			return "Vertical Center";
 	case V4L2_CID_POWER_LINE_FREQUENCY:	return "Power Line Frequency";
 	case V4L2_CID_HUE_AUTO:			return "Hue, Automatic";
 	case V4L2_CID_WHITE_BALANCE_TEMPERATURE: return "White Balance Temperature";
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index f56c945..4dc0822 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -88,2 +88,2 @@
 #define V4L2_CID_HFLIP			(V4L2_CID_BASE+20)
 #define V4L2_CID_VFLIP			(V4L2_CID_BASE+21)

-/* Deprecated; use V4L2_CID_PAN_RESET and V4L2_CID_TILT_RESET */
-#define V4L2_CID_HCENTER		(V4L2_CID_BASE+22)
-#define V4L2_CID_VCENTER		(V4L2_CID_BASE+23)
-
 #define V4L2_CID_POWER_LINE_FREQUENCY	(V4L2_CID_BASE+24)
 enum v4l2_power_line_frequency {
 	V4L2_CID_POWER_LINE_FREQUENCY_DISABLED	= 0,
--
1.7.4.1

