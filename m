Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:59618 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbbCKMvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 08:51:43 -0400
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id 728772A0097
	for <linux-media@vger.kernel.org>; Wed, 11 Mar 2015 13:51:35 +0100 (CET)
Message-ID: <55003A40.4010607@xs4all.nl>
Date: Wed, 11 Mar 2015 13:51:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media: fix section IDs
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The colorspace section IDs were assigned to the title instead of to the
section. Some links failed because of that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 13540fa..1759beb 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -620,8 +620,8 @@ is mapped to [16&hellip;235]. Cb and Cr are mapped from [-0.5&hellip;0.5] to [16

   <section>
     <title>Detailed Colorspace Descriptions</title>
-    <section>
-      <title id="col-smpte-170m">Colorspace SMPTE 170M (<constant>V4L2_COLORSPACE_SMPTE170M</constant>)</title>
+    <section id="col-smpte-170m">
+      <title>Colorspace SMPTE 170M (<constant>V4L2_COLORSPACE_SMPTE170M</constant>)</title>
       <para>The <xref linkend="smpte170m" /> standard defines the colorspace used by NTSC and PAL and by SDTV
 in general. The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>.
 The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and
@@ -703,8 +703,8 @@ though BT.601 does not mention any color primaries.</para>
 rarely seen.</para>
     </section>

-    <section>
-      <title id="col-rec709">Colorspace Rec. 709 (<constant>V4L2_COLORSPACE_REC709</constant>)</title>
+    <section id="col-rec709">
+      <title>Colorspace Rec. 709 (<constant>V4L2_COLORSPACE_REC709</constant>)</title>
       <para>The <xref linkend="itu709" /> standard defines the colorspace used by HDTV in general. The default
 Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_709</constant>. The default Y'CbCr quantization is
 limited range. The chromaticities of the primary colors and the white reference are:</para>
@@ -814,8 +814,8 @@ selecting <constant>V4L2_YCBCR_ENC_XV709</constant> or <constant>V4L2_YCBCR_ENC_
 The xvYCC encodings always use full range quantization.</para>
     </section>

-    <section>
-      <title id="col-srgb">Colorspace sRGB (<constant>V4L2_COLORSPACE_SRGB</constant>)</title>
+    <section id="col-srgb">
+      <title>Colorspace sRGB (<constant>V4L2_COLORSPACE_SRGB</constant>)</title>
       <para>The <xref linkend="srgb" /> standard defines the colorspace used by most webcams and computer graphics. The
 default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_SYCC</constant>. The default Y'CbCr quantization
 is full range. The chromaticities of the primary colors and the white reference are:</para>
@@ -891,8 +891,8 @@ encoding, it is not. The <constant>V4L2_YCBCR_ENC_XV601</constant> scales and of
 values before quantization, but this encoding does not do that.</para>
     </section>

-    <section>
-      <title id="col-adobergb">Colorspace Adobe RGB (<constant>V4L2_COLORSPACE_ADOBERGB</constant>)</title>
+    <section id="col-adobergb">
+      <title>Colorspace Adobe RGB (<constant>V4L2_COLORSPACE_ADOBERGB</constant>)</title>
       <para>The <xref linkend="adobergb" /> standard defines the colorspace used by computer graphics
 that use the AdobeRGB colorspace. This is also known as the <xref linkend="oprgb" /> standard.
 The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr
@@ -963,8 +963,8 @@ clamped to the range [-0.5&hellip;0.5]. This transform is identical to one defin
 SMPTE 170M/BT.601. The Y'CbCr quantization is limited range.</para>
     </section>

-    <section>
-      <title id="col-bt2020">Colorspace BT.2020 (<constant>V4L2_COLORSPACE_BT2020</constant>)</title>
+    <section id="col-bt2020">
+      <title>Colorspace BT.2020 (<constant>V4L2_COLORSPACE_BT2020</constant>)</title>
       <para>The <xref linkend="itu2020" /> standard defines the colorspace used by Ultra-high definition
 television (UHDTV). The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_BT2020</constant>.
 The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and
@@ -1079,8 +1079,8 @@ clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range
 clamped to the range [-0.5&hellip;0.5]. The Yc'CbcCrc quantization is limited range.</para>
     </section>

-    <section>
-      <title id="col-smpte-240m">Colorspace SMPTE 240M (<constant>V4L2_COLORSPACE_SMPTE240M</constant>)</title>
+    <section id="col-smpte-240m">
+      <title>Colorspace SMPTE 240M (<constant>V4L2_COLORSPACE_SMPTE240M</constant>)</title>
       <para>The <xref linkend="smpte240m" /> standard was an interim standard used during the early days of HDTV (1988-1998).
 It has been superseded by Rec. 709. The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_SMPTE240M</constant>.
 The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and the
@@ -1152,8 +1152,8 @@ following <constant>V4L2_YCBCR_ENC_SMPTE240M</constant> encoding:</term>
 clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range.</para>
     </section>

-    <section>
-      <title id="col-sysm">Colorspace NTSC 1953 (<constant>V4L2_COLORSPACE_470_SYSTEM_M</constant>)</title>
+    <section id="col-sysm">
+      <title>Colorspace NTSC 1953 (<constant>V4L2_COLORSPACE_470_SYSTEM_M</constant>)</title>
       <para>This standard defines the colorspace used by NTSC in 1953. In practice this
 colorspace is obsolete and SMPTE 170M should be used instead. The default Y'CbCr encoding
 is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr quantization is limited range.
@@ -1230,8 +1230,8 @@ clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range
 This transform is identical to one defined in SMPTE 170M/BT.601.</para>
     </section>

-    <section>
-      <title id="col-sysbg">Colorspace EBU Tech. 3213 (<constant>V4L2_COLORSPACE_470_SYSTEM_BG</constant>)</title>
+    <section id="col-sysbg">
+      <title>Colorspace EBU Tech. 3213 (<constant>V4L2_COLORSPACE_470_SYSTEM_BG</constant>)</title>
       <para>The <xref linkend="tech3213" /> standard defines the colorspace used by PAL/SECAM in 1975. In practice this
 colorspace is obsolete and SMPTE 170M should be used instead. The default Y'CbCr encoding
 is <constant>V4L2_YCBCR_ENC_601</constant>. The default Y'CbCr quantization is limited range.
@@ -1304,8 +1304,8 @@ clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range
 This transform is identical to one defined in SMPTE 170M/BT.601.</para>
     </section>

-    <section>
-      <title id="col-jpeg">Colorspace JPEG (<constant>V4L2_COLORSPACE_JPEG</constant>)</title>
+    <section id="col-jpeg">
+      <title>Colorspace JPEG (<constant>V4L2_COLORSPACE_JPEG</constant>)</title>
       <para>This colorspace defines the colorspace used by most (Motion-)JPEG formats. The chromaticities
 of the primary colors and the white reference are identical to sRGB. The Y'CbCr encoding is
 <constant>V4L2_YCBCR_ENC_601</constant> with full range quantization where
