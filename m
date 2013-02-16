Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3049 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab3BPJ3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:29:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 17/18] DocBook/media/v4l: remove the documentation of the obsolete dv_preset API.
Date: Sat, 16 Feb 2013 10:28:20 +0100
Message-Id: <d758f8582d2024efa2170f861887324663fa3da6.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This API is no longer used by any driver and so can be removed from the
documentation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml         |   14 --
 Documentation/DocBook/media/v4l/v4l2.xml           |    3 -
 .../DocBook/media/v4l/vidioc-enum-dv-presets.xml   |  240 --------------------
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    5 -
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    5 -
 .../DocBook/media/v4l/vidioc-g-dv-preset.xml       |  113 ---------
 .../DocBook/media/v4l/vidioc-query-dv-preset.xml   |   78 -------
 7 files changed, 458 deletions(-)
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
 delete mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index ae06afb..1ddf354 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -750,15 +750,6 @@ header can be used to get the timings of the formats in the <xref linkend="cea86
 <xref linkend="vesadmt" /> standards.
 	</para>
 	</listitem>
-	<listitem>
-	<para>DV Presets: Digital Video (DV) presets (<emphasis role="bold">deprecated</emphasis>).
-	These are IDs representing a
-video timing at the input/output. Presets are pre-defined timings implemented
-by the hardware according to video standards. A __u32 data type is used to represent
-a preset unlike the bit mask that is used in &v4l2-std-id; allowing future extensions
-to support as many different presets as needed. This API is deprecated in favor of the DV Timings
-API.</para>
-	</listitem>
 	</itemizedlist>
 	<para>To enumerate and query the attributes of the DV timings supported by a device,
 	applications use the &VIDIOC-ENUM-DV-TIMINGS; and &VIDIOC-DV-TIMINGS-CAP; ioctls.
@@ -766,11 +757,6 @@ API.</para>
 &VIDIOC-S-DV-TIMINGS; ioctl and to get current DV timings they use the
 &VIDIOC-G-DV-TIMINGS; ioctl. To detect the DV timings as seen by the video receiver applications
 use the &VIDIOC-QUERY-DV-TIMINGS; ioctl.</para>
-	<para>To enumerate and query the attributes of DV presets supported by a device,
-applications use the &VIDIOC-ENUM-DV-PRESETS; ioctl. To get the current DV preset,
-applications use the &VIDIOC-G-DV-PRESET; ioctl and to set a preset they use the
-&VIDIOC-S-DV-PRESET; ioctl. To detect the preset as seen by the video receiver applications
-use the &VIDIOC-QUERY-DV-PRESET; ioctl.</para>
 	<para>Applications can make use of the <xref linkend="input-capabilities" /> and
 <xref linkend="output-capabilities"/> flags to decide what ioctls are available to set the
 video timings for the device.</para>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index a3cce18..32a10ee 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -544,7 +544,6 @@ and discussions on the V4L mailing list.</revremark>
     &sub-encoder-cmd;
     &sub-enumaudio;
     &sub-enumaudioout;
-    &sub-enum-dv-presets;
     &sub-enum-dv-timings;
     &sub-enum-fmt;
     &sub-enum-framesizes;
@@ -558,7 +557,6 @@ and discussions on the V4L mailing list.</revremark>
     &sub-g-audioout;
     &sub-g-crop;
     &sub-g-ctrl;
-    &sub-g-dv-preset;
     &sub-g-dv-timings;
     &sub-g-enc-index;
     &sub-g-ext-ctrls;
@@ -582,7 +580,6 @@ and discussions on the V4L mailing list.</revremark>
     &sub-querybuf;
     &sub-querycap;
     &sub-queryctrl;
