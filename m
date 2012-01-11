Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:41453 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933969Ab2AKV1Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:16 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 08/23] v4l: Image source control class
Date: Wed, 11 Jan 2012 23:26:45 +0200
Message-Id: <1326317220-15339-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add image source control class. This control class is intended to contain
low level controls which deal with control of the image capture process ---
the A/D converter in image sensors, for example.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/controls.xml       |  112 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    6 +
 drivers/media/video/v4l2-ctrls.c                   |   15 +++
 include/linux/videodev2.h                          |   11 ++
 4 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 3bc5ee8..467ace3 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3356,6 +3356,118 @@ interface and may change in the future.</para>
       </table>
 
     </section>
+
+    <section id="image-source-controls">
+      <title>Image Source Control Reference</title>
+
+      <note>
+	<title>Experimental</title>
+
+	<para>This is an <link
+	linkend="experimental">experimental</link> interface and may
+	change in the future.</para>
+      </note>
+
+      <para>
+	The Image Source control class is intended for low-level
+	control of image source devices such as image sensors. The
+	devices feature an analogue to digital converter and a bus
+	transmitter to transmit the image data out of the device.
+      </para>
+
+      <table pgwide="1" frame="none" id="image-source-control-id">
+      <title>Image Source Control IDs</title>
+
+      <tgroup cols="4">
+	<colspec colname="c1" colwidth="1*" />
+	<colspec colname="c2" colwidth="6*" />
+	<colspec colname="c3" colwidth="2*" />
+	<colspec colname="c4" colwidth="6*" />
+	<spanspec namest="c1" nameend="c2" spanname="id" />
+	<spanspec namest="c2" nameend="c4" spanname="descr" />
+	<thead>
+	  <row>
+	    <entry spanname="id" align="left">ID</entry>
+	    <entry align="left">Type</entry>
+	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row><entry></entry></row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_CLASS</constant></entry>
+	    <entry>class</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">The IMAGE_SOURCE class descriptor.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_VBLANK</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Vertical blanking. The idle
+	    preriod after every frame during which no image data is
+	    produced. The unit of vertical blanking is a line. Every
+	    line has length of the image width plus horizontal
+	    blanking at the pixel clock specified by struct
+	    v4l2_mbus_framefmt <xref linkend="v4l2-mbus-framefmt"
+	    />.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_HBLANK</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Horizontal blanking. The idle
+	    preriod after every line of image data during which no
+	    image data is produced. The unit of horizontal blanking is
+	    pixels.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_LINK_FREQ</constant></entry>
+	    <entry>integer menu</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Image source's data bus frequency.
+	    Together with the media bus pixel code, bus type (clock
+	    cycles per sample), the data bus frequency defines the
+	    pixel clock. <xref linkend="v4l2-mbus-framefmt" /> The
+	    frame rate can be calculated from the pixel clock, image
+	    width and height and horizontal and vertical blanking. The
+	    frame rate control is performed by selecting the desired
+	    horizontal and vertical blanking. The unit of this control
+	    is Hz.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN</constant></entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Analogue gain is gain affecting
+	    all colour components in the pixel matrix. The gain
+	    operation is performed in the analogue domain before A/D
+	    conversion.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_SOURCE_PIXEL_RATE</constant></entry>
+	    <entry>64-bit integer</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Pixel rate in the source pads of
+	    the subdev. This control is read-only and its unit is
+	    pixels / second.
+	    </entry>
+	  </row>
+	  <row><entry></entry></row>
+	</tbody>
+      </tgroup>
+      </table>
+
+    </section>
+
 </section>
 
   <!--
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index 5122ce8..250c1cf 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -257,6 +257,12 @@ These controls are described in <xref
 These controls are described in <xref
 		linkend="flash-controls" />.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_CLASS_IMAGE_SOURCE</constant></entry>
+	    <entry>0x9d0000</entry> <entry>The class containing image
+	    source controls. These controls are described in <xref
+	    linkend="image-source-controls" />.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 605d4dd..51b4559 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -606,6 +606,13 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_FLASH_CHARGE:		return "Charge";
 	case V4L2_CID_FLASH_READY:		return "Ready to strobe";
 
+	case V4L2_CID_IMAGE_SOURCE_CLASS:	return "Image source controls";
+	case V4L2_CID_IMAGE_SOURCE_VBLANK:	return "Vertical blanking";
+	case V4L2_CID_IMAGE_SOURCE_HBLANK:	return "Horizontal blanking";
+	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:	return "Link frequency";
+	case V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN: return "Analogue gain";
+	case V4L2_CID_IMAGE_SOURCE_PIXEL_RATE:	return "Pixel rate";
+
 	default:
 		return NULL;
 	}
@@ -694,6 +701,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
+	case V4L2_CID_IMAGE_SOURCE_LINK_FREQ:
+		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
+		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
 	case V4L2_CID_RDS_TX_RADIO_TEXT:
 		*type = V4L2_CTRL_TYPE_STRING;
@@ -703,6 +713,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_CLASS:
 	case V4L2_CID_FM_TX_CLASS:
 	case V4L2_CID_FLASH_CLASS:
+	case V4L2_CID_IMAGE_SOURCE_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -723,6 +734,10 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
+	case V4L2_CID_IMAGE_SOURCE_PIXEL_RATE:
+		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
+		*type = V4L2_CTRL_TYPE_INTEGER64;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 9633c69..c9d07c7 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1080,6 +1080,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_CAMERA 0x009a0000	/* Camera class controls */
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
 #define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
+#define V4L2_CTRL_CLASS_IMAGE_SOURCE 0x009d0000	/* Image source flash controls */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1690,6 +1691,16 @@ enum v4l2_flash_strobe_source {
 #define V4L2_CID_FLASH_CHARGE			(V4L2_CID_FLASH_CLASS_BASE + 11)
 #define V4L2_CID_FLASH_READY			(V4L2_CID_FLASH_CLASS_BASE + 12)
 
+/* Image source controls */
+#define V4L2_CID_IMAGE_SOURCE_CLASS_BASE	(V4L2_CTRL_CLASS_IMAGE_SOURCE | 0x900)
+#define V4L2_CID_IMAGE_SOURCE_CLASS		(V4L2_CTRL_CLASS_IMAGE_SOURCE | 1)
+
+#define V4L2_CID_IMAGE_SOURCE_VBLANK		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 1)
+#define V4L2_CID_IMAGE_SOURCE_HBLANK		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
+#define V4L2_CID_IMAGE_SOURCE_LINK_FREQ		(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 3)
+#define V4L2_CID_IMAGE_SOURCE_ANALOGUE_GAIN	(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 4)
+#define V4L2_CID_IMAGE_SOURCE_PIXEL_RATE	(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 5)
+
 /*
  *	T U N I N G
  */
-- 
1.7.2.5

