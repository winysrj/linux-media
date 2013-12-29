Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33493 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3L2EF2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 23:05:28 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v6 11/12] DocBook: Software Defined Radio Interface
Date: Sun, 29 Dec 2013 06:04:03 +0200
Message-Id: <1388289844-2766-12-git-send-email-crope@iki.fi>
In-Reply-To: <1388289844-2766-1-git-send-email-crope@iki.fi>
References: <1388289844-2766-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document V4L2 SDR interface.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 Documentation/DocBook/media/v4l/compat.xml         |  10 ++
 Documentation/DocBook/media/v4l/dev-sdr.xml        | 107 +++++++++++++++++++++
 Documentation/DocBook/media/v4l/io.xml             |   6 ++
 Documentation/DocBook/media/v4l/v4l2.xml           |   1 +
 Documentation/DocBook/media/v4l/vidioc-g-fmt.xml   |   7 ++
 .../DocBook/media/v4l/vidioc-querycap.xml          |   6 ++
 6 files changed, 137 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/dev-sdr.xml

diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
index 0c7195e..85fb864 100644
--- a/Documentation/DocBook/media/v4l/compat.xml
+++ b/Documentation/DocBook/media/v4l/compat.xml
@@ -2523,6 +2523,16 @@ that used it. It was originally scheduled for removal in 2.6.35.
       </orderedlist>
     </section>
 
+    <section>
+      <title>V4L2 in Linux 3.14</title>
+      <orderedlist>
+        <listitem>
+	  <para>Added Software Defined Radio (SDR) Interface.
+	  </para>
+        </listitem>
+      </orderedlist>
+    </section>
+
     <section id="other">
       <title>Relation of V4L2 to other Linux multimedia APIs</title>
 
diff --git a/Documentation/DocBook/media/v4l/dev-sdr.xml b/Documentation/DocBook/media/v4l/dev-sdr.xml
new file mode 100644
index 0000000..db4859f
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/dev-sdr.xml
@@ -0,0 +1,107 @@
+  <title>Software Defined Radio Interface (SDR)</title>
+
+  <para>
+SDR is an abbreviation of Software Defined Radio, the radio device
+which uses application software for modulation or demodulation. This interface
+is intended for controlling and data streaming of such devices.
+  </para>
+
+  <para>
+SDR devices are accessed through character device special files named
+<filename>/dev/swradio0</filename> to <filename>/dev/swradio255</filename>
+with major number 81 and dynamically allocated minor numbers 0 to 255.
+  </para>
+
+  <section>
+    <title>Querying Capabilities</title>
+
+    <para>
+Devices supporting the SDR receiver interface set the
+<constant>V4L2_CAP_SDR_CAPTURE</constant> and
+<constant>V4L2_CAP_TUNER</constant> flag in the
+<structfield>capabilities</structfield> field of &v4l2-capability;
+returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device has an
+Analog to Digital Converter (ADC), which is a mandatory element for the SDR receiver.
+At least one of the read/write, streaming or asynchronous I/O methods must
+be supported.
+    </para>
+  </section>
+
+  <section>
+    <title>Supplemental Functions</title>
+
+    <para>
+SDR devices can support <link linkend="control">controls</link>, and must
+support the <link linkend="tuner">tuner</link> ioctls. Tuner ioctls are used
+for setting the ADC sampling rate (sampling frequency) and the possible RF tuner
+frequency.
+    </para>
+
+    <para>
+The <constant>V4L2_TUNER_ADC</constant> tuner type is used for ADC tuners, and
+the <constant>V4L2_TUNER_RF</constant> is used for RF tuners. The tuner index
+of the RF tuner (if any) must always follow the ADC tuner index. Normally the
+ADC tuner is #0 and the RF tuner is #1.
+    </para>
+
+    <para>
+The &VIDIOC-S-HW-FREQ-SEEK; ioctl is not supported.
+    </para>
+  </section>
+
+  <section>
+    <title>Data Format Negotiation</title>
+
+    <para>
+The SDR capture device uses the <link linkend="format">format</link> ioctls to
+select the capture format. Both the sampling resolution and the data streaming
+format are bound to that selectable format. In addition to basic
+<link linkend="format">format</link> ioctls, the &VIDIOC-ENUM-FMT; ioctl
+must be supported too.
+    </para>
+
+    <para>
+To use the <link linkend="format">format</link> ioctls applications set the
+<structfield>type</structfield> field of a &v4l2-format; to
+<constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant> and use the &v4l2-format-sdr;
+<structfield>sdr</structfield> member of the <structfield>fmt</structfield>
+union as needed per the desired operation.
+Currently only the <structfield>pixelformat</structfield> field of
+&v4l2-format-sdr; is used. The content of that field is the V4L2 fourcc code
+of the data format.
+    </para>
+
+    <table pgwide="1" frame="none" id="v4l2-format-sdr">
+      <title>struct <structname>v4l2_format_sdr</structname></title>
+      <tgroup cols="3">
+        &cs-str;
+        <tbody valign="top">
+          <row>
+            <entry>__u32</entry>
+            <entry><structfield>pixelformat</structfield></entry>
+            <entry>
+The pixel format or type of compression, set by the
+application. This is a little endian
+<link linkend="v4l2-fourcc">four character code</link>. V4L2 defines
+standard RGB formats in <xref linkend="rgb-formats" />, YUV formats in
+<xref linkend="yuv-formats" />, and reserved codes in
+<xref linkend="reserved-formats" />
+           </entry>
+          </row>
+          <row>
+            <entry>__u8</entry>
+            <entry><structfield>reserved[28]</structfield></entry>
+            <entry>This array is reserved for future extensions.
+Drivers and applications must set it to zero.</entry>
+          </row>
+        </tbody>
+      </tgroup>
+    </table>
+
+    <para>
+An SDR device may support <link linkend="rw">read/write</link>
+and/or streaming (<link linkend="mmap">memory mapping</link>
+or <link linkend="userp">user pointer</link>) I/O.
+    </para>
+
+  </section>
diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
index 2c4c068..1fb11e8 100644
--- a/Documentation/DocBook/media/v4l/io.xml
+++ b/Documentation/DocBook/media/v4l/io.xml
@@ -1005,6 +1005,12 @@ should set this to 0.</entry>
 	    <entry>Buffer for video output overlay (OSD), see <xref
 		linkend="osd" />.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_BUF_TYPE_SDR_CAPTURE</constant></entry>
