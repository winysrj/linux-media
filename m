Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39612 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbaGOBJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/18] DocBook: V4L: add V4L2_SDR_FMT_CS8 - 'CS08'
Date: Tue, 15 Jul 2014 04:09:07 +0300
Message-Id: <1405386561-30450-4-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_SDR_FMT_CS8 is complex signed 8-bit sample format, used for
software defined radio devices.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 .../DocBook/media/v4l/pixfmt-sdr-cs08.xml          | 44 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |  1 +
 2 files changed, 45 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml
new file mode 100644
index 0000000..6118d8f
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-sdr-cs08.xml
@@ -0,0 +1,44 @@
+<refentry id="V4L2-SDR-FMT-CS08">
+  <refmeta>
+    <refentrytitle>V4L2_SDR_FMT_CS8 ('CS08')</refentrytitle>
+    &manvol;
+  </refmeta>
+    <refnamediv>
+      <refname>
+        <constant>V4L2_SDR_FMT_CS8</constant>
+      </refname>
+      <refpurpose>Complex signed 8-bit IQ sample</refpurpose>
+    </refnamediv>
+    <refsect1>
+      <title>Description</title>
+      <para>
+This format contains sequence of complex number samples. Each complex number
+consist two parts, called In-phase and Quadrature (IQ). Both I and Q are
+represented as a 8 bit signed number. I value comes first and Q value after
+that.
+      </para>
+    <example>
+      <title><constant>V4L2_SDR_FMT_CS8</constant> 1 sample</title>
+      <formalpara>
+        <title>Byte Order.</title>
+        <para>Each cell is one byte.
+          <informaltable frame="none">
+            <tgroup cols="2" align="center">
+              <colspec align="left" colwidth="2*" />
+              <tbody valign="top">
+                <row>
+                  <entry>start&nbsp;+&nbsp;0:</entry>
+                  <entry>I'<subscript>0</subscript></entry>
+                </row>
+                <row>
+                  <entry>start&nbsp;+&nbsp;1:</entry>
+                  <entry>Q'<subscript>0</subscript></entry>
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
index 3e124aa..3e90ded 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -828,6 +828,7 @@ interface only.</para>
 
     &sub-sdr-cu08;
     &sub-sdr-cu16le;
+    &sub-sdr-cs08;
     &sub-sdr-ru12le;
 
   </section>
-- 
1.9.3

