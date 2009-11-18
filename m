Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52528 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbZKRSuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 13:50:03 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"mchehab@infradead.org" <mchehab@infradead.org>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 18 Nov 2009 12:49:58 -0600
Subject: RE: [PATCH v2] V4L - Digital Video Timings API documentation
Message-ID: <A69FA2915331DC488A831521EAE36FE401559C6104@dlee06.ent.ti.com>
References: <1258569289-4635-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1258569289-4635-1-git-send-email-m-karicheri2@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please ignore this since I found some issues with this.
I will be sending another one soon.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Wednesday, November 18, 2009 1:35 PM
>To: linux-media@vger.kernel.org; hverkuil@xs4all.nl; mchehab@infradead.org
>Cc: davinci-linux-open-source@linux.davincidsp.com; Karicheri, Muralidharan
>Subject: [PATCH v2] V4L - Digital Video Timings API documentation
>
>From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
>This patch updates the v4l2-dvb documentation for the new
>video timings API added.
>
>Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
>---
>
>diff -uNr v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/common.xml
>v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/common.xml
>--- v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/common.xml
>       2009-11-12 09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/common.xml
>       2009-11-18 12:13:34.000000000 -0500
>@@ -716,6 +716,41 @@
> }
>       </programlisting>
>     </example>
>+  <section id="dv-timings">
>+      <title>Digital Video (DV) Timings</title>
>+      <para>
>+      The video standards discussed so far has been dealing with Analog TV
>and the
>+corresponding video timings. Today there are many more different hardware
>interfaces
>+such as High Definition TV interfaces (HDMI), VGA, DVI connectors etc.,
>that carries
>+video signals and there is a need to extend the API to allow settings
>video timings
>+ on these interfaces. Since it is not possible to extend the v4l2-std-id
>due to
>+the limited bits available, a new set of IOCTLs are added to set/get video
>timings at
>+the input and output:- </para><itemizedlist>
>+      <listitem>
>+      <para> DV Presets :- Digital Video (DV) presets. These are IDs
>representing a
>+video timing at the input/output. Presets can be thought of pre-defined
>timings implemented
>+by the hardware like standards. A __u32 data type is used to represent a
>preset unlike the
>+ bit mask that is used in &v4l2-std-id; allowing future extensions to
>support many
>+different presets as needed</para>
>+      </listitem>
>+      <listitem>
>+      <para> Custom DV Timings :- This will allow applications to define a
>more detailed
>+custom video timings at the interface. This includes parameters such as
>width, height,
>+ polarities, frontporch, backporch etc.
>+      </para>
>+      </listitem>
>+      </itemizedlist>
>+      <para> To Enumerate and query the attributes of DV presets supported
>by a device,
>+ applications use the &VIDIOC-ENUM-DV-PRESETS; ioctl. To Get the current
>DV preset,
>+ application use the &VIDIOC-G-DV-PRESET; ioctl and to Set a preset it
>uses the
>+ &VIDIOC-S-DV-PRESET; ioctl.</para>
>+      <para> To Set a Custom DV timings at the device, applications use the
>+ &VIDIOC-S-DV-TIMINGS; ioctl and to Get current Custom DV timings, it uses
>the
>+ &VIDIOC-G-DV-TIMINGS; ioctl.</para>
>+      <para> Applications can make use of the <xref linkend="input-
>capabilities" /> and
>+<xref linkend="output-capabilities"/> flags to decide what ioctls
>available to set the
>+video timings at the device.</para>
>+      </section>
>   </section>
>
>   &sub-controls;
>diff -uNr v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/v4l2.xml
>v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/v4l2.xml
>--- v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/v4l2.xml      2009-11-
>12 09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/v4l2.xml
>       2009-11-18 12:13:57.000000000 -0500
>@@ -416,6 +416,10 @@
>     &sub-enum-frameintervals;
>     &sub-enuminput;
>     &sub-enumoutput;
>+    &sub-enum-dv-presets;
>+    &sub-g-dv-preset;
>+    &sub-query-dv-preset;
>+    &sub-g-dv-timings;
>     &sub-enumstd;
>     &sub-g-audio;
>     &sub-g-audioout;
>diff -uNr v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-enum-
>dv-presets.xml v4l-dvb-
>aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-enum-dv-presets.xml
>--- v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-enum-dv-
>presets.xml    1969-12-31 19:00:00.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-enum-
>dv-presets.xml 2009-11-18 12:14:25.000000000 -0500
>@@ -0,0 +1,167 @@
>+<refentry id="vidioc-enum-dv-presets">
>+  <refmeta>
>+    <refentrytitle>ioctl VIDIOC_ENUM_DV_PRESETS</refentrytitle>
>+    &manvol;
>+  </refmeta>
>+
>+  <refnamediv>
>+    <refname>VIDIOC_ENUM_DV_PRESETS</refname>
>+    <refpurpose>Enumerate supported Digital Video Presets</refpurpose>
>+  </refnamediv>
>+
>+  <refsynopsisdiv>
>+    <funcsynopsis>
>+      <funcprototype>
>+      <funcdef>int <function>ioctl</function></funcdef>
>+      <paramdef>int <parameter>fd</parameter></paramdef>
>+      <paramdef>int <parameter>request</parameter></paramdef>
>+      <paramdef>struct v4l2_dv_enum_preset
>*<parameter>argp</parameter></paramdef>
>+      </funcprototype>
>+    </funcsynopsis>
>+  </refsynopsisdiv>
>+
>+  <refsect1>
>+    <title>Arguments</title>
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><parameter>fd</parameter></term>
>+      <listitem>
>+        <para>&fd;</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>request</parameter></term>
>+      <listitem>
>+        <para>VIDIOC_ENUM_DV_PRESETS</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>argp</parameter></term>
>+      <listitem>
>+        <para></para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+
>+  <refsect1>
>+    <title>Description</title>
>+
>+    <para>To query the attributes of a DV preset, applications initialize
>the
>+<structfield>index</structfield> field of &v4l2-dv-enum-preset; and call
>the
>+<constant>VIDIOC_ENUM_DV_PRESETS</constant> ioctl with a pointer to this
>+structure. Drivers fill the rest of the structure or return an
>+&EINVAL; when the index is out of bounds. To enumerate all DV Presets
>supported,
>+applications shall begin  at index zero, incrementing by one until the
>+driver returns <errorcode>EINVAL</errorcode>. Drivers may enumerate a
>+different set of DV Presets after switching the video input or
>+output.</para>
>+
>+    <table pgwide="1" frame="none" id="v4l2-dv-enum-preset">
>+      <title>struct <structname>v4l2_dv_enum_presets</structname></title>
>+      <tgroup cols="3">
>+      &cs-str;
>+      <tbody valign="top">
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>index</structfield></entry>
>+          <entry>Number of the DV preset, set by the
>+application.</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>preset</structfield></entry>
>+          <entry>This field identify one of the DV Preset value listed
>below</entry>
>+        </row>
>+        <row>
>+          <entry>__u8</entry>
>+          <entry><structfield>name</structfield>[24]</entry>
>+          <entry>Name of the preset, a NUL-terminated ASCII
>+string, for example: "720P-60", "1080I-60". This information is
>+intended for the user.</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>width</structfield></entry>
>+          <entry>Width in pixels of the DV preset.</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>height</structfield></entry>
>+          <entry>Height in lines of the DV preset.</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>reserved</structfield>[4]</entry>
>+          <entry>Reserved for future extensions. Drivers must set
>+the array to zero.</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>+    <para><programlisting>
>+#define               V4L2_DV_PRESET_BASE     0x00000000
>+#define               V4L2_DV_INVALID         (V4L2_DV_PRESET_BASE + 0)
>+/* BT.1362 */
>+#define               V4L2_DV_480P59_94       (V4L2_DV_PRESET_BASE + 1)
>+/* BT.1362 */
>+#define               V4L2_DV_576P50          (V4L2_DV_PRESET_BASE + 2)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P24          (V4L2_DV_PRESET_BASE + 3)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P25          (V4L2_DV_PRESET_BASE + 4)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P30          (V4L2_DV_PRESET_BASE + 5)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P50          (V4L2_DV_PRESET_BASE + 6)
>+/* SMPTE 274M */
>+#define               V4L2_DV_720P59_94       (V4L2_DV_PRESET_BASE + 7)
>+/* SMPTE 274M/296M */
>+#define               V4L2_DV_720P60          (V4L2_DV_PRESET_BASE + 8)
>+/* BT.1120/ SMPTE 274M */
>+#define               V4L2_DV_1080I29_97      (V4L2_DV_PRESET_BASE + 9)
>+/* BT.1120/ SMPTE 274M */
>+#define               V4L2_DV_1080I30         (V4L2_DV_PRESET_BASE + 10)
>+/* BT.1120 */
>+#define               V4L2_DV_1080I25         (V4L2_DV_PRESET_BASE + 11)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080I50         (V4L2_DV_PRESET_BASE + 12)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080I60         (V4L2_DV_PRESET_BASE + 13)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P24         (V4L2_DV_PRESET_BASE + 14)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P25         (V4L2_DV_PRESET_BASE + 15)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P30         (V4L2_DV_PRESET_BASE + 16)
>+/* BT.1120 */
>+#define               V4L2_DV_1080P50         (V4L2_DV_PRESET_BASE + 17)
>+/* BT.1120 */
>+#define               V4L2_DV_1080P60         (V4L2_DV_PRESET_BASE + 18)
>+</programlisting> </para>
>+  </refsect1>
>+
>+  <refsect1>
>+    &return-value;
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><errorcode>EINVAL</errorcode></term>
>+      <listitem>
>+        <para>The &v4l2-dv-enum-preset; <structfield>index</structfield>
>+is out of bounds.</para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+</refentry>
>+
>+<!--
>+Local Variables:
>+mode: sgml
>+sgml-parent-document: "v4l2.sgml"
>+indent-tabs-mode: nil
>+End:
>+-->
>diff -uNr v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-
>enuminput.xml v4l-dvb-
>aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-enuminput.xml
>--- v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-
>enuminput.xml  2009-11-12 09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-
>enuminput.xml  2009-11-18 12:14:54.000000000 -0500
>@@ -124,7 +124,13 @@
>         </row>
>         <row>
>           <entry>__u32</entry>
>-          <entry><structfield>reserved</structfield>[4]</entry>
>+          <entry><structfield>capabilities</structfield></entry>
>+          <entry>This field provides capabilities that exists at the
>+input.  See <xref linkend="input-capabilities" /> for flags </entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>reserved</structfield>[3]</entry>
>           <entry>Reserved for future extensions. Drivers must set
> the array to zero.</entry>
>         </row>
>@@ -261,6 +267,34 @@
>       </tbody>
>       </tgroup>
>     </table>
>+
>+    <!-- Capabilities flags based on video timings RFC by Muralidharan
>+Karicheri, titled RFC (v1.2): V4L - Support for video timings at the
>+input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
>+      -->
>+    <table frame="none" pgwide="1" id="input-capabilities">
>+      <title>Input capabilities</title>
>+      <tgroup cols="3">
>+      &cs-def;
>+      <tbody valign="top">
>+        <row>
>+          <entry><constant>V4L2_IN_CAP_PRESETS</constant></entry>
>+          <entry>0x00000001</entry>
>+          <entry>This input supports setting DV PRESET using
>VIDIOC_S_DV_PRESET</entry>
>+        </row>
>+        <row>
>+          <entry><constant>V4L2_OUT_CAP_CUSTOM_TIMINGS</constant></entry>
>+          <entry>0x00000002</entry>
>+          <entry>This input supports setting Custom timings using
>VIDIOC_S_DV_TIMINGS</entry>
>+        </row>
>+        <row>
>+          <entry><constant>V4L2_IN_CAP_STD</constant></entry>
>+          <entry>0x00000004</entry>
>+          <entry>This input supports setting standard using
>VIDIOC_S_STD</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>   </refsect1>
>
>   <refsect1>
>diff -uNr v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-
>enumoutput.xml v4l-dvb-
>aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-enumoutput.xml
>--- v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-
>enumoutput.xml 2009-11-12 09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-
>enumoutput.xml 2009-11-18 12:15:09.000000000 -0500
>@@ -114,7 +114,13 @@
>         </row>
>         <row>
>           <entry>__u32</entry>
>-          <entry><structfield>reserved</structfield>[4]</entry>
>+          <entry><structfield>capabilities</structfield></entry>
>+          <entry>This field provides capabilities that exists at the
>+output.  See <xref linkend="output-capabilities" /> for flags </entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>reserved</structfield>[3]</entry>
>           <entry>Reserved for future extensions. Drivers must set
> the array to zero.</entry>
>         </row>
>@@ -147,6 +153,34 @@
>       </tgroup>
>     </table>
>
>+    <!-- Capabilities flags based on video timings RFC by Muralidharan
>+Karicheri, titled RFC (v1.2): V4L - Support for video timings at the
>+input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
>+      -->
>+    <table frame="none" pgwide="1" id="output-capabilities">
>+      <title>Output capabilities</title>
>+      <tgroup cols="3">
>+      &cs-def;
>+      <tbody valign="top">
>+        <row>
>+          <entry><constant>V4L2_OUT_CAP_PRESETS</constant></entry>
>+          <entry>0x00000001</entry>
>+          <entry>This output supports setting DV PRESET using
>VIDIOC_S_DV_PRESET</entry>
>+        </row>
>+        <row>
>+          <entry><constant>V4L2_OUT_CAP_CUSTOM_TIMINGS</constant></entry>
>+          <entry>0x00000002</entry>
>+          <entry>This output supports setting Custom timings using
>VIDIOC_S_DV_TIMINGS</entry>
>+        </row>
>+        <row>
>+          <entry><constant>V4L2_OUT_CAP_STD</constant></entry>
>+          <entry>0x00000004</entry>
>+          <entry>This output supports setting standard using
>VIDIOC_S_STD</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>   </refsect1>
>   <refsect1>
>     &return-value;
>diff -uNr v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-g-dv-
>preset.xml v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-
>g-dv-preset.xml
>--- v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-g-dv-
>preset.xml     1969-12-31 19:00:00.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-g-dv-
>preset.xml     2009-11-18 12:15:31.000000000 -0500
>@@ -0,0 +1,103 @@
>+<refentry id="vidioc-g-dv-preset">
>+  <refmeta>
>+    <refentrytitle>ioctl VIDIOC_G_DV_PRESET,
>VIDIOC_S_DV_PRESET</refentrytitle>
>+    &manvol;
>+  </refmeta>
>+
>+  <refnamediv>
>+    <refname>VIDIOC_G_DV_PRESET</refname>
>+    <refname>VIDIOC_S_DV_PRESET</refname>
>+    <refpurpose>Query or select the DV preset of the current input or
>output</refpurpose>
>+  </refnamediv>
>+
>+  <refsynopsisdiv>
>+    <funcsynopsis>
>+      <funcprototype>
>+      <funcdef>int <function>ioctl</function></funcdef>
>+      <paramdef>int <parameter>fd</parameter></paramdef>
>+      <paramdef>int <parameter>request</parameter></paramdef>
>+      <paramdef>&v4l2-dv-preset;
>+*<parameter>argp</parameter></paramdef>
>+      </funcprototype>
>+    </funcsynopsis>
>+  </refsynopsisdiv>
>+
>+  <refsect1>
>+    <title>Arguments</title>
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><parameter>fd</parameter></term>
>+      <listitem>
>+        <para>&fd;</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>request</parameter></term>
>+      <listitem>
>+        <para>VIDIOC_G_DV_PRESET, VIDIOC_S_DV_PRESET</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>argp</parameter></term>
>+      <listitem>
>+        <para></para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+
>+  <refsect1>
>+    <title>Description</title>
>+    <para>To query and select the current DV preset, applications
>+use the <constant>VIDIOC_G_DV_PRESET</constant> and
><constant>VIDIOC_S_DV_PRESET</constant>
>+ioctls which take a pointer to a &v4l2-dv-preset; type as argument.
><constant>VIDIOC_G_DV_PRESET</constant>
>+returns a dv preset in the field <structfield>preset</structfield> of
>&v4l2-dv-preset; </para>
>+
>+    <para><constant>VIDIOC_S_DV_PRESET</constant> accepts a pointer to a
>&v4l2-dv-preset;
>+that has the preset value to be set. If the preset is not supported, it
>+returns an &EINVAL; </para>
>+  </refsect1>
>+
>+  <refsect1>
>+    &return-value;
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><errorcode>EINVAL</errorcode></term>
>+      <listitem>
>+        <para>This ioctl is not supported, or the
>+<constant>VIDIOC_S_DV_PRESET</constant>,<constant>VIDIOC_S_DV_PRESET</cons
>tant> parameter was unsuitable.</para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+
>+    <table pgwide="1" frame="none" id="v4l2-dv-preset">
>+      <title>struct <structname>v4l2_dv_preset</structname></title>
>+      <tgroup cols="3">
>+      &cs-str;
>+      <tbody valign="top">
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>preset</structfield></entry>
>+          <entry>preset value to represent the digital video
>timings</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>reserved[4]</structfield></entry>
>+          <entry>Reserved fields for future use</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>+  </refsect1>
>+</refentry>
>+
>+<!--
>+Local Variables:
>+mode: sgml
>+sgml-parent-document: "v4l2.sgml"
>+indent-tabs-mode: nil
>+End:
>+-->
>diff -uNr v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-g-dv-
>timings.xml v4l-dvb-
>aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-g-dv-timings.xml
>--- v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-g-dv-
>timings.xml    1969-12-31 19:00:00.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-g-dv-
>timings.xml    2009-11-18 12:15:42.000000000 -0500
>@@ -0,0 +1,195 @@
>+<refentry id="vidioc-g-dv-timings">
>+  <refmeta>
>+    <refentrytitle>ioctl VIDIOC_G_DV_TIMINGS,
>VIDIOC_S_DV_TIMINGS</refentrytitle>
>+    &manvol;
>+  </refmeta>
>+
>+  <refnamediv>
>+    <refname>VIDIOC_G_DV_TIMINGS</refname>
>+    <refname>VIDIOC_S_DV_TIMINGS</refname>
>+    <refpurpose>Get or Set Custom DV Timings at input or
>output</refpurpose>
>+  </refnamediv>
>+
>+  <refsynopsisdiv>
>+    <funcsynopsis>
>+      <funcprototype>
>+      <funcdef>int <function>ioctl</function></funcdef>
>+      <paramdef>int <parameter>fd</parameter></paramdef>
>+      <paramdef>int <parameter>request</parameter></paramdef>
>+      <paramdef>&v4l2-dv-timings;
>+*<parameter>argp</parameter></paramdef>
>+      </funcprototype>
>+    </funcsynopsis>
>+  </refsynopsisdiv>
>+
>+  <refsect1>
>+    <title>Arguments</title>
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><parameter>fd</parameter></term>
>+      <listitem>
>+        <para>&fd;</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>request</parameter></term>
>+      <listitem>
>+        <para>VIDIOC_G_DV_TIMINGS, VIDIOC_S_DV_TIMINGS</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>argp</parameter></term>
>+      <listitem>
>+        <para></para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+
>+  <refsect1>
>+    <title>Description</title>
>+    <para>To Set Custom DV timings at the input or output, applications
>use the
>+<constant>VIDIOC_S_DV_TIMINGS</constant> ioctl and to Get the current
>custom timings,
>+applications use  <constant>VIDIOC_G_DV_TIMINGS</constant> ioctl. The
>detailed timing
>+informations are filled in using the structure &v4l2-dv-timings;. These
>ioctls take
>+ a pointer to &v4l2-dv-timings; structure as argument. If the ioctl is not
>supported
>+or the timing values are not correct, driver returns an &EINVAL; </para>
>+  </refsect1>
>+
>+  <refsect1>
>+    &return-value;
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><errorcode>EINVAL</errorcode></term>
>+      <listitem>
>+        <para>This ioctl is not supported, or the
>+<constant>VIDIOC_S_DV_TIMINGS</constant> parameter was unsuitable.</para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+
>+   <table frame="none" pgwide="1" id="v4l2-dv-timings-type">
>+      <title>DV Timing types</title>
>+      <tgroup cols="3">
>+        &cs-def;
>+        <tbody valign="top">
>+          <row>
>+            <entry><constant>V4L2_DV_BT_656_1120</constant></entry>
>+            <entry></entry>
>+            <entry>BT.656/BT.1120 timings </entry>
>+          </row>
>+        </tbody>
>+      </tgroup>
>+    </table>
>+
>+
>+    <table pgwide="1" frame="none" id="v4l2-bt-timings">
>+      <title>struct <structname>v4l2_bt_timings</structname></title>
>+      <tgroup cols="3">
>+      &cs-str;
>+      <tbody valign="top">
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>width</structfield></entry>
>+          <entry>width in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>height</structfield></entry>
>+          <entry>height in lines</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>interlaced</structfield></entry>
>+          <entry>Interlaced or progressive</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>polarities</structfield></entry>
>+          <entry>Positive or negative polarity</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>pixelclock</structfield></entry>
>+          <entry>Pixel clock in HZ. Ex. 74.25MHz->74250000</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>hfrontporch</structfield></entry>
>+          <entry>Horizpontal front porch in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>hsync</structfield></entry>
>+          <entry>Horizontal Sync length in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>hbackporch</structfield></entry>
>+          <entry>Horizontal back porch in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>vfrontporch</structfield></entry>
>+          <entry>Vertical front porch in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>vsync</structfield></entry>
>+          <entry>Vertical Sync length in lines</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>vbackporch</structfield></entry>
>+          <entry>Vertical back porch in lines</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>il_vfrontporch</structfield></entry>
>+          <entry>Vertical front porch for bottom field of interlaced field
>formats</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>il_vsync</structfield></entry>
>+          <entry>Vertical sync length for bottom field of interlaced field
>formats</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>il_vbackporch</structfield></entry>
>+          <entry>Vertical back porch for bottom field of interlaced field
>formats</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>+    <table pgwide="1" frame="none" id="v4l2-dv-timings">
>+      <title>struct <structname>v4l2_dv_timings</structname></title>
>+      <tgroup cols="3">
>+      &cs-str;
>+      <tbody valign="top">
>+        <row>
>+          <entry>&v4l2-dv-timings-type;</entry>
>+          <entry><structfield>type</structfield></entry>
>+          <entry></entry>
>+        </row>
>+        <row>
>+          <entry>union</entry>
>+          <entry><structfield>&v4l2-bt-timings; bt and
>reserved[32]</structfield></entry>
>+          <entry></entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>+  </refsect1>
>+</refentry>
>+
>+<!--
>+Local Variables:
>+mode: sgml
>+sgml-parent-document: "v4l2.sgml"
>+indent-tabs-mode: nil
>+End:
>+-->
>diff -uNr v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-
>query-dv-preset.xml v4l-dvb-
>aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-query-dv-preset.xml
>--- v4l-dvb-aba823ecaea6/linux/Documentation/DocBook/v4l/vidioc-query-dv-
>preset.xml     1969-12-31 19:00:00.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/Documentation/DocBook/v4l/vidioc-query-
>dv-preset.xml  2009-11-18 12:15:53.000000000 -0500
>@@ -0,0 +1,80 @@
>+<refentry id="vidioc-query-dv-preset">
>+  <refmeta>
>+    <refentrytitle>ioctl VIDIOC_QUERY_DV_PRESET</refentrytitle>
>+    &manvol;
>+  </refmeta>
>+
>+  <refnamediv>
>+    <refname>VIDIOC_QUERY_DV_PRESET</refname>
>+    <refpurpose>Sense the DV preset received by the current
>+input</refpurpose>
>+  </refnamediv>
>+
>+  <refsynopsisdiv>
>+    <funcsynopsis>
>+      <funcprototype>
>+      <funcdef>int <function>ioctl</function></funcdef>
>+      <paramdef>int <parameter>fd</parameter></paramdef>
>+      <paramdef>int <parameter>request</parameter></paramdef>
>+      <paramdef>&v4l2-dv-preset; *<parameter>argp</parameter></paramdef>
>+      </funcprototype>
>+    </funcsynopsis>
>+  </refsynopsisdiv>
>+
>+  <refsect1>
>+    <title>Arguments</title>
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><parameter>fd</parameter></term>
>+      <listitem>
>+        <para>&fd;</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>request</parameter></term>
>+      <listitem>
>+        <para>VIDIOC_QUERY_DV_PRESET</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>argp</parameter></term>
>+      <listitem>
>+        <para></para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+
>+  <refsect1>
>+    <title>Description</title>
>+
>+    <para>The hardware may be able to detect the current DV preset
>+automatically similar to sensing the video standard. To do so,
>applications
>+call <constant> VIDIOC_QUERY_DV_PRESET</constant> with a pointer to a
>+ &v4l2-dv-preset; type.  Once hardware detects a preset, the same is
>+returned in the preset field of &v4l2-dv-preset; When detection is not
>+possible or fails, the value V4L2_DV_INVALID is returned</para>
>+  </refsect1>
>+
>+  <refsect1>
>+    &return-value;
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><errorcode>EINVAL</errorcode></term>
>+      <listitem>
>+        <para>This ioctl is not supported.</para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+</refentry>
>+
>+<!--
>+Local Variables:
>+mode: sgml
>+sgml-parent-document: "v4l2.sgml"
>+indent-tabs-mode: nil
>+End:
>+-->
>diff -uNr v4l-dvb-aba823ecaea6/linux/include/linux/videodev2.h v4l-dvb-
>aba823ecaea6_new/linux/include/linux/videodev2.h
>--- v4l-dvb-aba823ecaea6/linux/include/linux/videodev2.h       2009-11-12
>09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/linux/include/linux/videodev2.h   2009-11-
>18 12:16:26.000000000 -0500
>@@ -731,6 +731,119 @@
> };
>
> /*
>+ *    V I D E O       T I M I N G S   D V     P R E S E T
>+ */
>+struct v4l2_dv_preset {
>+      __u32   preset;
>+      __u32   reserved[4];
>+};
>+
>+/*
>+ *    D V     P R E S E T S   E N U M E R A T I O N
>+ */
>+struct v4l2_dv_enum_preset {
>+      __u32   index;
>+      __u32   preset;
>+      __u8    name[32]; /* Name of the preset timing */
>+      __u32   width;
>+      __u32   height;
>+      __u32   reserved[4];
>+};
>+
>+/*
>+ *    D V     P R E S E T     V A L U E S
>+ */
>+#define               V4L2_DV_PRESET_BASE     0x00000000
>+#define               V4L2_DV_INVALID         (V4L2_DV_PRESET_BASE + 0)
>+/* BT.1362 */
>+#define               V4L2_DV_480P59_94       (V4L2_DV_PRESET_BASE + 1)
>+/* BT.1362 */
>+#define               V4L2_DV_576P50          (V4L2_DV_PRESET_BASE + 2)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P24          (V4L2_DV_PRESET_BASE + 3)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P25          (V4L2_DV_PRESET_BASE + 4)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P30          (V4L2_DV_PRESET_BASE + 5)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P50          (V4L2_DV_PRESET_BASE + 6)
>+/* SMPTE 274M */
>+#define               V4L2_DV_720P59_94       (V4L2_DV_PRESET_BASE + 7)
>+/* SMPTE 274M/296M */
>+#define               V4L2_DV_720P60          (V4L2_DV_PRESET_BASE + 8)
>+/* BT.1120/ SMPTE 274M */
>+#define               V4L2_DV_1080I29_97      (V4L2_DV_PRESET_BASE + 9)
>+/* BT.1120/ SMPTE 274M */
>+#define               V4L2_DV_1080I30         (V4L2_DV_PRESET_BASE + 10)
>+/* BT.1120 */
>+#define               V4L2_DV_1080I25         (V4L2_DV_PRESET_BASE + 11)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080I50         (V4L2_DV_PRESET_BASE + 12)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080I60         (V4L2_DV_PRESET_BASE + 13)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P24         (V4L2_DV_PRESET_BASE + 14)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P25         (V4L2_DV_PRESET_BASE + 15)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P30         (V4L2_DV_PRESET_BASE + 16)
>+/* BT.1120 */
>+#define               V4L2_DV_1080P50         (V4L2_DV_PRESET_BASE + 17)
>+/* BT.1120 */
>+#define               V4L2_DV_1080P60         (V4L2_DV_PRESET_BASE + 18)
>+
>+/*
>+ *    D V     B T     T I M I N G S
>+ */
>+
>+/* BT.656/BT.1120 timing data */
>+struct v4l2_bt_timings {
>+      __u32   width;          /* width in pixels */
>+      __u32   height;         /* height in lines */
>+      __u32   interlaced;     /* Interlaced or progressive */
>+      __u32   polarities;     /* Positive or negative polarity */
>+      __u64   pixelclock;     /* Pixel clock in HZ. Ex. 74.25MHz->74250000 */
>+      __u32   hfrontporch;    /* Horizpontal front porch in pixels */
>+      __u32   hsync;          /* Horizontal Sync length in pixels */
>+      __u32   hbackporch;     /* Horizontal back porch in pixels */
>+      __u32   vfrontporch;    /* Vertical front porch in pixels */
>+      __u32   vsync;          /* Vertical Sync length in lines */
>+      __u32   vbackporch;     /* Vertical back porch in lines */
>+      __u32   il_vfrontporch; /* Vertical front porch for bottom field of
>+                               * interlaced field formats
>+                               */
>+      __u32   il_vsync;       /* Vertical sync length for bottom field of
>+                               * interlaced field formats
>+                               */
>+      __u32   il_vbackporch;  /* Vertical back porch for bottom field of
>+                               * interlaced field formats
>+                               */
>+      __u32   reserved[16];
>+};
>+
>+/* Interlaced or progressive format */
>+#define       V4L2_DV_PROGRESSIVE     0
>+#define       V4L2_DV_INTERLACED      1
>+
>+/* Polarities. If bit is not set, it is assumed to be negative polarity */
>+#define V4L2_DV_VSYNC_POS_POL 0x00000001
>+#define V4L2_DV_HSYNC_POS_POL 0x00000002
>+
>+/* BT.656/1120 timing type */
>+enum v4l2_dv_timings_type {
>+      V4L2_DV_BT_656_1120,
>+};
>+
>+/* DV timings */
>+struct v4l2_dv_timings {
>+      enum v4l2_dv_timings_type type;
>+      union {
>+              struct v4l2_bt_timings  bt;
>+              __u32   reserved[32];
>+      };
>+};
>+
>+/*
>  *    V I D E O   I N P U T S
>  */
> struct v4l2_input {
>@@ -741,7 +854,8 @@
>       __u32        tuner;             /*  Associated tuner */
>       v4l2_std_id  std;
>       __u32        status;
>-      __u32        reserved[4];
>+      __u32        capabilities;
>+      __u32        reserved[3];
> };
>
> /*  Values for the 'type' field */
>@@ -772,6 +886,11 @@
> #define V4L2_IN_ST_NO_ACCESS   0x02000000  /* Conditional access denied */
> #define V4L2_IN_ST_VTR         0x04000000  /* VTR time constant */
>
>+/* capabilities flags */
>+#define V4L2_IN_CAP_PRESETS           0x00000001 /* Supports DV_PRESETS */
>+#define V4L2_IN_CAP_CUSTOM_TIMINGS    0x00000002 /* Supports Custom timings
>*/
>+#define V4L2_IN_CAP_STD                       0x00000004 /* Supports STD */
>+
> /*
>  *    V I D E O   O U T P U T S
>  */
>@@ -782,13 +901,19 @@
>       __u32        audioset;          /*  Associated audios (bitfield) */
>       __u32        modulator;         /*  Associated modulator */
>       v4l2_std_id  std;
>-      __u32        reserved[4];
>+      __u32        capabilities;
>+      __u32        reserved[3];
> };
> /*  Values for the 'type' field */
> #define V4L2_OUTPUT_TYPE_MODULATOR            1
> #define V4L2_OUTPUT_TYPE_ANALOG                       2
> #define V4L2_OUTPUT_TYPE_ANALOGVGAOVERLAY     3
>
>+/* capabilities flags */
>+#define V4L2_OUT_CAP_PRESETS          0x00000001 /* Supports DV_PRESETS */
>+#define V4L2_OUT_CAP_CUSTOM_TIMINGS   0x00000002 /* Supports Custom
>timings */
>+#define V4L2_OUT_CAP_STD              0x00000004 /* Supports STD */
>+
> /*
>  *    C O N T R O L S
>  */
>@@ -1621,6 +1746,13 @@
> #endif
>
> #define VIDIOC_S_HW_FREQ_SEEK  _IOW('V', 82, struct
>v4l2_hw_freq_seek)
>+#define       VIDIOC_ENUM_DV_PRESETS  _IOWR('V', 83, struct
>v4l2_dv_enum_preset)
>+#define       VIDIOC_S_DV_PRESET      _IOWR('V', 84, struct v4l2_dv_preset)
>+#define       VIDIOC_G_DV_PRESET      _IOWR('V', 85, struct v4l2_dv_preset)
>+#define       VIDIOC_QUERY_DV_PRESET  _IOR('V',  86, struct v4l2_dv_preset)
>+#define       VIDIOC_S_DV_TIMINGS     _IOWR('V', 87, struct v4l2_dv_timings)
>+#define       VIDIOC_G_DV_TIMINGS     _IOWR('V', 88, struct v4l2_dv_timings)
>+
> /* Reminder: when adding new ioctls please add support for them to
>    drivers/media/video/v4l2-compat-ioctl32.c as well! */
>
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/Makefile v4l-dvb-
>aba823ecaea6_new/media-specs/Makefile
>--- v4l-dvb-aba823ecaea6/media-specs/Makefile  2009-11-12
>09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/Makefile      2009-11-18
>12:16:59.000000000 -0500
>@@ -60,6 +60,10 @@
>       v4l/vidioc-enumaudioout.xml \
>       v4l/vidioc-enuminput.xml \
>       v4l/vidioc-enumoutput.xml \
>+      v4l/vidioc-enum-dv-presets.xml \
>+      v4l/vidioc-g-dv-preset.xml \
>+      v4l/vidioc-query-dv-preset.xml \
>+      v4l/vidioc-g-dv-timings.xml \
>       v4l/vidioc-enumstd.xml \
>       v4l/vidioc-g-audio.xml \
>       v4l/vidioc-g-audioout.xml \
>@@ -191,6 +195,12 @@
>       VIDIOC_ENUMAUDOUT \
>       VIDIOC_ENUMINPUT \
>       VIDIOC_ENUMOUTPUT \
>+      VIDIOC_ENUM_DV_PRESETS \
>+      VIDIOC_QUERY_DV_PRESET \
>+      VIDIOC_G_DV_PRESET \
>+      VIDIOC_S_DV_PRESET \
>+      VIDIOC_G_DV_TIMINGS \
>+      VIDIOC_S_DV_TIMINGS \
>       VIDIOC_ENUMSTD \
>       VIDIOC_ENUM_FMT \
>       VIDIOC_ENUM_FRAMEINTERVALS \
>@@ -283,6 +293,7 @@
>       v4l2_priority \
>       v4l2_tuner_type \
>       v4l2_preemphasis \
>+      v4l2_dv_timings_type \
>
> STRUCTS = \
>       v4l2_audio \
>@@ -333,6 +344,10 @@
>       v4l2_tuner \
>       v4l2_vbi_format \
>       v4l2_window \
>+      v4l2_dv_enum_preset \
>+      v4l2_dv_preset \
>+      v4l2_dv_timings \
>+      v4l2_bt_timings \
>
> ERRORS = \
>       EACCES \
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/v4l/common.xml v4l-dvb-
>aba823ecaea6_new/media-specs/v4l/common.xml
>--- v4l-dvb-aba823ecaea6/media-specs/v4l/common.xml    2009-11-12
>09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/v4l/common.xml        2009-11-18
>12:13:34.000000000 -0500
>@@ -716,6 +716,41 @@
> }
>       </programlisting>
>     </example>
>+  <section id="dv-timings">
>+      <title>Digital Video (DV) Timings</title>
>+      <para>
>+      The video standards discussed so far has been dealing with Analog TV
>and the
>+corresponding video timings. Today there are many more different hardware
>interfaces
>+such as High Definition TV interfaces (HDMI), VGA, DVI connectors etc.,
>that carries
>+video signals and there is a need to extend the API to allow settings
>video timings
>+ on these interfaces. Since it is not possible to extend the v4l2-std-id
>due to
>+the limited bits available, a new set of IOCTLs are added to set/get video
>timings at
>+the input and output:- </para><itemizedlist>
>+      <listitem>
>+      <para> DV Presets :- Digital Video (DV) presets. These are IDs
>representing a
>+video timing at the input/output. Presets can be thought of pre-defined
>timings implemented
>+by the hardware like standards. A __u32 data type is used to represent a
>preset unlike the
>+ bit mask that is used in &v4l2-std-id; allowing future extensions to
>support many
>+different presets as needed</para>
>+      </listitem>
>+      <listitem>
>+      <para> Custom DV Timings :- This will allow applications to define a
>more detailed
>+custom video timings at the interface. This includes parameters such as
>width, height,
>+ polarities, frontporch, backporch etc.
>+      </para>
>+      </listitem>
>+      </itemizedlist>
>+      <para> To Enumerate and query the attributes of DV presets supported
>by a device,
>+ applications use the &VIDIOC-ENUM-DV-PRESETS; ioctl. To Get the current
>DV preset,
>+ application use the &VIDIOC-G-DV-PRESET; ioctl and to Set a preset it
>uses the
>+ &VIDIOC-S-DV-PRESET; ioctl.</para>
>+      <para> To Set a Custom DV timings at the device, applications use the
>+ &VIDIOC-S-DV-TIMINGS; ioctl and to Get current Custom DV timings, it uses
>the
>+ &VIDIOC-G-DV-TIMINGS; ioctl.</para>
>+      <para> Applications can make use of the <xref linkend="input-
>capabilities" /> and
>+<xref linkend="output-capabilities"/> flags to decide what ioctls
>available to set the
>+video timings at the device.</para>
>+      </section>
>   </section>
>
>   &sub-controls;
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/v4l/v4l2.xml v4l-dvb-
>aba823ecaea6_new/media-specs/v4l/v4l2.xml
>--- v4l-dvb-aba823ecaea6/media-specs/v4l/v4l2.xml      2009-11-12
>09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/v4l/v4l2.xml  2009-11-18
>12:13:57.000000000 -0500
>@@ -416,6 +416,10 @@
>     &sub-enum-frameintervals;
>     &sub-enuminput;
>     &sub-enumoutput;
>+    &sub-enum-dv-presets;
>+    &sub-g-dv-preset;
>+    &sub-query-dv-preset;
>+    &sub-g-dv-timings;
>     &sub-enumstd;
>     &sub-g-audio;
>     &sub-g-audioout;
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-enum-dv-presets.xml
>v4l-dvb-aba823ecaea6_new/media-specs/v4l/vidioc-enum-dv-presets.xml
>--- v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-enum-dv-presets.xml
>       1969-12-31 19:00:00.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/v4l/vidioc-enum-dv-presets.xml
>       2009-11-18 12:14:25.000000000 -0500
>@@ -0,0 +1,167 @@
>+<refentry id="vidioc-enum-dv-presets">
>+  <refmeta>
>+    <refentrytitle>ioctl VIDIOC_ENUM_DV_PRESETS</refentrytitle>
>+    &manvol;
>+  </refmeta>
>+
>+  <refnamediv>
>+    <refname>VIDIOC_ENUM_DV_PRESETS</refname>
>+    <refpurpose>Enumerate supported Digital Video Presets</refpurpose>
>+  </refnamediv>
>+
>+  <refsynopsisdiv>
>+    <funcsynopsis>
>+      <funcprototype>
>+      <funcdef>int <function>ioctl</function></funcdef>
>+      <paramdef>int <parameter>fd</parameter></paramdef>
>+      <paramdef>int <parameter>request</parameter></paramdef>
>+      <paramdef>struct v4l2_dv_enum_preset
>*<parameter>argp</parameter></paramdef>
>+      </funcprototype>
>+    </funcsynopsis>
>+  </refsynopsisdiv>
>+
>+  <refsect1>
>+    <title>Arguments</title>
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><parameter>fd</parameter></term>
>+      <listitem>
>+        <para>&fd;</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>request</parameter></term>
>+      <listitem>
>+        <para>VIDIOC_ENUM_DV_PRESETS</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>argp</parameter></term>
>+      <listitem>
>+        <para></para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+
>+  <refsect1>
>+    <title>Description</title>
>+
>+    <para>To query the attributes of a DV preset, applications initialize
>the
>+<structfield>index</structfield> field of &v4l2-dv-enum-preset; and call
>the
>+<constant>VIDIOC_ENUM_DV_PRESETS</constant> ioctl with a pointer to this
>+structure. Drivers fill the rest of the structure or return an
>+&EINVAL; when the index is out of bounds. To enumerate all DV Presets
>supported,
>+applications shall begin  at index zero, incrementing by one until the
>+driver returns <errorcode>EINVAL</errorcode>. Drivers may enumerate a
>+different set of DV Presets after switching the video input or
>+output.</para>
>+
>+    <table pgwide="1" frame="none" id="v4l2-dv-enum-preset">
>+      <title>struct <structname>v4l2_dv_enum_presets</structname></title>
>+      <tgroup cols="3">
>+      &cs-str;
>+      <tbody valign="top">
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>index</structfield></entry>
>+          <entry>Number of the DV preset, set by the
>+application.</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>preset</structfield></entry>
>+          <entry>This field identify one of the DV Preset value listed
>below</entry>
>+        </row>
>+        <row>
>+          <entry>__u8</entry>
>+          <entry><structfield>name</structfield>[24]</entry>
>+          <entry>Name of the preset, a NUL-terminated ASCII
>+string, for example: "720P-60", "1080I-60". This information is
>+intended for the user.</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>width</structfield></entry>
>+          <entry>Width in pixels of the DV preset.</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>height</structfield></entry>
>+          <entry>Height in lines of the DV preset.</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>reserved</structfield>[4]</entry>
>+          <entry>Reserved for future extensions. Drivers must set
>+the array to zero.</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>+    <para><programlisting>
>+#define               V4L2_DV_PRESET_BASE     0x00000000
>+#define               V4L2_DV_INVALID         (V4L2_DV_PRESET_BASE + 0)
>+/* BT.1362 */
>+#define               V4L2_DV_480P59_94       (V4L2_DV_PRESET_BASE + 1)
>+/* BT.1362 */
>+#define               V4L2_DV_576P50          (V4L2_DV_PRESET_BASE + 2)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P24          (V4L2_DV_PRESET_BASE + 3)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P25          (V4L2_DV_PRESET_BASE + 4)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P30          (V4L2_DV_PRESET_BASE + 5)
>+/* SMPTE 296M */
>+#define               V4L2_DV_720P50          (V4L2_DV_PRESET_BASE + 6)
>+/* SMPTE 274M */
>+#define               V4L2_DV_720P59_94       (V4L2_DV_PRESET_BASE + 7)
>+/* SMPTE 274M/296M */
>+#define               V4L2_DV_720P60          (V4L2_DV_PRESET_BASE + 8)
>+/* BT.1120/ SMPTE 274M */
>+#define               V4L2_DV_1080I29_97      (V4L2_DV_PRESET_BASE + 9)
>+/* BT.1120/ SMPTE 274M */
>+#define               V4L2_DV_1080I30         (V4L2_DV_PRESET_BASE + 10)
>+/* BT.1120 */
>+#define               V4L2_DV_1080I25         (V4L2_DV_PRESET_BASE + 11)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080I50         (V4L2_DV_PRESET_BASE + 12)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080I60         (V4L2_DV_PRESET_BASE + 13)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P24         (V4L2_DV_PRESET_BASE + 14)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P25         (V4L2_DV_PRESET_BASE + 15)
>+/* SMPTE 296M */
>+#define               V4L2_DV_1080P30         (V4L2_DV_PRESET_BASE + 16)
>+/* BT.1120 */
>+#define               V4L2_DV_1080P50         (V4L2_DV_PRESET_BASE + 17)
>+/* BT.1120 */
>+#define               V4L2_DV_1080P60         (V4L2_DV_PRESET_BASE + 18)
>+</programlisting> </para>
>+  </refsect1>
>+
>+  <refsect1>
>+    &return-value;
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><errorcode>EINVAL</errorcode></term>
>+      <listitem>
>+        <para>The &v4l2-dv-enum-preset; <structfield>index</structfield>
>+is out of bounds.</para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+</refentry>
>+
>+<!--
>+Local Variables:
>+mode: sgml
>+sgml-parent-document: "v4l2.sgml"
>+indent-tabs-mode: nil
>+End:
>+-->
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-enuminput.xml v4l-
>dvb-aba823ecaea6_new/media-specs/v4l/vidioc-enuminput.xml
>--- v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-enuminput.xml  2009-11-
>12 09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/v4l/vidioc-enuminput.xml      2009-11-
>18 12:14:54.000000000 -0500
>@@ -124,7 +124,13 @@
>         </row>
>         <row>
>           <entry>__u32</entry>
>-          <entry><structfield>reserved</structfield>[4]</entry>
>+          <entry><structfield>capabilities</structfield></entry>
>+          <entry>This field provides capabilities that exists at the
>+input.  See <xref linkend="input-capabilities" /> for flags </entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>reserved</structfield>[3]</entry>
>           <entry>Reserved for future extensions. Drivers must set
> the array to zero.</entry>
>         </row>
>@@ -261,6 +267,34 @@
>       </tbody>
>       </tgroup>
>     </table>
>+
>+    <!-- Capabilities flags based on video timings RFC by Muralidharan
>+Karicheri, titled RFC (v1.2): V4L - Support for video timings at the
>+input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
>+      -->
>+    <table frame="none" pgwide="1" id="input-capabilities">
>+      <title>Input capabilities</title>
>+      <tgroup cols="3">
>+      &cs-def;
>+      <tbody valign="top">
>+        <row>
>+          <entry><constant>V4L2_IN_CAP_PRESETS</constant></entry>
>+          <entry>0x00000001</entry>
>+          <entry>This input supports setting DV PRESET using
>VIDIOC_S_DV_PRESET</entry>
>+        </row>
>+        <row>
>+          <entry><constant>V4L2_OUT_CAP_CUSTOM_TIMINGS</constant></entry>
>+          <entry>0x00000002</entry>
>+          <entry>This input supports setting Custom timings using
>VIDIOC_S_DV_TIMINGS</entry>
>+        </row>
>+        <row>
>+          <entry><constant>V4L2_IN_CAP_STD</constant></entry>
>+          <entry>0x00000004</entry>
>+          <entry>This input supports setting standard using
>VIDIOC_S_STD</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>   </refsect1>
>
>   <refsect1>
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-enumoutput.xml v4l-
>dvb-aba823ecaea6_new/media-specs/v4l/vidioc-enumoutput.xml
>--- v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-enumoutput.xml 2009-11-
>12 09:21:05.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/v4l/vidioc-enumoutput.xml
>       2009-11-18 12:15:09.000000000 -0500
>@@ -114,7 +114,13 @@
>         </row>
>         <row>
>           <entry>__u32</entry>
>-          <entry><structfield>reserved</structfield>[4]</entry>
>+          <entry><structfield>capabilities</structfield></entry>
>+          <entry>This field provides capabilities that exists at the
>+output.  See <xref linkend="output-capabilities" /> for flags </entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>reserved</structfield>[3]</entry>
>           <entry>Reserved for future extensions. Drivers must set
> the array to zero.</entry>
>         </row>
>@@ -147,6 +153,34 @@
>       </tgroup>
>     </table>
>
>+    <!-- Capabilities flags based on video timings RFC by Muralidharan
>+Karicheri, titled RFC (v1.2): V4L - Support for video timings at the
>+input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
>+      -->
>+    <table frame="none" pgwide="1" id="output-capabilities">
>+      <title>Output capabilities</title>
>+      <tgroup cols="3">
>+      &cs-def;
>+      <tbody valign="top">
>+        <row>
>+          <entry><constant>V4L2_OUT_CAP_PRESETS</constant></entry>
>+          <entry>0x00000001</entry>
>+          <entry>This output supports setting DV PRESET using
>VIDIOC_S_DV_PRESET</entry>
>+        </row>
>+        <row>
>+          <entry><constant>V4L2_OUT_CAP_CUSTOM_TIMINGS</constant></entry>
>+          <entry>0x00000002</entry>
>+          <entry>This output supports setting Custom timings using
>VIDIOC_S_DV_TIMINGS</entry>
>+        </row>
>+        <row>
>+          <entry><constant>V4L2_OUT_CAP_STD</constant></entry>
>+          <entry>0x00000004</entry>
>+          <entry>This output supports setting standard using
>VIDIOC_S_STD</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>   </refsect1>
>   <refsect1>
>     &return-value;
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-g-dv-preset.xml v4l-
>dvb-aba823ecaea6_new/media-specs/v4l/vidioc-g-dv-preset.xml
>--- v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-g-dv-preset.xml        1969-12-
>31 19:00:00.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/v4l/vidioc-g-dv-preset.xml
>       2009-11-18 12:15:31.000000000 -0500
>@@ -0,0 +1,103 @@
>+<refentry id="vidioc-g-dv-preset">
>+  <refmeta>
>+    <refentrytitle>ioctl VIDIOC_G_DV_PRESET,
>VIDIOC_S_DV_PRESET</refentrytitle>
>+    &manvol;
>+  </refmeta>
>+
>+  <refnamediv>
>+    <refname>VIDIOC_G_DV_PRESET</refname>
>+    <refname>VIDIOC_S_DV_PRESET</refname>
>+    <refpurpose>Query or select the DV preset of the current input or
>output</refpurpose>
>+  </refnamediv>
>+
>+  <refsynopsisdiv>
>+    <funcsynopsis>
>+      <funcprototype>
>+      <funcdef>int <function>ioctl</function></funcdef>
>+      <paramdef>int <parameter>fd</parameter></paramdef>
>+      <paramdef>int <parameter>request</parameter></paramdef>
>+      <paramdef>&v4l2-dv-preset;
>+*<parameter>argp</parameter></paramdef>
>+      </funcprototype>
>+    </funcsynopsis>
>+  </refsynopsisdiv>
>+
>+  <refsect1>
>+    <title>Arguments</title>
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><parameter>fd</parameter></term>
>+      <listitem>
>+        <para>&fd;</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>request</parameter></term>
>+      <listitem>
>+        <para>VIDIOC_G_DV_PRESET, VIDIOC_S_DV_PRESET</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>argp</parameter></term>
>+      <listitem>
>+        <para></para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+
>+  <refsect1>
>+    <title>Description</title>
>+    <para>To query and select the current DV preset, applications
>+use the <constant>VIDIOC_G_DV_PRESET</constant> and
><constant>VIDIOC_S_DV_PRESET</constant>
>+ioctls which take a pointer to a &v4l2-dv-preset; type as argument.
><constant>VIDIOC_G_DV_PRESET</constant>
>+returns a dv preset in the field <structfield>preset</structfield> of
>&v4l2-dv-preset; </para>
>+
>+    <para><constant>VIDIOC_S_DV_PRESET</constant> accepts a pointer to a
>&v4l2-dv-preset;
>+that has the preset value to be set. If the preset is not supported, it
>+returns an &EINVAL; </para>
>+  </refsect1>
>+
>+  <refsect1>
>+    &return-value;
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><errorcode>EINVAL</errorcode></term>
>+      <listitem>
>+        <para>This ioctl is not supported, or the
>+<constant>VIDIOC_S_DV_PRESET</constant>,<constant>VIDIOC_S_DV_PRESET</cons
>tant> parameter was unsuitable.</para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+
>+    <table pgwide="1" frame="none" id="v4l2-dv-preset">
>+      <title>struct <structname>v4l2_dv_preset</structname></title>
>+      <tgroup cols="3">
>+      &cs-str;
>+      <tbody valign="top">
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>preset</structfield></entry>
>+          <entry>preset value to represent the digital video
>timings</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>reserved[4]</structfield></entry>
>+          <entry>Reserved fields for future use</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>+  </refsect1>
>+</refentry>
>+
>+<!--
>+Local Variables:
>+mode: sgml
>+sgml-parent-document: "v4l2.sgml"
>+indent-tabs-mode: nil
>+End:
>+-->
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-g-dv-timings.xml v4l-
>dvb-aba823ecaea6_new/media-specs/v4l/vidioc-g-dv-timings.xml
>--- v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-g-dv-timings.xml       1969-12-
>31 19:00:00.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/v4l/vidioc-g-dv-timings.xml
>       2009-11-18 12:15:42.000000000 -0500
>@@ -0,0 +1,195 @@
>+<refentry id="vidioc-g-dv-timings">
>+  <refmeta>
>+    <refentrytitle>ioctl VIDIOC_G_DV_TIMINGS,
>VIDIOC_S_DV_TIMINGS</refentrytitle>
>+    &manvol;
>+  </refmeta>
>+
>+  <refnamediv>
>+    <refname>VIDIOC_G_DV_TIMINGS</refname>
>+    <refname>VIDIOC_S_DV_TIMINGS</refname>
>+    <refpurpose>Get or Set Custom DV Timings at input or
>output</refpurpose>
>+  </refnamediv>
>+
>+  <refsynopsisdiv>
>+    <funcsynopsis>
>+      <funcprototype>
>+      <funcdef>int <function>ioctl</function></funcdef>
>+      <paramdef>int <parameter>fd</parameter></paramdef>
>+      <paramdef>int <parameter>request</parameter></paramdef>
>+      <paramdef>&v4l2-dv-timings;
>+*<parameter>argp</parameter></paramdef>
>+      </funcprototype>
>+    </funcsynopsis>
>+  </refsynopsisdiv>
>+
>+  <refsect1>
>+    <title>Arguments</title>
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><parameter>fd</parameter></term>
>+      <listitem>
>+        <para>&fd;</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>request</parameter></term>
>+      <listitem>
>+        <para>VIDIOC_G_DV_TIMINGS, VIDIOC_S_DV_TIMINGS</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>argp</parameter></term>
>+      <listitem>
>+        <para></para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+
>+  <refsect1>
>+    <title>Description</title>
>+    <para>To Set Custom DV timings at the input or output, applications
>use the
>+<constant>VIDIOC_S_DV_TIMINGS</constant> ioctl and to Get the current
>custom timings,
>+applications use  <constant>VIDIOC_G_DV_TIMINGS</constant> ioctl. The
>detailed timing
>+informations are filled in using the structure &v4l2-dv-timings;. These
>ioctls take
>+ a pointer to &v4l2-dv-timings; structure as argument. If the ioctl is not
>supported
>+or the timing values are not correct, driver returns an &EINVAL; </para>
>+  </refsect1>
>+
>+  <refsect1>
>+    &return-value;
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><errorcode>EINVAL</errorcode></term>
>+      <listitem>
>+        <para>This ioctl is not supported, or the
>+<constant>VIDIOC_S_DV_TIMINGS</constant> parameter was unsuitable.</para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+
>+   <table frame="none" pgwide="1" id="v4l2-dv-timings-type">
>+      <title>DV Timing types</title>
>+      <tgroup cols="3">
>+        &cs-def;
>+        <tbody valign="top">
>+          <row>
>+            <entry><constant>V4L2_DV_BT_656_1120</constant></entry>
>+            <entry></entry>
>+            <entry>BT.656/BT.1120 timings </entry>
>+          </row>
>+        </tbody>
>+      </tgroup>
>+    </table>
>+
>+
>+    <table pgwide="1" frame="none" id="v4l2-bt-timings">
>+      <title>struct <structname>v4l2_bt_timings</structname></title>
>+      <tgroup cols="3">
>+      &cs-str;
>+      <tbody valign="top">
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>width</structfield></entry>
>+          <entry>width in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>height</structfield></entry>
>+          <entry>height in lines</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>interlaced</structfield></entry>
>+          <entry>Interlaced or progressive</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>polarities</structfield></entry>
>+          <entry>Positive or negative polarity</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>pixelclock</structfield></entry>
>+          <entry>Pixel clock in HZ. Ex. 74.25MHz->74250000</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>hfrontporch</structfield></entry>
>+          <entry>Horizpontal front porch in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>hsync</structfield></entry>
>+          <entry>Horizontal Sync length in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>hbackporch</structfield></entry>
>+          <entry>Horizontal back porch in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>vfrontporch</structfield></entry>
>+          <entry>Vertical front porch in pixels</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>vsync</structfield></entry>
>+          <entry>Vertical Sync length in lines</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>vbackporch</structfield></entry>
>+          <entry>Vertical back porch in lines</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>il_vfrontporch</structfield></entry>
>+          <entry>Vertical front porch for bottom field of interlaced field
>formats</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>il_vsync</structfield></entry>
>+          <entry>Vertical sync length for bottom field of interlaced field
>formats</entry>
>+        </row>
>+        <row>
>+          <entry>__u32</entry>
>+          <entry><structfield>il_vbackporch</structfield></entry>
>+          <entry>Vertical back porch for bottom field of interlaced field
>formats</entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>+    <table pgwide="1" frame="none" id="v4l2-dv-timings">
>+      <title>struct <structname>v4l2_dv_timings</structname></title>
>+      <tgroup cols="3">
>+      &cs-str;
>+      <tbody valign="top">
>+        <row>
>+          <entry>&v4l2-dv-timings-type;</entry>
>+          <entry><structfield>type</structfield></entry>
>+          <entry></entry>
>+        </row>
>+        <row>
>+          <entry>union</entry>
>+          <entry><structfield>&v4l2-bt-timings; bt and
>reserved[32]</structfield></entry>
>+          <entry></entry>
>+        </row>
>+      </tbody>
>+      </tgroup>
>+    </table>
>+
>+  </refsect1>
>+</refentry>
>+
>+<!--
>+Local Variables:
>+mode: sgml
>+sgml-parent-document: "v4l2.sgml"
>+indent-tabs-mode: nil
>+End:
>+-->
>diff -uNr v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-query-dv-preset.xml
>v4l-dvb-aba823ecaea6_new/media-specs/v4l/vidioc-query-dv-preset.xml
>--- v4l-dvb-aba823ecaea6/media-specs/v4l/vidioc-query-dv-preset.xml
>       1969-12-31 19:00:00.000000000 -0500
>+++ v4l-dvb-aba823ecaea6_new/media-specs/v4l/vidioc-query-dv-preset.xml
>       2009-11-18 12:15:53.000000000 -0500
>@@ -0,0 +1,80 @@
>+<refentry id="vidioc-query-dv-preset">
>+  <refmeta>
>+    <refentrytitle>ioctl VIDIOC_QUERY_DV_PRESET</refentrytitle>
>+    &manvol;
>+  </refmeta>
>+
>+  <refnamediv>
>+    <refname>VIDIOC_QUERY_DV_PRESET</refname>
>+    <refpurpose>Sense the DV preset received by the current
>+input</refpurpose>
>+  </refnamediv>
>+
>+  <refsynopsisdiv>
>+    <funcsynopsis>
>+      <funcprototype>
>+      <funcdef>int <function>ioctl</function></funcdef>
>+      <paramdef>int <parameter>fd</parameter></paramdef>
>+      <paramdef>int <parameter>request</parameter></paramdef>
>+      <paramdef>&v4l2-dv-preset; *<parameter>argp</parameter></paramdef>
>+      </funcprototype>
>+    </funcsynopsis>
>+  </refsynopsisdiv>
>+
>+  <refsect1>
>+    <title>Arguments</title>
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><parameter>fd</parameter></term>
>+      <listitem>
>+        <para>&fd;</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>request</parameter></term>
>+      <listitem>
>+        <para>VIDIOC_QUERY_DV_PRESET</para>
>+      </listitem>
>+      </varlistentry>
>+      <varlistentry>
>+      <term><parameter>argp</parameter></term>
>+      <listitem>
>+        <para></para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+
>+  <refsect1>
>+    <title>Description</title>
>+
>+    <para>The hardware may be able to detect the current DV preset
>+automatically similar to sensing the video standard. To do so,
>applications
>+call <constant> VIDIOC_QUERY_DV_PRESET</constant> with a pointer to a
>+ &v4l2-dv-preset; type.  Once hardware detects a preset, the same is
>+returned in the preset field of &v4l2-dv-preset; When detection is not
>+possible or fails, the value V4L2_DV_INVALID is returned</para>
>+  </refsect1>
>+
>+  <refsect1>
>+    &return-value;
>+
>+    <variablelist>
>+      <varlistentry>
>+      <term><errorcode>EINVAL</errorcode></term>
>+      <listitem>
>+        <para>This ioctl is not supported.</para>
>+      </listitem>
>+      </varlistentry>
>+    </variablelist>
>+  </refsect1>
>+</refentry>
>+
>+<!--
>+Local Variables:
>+mode: sgml
>+sgml-parent-document: "v4l2.sgml"
>+indent-tabs-mode: nil
>+End:
>+-->
