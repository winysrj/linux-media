Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56273 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736AbaGOBJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/18] DocBook: V4L: add V4L2_SDR_FMT_CS14LE - 'CS14'
Date: Tue, 15 Jul 2014 04:09:09 +0300
Message-Id: <1405386561-30450-6-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_SDR_FMT_CS14LE is complex signed 14-bit sample format, used
for software defined radio devices.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 .../DocBook/media/v4l/pixfmt-sdr-cs14le.xml        | 47 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |  1 +
 2 files changed, 48 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml
new file mode 100644
index 0000000..e4b494c
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-sdr-cs14le.xml
@@ -0,0 +1,47 @@
+<refentry id="V4L2-SDR-FMT-CS14LE">
+  <refmeta>
+    <refentrytitle>V4L2_SDR_FMT_CS14LE ('CS14')</refentrytitle>
+    &manvol;
+  </refmeta>
+    <refnamediv>
+      <refname>
+        <constant>V4L2_SDR_FMT_CS14LE</constant>
+      </refname>
+      <refpurpose>Complex signed 14-bit little endian IQ sample</refpurpose>
+    </refnamediv>
+    <refsect1>
+      <title>Description</title>
+      <para>
+This format contains sequence of complex number samples. Each complex number
+consist two parts, called In-phase and Quadrature (IQ). Both I and Q are
+represented as a 14 bit signed little endian number. I value comes first
+and Q value after that. 14 bit value is stored in 16 bit space with unused
+high bits padded with 0.
+      </para>
+    <example>
+      <title><constant>V4L2_SDR_FMT_CS14LE</constant> 1 sample</title>
+      <formalpara>
+        <title>Byte Order.</title>
+        <para>Each cell is one byte.
+          <informaltable frame="none">
+            <tgroup cols="3" align="center">
+              <colspec align="left" colwidth="2*" />
+              <tbody valign="top">
+                <row>
+                  <entry>start&nbsp;+&nbsp;0:</entry>
+                  <entry>I'<subscript>0[7:0]</subscript></entry>
+                  <entry>I'<subscript>0[13:8]</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;2:</entry>
+                  <entry>Q'<subscript>0[7:0]</subscript></entry>
+                  <entry>Q'<subscript>0[13:8]</subscript></entry>
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
index 3e90ded..df0c95c 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -829,6 +829,7 @@ interface only.</para>
     &sub-sdr-cu08;
     &sub-sdr-cu16le;
     &sub-sdr-cs08;
+    &sub-sdr-cs14le;
     &sub-sdr-ru12le;
 
   </section>
-- 
1.9.3