-    &sub-query-dv-preset;
     &sub-query-dv-timings;
     &sub-querystd;
     &sub-reqbufs;
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
deleted file mode 100644
index fced5fb..0000000
--- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
+++ /dev/null
@@ -1,240 +0,0 @@
-<refentry id="vidioc-enum-dv-presets">
-  <refmeta>
-    <refentrytitle>ioctl VIDIOC_ENUM_DV_PRESETS</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-    <refname>VIDIOC_ENUM_DV_PRESETS</refname>
-    <refpurpose>Enumerate supported Digital Video presets</refpurpose>
-  </refnamediv>
-
-  <refsynopsisdiv>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct v4l2_dv_enum_preset *<parameter>argp</parameter></paramdef>
-      </funcprototype>
-    </funcsynopsis>
-  </refsynopsisdiv>
-
-  <refsect1>
-    <title>Arguments</title>
-
-    <variablelist>
-      <varlistentry>
-	<term><parameter>fd</parameter></term>
-	<listitem>
-	  <para>&fd;</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>request</parameter></term>
-	<listitem>
-	  <para>VIDIOC_ENUM_DV_PRESETS</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>argp</parameter></term>
-	<listitem>
-	  <para></para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-
-  <refsect1>
-    <title>Description</title>
-
-    <para>This ioctl is <emphasis role="bold">deprecated</emphasis>.
-    New drivers and applications should use &VIDIOC-ENUM-DV-TIMINGS; instead.
-    </para>
-
-    <para>To query the attributes of a DV preset, applications initialize the
-<structfield>index</structfield> field and zero the reserved array of &v4l2-dv-enum-preset;
-and call the <constant>VIDIOC_ENUM_DV_PRESETS</constant> ioctl with a pointer to this
-structure. Drivers fill the rest of the structure or return an
-&EINVAL; when the index is out of bounds. To enumerate all DV Presets supported,
-applications shall begin at index zero, incrementing by one until the
-driver returns <errorcode>EINVAL</errorcode>. Drivers may enumerate a
-different set of DV presets after switching the video input or
-output.</para>
-
-    <table pgwide="1" frame="none" id="v4l2-dv-enum-preset">
-      <title>struct <structname>v4l2_dv_enum_presets</structname></title>
-      <tgroup cols="3">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>index</structfield></entry>
-	    <entry>Number of the DV preset, set by the
-application.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>preset</structfield></entry>
-	    <entry>This field identifies one of the DV preset values listed in <xref linkend="v4l2-dv-presets-vals"/>.</entry>
-	  </row>
-	  <row>
-	    <entry>__u8</entry>
-	    <entry><structfield>name</structfield>[24]</entry>
-	    <entry>Name of the preset, a NUL-terminated ASCII string, for example: "720P-60", "1080I-60". This information is
-intended for the user.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>width</structfield></entry>
-	    <entry>Width of the active video in pixels for the DV preset.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>height</structfield></entry>
-	    <entry>Height of the active video in lines for the DV preset.</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[4]</entry>
-	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-
-    <table pgwide="1" frame="none" id="v4l2-dv-presets-vals">
-      <title>struct <structname>DV Presets</structname></title>
-      <tgroup cols="3">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>Preset</entry>
-	    <entry>Preset value</entry>
-	    <entry>Description</entry>
-	  </row>
-	  <row>
-	    <entry></entry>
-	    <entry></entry>
-	    <entry></entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_INVALID</entry>
-	    <entry>0</entry>
-	    <entry>Invalid preset value.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_480P59_94</entry>
-	    <entry>1</entry>
-	    <entry>720x480 progressive video at 59.94 fps as per BT.1362.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_576P50</entry>
-	    <entry>2</entry>
-	    <entry>720x576 progressive video at 50 fps as per BT.1362.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_720P24</entry>
-	    <entry>3</entry>
-	    <entry>1280x720 progressive video at 24 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_720P25</entry>
-	    <entry>4</entry>
-	    <entry>1280x720 progressive video at 25 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_720P30</entry>
-	    <entry>5</entry>
-	    <entry>1280x720 progressive video at 30 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_720P50</entry>
-	    <entry>6</entry>
-	    <entry>1280x720 progressive video at 50 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_720P59_94</entry>
-	    <entry>7</entry>
-	    <entry>1280x720 progressive video at 59.94 fps as per SMPTE 274M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_720P60</entry>
-	    <entry>8</entry>
-	    <entry>1280x720 progressive video at 60 fps as per SMPTE 274M/296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080I29_97</entry>
-	    <entry>9</entry>
-	    <entry>1920x1080 interlaced video at 29.97 fps as per BT.1120/SMPTE 274M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080I30</entry>
-	    <entry>10</entry>
-	    <entry>1920x1080 interlaced video at 30 fps as per BT.1120/SMPTE 274M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080I25</entry>
-	    <entry>11</entry>
-	    <entry>1920x1080 interlaced video at 25 fps as per BT.1120.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080I50</entry>
-	    <entry>12</entry>
-	    <entry>1920x1080 interlaced video at 50 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080I60</entry>
-	    <entry>13</entry>
-	    <entry>1920x1080 interlaced video at 60 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080P24</entry>
-	    <entry>14</entry>
-	    <entry>1920x1080 progressive video at 24 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080P25</entry>
-	    <entry>15</entry>
-	    <entry>1920x1080 progressive video at 25 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080P30</entry>
-	    <entry>16</entry>
-	    <entry>1920x1080 progressive video at 30 fps as per SMPTE 296M.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080P50</entry>
-	    <entry>17</entry>
-	    <entry>1920x1080 progressive video at 50 fps as per BT.1120.</entry>
-	  </row>
-	  <row>
-	    <entry>V4L2_DV_1080P60</entry>
-	    <entry>18</entry>
-	    <entry>1920x1080 progressive video at 60 fps as per BT.1120.</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-  </refsect1>
-
-  <refsect1>
-    &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>The &v4l2-dv-enum-preset; <structfield>index</structfield>
-is out of bounds.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>ENODATA</errorcode></term>
-	<listitem>
-	  <para>Digital video presets are not supported for this input or output.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-</refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
index 3c9a813..493a39a 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
@@ -278,11 +278,6 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
 	&cs-def;
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>V4L2_IN_CAP_PRESETS</constant></entry>
-	    <entry>0x00000001</entry>
-	    <entry>This input supports setting DV presets by using VIDIOC_S_DV_PRESET.</entry>
-	  </row>
-	  <row>
 	    <entry><constant>V4L2_IN_CAP_DV_TIMINGS</constant></entry>
 	    <entry>0x00000002</entry>
 	    <entry>This input supports setting video timings by using VIDIOC_S_DV_TIMINGS.</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
