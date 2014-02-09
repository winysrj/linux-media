Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34912 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbaBII7b (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:59:31 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [REVIEW PATCH 50/86] DocBook: V4L: add V4L2_SDR_FMT_CU8 - 'CU08'
Date: Sun,  9 Feb 2014 10:48:55 +0200
Message-Id: <1391935771-18670-51-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document V4L2_SDR_FMT_CU8 SDR format.
It is complex unsigned 8-bit IQ sample. Used by software defined
radio devices.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../DocBook/media/v4l/pixfmt-sdr-cu08.xml          | 44 ++++++++++++++++++++++
 Documentation/DocBook/media/v4l/pixfmt.xml         |  2 +
 2 files changed, 46 insertions(+)
 create mode 100644 Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml

diff --git a/Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml b/Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
new file mode 100644
index 0000000..2d80104
--- /dev/null
+++ b/Documentation/DocBook/media/v4l/pixfmt-sdr-cu08.xml
@@ -0,0 +1,44 @@
+<refentry id="V4L2-SDR-FMT-CU08">
+  <refmeta>
+    <refentrytitle>V4L2_SDR_FMT_CU8 ('CU08')</refentrytitle>
+    &manvol;
+  </refmeta>
+    <refnamediv>
+      <refname>
+        <constant>V4L2_SDR_FMT_CU8</constant>
+      </refname>
+      <refpurpose>Complex unsigned 8-bit IQ sample</refpurpose>
+    </refnamediv>
+    <refsect1>
+      <title>Description</title>
+      <para>
+This format contains sequence of complex number samples. Each complex number
+consist two parts, called In-phase and Quadrature (IQ). Both I and Q are
+represented as a 8 bit unsigned number. I value comes first and Q value after
+that.
+      </para>
+    <example>
+      <title><constant>V4L2_SDR_FMT_CU8</constant> 1 sample</title>
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
index f586d34..40adcb8 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -817,6 +817,8 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
     <para>These formats are used for <link linkend="sdr">SDR Capture</link>
 interface only.</para>
 
+    &sub-sdr-cu08;
+
   </section>
 
   <section id="pixfmt-reserved">
-- 
1.8.5.3

