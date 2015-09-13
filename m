Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42200 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426AbbIMQm7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 12:42:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] DocBook media: document the new DCI-P3 colorspace
Date: Sun, 13 Sep 2015 18:41:30 +0200
Message-Id: <1442162492-46238-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
References: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Document this colorspace.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/biblio.xml |  9 ++++
 Documentation/DocBook/media/v4l/pixfmt.xml | 70 ++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/biblio.xml b/Documentation/DocBook/media/v4l/biblio.xml
index fdee6b3..f54db59 100644
--- a/Documentation/DocBook/media/v4l/biblio.xml
+++ b/Documentation/DocBook/media/v4l/biblio.xml
@@ -177,6 +177,15 @@ Signal - NTSC for Studio Applications"</title>
 1125-Line High-Definition Production"</title>
     </biblioentry>
 
+    <biblioentry id="smpte431">
+      <abbrev>SMPTE&nbsp;RP&nbsp;431-2</abbrev>
+      <authorgroup>
+	<corpauthor>Society of Motion Picture and Television Engineers
+(<ulink url="http://www.smpte.org">http://www.smpte.org</ulink>)</corpauthor>
+      </authorgroup>
+      <title>SMPTE RP 431-2:2011 "D-Cinema Quality - Reference Projector and Environment"</title>
+    </biblioentry>
+
     <biblioentry id="srgb">
       <abbrev>sRGB</abbrev>
       <authorgroup>
diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 965ea91..4173333 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -540,6 +540,10 @@ colorspaces except for BT.2020 which uses limited range R'G'B' quantization.</pa
 	    <entry>See <xref linkend="col-bt2020" />.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_COLORSPACE_DCI_P3</constant></entry>
+	    <entry>See <xref linkend="col-dcip3" />.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_COLORSPACE_SMPTE240M</constant></entry>
 	    <entry>See <xref linkend="col-smpte-240m" />.</entry>
 	  </row>
@@ -601,6 +605,10 @@ colorspaces except for BT.2020 which uses limited range R'G'B' quantization.</pa
 	    <entry><constant>V4L2_XFER_FUNC_NONE</constant></entry>
 	    <entry>Do not use a transfer function (i.e. use linear RGB values).</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_XFER_FUNC_DCI_P3</constant></entry>
+	    <entry>Use the DCI-P3 transfer function.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
@@ -1154,6 +1162,68 @@ clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range
 clamped to the range [-0.5&hellip;0.5]. The Yc'CbcCrc quantization is limited range.</para>
     </section>
 
+    <section id="col-dcip3">
+      <title>Colorspace DCI-P3 (<constant>V4L2_COLORSPACE_DCI_P3</constant>)</title>
+      <para>The <xref linkend="smpte431" /> standard defines the colorspace used by cinema
+projectors that use the DCI-P3 colorspace.
+The default transfer function is <constant>V4L2_XFER_FUNC_DCI_P3</constant>.
+The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_709</constant>. Note that this
+colorspace does not specify a Y'CbCr encoding since it is not meant to be encoded
+to Y'CbCr. So this default Y'CbCr encoding was picked because it is the HDTV
+encoding. The default Y'CbCr quantization is limited range. The chromaticities of
+the primary colors and the white reference are:</para>
+      <table frame="none">
+        <title>DCI-P3 Chromaticities</title>
+        <tgroup cols="3" align="left">
+          &cs-str;
+    	<thead>
+    	  <row>
+    	    <entry>Color</entry>
+    	    <entry>x</entry>
+    	    <entry>y</entry>
+    	  </row>
+    	</thead>
+          <tbody valign="top">
+            <row>
+              <entry>Red</entry>
+              <entry>0.6800</entry>
+              <entry>0.3200</entry>
+            </row>
+            <row>
+              <entry>Green</entry>
+              <entry>0.2650</entry>
+              <entry>0.6900</entry>
+            </row>
+            <row>
+              <entry>Blue</entry>
+              <entry>0.1500</entry>
+              <entry>0.0600</entry>
+            </row>
+            <row>
+              <entry>White Reference</entry>
+              <entry>0.3140</entry>
+              <entry>0.3510</entry>
+            </row>
+          </tbody>
+        </tgroup>
+      </table>
+      <variablelist>
+	<varlistentry>
+          <term>Transfer function:</term>
+	  <listitem>
+            <para>L' = L<superscript>1/2.6</superscript></para>
+	  </listitem>
+	</varlistentry>
+	<varlistentry>
+          <term>Inverse Transfer function:</term>
+	  <listitem>
+            <para>L = L'<superscript>2.6</superscript></para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
+      <para>Y'CbCr encoding is not specified. V4L2 defaults to Rec. 709.</para>
+    </section>
+
     <section id="col-smpte-240m">
       <title>Colorspace SMPTE 240M (<constant>V4L2_COLORSPACE_SMPTE240M</constant>)</title>
       <para>The <xref linkend="smpte240m" /> standard was an interim standard used during
-- 
2.1.4

