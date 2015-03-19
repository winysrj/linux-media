Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52988 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536AbbCSObz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 10:31:55 -0400
Received: from [10.54.92.107] (unknown [173.38.220.40])
	by tschai.lan (Postfix) with ESMTPSA id 4CBC92A00AB
	for <linux-media@vger.kernel.org>; Thu, 19 Mar 2015 15:31:44 +0100 (CET)
Message-ID: <550ADDAE.1000406@xs4all.nl>
Date: Thu, 19 Mar 2015 15:31:10 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH] DocBook media: fix BT.2020 description
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One number was wrong (0.6789 -> 0.6780) and Y' should have been Yc'.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index 13540fa..05b595c 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -1025,7 +1025,7 @@ the white reference are:</para>
       	  <term>The luminance (Y') and color difference (Cb and Cr) are obtained with the
 following <constant>V4L2_YCBCR_ENC_BT2020</constant> encoding:</term>
 	  <listitem>
-            <para>Y'&nbsp;=&nbsp;0.2627R'&nbsp;+&nbsp;0.6789G'&nbsp;+&nbsp;0.0593B'</para>
+            <para>Y'&nbsp;=&nbsp;0.2627R'&nbsp;+&nbsp;0.6780G'&nbsp;+&nbsp;0.0593B'</para>
             <para>Cb&nbsp;=&nbsp;-0.1396R'&nbsp;-&nbsp;0.3604G'&nbsp;+&nbsp;0.5B'</para>
             <para>Cr&nbsp;=&nbsp;0.5R'&nbsp;-&nbsp;0.4598G'&nbsp;-&nbsp;0.0402B'</para>
 	  </listitem>
@@ -1039,7 +1039,7 @@ clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range
 	<varlistentry>
       	  <term>Luma:</term>
 	  <listitem>
-            <para>Yc'&nbsp;=&nbsp;(0.2627R&nbsp;+&nbsp;0.6789G&nbsp;+&nbsp;0.0593B)'</para>
+            <para>Yc'&nbsp;=&nbsp;(0.2627R&nbsp;+&nbsp;0.6780G&nbsp;+&nbsp;0.0593B)'</para>
 	  </listitem>
 	</varlistentry>
       </variablelist>
@@ -1047,7 +1047,7 @@ clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range
 	<varlistentry>
       	  <term>B'&nbsp;-&nbsp;Yc'&nbsp;&le;&nbsp;0:</term>
 	  <listitem>
-            <para>Cbc&nbsp;=&nbsp;(B'&nbsp;-&nbsp;Y')&nbsp;/&nbsp;1.9404</para>
+            <para>Cbc&nbsp;=&nbsp;(B'&nbsp;-&nbsp;Yc')&nbsp;/&nbsp;1.9404</para>
 	  </listitem>
 	</varlistentry>
       </variablelist>
@@ -1055,7 +1055,7 @@ clamped to the range [-0.5&hellip;0.5]. The Y'CbCr quantization is limited range
 	<varlistentry>
       	  <term>B'&nbsp;-&nbsp;Yc'&nbsp;&gt;&nbsp;0:</term>
 	  <listitem>
-            <para>Cbc&nbsp;=&nbsp;(B'&nbsp;-&nbsp;Y')&nbsp;/&nbsp;1.5816</para>
+            <para>Cbc&nbsp;=&nbsp;(B'&nbsp;-&nbsp;Yc')&nbsp;/&nbsp;1.5816</para>
 	  </listitem>
 	</varlistentry>
       </variablelist>
