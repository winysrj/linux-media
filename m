Return-path: <mchehab@pedra>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:16479 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0JRM6B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Oct 2010 08:58:01 -0400
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com, hverkuil@xs4all.nl
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH v13 1/1] Documentation: v4l: Add hw_seek spacing and two TUNER_RDS_CAP flags.
Date: Mon, 18 Oct 2010 15:57:37 +0300
Message-Id: <1287406657-18859-2-git-send-email-matti.j.aaltonen@nokia.com>
In-Reply-To: <1287406657-18859-1-git-send-email-matti.j.aaltonen@nokia.com>
References: <1287406657-18859-1-git-send-email-matti.j.aaltonen@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add a couple of words about the spacing field in the HW seek struct,
also a few words about the new RDS tuner capability flags
V4L2_TUNER_CAP_RDS_BLOCK-IO and V4L2_TUNER_CAP_RDS_CONTROLS.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 Documentation/DocBook/v4l/dev-rds.xml              |   60 ++++++++++++++------
 .../DocBook/v4l/vidioc-s-hw-freq-seek.xml          |   10 +++-
 2 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/Documentation/DocBook/v4l/dev-rds.xml b/Documentation/DocBook/v4l/dev-rds.xml
index 0869d70..5498753 100644
--- a/Documentation/DocBook/v4l/dev-rds.xml
+++ b/Documentation/DocBook/v4l/dev-rds.xml
@@ -3,15 +3,16 @@
       <para>The Radio Data System transmits supplementary
 information in binary format, for example the station name or travel
 information, on an inaudible audio subcarrier of a radio program. This
-interface is aimed at devices capable of receiving and decoding RDS
+interface is aimed at devices capable of receiving and/or transmitting RDS
 information.</para>
 
       <para>For more information see the core RDS standard <xref linkend="en50067" />
 and the RBDS standard <xref linkend="nrsc4" />.</para>
 
       <para>Note that the RBDS standard as is used in the USA is almost identical
-to the RDS standard. Any RDS decoder can also handle RBDS. Only some of the fields
-have slightly different meanings. See the RBDS standard for more information.</para>
+to the RDS standard. Any RDS decoder/encoder can also handle RBDS. Only some of the
+fields have slightly different meanings. See the RBDS standard for more
+information.</para>
 
       <para>The RBDS standard also specifies support for MMBS (Modified Mobile Search).
 This is a proprietary format which seems to be discontinued. The RDS interface does not
@@ -21,16 +22,26 @@ be needed, then please contact the linux-media mailing list: &v4l-ml;.</para>
   <section>
     <title>Querying Capabilities</title>
 
-    <para>Devices supporting the RDS capturing API
-set the <constant>V4L2_CAP_RDS_CAPTURE</constant> flag in
+    <para>Devices supporting the RDS capturing API set
+the <constant>V4L2_CAP_RDS_CAPTURE</constant> flag in
 the <structfield>capabilities</structfield> field of &v4l2-capability;
-returned by the &VIDIOC-QUERYCAP; ioctl.
-Any tuner that supports RDS will set the
-<constant>V4L2_TUNER_CAP_RDS</constant> flag in the <structfield>capability</structfield>
-field of &v4l2-tuner;.
-Whether an RDS signal is present can be detected by looking at
-the <structfield>rxsubchans</structfield> field of &v4l2-tuner;: the
-<constant>V4L2_TUNER_SUB_RDS</constant> will be set if RDS data was detected.</para>
+returned by the &VIDIOC-QUERYCAP; ioctl.  Any tuner that supports RDS
+will set the <constant>V4L2_TUNER_CAP_RDS</constant> flag in
+the <structfield>capability</structfield> field of &v4l2-tuner;.  If
+the driver only passes RDS blocks without interpreting the data
+the <constant>V4L2_TUNER_SUB_RDS_BLOCK_IO</constant> flag has to be
+set, see <link linkend="reading-rds-data">Reading RDS data</link>.
+For future use the
+flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> has also been
+defined. However, a driver for a radio tuner with this capability does
+not yet exist, so if you are planning to write such a driver the best
+way to start would probably be by opening a discussion about it on
+the linux-media mailing list: &v4l-ml;. </para>
+
+    <para> Whether an RDS signal is present can be detected by looking
+at the <structfield>rxsubchans</structfield> field of &v4l2-tuner;:
+the <constant>V4L2_TUNER_SUB_RDS</constant> will be set if RDS data
+was detected.</para>
 
     <para>Devices supporting the RDS output API
 set the <constant>V4L2_CAP_RDS_OUTPUT</constant> flag in
@@ -40,16 +51,31 @@ Any modulator that supports RDS will set the
 <constant>V4L2_TUNER_CAP_RDS</constant> flag in the <structfield>capability</structfield>
 field of &v4l2-modulator;.
 In order to enable the RDS transmission one must set the <constant>V4L2_TUNER_SUB_RDS</constant>
-bit in the <structfield>txsubchans</structfield> field of &v4l2-modulator;.</para>
-
+bit in the <structfield>txsubchans</structfield> field of &v4l2-modulator;.
+If the driver only passes RDS blocks without interpreting the data
+the <constant>V4L2_TUNER_SUB_RDS_BLOCK_IO</constant> flag has to be set. If the
+tuner is capable of handling RDS entities like program identification codes and radio
+text, the flag <constant>V4L2_TUNER_SUB_RDS_CONTROLS</constant> should be set,
+see <link linkend="writing-rds-data">Writing RDS data</link> and
+<link linkend="fm-tx-controls">FM Transmitter Control Reference</link>.</para>
   </section>
 
-  <section>
+  <section  id="reading-rds-data">
     <title>Reading RDS data</title>
 
       <para>RDS data can be read from the radio device
-with the &func-read; function. The data is packed in groups of three bytes,
+with the &func-read; function. The data is packed in groups of three bytes.</para>
+  </section>
+
+  <section  id="writing-rds-data">
+    <title>Writing RDS data</title>
+
+      <para>RDS data can be written to the radio device
+with the &func-write; function. The data is packed in groups of three bytes,
 as follows:</para>
+  </section>
+
+  <section>
     <table frame="none" pgwide="1" id="v4l2-rds-data">
       <title>struct
 <structname>v4l2_rds_data</structname></title>
@@ -152,7 +178,7 @@ as follows:</para>
 	  <row>
 	    <entry>V4L2_RDS_BLOCK_ERROR</entry>
 	    <entry>0x80</entry>
-	    <entry>An incorrectable error occurred.</entry>
+	    <entry>An uncorrectable error occurred.</entry>
 	  </row>
 	</tbody>
       </tgroup>
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

