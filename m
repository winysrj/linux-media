Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:40710 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933965Ab2AKV1P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:15 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 06/23] v4l: Add selections documentation
Date: Wed, 11 Jan 2012 23:26:43 +0200
Message-Id: <1326317220-15339-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 .../DocBook/media/subdev-image-processing.svg      |  116 ++
 Documentation/DocBook/media/v4l/dev-subdev.xml     |  116 ++-
 .../DocBook/media/v4l/subdev-image-processing.dia  | 1137 ++++++++++++++++++++
 Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
 .../media/v4l/vidioc-subdev-g-selection.xml        |  227 ++++
 5 files changed, 1573 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/DocBook/media/subdev-image-processing.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing.dia
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml

diff --git a/Documentation/DocBook/media/subdev-image-processing.svg b/Documentation/DocBook/media/subdev-image-processing.svg
new file mode 100644
index 0000000..8e24d7e
--- /dev/null
+++ b/Documentation/DocBook/media/subdev-image-processing.svg
@@ -0,0 +1,116 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
+<svg width="49cm" height="18cm" viewBox="3 137 977 346" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
+  <g>
+    <rect style="fill: #ffffff" x="294" y="400" width="342.5" height="82"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="294" y="400" width="342.5" height="82"/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="442" y="446">
+    <tspan x="442" y="446">Subdev</tspan>
+  </text>
+  <g>
+    <ellipse style="fill: #ffffff" cx="284.5" cy="439.712" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="284.5" cy="439.712" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="284.5" cy="439.712" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <ellipse style="fill: #ffffff" cx="646.232" cy="440.184" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="646.232" cy="440.184" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="646.232" cy="440.184" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="112.5" y1="440" x2="266.264" y2="439.729"/>
+    <polygon style="fill: #000000" points="273.764,439.716 263.773,444.734 266.264,439.729 263.755,434.734 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="273.764,439.716 263.773,444.734 266.264,439.729 263.755,434.734 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="654.732" y1="440.184" x2="811.066" y2="440.212"/>
+    <polygon style="fill: #000000" points="818.566,440.214 808.565,445.212 811.066,440.212 808.567,435.212 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="818.566,440.214 808.565,445.212 811.066,440.212 808.567,435.212 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="263.5" y="409">
+    <tspan x="263.5" y="409">sink</tspan>
+    <tspan x="263.5" y="425">pad</tspan>
+  </text>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="643.5" y="407">
+    <tspan x="643.5" y="407">source</tspan>
+    <tspan x="643.5" y="423">pad</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="4.5" y="189" width="159" height="104"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="4.5" y="189" width="159" height="104"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="213.5" y="209" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="213.5" y="209" width="94" height="77"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="58.3" y="195" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #0000ff" x="58.3" y="195" width="94" height="77"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="213.5" y1="286" x2="58.3" y2="272"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="213.5" y1="209" x2="58.3" y2="195"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="307.5" y1="286" x2="152.3" y2="272"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="307.5" y1="209" x2="152.3" y2="195"/>
+  <text style="fill: #0000ff;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="212.5" y="153">
+    <tspan x="212.5" y="153">sink</tspan>
+    <tspan x="212.5" y="169">crop</tspan>
+    <tspan x="212.5" y="185">selection</tspan>
+  </text>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="29.5" y="158">
+    <tspan x="29.5" y="158"></tspan>
+  </text>
+  <text style="fill: #a52a2a;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="8.53836" y="157.914">
+    <tspan x="8.53836" y="157.914">sink media</tspan>
+    <tspan x="8.53836" y="173.914">bus format</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="333.644" y="185.65" width="165.2" height="172.478"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #00ff00" x="333.644" y="185.65" width="165.2" height="172.478"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="333.644" y1="358.128" x2="213.5" y2="286"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="333.644" y1="185.65" x2="213.5" y2="209"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="498.844" y1="358.128" x2="307.5" y2="286"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="498.844" y1="185.65" x2="307.5" y2="209"/>
+  <text style="fill: #00ff00;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="334.704" y="149.442">
+    <tspan x="334.704" y="149.442">sink compose</tspan>
+    <tspan x="334.704" y="165.442">selection (scaling)</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="543.322" y="187.565" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="543.322" y="187.565" width="100.186" height="71.4523"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="386.64" y="225.1" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #a020f0" x="386.64" y="225.1" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="543.322" y1="259.018" x2="386.64" y2="296.552"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="543.322" y1="187.565" x2="386.64" y2="225.1"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="643.508" y1="259.018" x2="486.826" y2="296.552"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="643.508" y1="187.565" x2="486.826" y2="225.1"/>
+  <text style="fill: #a020f0;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="543.322" y="149.442">
+    <tspan x="543.322" y="149.442">source</tspan>
+    <tspan x="543.322" y="165.442">crop</tspan>
+    <tspan x="543.322" y="181.442">selection</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="685.6" y="182.628" width="292.9" height="200.5"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="685.6" y="182.628" width="292.9" height="200.5"/>
+  </g>
+  <text style="fill: #8b6914;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="691.5" y="157.128">
+    <tspan x="691.5" y="157.128">source media</tspan>
+    <tspan x="691.5" y="173.128">bus format</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="780.488" y="268.834" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #ffa500" x="780.488" y="268.834" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="780.488" y1="340.286" x2="543.322" y2="259.018"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="780.488" y1="268.834" x2="543.322" y2="187.565"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="880.674" y1="340.286" x2="643.508" y2="259.018"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="880.674" y1="268.834" x2="643.508" y2="187.565"/>
+  <text style="fill: #ffa500;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="800" y="220">
+    <tspan x="800" y="220">source compose</tspan>
+    <tspan x="800" y="236">selection (composition)</tspan>
+  </text>
+</svg>
diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
index 0916a73..9ee17a3 100644
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
 
