Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:32681 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884Ab2CFQd3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 11:33:29 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5 09/35] v4l: Add subdev selections documentation
Date: Tue,  6 Mar 2012 18:32:50 +0200
Message-Id: <1331051596-8261-9-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120306163239.GN1075@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for V4L2 subdev selection API. This changes also
experimental V4L2 subdev API so that scaling now works through selection API
only.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/Makefile               |    4 +-
 Documentation/DocBook/media/v4l/compat.xml         |    9 +
 Documentation/DocBook/media/v4l/dev-subdev.xml     |  202 +++++++++++++++--
 Documentation/DocBook/media/v4l/v4l2.xml           |   17 ++-
 .../media/v4l/vidioc-subdev-g-selection.xml        |  228 ++++++++++++++++++++
 5 files changed, 433 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 6628b4b..3625209 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -70,6 +70,8 @@ IOCTLS = \
 	VIDIOC_SUBDEV_ENUM_MBUS_CODE \
 	VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
 	VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL \
+	VIDIOC_SUBDEV_G_SELECTION \
+	VIDIOC_SUBDEV_S_SELECTION \
 
 TYPES = \
 	$(shell perl -ne 'print "$$1 " if /^typedef\s+[^\s]+\s+([^\s]+)\;/' $(srctree)/include/linux/videodev2.h) \
@@ -193,7 +195,7 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)cp $(OBJIMGFILES) $(MEDIA_OBJ_DIR)/media_api
+	$(Q)cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 	$(Q)base64 -d $< >$@
diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 8cd5c96..603fa4ad 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2407,6 +2407,11 @@ details.</para>
 	  <para>Added integer menus, the new type will be
 	  V4L2_CTRL_TYPE_INTEGER_MENU.</para>
         </listitem>
+        <listitem>
+	  <para>Added selection API for V4L2 subdev interface:
+	  &VIDIOC-SUBDEV-G-SELECTION; and
+	  &VIDIOC-SUBDEV-S-SELECTION;.</para>
+        </listitem>
       </orderedlist>
     </section>
 
@@ -2523,6 +2528,10 @@ ioctls.</para>
         <listitem>
 	  <para>Selection API. <xref linkend="selection-api" /></para>
         </listitem>
+        <listitem>
+	  <para>Sub-device selection API: &VIDIOC-SUBDEV-G-SELECTION;
+	  and &VIDIOC-SUBDEV-S-SELECTION; ioctls.</para>
+        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 0916a73..f4c623e 100644
--- a/Documentation/DocBook/media/v4l/dev-subdev.xml
+++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
@@ -76,11 +76,12 @@
     <wordasword>format</wordasword> means the combination of media bus data
     format, frame width and frame height.</para></note>
 
-    <para>Image formats are typically negotiated on video capture and output
-    devices using the <link linkend="crop">cropping and scaling</link> ioctls.
-    The driver is responsible for configuring every block in the video pipeline
-    according to the requested format at the pipeline input and/or
-    output.</para>
+    <para>Image formats are typically negotiated on video capture and
+    output devices using the format and <link
+    linkend="vidioc-subdev-g-selection">selection</link> ioctls. The
+    driver is responsible for configuring every block in the video
+    pipeline according to the requested format at the pipeline input
+    and/or output.</para>
 
     <para>For complex devices, such as often found in embedded systems,
     identical image sizes at the output of a pipeline can be achieved using
@@ -276,11 +277,11 @@
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
 
@@ -288,26 +289,179 @@
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
+      <para>The scaling operation changes the size of the image by
+      scaling it to new dimensions. The scaling ratio isn't specified
+      explicitly, but is implied from the original and scaled image
+      sizes. Both sizes are represented by &v4l2-rect;.</para>
+
+      <para>Scaling support is optional. When supported by a subdev,
+      the crop rectangle on the subdev's sink pad is scaled to the
+      size configured using &sub-subdev-g-selection; and
+      <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection
+      target on the same pad. If the subdev supports scaling but not
+      composing, the top and left values are not used and must always
+      be set to zero.</para>
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
+      specificly told otherwise.
+      <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant> and
+      <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant> flags may be
+      used to round the image size either up or down. <xref
+      linkend="v4l2-subdev-selection-flags"></xref></para>
+    </section>
+
+    <section>
+      <title>Types of selection targets</title>
+
+      <section>
+	<title>ACTIVE targets</title>
+
+	<para>ACTIVE targets reflect the actual hardware configuration
+	at any point of time. There is a BOUNDS target
+	corresponding to every ACTIVE target.</para>
+      </section>
+
+      <section>
+	<title>BOUNDS targets</title>
+
+	<para>BOUNDS targets is the smallest rectangle that contains
+	all valid ACTIVE rectangles. It may not be possible to set the
+	ACTIVE rectangle as large as the BOUNDS rectangle, however.
+	This may be because e.g. a sensor's pixel array is not
+	rectangular but cross-shaped or round. The maximum size may
+	also be smaller than the BOUNDS rectangle.</para>
+      </section>
 