index f4ab079..2654e09 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
@@ -163,11 +163,6 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
 	&cs-def;
 	<tbody valign="top">
 	  <row>
-	    <entry><constant>V4L2_OUT_CAP_PRESETS</constant></entry>
-	    <entry>0x00000001</entry>
-	    <entry>This output supports setting DV presets by using VIDIOC_S_DV_PRESET.</entry>
-	  </row>
-	  <row>
 	    <entry><constant>V4L2_OUT_CAP_DV_TIMINGS</constant></entry>
 	    <entry>0x00000002</entry>
 	    <entry>This output supports setting video timings by using VIDIOC_S_DV_TIMINGS.</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
deleted file mode 100644
index b9ea376..0000000
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-preset.xml
+++ /dev/null
@@ -1,113 +0,0 @@
-<refentry id="vidioc-g-dv-preset">
-  <refmeta>
-    <refentrytitle>ioctl VIDIOC_G_DV_PRESET, VIDIOC_S_DV_PRESET</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-    <refname>VIDIOC_G_DV_PRESET</refname>
-    <refname>VIDIOC_S_DV_PRESET</refname>
-    <refpurpose>Query or select the DV preset of the current input or output</refpurpose>
-  </refnamediv>
-
-  <refsynopsisdiv>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct v4l2_dv_preset *<parameter>argp</parameter></paramdef>
-      </funcprototype>
-    </funcsynopsis>
-  </refsynopsisdiv>
-
-  <refsect1>
-    <title>Arguments</title>
-
-    <variablelist>
-      <varlistentry>
-	<term><parameter>fd</parameter></term>
-	<listitem>
-	  <para>&fd;</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>request</parameter></term>
-	<listitem>
-	  <para>VIDIOC_G_DV_PRESET, VIDIOC_S_DV_PRESET</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>argp</parameter></term>
-	<listitem>
-	  <para></para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-
-  <refsect1>
-    <title>Description</title>
-
-    <para>These ioctls are <emphasis role="bold">deprecated</emphasis>.
-    New drivers and applications should use &VIDIOC-G-DV-TIMINGS; and &VIDIOC-S-DV-TIMINGS;
-    instead.
-    </para>
-
-    <para>To query and select the current DV preset, applications
-use the <constant>VIDIOC_G_DV_PRESET</constant> and <constant>VIDIOC_S_DV_PRESET</constant>
-ioctls which take a pointer to a &v4l2-dv-preset; type as argument.
-Applications must zero the reserved array in &v4l2-dv-preset;.
-<constant>VIDIOC_G_DV_PRESET</constant> returns a dv preset in the field
-<structfield>preset</structfield> of &v4l2-dv-preset;.</para>
-
-    <para><constant>VIDIOC_S_DV_PRESET</constant> accepts a pointer to a &v4l2-dv-preset;
-that has the preset value to be set. Applications must zero the reserved array in &v4l2-dv-preset;.
-If the preset is not supported, it returns an &EINVAL; </para>
-  </refsect1>
-
-  <refsect1>
-    &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>EINVAL</errorcode></term>
-	<listitem>
-	  <para>This ioctl is not supported, or the
-<constant>VIDIOC_S_DV_PRESET</constant>,<constant>VIDIOC_S_DV_PRESET</constant> parameter was unsuitable.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>ENODATA</errorcode></term>
-	<listitem>
-	  <para>Digital video presets are not supported for this input or output.</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><errorcode>EBUSY</errorcode></term>
-	<listitem>
-	  <para>The device is busy and therefore can not change the preset.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-
-    <table pgwide="1" frame="none" id="v4l2-dv-preset">
-      <title>struct <structname>v4l2_dv_preset</structname></title>
-      <tgroup cols="3">
-	&cs-str;
-	<tbody valign="top">
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>preset</structfield></entry>
-	    <entry>Preset value to represent the digital video timings</entry>
-	  </row>
-	  <row>
-	    <entry>__u32</entry>
-	    <entry><structfield>reserved[4]</structfield></entry>
-	    <entry>Reserved fields for future use</entry>
-	  </row>
-	</tbody>
-      </tgroup>
-    </table>
-  </refsect1>
-</refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
deleted file mode 100644
index 68b49d0..0000000
--- a/Documentation/DocBook/media/v4l/vidioc-query-dv-preset.xml
+++ /dev/null
@@ -1,78 +0,0 @@
-<refentry id="vidioc-query-dv-preset">
-  <refmeta>
-    <refentrytitle>ioctl VIDIOC_QUERY_DV_PRESET</refentrytitle>
-    &manvol;
-  </refmeta>
-
-  <refnamediv>
-    <refname>VIDIOC_QUERY_DV_PRESET</refname>
-    <refpurpose>Sense the DV preset received by the current
-input</refpurpose>
-  </refnamediv>
-
-  <refsynopsisdiv>
-    <funcsynopsis>
-      <funcprototype>
-	<funcdef>int <function>ioctl</function></funcdef>
-	<paramdef>int <parameter>fd</parameter></paramdef>
-	<paramdef>int <parameter>request</parameter></paramdef>
-	<paramdef>struct v4l2_dv_preset *<parameter>argp</parameter></paramdef>
-      </funcprototype>
-    </funcsynopsis>
-  </refsynopsisdiv>
-
-  <refsect1>
-    <title>Arguments</title>
-
-    <variablelist>
-	<varlistentry>
-	<term><parameter>fd</parameter></term>
-	<listitem>
-	  <para>&fd;</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>request</parameter></term>
-	<listitem>
-	  <para>VIDIOC_QUERY_DV_PRESET</para>
-	</listitem>
-      </varlistentry>
-      <varlistentry>
-	<term><parameter>argp</parameter></term>
-	<listitem>
-	  <para></para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-
-  <refsect1>
-    <title>Description</title>
-
-    <para>This ioctl is <emphasis role="bold">deprecated</emphasis>.
-    New drivers and applications should use &VIDIOC-QUERY-DV-TIMINGS; instead.
-    </para>
-
-    <para>The hardware may be able to detect the current DV preset
-automatically, similar to sensing the video standard. To do so, applications
-call <constant> VIDIOC_QUERY_DV_PRESET</constant> with a pointer to a
-&v4l2-dv-preset; type. Once the hardware detects a preset, that preset is
-returned in the preset field of &v4l2-dv-preset;. If the preset could not be
-detected because there was no signal, or the signal was unreliable, or the
-signal did not map to a supported preset, then the value V4L2_DV_INVALID is
-returned.</para>
-  </refsect1>
-
-  <refsect1>
-    &return-value;
-
-    <variablelist>
-      <varlistentry>
-	<term><errorcode>ENODATA</errorcode></term>
-	<listitem>
-	  <para>Digital video presets are not supported for this input or output.</para>
-	</listitem>
-      </varlistentry>
-    </variablelist>
-  </refsect1>
-</refentry>
-- 
1.7.10.4

