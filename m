Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56028 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbaGOBJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/18] DocBook: V4L: add V4L2_SDR_FMT_RU12LE - 'RU12'
Date: Tue, 15 Jul 2014 04:09:05 +0300
Message-Id: <1405386561-30450-2-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document V4L2_SDR_FMT_RU12LE format. It is real unsigned 12-bit
little endian sample inside 16-bit space. Used by software defined
radio devices.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 .../DocBook/media/v4l/pixfmt-sdr-ru12le.xml        | 40 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |  1 +
 2 files changed, 41 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml
new file mode 100644
index 0000000..3df076b
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-sdr-ru12le.xml
@@ -0,0 +1,40 @@
+<refentry id="V4L2-SDR-FMT-RU12LE">
+  <refmeta>
+    <refentrytitle>V4L2_SDR_FMT_RU12LE ('RU12')</refentrytitle>
+    &manvol;
+  </refmeta>
+    <refnamediv>
+      <refname>
+        <constant>V4L2_SDR_FMT_RU12LE</constant>
+      </refname>
+      <refpurpose>Real unsigned 12-bit little endian sample</refpurpose>
+    </refnamediv>
+    <refsect1>
+      <title>Description</title>
+      <para>
+This format contains sequence of real number samples. Each sample is
+represented as a 12 bit unsigned little endian number. Sample is stored
+in 16 bit space with unused high bits padded with 0.
+      </para>
+    <example>
+      <title><constant>V4L2_SDR_FMT_RU12LE</constant> 1 sample</title>
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
+                  <entry>I'<subscript>0[11:8]</subscript></entry>
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
index 91dcbc8..3e124aa 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -828,6 +828,7 @@ interface only.</para>
 
     &sub-sdr-cu08;
     &sub-sdr-cu16le;
+    &sub-sdr-ru12le;
 
   </section>
 
-- 
1.9.3

