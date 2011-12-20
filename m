Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34265 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab1LTU2O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 15:28:14 -0500
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com
Subject: [RFC 06/17] v4l: Add selections documentation.
Date: Tue, 20 Dec 2011 22:27:58 +0200
Message-Id: <1324412889-17961-6-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4EF0EFC9.6080501@maxwell.research.nokia.com>
References: <4EF0EFC9.6080501@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   95 +++++++--
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../media/v4l/vidioc-subdev-g-selection.xml        |  226 ++++++++++++++++++++
 3 files changed, 302 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml

diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 0916a73..722db60 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -77,7 +77,7 @@
     format, frame width and frame height.</para></note>
 
     <para>Image formats are typically negotiated on video capture and output
-    devices using the <link linkend="crop">cropping and scaling</link> ioctls.
+    devices using the format and <link linkend="selection">selection</link> ioctls.
     The driver is responsible for configuring every block in the video pipeline
     according to the requested format at the pipeline input and/or
     output.</para>
@@ -276,11 +276,11 @@
     </section>
 
     <section>
-      <title>Cropping and scaling</title>
+      <title>Selections: cropping, scaling and composition</title>
 
       <para>Many sub-devices support cropping frames on their input or output
       pads (or possible even on both). Cropping is used to select the area of
-      interest in an image, typically on a video sensor or video decoder. It can
+      interest in an image, typically on an image sensor or a video decoder. It can
       also be used as part of digital zoom implementations to select the area of
       the image that will be scaled up.</para>
 
@@ -288,26 +288,81 @@
       &v4l2-rect; by the coordinates of the top left corner and the rectangle
       size. Both the coordinates and sizes are expressed in pixels.</para>
 
-      <para>The crop rectangle is retrieved and set using the
-      &VIDIOC-SUBDEV-G-CROP; and &VIDIOC-SUBDEV-S-CROP; ioctls. Like for pad
-      formats, drivers store try and active crop rectangles. The format
-      negotiation mechanism applies to crop settings as well.</para>
-
-      <para>On input pads, cropping is applied relatively to the current pad
-      format. The pad format represents the image size as received by the
-      sub-device from the previous block in the pipeline, and the crop rectangle
-      represents the sub-image that will be transmitted further inside the
-      sub-device for processing. The crop rectangle be entirely containted
-      inside the input image size.</para>
-
-      <para>Input crop rectangle are reset to their default value when the input
-      image format is modified. Drivers should use the input image size as the
-      crop rectangle default value, but hardware requirements may prevent this.
-      </para>
+      <para>Scaling operation changes the size of the image by scaling
+      it to new dimensions. Some sub-devices support it. The scaled
+      size (width and height) is represented by &v4l2-rect;. In the
+      case of scaling, top and left will always be zero. Scaling is
+      configured using &sub-subdev-g-selection; and
+      <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection
+      target on the sink pad of the subdev. The scaling is performed
+      related to the width and height of the crop rectangle on the
+      subdev's sink pad.</para>
+
+      <para>As for pad formats, drivers store try and active
+      rectangles for the selection targets of ACTIVE type <xref
+      linkend="v4l2-subdev-selection-targets">.</xref></para>
+
+      <para>On sink pads, cropping is applied relatively to the
+      current pad format. The pad format represents the image size as
+      received by the sub-device from the previous block in the
+      pipeline, and the crop rectangle represents the sub-image that
+      will be transmitted further inside the sub-device for
+      processing.</para>
+
+      <para>On source pads, cropping is similar to sink pads, with the
+      exception that the source size from which the cropping is
+      performed, is the COMPOSE rectangle on the sink pad. In both
+      sink and source pads, the crop rectangle must be entirely
+      containted inside the source image size for the crop
+      operation.</para>
+
+      <para>The drivers should always use the closest possible
+      rectangle the user requests on all selection targets, unless
+      specificly told otherwise<xref
+      linkend="v4l2-subdev-selection-flags">.</xref></para>
+    </section>
+
+    <section>
+      <title>Order of configuration and format propagation</title>
+
+      <para>The order of image processing steps will always be from
+      the sink pad towards the source pad. This is also reflected in
+      the order in which the configuration must be performed by the
+      user. The format is propagated within the subdev along the later
+      processing steps. For example, setting the sink pad format
+      causes all the selection rectangles and the source pad format to
+      be set to sink pad format --- if allowed by the hardware, and if
+      not, then closest possible. The coordinates to a step always
+      refer to the active size of the previous step.</para>
+
+      <orderedlist>
+	<listitem>Sink pad format. The user configures the sink pad
+	format. This format defines the parameters of the image the
+	entity receives through the pad for further processing.</listitem>
 
-      <para>Cropping behaviour on output pads is not defined.</para>
+	<listitem>Sink pad active crop selection. The sink pad crop
+	defines the performed to the sink pad format.</listitem>
 
+	<listitem>Sink pad active compose selection. The sink pad compose
+	rectangle defines the scaling ratio compared to the size of
+	the sink pad crop rectangle.</listitem>
+
+	<listitem>Source pad active crop selection. Crop on the source
+	pad defines crop performed to the image scaled according to
+	the sink pad compose rectangle.</listitem>
+
+	<listitem>Source pad active compose selection. The source pad
+	compose defines the size and location of the compose
+	rectangle.</listitem>
+
+	<listitem>Source pad format. The source pad format defines the
+	output pixel format of the subdev, as well as the other
+	parameters with the exception of the image width and
+	height.</listitem>
+
+      </orderedlist>
     </section>