-      <para>Cropping behaviour on output pads is not defined.</para>
+    </section>
+
+    <section>
+      <title>Order of configuration and format propagation</title>
+
+      <para>Inside subdevs, the order of image processing steps will
+      always be from the sink pad towards the source pad. This is also
+      reflected in the order in which the configuration must be
+      performed by the user: the changes made will be propagated to
+      any subsequent stages. If this behaviour is not desired, the
+      user must set
+      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag. This
+      flag causes that no propagation of the changes are allowed in
+      any circumstances. This may also cause the accessed rectangle to
+      be adjusted by the driver, depending on the properties of the
+      underlying hardware.</para>
+
+      <para>The coordinates to a step always refer to the active size
+      of the previous step. The exception to this rule is the source
+      compose rectangle, which refers to the sink compose bounds
+      rectangle --- if it is supported by the hardware.</para>
+
+      <orderedlist>
+	<listitem>Sink pad format. The user configures the sink pad
+	format. This format defines the parameters of the image the
+	entity receives through the pad for further processing.</listitem>
+
+	<listitem>Sink pad active crop selection. The sink pad crop
+	defines the crop performed to the sink pad format.</listitem>
+
+	<listitem>Sink pad active compose selection. The size of the
+	sink pad compose rectangle defines the scaling ratio compared
+	to the size of the sink pad crop rectangle. The location of
+	the compose rectangle specifies the location of the active
+	sink compose rectangle in the sink compose bounds
+	rectangle.</listitem>
+
+	<listitem>Source pad active crop selection. Crop on the source
+	pad defines crop performed to the image in the sink compose
+	bounds rectangle.</listitem>
+
+	<listitem>Source pad format. The source pad format defines the
+	output pixel format of the subdev, as well as the other
+	parameters with the exception of the image width and height.
+	Width and height are defined by the size of the source pad
+	active crop selection.</listitem>
+      </orderedlist>
+
+      <para>Accessing any of the above rectangles not supported by the
+      subdev will return <constant>EINVAL</constant>. Any rectangle
+      referring to a previous unsupported rectangle coordinates will
+      instead refer to the previous supported rectangle. For example,
+      if sink crop is not supported, the compose selection will refer
+      to the sink pad format dimensions instead.</para>
+
+      <figure id="subdev-image-processing-crop">
+	<title>Image processing in subdevs: simple crop example</title>
+	<mediaobject>
+	  <imageobject>
+	    <imagedata fileref="subdev-image-processing-crop.svg"
+	    format="SVG" scale="200" />
+	  </imageobject>
+	</mediaobject>
+      </figure>
+
+      <para>In the above example, the subdev supports cropping on its
+      sink pad. To configure it, the user sets the media bus format on
+      the subdev's sink pad. Now the active crop rectangle can be set
+      on the sink pad --- the location and size of this rectangle
+      reflect the location and size of a rectangle to be cropped from
+      the sink format. The size of the sink crop rectangle will also
+      be the size of the format of the subdev's source pad.</para>
+
+      <figure id="subdev-image-processing-scaling-multi-source">
+	<title>Image processing in subdevs: scaling with multiple sources</title>
+	<mediaobject>
+	  <imageobject>
+	    <imagedata fileref="subdev-image-processing-scaling-multi-source.svg"
+	    format="SVG" scale="200" />
+	  </imageobject>
+	</mediaobject>
+      </figure>
+
+      <para>In this example, the subdev is capable of first cropping,
+      then scaling and finally cropping for two source pads
+      individually from the resulting scaled image. The location of
+      the scaled image in the cropped image is ignored in sink compose
+      target. Both of the locations of the source crop rectangles
+      refer to the sink scaling rectangle, independently cropping an
+      area at location specified by the source crop rectangle from
+      it.</para>
+
+      <figure id="subdev-image-processing-full">
+	<title>Image processing in subdevs: scaling and composition
+	with multiple sinks and sources</title>
+	<mediaobject>
+	  <imageobject>
+	    <imagedata fileref="subdev-image-processing-full.svg"
+	    format="SVG" scale="200" />
+	  </imageobject>
+	</mediaobject>
+      </figure>
+
+      <para>The subdev driver supports two sink pads and two source
+      pads. The images from both of the sink pads are individually
+      cropped, then scaled and further composed on the composition
+      bounds rectangle. From that, two independent streams are cropped
+      and sent out of the subdev from the source pads.</para>
 
     </section>
