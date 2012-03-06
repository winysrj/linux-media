Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:22304 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2CFQd2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:28 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 12/35] v4l: Image processing control class
Date: Tue,  6 Mar 2012 18:32:53 +0200
Message-Id: <1331051596-8261-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add control class for image processing controls. The control class deals
with controls processing image, for example digital gain or noise filtering,
which can be present in any part of the pipeline.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/controls.xml       |   82 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    6 ++
 drivers/media/video/v4l2-ctrls.c                   |   13 +++
 include/linux/videodev2.h                          |    8 ++
 4 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 2257db4..4ca03f1 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3524,4 +3524,86 @@ interface and may change in the future.</para>
 
     </section>
 
+    <section id="image-process-controls">
+      <title>Image Process Control Reference</title>
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
+	The Image Source control class is intended for low-level control of
+	image processing functions. Unlike
+	<constant>V4L2_CID_IMAGE_SOURCE_CLASS</constant>, the controls in
+	this class affect processing the image, and do not control capturing
+	of it.
+      </para>
+
+      <table pgwide="1" frame="none" id="image-process-control-id">
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
+	    <entry spanname="id"><constant>V4L2_CID_IMAGE_PROC_CLASS</constant></entry>
+	    <entry>class</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">The IMAGE_PROC class descriptor.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_LINK_FREQ</constant></entry>
+	    <entry>integer menu</entry>
+	  </row>
+	  <row>
+	    <entry spanname="descr">Data bus frequency. Together with the
+	    media bus pixel code, bus type (clock cycles per sample), the
+	    data bus frequency defines the pixel rate
+	    (<constant>V4L2_CID_PIXEL_RATE</constant>) in the
+	    pixel array (or possibly elsewhere, if the device is not an
+	    image sensor). The frame rate can be calculated from the pixel
+	    clock, image width and height and horizontal and vertical
+	    blanking. While the pixel rate control may be defined elsewhere
+	    than in the subdev containing the pixel array, the frame rate
+	    cannot be obtained from that information. This is because only
+	    on the pixel array it can be assumed that the vertical and
+	    horizontal blanking information is exact: no other blanking is
+	    allowed in the pixel array. The selection of frame rate is
+	    performed by selecting the desired horizontal and vertical
+	    blanking. The unit of this control is Hz. </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_PIXEL_RATE</constant></entry>
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
 </section>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index f420034..f41a2f5 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -271,6 +271,12 @@ These controls are described in <xref
 	    source controls. These controls are described in <xref
 	    linkend="image-source-controls" />.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_CLASS_IMAGE_PROC</constant></entry>
+	    <entry>0x9e0000</entry> <entry>The class containing image
+	    processing controls. These controls are described in <xref
+	    linkend="image-process-controls" />.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 3ca6bc7..1cbf97f 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -629,6 +629,11 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_HBLANK:			return "Horizontal Blanking";
 	case V4L2_CID_ANALOGUE_GAIN:		return "Analogue Gain";
 
+	/* Image processing controls */
+	case V4L2_CID_IMAGE_PROC_CLASS:		return "Image Processing Controls";
+	case V4L2_CID_LINK_FREQ:		return "Link Frequency";
+	case V4L2_CID_PIXEL_RATE:		return "Pixel Rate";
+
 	default:
 		return NULL;
 	}
@@ -719,6 +724,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG4_PROFILE:
 		*type = V4L2_CTRL_TYPE_MENU;
 		break;
+	case V4L2_CID_LINK_FREQ:
+		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
+		break;
 	case V4L2_CID_RDS_TX_PS_NAME:
 	case V4L2_CID_RDS_TX_RADIO_TEXT:
 		*type = V4L2_CTRL_TYPE_STRING;
@@ -729,6 +737,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FM_TX_CLASS:
 	case V4L2_CID_FLASH_CLASS:
 	case V4L2_CID_IMAGE_SOURCE_CLASS:
+	case V4L2_CID_IMAGE_PROC_CLASS:
 		*type = V4L2_CTRL_TYPE_CTRL_CLASS;
 		/* You can neither read not write these */
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY;
@@ -754,6 +763,10 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 		*type = V4L2_CTRL_TYPE_INTEGER64;
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_VOLATILE;
 		break;
+	case V4L2_CID_PIXEL_RATE:
+		*type = V4L2_CTRL_TYPE_INTEGER64;
+		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index ca64202..f46350e 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1137,6 +1137,7 @@ struct v4l2_ext_controls {
 #define V4L2_CTRL_CLASS_FM_TX 0x009b0000	/* FM Modulator control class */
 #define V4L2_CTRL_CLASS_FLASH 0x009c0000	/* Camera flash controls */
 #define V4L2_CTRL_CLASS_IMAGE_SOURCE 0x009d0000	/* Image source controls */
+#define V4L2_CTRL_CLASS_IMAGE_PROC 0x009e0000	/* Image processing controls */
 
 #define V4L2_CTRL_ID_MASK      	  (0x0fffffff)
 #define V4L2_CTRL_ID2CLASS(id)    ((id) & 0x0fff0000UL)
@@ -1771,6 +1772,13 @@ enum v4l2_flash_strobe_source {
 #define V4L2_CID_HBLANK				(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 2)
 #define V4L2_CID_ANALOGUE_GAIN			(V4L2_CID_IMAGE_SOURCE_CLASS_BASE + 3)
 
+/* Image processing controls */
+#define V4L2_CID_IMAGE_PROC_CLASS_BASE		(V4L2_CTRL_CLASS_IMAGE_PROC | 0x900)
+#define V4L2_CID_IMAGE_PROC_CLASS		(V4L2_CTRL_CLASS_IMAGE_PROC | 1)
+
+#define V4L2_CID_LINK_FREQ			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 1)
+#define V4L2_CID_PIXEL_RATE			(V4L2_CID_IMAGE_PROC_CLASS_BASE + 2)
+
 /*
  *	T U N I N G
  */
-- 
1.7.2.5

