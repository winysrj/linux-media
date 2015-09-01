Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45350 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbbIAV7y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 17:59:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/13] DocBook: document SDR transmitter
Date: Wed,  2 Sep 2015 00:59:21 +0300
Message-Id: <1441144769-29211-6-git-send-email-crope@iki.fi>
In-Reply-To: <1441144769-29211-1-git-send-email-crope@iki.fi>
References: <1441144769-29211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for V4L SDR transmitter (output) devices.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/compat.xml         |  4 +++
 Documentation/DocBook/media/v4l/dev-sdr.xml        | 30 +++++++++++++++-------
 Documentation/DocBook/media/v4l/io.xml             | 10 ++++++--
 Documentation/DocBook/media/v4l/pixfmt.xml         |  2 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |  1 +
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |  2 +-
 .../DocBook/media/v4l/vidioc-querycap.xml          |  6 +++++
 7 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index eb091c7..f534fc5 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2604,6 +2604,10 @@ and &v4l2-mbus-framefmt;.
 	  <para>Added <constant>V4L2_CID_RF_TUNER_RF_GAIN</constant>
 RF Tuner control.</para>
 	</listitem>
+	<listitem>
+	  <para>Added transmitter support for Software Defined Radio (SDR)
+Interface.</para>
+	</listitem>
       </orderedlist>
     </section>
 
diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
index 3344921..a659771 100644
--- a/Documentation/DocBook/media/v4l/dev-sdr.xml
+++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
@@ -28,6 +28,16 @@ Devices supporting the SDR receiver interface set the
 <structfield>capabilities</structfield> field of &v4l2-capability;
 returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device has an
 Analog to Digital Converter (ADC), which is a mandatory element for the SDR receiver.
+    </para>
+    <para>
+Devices supporting the SDR transmitter interface set the
+<constant>V4L2_CAP_SDR_OUTPUT</constant> and
+<constant>V4L2_CAP_MODULATOR</constant> flag in the
+<structfield>capabilities</structfield> field of &v4l2-capability;
+returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device has an
+Digital to Analog Converter (DAC), which is a mandatory element for the SDR transmitter.
+    </para>
+    <para>
 At least one of the read/write, streaming or asynchronous I/O methods must
 be supported.
     </para>
@@ -39,14 +49,15 @@ be supported.
     <para>
 SDR devices can support <link linkend="control">controls</link>, and must
 support the <link linkend="tuner">tuner</link> ioctls. Tuner ioctls are used
-for setting the ADC sampling rate (sampling frequency) and the possible RF tuner
-frequency.
+for setting the ADC/DAC sampling rate (sampling frequency) and the possible
+radio frequency (RF).
     </para>
 
     <para>
-The <constant>V4L2_TUNER_SDR</constant> tuner type is used for SDR tuners, and
-the <constant>V4L2_TUNER_RF</constant> tuner type is used for RF tuners. The
-tuner index of the RF tuner (if any) must always follow the SDR tuner index.
+The <constant>V4L2_TUNER_SDR</constant> tuner type is used for setting SDR
+device ADC/DAC frequency, and the <constant>V4L2_TUNER_RF</constant>
+tuner type is used for setting radio frequency.
+The tuner index of the RF tuner (if any) must always follow the SDR tuner index.
 Normally the SDR tuner is #0 and the RF tuner is #1.
     </para>
 
@@ -59,9 +70,9 @@ The &VIDIOC-S-HW-FREQ-SEEK; ioctl is not supported.
     <title>Data Format Negotiation</title>
 
     <para>
-The SDR capture device uses the <link linkend="format">format</link> ioctls to
-select the capture format. Both the sampling resolution and the data streaming
-format are bound to that selectable format. In addition to the basic
+The SDR device uses the <link linkend="format">format</link> ioctls to
+select the capture and output format. Both the sampling resolution and the data
+streaming format are bound to that selectable format. In addition to the basic
 <link linkend="format">format</link> ioctls, the &VIDIOC-ENUM-FMT; ioctl
 must be supported as well.
     </para>
@@ -69,7 +80,8 @@ must be supported as well.
     <para>
 To use the <link linkend="format">format</link> ioctls applications set the
 <structfield>type</structfield> field of a &v4l2-format; to
-<constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant> and use the &v4l2-sdr-format;
+<constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant> or
+<constant>V4L2_BUF_TYPE_SDR_OUTPUT</constant> and use the &v4l2-sdr-format;
 <structfield>sdr</structfield> member of the <structfield>fmt</structfield>
 union as needed per the desired operation.
 Currently there is two fields, <structfield>pixelformat</structfield> and
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 7bbc2a4..da65403 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1006,8 +1006,14 @@ must set this to 0.</entry>
 	  <row>
 	    <entry><constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant></entry>
 	    <entry>11</entry>
-	    <entry>Buffer for Software Defined Radio (SDR), see <xref
-		linkend="sdr" />.</entry>
+	    <entry>Buffer for Software Defined Radio (SDR) capture stream, see
+		<xref linkend="sdr" />.</entry>
+	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_TYPE_SDR_OUTPUT</constant></entry>
+	    <entry>12</entry>
+	    <entry>Buffer for Software Defined Radio (SDR) output stream, see
+		<xref linkend="sdr" />.</entry>
 	  </row>
 	</tbody>
       </tgroup>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 965ea91..02aac95 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1623,7 +1623,7 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
   <section id="sdr-formats">
     <title>SDR Formats</title>
 
-    <para>These formats are used for <link linkend="sdr">SDR Capture</link>
+    <para>These formats are used for <link linkend="sdr">SDR</link>
 interface only.</para>
 
     &sub-sdr-cu08;
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index ab9fca4..ed870fb 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -157,6 +157,7 @@ applications. -->
 	<authorinitials>ap</authorinitials>
 	<revremark>Renamed V4L2_TUNER_ADC to V4L2_TUNER_SDR.
 Added V4L2_CID_RF_TUNER_RF_GAIN control.
+Added transmitter support for Software Defined Radio (SDR) Interface.
 	</revremark>
       </revision>
 
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
index 4fe19a7a..ffcb448 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
@@ -175,7 +175,7 @@ capture and output devices.</entry>
 	    <entry>&v4l2-sdr-format;</entry>
 	    <entry><structfield>sdr</structfield></entry>
 	    <entry>Definition of a data format, see
-<xref linkend="pixfmt" />, used by SDR capture devices.</entry>
+<xref linkend="pixfmt" />, used by SDR capture and output devices.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index 20fda75..cd82148 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -308,6 +308,12 @@ modulator programming see
 fields.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CAP_SDR_OUTPUT</constant></entry>
+	    <entry>0x00400000</entry>
+	    <entry>The device supports the
+<link linkend="sdr">SDR Output</link> interface.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CAP_READWRITE</constant></entry>
 	    <entry>0x01000000</entry>
 	    <entry>The device supports the <link
-- 
http://palosaari.fi/

