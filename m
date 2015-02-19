Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58550 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbbBSNuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 08:50:21 -0500
Received: from [10.54.92.107] (173-38-208-170.cisco.com [173.38.208.170])
	by tschai.lan (Postfix) with ESMTPSA id 5A4772A01AF
	for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 14:49:57 +0100 (CET)
Message-ID: <54E5E9F4.10000@xs4all.nl>
Date: Thu, 19 Feb 2015 14:49:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media: fix xvYCC601 documentation
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The documentation of the xvYCC601 Y'CbCr encoding was part of the SMPTE 170M
(SDTV) colorspace, but it should have been part of the Rec. 709 (HDTV) colorspace
as per the xvYCC standard.

This change only affects the documentation and not any code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 5e0352c..a3dfc32 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -666,8 +666,7 @@ as the SMPTE C set, so this colorspace is sometimes called SMPTE C as well.</par
       <variablelist>
 	<varlistentry>
           <term>The transfer function defined for SMPTE 170M is the same as the
-one defined in Rec. 709. Normally L is in the range [0&hellip;1], but for the extended
-gamut xvYCC encoding values outside that range are allowed.</term>
+one defined in Rec. 709.</term>
 	  <listitem>
             <para>L' = -1.099(-L)<superscript>0.45</superscript>&nbsp;+&nbsp;0.099&nbsp;for&nbsp;L&nbsp;&le;&nbsp;-0.018</para>
             <para>L' = 4.5L&nbsp;for&nbsp;-0.018&nbsp;&lt;&nbsp;L&nbsp;&lt;&nbsp;0.018</para>
@@ -702,25 +701,6 @@ defined in the <xref linkend="itu601" /> standard and this colorspace is sometim
 though BT.601 does not mention any color primaries.</para>
       <para>The default quantization is limited range, but full range is possible although
 rarely seen.</para>
-      <para>The <constant>V4L2_YCBCR_ENC_601</constant> encoding as described above is the
-default for this colorspace, but it can be overridden with <constant>V4L2_YCBCR_ENC_709</constant>,
-in which case the Rec. 709 Y'CbCr encoding is used.</para>
-      <variablelist>
-	<varlistentry>
-      	  <term>The xvYCC 601 encoding (<constant>V4L2_YCBCR_ENC_XV601</constant>, <xref linkend="xvycc" />) is similar
-to the BT.601 encoding, but it allows for R', G' and B' values that are outside the range
-[0&hellip;1]. The resulting Y', Cb and Cr values are scaled and offset:</term>
-	  <listitem>
-            <para>Y'&nbsp;=&nbsp;(219&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B')&nbsp;+&nbsp;(16&nbsp;/&nbsp;255)</para>
-            <para>Cb&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B')</para>
-            <para>Cr&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B')</para>
-	  </listitem>
-	</varlistentry>
-      </variablelist>
-      <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are clamped
-to the range [-0.5&hellip;0.5]. The non-standard xvYCC 709 encoding can also be used by selecting
-<constant>V4L2_YCBCR_ENC_XV709</constant>. The xvYCC encodings always use full range
-quantization.</para>
     </section>

     <section>
@@ -803,6 +783,7 @@ rarely seen.</para>
       <para>The <constant>V4L2_YCBCR_ENC_709</constant> encoding described above is the default
 for this colorspace, but it can be overridden with <constant>V4L2_YCBCR_ENC_601</constant>, in which
 case the BT.601 Y'CbCr encoding is used.</para>
+      <para>Two additional extended gamut Y'CbCr encodings are also possible with this colorspace:</para>
       <variablelist>
 	<varlistentry>
       	  <term>The xvYCC 709 encoding (<constant>V4L2_YCBCR_ENC_XV709</constant>, <xref linkend="xvycc" />)
@@ -815,10 +796,22 @@ is similar to the Rec. 709 encoding, but it allows for R', G' and B' values that
 	  </listitem>
 	</varlistentry>
       </variablelist>
+      <variablelist>
+	<varlistentry>
+      	  <term>The xvYCC 601 encoding (<constant>V4L2_YCBCR_ENC_XV601</constant>, <xref linkend="xvycc" />) is similar
+to the BT.601 encoding, but it allows for R', G' and B' values that are outside the range
+[0&hellip;1]. The resulting Y', Cb and Cr values are scaled and offset:</term>
+	  <listitem>
+            <para>Y'&nbsp;=&nbsp;(219&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.299R'&nbsp;+&nbsp;0.587G'&nbsp;+&nbsp;0.114B')&nbsp;+&nbsp;(16&nbsp;/&nbsp;255)</para>
+            <para>Cb&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(-0.169R'&nbsp;-&nbsp;0.331G'&nbsp;+&nbsp;0.5B')</para>
+            <para>Cr&nbsp;=&nbsp;(224&nbsp;/&nbsp;255)&nbsp;*&nbsp;(0.5R'&nbsp;-&nbsp;0.419G'&nbsp;-&nbsp;0.081B')</para>
+	  </listitem>
+	</varlistentry>
+      </variablelist>
       <para>Y' is clamped to the range [0&hellip;1] and Cb and Cr are clamped
-to the range [-0.5&hellip;0.5]. The non-standard xvYCC 601 encoding can also be used by
-selecting <constant>V4L2_YCBCR_ENC_XV601</constant>. The xvYCC encodings always use full
-range quantization.</para>
+to the range [-0.5&hellip;0.5]. The non-standard xvYCC 709 or xvYCC 601 encodings can be used by
+selecting <constant>V4L2_YCBCR_ENC_XV709</constant> or <constant>V4L2_YCBCR_ENC_XV601</constant>.
+The xvYCC encodings always use full range quantization.</para>
     </section>

     <section>
