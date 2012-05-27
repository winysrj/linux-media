Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3421 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2E0Luh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 07:50:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 5/5] V4L2 spec: add frequency band documentation.
Date: Sun, 27 May 2012 13:50:25 +0200
Message-Id: <04d04591632a7db503981b27335eaad27c73d332.1338118975.git.hans.verkuil@cisco.com>
In-Reply-To: <1338119425-17274-1-git-send-email-hverkuil@xs4all.nl>
References: <1338119425-17274-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <04a877e6f6310b83c3980cd6963f52d3b9ae658f.1338118975.git.hans.verkuil@cisco.com>
References: <04a877e6f6310b83c3980cd6963f52d3b9ae658f.1338118975.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Based in part on an earlier patch from <hallimanju@gmail.com>.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/common.xml         |   28 ++++--
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |   38 +++++---
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   97 +++++++++++++++++---
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    3 +-
 4 files changed, 131 insertions(+), 35 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
index 4101aeb..4e7082d 100644
--- a/Documentation/DocBook/media/v4l/common.xml
+++ b/Documentation/DocBook/media/v4l/common.xml
@@ -464,17 +464,18 @@ The <structfield>type</structfield> field of the respective
 <structfield>tuner</structfield> field contains the index number of
 the tuner.</para>
 
-      <para>Radio devices have exactly one tuner with index zero, no
-video inputs.</para>
+      <para>Radio input devices have one or more tuners, but these are
+obviously not associated with any video inputs.</para>
 
       <para>To query and change tuner properties applications use the
 &VIDIOC-G-TUNER; and &VIDIOC-S-TUNER; ioctl, respectively. The
 &v4l2-tuner; returned by <constant>VIDIOC_G_TUNER</constant> also
 contains signal status information applicable when the tuner of the
-current video input, or a radio tuner is queried. Note that
+current video input or a radio tuner is queried. Note that
 <constant>VIDIOC_S_TUNER</constant> does not switch the current tuner,
 when there is more than one at all. The tuner is solely determined by
-the current video input. Drivers must support both ioctls and set the
+the current video input or by calling &VIDIOC-S-FREQUENCY; for radio
+tuners. Drivers must support both ioctls and set the
 <constant>V4L2_CAP_TUNER</constant> flag in the &v4l2-capability;
 returned by the &VIDIOC-QUERYCAP; ioctl when the device has one or
 more tuners.</para>
@@ -491,14 +492,24 @@ the modulator. The <structfield>type</structfield> field of the
 respective &v4l2-output; returned by the &VIDIOC-ENUMOUTPUT; ioctl is
 set to <constant>V4L2_OUTPUT_TYPE_MODULATOR</constant> and its
 <structfield>modulator</structfield> field contains the index number
-of the modulator. This specification does not define radio output
-devices.</para>
+of the modulator.</para>
+
+      <para>Radio output devices have one or more modulators, but these
+are obviously not associated with any video outputs.</para>
+
+      <para>A video or radio device cannot support both a tuner and a
+modulator. Two separate device nodes will have to be used for such
+hardware, one that supports the tuner functionality and one that supports
+the modulator functionality. The reason is a limitation with the
+&VIDIOC-S-FREQUENCY; ioctl where you cannot specify whether the frequency
+is for a tuner or a modulator.</para>
 
       <para>To query and change modulator properties applications use
 the &VIDIOC-G-MODULATOR; and &VIDIOC-S-MODULATOR; ioctl. Note that
 <constant>VIDIOC_S_MODULATOR</constant> does not switch the current
 modulator, when there is more than one at all. The modulator is solely
-determined by the current video output. Drivers must support both
+determined by the current video output or by calling &VIDIOC-S-FREQUENCY;
+for radio modulators. Drivers must support both
 ioctls and set the <constant>V4L2_CAP_MODULATOR</constant> flag in
 the &v4l2-capability; returned by the &VIDIOC-QUERYCAP; ioctl when the
 device has one or more modulators.</para>
@@ -511,8 +522,7 @@ device has one or more modulators.</para>
 applications use the &VIDIOC-G-FREQUENCY; and &VIDIOC-S-FREQUENCY;
 ioctl which both take a pointer to a &v4l2-frequency;. These ioctls
 are used for TV and radio devices alike. Drivers must support both
-ioctls when the tuner or modulator ioctls are supported, or
-when the device is a radio device.</para>
+ioctls when the tuner or modulator ioctls are supported.</para>
     </section>
   </section>
 
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
index 7f4ac7e..713ba06 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-modulator.xml
@@ -68,17 +68,17 @@ to this structure. Drivers fill the rest of the structure or return an
 applications shall begin at index zero, incrementing by one until the
 driver returns <errorcode>EINVAL</errorcode>.</para>
 
