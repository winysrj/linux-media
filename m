Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1346 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2EAJGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 05:06:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] V4L2 spec: document the new V4L2 DV timings ioctls.
Date: Tue,  1 May 2012 11:05:49 +0200
Message-Id: <d99d8e6e8bdc9032039282d6191980fc56d97061.1335862609.git.hans.verkuil@cisco.com>
In-Reply-To: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
References: <1335863152-15791-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
References: <de77f3452a3710c48282ebe24937731b252a1ef7.1335862609.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/DocBook/media/v4l/biblio.xml         |   18 ++
 Documentation/DocBook/media/v4l/common.xml         |   32 +--
 Documentation/DocBook/media/v4l/compat.xml         |   13 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |   15 +-
 .../DocBook/media/v4l/vidioc-create-bufs.xml       |    6 +
 .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |  211 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-enum-dv-presets.xml   |    4 +
 .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |  119 +++++++++++
 .../DocBook/media/v4l/vidioc-enuminput.xml         |    2 +-
 .../DocBook/media/v4l/vidioc-enumoutput.xml        |    2 +-
 .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |  130 +++++++++++-
 .../DocBook/media/v4l/vidioc-prepare-buf.xml       |    6 +
 .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |  104 ++++++++++
 13 files changed, 633 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index 7dc65c5..722e766 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -197,4 +197,22 @@ in the frequency range from 87,5 to 108,0 MHz</title>
       <title>NTSC-4: United States RBDS Standard</title>
     </biblioentry>
 
