Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3789 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaA0OfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jan 2014 09:35:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 18/22] DocBook media: document VIDIOC_QUERY_EXT_CTRL.
Date: Mon, 27 Jan 2014 15:34:20 +0100
Message-Id: <1390833264-8503-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1390833264-8503-1-git-send-email-hverkuil@xs4all.nl>
References: <1390833264-8503-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 .../DocBook/media/v4l/vidioc-queryctrl.xml         | 223 +++++++++++++++++----
 1 file changed, 189 insertions(+), 34 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
index e6645b9..da0e534 100644
--- a/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-queryctrl.xml
@@ -1,11 +1,12 @@
 <refentry id="vidioc-queryctrl">
   <refmeta>
-    <refentrytitle>ioctl VIDIOC_QUERYCTRL, VIDIOC_QUERYMENU</refentrytitle>
+    <refentrytitle>ioctl VIDIOC_QUERYCTRL, VIDIOC_QUERY_EXT_CTRL, VIDIOC_QUERYMENU</refentrytitle>
     &manvol;
   </refmeta>
 
   <refnamediv>
     <refname>VIDIOC_QUERYCTRL</refname>
+    <refname>VIDIOC_QUERY_EXT_CTRL</refname>
     <refname>VIDIOC_QUERYMENU</refname>
     <refpurpose>Enumerate controls and menu control items</refpurpose>
   </refnamediv>
@@ -24,6 +25,14 @@
 	<funcdef>int <function>ioctl</function></funcdef>
 	<paramdef>int <parameter>fd</parameter></paramdef>
 	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_query_ext_ctrl *<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
 	<paramdef>struct v4l2_querymenu *<parameter>argp</parameter></paramdef>
       </funcprototype>
     </funcsynopsis>
@@ -42,7 +51,7 @@
       <varlistentry>
 	<term><parameter>request</parameter></term>
 	<listitem>
-	  <para>VIDIOC_QUERYCTRL, VIDIOC_QUERYMENU</para>
+	  <para>VIDIOC_QUERYCTRL, VIDIOC_QUERY_EXT_CTRL, VIDIOC_QUERYMENU</para>
 	</listitem>
       </varlistentry>
       <varlistentry>
@@ -91,7 +100,26 @@ prematurely end the enumeration).</para></footnote></para>
 <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant> the driver returns the
 next supported control, or <errorcode>EINVAL</errorcode> if there is
 none. Drivers which do not support this flag yet always return
-<errorcode>EINVAL</errorcode>.</para>
+<errorcode>EINVAL</errorcode>. Hidden controls (i.e. controls
+with the <constant>V4L2_CTRL_FLAG_HIDDEN</constant> flag set) are
+skipped when using the <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant>
+flag. Use the <constant>VIDIOC_QUERY_EXT_CTRL</constant> for that.</para>
+
+    <para>The <constant>VIDIOC_QUERY_EXT_CTRL</constant> ioctl was
+introduced in order to better support controls that can use complex
+types, and to expose additional control information that cannot be
+returned in &v4l2-queryctrl; since that structure is full.</para>
+
+    <para><constant>VIDIOC_QUERY_EXT_CTRL</constant> is used in the
+same way as <constant>VIDIOC_QUERYCTRL</constant>, except that the
+<structfield>reserved</structfield> array must be zeroed as well.
+In addition, the <constant>V4L2_CTRL_FLAG_NEXT_HIDDEN</constant> flag
+can be specified to enumerate all hidden controls (i.e. controls
+with the <constant>V4L2_CTRL_FLAG_HIDDEN</constant> flag set, which
+includes all controls with complex types). Specify both
+<constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant> and
+<constant>V4L2_CTRL_FLAG_NEXT_HIDDEN</constant> in order to enumerate
+all controls, hidden or not.</para>
 
     <para>Additional information is required for menu controls: the
 names of the menu items. To query them applications set the
@@ -142,38 +170,23 @@ string. This information is intended for the user.</entry>
 	    <entry>__s32</entry>
 	    <entry><structfield>minimum</structfield></entry>
 	    <entry>Minimum value, inclusive. This field gives a lower
-bound for <constant>V4L2_CTRL_TYPE_INTEGER</constant> controls and the
-lowest valid index for <constant>V4L2_CTRL_TYPE_MENU</constant> controls.
-For <constant>V4L2_CTRL_TYPE_STRING</constant> controls the minimum value
-gives the minimum length of the string. This length <emphasis>does not include the terminating
-zero</emphasis>. It may not be valid for any other type of control, including
-<constant>V4L2_CTRL_TYPE_INTEGER64</constant> controls. Note that this is a
-signed value.</entry>
+bound for the control. See &v4l2-ctrl-type; how the minimum value is to
+be used for each possible control type. Note that this a signed 32-bit value.</entry>
 	  </row>
 	  <row>
 	    <entry>__s32</entry>
 	    <entry><structfield>maximum</structfield></entry>
 	    <entry>Maximum value, inclusive. This field gives an upper