-    <para>Modulators have two writable properties, an audio
-modulation set and the radio frequency. To change the modulated audio
-subprograms, applications initialize the <structfield>index
-</structfield> and <structfield>txsubchans</structfield> fields and the
-<structfield>reserved</structfield> array and call the
-<constant>VIDIOC_S_MODULATOR</constant> ioctl. Drivers may choose a
-different audio modulation if the request cannot be satisfied. However
-this is a write-only ioctl, it does not return the actual audio
+    <para>Modulators have three writable properties, an audio
+modulation set, the frequency band and the radio frequency. To change the
+modulated audio subprograms or frequency band, applications initialize the
+<structfield>index</structfield>, <structfield>band</structfield>,
+<structfield>txsubchans</structfield> and <structfield>reserved</structfield>
+fields and call the <constant>VIDIOC_S_MODULATOR</constant> ioctl. Drivers
+may choose a different audio modulation if the request cannot be satisfied.
+However this is a write-only ioctl, it does not return the actual audio
 modulation selected.</para>
 
-    <para>To change the radio frequency the &VIDIOC-S-FREQUENCY; ioctl
+    <para>To change the frequency the &VIDIOC-S-FREQUENCY; ioctl
 is available.</para>
 
     <table pgwide="1" frame="none" id="v4l2-modulator">
@@ -110,16 +110,16 @@ change for example with the current video standard.</entry>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>rangelow</structfield></entry>
-	    <entry>The lowest tunable frequency in units of 62.5
-KHz, or if the <structfield>capability</structfield> flag
+	    <entry>The lowest tunable frequency of the current frequency band
+in units of 62.5 kHz, or if the <structfield>capability</structfield> flag
 <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
 Hz.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>rangehigh</structfield></entry>
-	    <entry>The highest tunable frequency in units of 62.5
-KHz, or if the <structfield>capability</structfield> flag
+	    <entry>The highest tunable frequency of the current frequency band
+in units of 62.5 kHz, or if the <structfield>capability</structfield> flag
 <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
 Hz.</entry>
 	  </row>
@@ -138,7 +138,17 @@ indicator, for example a stereo pilot tone.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[4]</entry>
+	    <entry><structfield>band</structfield></entry>
+	    <entry spanname="hspan">The frequency band. The available bands are
+	    defined in the <structfield>capability</structfield> field. The band
+	    <constant>V4L2_TUNER_BAND_DEFAULT</constant> is always available. After changing
+	    the band the current frequency will be clamped to the new frequency range.
+	    See <xref linkend="radio-bands" /> for valid band values.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[3]</entry>
 	    <entry>Reserved for future extensions. Drivers and
 applications must set the array to zero.</entry>
 	  </row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
index 95d5371..27a8916 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-tuner.xml
@@ -68,10 +68,10 @@ structure. Drivers fill the rest of the structure or return an
 applications shall begin at index zero, incrementing by one until the
 driver returns <errorcode>EINVAL</errorcode>.</para>
 
-    <para>Tuners have two writable properties, the audio mode and
-the radio frequency. To change the audio mode, applications initialize
-the <structfield>index</structfield>,
-<structfield>audmode</structfield> and
+    <para>Tuners have three writable properties, the audio mode, the frequency
+band and the radio frequency. To change the audio mode and band, applications
+initialize the <structfield>index</structfield>,
+<structfield>audmode</structfield>, <structfield>band</structfield> and
 <structfield>reserved</structfield> fields and call the
 <constant>VIDIOC_S_TUNER</constant> ioctl. This will
 <emphasis>not</emphasis> change the current tuner, which is determined
@@ -80,7 +80,7 @@ if the requested mode is invalid or unsupported. Since this is a
 <!-- FIXME -->write-only ioctl, it does not return the actually
 selected audio mode.</para>
 
-    <para>To change the radio frequency the &VIDIOC-S-FREQUENCY; ioctl
+    <para>To change the frequency the &VIDIOC-S-FREQUENCY; ioctl
 is available.</para>
 
     <table pgwide="1" frame="none" id="v4l2-tuner">
@@ -127,16 +127,16 @@ the structure refers to a radio tuner only the
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>rangelow</structfield></entry>
-	    <entry spanname="hspan">The lowest tunable frequency in
-units of 62.5 kHz, or if the <structfield>capability</structfield>
+	    <entry spanname="hspan">The lowest tunable frequency of the current
+frequency band in units of 62.5 kHz, or if the <structfield>capability</structfield>
 flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
 Hz.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
 	    <entry><structfield>rangehigh</structfield></entry>
-	    <entry spanname="hspan">The highest tunable frequency in
-units of 62.5 kHz, or if the <structfield>capability</structfield>
+	    <entry spanname="hspan">The highest tunable frequency of the current
+frequency band in units of 62.5 kHz, or if the <structfield>capability</structfield>
 flag <constant>V4L2_TUNER_CAP_LOW</constant> is set, in units of 62.5
 Hz.</entry>
 	  </row>
