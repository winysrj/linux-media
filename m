Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:28021 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343Ab2CBRc4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Mar 2012 12:32:56 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: [PATCH v4 08/34] v4l: Add subdev selections documentation: svg and dia files
Date: Fri,  2 Mar 2012 19:30:16 +0200
Message-Id: <1330709442-16654-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120302173219.GA15695@valkosipuli.localdomain>
References: <20120302173219.GA15695@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add svga and dia files for V4L2 subdev selections documentation.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 .../media/v4l/subdev-image-processing-crop.dia     |  602 ++++++++
 .../media/v4l/subdev-image-processing-crop.svg     |   63 +
 .../media/v4l/subdev-image-processing-full.dia     | 1540 ++++++++++++++++++++
 .../media/v4l/subdev-image-processing-full.svg     |  163 +++
 ...ubdev-image-processing-scaling-multi-source.dia | 1116 ++++++++++++++
 ...ubdev-image-processing-scaling-multi-source.svg |  116 ++
 6 files changed, 3600 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
 create mode 100644 Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg

diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
new file mode 100644
index 0000000..899b8fd
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.dia
@@ -0,0 +1,602 @@
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
+        <dia:point val="3.175,10.55"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="3.125,10.5;7.925,14.45"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="3.175,10.55"/>
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
+    <dia:object type="Standard - Text" version="1" id="O3">
+      <dia:attribute name="obj_pos">
+        <dia:point val="3.725,11.3875"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="3.725,10.7925;6.6025,13.14"/>
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
+            <dia:point val="3.725,11.3875"/>
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
+    <dia:object type="Standard - Text" version="1" id="O4">
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
+    <dia:object type="Standard - Text" version="1" id="O5">
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
+    <dia:object type="Standard - Text" version="1" id="O6">
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
+    <dia:object type="Standard - Box" version="0" id="O7">
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
+    <dia:object type="Standard - Line" version="0" id="O8">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.5244,13.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="3.12132,13.2463;17.5781,14.4537"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="17.5244,13.3"/>
+        <dia:point val="3.175,14.4"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O7" connection="5"/>
+        <dia:connection handle="1" to="O2" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O9">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.5244,9.5417"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="3.12162,9.48832;17.5778,10.6034"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="17.5244,9.5417"/>
+        <dia:point val="3.175,10.55"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O7" connection="0"/>
+        <dia:connection handle="1" to="O2" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O10">
+      <dia:attribute name="obj_pos">
+        <dia:point val="22.1887,13.3"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.82132,13.2463;22.2424,14.4537"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="22.1887,13.3"/>
+        <dia:point val="7.875,14.4"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O7" connection="7"/>
+        <dia:connection handle="1" to="O2" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O11">
+      <dia:attribute name="obj_pos">
+        <dia:point val="22.1887,9.5417"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.82161,9.48831;22.2421,10.6034"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="22.1887,9.5417"/>
+        <dia:point val="7.875,10.55"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O7" connection="2"/>
+        <dia:connection handle="1" to="O2" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O12">
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
+    <dia:object type="Standard - Line" version="0" id="O13">
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
+        <dia:connection handle="0" to="O12" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O14">
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
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O15">
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
+    <dia:object type="Standard - Line" version="0" id="O16">
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
+        <dia:connection handle="1" to="O15" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O17">
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
index 0000000..3da6ed7
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-crop.svg
@@ -0,0 +1,63 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
+<svg width="43cm" height="10cm" viewBox="-194 128 844 196" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="-8" y="130" width="469.774" height="193"/>
+  <g>
+    <rect style="fill: #ffffff" x="4.5" y="189" width="159" height="104"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="4.5" y="189" width="159" height="104"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="63.5" y="211" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="63.5" y="211" width="94" height="77"/>
+  </g>
+  <text style="fill: #0000ff;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="74.5" y="227.75">
+    <tspan x="74.5" y="227.75">sink</tspan>
+    <tspan x="74.5" y="243.75">crop</tspan>
+    <tspan x="74.5" y="259.75">selection</tspan>
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
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="350.488" y1="266" x2="63.5" y2="288"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="350.488" y1="190.834" x2="63.5" y2="211"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="443.774" y1="266" x2="157.5" y2="288"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="443.774" y1="190.834" x2="157.5" y2="211"/>
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
index 0000000..4976611
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-full.dia
@@ -0,0 +1,1540 @@
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
+        <dia:point val="3.125,6.8"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="3.075,6.75;7.875,10.7"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="3.125,6.8"/>
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
+    <dia:object type="Standard - Text" version="1" id="O10">
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
+    <dia:object type="Standard - Text" version="1" id="O11">
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
+    <dia:object type="Standard - Box" version="0" id="O12">
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
+    <dia:object type="Standard - Line" version="0" id="O13">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.6822,17.9064"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="3.05732,10.5823;16.7499,17.9741"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="16.6822,17.9064"/>
+        <dia:point val="3.125,10.65"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O12" connection="5"/>
+        <dia:connection handle="1" to="O9" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O14">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.6822,9.28251"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="3.06681,6.74181;16.7404,9.3407"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="16.6822,9.28251"/>
+        <dia:point val="3.125,6.8"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O12" connection="0"/>
+        <dia:connection handle="1" to="O9" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O15">
+      <dia:attribute name="obj_pos">
+        <dia:point val="24.9422,17.9064"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.75945,10.5845;25.0077,17.9719"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.9422,17.9064"/>
+        <dia:point val="7.825,10.65"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O12" connection="7"/>
+        <dia:connection handle="1" to="O9" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O16">
+      <dia:attribute name="obj_pos">
+        <dia:point val="24.9422,9.28251"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.76834,6.74334;24.9989,9.33917"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.9422,9.28251"/>
+        <dia:point val="7.825,6.8"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O12" connection="2"/>
+        <dia:connection handle="1" to="O9" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O17">
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
+    <dia:object type="Standard - Box" version="0" id="O18">
+      <dia:attribute name="obj_pos">
+        <dia:point val="20.4661,9.72825"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="20.4161,9.67825;25.5254,13.3509"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="20.4661,9.72825"/>
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
+    <dia:object type="Standard - Text" version="1" id="O19">
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
+    <dia:object type="Standard - Box" version="0" id="O20">
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
+    <dia:object type="Standard - Line" version="0" id="O21">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4244,12.2643"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="20.4125,12.2107;34.478,13.3544"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.4244,12.2643"/>
+        <dia:point val="20.4661,13.3009"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O20" connection="5"/>
+        <dia:connection handle="1" to="O18" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O22">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4244,8.6917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="20.4125,8.63813;34.478,9.78182"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.4244,8.6917"/>
+        <dia:point val="20.4661,9.72825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O20" connection="0"/>
+        <dia:connection handle="1" to="O18" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O23">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.4337,12.2643"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="25.4218,12.2107;39.4873,13.3544"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.4337,12.2643"/>
+        <dia:point val="25.4754,13.3009"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O20" connection="7"/>
+        <dia:connection handle="1" to="O18" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O24">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.4337,8.6917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="25.4218,8.63813;39.4873,9.78182"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.4337,8.6917"/>
+        <dia:point val="25.4754,9.72825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O20" connection="2"/>
+        <dia:connection handle="1" to="O18" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O25">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.25,5.15"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="16.25,4.555;21.68,6.1025"/>
+      </dia:attribute>
+      <dia:attribute name="text">
+        <dia:composite type="text">
+          <dia:attribute name="string">
+            <dia:string>#sink compose
+bounds selection#</dia:string>
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
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O26">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-1.02991,16.6506"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-1.07991,16.6006;-0.12991,17.5506"/>
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
+    <dia:object type="Standard - Line" version="0" id="O27">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-9.20491,17.09"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-9.255,16.7149;-0.918107,17.4385"/>
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
+        <dia:connection handle="1" to="O26" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O28">
+      <dia:attribute name="obj_pos">
+        <dia:point val="-6.95,16.45"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="-6.95,15.855;-3.145,16.6025"/>
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
+    <dia:object type="Standard - Box" version="0" id="O29">
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
+    <dia:object type="Standard - Box" version="0" id="O30">
+      <dia:attribute name="obj_pos">
+        <dia:point val="2.645,15.74"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.595,15.69;5.6,18.3"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="2.645,15.74"/>
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
+    <dia:object type="Standard - Text" version="1" id="O31">
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
+    <dia:object type="Standard - Line" version="0" id="O32">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.945,12.595"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.58596,12.536;18.004,15.799"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="17.945,12.595"/>
+        <dia:point val="2.645,15.74"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O36" connection="0"/>
+        <dia:connection handle="1" to="O30" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O33">
+      <dia:attribute name="obj_pos">
+        <dia:point val="17.945,15.8"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.58772,15.7427;18.0023,18.3073"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="17.945,15.8"/>
+        <dia:point val="2.645,18.25"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O36" connection="5"/>
+        <dia:connection handle="1" to="O30" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O34">
+      <dia:attribute name="obj_pos">
+        <dia:point val="21.7,15.8"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="5.49307,15.7431;21.7569,18.3069"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="21.7,15.8"/>
+        <dia:point val="5.55,18.25"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O36" connection="7"/>
+        <dia:connection handle="1" to="O30" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O35">
+      <dia:attribute name="obj_pos">
+        <dia:point val="21.7,12.595"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="5.49136,12.5364;21.7586,15.7986"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="21.7,12.595"/>
+        <dia:point val="5.55,15.74"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O36" connection="2"/>
+        <dia:connection handle="1" to="O30" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O36">
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
+    <dia:object type="Standard - Box" version="0" id="O37">
+      <dia:attribute name="obj_pos">
+        <dia:point val="22.1631,14.2233"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="22.1131,14.1733;25.45,16.7"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="22.1631,14.2233"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="3.2369000000000021"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="2.4267000000000003"/>
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
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O38">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.6714,16.2367"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="34.6214,16.1867;37.9,18.75"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="34.6714,16.2367"/>
+      </dia:attribute>
+      <dia:attribute name="elem_width">
+        <dia:real val="3.178600000000003"/>
+      </dia:attribute>
+      <dia:attribute name="elem_height">
+        <dia:real val="2.4632999999999967"/>
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
+    <dia:object type="Standard - Line" version="0" id="O39">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.6714,18.7"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="22.1057,16.5926;34.7288,18.7574"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.6714,18.7"/>
+        <dia:point val="22.1631,16.65"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O38" connection="5"/>
+        <dia:connection handle="1" to="O37" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O40">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.6714,16.2367"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="22.1058,14.166;34.7287,16.294"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.6714,16.2367"/>
+        <dia:point val="22.1631,14.2233"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O38" connection="0"/>
+        <dia:connection handle="1" to="O37" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O41">
+      <dia:attribute name="obj_pos">
+        <dia:point val="37.85,18.7"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="25.3425,16.5925;37.9075,18.7575"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="37.85,18.7"/>
+        <dia:point val="25.4,16.65"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O38" connection="7"/>
+        <dia:connection handle="1" to="O37" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O42">
+      <dia:attribute name="obj_pos">
+        <dia:point val="37.85,16.2367"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="25.3427,14.166;37.9073,16.294"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="37.85,16.2367"/>
+        <dia:point val="25.4,14.2233"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O38" connection="2"/>
+        <dia:connection handle="1" to="O37" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O43">
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
+    <dia:object type="Standard - Line" version="0" id="O44">
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
+        <dia:connection handle="0" to="O43" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O45">
+      <dia:attribute name="obj_pos">
+        <dia:point val="42.4624,16.69"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="42.4624,16.095;47.1074,16.8425"/>
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
+    <dia:object type="Standard - Text" version="1" id="O46">
+      <dia:attribute name="obj_pos">
+        <dia:point val="9.85,4.55"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="9.85,3.955;12.7275,6.3025"/>
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
+            <dia:point val="9.85,4.55"/>
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
+    <dia:object type="Standard - Text" version="1" id="O47">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.65,4.75"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="27.65,4.155;30.5275,6.5025"/>
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
+            <dia:point val="27.65,4.75"/>
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
+    <dia:object type="Standard - Line" version="0" id="O48">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.55,6.6"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.7135,6.39438;10.6035,7.11605"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="10.55,6.6"/>
+        <dia:point val="7.825,6.8"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#0000ff"/>
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
+        <dia:connection handle="1" to="O9" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O49">
+      <dia:attribute name="obj_pos">
+        <dia:point val="10.45,6.55"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="5.48029,6.48236;10.5176,15.8387"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="10.45,6.55"/>
+        <dia:point val="5.55,15.74"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#0000ff"/>
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
+        <dia:connection handle="1" to="O30" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O50">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.5246,6.66071"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="25.4061,6.59136;27.594,9.82122"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.5246,6.66071"/>
+        <dia:point val="25.4754,9.72825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#a020f0"/>
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
+        <dia:connection handle="1" to="O18" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O51">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.5036,6.68935"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="25.2161,6.62775;27.5652,14.331"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.5036,6.68935"/>
+        <dia:point val="25.4,14.2233"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#a020f0"/>
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
+  </dia:layer>
+</dia:diagram>
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-full.svg b/Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
new file mode 100644
index 0000000..edb33fb
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-full.svg
@@ -0,0 +1,163 @@
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
+    <rect style="fill: #ffffff" x="62.5" y="136" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="62.5" y="136" width="94" height="77"/>
+  </g>
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
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="333.644" y1="358.128" x2="62.5" y2="213"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="333.644" y1="185.65" x2="62.5" y2="136"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="498.844" y1="358.128" x2="156.5" y2="213"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="498.844" y1="185.65" x2="156.5" y2="136"/>
+  <text style="fill: #00ff00;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="334.704" y="149.442">
+    <tspan x="334.704" y="149.442">sink compose</tspan>
+    <tspan x="334.704" y="165.442">selection (scaling)</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="409.322" y="194.565" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="409.322" y="194.565" width="100.186" height="71.4523"/>
+  </g>
+  <text style="fill: #8b6914;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="689.5" y="105.128">
+    <tspan x="689.5" y="105.128">source media</tspan>
+    <tspan x="689.5" y="121.128">bus format</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="688.488" y="173.834" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="688.488" y="173.834" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="688.488" y1="245.286" x2="409.322" y2="266.017"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="688.488" y1="173.834" x2="409.322" y2="194.565"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="788.674" y1="245.286" x2="509.508" y2="266.017"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="788.674" y1="173.834" x2="509.508" y2="194.565"/>
+  <text style="fill: #ff765a;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="325" y="103">
+    <tspan x="325" y="103">sink compose</tspan>
+    <tspan x="325" y="119">bounds selection</tspan>
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
+    <rect style="fill: #ffffff" x="52.9" y="314.8" width="58.1" height="50.2"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="52.9" y="314.8" width="58.1" height="50.2"/>
+  </g>
+  <text style="fill: #000000;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="31.9" y="259.8">
+    <tspan x="31.9" y="259.8"></tspan>
+  </text>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="358.9" y1="251.9" x2="52.9" y2="314.8"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="358.9" y1="316" x2="52.9" y2="365"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="434" y1="316" x2="111" y2="365"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="434" y1="251.9" x2="111" y2="314.8"/>
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #00ff00" x="358.9" y="251.9" width="75.1" height="64.1"/>
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="443.262" y="284.466" width="64.738" height="48.534"/>
+  <g>
+    <rect style="fill: #ffffff" x="693.428" y="324.734" width="63.572" height="49.266"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="693.428" y="324.734" width="63.572" height="49.266"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="693.428" y1="374" x2="443.262" y2="333"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="693.428" y1="324.734" x2="443.262" y2="284.466"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="757" y1="374" x2="508" y2="333"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="757" y1="324.734" x2="508" y2="284.466"/>
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
+  <text style="fill: #0000ff;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="197" y="91">
+    <tspan x="197" y="91">sink</tspan>
+    <tspan x="197" y="107">crop</tspan>
+    <tspan x="197" y="123">selection</tspan>
+  </text>
+  <text style="fill: #a020f0;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="553" y="95">
+    <tspan x="553" y="95">source</tspan>
+    <tspan x="553" y="111">crop</tspan>
+    <tspan x="553" y="127">selection</tspan>
+  </text>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x1="211" y1="132" x2="166.21" y2="135.287"/>
+    <polygon style="fill: #0000ff" points="158.73,135.836 168.337,130.118 166.21,135.287 169.069,140.091 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" points="158.73,135.836 168.337,130.118 166.21,135.287 169.069,140.091 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x1="209" y1="131" x2="115.581" y2="306.209"/>
+    <polygon style="fill: #0000ff" points="112.052,312.827 112.345,301.65 115.581,306.209 121.169,306.355 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" points="112.052,312.827 112.345,301.65 115.581,306.209 121.169,306.355 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x1="550.493" y1="133.214" x2="514.916" y2="186.469"/>
+    <polygon style="fill: #a020f0" points="510.75,192.706 512.148,181.613 514.916,186.469 520.463,187.168 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" points="510.75,192.706 512.148,181.613 514.916,186.469 520.463,187.168 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x1="550.071" y1="133.787" x2="510.618" y2="275.089"/>
+    <polygon style="fill: #a020f0" points="508.601,282.312 506.475,271.336 510.618,275.089 516.106,274.025 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" points="508.601,282.312 506.475,271.336 510.618,275.089 516.106,274.025 "/>
+  </g>
+</svg>
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
new file mode 100644
index 0000000..be14456
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.dia
@@ -0,0 +1,1116 @@
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
+        <dia:point val="2.475,10.2"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.425,10.15;7.225,14.1"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="2.475,10.2"/>
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
+    <dia:object type="Standard - Text" version="1" id="O3">
+      <dia:attribute name="obj_pos">
+        <dia:point val="3,11.2"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="3,10.605;5.8775,12.9525"/>
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
+            <dia:point val="3,11.2"/>
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
+    <dia:object type="Standard - Text" version="1" id="O4">
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
+    <dia:object type="Standard - Text" version="1" id="O5">
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
+    <dia:object type="Standard - Box" version="0" id="O6">
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
+    <dia:object type="Standard - Line" version="0" id="O7">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.6822,17.9064"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.41365,13.9886;16.7436,17.9678"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="16.6822,17.9064"/>
+        <dia:point val="2.475,14.05"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O6" connection="5"/>
+        <dia:connection handle="1" to="O2" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O8">
+      <dia:attribute name="obj_pos">
+        <dia:point val="16.6822,9.28251"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="2.42188,9.22939;16.7353,10.2531"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="16.6822,9.28251"/>
+        <dia:point val="2.475,10.2"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O6" connection="0"/>
+        <dia:connection handle="1" to="O2" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O9">
+      <dia:attribute name="obj_pos">
+        <dia:point val="24.9422,17.9064"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.11553,13.9905;25.0017,17.9659"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.9422,17.9064"/>
+        <dia:point val="7.175,14.05"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O6" connection="7"/>
+        <dia:connection handle="1" to="O2" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O10">
+      <dia:attribute name="obj_pos">
+        <dia:point val="24.9422,9.28251"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="7.12249,9.23;24.9947,10.2525"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="24.9422,9.28251"/>
+        <dia:point val="7.175,10.2"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O6" connection="2"/>
+        <dia:connection handle="1" to="O2" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O11">
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
+    <dia:object type="Standard - Box" version="0" id="O12">
+      <dia:attribute name="obj_pos">
+        <dia:point val="19.1161,9.97825"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.0661,9.92825;24.1754,13.6009"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="19.1161,9.97825"/>
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
+    <dia:object type="Standard - Text" version="1" id="O13">
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
+    <dia:object type="Standard - Text" version="1" id="O14">
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
+    <dia:object type="Standard - Box" version="0" id="O15">
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
+    <dia:object type="Standard - Line" version="0" id="O16">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.5244,14.8643"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.062,13.4968;34.5785,14.9184"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.5244,14.8643"/>
+        <dia:point val="19.1161,13.5509"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O15" connection="5"/>
+        <dia:connection handle="1" to="O12" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O17">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.5244,11.2917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.062,9.92418;34.5785,11.3458"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.5244,11.2917"/>
+        <dia:point val="19.1161,9.97825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O15" connection="0"/>
+        <dia:connection handle="1" to="O12" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O18">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.5337,14.8643"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.0713,13.4968;39.5878,14.9184"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.5337,14.8643"/>
+        <dia:point val="24.1254,13.5509"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O15" connection="7"/>
+        <dia:connection handle="1" to="O12" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O19">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.5337,11.2917"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.0713,9.92418;39.5878,11.3458"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.5337,11.2917"/>
+        <dia:point val="24.1254,9.97825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O15" connection="2"/>
+        <dia:connection handle="1" to="O12" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O20">
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
+    <dia:object type="Standard - Line" version="0" id="O21">
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
+        <dia:connection handle="0" to="O20" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O22">
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
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O23">
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
+    <dia:object type="Standard - Line" version="0" id="O24">
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
+        <dia:connection handle="1" to="O23" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O25">
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
+    <dia:object type="Standard - Box" version="0" id="O26">
+      <dia:attribute name="obj_pos">
+        <dia:point val="19.4911,13.8333"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.4411,13.7833;24.5504,17.4559"/>
+      </dia:attribute>
+      <dia:attribute name="elem_corner">
+        <dia:point val="19.4911,13.8333"/>
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
+    </dia:object>
+    <dia:object type="Standard - Box" version="0" id="O27">
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
+    <dia:object type="Standard - Line" version="0" id="O28">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4994,20.8693"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.4311,17.346;34.5594,20.9293"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.4994,20.8693"/>
+        <dia:point val="19.4911,17.4059"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O27" connection="5"/>
+        <dia:connection handle="1" to="O26" connection="5"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O29">
+      <dia:attribute name="obj_pos">
+        <dia:point val="34.4994,17.2967"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="19.4311,13.7733;34.5594,17.3567"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="34.4994,17.2967"/>
+        <dia:point val="19.4911,13.8333"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O27" connection="0"/>
+        <dia:connection handle="1" to="O26" connection="0"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O30">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.5087,20.8693"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.4404,17.346;39.5687,20.9293"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.5087,20.8693"/>
+        <dia:point val="24.5004,17.4059"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O27" connection="7"/>
+        <dia:connection handle="1" to="O26" connection="7"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O31">
+      <dia:attribute name="obj_pos">
+        <dia:point val="39.5087,17.2967"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.4404,13.7733;39.5687,17.3567"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="39.5087,17.2967"/>
+        <dia:point val="24.5004,13.8333"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#e60505"/>
+      </dia:attribute>
+      <dia:connections>
+        <dia:connection handle="0" to="O27" connection="2"/>
+        <dia:connection handle="1" to="O26" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Geometric - Perfect Circle" version="1" id="O32">
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
+    <dia:object type="Standard - Line" version="0" id="O33">
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
+        <dia:connection handle="0" to="O32" connection="3"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Text" version="1" id="O34">
+      <dia:attribute name="obj_pos">
+        <dia:point val="41.9704,18.695"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="41.9704,18.1;46.6154,18.8475"/>
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
+    <dia:object type="Standard - Line" version="0" id="O35">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.3,9.55"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.0146,9.49376;27.3562,10.255"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.3,9.55"/>
+        <dia:point val="24.1254,9.97825"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#a020f0"/>
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
+        <dia:connection handle="1" to="O12" connection="2"/>
+      </dia:connections>
+    </dia:object>
+    <dia:object type="Standard - Line" version="0" id="O36">
+      <dia:attribute name="obj_pos">
+        <dia:point val="27.3454,9.53624"/>
+      </dia:attribute>
+      <dia:attribute name="obj_bb">
+        <dia:rectangle val="24.4311,9.46694;27.4147,13.9265"/>
+      </dia:attribute>
+      <dia:attribute name="conn_endpoints">
+        <dia:point val="27.3454,9.53624"/>
+        <dia:point val="24.5004,13.8333"/>
+      </dia:attribute>
+      <dia:attribute name="numcp">
+        <dia:int val="1"/>
+      </dia:attribute>
+      <dia:attribute name="line_color">
+        <dia:color val="#a020f0"/>
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
+        <dia:connection handle="1" to="O26" connection="2"/>
+      </dia:connections>
+    </dia:object>
+  </dia:layer>
+</dia:diagram>
diff --git a/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
new file mode 100644
index 0000000..7fb5fa7
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/subdev-image-processing-scaling-multi-source.svg
@@ -0,0 +1,116 @@
+<?xml version="1.0" encoding="UTF-8" standalone="no"?>
+<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/PR-SVG-20010719/DTD/svg10.dtd">
+<svg width="59cm" height="17cm" viewBox="-194 128 1179 330" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #000000" x="-8" y="130" width="806" height="327"/>
+  <g>
+    <rect style="fill: #ffffff" x="4.5" y="189" width="159" height="104"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a52a2a" x="4.5" y="189" width="159" height="104"/>
+  </g>
+  <g>
+    <rect style="fill: #ffffff" x="49.5" y="204" width="94" height="77"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #0000ff" x="49.5" y="204" width="94" height="77"/>
+  </g>
+  <text style="fill: #0000ff;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="60" y="224">
+    <tspan x="60" y="224">sink</tspan>
+    <tspan x="60" y="240">crop</tspan>
+    <tspan x="60" y="256">selection</tspan>
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
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="333.644" y1="358.128" x2="49.5" y2="281"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="333.644" y1="185.65" x2="49.5" y2="204"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="498.844" y1="358.128" x2="143.5" y2="281"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="498.844" y1="185.65" x2="143.5" y2="204"/>
+  <text style="fill: #00ff00;text-anchor:start;font-size:12.8;font-family:sanserif;font-style:normal;font-weight:normal" x="334.704" y="149.442">
+    <tspan x="334.704" y="149.442">sink compose</tspan>
+    <tspan x="334.704" y="165.442">selection (scaling)</tspan>
+  </text>
+  <g>
+    <rect style="fill: #ffffff" x="382.322" y="199.565" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="382.322" y="199.565" width="100.186" height="71.4523"/>
+  </g>
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
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="690.488" y1="297.286" x2="382.322" y2="271.017"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="690.488" y1="225.834" x2="382.322" y2="199.565"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="790.674" y1="297.286" x2="482.508" y2="271.017"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="790.674" y1="225.834" x2="482.508" y2="199.565"/>
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
+  <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x="389.822" y="276.666" width="100.186" height="71.4523"/>
+  <g>
+    <rect style="fill: #ffffff" x="689.988" y="345.934" width="100.186" height="71.4523"/>
+    <rect style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #8b6914" x="689.988" y="345.934" width="100.186" height="71.4523"/>
+  </g>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="689.988" y1="417.386" x2="389.822" y2="348.118"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="689.988" y1="345.934" x2="389.822" y2="276.666"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="790.174" y1="417.386" x2="490.008" y2="348.118"/>
+  <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #e60505" x1="790.174" y1="345.934" x2="490.008" y2="276.666"/>
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
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x1="546" y1="191" x2="492.157" y2="198.263"/>
+    <polygon style="fill: #a020f0" points="484.724,199.266 493.966,192.974 492.157,198.263 495.303,202.884 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" points="484.724,199.266 493.966,192.974 492.157,198.263 495.303,202.884 "/>
+  </g>
+  <g>
+    <line style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" x1="546.908" y1="190.725" x2="495.383" y2="268.548"/>
+    <polygon style="fill: #a020f0" points="491.243,274.802 492.594,263.703 495.383,268.548 500.932,269.224 "/>
+    <polygon style="fill: none; fill-opacity:0; stroke-width: 2; stroke: #a020f0" points="491.243,274.802 492.594,263.703 495.383,268.548 500.932,269.224 "/>
+  </g>
+</svg>
-- 
1.7.2.5

