Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:33566 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752589AbcF3Rqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 13:46:49 -0400
From: Nick Dyer <nick@shmanahar.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	jon.older@itdev.co.uk, nick.dyer@itdev.co.uk,
	Nick Dyer <nick@shmanahar.org>
Subject: [PATCH v6 03/11] [media] DocBook: add support for touch devices
Date: Thu, 30 Jun 2016 18:38:46 +0100
Message-Id: <1467308334-12580-4-git-send-email-nick@shmanahar.org>
In-Reply-To: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
References: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Nick Dyer <nick@shmanahar.org>
---
 Documentation/DocBook/media/v4l/dev-touch.xml      | 51 ++++++++++++++
 Documentation/DocBook/media/v4l/media-types.xml    |  5 ++
 .../DocBook/media/v4l/pixfmt-tch-td08.xml          | 66 +++++++++++++++++
 .../DocBook/media/v4l/pixfmt-tch-td16.xml          | 82 ++++++++++++++++++++++
 .../DocBook/media/v4l/pixfmt-tch-tu08.xml          | 66 +++++++++++++++++
 .../DocBook/media/v4l/pixfmt-tch-tu16.xml          | 81 +++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         | 13 ++++
 Documentation/DocBook/media/v4l/v4l2.xml           |  1 +
 8 files changed, 365 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/dev-touch.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-tch-td08.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-tch-td16.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-tch-tu08.xml
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-tch-tu16.xml

diff --git a/Documentation/DocBook/media/v4l/dev-touch.xml b/Documentation/DocBook/media/v4l/dev-touch.xml
new file mode 100644
index 0000000..85d492a
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/dev-touch.xml
@@ -0,0 +1,51 @@
+<title>Touch Devices</title>
+
+<para>Touch devices are accessed through character device special files
+  named <filename>/dev/v4l-touch0</filename> to
+  <filename>/dev/v4l-touch255</filename> with major number 81 and
+  dynamically allocated minor numbers 0 to 255.</para>
+
+<section>
+  <title>Overview</title>
+
+  <para>Sensors may be Optical, or Projected Capacitive touch (PCT).</para>
+
+  <para>Processing is required to analyse the raw data and produce input
+    events. In some systems, this may be performed on the ASIC and the raw data
+    is purely a side-channel for diagnostics or tuning. In other systems, the
+    ASIC is a simple analogue front end device which delivers touch data at
+    high rate, and any touch processing must be done on the host.</para>
+
+  <para>For capacitive touch sensing, the touchscreen is composed of an array
+    of horizontal and vertical conductors (alternatively called rows/columns,
+    X/Y lines, or tx/rx). Mutual Capacitance measured is at the nodes where the
+    conductors cross. Alternatively, Self Capacitance measures the signal from
+    each column and row independently.</para>
+
+  <para>A touch input may be determined by comparing the raw capacitance
+    measurement to a no-touch reference (or "baseline") measurement:</para>
+
+  <para>Delta = Raw - Reference</para>
+
+  <para>The reference measurement takes account of variations in the
+    capacitance across the touch sensor matrix, for example
+    manufacturing irregularities, environmental or edge effects.</para>
+</section>
+
+<section>
+  <title>Querying Capabilities</title>
+
+  <para>Devices supporting the touch interface set the
+    <constant>V4L2_CAP_VIDEO_CAPTURE</constant> flag in the
+    <structfield>capabilities</structfield> field of &v4l2-capability;
+    returned by the &VIDIOC-QUERYCAP; ioctl.</para>
+
+  <para>At least one of the read/write or streaming I/O methods must be
+    supported.</para>
+</section>
+
+<section>
+  <title>Data Format Negotiation</title>
+
+  <para>A touch device may support any I/O method.</para>
+</section>
diff --git a/Documentation/DocBook/media/v4l/media-types.xml b/Documentation/DocBook/media/v4l/media-types.xml
index 5e3f20f..fb957c7 100644
--- a/Documentation/DocBook/media/v4l/media-types.xml
+++ b/Documentation/DocBook/media/v4l/media-types.xml
@@ -202,6 +202,11 @@
 	    <entry>typically, /dev/swradio?</entry>
 	  </row>
 	  <row>