+
   </section>
 
   &sub-subdev-formats;
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index ff11a13..912ec9c 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -96,6 +96,17 @@ Remote Controller chapter.</contrib>
 	  </address>
 	</affiliation>
       </author>
+
+      <author>
+	<firstname>Sakari</firstname>
+	<surname>Ailus</surname>
+	<contrib>Subdev selections API.</contrib>
+	<affiliation>
+	  <address>
+	    <email>sakari.ailus@iki.fi</email>
+	  </address>
+	</affiliation>
+      </author>
     </authorgroup>
 
     <copyright>
@@ -129,9 +140,10 @@ applications. -->
 
       <revision>
 	<revnumber>3.4</revnumber>
-	<date>2012-01-26</date>
+	<date>2012-02-02</date>
 	<authorinitials>sa</authorinitials>
-	<revremark>Added V4L2_CTRL_TYPE_INTEGER_MENU.</revremark>
+	<revremark>Added V4L2_CTRL_TYPE_INTEGER_MENU. Added V4L2 subdev
+		   selections API.</revremark>
       </revision>
       <revision>
 	<revnumber>3.3</revnumber>
@@ -537,6 +549,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-subdev-g-crop;
     &sub-subdev-g-fmt;
     &sub-subdev-g-frame-interval;
+    &sub-subdev-g-selection;
     &sub-subscribe-event;
     <!-- End of ioctls. -->
     &sub-mmap;
diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
new file mode 100644
index 0000000..9164b85
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -0,0 +1,228 @@
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
+    <para>The selection API replaces <link
+    linkend="vidioc-subdev-g-crop">the old subdev crop API</link>. All
+    the function of the crop API, and more, are supported by the
+    selections API.</para>
+
+    <para>See <xref linkend="subdev"></xref> for
+    more information on how each selection target affects the image
+    processing pipeline inside the subdevice.</para>
+
+    <section>
+      <title>Types of selection targets</title>
+
+      <para>There are two types of selection targets: active and bounds.
+      The ACTIVE targets are the targets which configure the hardware.
+      The BOUNDS target will return a rectangle that contain all
+      possible ACTIVE rectangles.</para>
+    </section>
+
+    <section>
+      <title>Discovering supported features</title>
+
+      <para>To discover which targets are supported, the user can
+      perform <constant>VIDIOC_SUBDEV_G_SELECTION</constant> on them.
+      Any unsupported target will return
+      <constant>EINVAL</constant>.</para>
+    </section>
+
+    <table pgwide="1" frame="none" id="v4l2-subdev-selection-targets">
+      <title>V4L2 subdev selection targets</title>
+      <tgroup cols="3">
+        &cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE</constant></entry>
+	    <entry>0x0000</entry>
+	    <entry>Active crop. Defines the cropping
+	    performed by the processing step.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS</constant></entry>
+	    <entry>0x0002</entry>
+	    <entry>Bounds of the crop rectangle.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE</constant></entry>
+	    <entry>0x0100</entry>
+	    <entry>Active compose rectangle. Used to configure scaling
+	    on sink pads and composition on source pads.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
+	    <entry>0x0102</entry>
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
+	    <entry>(1 &lt;&lt; 0)</entry> <entry>Suggest the driver it
+	    should choose greater or equal rectangle (in size) than
+	    was requested. Albeit the driver may choose a lesser size,
+	    it will only do so due to hardware limitations. Without
+	    this flag (and
+	    <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant>) the
+	    behaviour is to choose the closest possible
+	    rectangle.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant></entry>
+	    <entry>(1 &lt;&lt; 1)</entry> <entry>Suggest the driver it
+	    should choose lesser or equal rectangle (in size) than was
+	    requested. Albeit the driver may choose a greater size, it
+	    will only do so due to hardware limitations.</entry>
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

