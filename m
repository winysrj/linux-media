Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:61463 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab2DJUcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 16:32:12 -0400
Received: by wibhr17 with SMTP id hr17so3422678wib.1
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 13:32:11 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH v2] V4L: JPEG class documentation corrections
Date: Tue, 10 Apr 2012 22:31:31 +0200
Message-Id: <1334089891-4025-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1333187035-28340-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1333187035-28340-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

This patch fixes following compilation warning:
Error: no ID for constraint linkend: v4l2-jpeg-chroma-subsampling.

and adds missing JPEG control class at the Table A.58.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
Changes since v1:
 - jpeg-chroma-subsampling-control replaced with v4l2-jpeg-chroma-subsampling
   rather than adding new id

 Documentation/DocBook/media/v4l/controls.xml       |    2 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 +++++++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index b84f25e..aa1fb7f 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3476,7 +3476,7 @@ interface and may change in the future.</para>
 	    <entry spanname="id"><constant>V4L2_CID_JPEG_CHROMA_SUBSAMPLING</constant></entry>
 	    <entry>menu</entry>
 	  </row>
-	  <row id="jpeg-chroma-subsampling-control">
+	  <row id="v4l2-jpeg-chroma-subsampling">
 	    <entry spanname="descr">The chroma subsampling factors describe how
 	    each component of an input image is sampled, in respect to maximum
 	    sample rate in each spatial dimension. See <xref linkend="itu-t81"/>,
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index b17a7aa..27e20bc 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -265,6 +265,13 @@ These controls are described in <xref
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

