Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46493 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751974AbaKRFkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 00:40:40 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@xs4all.nl
Subject: [REVIEW PATCH v2 3/5] v4l: Add intput and output capability flags for native size setting
Date: Tue, 18 Nov 2014 07:40:18 +0200
Message-Id: <1416289220-32673-4-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
References: <1416289220-32673-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add input and output capability flags for setting native size of the device,
and document them.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 Documentation/DocBook/media/v4l/vidioc-enuminput.xml  |    8 ++++++++
 Documentation/DocBook/media/v4l/vidioc-enumoutput.xml |    8 ++++++++
 include/uapi/linux/videodev2.h                        |    2 ++
 3 files changed, 18 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
index 493a39a..603fece 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enuminput.xml
@@ -287,6 +287,14 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
 	    <entry>0x00000004</entry>
 	    <entry>This input supports setting the TV standard by using VIDIOC_S_STD.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_IN_CAP_NATIVE_SIZE</constant></entry>
+	    <entry>0x00000008</entry>
+	    <entry>This input supports setting the native size using
+	    the <constant>V4L2_SEL_TGT_NATIVE_SIZE</constant>
+	    selection target, see <xref
+	    linkend="v4l2-selections-common"/>.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
index 2654e09..773fb12 100644
--- a/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-enumoutput.xml
@@ -172,6 +172,14 @@ input/output interface to linux-media@vger.kernel.org on 19 Oct 2009.
 	    <entry>0x00000004</entry>
 	    <entry>This output supports setting the TV standard by using VIDIOC_S_STD.</entry>
 	  </row>
+	  <row>
+	    <entry><constant>V4L2_OUT_CAP_NATIVE_SIZE</constant></entry>
+	    <entry>0x00000008</entry>
+	    <entry>This output supports setting the native size using
+	    the <constant>V4L2_SEL_TGT_NATIVE_SIZE</constant>
+	    selection target, see <xref
+	    linkend="v4l2-selections-common"/>.</entry>
+	  </row>
 	</tbody>
       </tgroup>
     </table>
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1c2f84f..e445b48 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1249,6 +1249,7 @@ struct v4l2_input {
 #define V4L2_IN_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
 #define V4L2_IN_CAP_CUSTOM_TIMINGS	V4L2_IN_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_IN_CAP_STD			0x00000004 /* Supports S_STD */
+#define V4L2_IN_CAP_NATIVE_SIZE		0x00000008 /* Supports setting native size */
 
 /*
  *	V I D E O   O U T P U T S
@@ -1272,6 +1273,7 @@ struct v4l2_output {
 #define V4L2_OUT_CAP_DV_TIMINGS		0x00000002 /* Supports S_DV_TIMINGS */
 #define V4L2_OUT_CAP_CUSTOM_TIMINGS	V4L2_OUT_CAP_DV_TIMINGS /* For compatibility */
 #define V4L2_OUT_CAP_STD		0x00000004 /* Supports S_STD */
+#define V4L2_OUT_CAP_NATIVE_SIZE	0x00000008 /* Supports setting native size */
 
 /*
  *	C O N T R O L S
-- 
1.7.10.4