-bound for <constant>V4L2_CTRL_TYPE_INTEGER</constant> controls and the
-highest valid index for <constant>V4L2_CTRL_TYPE_MENU</constant>
-controls. For <constant>V4L2_CTRL_TYPE_BITMASK</constant> controls it is the
-set of usable bits.
-For <constant>V4L2_CTRL_TYPE_STRING</constant> controls the maximum value
-gives the maximum length of the string. This length <emphasis>does not include the terminating
-zero</emphasis>. It may not be valid for any other type of control, including
-<constant>V4L2_CTRL_TYPE_INTEGER64</constant> controls. Note that this is a
-signed value.</entry>
+bound for the control. See &v4l2-ctrl-type; how the maximum value is to
+be used for each possible control type. Note that this a signed 32-bit value.</entry>
 	  </row>
 	  <row>
 	    <entry>__s32</entry>
 	    <entry><structfield>step</structfield></entry>
-	    <entry><para>This field gives a step size for
-<constant>V4L2_CTRL_TYPE_INTEGER</constant> controls. For
-<constant>V4L2_CTRL_TYPE_STRING</constant> controls this field refers to
-the string length that has to be a multiple of this step size.
-It may not be valid for any other type of control, including
-<constant>V4L2_CTRL_TYPE_INTEGER64</constant>
-controls.</para><para>Generally drivers should not scale hardware
+	    <entry><para>This field gives a step size for the control.
+See &v4l2-ctrl-type; how the step value is to be used for each possible
+control type. Note that this an unsigned 32-bit value.
+</para><para>Generally drivers should not scale hardware
 control values. It may be necessary for example when the
 <structfield>name</structfield> or <structfield>id</structfield> imply
 a particular unit and the hardware actually accepts only multiples of
@@ -192,10 +205,11 @@ be always positive.</para></entry>
 	    <entry><structfield>default_value</structfield></entry>
 	    <entry>The default value of a
 <constant>V4L2_CTRL_TYPE_INTEGER</constant>,
-<constant>_BOOLEAN</constant> or <constant>_MENU</constant> control.
-Not valid for other types of controls. Drivers reset controls only
-when the driver is loaded, not later, in particular not when the
-func-open; is called.</entry>
+<constant>_BOOLEAN</constant>, <constant>_BITMASK</constant>,
+<constant>_MENU</constant> or <constant>_INTEGER_MENU</constant> control.
+Not valid for other types of controls.
+Note that drivers reset controls to their default value only when the
+driver is first loaded, never afterwards.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -213,6 +227,129 @@ the array to zero.</entry>
       </tgroup>
     </table>
 
