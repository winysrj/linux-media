Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4743 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2GEK0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 06:26:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] v4l2 spec: add VIDIOC_ENUM_FREQ_BANDS documentation.
Date: Thu,  5 Jul 2012 12:25:30 +0200
Message-Id: <9c717c7b5c288df94e10e75e0a75a7c7b615d513.1341483687.git.hans.verkuil@cisco.com>
In-Reply-To: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
References: <1341483933-9986-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9f434bb4733245d7342b1547f65e40dae1603cd5.1341483687.git.hans.verkuil@cisco.com>
References: <9f434bb4733245d7342b1547f65e40dae1603cd5.1341483687.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |   12 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |    6 +
 .../DocBook/media/v4l/vidioc-enum-freq-bands.xml   |  179 ++++++++++++++++++++
 .../DocBook/media/v4l/vidioc-g-frequency.xml       |    7 +-
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   26 ++-
 5 files changed, 221 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index ea42ef8..2ec8000 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2458,6 +2458,15 @@ details.</para>
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.6</title>
+      <orderedlist>
+        <listitem>
+	  <para>Added support for frequency band enumerations: &VIDIOC-ENUM-FREQ-BANDS;.</para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
@@ -2587,6 +2596,9 @@ ioctls.</para>
 	  <para><link linkend="v4l2-auto-focus-area"><constant>
 	  V4L2_CID_AUTO_FOCUS_AREA</constant></link> control.</para>
         </listitem>
+        <listitem>
+	  <para>Support for frequency band enumeration: &VIDIOC-ENUM-FREQ-BANDS; ioctl.</para>
+        </listitem>
       </itemizedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 008c2d7..c6e307b 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -140,6 +140,11 @@ structs, ioctls) must be noted in more detail in the history chapter
 applications. -->
 
       <revision>
+	<revnumber>3.6</revnumber>
+	<date>2012-07-02</date>
+	<authorinitials>hv</authorinitials>
+	<revremark>Added VIDIOC_ENUM_FREQ_BANDS.
+	</revremark>
 	<revnumber>3.5</revnumber>
 	<date>2012-05-07</date>
 	<authorinitials>sa, sn</authorinitials>
@@ -534,6 +539,7 @@ and discussions on the V4L mailing list.</revremark>
     &sub-enum-fmt;
     &sub-enum-framesizes;
     &sub-enum-frameintervals;
+    &sub-enum-freq-bands;
     &sub-enuminput;
     &sub-enumoutput;
     &sub-enumstd;
diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml b/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
new file mode 100644
index 0000000..6541ba0
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/vidioc-enum-freq-bands.xml
@@ -0,0 +1,179 @@
+<refentry id="vidioc-enum-freq-bands">
+  <refmeta>
+    <refentrytitle>ioctl VIDIOC_ENUM_FREQ_BANDS</refentrytitle>
+    &manvol;
+  </refmeta>
+
+  <refnamediv>
+    <refname>VIDIOC_ENUM_FREQ_BANDS</refname>
+    <refpurpose>Enumerate supported frequency bands</refpurpose>
+  </refnamediv>
+
+  <refsynopsisdiv>
+    <funcsynopsis>
+      <funcprototype>
+	<funcdef>int <function>ioctl</function></funcdef>
+	<paramdef>int <parameter>fd</parameter></paramdef>
+	<paramdef>int <parameter>request</parameter></paramdef>
+	<paramdef>struct v4l2_frequency_band
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
+	  <para>VIDIOC_ENUM_FREQ_BANDS</para>
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
+    <para>Enumerates the frequency bands that a tuner or modulator supports.
+To do this applications initialize the <structfield>tuner</structfield>,
+<structfield>type</structfield> and <structfield>index</structfield> fields,
+and zero out the <structfield>reserved</structfield> array of a &v4l2-frequency-band; and
+call the <constant>VIDIOC_ENUM_FREQ_BANDS</constant> ioctl with a pointer
+to this structure.</para>
+
+    <para>This ioctl is supported if the <constant>V4L2_TUNER_CAP_FREQ_BANDS</constant> capability
+    of the corresponding tuner/modulator is set.</para>
+
+    <table pgwide="1" frame="none" id="v4l2-frequency-band">
+      <title>struct <structname>v4l2_frequency_band</structname></title>
+      <tgroup cols="3">
+	&cs-str;
+	<tbody valign="top">
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>tuner</structfield></entry>
+	    <entry>The tuner or modulator index number. This is the
+same value as in the &v4l2-input; <structfield>tuner</structfield>
+field and the &v4l2-tuner; <structfield>index</structfield> field, or
+the &v4l2-output; <structfield>modulator</structfield> field and the
+&v4l2-modulator; <structfield>index</structfield> field.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>type</structfield></entry>
+	    <entry>The tuner type. This is the same value as in the
+&v4l2-tuner; <structfield>type</structfield> field. The type must be set
+to <constant>V4L2_TUNER_RADIO</constant> for <filename>/dev/radioX</filename>
+device nodes, and to <constant>V4L2_TUNER_ANALOG_TV</constant>
+for all others. Set this field to <constant>V4L2_TUNER_RADIO</constant> for
+modulators (currently only radio modulators are supported).
+See <xref linkend="v4l2-tuner-type" /></entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>index</structfield></entry>
+	    <entry>Identifies the frequency band, set by the application.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>capability</structfield></entry>
+	    <entry spanname="hspan">The tuner/modulator capability flags for
+this frequency band, see <xref linkend="tuner-capability" />. The <constant>V4L2_TUNER_CAP_LOW</constant>
+capability must be the same for all frequency bands of the selected tuner/modulator.
+So either all bands have that capability set, or none of them have that capability.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>rangelow</structfield></entry>
+	    <entry spanname="hspan">The lowest tunable frequency in
+units of 62.5 kHz, or if the <structfield>capability</structfield>
+flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
+Hz, for this frequency band.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>rangehigh</structfield></entry>
+	    <entry spanname="hspan">The highest tunable frequency in
+units of 62.5 kHz, or if the <structfield>capability</structfield>
+flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
+Hz, for this frequency band.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>modulation</structfield></entry>
+	    <entry spanname="hspan">The supported modulation systems of this frequency band.
+	    See <xref linkend="band-modulation" />. Note that currently only one
+	    modulation system per frequency band is supported. More work will need to
+	    be done if multiple modulation systems are possible. Contact the
+	    linux-media mailing list (&v4l-ml;) if you need that functionality.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[9]</entry>
+	    <entry>Reserved for future extensions. Applications and drivers
+	    must set the array to zero.</entry>
+	  </row>
+	</tbody>
+      </tgroup>
+    </table>
+
+    <table pgwide="1" frame="none" id="band-modulation">
+      <title>Band Modulation Systems</title>
+      <tgroup cols="3">
+	&cs-def;
+	<tbody valign="top">
+	  <row>
+	    <entry><constant>V4L2_BAND_MODULATION_VSB</constant></entry>
+	    <entry>0x02</entry>
+	    <entry>Vestigial Sideband modulation, used for analog TV.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_BAND_MODULATION_FM</constant></entry>
+	    <entry>0x04</entry>
+	    <entry>Frequency Modulation, commonly used for analog radio.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_BAND_MODULATION_AM</constant></entry>
+	    <entry>0x08</entry>
+	    <entry>Amplitude Modulation, commonly used for analog radio.</entry>
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
+	  <para>The <structfield>tuner</structfield> or <structfield>index</structfield>
+is out of bounds or the <structfield>type</structfield> field is wrong.</para>
+	</listitem>
+      </varlistentry>
+    </variablelist>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
index 40e58a4..c7a1c46 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-frequency.xml
@@ -98,11 +98,12 @@ the &v4l2-output; <structfield>modulator</structfield> field and the
 	    <entry>__u32</entry>
 	    <entry><structfield>type</structfield></entry>
 	    <entry>The tuner type. This is the same value as in the