+
   </section>
 
   &sub-subdev-formats;
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index affe1ba..3ff11a6 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -529,6 +529,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-subdev-g-crop;
     &sub-subdev-g-fmt;
     &sub-subdev-g-frame-interval;
+    &sub-subdev-g-selection;
     &sub-subscribe-event;
     <!-- End of ioctls. -->
     &sub-mmap;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
new file mode 100644
index 0000000..5fbcd65
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -0,0 +1,226 @@
+<refentry id="vidioc-subdev-g-selection">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_SUBDEV_G_SELECTION</refname>
+    <refname>VIDIOC_SUBDEV_S_SELECTION</refname>
+    <refpurpose>Get or set selection rectangles on a subdev pad</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_subdev_selection *<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+      <varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>argp</parameter></term>
+	<listitem>
+	  <para></para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+
+  <refsect1>
+    <title>Description</title>
+
+    <note>
+      <title>Experimental</title>
+      <para>This is an <link linkend="experimental">experimental</link>
+      interface and may change in the future.</para>
+    </note>
+
+    <para>The selections are used to configure various image
+    processing functionality performed by the subdevs which affect the
+    image size. This currently includes cropping, scaling and
+    composition.</para>
+
+    <para>The selections replace the crop API &sub-subdev-g-crop;. All
+    the function of the crop API, and more, are supported by the
+    selections API.</para>
+
+    <para>See <xref linkend="subdev">Sub-device interface</xref> for
+    more information on how each selection target affects the image
+    processing pipeline inside the subdevice.</para>
+
+    <section>
+      <title>Types of selection targets</title>
+
+      <para>The are four types of selection targets: active, default,
+      bounds and padding. The ACTIVE targets are the targets which
+      configure the hardware. The DEFAULT target provides the default
+      for the ACTIVE selection. The BOUNDS target will return the
+      maximum width and height of the target. The PADDED target
+      provides the width and height for the padded image, and is
+      directly affected by the ACTIVE target. The PADDED targets may
+      be configurable depending on the hardware.</para>
+    </section>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-selection-targets">
+      <title>V4L2 subdev selection targets</title>
+      <tgroup cols="3">
+        &cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE</constant></entry>
+	    <entry>0</entry>
+	    <entry>Active crop. Defines the cropping
+	    performed by the processing step.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_DEFAULT</constant></entry>
+	    <entry>1</entry>
+	    <entry>Default crop rectangle.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS</constant></entry>
+	    <entry>2</entry>
+	    <entry>Bounds of the crop rectangle.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE</constant></entry>
+	    <entry>256</entry>
+	    <entry>Active compose rectangle. Used to configure scaling
+	    on sink pads and composition on source pads.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_DEFAULT</constant></entry>
+	    <entry>257</entry>
+	    <entry>Default compose rectangle.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
+	    <entry>258</entry>
+	    <entry>Bounds of the compose rectangle.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-selection-flags">
+      <title>V4L2 subdev selection flags</title>
+      <tgroup cols="3">
+        &cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant></entry>
+	    <entry>(1 &lt;&lt; 0)</entry>
+	    <entry>Suggest the driver it should choose greater or
+	    equal rectangle (in size) than was requested.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant></entry>
+	    <entry>(1 &lt;&lt; 1)</entry>
+	    <entry>Suggest the driver it should choose lesser or
+	    equal rectangle (in size) than was requested.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant></entry>
+	    <entry>(1 &lt;&lt; 2)</entry>
+	    <entry>The configuration should not be propagated to any
+	    further processing steps. If this flag is not given, the
+	    configuration is propagated inside the subdevice to all
+	    further processing steps.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-selection">
+      <title>struct <structname>v4l2_subdev_selection</structname></title>
+      <tgroup cols="3">
+        &cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>which</structfield></entry>
+	    <entry>Active or try selection, from
+	    &v4l2-subdev-format-whence;.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>pad</structfield></entry>
+	    <entry>Pad number as reported by the media framework.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>target</structfield></entry>
+	    <entry>Target selection rectangle. See
+	    <xref linkend="v4l2-subdev-selection-targets">.</xref>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Flags. See
+	    <xref linkend="v4l2-subdev-selection-flags">.</xref></entry>
+	  </row>
+	  <row>
+	    <entry>&v4l2-rect;</entry>
+	    <entry><structfield>rect</structfield></entry>
+	    <entry>Crop rectangle boundaries, in pixels.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[8]</entry>
+	    <entry>Reserved for future extensions. Applications and drivers must
+	    set the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
+	<listitem>
+	  <para>The selection rectangle can't be changed because the
+	  pad is currently busy. This can be caused, for instance, by
+	  an active video stream on the pad. The ioctl must not be
+	  retried without performing another action to fix the problem
+	  first. Only returned by
+	  <constant>VIDIOC_SUBDEV_S_SELECTION</constant></para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>The &v4l2-subdev-selection;
+	  <structfield>pad</structfield> references a non-existing
+	  pad, the <structfield>which</structfield> field references a
+	  non-existing format, or the selection target is not
+	  supported on the given subdev pad.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
-- 
1.7.2.5

