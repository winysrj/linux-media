Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62460 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2IPQAl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 12:00:41 -0400
Received: by wibhi8 with SMTP id hi8so1638690wib.1
        for <linux-media@vger.kernel.org>; Sun, 16 Sep 2012 09:00:40 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: hdegoede@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/4] v4l2-ctrl: add a control for green balance
Date: Sun, 16 Sep 2012 18:00:39 +0200
Message-Id: <1347811240-4000-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1347811240-4000-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We already support the red balance (V4L2_CID_RED_BALANCE) and
blue balance (V4L2_CID_BLUE_BALANCE) controls and lots of hardware
provides a possibility to adjust the green balance, too.
Several drivers already support this as custom controls, other just
don't do that due to the lack of a V4L2 standard control.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    5 +++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
 include/linux/videodev2.h                    |    4 +++-
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 272a5f7..dbb3b61 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -162,6 +162,11 @@ activated, keeps adjusting the white balance.</entry>
 	    <entry>Red chroma balance.</entry>
 	  </row>
 	  <row>
+	    <entry><constant>V4L2_CID_GREEN_BALANCE</constant></entry>
+	    <entry>integer</entry>
+	    <entry>Green chroma balance.</entry>
+	  </row>
+	  <row>
 	    <entry><constant>V4L2_CID_BLUE_BALANCE</constant></entry>
 	    <entry>integer</entry>
 	    <entry>Blue chroma balance.</entry>
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index ab287f2..39b9bb8 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -575,6 +575,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MIN_BUFFERS_FOR_OUTPUT:	return "Min Number of Output Buffers";
 	case V4L2_CID_ALPHA_COMPONENT:		return "Alpha Component";
 	case V4L2_CID_COLORFX_CBCR:		return "Color Effects, CbCr";
+	case V4L2_CID_GREEN_BALANCE:		return "Green Balance";
 
 	/* MPEG controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -941,6 +942,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_SATURATION:
 	case V4L2_CID_HUE:
 	case V4L2_CID_RED_BALANCE:
+	case V4L2_CID_GREEN_BALANCE:
 	case V4L2_CID_BLUE_BALANCE:
 	case V4L2_CID_GAMMA:
 	case V4L2_CID_SHARPNESS:
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 4862165..72354ad 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1390,8 +1390,10 @@ enum v4l2_colorfx {
 #define V4L2_CID_ALPHA_COMPONENT		(V4L2_CID_BASE+41)
 #define V4L2_CID_COLORFX_CBCR			(V4L2_CID_BASE+42)
 
+#define V4L2_CID_GREEN_BALANCE			(V4L2_CID_BASE+43)
+
 /* last CID + 1 */
-#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+43)
+#define V4L2_CID_LASTP1                         (V4L2_CID_BASE+44)
 
 /*  MPEG-class control IDs defined by V4L2 */
 #define V4L2_CID_MPEG_BASE 			(V4L2_CTRL_CLASS_MPEG | 0x900)
-- 
1.7.7

