Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:48629 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab2F0OKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 10:10:04 -0400
Received: from epcpsbgm2.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M6A00JCC4OGCI10@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jun 2012 23:10:02 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M6A008NR4OC4950@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Jun 2012 23:09:56 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] Revert "[media] V4L: JPEG class documentation corrections"
Date: Wed, 27 Jun 2012 16:09:44 +0200
Message-id: <1340806186-6484-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit feed0258e11e04b7e0, as the same issues
are already covered in another version of that patch that
was also applied (579e92ffac65c717c9c8a50feb755a).

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml           |    2 +-
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml |    7 -------
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 676bc46..cda0dfb 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3988,7 +3988,7 @@ interface and may change in the future.</para>
 	    from RGB to Y'CbCr color space.
 	    </entry>
 	  </row>
-	  <row id = "v4l2-jpeg-chroma-subsampling">
+	  <row>
 	    <entrytbl spanname="descr" cols="2">
 	      <tbody valign="top">
 		<row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
index e3d5afcd..0a4b90f 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml
@@ -284,14 +284,6 @@ These controls are described in <xref
 	    processing controls. These controls are described in <xref
 	    linkend="image-process-controls" />.</entry>
 	  </row>
-	  <row>
-	    <entry><constant>V4L2_CTRL_CLASS_JPEG</constant></entry>
-	    <entry>0x9d0000</entry>
-	    <entry>The class containing JPEG compression controls.
-These controls are described in <xref
-		linkend="jpeg-controls" />.</entry>
-	  </row>
 	</tbody>
       </tgroup>
     </table>
--
1.7.10