+    <biblioentry id="cea861">
+      <abbrev>CEA-861-E</abbrev>
+      <authorgroup>
+	<corpauthor>Consumer Electronics Association
+(<ulink url="http://www.ce.org">http://www.ce.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>A DTV Profile for Uncompressed High Speed Digital Interfaces</title>
+    </biblioentry>
+
+    <biblioentry id="vesadmt">
+      <abbrev>VESA&nbsp;DMT</abbrev>
+      <authorgroup>
+	<corpauthor>Video Electronics Standards Association
+(<ulink url="http://www.vesa.org">http://www.vesa.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>VESA and Industry Standards and Guidelines for Computer Display Monitor Timing (DMT)</title>
+    </biblioentry>
+
   </bibliography>
diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index c79278a..81b7cf3 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -724,41 +724,47 @@ if (-1 == ioctl (fd, &VIDIOC-S-STD;, &amp;std_id)) {
 }
       </programlisting>
     </example>
+  </section>
   <section id="dv-timings">
 	<title>Digital Video (DV) Timings</title>
 	<para>
-	The video standards discussed so far has been dealing with Analog TV and the
+	The video standards discussed so far have been dealing with Analog TV and the
 corresponding video timings. Today there are many more different hardware interfaces
 such as High Definition TV interfaces (HDMI), VGA, DVI connectors etc., that carry
 video signals and there is a need to extend the API to select the video timings
 for these interfaces. Since it is not possible to extend the &v4l2-std-id; due to
-the limited bits available, a new set of IOCTLs is added to set/get video timings at
+the limited bits available, a new set of IOCTLs was added to set/get video timings at
 the input and output: </para><itemizedlist>
 	<listitem>
+	<para>DV Timings: This will allow applications to define detailed
+video timings for the interface. This includes parameters such as width, height,
+polarities, frontporch, backporch etc. The <filename>linux/v4l2-dv-timings.h</filename>
+header can be used to get the timings of the formats in the <xref linkend="cea861" /> and
+<xref linkend="vesadmt" /> standards.
+	</para>
+	</listitem>
+	<listitem>
 	<para>DV Presets: Digital Video (DV) presets. These are IDs representing a
 video timing at the input/output. Presets are pre-defined timings implemented
 by the hardware according to video standards. A __u32 data type is used to represent
 a preset unlike the bit mask that is used in &v4l2-std-id; allowing future extensions
 to support as many different presets as needed.</para>
 	</listitem>
-	<listitem>
-	<para>Custom DV Timings: This will allow applications to define more detailed
-custom video timings for the interface. This includes parameters such as width, height,
-polarities, frontporch, backporch etc.
-	</para>
-	</listitem>
 	</itemizedlist>
+	<para>To enumerate and query the attributes of the DV timings supported by a device,
+	applications use the &VIDIOC-ENUM-DV-TIMINGS; and &VIDIOC-DV-TIMINGS-CAP; ioctls.
+	To set DV timings for the device, applications use the
+&VIDIOC-S-DV-TIMINGS; ioctl and to get current DV timings they use the
+&VIDIOC-G-DV-TIMINGS; ioctl. To detect the DV timings as seen by the video receiver applications
+use the &VIDIOC-QUERY-DV-TIMINGS; ioctl.</para>
 	<para>To enumerate and query the attributes of DV presets supported by a device,
 applications use the &VIDIOC-ENUM-DV-PRESETS; ioctl. To get the current DV preset,
 applications use the &VIDIOC-G-DV-PRESET; ioctl and to set a preset they use the
-&VIDIOC-S-DV-PRESET; ioctl.</para>
-	<para>To set custom DV timings for the device, applications use the
-&VIDIOC-S-DV-TIMINGS; ioctl and to get current custom DV timings they use the
-&VIDIOC-G-DV-TIMINGS; ioctl.</para>
+&VIDIOC-S-DV-PRESET; ioctl. To detect the preset as seen by the video receiver applications
+use the &VIDIOC-QUERY-DV-PRESET; ioctl.</para>
 	<para>Applications can make use of the <xref linkend="input-capabilities" /> and
 <xref linkend="output-capabilities"/> flags to decide what ioctls are available to set the
 video timings for the device.</para>
-	</section>
   </section>
 
   &sub-controls;
diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 87339b2..21424a6 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2422,6 +2422,11 @@ details.</para>
 	  &VIDIOC-SUBDEV-G-SELECTION; and
 	  &VIDIOC-SUBDEV-S-SELECTION;.</para>
         </listitem>
+        <listitem>
+	  <para>Extended the DV Timings API:
+	  &VIDIOC-ENUM-DV-TIMINGS;, &VIDIOC-QUERY-DV-TIMINGS; and
+	  &VIDIOC-DV-TIMINGS-CAP;.</para>
+        </listitem>
       </orderedlist>
     </section>
 
@@ -2523,6 +2528,10 @@ and may change in the future.</para>
 ioctls.</para>
         </listitem>
         <listitem>
+	  <para>&VIDIOC-DECODER-CMD; and &VIDIOC-TRY-DECODER-CMD;
+ioctls.</para>
+        </listitem>
+        <listitem>
 	  <para>&VIDIOC-DBG-G-REGISTER; and &VIDIOC-DBG-S-REGISTER;
 ioctls.</para>
         </listitem>
@@ -2530,6 +2539,10 @@ ioctls.</para>
 	  <para>&VIDIOC-DBG-G-CHIP-IDENT; ioctl.</para>
         </listitem>
         <listitem>
+	  <para>&VIDIOC-ENUM-DV-TIMINGS;, &VIDIOC-QUERY-DV-TIMINGS; and
+	  &VIDIOC-DV-TIMINGS-CAP; ioctls.</para>
+        </listitem>
+        <listitem>
 	  <para>Flash API. <xref linkend="flash-controls" /></para>
         </listitem>
         <listitem>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index fbf808d..0975a54 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -28,8 +28,8 @@ documentation.</contrib>
 	<firstname>Hans</firstname>
 	<surname>Verkuil</surname>
 	<contrib>Designed and documented the VIDIOC_LOG_STATUS ioctl,
-the extended control ioctls and major parts of the sliced VBI
-API.</contrib>
+the extended control ioctls, major parts of the sliced VBI API, the
+MPEG encoder and decoder APIs and the DV Timings API.</contrib>
 	<affiliation>
 	  <address>
 	    <email>hverkuil@xs4all.nl</email>
@@ -123,6 +123,7 @@ Remote Controller chapter.</contrib>
       <year>2009</year>
       <year>2010</year>
       <year>2011</year>
+      <year>2012</year>
       <holder>Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin
 Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab,
 	Pawel Osciak</holder>
@@ -145,6 +146,11 @@ applications. -->
 	<revremark>Added V4L2_CTRL_TYPE_INTEGER_MENU and V4L2 subdev
 	    selections API.
 	</revremark>
+	<date>2012-05-01</date>
+	<authorinitials>hv</authorinitials>
+	<revremark>Added VIDIOC_ENUM_DV_TIMINGS, VIDIOC_QUERY_DV_TIMINGS and
+	VIDIOC_DV_TIMINGS_CAP.
+	</revremark>
       </revision>
 
       <revision>
@@ -453,7 +459,7 @@ and discussions on the V4L mailing list.</revremark>
 </partinfo>
 
 <title>Video for Linux Two API Specification</title>
- <subtitle>Revision 3.3</subtitle>
+ <subtitle>Revision 3.5</subtitle>
 
   <chapter id="common">
     &sub-common;
@@ -511,10 +517,12 @@ and discussions on the V4L mailing list.</revremark>
     &sub-dbg-g-register;
     &sub-decoder-cmd;
     &sub-dqevent;
+    &sub-dv-timings-cap;
     &sub-encoder-cmd;
     &sub-enumaudio;
     &sub-enumaudioout;
     &sub-enum-dv-presets;
+    &sub-enum-dv-timings;
     &sub-enum-fmt;
     &sub-enum-framesizes;
     &sub-enum-frameintervals;
@@ -549,6 +557,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-querycap;
     &sub-queryctrl;
     &sub-query-dv-preset;
+    &sub-query-dv-timings;
     &sub-querystd;
     &sub-prepare-buf;
     &sub-reqbufs;
diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
index 73ae8a6..5656e25 100644
--- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
@@ -48,6 +48,12 @@
   <refsect1>
     <title>Description</title>
 
+    <note>
+      <title>Experimental</title>
+      <para>This is an <link linkend="experimental"> experimental </link>
+      interface and may change in the future.</para>
+    </note>
+
     <para>This ioctl is used to create buffers for <link linkend="mmap">memory
 mapped</link> or <link linkend="userp">user pointer</link>
 I/O. It can be used as an alternative or in addition to the
diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
new file mode 100644
index 0000000..6673ce5
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
@@ -0,0 +1,211 @@
+<refentry id="vidioc-dv-timings-cap">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_DV_TIMINGS_CAP</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_DV_TIMINGS_CAP</refname>
+    <refpurpose>The capabilities of the Digital Video receiver/transmitter</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_dv_timings_cap *<parameter>argp</parameter></paramdef>
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
+	  <para>VIDIOC_DV_TIMINGS_CAP</para>
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
+      <para>This is an <link linkend="experimental"> experimental </link>
+      interface and may change in the future.</para>
+    </note>
+
+    <para>To query the available timings, applications initialize the
+<structfield>index</structfield> field and zero the reserved array of &v4l2-dv-timings-cap;
+and call the <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl with a pointer to this
+structure. Drivers fill the rest of the structure or return an
+&EINVAL; when the index is out of bounds. To enumerate all supported DV timings,
+applications shall begin at index zero, incrementing by one until the
+driver returns <errorcode>EINVAL</errorcode>. Note that drivers may enumerate a
+different set of DV timings after switching the video input or
+output.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-bt-timings-cap">
+      <title>struct <structname>v4l2_bt_timings_cap</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>min_width</structfield></entry>
+	    <entry>Minimum width of the active video in pixels.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>max_width</structfield></entry>
+	    <entry>Maximum width of the active video in pixels.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>min_height</structfield></entry>
+	    <entry>Minimum height of the active video in lines.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>max_height</structfield></entry>
+	    <entry>Maximum height of the active video in lines.</entry>
+	  </row>
+	  <row>
+	    <entry>__u64</entry>
+	    <entry><structfield>min_pixelclock</structfield></entry>
+	    <entry>Minimum pixelclock frequency in Hz.</entry>
+	  </row>
+	  <row>
+	    <entry>__u64</entry>
+	    <entry><structfield>max_pixelclock</structfield></entry>
+	    <entry>Maximum pixelclock frequency in Hz.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>standards</structfield></entry>
+	    <entry>The video standard(s) supported by the hardware.
+	    See <xref linkend="dv-bt-standards"/> for a list of standards.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>capabilities</structfield></entry>
+	    <entry>Several flags giving more information about the capabilities.
+	    See <xref linkend="dv-bt-cap-capabilities"/> for a description of the flags.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[16]</entry>
+	    <entry></entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="v4l2-dv-timings-cap">
+      <title>struct <structname>v4l2_dv_timings_cap</structname></title>
+      <tgroup cols="4">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry>Type of DV timings as listed in <xref linkend="dv-timing-types"/>.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[3]</entry>
+	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
+	  </row>
+	  <row>
+	    <entry>union</entry>
+	    <entry><structfield></structfield></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>&v4l2-bt-timings-cap;</entry>
+	    <entry><structfield>bt</structfield></entry>
+	    <entry>BT.656/1120 timings capabilities of the hardware.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry>__u32</entry>
+	    <entry><structfield>raw_data</structfield>[32]</entry>
+	    <entry></entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="dv-bt-cap-capabilities">
+      <title>DV BT Timing capabilities</title>
+      <tgroup cols="2">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>Flag</entry>
+	    <entry>Description</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_CAP_INTERLACED</entry>
+	    <entry>Interlaced formats are supported.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_CAP_PROGRESSIVE</entry>
+	    <entry>Progressive formats are supported.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_CAP_REDUCED_BLANKING</entry>
+	    <entry>CVT/GTF specific: the timings can make use of reduced blanking (CVT)
+or the 'Secondary GTF' curve (GTF).
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_CAP_CUSTOM</entry>
+	    <entry>Can support non-standard timings, i.e. timings not belonging to the
+standards set in the <structfield>standards</structfield> field.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+  </refsect1>
+</refentry>
+
+<!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "v4l2.sgml"
+indent-tabs-mode: nil
+End:
+-->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
index 0be17c2..509f001 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-presets.xml
@@ -48,6 +48,10 @@
   <refsect1>
     <title>Description</title>
 
+    <para>This ioctl is <emphasis role="bold">deprecated</emphasis>.
+    New drivers and applications should use &VIDIOC-ENUM-DV-TIMINGS; instead.
+    </para>
+
     <para>To query the attributes of a DV preset, applications initialize the
 <structfield>index</structfield> field and zero the reserved array of &v4l2-dv-enum-preset;
 and call the <constant>VIDIOC_ENUM_DV_PRESETS</constant> ioctl with a pointer to this
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
new file mode 100644
index 0000000..24c3bf4
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
@@ -0,0 +1,119 @@
+<refentry id="vidioc-enum-dv-timings">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_ENUM_DV_TIMINGS</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_ENUM_DV_TIMINGS</refname>
+    <refpurpose>Enumerate supported Digital Video timings</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_enum_dv_timings *<parameter>argp</parameter></paramdef>
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
+	  <para>VIDIOC_ENUM_DV_TIMINGS</para>
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
+      <para>This is an <link linkend="experimental"> experimental </link>
+      interface and may change in the future.</para>
+    </note>
+
+    <para>While some DV receivers or transmitters support a wide range of timings, others
+support only a limited number of timings. With this ioctl applications can enumerate a list
+of known supported timings. Call &VIDIOC-DV-TIMINGS-CAP; to check if it also supports other
+standards or even custom timings that are not in this list.</para>
+
+    <para>To query the available timings, applications initialize the
+<structfield>index</structfield> field and zero the reserved array of &v4l2-enum-dv-timings;
+and call the <constant>VIDIOC_ENUM_DV_TIMINGS</constant> ioctl with a pointer to this
+structure. Drivers fill the rest of the structure or return an
+&EINVAL; when the index is out of bounds. To enumerate all supported DV timings,
+applications shall begin at index zero, incrementing by one until the
+driver returns <errorcode>EINVAL</errorcode>. Note that drivers may enumerate a
+different set of DV timings after switching the video input or
+output.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-enum-dv-timings">
+      <title>struct <structname>v4l2_enum_dv_timings</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>index</structfield></entry>
+	    <entry>Number of the DV timings, set by the
+application.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[3]</entry>
+	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
+	  </row>
+	  <row>
+	    <entry>&v4l2-dv-timings;</entry>
+	    <entry><structfield>timings</structfield></entry>
+	    <entry>The timings.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>EINVAL</errorcode></term>
+	<listitem>
+	  <para>The &v4l2-enum-dv-timings; <structfield>index</structfield>
+is out of bounds.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
+
+<!--
+Local Variables:
+mode: sgml
+sgml-parent-document: "v4l2.sgml"
+indent-tabs-mode: nil
+End:
+-->
diff --git a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
index 9b8efcd..46d5a04 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
@@ -285,7 +285,7 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
 	  <row>
 	    <entry><constant>V4L2_IN_CAP_CUSTOM_TIMINGS</constant></entry>
 	    <entry>0x00000002</entry>
-	    <entry>This input supports setting custom video timings by using VIDIOC_S_DV_TIMINGS.</entry>
+	    <entry>This input supports setting video timings by using VIDIOC_S_DV_TIMINGS.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_IN_CAP_STD</constant></entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
index a64d5ef..4280200 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
@@ -170,7 +170,7 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
 	  <row>
 	    <entry><constant>V4L2_OUT_CAP_CUSTOM_TIMINGS</constant></entry>
 	    <entry>0x00000002</entry>
-	    <entry>This output supports setting custom video timings by using VIDIOC_S_DV_TIMINGS.</entry>
+	    <entry>This output supports setting video timings by using VIDIOC_S_DV_TIMINGS.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_OUT_CAP_STD</constant></entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
index 4a8648a..eda1a29 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
@@ -7,7 +7,7 @@
   <refnamediv>
     <refname>VIDIOC_G_DV_TIMINGS</refname>
     <refname>VIDIOC_S_DV_TIMINGS</refname>
-    <refpurpose>Get or set custom DV timings for input or output</refpurpose>
+    <refpurpose>Get or set DV timings for input or output</refpurpose>
   </refnamediv>
 
   <refsynopsisdiv>
@@ -48,12 +48,15 @@
 
   <refsect1>
     <title>Description</title>
-    <para>To set custom DV timings for the input or output, applications use the
-<constant>VIDIOC_S_DV_TIMINGS</constant> ioctl and to get the current custom timings,
+    <para>To set DV timings for the input or output, applications use the
+<constant>VIDIOC_S_DV_TIMINGS</constant> ioctl and to get the current timings,
 applications use the <constant>VIDIOC_G_DV_TIMINGS</constant> ioctl. The detailed timing
 information is filled in using the structure &v4l2-dv-timings;. These ioctls take
 a pointer to the &v4l2-dv-timings; structure as argument. If the ioctl is not supported
 or the timing values are not correct, the driver returns &EINVAL;.</para>
+<para>The <filename>linux/v4l2-dv-timings.h</filename> header can be used to get the
+timings of the formats in the <xref linkend="cea861" /> and <xref linkend="vesadmt" />
+standards.</para>
   </refsect1>
 
   <refsect1>
@@ -83,12 +86,13 @@ or the timing values are not correct, the driver returns &EINVAL;.</para>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>width</structfield></entry>
-	    <entry>Width of the active video in pixels</entry>
+	    <entry>Width of the active video in pixels.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>height</structfield></entry>
-	    <entry>Height of the active video in lines</entry>
+	    <entry>Height of the active video frame in lines. So for interlaced formats the
+	    height of the active video in each field is <structfield>height</structfield>/2.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -125,32 +129,52 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>vfrontporch</structfield></entry>
-	    <entry>Vertical front porch in lines</entry>
+	    <entry>Vertical front porch in lines. For interlaced formats this refers to the
+	    odd field (aka field 1).</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>vsync</structfield></entry>
-	    <entry>Vertical sync length in lines</entry>
+	    <entry>Vertical sync length in lines. For interlaced formats this refers to the
+	    odd field (aka field 1).</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>vbackporch</structfield></entry>
-	    <entry>Vertical back porch in lines</entry>
+	    <entry>Vertical back porch in lines. For interlaced formats this refers to the
+	    odd field (aka field 1).</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vfrontporch</structfield></entry>
-	    <entry>Vertical front porch in lines for bottom field of interlaced field formats</entry>
+	    <entry>Vertical front porch in lines for the even field (aka field 2) of
+	    interlaced field formats.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vsync</structfield></entry>
-	    <entry>Vertical sync length in lines for bottom field of interlaced field formats</entry>
+	    <entry>Vertical sync length in lines for the even field (aka field 2) of
+	    interlaced field formats.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>il_vbackporch</structfield></entry>
-	    <entry>Vertical back porch in lines for bottom field of interlaced field formats</entry>
+	    <entry>Vertical back porch in lines for the even field (aka field 2) of
+	    interlaced field formats.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>standards</structfield></entry>
+	    <entry>The video standard(s) this format belongs to. This will be filled in by
+	    the driver. Applications must set this to 0. See <xref linkend="dv-bt-standards"/>
+	    for a list of standards.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>flags</structfield></entry>
+	    <entry>Several flags giving more information about the format.
+	    See <xref linkend="dv-bt-flags"/> for a description of the flags.
+	    </entry>
 	  </row>
 	</tbody>
       </tgroup>
@@ -211,6 +235,90 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
 	</tbody>
       </tgroup>
     </table>
+    <table pgwide="1" frame="none" id="dv-bt-standards">
+      <title>DV BT Timing standards</title>
+      <tgroup cols="2">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>Timing standard</entry>
+	    <entry>Description</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_STD_CEA861</entry>
+	    <entry>The timings follow the CEA-861 Digital TV Profile standard</entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_STD_DMT</entry>
+	    <entry>The timings follow the VESA Discrete Monitor Timings standard</entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_STD_CVT</entry>
+	    <entry>The timings follow the VESA Coordinated Video Timings standard</entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_BT_STD_GTF</entry>
+	    <entry>The timings follow the VESA Generalized Timings Formula standard</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+    <table pgwide="1" frame="none" id="dv-bt-flags">
+      <title>DV BT Timing flags</title>
+      <tgroup cols="2">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>Flag</entry>
+	    <entry>Description</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
+	    <entry></entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_REDUCED_BLANKING</entry>
+	    <entry>CVT/GTF specific: the timings use reduced blanking (CVT) or the 'Secondary
+GTF' curve (GTF). In both cases the horizontal and/or vertical blanking
+intervals are reduced, allowing a higher resolution over the same
+bandwidth. This is a read-only flag, applications must not set this.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_CAN_REDUCE_FPS</entry>
+	    <entry>CEA-861 specific: set for CEA-861 formats with a framerate that is a multiple
+of six. These formats can be optionally played at 1 / 1.001 speed to
+be compatible with 60 Hz based standards such as NTSC and PAL-M that use a framerate of
+29.97 frames per second. If the transmitter can't generate such frequencies, then the
+flag will also be cleared. This is a read-only flag, applications must not set this.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_REDUCED_FPS</entry>
+	    <entry>CEA-861 specific: only valid for video transmitters, the flag is cleared
+by receivers. It is also only valid for formats with the V4L2_DV_FL_CAN_REDUCE_FPS flag
+set, for other formats the flag will be cleared by the driver.
+
+If the application sets this flag, then the pixelclock used to set up the transmitter is
+divided by 1.001 to make it compatible with NTSC framerates. If the transmitter
+can't generate such frequencies, then the flag will also be cleared.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>V4L2_DV_FL_HALF_LINE</entry>
+	    <entry>Specific to interlaced formats: if set, then field 1 (aka the odd field)
+is really one half-line longer and field 2 (aka the even field) is really one half-line
+shorter, so each field has exactly the same number of half-lines. Whether half-lines can be
+detected or used depends on the hardware.
+	    </entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
   </refsect1>
   <refsect1>
     &return-value;
diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
index 7bde698..fa7ad7e 100644
--- a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
@@ -48,6 +48,12 @@
   <refsect1>
     <title>Description</title>
 
+    <note>
+      <title>Experimental</title>
+      <para>This is an <link linkend="experimental"> experimental </link>
+      interface and may change in the future.</para>
+    </note>
+
     <para>Applications can optionally call the
 <constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
 to the driver before actually enqueuing it, using the
diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
new file mode 100644
index 0000000..44935a0
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
@@ -0,0 +1,104 @@
+<refentry id="vidioc-query-dv-timings">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_QUERY_DV_TIMINGS</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_QUERY_DV_TIMINGS</refname>
+    <refpurpose>Sense the DV preset received by the current
+input</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_dv_timings *<parameter>argp</parameter></paramdef>
+      </funcprototype>
+    </funcsynopsis>
+  </refsynopsisdiv>
+
+  <refsect1>
+    <title>Arguments</title>
+
+    <variablelist>
+	<varlistentry>
+	<term><parameter>fd</parameter></term>
+	<listitem>
+	  <para>&fd;</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><parameter>request</parameter></term>
+	<listitem>
+	  <para>VIDIOC_QUERY_DV_TIMINGS</para>
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
+      <para>This is an <link linkend="experimental"> experimental </link>
+      interface and may change in the future.</para>
+    </note>
+
+    <para>The hardware may be able to detect the current DV timings
+automatically, similar to sensing the video standard. To do so, applications
+call <constant>VIDIOC_QUERY_DV_TIMINGS</constant> with a pointer to a
+&v4l2-dv-timings;. Once the hardware detects the timings, it will fill in the
+timings structure.
+
+If the timings could not be detected because there was no signal, then
+<errorcode>ENOLINK</errorcode> is returned. If a signal was detected, but
+it was unstable and the receiver could not lock to the signal, then
+<errorcode>ENOLCK</errorcode> is returned. If the receiver could lock to the signal,
+but the format is unsupported (e.g. because the pixelclock is out of range
+of the hardware capabilities), then the driver fills in whatever timings it
+could find and returns <errorcode>ERANGE</errorcode>. In that case the application
+can call &VIDIOC-DV-TIMINGS-CAP; to compare the found timings with the hardware's
+capabilities in order to give more precise feedback to the user.
+</para>
+  </refsect1>
+
+  <refsect1>
+    &return-value;
+
+    <variablelist>
+      <varlistentry>
+	<term><errorcode>ENOLINK</errorcode></term>
+	<listitem>
+	  <para>No timings could be detected because no signal was found.
+</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>ENOLCK</errorcode></term>
+	<listitem>
+	  <para>The signal was unstable and the hardware could not lock on to it.
+</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>ERANGE</errorcode></term>
+	<listitem>
+	  <para>Timings were found, but they are out of range of the hardware
+capabilities.
+</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
-- 
1.7.10

