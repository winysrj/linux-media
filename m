Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:18004 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023AbZHHLXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Aug 2009 07:23:23 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "ext Hans Verkuil" <hverkuil@xs4all.nl>,
	"ext Mauro Carvalho Chehab" <mchehab@infradead.org>
Cc: "ext Douglas Schilling Landgraf" <dougsland@gmail.com>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv15 4/8] v4l2-spec: Add documentation description for FM TX extended control class
Date: Sat,  8 Aug 2009 14:10:29 +0300
Message-Id: <1249729833-24975-5-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1249729833-24975-4-git-send-email-eduardo.valentin@nokia.com>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-4-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This single patch adds documentation description for FM Modulator (FM TX)
Extended Control Class and its Control IDs. The text was added under
"Extended Controls" section. The vidioc-g-ext-ctrls.sgml file was
updated as well.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 v4l2-spec/Makefile                |    1 +
 v4l2-spec/controls.sgml           |  215 +++++++++++++++++++++++++++++++++++++
 v4l2-spec/vidioc-g-ext-ctrls.sgml |    7 ++
 3 files changed, 223 insertions(+), 0 deletions(-)

diff --git a/v4l2-spec/Makefile b/v4l2-spec/Makefile
index 4f11745..7a8d161 100644
--- a/v4l2-spec/Makefile
+++ b/v4l2-spec/Makefile
@@ -243,6 +243,7 @@ ENUMS = \
 	v4l2_power_line_frequency \
 	v4l2_priority \
 	v4l2_tuner_type \
+	v4l2_preemphasis \
 
 STRUCTS = \
 	v4l2_audio \
diff --git a/v4l2-spec/controls.sgml b/v4l2-spec/controls.sgml
index 8e0e024..1e45b4b 100644
--- a/v4l2-spec/controls.sgml
+++ b/v4l2-spec/controls.sgml
@@ -458,6 +458,12 @@ video is actually encoded into that format.</para>
       <para>Unfortunately, the original control API lacked some
 features needed for these new uses and so it was extended into the
 (not terribly originally named) extended control API.</para>
+
+      <para>Even though the MPEG encoding API was the first effort
+to use the Extended Control API, nowadays there are also other classes
+of Extended Controls, such as Camera Controls and FM Transmitter Controls.
+The Extended Controls API as well as all Extended Controls classes are
+described in the following text.</para>
     </section>
 
     <section>
@@ -1815,6 +1821,215 @@ control must support read access and may support write access.</entry>
       </tgroup>
     </table>
   </section>
