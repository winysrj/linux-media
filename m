Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44452 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025AbbCHHyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Mar 2015 03:54:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] DocBook media: BT.2020 RGB uses limited quantization range
Date: Sun,  8 Mar 2015 08:53:31 +0100
Message-Id: <1425801213-14230-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
References: <1425801213-14230-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

In contrast to all other colorspaces, the BT.2020 colorspace uses
limited range R'G'B' quantization as the default.

This was incorrected documented, so fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/pixfmt.xml | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
index f2175f0..56bdd24 100644
--- a/Documentation/DocBook/media/v4l/pixfmt.xml
+++ b/Documentation/DocBook/media/v4l/pixfmt.xml
@@ -483,8 +483,8 @@ is the Y'CbCr encoding identifier (&v4l2-ycbcr-encoding;) to specify non-standar
 Y'CbCr encodings and the third is the quantization identifier (&v4l2-quantization;)
 to specify non-standard quantization methods. Most of the time only the colorspace
 field of &v4l2-pix-format; or &v4l2-pix-format-mplane; needs to be filled in. Note
-that the default R'G'B' quantization is always full range for all colorspaces,
-so this won't be mentioned explicitly for each colorspace description.</para>
+that the default R'G'B' quantization is full range for all colorspaces except for
+BT.2020 which uses limited range R'G'B' quantization.</para>
 
     <table pgwide="1" frame="none" id="v4l2-colorspace">
       <title>V4L2 Colorspaces</title>
@@ -598,7 +598,8 @@ so this won't be mentioned explicitly for each colorspace description.</para>
 	  <row>
 	    <entry><constant>V4L2_QUANTIZATION_DEFAULT</constant></entry>
 	    <entry>Use the default quantization encoding as defined by the colorspace.
-This is always full range for R'G'B' and usually limited range for Y'CbCr.</entry>
+This is always full range for R'G'B' (except for the BT.2020 colorspace) and usually
+limited range for Y'CbCr.</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_QUANTIZATION_FULL_RANGE</constant></entry>
@@ -967,8 +968,8 @@ SMPTE 170M/BT.601. The Y'CbCr quantization is limited range.</para>
       <title id="col-bt2020">Colorspace BT.2020 (<constant>V4L2_COLORSPACE_BT2020</constant>)</title>
       <para>The <xref linkend="itu2020" /> standard defines the colorspace used by Ultra-high definition
 television (UHDTV). The default Y'CbCr encoding is <constant>V4L2_YCBCR_ENC_BT2020</constant>.
-The default Y'CbCr quantization is limited range. The chromaticities of the primary colors and
-the white reference are:</para>
+The default R'G'B' quantization is limited range (!), and so is the default Y'CbCr quantization.
+The chromaticities of the primary colors and the white reference are:</para>
       <table frame="none">
         <title>BT.2020 Chromaticities</title>
         <tgroup cols="3" align="left">
-- 
2.1.4

