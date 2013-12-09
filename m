Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab3LINQJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 08:16:09 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, hverkuil@xs4all.nl, avnd.kiran@samsung.com,
	posciak@chromium.org, arunkk.samsung@gmail.com
Subject: [PATCH] CHROMIUM: s5p-mfc: add controls to set vp8 enc profile
Date: Mon,  9 Dec 2013 18:46:00 +0530
Message-Id: <1386594961-17803-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add v4l2 controls to set desired profile for VP8 encoder.
Acceptable levels for VP8 encoder are
0: Version 0
1: Version 1
2: Version 2
3: Version 3

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
This patch is rebased over another VP8 control patch from me:
https://linuxtv.org/patch/20733/
---
 Documentation/DocBook/media/v4l/controls.xml    |    9 +++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   11 +++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    6 ++----
 drivers/media/v4l2-core/v4l2-ctrls.c            |    8 ++++++++
 include/uapi/linux/v4l2-controls.h              |    1 +
 6 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index e4db4ac..c1f7544 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3193,6 +3193,15 @@ V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD as a golden frame.</entry>
 	      <row><entry spanname="descr">Quantization parameter for a P frame for VP8.</entry>
 	      </row>
 
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_PROFILE</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Select the desired profile for VP8 encoder.
+Acceptable values are 0, 1, 2 and 3 corresponding to encoder versions 0, 1, 2 and 3.</entry>
+	      </row>
+
           <row><entry></entry></row>
         </tbody>
       </tgroup>
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index d91f757..797e61d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -426,6 +426,7 @@ struct s5p_mfc_vp8_enc_params {
 	u8 rc_max_qp;
 	u8 rc_frame_qp;
 	u8 rc_p_frame_qp;
+	u8 profile;
 };
 
 /**
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 33e8ae3..ec0581c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -650,6 +650,14 @@ static struct mfc_control controls[] = {
 		.step = 1,
 		.default_value = 10,
 	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_PROFILE,
+		.type = V4L2_CTRL_TYPE_INTEGER_MENU,
+		.minimum = 0,
+		.maximum = 3,
+		.step = 1,
+		.default_value = 0,
+	},
 };
 
 #define NUM_CTRLS ARRAY_SIZE(controls)
@@ -1601,6 +1609,9 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:
 		p->codec.vp8.rc_p_frame_qp = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
+		p->codec.vp8.profile = ctrl->val;
+		break;
 	default:
 		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
 							ctrl->id, ctrl->val);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index b4886d6..f6ff2db 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1197,10 +1197,8 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 	reg |= ((p->num_b_frame & 0x3) << 16);
 	WRITEL(reg, S5P_FIMV_E_GOP_CONFIG_V6);
 
-	/* profile & level */
-	reg = 0;
-	/** profile */
-	reg |= (0x1 << 4);
+	/* profile - 0 ~ 3 */
+	reg = p_vp8->profile & 0x3;
 	WRITEL(reg, S5P_FIMV_E_PICTURE_PROFILE_V6);
 
 	/* rate control config. */
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 20840df..5069dd2 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -575,11 +575,17 @@ const s64 *v4l2_ctrl_get_int_menu(u32 id, u32 *len)
 		1, 2, 3,
 	};
 
+	static const s64 qmenu_int_vpx_profile[] = {
+		0, 1, 2, 3,
+	};
+
 	switch (id) {
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:
 		return __v4l2_qmenu_int_len(qmenu_int_vpx_num_partitions, len);
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES:
 		return __v4l2_qmenu_int_len(qmenu_int_vpx_num_ref_frames, len);
+	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
+		return __v4l2_qmenu_int_len(qmenu_int_vpx_profile, len);
 	default:
 		*len = 0;
 		return NULL;
@@ -749,6 +755,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_MAX_QP:			return "VPX Maximum QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:		return "VPX I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
@@ -978,6 +985,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_AUTO_EXPOSURE_BIAS:
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_REF_FRAMES:
+	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
 		*type = V4L2_CTRL_TYPE_INTEGER_MENU;
 		break;
 	case V4L2_CID_USER_CLASS:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 5b9dfc8..9970a9d 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -558,6 +558,7 @@ enum v4l2_vp8_golden_frame_sel {
 #define V4L2_CID_MPEG_VIDEO_VPX_MAX_QP			(V4L2_CID_MPEG_BASE+508)
 #define V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP		(V4L2_CID_MPEG_BASE+509)
 #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
+#define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
 
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
-- 
1.7.9.5