+    <table pgwide="1" frame="none" id="v4l2-query-ext-ctrl">
+      <title>struct <structname>v4l2_query_ext_ctrl</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>id</structfield></entry>
+	    <entry>Identifies the control, set by the application. See
+<xref linkend="control-id" /> for predefined IDs. When the ID is ORed
+with <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant> the driver clears the
+flag and returns the first non-hidden control with a higher ID. When the
+ID is ORed with <constant>V4L2_CTRL_FLAG_NEXT_HIDDEN</constant> the driver
+clears the flag and returns the first hidden control with a higher ID.
+Set both to get the first control (hidden or not) with a higher ID.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry>Type of control, see <xref
+		linkend="v4l2-ctrl-type" />.</entry>
+	  </row>
+	  <row>
+	    <entry>char</entry>
+	    <entry><structfield>name</structfield>[32]</entry>
+	    <entry>Name of the control, a NUL-terminated ASCII
+string. This information is intended for the user.</entry>
+	  </row>
+	  <row>
+	    <entry>char</entry>
+	    <entry><structfield>unit</structfield>[32]</entry>
+	    <entry>The name of the unit of the control's value, a NUL-terminated ASCII
+string. This information is intended for the user. This may be an empty string if no
+unit is known or if it is not applicable to this particular control.</entry>
+	  </row>
+	  <row>
+	    <entry>__s64</entry>
+	    <entry><structfield>minimum</structfield></entry>
+	    <entry>Minimum value, inclusive. This field gives a lower
+bound for the control. See &v4l2-ctrl-type; how the minimum value is to
+be used for each possible control type. Note that this a signed 64-bit value.</entry>
+	  </row>
+	  <row>
+	    <entry>__s64</entry>
+	    <entry><structfield>maximum</structfield></entry>
+	    <entry>Maximum value, inclusive. This field gives an upper
+bound for the control. See &v4l2-ctrl-type; how the maximum value is to
+be used for each possible control type. Note that this a signed 64-bit value.</entry>
+	  </row>
+	  <row>
+	    <entry>__u64</entry>
+	    <entry><structfield>step</structfield></entry>
+	    <entry><para>This field gives a step size for the control.
+See &v4l2-ctrl-type; how the step value is to be used for each possible
+control type. Note that this an unsigned 64-bit value.
+</para><para>Generally drivers should not scale hardware
+control values. It may be necessary for example when the
+<structfield>name</structfield> or <structfield>id</structfield> imply
+a particular unit and the hardware actually accepts only multiples of
+said unit. If so, drivers must take care values are properly rounded
+when scaling, such that errors will not accumulate on repeated
+read-write cycles.</para><para>This field gives the smallest change of
+an integer control actually affecting hardware. Often the information
+is needed when the user can change controls by keyboard or GUI
+buttons, rather than a slider. When for example a hardware register
+accepts values 0-511 and the driver reports 0-65535, step should be
+128.</para></entry>
+	  </row>
+	  <row>
+	    <entry>__s64</entry>
+	    <entry><structfield>default_value</structfield></entry>
+	    <entry>The default value of a
+<constant>V4L2_CTRL_TYPE_INTEGER</constant>, <constant>_INTEGER64</constant>,
+<constant>_BOOLEAN</constant>, <constant>_BITMASK</constant>,
+<constant>_MENU</constant> or <constant>_INTEGER_MENU</constant> control.
+Not valid for other types of controls.
+Note that drivers reset controls to their default value only when the
+driver is first loaded, never afterwards.
+</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Control flags, see <xref
+		linkend="control-flags" />.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>cols</structfield></entry>
+	    <entry>The number of columns in the matrix. If this control
+is not a matrix, then both <structfield>cols</structfield> and
+<structfield>rows</structfield> are 1. <structfield>cols</structfield>
+can never be 0.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>rows</structfield></entry>
+	    <entry>The number of rows in the matrix. If this control
+is not a matrix, then both <structfield>cols</structfield> and
+<structfield>rows</structfield> are 1. <structfield>rows</structfield>
+can never be 0.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>elem_size</structfield></entry>
+	    <entry>The size in bytes of a single element of the matrix.
+Given a char pointer <constant>p</constant> to the matrix you can find the
+position of cell <constant>(y, x)</constant> as follows:
+<constant>p + (y * cols + x) * elem_size</constant>. <structfield>elem_size</structfield>
+is always valid, also when the control isn't a matrix. For string controls
+<structfield>elem_size</structfield> is equal to <structfield>maximum + 1</structfield>.
+</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[17]</entry>
+	    <entry>Reserved for future extensions. Applications and drivers
+must set the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
     <table pgwide="1" frame="none" id="v4l2-querymenu">
       <title>struct <structname>v4l2_querymenu</structname></title>
       <tgroup cols="4">
@@ -347,11 +484,14 @@ Drivers must ignore the value passed with
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CTRL_TYPE_INTEGER64</constant></entry>
-	    <entry>n/a</entry>
-	    <entry>n/a</entry>
-	    <entry>n/a</entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
+	    <entry>any</entry>
 	    <entry>A 64-bit integer valued control. Minimum, maximum
-and step size cannot be queried.</entry>
+and step size cannot be queried using <constant>VIDIOC_QUERYCTRL</constant>.
+Only <constant>VIDIOC_QUERY_EXT_CTRL</constant> can retrieve the 64-bit
+min/max/step values, they should be interpreted as n/a when using
+<constant>VIDIOC_QUERYCTRL</constant>.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_CTRL_TYPE_STRING</constant></entry>
@@ -450,6 +590,21 @@ is in auto-gain mode. In such a case the hardware calculates the gain value base
 the lighting conditions which can change over time. Note that setting a new value for
 a volatile control will have no effect. The new value will just be ignored.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_FLAG_HIDDEN</constant></entry>
+	    <entry>0x0100</entry>
+	    <entry>This control is hidden and should not be shown in a GUI application.
+Hidden controls are skipped when enumerating them using <constant>V4L2_CTRL_FLAG_NEXT_CTRL</constant>,
+and they can only be enumerated by using the <constant>V4L2_CTRL_FLAG_NEXT_HIDDEN</constant>
+flag. All controls that have a complex type have this flag set.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_FLAG_IS_PTR</constant></entry>
+	    <entry>0x0200</entry>
+	    <entry>This control has a pointer type, so its value has to be accessed
+using one of the pointer fields of &v4l2-ext-control;. This flag is set for controls
+that are a matrix, string, or have a complex type.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
1.8.5.2

