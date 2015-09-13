Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57283 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755189AbbIMTQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 15:16:50 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] DocBook media: Document the SMPTE 2084 transfer function
Date: Sun, 13 Sep 2015 21:15:21 +0200
Message-Id: <1442171721-13058-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
References: <1442171721-13058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document this new transfer function used by High Dynamic Range content.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/biblio.xml |  9 +++++++
 Documentation/DocBook/media/v4l/pixfmt.xml | 39 ++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index f54db59..9beb30f 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -186,6 +186,15 @@ Signal - NTSC for Studio Applications"</title>
       <title>SMPTE RP 431-2:2011 "D-Cinema Quality - Reference Projector and Environment"</title>
     </biblioentry>
 
+    <biblioentry id="smpte2084">
+      <abbrev>SMPTE&nbsp;ST&nbsp;2084</abbrev>
+      <authorgroup>
+	<corpauthor>Society of Motion Picture and Television Engineers
+(<ulink url="http://www.smpte.org">http://www.smpte.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>SMPTE ST 2084:2014 "High Dynamic Range Electro-Optical Transfer Function of Master Reference Displays"</title>
+    </biblioentry>
+
     <biblioentry id="srgb">
       <abbrev>sRGB</abbrev>
       <authorgroup>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 4173333..70cd0fd 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -609,6 +609,10 @@ colorspaces except for BT.2020 which uses limited range R'G'B' quantization.</pa
 	    <entry><constant>V4L2_XFER_FUNC_DCI_P3</constant></entry>
 	    <entry>Use the DCI-P3 transfer function.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_XFER_FUNC_SMPTE2084</constant></entry>
+	    <entry>Use the SMPTE 2084 transfer function.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -1472,6 +1476,41 @@ and <constant>V4L2_QUANTIZATION_FULL_RANGE</constant>.</para>
 
   </section>
 
+  <section>
+    <title>Detailed Transfer Function Descriptions</title>
+    <section id="xf-smpte-2084">
+      <title>Transfer Function SMPTE 2084 (<constant>V4L2_XFER_FUNC_SMPTE2084</constant>)</title>
+      <para>The <xref linkend="smpte2084" /> standard defines the transfer function used by
+High Dynamic Range content.</para>
+      <variablelist>
+	<varlistentry>
+          <term>Constants:</term>
+	  <listitem>
+            <para>m1 = (2610 / 4096) / 4</para>
+            <para>m2 = (2523 / 4096) * 128</para>
+            <para>c1 = 3424 / 4096</para>
+            <para>c2 = (2413 / 4096) * 32</para>
+            <para>c3 = (2392 / 4096) * 32</para>
+	  </listitem>
+	</varlistentry>
+	<varlistentry>
+          <term>Transfer function:</term>
+	  <listitem>
+            <para>L' = ((c1 + c2 * L<superscript>m1</superscript>) / (1 + c3 * L<superscript>m1</superscript>))<superscript>m2</superscript></para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <variablelist>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = (max(L'<superscript>1/m2</superscript> - c1, 0) / (c2 - c3 * L'<superscript>1/m2</superscript>))<superscript>1/m1</superscript></para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+    </section>
+  </section>
+
   <section id="pixfmt-indexed">
     <title>Indexed Format</title>
 
-- 
2.1.4