@@ -226,7 +226,17 @@ settles at zero, &ie; range is what? --></entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[4]</entry>
+	    <entry><structfield>band</structfield></entry>
+	    <entry spanname="hspan">The frequency band. The available bands are
+	    defined in the <structfield>capability</structfield> field. The band
+	    <constant>V4L2_TUNER_BAND_DEFAULT</constant> is always available. After changing
+	    the band the current frequency will be clamped to the new frequency range.
+	    See <xref linkend="radio-bands" /> for valid band values.
+	    </entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[3]</entry>
 	    <entry spanname="hspan">Reserved for future extensions. Drivers and
 applications must set the array to zero.</entry>
 	  </row>
@@ -340,6 +350,31 @@ radio tuners.</entry>
 	<entry>0x0200</entry>
 	<entry>The RDS data is parsed by the hardware and set via controls.</entry>
 	  </row>
+	  <row>
+	<entry><constant>V4L2_TUNER_CAP_BAND_FM_EUROPE_US</constant></entry>
+	<entry>0x010000</entry>
+	<entry>FM radio European or US band (87.5 Mhz - 108 MHz, exact range is hardware dependent).</entry>
+	  </row>
+	  <row>
+	<entry><constant>V4L2_TUNER_CAP_BAND_FM_JAPAN</constant></entry>
+	<entry>0x020000</entry>
+	<entry>FM radio Japan band (76 MHz - 90 MHz, exact range is hardware dependent).</entry>
+	  </row>
+	  <row>
+	<entry><constant>V4L2_TUNER_CAP_BAND_FM_RUSSIAN</constant></entry>
+	<entry>0x040000</entry>
+	<entry>FM radio OIRT or Russian band (65.8 MHz - 74 MHz, exact range is hardware dependent).</entry>
+	  </row>
+	  <row>
+	<entry><constant>V4L2_TUNER_CAP_BAND_FM_WEATHER</constant></entry>
+	<entry>0x080000</entry>
+	<entry>FM radio weather band (162.4 MHz - 162.55 MHz, exact range is hardware dependent).</entry>
+	  </row>
+	  <row>
+	<entry><constant>V4L2_TUNER_CAP_BAND_AM_MW</constant></entry>
+	<entry>0x100000</entry>
+	<entry>AM radio medium wave band (520 kHz - 1710 kHz, exact range is hardware dependent).</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -532,6 +567,39 @@ Lang1/Lang1</entry>
       </tgroup>
     </table>
   </refsect1>
+    <table pgwide="1" frame="none" id="radio-bands">
+      <title>Radio Band Types</title>
+      <tgroup cols="2">
+	&cs-str;
+	<tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_TUNER_BAND_DEFAULT</constant>&nbsp;</entry>
+		      <entry>This is the default band, which should be the widest frequency range supported by
+		      the hardware. This band is always available.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_TUNER_BAND_FM_EUROPE_US</constant>&nbsp;</entry>
+		      <entry>FM radio European or US band (87.5 Mhz - 108 MHz, exact range is hardware dependent).</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_TUNER_BAND_FM_JAPAN</constant>&nbsp;</entry>
+		      <entry>FM radio Japan band (76 MHz - 90 MHz, exact range is hardware dependent).</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_TUNER_BAND_FM_RUSSIAN</constant>&nbsp;</entry>
+		      <entry>FM radio OIRT or Russian band (65.8 MHz - 74 MHz, exact range is hardware dependent).</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_TUNER_BAND_FM_WEATHER</constant>&nbsp;</entry>
+		      <entry>FM radio weather band (162.4 MHz - 162.55 MHz, exact range is hardware dependent).</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_TUNER_BAND_AM_MW</constant>&nbsp;</entry>
+		      <entry>AM radio medium wave band (520 kHz - 1710 kHz, exact range is hardware dependent).</entry>
+		    </row>
+	</tbody>
+      </tgroup>
+    </table>
 
   <refsect1>
     &return-value;
@@ -541,7 +609,14 @@ Lang1/Lang1</entry>
 	<term><errorcode>EINVAL</errorcode></term>
 	<listitem>
 	  <para>The &v4l2-tuner; <structfield>index</structfield> is
-out of bounds.</para>
+out of bounds or the <structfield>band</structfield> is invalid.</para>
+	</listitem>
+      </varlistentry>
+      <varlistentry>
+	<term><errorcode>EBUSY</errorcode></term>
+	<listitem>
+	  <para>An attempt was made to change the frequency band while a hardware
+frequency seek was in progress.</para>
 	</listitem>
       </varlistentry>
     </variablelist>
diff --git a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
index d58b648..d893d67 100644
--- a/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-s-hw-freq-seek.xml
@@ -49,7 +49,8 @@
   <refsect1>
     <title>Description</title>
 
-    <para>Start a hardware frequency seek from the current frequency.
+    <para>Start a hardware frequency seek from the current frequency covering
+the current frequency band.
 To do this applications initialize the <structfield>tuner</structfield>,
 <structfield>type</structfield>, <structfield>seek_upward</structfield>,
 <structfield>spacing</structfield> and
-- 
1.7.10