@@ -288,26 +289,93 @@
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
+      <para>Inside subdevs, the order of image processing steps will
+      always be from the sink pad towards the source pad. This is also
+      reflected in the order in which the configuration must be
+      performed by the user: the changes made will be propagated to
+      any subsequent stages. The coordinates to a step always refer to
+      the active size of the previous step.</para>
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
+
+      <figure id="subdev-image-processing">
+	<title>Image processing in subdevs</title>
+	<mediaobject>
+	  <imageobject>
+	    <imagedata fileref="subdev-image-processing.svg"
+	    format="SVG" scale="200" />
+	  </imageobject>
+	</mediaobject>
+      </figure>
+
+      <para>For example, setting the sink pad format causes all the
+      selection rectangles to be set to the sink image size and the
+      source pad format to be set to sink pad format --- if allowed by
+      the hardware, and if not, then closest possible.</para>
     </section>
+
   </section>
 
   &sub-subdev-formats;
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing.dia b/Documentation/DocBook/media/v4l/subdev-image-processing.dia
new file mode 100644
index 0000000..00b9317
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing.dia
@@ -0,0 +1,1137 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<dia:diagram xmlns:dia="http://www.lysator.liu.se/~alla/dia/">
+  <dia:diagramdata>
+    <dia:attribute name="background">
+      <dia:color val="#ffffff"/>
+    </dia:attribute>
+    <dia:attribute name="pagebreak">
+      <dia:color val="#000099"/>
+    </dia:attribute>
+    <dia:attribute name="paper">
+      <dia:composite type="paper">
+        <dia:attribute name="name">
+          <dia:string>#A4#</dia:string>
+        </dia:attribute>
+        <dia:attribute name="tmargin">
+          <dia:real val="2.8222000598907471"/>
+        </dia:attribute>
+        <dia:attribute name="bmargin">
+          <dia:real val="2.8222000598907471"/>
+        </dia:attribute>
+        <dia:attribute name="lmargin">
+          <dia:real val="2.8222000598907471"/>
+        </dia:attribute>
+        <dia:attribute name="rmargin">
+          <dia:real val="2.8222000598907471"/>
+        </dia:attribute>
+        <dia:attribute name="is_portrait">
+          <dia:boolean val="false"/>
+        </dia:attribute>
+        <dia:attribute name="scaling">
+          <dia:real val="0.49000000953674316"/>
+        </dia:attribute>
+        <dia:attribute name="fitto">
+          <dia:boolean val="false"/>
+        </dia:attribute>
+      </dia:composite>
+    </dia:attribute>
+    <dia:attribute name="grid">
+      <dia:composite type="grid">
+        <dia:attribute name="width_x">
+          <dia:real val="1"/>
+        </dia:attribute>
+        <dia:attribute name="width_y">
+          <dia:real val="1"/>
+        </dia:attribute>
+        <dia:attribute name="visible_x">
+          <dia:int val="1"/>
+        </dia:attribute>
+        <dia:attribute name="visible_y">
+          <dia:int val="1"/>
+        </dia:attribute>
+        <dia:composite type="color"/>
+      </dia:composite>
+    </dia:attribute>
+    <dia:attribute name="color">
+      <dia:color val="#d8e5e5"/>
+    </dia:attribute>
+    <dia:attribute name="guides">
+      <dia:composite type="guides">
+        <dia:attribute name="hguides"/>
+        <dia:attribute name="vguides"/>
+      </dia:composite>
+    </dia:attribute>
+  </dia:diagramdata>
+  <dia:layer name="Background" visible="true" active="true">
+    <dia:object type="Standard - Box" version="0" id="O0">
+      <dia:attribute name="obj_pos">
+        <dia:point val="14.7,20"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="14.65,19.95;31.875,24.15"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="14.7,20"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="17.124999999999996"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="4.1000000000000014"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O1">
+      <dia:attribute name="obj_pos">
+        <dia:point val="22.1,22.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="22.1,21.705;24.5025,22.4525"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#Subdev#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="22.1,22.3"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#000000"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O2">
+      <dia:attribute name="obj_pos">
+        <dia:point val="13.8,21.5606"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="13.75,21.5106;14.7,22.4606"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="13.8,21.5606"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="0.84999999999999787"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="0.84999999999999787"/>
+      </dia:attribute>
+      <dia:attribute name="line_width">
+        <dia:real val="0.10000000000000001"/>
+      </dia:attribute>
+      <dia:attribute name="line_colour">
+        <dia:color val="#000000"/>
+      </dia:attribute>
+      <dia:attribute name="fill_colour">
+        <dia:color val="#ffffff"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+      <dia:attribute name="line_style">
+        <dia:enum val="0"/>
+        <dia:real val="1"/>
+      </dia:attribute>
+      <dia:attribute name="flip_horizontal">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+      <dia:attribute name="flip_vertical">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+      <dia:attribute name="subscale">
+        <dia:real val="1"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O3">
+      <dia:attribute name="obj_pos">
+        <dia:point val="31.8866,21.5842"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="31.8366,21.5342;32.7866,22.4842"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="31.8866,21.5842"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="0.84999999999999787"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="0.84999999999999787"/>
+      </dia:attribute>
+      <dia:attribute name="line_width">
+        <dia:real val="0.10000000000000001"/>
+      </dia:attribute>
+      <dia:attribute name="line_colour">
+        <dia:color val="#000000"/>
+      </dia:attribute>
+      <dia:attribute name="fill_colour">
+        <dia:color val="#ffffff"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+      <dia:attribute name="line_style">
+        <dia:enum val="0"/>
+        <dia:real val="1"/>
+      </dia:attribute>
+      <dia:attribute name="flip_horizontal">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+      <dia:attribute name="flip_vertical">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+      <dia:attribute name="subscale">
+        <dia:real val="1"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O4">
+      <dia:attribute name="obj_pos">
+        <dia:point val="5.625,22"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="5.57491,21.6249;13.9118,22.3485"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="5.625,22"/>
+        <dia:point val="13.8,21.9856"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="end_arrow">
+        <dia:enum val="22"/>
+      </dia:attribute>
+      <dia:attribute name="end_arrow_length">
+        <dia:real val="0.5"/>
+      </dia:attribute>
+      <dia:attribute name="end_arrow_width">
+        <dia:real val="0.5"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="1" to="O2" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O5">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.7366,22.0092"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.6866,21.6488;41.1519,22.3724"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.7366,22.0092"/>
+        <dia:point val="41.0401,22.0107"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="end_arrow">
+        <dia:enum val="22"/>
+      </dia:attribute>
+      <dia:attribute name="end_arrow_length">
+        <dia:real val="0.5"/>
+      </dia:attribute>
+      <dia:attribute name="end_arrow_width">
+        <dia:real val="0.5"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O3" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O6">
+      <dia:attribute name="obj_pos">
+        <dia:point val="13.175,20.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="13.175,19.855;14.46,21.4025"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#sink
+pad#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="13.175,20.45"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#000000"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O7">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.175,20.35"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.175,19.755;34.3,21.3025"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#source
+pad#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="32.175,20.35"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#000000"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O8">
+      <dia:attribute name="obj_pos">
+        <dia:point val="0.225,9.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="0.175,9.4;8.225,14.7"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="0.225,9.45"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="7.9499999999999975"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="5.1999999999999975"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#a52a2a"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O9">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.675,10.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.625,10.4;15.425,14.35"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="10.675,10.45"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="4.6999999999999975"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="3.8499999999999979"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#0000ff"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O10">
+      <dia:attribute name="obj_pos">
+        <dia:point val="2.915,9.75"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.865,9.7;7.665,13.65"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="2.915,9.75"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="4.6999999999999975"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="3.8499999999999979"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#0000ff"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+      <dia:attribute name="line_style">
+        <dia:enum val="4"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O11">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.675,14.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.86071,13.5457;10.7293,14.3543"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="10.675,14.3"/>
+        <dia:point val="2.915,13.6"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O9" connection="5"/>
+        <dia:connection handle="1" to="O10" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O12">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.675,10.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.86071,9.69571;10.7293,10.5043"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="10.675,10.45"/>
+        <dia:point val="2.915,9.75"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O9" connection="0"/>
+        <dia:connection handle="1" to="O10" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O13">
+      <dia:attribute name="obj_pos">
+        <dia:point val="15.375,14.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.56071,13.5457;15.4293,14.3543"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="15.375,14.3"/>
+        <dia:point val="7.615,13.6"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O9" connection="7"/>
+        <dia:connection handle="1" to="O10" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O14">
+      <dia:attribute name="obj_pos">
+        <dia:point val="15.375,10.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.56071,9.69571;15.4293,10.5043"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="15.375,10.45"/>
+        <dia:point val="7.615,9.75"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O9" connection="2"/>
+        <dia:connection handle="1" to="O10" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O15">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.625,7.65"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.625,7.055;13.5025,9.4025"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#sink
+crop
+selection#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="10.625,7.65"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#0000ff"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O16">
+      <dia:attribute name="obj_pos">
+        <dia:point val="1.475,7.9"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="1.475,7.305;1.475,8.0525"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>##</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="1.475,7.9"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#000000"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O17">
+      <dia:attribute name="obj_pos">
+        <dia:point val="0.426918,7.89569"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="0.426918,7.30069;3.90942,8.84819"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#sink media
+bus format#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="0.426918,7.89569"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#a52a2a"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O18">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.6822,9.28251"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="16.6322,9.23251;24.9922,17.9564"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="16.6822,9.28251"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="8.2600228398861297"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="8.6238900617957164"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#00ff00"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O19">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.6822,17.9064"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.6064,14.2314;16.7508,17.975"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="16.6822,17.9064"/>
+        <dia:point val="10.675,14.3"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O18" connection="5"/>
+        <dia:connection handle="1" to="O9" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O20">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.6822,9.28251"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.6164,9.22389;16.7408,10.5086"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="16.6822,9.28251"/>
+        <dia:point val="10.675,10.45"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O18" connection="0"/>
+        <dia:connection handle="1" to="O9" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O21">
+      <dia:attribute name="obj_pos">
+        <dia:point val="24.9422,17.9064"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="15.3106,14.2356;25.0066,17.9708"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.9422,17.9064"/>
+        <dia:point val="15.375,14.3"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O18" connection="7"/>
+        <dia:connection handle="1" to="O9" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O22">
+      <dia:attribute name="obj_pos">
+        <dia:point val="24.9422,9.28251"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="15.3193,9.22682;24.9979,10.5057"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.9422,9.28251"/>
+        <dia:point val="15.375,10.45"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O18" connection="2"/>
+        <dia:connection handle="1" to="O9" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O23">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.7352,7.47209"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="16.7352,6.87709;22.5602,8.42459"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#sink compose
+selection (scaling)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="16.7352,7.47209"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#00ff00"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O24">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.1661,9.37825"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.1161,9.32825;32.2254,13.0009"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="27.1661,9.37825"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="5.009308462554376"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="3.5726155970598077"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#a020f0"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O25">
+      <dia:attribute name="obj_pos">
+        <dia:point val="19.332,11.255"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.282,11.205;24.3913,14.8776"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="19.332,11.255"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="5.009308462554376"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="3.5726155970598077"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#a020f0"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+      <dia:attribute name="line_style">
+        <dia:enum val="4"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O26">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.1661,12.9509"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.2717,12.8906;27.2264,14.8879"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.1661,12.9509"/>
+        <dia:point val="19.332,14.8276"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O24" connection="5"/>
+        <dia:connection handle="1" to="O25" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O27">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.1661,9.37825"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.2717,9.31798;27.2264,11.3153"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.1661,9.37825"/>
+        <dia:point val="19.332,11.255"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O24" connection="0"/>
+        <dia:connection handle="1" to="O25" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O28">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.1754,12.9509"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.281,12.8906;32.2357,14.8879"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.1754,12.9509"/>
+        <dia:point val="24.3413,14.8276"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O24" connection="7"/>
+        <dia:connection handle="1" to="O25" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O29">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.1754,9.37825"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.281,9.31798;32.2357,11.3153"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.1754,9.37825"/>
+        <dia:point val="24.3413,11.255"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O24" connection="2"/>
+        <dia:connection handle="1" to="O25" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O30">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.1661,7.47209"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.1661,6.87709;30.0436,9.22459"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#source
+crop
+selection#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="27.1661,7.47209"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#a020f0"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O31">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.28,9.1314"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="34.23,9.0814;48.975,19.2064"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="34.28,9.1314"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="14.64500056728086"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="10.025000388931929"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#8b6914"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O32">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.575,7.8564"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="34.575,7.2614;38.8975,8.8089"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#source media
+bus format#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="34.575,7.8564"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#8b6914"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O33">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.0244,13.4417"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="38.9744,13.3917;44.0837,17.0643"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="39.0244,13.4417"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="5.009308462554376"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="3.5726155970598077"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#ffa500"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O34">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.0244,17.0143"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.1026,12.8874;39.0879,17.0778"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.0244,17.0143"/>
+        <dia:point val="27.1661,12.9509"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O33" connection="5"/>
+        <dia:connection handle="1" to="O24" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O35">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.0244,13.4417"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.1026,9.31474;39.0879,13.5052"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.0244,13.4417"/>
+        <dia:point val="27.1661,9.37825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O33" connection="0"/>
+        <dia:connection handle="1" to="O24" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O36">
+      <dia:attribute name="obj_pos">
+        <dia:point val="44.0337,17.0143"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.1119,12.8874;44.0972,17.0778"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="44.0337,17.0143"/>
+        <dia:point val="32.1754,12.9509"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O33" connection="7"/>
+        <dia:connection handle="1" to="O24" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O37">
+      <dia:attribute name="obj_pos">
+        <dia:point val="44.0337,13.4417"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.1119,9.31474;44.0972,13.5052"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="44.0337,13.4417"/>
+        <dia:point val="32.1754,9.37825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O33" connection="2"/>
+        <dia:connection handle="1" to="O24" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O38">
+      <dia:attribute name="obj_pos">
+        <dia:point val="40,11"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="40,10.405;47.4825,11.9525"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#source compose
+selection (composition)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="40,11"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#ffa500"/>
+          </dia:attribute>
+          <dia:attribute name="alignment">
+            <dia:enum val="0"/>
+          </dia:attribute>
+        </dia:composite>
+      </dia:attribute>
+      <dia:attribute name="valign">
+        <dia:enum val="3"/>
+      </dia:attribute>
+    </dia:object>
+  </dia:layer>
+</dia:diagram>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 8646fbc..79a0731 100644
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
index 0000000..eafacdb
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
@@ -0,0 +1,227 @@
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