-&v4l2-tuner; <structfield>type</structfield> field. See The type must be set
+&v4l2-tuner; <structfield>type</structfield> field. The type must be set
 to <constant>V4L2_TUNER_RADIO</constant> for <filename>/dev/radioX</filename>
 device nodes, and to <constant>V4L2_TUNER_ANALOG_TV</constant>
-for all others. The field is not applicable to modulators, &ie; ignored
-by drivers. See <xref linkend="v4l2-tuner-type" /></entry>
+for all others. Set this field to <constant>V4L2_TUNER_RADIO</constant> for
+modulators (currently only radio modulators are supported).
+See <xref linkend="v4l2-tuner-type" /></entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
index 95d5371..7203951 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
@@ -119,10 +119,14 @@ field is not quite clear.--></para></entry>
 <xref linkend="tuner-capability" />. Audio flags indicate the ability
 to decode audio subprograms. They will <emphasis>not</emphasis>
 change, for example with the current video standard.</para><para>When
-the structure refers to a radio tuner only the
-<constant>V4L2_TUNER_CAP_LOW</constant>,
-<constant>V4L2_TUNER_CAP_STEREO</constant> and
-<constant>V4L2_TUNER_CAP_RDS</constant> flags can be set.</para></entry>
+the structure refers to a radio tuner the
+<constant>V4L2_TUNER_CAP_LANG1</constant>,
+<constant>V4L2_TUNER_CAP_LANG2</constant> and
+<constant>V4L2_TUNER_CAP_NORM</constant> flags can't be used.</para>
+<para>If multiple frequency bands are supported, then
+<structfield>capability</structfield> is the union of all
+<structfield>capability></structfield> fields of each &v4l2-frequency-band;.
+</para></entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -130,7 +134,9 @@ the structure refers to a radio tuner only the
 	    <entry spanname="hspan">The lowest tunable frequency in
 units of 62.5 kHz, or if the <structfield>capability</structfield>
 flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz.</entry>
+Hz. If multiple frequency bands are supported, then
+<structfield>rangelow</structfield> is the lowest frequency
+of all the frequency bands.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -138,7 +144,9 @@ Hz.</entry>
 	    <entry spanname="hspan">The highest tunable frequency in
 units of 62.5 kHz, or if the <structfield>capability</structfield>
 flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
-Hz.</entry>
+Hz. If multiple frequency bands are supported, then
+<structfield>rangehigh</structfield> is the highest frequency
+of all the frequency bands.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
@@ -340,6 +348,12 @@ radio tuners.</entry>
 	<entry>0x0200</entry>
 	<entry>The RDS data is parsed by the hardware and set via controls.</entry>
 	  </row>
+	  <row>
+	<entry><constant>V4L2_TUNER_CAP_FREQ_BANDS</constant></entry>
+	<entry>0x0400</entry>
+	<entry>The &VIDIOC-ENUM-FREQ-BANDS; ioctl can be used to enumerate
+	the available frequency bands.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
1.7.10

