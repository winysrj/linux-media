Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2458 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3HVKPE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 06:15:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: ismael.luceno@corp.bluecherry.net, pete@sensoray.com,
	sakari.ailus@iki.fi, sylvester.nawrocki@gmail.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 09/10] DocBook: document the new v4l2 matrix ioctls.
Date: Thu, 22 Aug 2013 12:14:23 +0200
Message-Id: <662b2748c249934cbb0d7052fdfe728691561e44.1377166147.git.hans.verkuil@cisco.com>
In-Reply-To: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
References: <1377166464-27448-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
References: <7c5a78eea892dd37d172f24081402be354758894.1377166147.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/v4l2.xml           |   2 +
 .../DocBook/media/v4l/vidioc-g-matrix.xml          | 108 +++++++++++++
 .../DocBook/media/v4l/vidioc-query-matrix.xml      | 180 +++++++++++++++++++++
 3 files changed, 290 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-matrix.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-query-matrix.xml

diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 8469fe1..11687d5 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -584,6 +584,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-g-frequency;
     &sub-g-input;
     &sub-g-jpegcomp;
+    &sub-g-matrix;
     &sub-g-modulator;
     &sub-g-output;
     &sub-g-parm;
@@ -600,6 +601,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-querycap;
     &sub-queryctrl;
     &sub-query-dv-timings;
