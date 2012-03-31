Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40012 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab2CaJoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Mar 2012 05:44:04 -0400
Received: by wgbdr13 with SMTP id dr13so1259193wgb.1
        for <linux-media@vger.kernel.org>; Sat, 31 Mar 2012 02:44:03 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] V4L: JPEG class documentation corrections
Date: Sat, 31 Mar 2012 11:43:55 +0200
Message-Id: <1333187035-28340-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fixes following compilation warning:
Error: no ID for constraint linkend: v4l2-jpeg-chroma-subsampling.

and adds missing JPEG control class at the Table A.58.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 Documentation/DocBook/media/v4l/controls.xml       |    2 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 582324f..8761e76 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3546,7 +3546,7 @@ interface and may change in the future.</para>
 	    from RGB to Y'CbCr color space.
 	    </entry>
 	  </row>
-	  <row>
+	  <row id = "v4l2-jpeg-chroma-subsampling">
 	    <entrytbl spanname="descr" cols="2">
 	      <tbody valign="top">
 		<row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index b17a7aa..27e20bc 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -265,7 +265,13 @@ These controls are described in <xref
 These controls are described in <xref
 		linkend="flash-controls" />.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_CTRL_CLASS_JPEG</constant></entry>
+	    <entry>0x9d0000</entry>
+	    <entry>The class containing JPEG compression controls.
+These controls are described in <xref
+		linkend="jpeg-controls" />.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
--
1.7.4.1