+
+    <section id="fm-tx-controls">
+      <title>FM Transmitter Control Reference</title>
+
+      <para>The FM Transmitter (FM_TX) class includes controls for common features of
+FM transmissions capable devices. Currently this class includes parameters for audio
+compression, pilot tone generation, audio deviation limiter, RDS transmission and
+tuning power features.</para>
+
+      <table pgwide="1" frame="none" id="fm-tx-control-id">
+      <title>FM_TX Control IDs</title>
+
+      <tgroup cols="4">
+	<colspec colname="c1" colwidth="1*">
+	<colspec colname="c2" colwidth="6*">
+	<colspec colname="c3" colwidth="2*">
+	<colspec colname="c4" colwidth="6*">
+	<spanspec namest="c1" nameend="c2" spanname="id">
+	<spanspec namest="c2" nameend="c4" spanname="descr">
+	<thead>
+	  <row>
+	    <entry spanname="id" align="left">ID</entry>
+	    <entry align="left">Type</entry>
+	  </row><row rowsep="1"><entry spanname="descr" align="left">Description</entry>
+	  </row>
+	</thead>
+	<tbody valign="top">
+	  <row><entry></entry></row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FM_TX_CLASS</constant>&nbsp;</entry>
+	    <entry>class</entry>
+	  </row><row><entry spanname="descr">The FM_TX class
+descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
+description of this control class.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_DEVIATION</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Configures RDS signal frequency deviation level in Hz.
+The range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_PI</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the RDS Programme Identification field
+for transmission.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_PTY</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the RDS Programme Type field for transmission.
+This encodes up to 31 pre-defined programme types.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_PS_NAME</constant>&nbsp;</entry>
+	    <entry>string</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the Programme Service name (PS_NAME) for transmission.
+It is intended for static display on a receiver. It is the primary aid to listeners in programme service
+identification and selection.  In Annex E of <xref linkend="en50067">, the RDS specification,
+there is a full description of the correct character encoding for Programme Service name strings.
+Also from RDS specification, PS is usually a single eight character text. However, it is also possible
+to find receivers which can scroll strings sized as 8 x N characters. So, this control must be configured
+with steps of 8 characters. The result is it must always contain a string with size multiple of 8.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_RDS_TX_RADIO_TEXT</constant>&nbsp;</entry>
+	    <entry>string</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the Radio Text info for transmission. It is a textual description of
+what is being broadcasted. RDS Radio Text can be applied when broadcaster wishes to transmit longer PS names,
+programme-related information or any other text. In these cases, RadioText should be used in addition to
+<constant>V4L2_CID_RDS_TX_PS_NAME</constant>. The encoding for Radio Text strings is also fully described
+in Annex E of <xref linkend="en50067">. The length of Radio Text strings depends on which RDS Block is being
+used to transmit it, either 32 (2A block) or 64 (2B block).  However, it is also possible
+to find receivers which can scroll strings sized as 32 x N or 64 x N characters. So, this control must be configured
+with steps of 32 or 64 characters. The result is it must always contain a string with size multiple of 32 or 64. </entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_ENABLED</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">Enables or disables the audio deviation limiter feature.
+The limiter is useful when trying to maximize the audio volume, minimize receiver-generated
+distortion and prevent overmodulation.
+</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_RELEASE_TIME</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the audio deviation limiter feature release time.
+Unit is in useconds. Step and range are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUDIO_LIMITER_DEVIATION</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Configures audio frequency deviation level in Hz.
+The range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_ENABLED</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">Enables or disables the audio compression feature.
+This feature amplifies signals below the threshold by a fixed gain and compresses audio
+signals above the threshold by the ratio of Threshold/(Gain + Threshold).</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_GAIN</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the gain for audio compression feature. It is
+a dB value. The range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_THRESHOLD</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the threshold level for audio compression freature.
+It is a dB value. The range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_ATTACK_TIME</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the attack time for audio compression feature.
+It is a useconds value. The range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_AUDIO_COMPRESSION_RELEASE_TIME</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the release time for audio compression feature.
+It is a useconds value. The range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_PILOT_TONE_ENABLED</constant>&nbsp;</entry>
+	    <entry>boolean</entry>
+	  </row>
+	  <row><entry spanname="descr">Enables or disables the pilot tone generation feature.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_PILOT_TONE_DEVIATION</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Configures pilot tone frequency deviation level. Unit is
+in Hz. The range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_PILOT_TONE_FREQUENCY</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Configures pilot tone frequency value. Unit is
+in Hz. The range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FM_TX_PREEMPHASIS</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row id="v4l2-preemphasis"><entry spanname="descr">Configures the pre-emphasis value for broadcasting.
+A pre-emphasis filter is applied to the broadcast to accentuate the high audio frequencies.
+Depending on the region, a time constant of either 50 or 75 useconds is used. The enum&nbsp;v4l2_preemphasis
+defines possible values for pre-emphasis. Here they are:</entry>
+	</row><row>
+	<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_DISABLED</constant>&nbsp;</entry>
+		      <entry>No pre-emphasis is applied.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_50_uS</constant>&nbsp;</entry>
+		      <entry>A pre-emphasis of 50 uS is used.</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_PREEMPHASIS_75_uS</constant>&nbsp;</entry>
+		      <entry>A pre-emphasis of 75 uS is used.</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_TUNE_POWER_LEVEL</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">Sets the output power level for signal transmission.
+Unit is in dBuV. Range and step are driver-specific.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_TUNE_ANTENNA_CAPACITOR</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row><entry spanname="descr">This selects the value of antenna tuning capacitor
+manually or automatically if set to zero. Unit, range and step are driver-specific.</entry>
+	  </row>
+	  <row><entry></entry></row>
+	</tbody>
+      </tgroup>
+      </table>
+
+<para>For more details about RDS specification, refer to
+<xref linkend="en50067"> document, from CENELEC.</para>
+    </section>
 </section>
 
   <!--
diff --git a/v4l2-spec/vidioc-g-ext-ctrls.sgml b/v4l2-spec/vidioc-g-ext-ctrls.sgml
index 44a8f55..352f24c 100644
--- a/v4l2-spec/vidioc-g-ext-ctrls.sgml
+++ b/v4l2-spec/vidioc-g-ext-ctrls.sgml
@@ -243,6 +243,13 @@ These controls are described in <xref
 These controls are described in <xref
 		linkend="camera-controls">.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_CLASS_FM_TX</constant></entry>
+	    <entry>0x9b0000</entry>
+	    <entry>The class containing FM Transmitter (FM TX) controls.
+These controls are described in <xref
+		linkend="fm-tx-controls">.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
-- 
1.6.2.GIT

