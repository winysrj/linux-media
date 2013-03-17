Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1055 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab3CQOJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 10:09:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [REVIEW PATCH] v4l2-ctrls: add V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER control
Date: Sun, 17 Mar 2013 15:09:21 +0100
Cc: Volokh Konstantin <volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303171509.21925.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This new control determines whether video sequence headers in an MPEG elementary
stream are repeated or not. Repeating them improves random access in the stream.

Added this since the go7007 support this feature. I've checked the MPEG-1/2/4
standards and it is a valid feature for all three.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/controls.xml |    6 ++++++
 drivers/media/v4l2-core/v4l2-ctrls.c         |    2 ++
 include/uapi/linux/v4l2-controls.h           |    1 +
 3 files changed, 9 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 9e8f854..b4952e2 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -2300,6 +2300,12 @@ Possible values are:</entry>
 	      </row>
 	      <row><entry></entry></row>
 	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row><row><entry spanname="descr">Repeat the video sequence headers. Repeating these
+headers makes random access to the video stream easier. Applicable to the MPEG1, 2 and 4 encoder.</entry>
+	      </row>
+	      <row>
 		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER</constant>&nbsp;</entry>
 		<entry>boolean</entry>
 	      </row><row><entry spanname="descr">Enabled the deblocking post processing filter for MPEG4 decoder.
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b36d1ec..f662df3 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -695,6 +695,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_DEC_PTS:			return "Video Decoder PTS";
 	case V4L2_CID_MPEG_VIDEO_DEC_FRAME:			return "Video Decoder Frame Count";
 	case V4L2_CID_MPEG_VIDEO_VBV_DELAY:			return "Initial Delay for VBV Control";
+	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -844,6 +845,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_H264_8X8_TRANSFORM:
 	case V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_ENABLE:
 	case V4L2_CID_MPEG_VIDEO_MPEG4_QPEL:
+	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 7eab0b9..844dc02 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -360,6 +360,7 @@ enum v4l2_mpeg_video_multi_slice_mode {
 #define V4L2_CID_MPEG_VIDEO_DEC_PTS			(V4L2_CID_MPEG_BASE+223)
 #define V4L2_CID_MPEG_VIDEO_DEC_FRAME			(V4L2_CID_MPEG_BASE+224)
 #define V4L2_CID_MPEG_VIDEO_VBV_DELAY			(V4L2_CID_MPEG_BASE+225)
+#define V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER		(V4L2_CID_MPEG_BASE+226)
 
 #define V4L2_CID_MPEG_VIDEO_H263_I_FRAME_QP		(V4L2_CID_MPEG_BASE+300)
 #define V4L2_CID_MPEG_VIDEO_H263_P_FRAME_QP		(V4L2_CID_MPEG_BASE+301)
-- 
1.7.10.4

