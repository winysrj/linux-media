Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3842 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2E1Kq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 06:46:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 5/6] V4L2 spec: add frequency band documentation.
Date: Mon, 28 May 2012 12:46:44 +0200
Message-Id: <eda704c39f9927ce7e099bdab9d8538efcc3fcb9.1338201853.git.hans.verkuil@cisco.com>
In-Reply-To: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
References: <1338202005-10208-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <e874de9bb774639e0ea58054862853b9703dc2aa.1338201853.git.hans.verkuil@cisco.com>
References: <e874de9bb774639e0ea58054862853b9703dc2aa.1338201853.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Based in part on an earlier patch from <hallimanju@gmail.com>.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/vidioc-g-modulator.xml       |   38 +++++---
 Documentation/DocBook/media/v4l/vidioc-g-tuner.xml |   97 +++++++++++++++++---
 .../DocBook/media/v4l/vidioc-s-hw-freq-seek.xml    |    3 +-
 3 files changed, 112 insertions(+), 26 deletions(-)

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
index f4db44d..0d684d4 100644
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

