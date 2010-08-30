Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.105.134]:57342 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab0H3Liz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Aug 2010 07:38:55 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	eduardo.valentin@nokia.com, mchehab@redhat.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v9 4/4] Documentation: v4l: Add hw_seek spacing and FM_RX class
Date: Mon, 30 Aug 2010 14:38:22 +0300
Message-Id: <1283168302-19111-5-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1283168302-19111-4-git-send-email-matti.j.aaltonen@nokia.com>
References: <1283168302-19111-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1283168302-19111-2-git-send-email-matti.j.aaltonen@nokia.com>
 <1283168302-19111-3-git-send-email-matti.j.aaltonen@nokia.com>
 <1283168302-19111-4-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Add a couple of words about the spacing field in the HW seek struct,
about the V4L2_CAP_RAW_RDS_ONLY capability flag and about the
new FM RX control class.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 Documentation/DocBook/v4l/controls.xml             |   71 ++++++++++++++++++++
 Documentation/DocBook/v4l/dev-rds.xml              |    5 ++
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 ++-
 3 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/v4l/controls.xml b/Documentation/DocBook/v4l/controls.xml
index 8408caa..e9512eb 100644
--- a/Documentation/DocBook/v4l/controls.xml
+++ b/Documentation/DocBook/v4l/controls.xml
@@ -2088,6 +2088,77 @@ manually or automatically if set to zero. Unit, range and step are driver-specif
 <para>For more details about RDS specification, refer to
 <xref linkend="en50067" /> document, from CENELEC.</para>
     </section>
+    <section id="fm-rx-controls">
+      <title>FM Tuner Control Reference</title>
+
+      <para>The FM Tuner (FM_RX) class includes controls for common features of
+devices that are capable of receiving FM transmissions. Currently this class includes a parameter
+defining the FM radio band being used.</para>
+
+      <table pgwide="1" frame="none" id="fm-rx-control-id">
+      <title>FM_RX Control IDs</title>
+
+      <tgroup cols="4">
+	<colspec colname="c1" colwidth="1*" />
+	<colspec colname="c2" colwidth="6*" />
+	<colspec colname="c3" colwidth="2*" />
+	<colspec colname="c4" colwidth="6*" />
+	<spanspec namest="c1" nameend="c2" spanname="id" />
+	<spanspec namest="c2" nameend="c4" spanname="descr" />
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
+	    <entry spanname="id"><constant>V4L2_CID_FM_RX_CLASS</constant>&nbsp;</entry>
+	    <entry>class</entry>
+	  </row><row><entry spanname="descr">The FM_RX class
+descriptor. Calling &VIDIOC-QUERYCTRL; for this control will return a
+description of this control class.</entry>
+	  </row>
+	  <row>
+	    <entry spanname="id"><constant>V4L2_CID_FM_RX_BAND</constant>&nbsp;</entry>
+	    <entry>integer</entry>
+	  </row>
+	  <row id="v4l2-fm_rx_band"><entry spanname="descr">Configures the FM radio
+frequency range being used. Currently there are three bands in use, see  <ulink
+url="http://en.wikipedia.org/wiki/FM_broadcasting">Wikipedia</ulink>.
+Usually 87.5 to 108.0 MHz is used, or some portion thereof, with a few exceptions:
+In Japan, the band 76-90 MHz is used and in the former Soviet republics
+and some Eastern European countries, the older 65-74 MHz band,
+referred also to as the OIRT band, is still used.
+
+The enum&nbsp; v4l2_fm_rx_band defines possible values for the FM band. They are:</entry>
+	</row><row>
+	<entrytbl spanname="descr" cols="2">
+		  <tbody valign="top">
+		    <row>
+		      <entry><constant>V4L2_FM_BAND_OTHER</constant>&nbsp;</entry>
+		      <entry>Frequencies from 87.5 to 108.0 MHz</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_FM_BAND_JAPAN</constant>&nbsp;</entry>
+		      <entry>from 65 to 74 MHz</entry>
+		    </row>
+		    <row>
+		      <entry><constant>V4L2_FM_BAND_OIRT</constant>&nbsp;</entry>
+		      <entry>from 65 to 74 MHz</entry>
+		    </row>
+		  </tbody>
+		</entrytbl>
+
+	  </row>
+	  <row><entry></entry></row>
+	</tbody>
+      </tgroup>
+      </table>
+
+    </section>
 </section>
 
   <!--
diff --git a/Documentation/DocBook/v4l/dev-rds.xml b/Documentation/DocBook/v4l/dev-rds.xml
index 0869d70..39c89c2 100644
--- a/Documentation/DocBook/v4l/dev-rds.xml
+++ b/Documentation/DocBook/v4l/dev-rds.xml
@@ -42,6 +42,11 @@ field of &v4l2-modulator;.
 In order to enable the RDS transmission one must set the <constant>V4L2_TUNER_SUB_RDS</constant>
 bit in the <structfield>txsubchans</structfield> field of &v4l2-modulator;.</para>
 
+    <para>Devices capable of only passing through raw uninterpreted RDS data
+set the flags as described above and in addition
+set the <constant>V4L2_CAP_RAW_RDS_ONLY</constant> flag in
+the <structfield>capabilities</structfield> field of &v4l2-capability;
+returned by the &VIDIOC-QUERYCAP; ioctl.</para>
   </section>
 
   <section>
diff --git a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
index 14b3ec7..c30dcc4 100644
--- a/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
+++ b/Documentation/DocBook/v4l/vidioc-s-hw-freq-seek.xml
@@ -51,7 +51,8 @@
 
     <para>Start a hardware frequency seek from the current frequency.
 To do this applications initialize the <structfield>tuner</structfield>,
-<structfield>type</structfield>, <structfield>seek_upward</structfield> and
+<structfield>type</structfield>, <structfield>seek_upward</structfield>,
+<structfield>spacing</structfield> and
 <structfield>wrap_around</structfield> fields, and zero out the
 <structfield>reserved</structfield> array of a &v4l2-hw-freq-seek; and
 call the <constant>VIDIOC_S_HW_FREQ_SEEK</constant> ioctl with a pointer
@@ -89,7 +90,12 @@ field and the &v4l2-tuner; <structfield>index</structfield> field.</entry>
 	  </row>
 	  <row>
 	    <entry>__u32</entry>
-	    <entry><structfield>reserved</structfield>[8]</entry>
+	    <entry><structfield>spacing</structfield></entry>
+	    <entry>If non-zero, defines the hardware seek resolution in Hz. The driver selects the nearest value that is supported by the device. If spacing is zero a reasonable default value is used.</entry>
+	  </row>
+	  <row>
+	    <entry>__u32</entry>
+	    <entry><structfield>reserved</structfield>[7]</entry>
 	    <entry>Reserved for future extensions. Drivers and
 	    applications must set the array to zero.</entry>
 	  </row>
-- 
1.6.1.3