+	    <entry>11</entry>
+	    <entry>Buffer for Software Defined Radio (SDR), see <xref
+		linkend="sdr" />.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 8469fe1..a27fcae 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -529,6 +529,7 @@ and discussions on the V4L mailing list.</revremark>
     <section id="ttx"> &sub-dev-teletext; </section>
     <section id="radio"> &sub-dev-radio; </section>
     <section id="rds"> &sub-dev-rds; </section>
+    <section id="sdr"> &sub-dev-sdr; </section>
     <section id="event"> &sub-dev-event; </section>
     <section id="subdev"> &sub-dev-subdev; </section>
   </chapter>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
index ee8f56e..ffed137 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
@@ -172,6 +172,13 @@ capture and output devices.</entry>
 	  </row>
 	  <row>
 	    <entry></entry>
+	    <entry>&v4l2-format-sdr;</entry>
+	    <entry><structfield>sdr</structfield></entry>
+	    <entry>Definition of an data format, see
+<xref linkend="pixfmt" />, used by SDR capture devices.</entry>
+	  </row>
+	  <row>
+	    <entry></entry>
 	    <entry>__u8</entry>
 	    <entry><structfield>raw_data</structfield>[200]</entry>
 	    <entry>Place holder for future extensions.</entry>
diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
index d5a3c97..370d49d 100644
--- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
@@ -296,6 +296,12 @@ modulator programming see
 <xref linkend="tuner" />.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CAP_SDR_CAPTURE</constant></entry>
+	    <entry>0x00100000</entry>
+	    <entry>The device supports the
+<link linkend="sdr">SDR Capture</link> interface.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CAP_READWRITE</constant></entry>
 	    <entry>0x01000000</entry>
 	    <entry>The device supports the <link
-- 
1.8.4.2