+	    <entry><constant>MEDIA_INTF_T_V4L_TOUCH</constant></entry>
+	    <entry>Device node interface for Touch device (V4L)</entry>
+	    <entry>typically, /dev/v4l-touch?</entry>
+	  </row>
+	  <row>
 	    <entry><constant>MEDIA_INTF_T_ALSA_PCM_CAPTURE</constant></entry>
 	    <entry>Device node interface for ALSA PCM Capture</entry>
 	    <entry>typically, /dev/snd/pcmC?D?c</entry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-tch-td08.xml b/Documentation/DocBook/media/v4l/pixfmt-tch-td08.xml
new file mode 100644
index 0000000..2483eb0
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-tch-td08.xml
@@ -0,0 +1,66 @@
+<refentry id="V4L2-TCH-FMT-DELTA-TD08">
+  <refmeta>
+    <refentrytitle>V4L2_TCH_FMT_DELTA_TD08 ('TD08')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_TCH_FMT_DELTA_TD08</constant></refname>
+    <refpurpose>8-bit signed Touch Delta</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This format represents delta data from a touch controller</para>
+
+    <para>Delta values may range from -128 to 127. Typically the values
+      will vary through a small range depending on whether the sensor is
+      touched or not. The full value may be seen if one of the
+      touchscreen nodes has a fault or the line is not connected.</para>
+
+    <example>
+      <title><constant>V4L2_TCH_FMT_DELTA_TD08</constant> 4 &times; 4
+        node matrix</title>
+
+      <formalpara>
+        <title>Byte Order.</title>
+        <para>Each cell is one byte.
+          <informaltable frame="none">
+            <tgroup cols="5" align="center">
+              <colspec align="left" colwidth="2*" />
+              <tbody valign="top">
+                <row>
+                  <entry>start&nbsp;+&nbsp;0:</entry>
+                  <entry>D'<subscript>00</subscript></entry>
+                  <entry>D'<subscript>01</subscript></entry>
+                  <entry>D'<subscript>02</subscript></entry>
+                  <entry>D'<subscript>03</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;4:</entry>
+                  <entry>D'<subscript>10</subscript></entry>
+                  <entry>D'<subscript>11</subscript></entry>
+                  <entry>D'<subscript>12</subscript></entry>
+                  <entry>D'<subscript>13</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;8:</entry>
+                  <entry>D'<subscript>20</subscript></entry>
+                  <entry>D'<subscript>21</subscript></entry>
+                  <entry>D'<subscript>22</subscript></entry>
+                  <entry>D'<subscript>23</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;12:</entry>
+                  <entry>D'<subscript>30</subscript></entry>
+                  <entry>D'<subscript>31</subscript></entry>
+                  <entry>D'<subscript>32</subscript></entry>
+                  <entry>D'<subscript>33</subscript></entry>
+                </row>
+              </tbody>
+            </tgroup>
+          </informaltable>
+        </para>
+      </formalpara>
+    </example>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-tch-td16.xml b/Documentation/DocBook/media/v4l/pixfmt-tch-td16.xml
new file mode 100644
index 0000000..72f6245
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-tch-td16.xml
@@ -0,0 +1,82 @@
+<refentry id="V4L2-TCH-FMT-DELTA-TD16">
+  <refmeta>
+    <refentrytitle>V4L2_TCH_FMT_DELTA_TD16 ('TD16')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_TCH_FMT_DELTA_TD16</constant></refname>
+    <refpurpose>16-bit signed Touch Delta</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This format represents delta data from a touch controller</para>
+
+    <para>Delta values may range from -32768 to 32767. Typically the values
+      will vary through a small range depending on whether the sensor is
+      touched or not. The full value may be seen if one of the
+      touchscreen nodes has a fault or the line is not connected.</para>
+
+    <example>
+      <title><constant>V4L2_TCH_FMT_DELTA_TD16</constant> 4 &times; 4
+        node matrix</title>
+
+      <formalpara>
+        <title>Byte Order.</title>
+        <para>Each cell is one byte.
+          <informaltable frame="none">
+            <tgroup cols="9" align="center">
+              <colspec align="left" colwidth="2*" />
+              <tbody valign="top">
+                <row>
+                  <entry>start&nbsp;+&nbsp;0:</entry>
+                  <entry>D'<subscript>00low</subscript></entry>
+                  <entry>D'<subscript>00high</subscript></entry>
+                  <entry>D'<subscript>01low</subscript></entry>
+                  <entry>D'<subscript>01high</subscript></entry>
+                  <entry>D'<subscript>02low</subscript></entry>
+                  <entry>D'<subscript>02high</subscript></entry>
+                  <entry>D'<subscript>03low</subscript></entry>
+                  <entry>D'<subscript>03high</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;8:</entry>
+                  <entry>D'<subscript>10low</subscript></entry>
+                  <entry>D'<subscript>10high</subscript></entry>
+                  <entry>D'<subscript>11low</subscript></entry>
+                  <entry>D'<subscript>11high</subscript></entry>
+                  <entry>D'<subscript>12low</subscript></entry>
+                  <entry>D'<subscript>12high</subscript></entry>
+                  <entry>D'<subscript>13low</subscript></entry>
+                  <entry>D'<subscript>13high</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;16:</entry>
+                  <entry>D'<subscript>20low</subscript></entry>
+                  <entry>D'<subscript>20high</subscript></entry>
+                  <entry>D'<subscript>21low</subscript></entry>
+                  <entry>D'<subscript>21high</subscript></entry>
+                  <entry>D'<subscript>22low</subscript></entry>
+                  <entry>D'<subscript>22high</subscript></entry>
+                  <entry>D'<subscript>23low</subscript></entry>
+                  <entry>D'<subscript>23high</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;24:</entry>
+                  <entry>D'<subscript>30low</subscript></entry>
+                  <entry>D'<subscript>30high</subscript></entry>
+                  <entry>D'<subscript>31low</subscript></entry>
+                  <entry>D'<subscript>31high</subscript></entry>
+                  <entry>D'<subscript>32low</subscript></entry>
+                  <entry>D'<subscript>32high</subscript></entry>
+                  <entry>D'<subscript>33low</subscript></entry>
+                  <entry>D'<subscript>33high</subscript></entry>
+                </row>
+              </tbody>
+            </tgroup>
+          </informaltable>
+        </para>
+      </formalpara>
+    </example>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-tch-tu08.xml b/Documentation/DocBook/media/v4l/pixfmt-tch-tu08.xml
new file mode 100644
index 0000000..24f76ab
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-tch-tu08.xml
@@ -0,0 +1,66 @@
+<refentry id="V4L2-TCH-FMT-TU08">
+  <refmeta>
+    <refentrytitle>V4L2_TCH_FMT_TU08 ('TU08')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_TCH_FMT_TU08</constant></refname>
+    <refpurpose>8-bit unsigned raw touch data</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This format represents unsigned 8-bit data from a touch
+      controller.</para>
+
+    <para>This may be used for output for raw and reference data. Values may
+      range from 0 to 255.</para>
+
+    <example>
+      <title><constant>V4L2_TCH_FMT_TU08</constant> 4 &times; 4
+        node matrix</title>
+
+      <formalpara>
+        <title>Byte Order.</title>
+        <para>Each cell is one byte.
+          <informaltable frame="none">
+            <tgroup cols="5" align="center">
+              <colspec align="left" colwidth="2*" />
+              <tbody valign="top">
+                <row>
+                  <entry>start&nbsp;+&nbsp;0:</entry>
+                  <entry>R'<subscript>00</subscript></entry>
+                  <entry>R'<subscript>01</subscript></entry>
+                  <entry>R'<subscript>02</subscript></entry>
+                  <entry>R'<subscript>03</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;4:</entry>
+                  <entry>R'<subscript>10</subscript></entry>
+                  <entry>R'<subscript>11</subscript></entry>
+                  <entry>R'<subscript>12</subscript></entry>
+                  <entry>R'<subscript>13</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;8:</entry>
+                  <entry>R'<subscript>20</subscript></entry>
+                  <entry>R'<subscript>21</subscript></entry>
+                  <entry>R'<subscript>22</subscript></entry>
+                  <entry>R'<subscript>23</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;12:</entry>
+                  <entry>R'<subscript>30</subscript></entry>
+                  <entry>R'<subscript>31</subscript></entry>
+                  <entry>R'<subscript>32</subscript></entry>
+                  <entry>R'<subscript>33</subscript></entry>
+                </row>
+              </tbody>
+            </tgroup>
+          </informaltable>
+        </para>
+      </formalpara>
+
+    </example>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt-tch-tu16.xml b/Documentation/DocBook/media/v4l/pixfmt-tch-tu16.xml
new file mode 100644
index 0000000..2db69af
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-tch-tu16.xml
@@ -0,0 +1,81 @@
+<refentry id="V4L2-TCH-FMT-TU16">
+  <refmeta>
+    <refentrytitle>V4L2_TCH_FMT_TU16 ('TU16')</refentrytitle>
+    &manvol;
+  </refmeta>
+  <refnamediv>
+    <refname><constant>V4L2_TCH_FMT_TU16</constant></refname>
+    <refpurpose>16-bit unsigned raw touch data</refpurpose>
+  </refnamediv>
+  <refsect1>
+    <title>Description</title>
+
+    <para>This format represents unsigned 16-bit data from a touch
+      controller.</para>
+
+    <para>This may be used for output for raw and reference data. Values may
+      range from 0 to 65535.</para>
+
+    <example>
+      <title><constant>V4L2_TCH_FMT_TU16</constant> 4 &times; 4
+        node matrix</title>
+
+      <formalpara>
+        <title>Byte Order.</title>
+        <para>Each cell is one byte.
+          <informaltable frame="none">
+            <tgroup cols="9" align="center">
+              <colspec align="left" colwidth="2*" />
+              <tbody valign="top">
+                <row>
+                  <entry>start&nbsp;+&nbsp;0:</entry>
+                  <entry>R'<subscript>00low</subscript></entry>
+                  <entry>R'<subscript>00high</subscript></entry>
+                  <entry>R'<subscript>01low</subscript></entry>
+                  <entry>R'<subscript>01high</subscript></entry>
+                  <entry>R'<subscript>02low</subscript></entry>
+                  <entry>R'<subscript>02high</subscript></entry>
+                  <entry>R'<subscript>03low</subscript></entry>
+                  <entry>R'<subscript>03high</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;8:</entry>
+                  <entry>R'<subscript>10low</subscript></entry>
+                  <entry>R'<subscript>10high</subscript></entry>
+                  <entry>R'<subscript>11low</subscript></entry>
+                  <entry>R'<subscript>11high</subscript></entry>
+                  <entry>R'<subscript>12low</subscript></entry>
+                  <entry>R'<subscript>12high</subscript></entry>
+                  <entry>R'<subscript>13low</subscript></entry>
+                  <entry>R'<subscript>13high</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;16:</entry>
+                  <entry>R'<subscript>20low</subscript></entry>
+                  <entry>R'<subscript>20high</subscript></entry>
+                  <entry>R'<subscript>21low</subscript></entry>
+                  <entry>R'<subscript>21high</subscript></entry>
+                  <entry>R'<subscript>22low</subscript></entry>
+                  <entry>R'<subscript>22high</subscript></entry>
+                  <entry>R'<subscript>23low</subscript></entry>
+                  <entry>R'<subscript>23high</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;24:</entry>
+                  <entry>R'<subscript>30low</subscript></entry>
+                  <entry>R'<subscript>30high</subscript></entry>
+                  <entry>R'<subscript>31low</subscript></entry>
+                  <entry>R'<subscript>31high</subscript></entry>
+                  <entry>R'<subscript>32low</subscript></entry>
+                  <entry>R'<subscript>32high</subscript></entry>
+                  <entry>R'<subscript>33low</subscript></entry>
+                  <entry>R'<subscript>33high</subscript></entry>
+                </row>
+              </tbody>
+            </tgroup>
+          </informaltable>
+        </para>
+      </formalpara>
+    </example>
+  </refsect1>
+</refentry>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 5a08aee..509248a 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1754,6 +1754,19 @@ interface only.</para>
 
   </section>
 
+  <section id="tch-formats">
+    <title>Touch Formats</title>
+
+    <para>These formats are used for <link linkend="touch">Touch Sensor</link>
+interface only.</para>
+
+    &sub-tch-td16;
+    &sub-tch-td08;
+    &sub-tch-tu16;
+    &sub-tch-tu08;
+
+  </section>
+
   <section id="pixfmt-reserved">
     <title>Reserved Format Identifiers</title>
 
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 42e626d..b577de2 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -605,6 +605,7 @@ and discussions on the V4L mailing list.</revremark>
     <section id="radio"> &sub-dev-radio; </section>
     <section id="rds"> &sub-dev-rds; </section>
     <section id="sdr"> &sub-dev-sdr; </section>
+    <section id="touch"> &sub-dev-touch; </section>
     <section id="event"> &sub-dev-event; </section>
     <section id="subdev"> &sub-dev-subdev; </section>
   </chapter>
-- 
2.5.0