+    &sub-query-matrix;
     &sub-querystd;
     &sub-reqbufs;
     &sub-s-hw-freq-seek;
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-matrix.xml b/Documentation/DocBook/media/v4l/vidioc-g-matrix.xml
new file mode 100644
index 0000000..9db30f1
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-g-matrix.xml
@@ -0,0 +1,108 @@
+<refentry id="vidioc-g-matrix">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_G_MATRIX, VIDIOC_S_MATRIX</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_G_MATRIX</refname>
+    <refname>VIDIOC_S_MATRIX</refname>
+    <refpurpose>Get or set a matrix</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_matrix
+*<parameter>argp</parameter></paramdef>
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
+	  <para>VIDIOC_G_MATRIX, VIDIOC_S_MATRIX</para>
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
+    <para>Get or set the elements of a matrix. To get a matrix the application fills in the
+    <structfield>type</structfield> and zeroes the <structfield>reserved</structfield>
+    field of &v4l2-matrix;. All other fields will be returned by the driver.
+    To set a matrix the application fills in all the fields of the structure and zeroes the
+    <structfield>reserved</structfield> field.
+    </para>
+
+    <table frame="none" pgwide="1" id="v4l2-matrix">
+      <title>struct <structname>v4l2_matrix</structname></title>
+      <tgroup cols="4">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+            <entry></entry>
+	    <entry>Type of the matrix, see <xref linkend="v4l2-matrix-type" />.</entry>
+	  </row>
+	  <row>
+	    <entry>&v4l2-rect;</entry>
+	    <entry><structfield>rect</structfield></entry>
+            <entry></entry>
+	    <entry>The subset of the matrix that you want to get or set. The rectangle
+	    must fit within the total matrix dimensions, the top left element of the total
+	    matrix is always (0, 0). To get/set the full matrix <structfield>rect</structfield>
+	    should be set to (0, 0, <structfield>columns</structfield>, <structfield>rows</structfield>),
+	    where <structfield>columns</structfield> and <structfield>rows</structfield> are
+	    obtained from &VIDIOC-QUERY-MATRIX;.</entry>
+	  </row>
+	  <row>
+	    <entry>void *</entry>
+	    <entry><structfield>matrix</structfield></entry>
+            <entry></entry>
+	    <entry>A pointer to the matrix. This matrix has size <structfield>rect.width</structfield> *
+	    <structfield>rect.height</structfield> * <structfield>elem_size</structfield>.
+	    The <structfield>elem_size</structfield> can be obtained via &VIDIOC-QUERY-MATRIX;.
+	    The elements are stored row-by-row in the matrix. The first element is element
+	    (<structfield>rect.top</structfield>, <structfield>rect.left</structfield>) of the
+	    full matrix.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[12]</entry>
+            <entry></entry>
+	    <entry>Reserved for future extensions. Drivers and applications must set
+	    the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </refsect1>
+  <refsect1>
+    &return-value;
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml b/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
new file mode 100644
index 0000000..c7423b6
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-query-matrix.xml
@@ -0,0 +1,180 @@
+<refentry id="vidioc-query-matrix">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_QUERY_MATRIX</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_QUERY_MATRIX</refname>
+    <refpurpose>Query the attributes of a matrix</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_query_matrix
+*<parameter>argp</parameter></paramdef>
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
+	  <para>VIDIOC_QUERY_MATRIX</para>
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
+    <para>Query the attributes of a matrix. The application fills in the
+    <structfield>type</structfield> and zeroes the <structfield>reserved</structfield>
+    field of &v4l2-query-matrix;. All other fields will be returned by the driver.
+    </para>
+
+    <table frame="none" pgwide="1" id="v4l2-query-matrix">
+      <title>struct <structname>v4l2_query_matrix</structname></title>
+      <tgroup cols="4">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+            <entry></entry>
+	    <entry>Type of the matrix, see <xref linkend="v4l2-matrix-type" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>columns</structfield></entry>
+            <entry></entry>
+	    <entry>Number of columns in the matrix.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>rows</structfield></entry>
+            <entry></entry>
+	    <entry>Number of rows in the matrix.</entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry><structfield>elem_min</structfield></entry>
+            <entry></entry>
+            <entry></entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+            <entry>__s64</entry>
+	    <entry><structfield>val</structfield></entry>
+            <entry>The minimal signed value of each matrix element.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+            <entry>__u64</entry>
+	    <entry><structfield>uval</structfield></entry>
+            <entry>The minimal unsigned value of each matrix element.</entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry><structfield>elem_max</structfield></entry>
+            <entry></entry>
+            <entry></entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+            <entry>__s64</entry>
+	    <entry><structfield>val</structfield></entry>
+            <entry>The maximal signed value of each matrix element.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+            <entry>__u64</entry>
+	    <entry><structfield>uval</structfield></entry>
+            <entry>The maximal unsigned value of each matrix element.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>elem_size</structfield></entry>
+            <entry></entry>
+	    <entry>The size in bytes of a single matrix element.
+	    The full matrix size will be <structfield>columns</structfield> *
+	    <structfield>rows</structfield> * <structfield>elem_size</structfield>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[16]</entry>
+            <entry></entry>
+	    <entry>Reserved for future extensions. Drivers and applications must set
+	    the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="v4l2-matrix-type">
+      <title>Matrix Types</title>
+      <tgroup cols="2" align="left">
+	<colspec colwidth="30*" />
+	<colspec colwidth="55*" />
+	<thead>
+	  <row>
+	    <entry>Type</entry>
+	    <entry>Description</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_MATRIX_T_MD_REGION</constant></entry>
+	    <entry><para>Hardware motion detection divides the image up into cells. If the image resolution
+	    is WxH and the full matrix size is COLSxROWS, then each cell is a rectangle of (W/COLS)x(H/ROWS)
+	    pixels (approximately as there may be some rounding involved). This matrix type sets the region
+	    property for each cell. The type of the region property is a __u8.</para>
+	    <para>Each region will typically have its own set of motion detection parameters such
+	    as thresholds that determines the motion detection sensitivity. By assigning a region to
+	    each cell you can create areas in the image with lower and areas with higher motion
+	    sensitivity.</para>
+	    <para>So if the hardware supports 4 regions, each with its own set of motion detection
+	    thresholds, then you can assign each cell to one of these regions (0-3) and thus decide
+	    for each cell how sensitive to motion that part of the image will be.</para>
+	    </entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_MATRIX_T_MD_THRESHOLD</constant></entry>
+	    <entry>Hardware motion detection divides the image up into cells. If the image resolution
+	    is WxH and the full matrix size is COLSxROWS, then each cell is a rectangle of (W/COLS)x(H/ROWS)
+	    pixels (approximately as there may be some rounding involved). Depending on the
+	    hardware each cell can have its own motion detection sensitivity threshold. This matrix
+	    type sets the motion detection threshold property for each cell. The type of the
+	    threshold property is a __u16.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+  </refsect1>
+  <refsect1>
+    &return-value;
+  </refsect1>
+</refentry>
-- 
1.8.3.2

