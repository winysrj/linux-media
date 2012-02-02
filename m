Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:44543 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2BBXzF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 18:55:05 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v2 06/31] v4l: Add subdev selections documentation: svg and dia files
Date: Fri,  3 Feb 2012 01:54:26 +0200
Message-Id: <1328226891-8968-6-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120202235231.GC841@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add svga and dia files for V4L2 subdev selections documentation.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 .../media/v4l/subdev-image-processing-crop.dia     |  719 ++++++++
 .../media/v4l/subdev-image-processing-crop.svg     |   71 +
 .../media/v4l/subdev-image-processing-full.dia     | 1888 ++++++++++++++++++++
 .../media/v4l/subdev-image-processing-full.svg     |  172 ++
 ...ubdev-image-processing-scaling-multi-source.dia | 1407 +++++++++++++++
 ...ubdev-image-processing-scaling-multi-source.svg |  130 ++
 6 files changed, 4387 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg

diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
new file mode 100644
index 0000000..5c467ec
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
@@ -0,0 +1,719 @@
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
+        <dia:point val="-0.4,6.5"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-0.45,6.45;23.1387,16.2"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="-0.4,6.5"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="23.48871579904775"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="9.6500000000000004"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O1">
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
+    <dia:object type="Standard - Box" version="0" id="O2">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.625,11.35"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.575,11.3;15.375,15.25"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="10.625,11.35"/>
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
+    <dia:object type="Standard - Box" version="0" id="O3">
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
+    <dia:object type="Standard - Line" version="0" id="O4">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.625,15.2"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.85588,13.5409;10.6841,15.2591"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="10.625,15.2"/>
+        <dia:point val="2.915,13.6"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O2" connection="5"/>
+        <dia:connection handle="1" to="O3" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O5">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.625,11.35"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.85588,9.69088;10.6841,11.4091"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="10.625,11.35"/>
+        <dia:point val="2.915,9.75"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O2" connection="0"/>
+        <dia:connection handle="1" to="O3" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O6">
+      <dia:attribute name="obj_pos">
+        <dia:point val="15.325,15.2"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.55588,13.5409;15.3841,15.2591"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="15.325,15.2"/>
+        <dia:point val="7.615,13.6"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O2" connection="7"/>
+        <dia:connection handle="1" to="O3" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O7">
+      <dia:attribute name="obj_pos">
+        <dia:point val="15.325,11.35"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.55588,9.69088;15.3841,11.4091"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="15.325,11.35"/>
+        <dia:point val="7.615,9.75"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O2" connection="2"/>
+        <dia:connection handle="1" to="O3" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O8">
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
+    <dia:object type="Standard - Text" version="1" id="O9">
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
+    <dia:object type="Standard - Text" version="1" id="O10">
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
+    <dia:object type="Standard - Text" version="1" id="O11">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.4887,7.75"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="17.4887,7.155;21.8112,8.7025"/>
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
+            <dia:point val="17.4887,7.75"/>
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
+    <dia:object type="Standard - Box" version="0" id="O12">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.5244,9.5417"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="17.4744,9.4917;22.2387,13.35"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="17.5244,9.5417"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="4.6643157990477508"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="3.758300000000002"/>
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
+    <dia:object type="Standard - Line" version="0" id="O13">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.5244,13.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.5635,13.2385;17.5859,15.2615"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="17.5244,13.3"/>
+        <dia:point val="10.625,15.2"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O12" connection="5"/>
+        <dia:connection handle="1" to="O2" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O14">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.5244,9.5417"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.564,9.48066;17.5854,11.411"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="17.5244,9.5417"/>
+        <dia:point val="10.625,11.35"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O12" connection="0"/>
+        <dia:connection handle="1" to="O2" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O15">
+      <dia:attribute name="obj_pos">
+        <dia:point val="22.1887,13.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="15.2635,13.2385;22.2502,15.2615"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="22.1887,13.3"/>
+        <dia:point val="15.325,15.2"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O12" connection="7"/>
+        <dia:connection handle="1" to="O2" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O16">
+      <dia:attribute name="obj_pos">
+        <dia:point val="22.1887,9.5417"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="15.2639,9.48061;22.2498,11.4111"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="22.1887,9.5417"/>
+        <dia:point val="15.325,11.35"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O12" connection="2"/>
+        <dia:connection handle="1" to="O2" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O17">
+      <dia:attribute name="obj_pos">
+        <dia:point val="23.23,10.5742"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="23.18,10.5242;24.13,11.4742"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="23.23,10.5742"/>
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
+    <dia:object type="Standard - Line" version="0" id="O18">
+      <dia:attribute name="obj_pos">
+        <dia:point val="24.08,10.9992"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.03,10.6388;32.4953,11.3624"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.08,10.9992"/>
+        <dia:point val="32.3835,11.0007"/>
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
+        <dia:connection handle="0" to="O17" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O19">
+      <dia:attribute name="obj_pos">
+        <dia:point val="25.3454,10.49"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="25.3454,9.895;29.9904,10.6425"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 1 (source)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="25.3454,10.49"/>
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
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O20">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-1.44491,11.6506"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-1.49491,11.6006;-0.544912,12.5506"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="-1.44491,11.6506"/>
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
+    <dia:object type="Standard - Line" version="0" id="O21">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-9.61991,12.09"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-9.67,11.7149;-1.33311,12.4385"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="-9.61991,12.09"/>
+        <dia:point val="-1.44491,12.0756"/>
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
+        <dia:connection handle="1" to="O20" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O22">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-7.39291,11.49"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-7.39291,10.895;-3.58791,11.6425"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 0 (sink)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="-7.39291,11.49"/>
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
+  </dia:layer>
+</dia:diagram>
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
new file mode 100644
index 0000000..7faee4d
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
@@ -0,0 +1,71 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
+<svg width="43cm" height="10cm" viewBox="-194 128 844 196" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="-8" y="130" width="469.774" height="193"/>
+  <g>
+    <rect style="fill: #ffffff" x="4.5" y="189" width="159" height="104"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="4.5" y="189" width="159" height="104"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="212.5" y="227" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="212.5" y="227" width="94" height="77"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="58.3" y="195" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #0000ff" x="58.3" y="195" width="94" height="77"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="212.5" y1="304" x2="58.3" y2="272"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="212.5" y1="227" x2="58.3" y2="195"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="306.5" y1="304" x2="152.3" y2="272"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="306.5" y1="227" x2="152.3" y2="195"/>
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
+  <text style="fill: #8b6914;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="349.774" y="155">
+    <tspan x="349.774" y="155">source media</tspan>
+    <tspan x="349.774" y="171">bus format</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="350.488" y="190.834" width="93.2863" height="75.166"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="350.488" y="190.834" width="93.2863" height="75.166"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="350.488" y1="266" x2="212.5" y2="304"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="350.488" y1="190.834" x2="212.5" y2="227"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="443.774" y1="266" x2="306.5" y2="304"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="443.774" y1="190.834" x2="306.5" y2="227"/>
+  <g>
+    <ellipse style="fill: #ffffff" cx="473.1" cy="219.984" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="473.1" cy="219.984" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="473.1" cy="219.984" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="481.6" y1="219.984" x2="637.934" y2="220.012"/>
+    <polygon style="fill: #000000" points="645.434,220.014 635.433,225.012 637.934,220.012 635.435,215.012 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="645.434,220.014 635.433,225.012 637.934,220.012 635.435,215.012 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="506.908" y="209.8">
+    <tspan x="506.908" y="209.8">pad 1 (source)</tspan>
+  </text>
+  <g>
+    <ellipse style="fill: #ffffff" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="-192.398" y1="241.8" x2="-38.6343" y2="241.529"/>
+    <polygon style="fill: #000000" points="-31.1343,241.516 -41.1254,246.534 -38.6343,241.529 -41.1431,236.534 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="-31.1343,241.516 -41.1254,246.534 -38.6343,241.529 -41.1431,236.534 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="-147.858" y="229.8">
+    <tspan x="-147.858" y="229.8">pad 0 (sink)</tspan>
+  </text>
+</svg>
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-full.dia b/Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
new file mode 100644
index 0000000..c228679
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
@@ -0,0 +1,1888 @@
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
+        <dia:point val="15.945,6.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="15.895,6.4;26.4,18.95"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="15.945,6.45"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="10.404999999254942"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="12.449999999999992"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#ff765a"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O1">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-0.1,3.65"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-0.15,3.6;40.25,20.85"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="-0.1,3.65"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="40.300000000000004"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="17.149999999999999"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O2">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-1.05,7.9106"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-1.1,7.8606;-0.15,8.8106"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="-1.05,7.9106"/>
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
+        <dia:point val="40.3366,9.8342"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="40.2866,9.7842;41.2366,10.7342"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="40.3366,9.8342"/>
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
+        <dia:point val="-9.225,8.35"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-9.27509,7.97487;-0.938197,8.69848"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="-9.225,8.35"/>
+        <dia:point val="-1.05,8.3356"/>
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
+        <dia:point val="41.1866,10.2592"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="41.1366,9.89879;49.6019,10.6224"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="41.1866,10.2592"/>
+        <dia:point val="49.4901,10.2607"/>
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
+        <dia:point val="-6.998,7.75"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-6.998,7.155;-3.193,7.9025"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 0 (sink)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="-6.998,7.75"/>
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
+        <dia:point val="42.452,9.75"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="42.452,9.155;47.097,9.9025"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 2 (source)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="42.452,9.75"/>
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
+        <dia:point val="0.275,6"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="0.225,5.95;8.275,11.25"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="0.275,6"/>
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
+        <dia:point val="10.725,7"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.675,6.95;15.475,10.9"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="10.725,7"/>
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
+        <dia:point val="2.965,6.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.915,6.25;7.715,10.2"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="2.965,6.3"/>
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
+        <dia:point val="10.725,10.85"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.91071,10.0957;10.7793,10.9043"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="10.725,10.85"/>
+        <dia:point val="2.965,10.15"/>
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
+        <dia:point val="10.725,7"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.91071,6.24571;10.7793,7.05429"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="10.725,7"/>
+        <dia:point val="2.965,6.3"/>
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
+        <dia:point val="15.425,10.85"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.61071,10.0957;15.4793,10.9043"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="15.425,10.85"/>
+        <dia:point val="7.665,10.15"/>
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
+        <dia:point val="15.425,7"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.61071,6.24571;15.4793,7.05429"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="15.425,7"/>
+        <dia:point val="7.665,6.3"/>
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
+        <dia:point val="10.675,4.2"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="10.675,3.605;13.5525,5.9525"/>
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
+            <dia:point val="10.675,4.2"/>
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
+        <dia:point val="1.525,4.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="1.525,3.855;1.525,4.6025"/>
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
+            <dia:point val="1.525,4.45"/>
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
+        <dia:point val="0.476918,4.44569"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="0.476918,3.85069;3.95942,5.39819"/>
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
+            <dia:point val="0.476918,4.44569"/>
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
+        <dia:rectangle val="10.6545,10.7795;16.7527,17.9769"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="16.6822,17.9064"/>
+        <dia:point val="10.725,10.85"/>
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
+        <dia:rectangle val="10.6604,6.93542;16.7468,9.34709"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="16.6822,9.28251"/>
+        <dia:point val="10.725,7"/>
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
+        <dia:rectangle val="15.3551,10.7801;25.0121,17.9763"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.9422,17.9064"/>
+        <dia:point val="15.425,10.85"/>
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
+        <dia:rectangle val="15.3647,6.93972;25.0025,9.34279"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.9422,9.28251"/>
+        <dia:point val="15.425,7"/>
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
+        <dia:point val="27.0661,6.77825"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.0161,6.72825;32.1254,10.4009"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="27.0661,6.77825"/>
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
+    <dia:object type="Standard - Line" version="0" id="O25">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.0661,10.3509"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.2637,10.2825;27.1344,14.8959"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.0661,10.3509"/>
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
+        <dia:connection handle="1" to="O53" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O26">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.0661,6.77825"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.2637,6.70993;27.1344,11.3233"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.0661,6.77825"/>
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
+        <dia:connection handle="1" to="O53" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O27">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.0754,10.3509"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.273,10.2825;32.1437,14.8959"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.0754,10.3509"/>
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
+        <dia:connection handle="1" to="O53" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O28">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.0754,6.77825"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.273,6.70993;32.1437,11.3233"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.0754,6.77825"/>
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
+        <dia:connection handle="1" to="O53" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O29">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.0661,4.87209"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.0661,4.27709;29.9436,6.62459"/>
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
+            <dia:point val="27.0661,4.87209"/>
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
+    <dia:object type="Standard - Text" version="1" id="O30">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.475,5.2564"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="34.475,4.6614;38.7975,6.2089"/>
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
+            <dia:point val="34.475,5.2564"/>
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
+    <dia:object type="Standard - Box" version="0" id="O31">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4244,8.6917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="34.3744,8.6417;39.4837,12.3143"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="34.4244,8.6917"/>
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
+        <dia:color val="#8b6914"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O32">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4244,12.2643"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.0051,10.2899;34.4854,12.3253"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.4244,12.2643"/>
+        <dia:point val="27.0661,10.3509"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O31" connection="5"/>
+        <dia:connection handle="1" to="O24" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O33">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4244,8.6917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.0051,6.71728;34.4854,8.75267"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.4244,8.6917"/>
+        <dia:point val="27.0661,6.77825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O31" connection="0"/>
+        <dia:connection handle="1" to="O24" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O34">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.4337,12.2643"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.0144,10.2899;39.4947,12.3253"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.4337,12.2643"/>
+        <dia:point val="32.0754,10.3509"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O31" connection="7"/>
+        <dia:connection handle="1" to="O24" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O35">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.4337,8.6917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.0144,6.71728;39.4947,8.75267"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.4337,8.6917"/>
+        <dia:point val="32.0754,6.77825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O31" connection="2"/>
+        <dia:connection handle="1" to="O24" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O36">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.25,5.15"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="16.25,4.555;21.6975,6.1025"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#compose bounds
+selection#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="16.25,5.15"/>
+          </dia:attribute>
+          <dia:attribute name="color">
+            <dia:color val="#ff765a"/>
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
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O37">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-1.02991,16.6506"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-1.07991,16.6006;-0.129912,17.5506"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="-1.02991,16.6506"/>
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
+    <dia:object type="Standard - Line" version="0" id="O38">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-9.20491,17.09"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-9.255,16.7149;-0.918109,17.4385"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="-9.20491,17.09"/>
+        <dia:point val="-1.02991,17.0756"/>
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
+        <dia:connection handle="1" to="O37" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O39">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-6.95,16.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-6.95,15.8363;-3.12631,16.6399"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 1 (sink)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="-6.95,16.45"/>
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
+    <dia:object type="Standard - Box" version="0" id="O40">
+      <dia:attribute name="obj_pos">
+        <dia:point val="0.390412,14.64"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="0.340412,14.59;6.045,18.8"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="0.390412,14.64"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="5.604587512785236"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="4.1099999999999994"/>
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
+    <dia:object type="Standard - Box" version="0" id="O41">
+      <dia:attribute name="obj_pos">
+        <dia:point val="11.145,16.39"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="11.095,16.34;14.1,18.95"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="11.145,16.39"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="2.904999999254942"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="2.5100000000000016"/>
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
+    <dia:object type="Standard - Box" version="0" id="O42">
+      <dia:attribute name="obj_pos">
+        <dia:point val="2.635,15.69"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.585,15.64;5.65,18.45"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="2.635,15.69"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="2.9649999992549416"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="2.7100000000000009"/>
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
+    <dia:object type="Standard - Line" version="0" id="O43">
+      <dia:attribute name="obj_pos">
+        <dia:point val="11.145,18.9"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.58215,18.3472;11.1978,18.9528"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="11.145,18.9"/>
+        <dia:point val="2.635,18.4"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O41" connection="5"/>
+        <dia:connection handle="1" to="O42" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O44">
+      <dia:attribute name="obj_pos">
+        <dia:point val="11.145,16.39"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.58107,15.6361;11.1989,16.4439"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="11.145,16.39"/>
+        <dia:point val="2.635,15.69"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O41" connection="0"/>
+        <dia:connection handle="1" to="O42" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O45">
+      <dia:attribute name="obj_pos">
+        <dia:point val="14.05,18.9"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="5.54713,18.3471;14.1029,18.9529"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="14.05,18.9"/>
+        <dia:point val="5.6,18.4"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O41" connection="7"/>
+        <dia:connection handle="1" to="O42" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O46">
+      <dia:attribute name="obj_pos">
+        <dia:point val="14.05,16.39"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="5.54604,15.636;14.104,16.444"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="14.05,16.39"/>
+        <dia:point val="5.6,15.69"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O41" connection="2"/>
+        <dia:connection handle="1" to="O42" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O47">
+      <dia:attribute name="obj_pos">
+        <dia:point val="1.595,12.99"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="1.595,12.395;1.595,13.1425"/>
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
+            <dia:point val="1.595,12.99"/>
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
+    <dia:object type="Standard - Line" version="0" id="O48">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.945,12.595"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="11.077,12.527;18.013,16.458"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="17.945,12.595"/>
+        <dia:point val="11.145,16.39"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O52" connection="0"/>
+        <dia:connection handle="1" to="O41" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O49">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.945,15.8"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="11.0788,15.7338;18.0112,18.9662"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="17.945,15.8"/>
+        <dia:point val="11.145,18.9"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O52" connection="5"/>
+        <dia:connection handle="1" to="O41" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O50">
+      <dia:attribute name="obj_pos">
+        <dia:point val="21.7,15.8"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="13.9849,15.7349;21.7651,18.9651"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="21.7,15.8"/>
+        <dia:point val="14.05,18.9"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O52" connection="7"/>
+        <dia:connection handle="1" to="O41" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O51">
+      <dia:attribute name="obj_pos">
+        <dia:point val="21.7,12.595"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="13.983,12.528;21.767,16.457"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="21.7,12.595"/>
+        <dia:point val="14.05,16.39"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O52" connection="2"/>
+        <dia:connection handle="1" to="O41" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O52">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.945,12.595"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="17.895,12.545;21.75,15.85"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="17.945,12.595"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="3.7549999992549452"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="3.2049999992549427"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#00ff00"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O53">
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
+        <dia:boolean val="false"/>
+      </dia:attribute>
+      <dia:attribute name="line_style">
+        <dia:enum val="4"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O54">
+      <dia:attribute name="obj_pos">
+        <dia:point val="29.9131,13.2733"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="29.8631,13.2233;32.252,15.25"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="29.9131,13.2733"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="2.2888999992549444"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="1.9267499992549393"/>
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
+    <dia:object type="Standard - Line" version="0" id="O55">
+      <dia:attribute name="obj_pos">
+        <dia:point val="29.9131,15.2"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="20.1901,15.1431;29.97,16.7069"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="29.9131,15.2"/>
+        <dia:point val="20.247,16.65"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O54" connection="5"/>
+        <dia:connection handle="1" to="O64" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O56">
+      <dia:attribute name="obj_pos">
+        <dia:point val="29.9131,13.2733"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="20.1903,13.2165;29.9698,14.7517"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="29.9131,13.2733"/>
+        <dia:point val="20.247,14.695"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O54" connection="0"/>
+        <dia:connection handle="1" to="O64" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O57">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.202,15.2"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="22.5951,15.1431;32.2589,16.7069"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.202,15.2"/>
+        <dia:point val="22.652,16.65"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O54" connection="7"/>
+        <dia:connection handle="1" to="O64" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O58">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.202,13.2733"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="22.5952,13.2164;32.2588,14.7518"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.202,13.2733"/>
+        <dia:point val="22.652,14.695"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O54" connection="2"/>
+        <dia:connection handle="1" to="O64" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O59">
+      <dia:attribute name="obj_pos">
+        <dia:point val="36.9214,16.3367"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="36.8714,16.2867;39.302,18.35"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="36.9214,16.3367"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="2.3305999992549431"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="1.9632999992549358"/>
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
+    <dia:object type="Standard - Line" version="0" id="O60">
+      <dia:attribute name="obj_pos">
+        <dia:point val="36.9214,18.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="29.8472,15.134;36.9874,18.366"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="36.9214,18.3"/>
+        <dia:point val="29.9131,15.2"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O59" connection="5"/>
+        <dia:connection handle="1" to="O54" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O61">
+      <dia:attribute name="obj_pos">
+        <dia:point val="36.9214,16.3367"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="29.8473,13.2074;36.9872,16.4025"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="36.9214,16.3367"/>
+        <dia:point val="29.9131,13.2733"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O59" connection="0"/>
+        <dia:connection handle="1" to="O54" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O62">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.252,18.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.1361,15.1341;39.3179,18.3659"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.252,18.3"/>
+        <dia:point val="32.202,15.2"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O59" connection="7"/>
+        <dia:connection handle="1" to="O54" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O63">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.252,16.3367"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.1362,13.2075;39.3178,16.4025"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.252,16.3367"/>
+        <dia:point val="32.202,13.2733"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O59" connection="2"/>
+        <dia:connection handle="1" to="O54" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O64">
+      <dia:attribute name="obj_pos">
+        <dia:point val="20.247,14.695"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="20.197,14.645;22.702,16.7"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="20.247,14.695"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="2.4049999992549402"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="1.9549999992549409"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="border_color">
+        <dia:color val="#a020f0"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+      <dia:attribute name="line_style">
+        <dia:enum val="4"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O65">
+      <dia:attribute name="obj_pos">
+        <dia:point val="40.347,16.7742"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="40.297,16.7242;41.247,17.6742"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="40.347,16.7742"/>
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
+    <dia:object type="Standard - Line" version="0" id="O66">
+      <dia:attribute name="obj_pos">
+        <dia:point val="41.197,17.1992"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="41.147,16.8388;49.6123,17.5624"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="41.197,17.1992"/>
+        <dia:point val="49.5005,17.2007"/>
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
+        <dia:connection handle="0" to="O65" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O67">
+      <dia:attribute name="obj_pos">
+        <dia:point val="42.4624,16.69"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="42.4624,16.0763;47.1261,16.8799"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 3 (source)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="42.4624,16.69"/>
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
+  </dia:layer>
+</dia:diagram>
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-full.svg b/Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
new file mode 100644
index 0000000..5170f10
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
@@ -0,0 +1,172 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
+<svg width="59cm" height="18cm" viewBox="-186 71 1178 346" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
+  <g>
+    <rect style="fill: #ffffff" x="318.9" y="129" width="208.1" height="249"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #ff765a" x="318.9" y="129" width="208.1" height="249"/>
+  </g>
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="-2" y="73" width="806" height="343"/>
+  <g>
+    <ellipse style="fill: #ffffff" cx="-12.5" cy="166.712" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-12.5" cy="166.712" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-12.5" cy="166.712" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <ellipse style="fill: #ffffff" cx="815.232" cy="205.184" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="815.232" cy="205.184" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="815.232" cy="205.184" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="-184.5" y1="167" x2="-30.7361" y2="166.729"/>
+    <polygon style="fill: #000000" points="-23.2361,166.716 -33.2272,171.734 -30.7361,166.729 -33.2449,161.734 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="-23.2361,166.716 -33.2272,171.734 -30.7361,166.729 -33.2449,161.734 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="823.732" y1="205.184" x2="980.066" y2="205.212"/>
+    <polygon style="fill: #000000" points="987.566,205.214 977.565,210.212 980.066,205.212 977.567,200.212 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="987.566,205.214 977.565,210.212 980.066,205.212 977.567,200.212 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="-139.96" y="155">
+    <tspan x="-139.96" y="155">pad 0 (sink)</tspan>
+  </text>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="849.04" y="195">
+    <tspan x="849.04" y="195">pad 2 (source)</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="5.5" y="120" width="159" height="104"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="5.5" y="120" width="159" height="104"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="214.5" y="140" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="214.5" y="140" width="94" height="77"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="59.3" y="126" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #0000ff" x="59.3" y="126" width="94" height="77"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="214.5" y1="217" x2="59.3" y2="203"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="214.5" y1="140" x2="59.3" y2="126"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="308.5" y1="217" x2="153.3" y2="203"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="308.5" y1="140" x2="153.3" y2="126"/>
+  <text style="fill: #0000ff;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="213.5" y="84">
+    <tspan x="213.5" y="84">sink</tspan>
+    <tspan x="213.5" y="100">crop</tspan>
+    <tspan x="213.5" y="116">selection</tspan>
+  </text>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="30.5" y="89">
+    <tspan x="30.5" y="89"></tspan>
+  </text>
+  <text style="fill: #a52a2a;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="9.53836" y="88.9138">
+    <tspan x="9.53836" y="88.9138">sink media</tspan>
+    <tspan x="9.53836" y="104.914">bus format</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="333.644" y="185.65" width="165.2" height="172.478"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #00ff00" x="333.644" y="185.65" width="165.2" height="172.478"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="333.644" y1="358.128" x2="214.5" y2="217"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="333.644" y1="185.65" x2="214.5" y2="140"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="498.844" y1="358.128" x2="308.5" y2="217"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="498.844" y1="185.65" x2="308.5" y2="140"/>
+  <text style="fill: #00ff00;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="334.704" y="149.442">
+    <tspan x="334.704" y="149.442">sink compose</tspan>
+    <tspan x="334.704" y="165.442">selection (scaling)</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="541.322" y="135.565" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="541.322" y="135.565" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="541.322" y1="207.018" x2="386.64" y2="296.552"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="541.322" y1="135.565" x2="386.64" y2="225.1"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="641.508" y1="207.018" x2="486.826" y2="296.552"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="641.508" y1="135.565" x2="486.826" y2="225.1"/>
+  <text style="fill: #a020f0;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="541.322" y="97.4418">
+    <tspan x="541.322" y="97.4418">source</tspan>
+    <tspan x="541.322" y="113.442">crop</tspan>
+    <tspan x="541.322" y="129.442">selection</tspan>
+  </text>
+  <text style="fill: #8b6914;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="689.5" y="105.128">
+    <tspan x="689.5" y="105.128">source media</tspan>
+    <tspan x="689.5" y="121.128">bus format</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="688.488" y="173.834" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="688.488" y="173.834" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="688.488" y1="245.286" x2="541.322" y2="207.018"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="688.488" y1="173.834" x2="541.322" y2="135.565"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="788.674" y1="245.286" x2="641.508" y2="207.018"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="788.674" y1="173.834" x2="641.508" y2="135.565"/>
+  <text style="fill: #ff765a;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="325" y="103">
+    <tspan x="325" y="103">compose bounds</tspan>
+    <tspan x="325" y="119">selection</tspan>
+  </text>
+  <g>
+    <ellipse style="fill: #ffffff" cx="-12.0982" cy="341.512" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-12.0982" cy="341.512" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-12.0982" cy="341.512" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="-184.098" y1="341.8" x2="-30.3343" y2="341.529"/>
+    <polygon style="fill: #000000" points="-22.8343,341.516 -32.8254,346.534 -30.3343,341.529 -32.8431,336.534 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="-22.8343,341.516 -32.8254,346.534 -30.3343,341.529 -32.8431,336.534 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="-139" y="329">
+    <tspan x="-139" y="329">pad 1 (sink)</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="7.80824" y="292.8" width="112.092" height="82.2"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="7.80824" y="292.8" width="112.092" height="82.2"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="222.9" y="327.8" width="58.1" height="50.2"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="222.9" y="327.8" width="58.1" height="50.2"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="52.7" y="313.8" width="59.3" height="54.2"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #0000ff" x="52.7" y="313.8" width="59.3" height="54.2"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="222.9" y1="378" x2="52.7" y2="368"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="222.9" y1="327.8" x2="52.7" y2="313.8"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="281" y1="378" x2="112" y2="368"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="281" y1="327.8" x2="112" y2="313.8"/>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="31.9" y="259.8">
+    <tspan x="31.9" y="259.8"></tspan>
+  </text>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="358.9" y1="251.9" x2="222.9" y2="327.8"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="358.9" y1="316" x2="222.9" y2="378"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="434" y1="316" x2="281" y2="378"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="434" y1="251.9" x2="281" y2="327.8"/>
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #00ff00" x="358.9" y="251.9" width="75.1" height="64.1"/>
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #a020f0" x="386.64" y="225.1" width="100.186" height="71.4523"/>
+  <g>
+    <rect style="fill: #ffffff" x="598.262" y="265.466" width="45.778" height="38.535"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="598.262" y="265.466" width="45.778" height="38.535"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="598.262" y1="304" x2="404.94" y2="333"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="598.262" y1="265.466" x2="404.94" y2="293.9"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="644.04" y1="304" x2="453.04" y2="333"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="644.04" y1="265.466" x2="453.04" y2="293.9"/>
+  <g>
+    <rect style="fill: #ffffff" x="738.428" y="326.734" width="46.612" height="39.266"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="738.428" y="326.734" width="46.612" height="39.266"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="738.428" y1="366" x2="598.262" y2="304"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="738.428" y1="326.734" x2="598.262" y2="265.466"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="785.04" y1="366" x2="644.04" y2="304"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="785.04" y1="326.734" x2="644.04" y2="265.466"/>
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #a020f0" x="404.94" y="293.9" width="48.1" height="39.1"/>
+  <g>
+    <ellipse style="fill: #ffffff" cx="815.44" cy="343.984" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="815.44" cy="343.984" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="815.44" cy="343.984" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="823.94" y1="343.984" x2="980.274" y2="344.012"/>
+    <polygon style="fill: #000000" points="987.774,344.014 977.773,349.012 980.274,344.012 977.775,339.012 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="987.774,344.014 977.773,349.012 980.274,344.012 977.775,339.012 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="849.248" y="333.8">
+    <tspan x="849.248" y="333.8">pad 3 (source)</tspan>
+  </text>
+</svg>
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
new file mode 100644
index 0000000..a051812
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
@@ -0,0 +1,1407 @@
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
+        <dia:point val="-0.4,6.5"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-0.45,6.45;39.95,22.9"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="-0.4,6.5"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="40.299999999999997"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="16.349999999999998"/>
+      </dia:attribute>
+      <dia:attribute name="border_width">
+        <dia:real val="0.10000000149011612"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="false"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O1">
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
+    <dia:object type="Standard - Box" version="0" id="O2">
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
+    <dia:object type="Standard - Box" version="0" id="O3">
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
+    <dia:object type="Standard - Line" version="0" id="O4">
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
+        <dia:connection handle="0" to="O2" connection="5"/>
+        <dia:connection handle="1" to="O3" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O5">
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
+        <dia:connection handle="0" to="O2" connection="0"/>
+        <dia:connection handle="1" to="O3" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O6">
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
+        <dia:connection handle="0" to="O2" connection="7"/>
+        <dia:connection handle="1" to="O3" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O7">
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
+        <dia:connection handle="0" to="O2" connection="2"/>
+        <dia:connection handle="1" to="O3" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O8">
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
+    <dia:object type="Standard - Text" version="1" id="O9">
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
+    <dia:object type="Standard - Text" version="1" id="O10">
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
+    <dia:object type="Standard - Box" version="0" id="O11">
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
+    <dia:object type="Standard - Line" version="0" id="O12">
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
+        <dia:connection handle="0" to="O11" connection="5"/>
+        <dia:connection handle="1" to="O2" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O13">
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
+        <dia:connection handle="0" to="O11" connection="0"/>
+        <dia:connection handle="1" to="O2" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O14">
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
+        <dia:connection handle="0" to="O11" connection="7"/>
+        <dia:connection handle="1" to="O2" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O15">
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
+        <dia:connection handle="0" to="O11" connection="2"/>
+        <dia:connection handle="1" to="O2" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O16">
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
+    <dia:object type="Standard - Box" version="0" id="O17">
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
+    <dia:object type="Standard - Box" version="0" id="O18">
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
+    <dia:object type="Standard - Line" version="0" id="O19">
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
+        <dia:connection handle="0" to="O17" connection="5"/>
+        <dia:connection handle="1" to="O18" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O20">
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
+        <dia:connection handle="0" to="O17" connection="0"/>
+        <dia:connection handle="1" to="O18" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O21">
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
+        <dia:connection handle="0" to="O17" connection="7"/>
+        <dia:connection handle="1" to="O18" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O22">
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
+        <dia:connection handle="0" to="O17" connection="2"/>
+        <dia:connection handle="1" to="O18" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O23">
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
+    <dia:object type="Standard - Text" version="1" id="O24">
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
+    <dia:object type="Standard - Box" version="0" id="O25">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.5244,11.2917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="34.4744,11.2417;39.5837,14.9143"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="34.5244,11.2917"/>
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
+        <dia:color val="#8b6914"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O26">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.5244,14.8643"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.1051,12.8899;34.5854,14.9253"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.5244,14.8643"/>
+        <dia:point val="27.1661,12.9509"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O25" connection="5"/>
+        <dia:connection handle="1" to="O17" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O27">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.5244,11.2917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.1051,9.31728;34.5854,11.3527"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.5244,11.2917"/>
+        <dia:point val="27.1661,9.37825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O25" connection="0"/>
+        <dia:connection handle="1" to="O17" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O28">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.5337,14.8643"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.1144,12.8899;39.5947,14.9253"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.5337,14.8643"/>
+        <dia:point val="32.1754,12.9509"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O25" connection="7"/>
+        <dia:connection handle="1" to="O17" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O29">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.5337,11.2917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.1144,9.31728;39.5947,11.3527"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.5337,11.2917"/>
+        <dia:point val="32.1754,9.37825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O25" connection="2"/>
+        <dia:connection handle="1" to="O17" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O30">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.98,12.0742"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="39.93,12.0242;40.88,12.9742"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="39.98,12.0742"/>
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
+    <dia:object type="Standard - Line" version="0" id="O31">
+      <dia:attribute name="obj_pos">
+        <dia:point val="40.83,12.4992"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="40.78,12.1388;49.2453,12.8624"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="40.83,12.4992"/>
+        <dia:point val="49.1335,12.5007"/>
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
+        <dia:connection handle="0" to="O30" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O32">
+      <dia:attribute name="obj_pos">
+        <dia:point val="42.0954,11.99"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="42.0954,11.395;46.7404,12.1425"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 1 (source)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="42.0954,11.99"/>
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
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O33">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-1.44491,11.6506"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-1.49491,11.6006;-0.54491,12.5506"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="-1.44491,11.6506"/>
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
+    <dia:object type="Standard - Line" version="0" id="O34">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-9.61991,12.09"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-9.67,11.7149;-1.33311,12.4385"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="-9.61991,12.09"/>
+        <dia:point val="-1.44491,12.0756"/>
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
+        <dia:connection handle="1" to="O33" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O35">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-7.39291,11.49"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-7.39291,10.895;-3.58791,11.6425"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 0 (sink)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="-7.39291,11.49"/>
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
+    <dia:object type="Standard - Box" version="0" id="O36">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.0911,18.2833"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.0411,18.2333;32.1504,21.9059"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="27.0911,18.2833"/>
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
+    <dia:object type="Standard - Line" version="0" id="O37">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.0911,21.8559"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="17.9067,16.5093;27.1594,21.9242"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.0911,21.8559"/>
+        <dia:point val="17.975,16.5776"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O36" connection="5"/>
+        <dia:connection handle="1" to="O49" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O38">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.0911,18.2833"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="17.9067,12.9367;27.1594,18.3516"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.0911,18.2833"/>
+        <dia:point val="17.975,13.005"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O36" connection="0"/>
+        <dia:connection handle="1" to="O49" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O39">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.1004,21.8559"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="22.916,16.5093;32.1687,21.9242"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.1004,21.8559"/>
+        <dia:point val="22.9843,16.5776"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O36" connection="7"/>
+        <dia:connection handle="1" to="O49" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O40">
+      <dia:attribute name="obj_pos">
+        <dia:point val="32.1004,18.2833"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="22.916,12.9367;32.1687,18.3516"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="32.1004,18.2833"/>
+        <dia:point val="22.9843,13.005"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O36" connection="2"/>
+        <dia:connection handle="1" to="O49" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O41">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4994,17.2967"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="34.4494,17.2467;39.5587,20.9193"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="34.4994,17.2967"/>
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
+        <dia:color val="#8b6914"/>
+      </dia:attribute>
+      <dia:attribute name="show_background">
+        <dia:boolean val="true"/>
+      </dia:attribute>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O42">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4994,20.8693"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.0349,20.8132;34.5556,21.912"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.4994,20.8693"/>
+        <dia:point val="27.0911,21.8559"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O41" connection="5"/>
+        <dia:connection handle="1" to="O36" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O43">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4994,17.2967"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.0349,17.2405;34.5556,18.3394"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.4994,17.2967"/>
+        <dia:point val="27.0911,18.2833"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O41" connection="0"/>
+        <dia:connection handle="1" to="O36" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O44">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.5087,20.8693"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.0442,20.8132;39.5649,21.912"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.5087,20.8693"/>
+        <dia:point val="32.1004,21.8559"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O41" connection="7"/>
+        <dia:connection handle="1" to="O36" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O45">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.5087,17.2967"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="32.0442,17.2405;39.5649,18.3394"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.5087,17.2967"/>
+        <dia:point val="32.1004,18.2833"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O41" connection="2"/>
+        <dia:connection handle="1" to="O36" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O46">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.855,18.7792"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="39.805,18.7292;40.755,19.6792"/>
+      </dia:attribute>
+      <dia:attribute name="meta">
+        <dia:composite type="dict"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="39.855,18.7792"/>
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
+    <dia:object type="Standard - Line" version="0" id="O47">
+      <dia:attribute name="obj_pos">
+        <dia:point val="40.705,19.2042"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="40.655,18.8438;49.1203,19.5674"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="40.705,19.2042"/>
+        <dia:point val="49.0085,19.2057"/>
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
+        <dia:connection handle="0" to="O46" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O48">
+      <dia:attribute name="obj_pos">
+        <dia:point val="41.9704,18.695"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="41.9704,18.0813;46.6341,18.8849"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#pad 2 (source)#</dia:string>
+          </dia:attribute>
+          <dia:attribute name="font">
+            <dia:font family="sans" style="0" name="Helvetica"/>
+          </dia:attribute>
+          <dia:attribute name="height">
+            <dia:real val="0.80000000000000004"/>
+          </dia:attribute>
+          <dia:attribute name="pos">
+            <dia:point val="41.9704,18.695"/>
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
+    <dia:object type="Standard - Box" version="0" id="O49">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.975,13.005"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="17.925,12.955;23.0343,16.6276"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="17.975,13.005"/>
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
+        <dia:boolean val="false"/>
+      </dia:attribute>
+      <dia:attribute name="line_style">
+        <dia:enum val="4"/>
+      </dia:attribute>
+    </dia:object>
+  </dia:layer>
+</dia:diagram>
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
new file mode 100644
index 0000000..eadb774
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
@@ -0,0 +1,130 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
+<svg width="59cm" height="17cm" viewBox="-194 128 1179 330" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="-8" y="130" width="806" height="327"/>
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
+  <text style="fill: #8b6914;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="691.5" y="157.128">
+    <tspan x="691.5" y="157.128">source media</tspan>
+    <tspan x="691.5" y="173.128">bus format</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="690.488" y="225.834" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="690.488" y="225.834" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="690.488" y1="297.286" x2="543.322" y2="259.018"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="690.488" y1="225.834" x2="543.322" y2="187.565"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="790.674" y1="297.286" x2="643.508" y2="259.018"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="790.674" y1="225.834" x2="643.508" y2="187.565"/>
+  <g>
+    <ellipse style="fill: #ffffff" cx="808.1" cy="249.984" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="808.1" cy="249.984" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="808.1" cy="249.984" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="816.6" y1="249.984" x2="972.934" y2="250.012"/>
+    <polygon style="fill: #000000" points="980.434,250.014 970.433,255.012 972.934,250.012 970.435,245.012 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="980.434,250.014 970.433,255.012 972.934,250.012 970.435,245.012 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="841.908" y="239.8">
+    <tspan x="841.908" y="239.8">pad 1 (source)</tspan>
+  </text>
+  <g>
+    <ellipse style="fill: #ffffff" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="-20.3982" cy="241.512" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="-192.398" y1="241.8" x2="-38.6343" y2="241.529"/>
+    <polygon style="fill: #000000" points="-31.1343,241.516 -41.1254,246.534 -38.6343,241.529 -41.1431,236.534 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="-31.1343,241.516 -41.1254,246.534 -38.6343,241.529 -41.1431,236.534 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="-147.858" y="229.8">
+    <tspan x="-147.858" y="229.8">pad 0 (sink)</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="541.822" y="365.666" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="541.822" y="365.666" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="541.822" y1="437.118" x2="359.5" y2="331.552"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="541.822" y1="365.666" x2="359.5" y2="260.1"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="642.008" y1="437.118" x2="459.686" y2="331.552"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="642.008" y1="365.666" x2="459.686" y2="260.1"/>
+  <g>
+    <rect style="fill: #ffffff" x="689.988" y="345.934" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="689.988" y="345.934" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="689.988" y1="417.386" x2="541.822" y2="437.118"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="689.988" y1="345.934" x2="541.822" y2="365.666"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="790.174" y1="417.386" x2="642.008" y2="437.118"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="790.174" y1="345.934" x2="642.008" y2="365.666"/>
+  <g>
+    <ellipse style="fill: #ffffff" cx="805.6" cy="384.084" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="805.6" cy="384.084" rx="8.5" ry="8.5"/>
+    <ellipse style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" cx="805.6" cy="384.084" rx="8.5" ry="8.5"/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x1="814.1" y1="384.084" x2="970.434" y2="384.112"/>
+    <polygon style="fill: #000000" points="977.934,384.114 967.933,389.112 970.434,384.112 967.935,379.112 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" points="977.934,384.114 967.933,389.112 970.434,384.112 967.935,379.112 "/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="839.408" y="373.9">
+    <tspan x="839.408" y="373.9">pad 2 (source)</tspan>
+  </text>
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke-dasharray: 4; stroke: #a020f0" x="359.5" y="260.1" width="100.186" height="71.4523"/>
+</svg>
-- 
1.7.2.5

