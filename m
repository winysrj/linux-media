Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57176 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab3KOF3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 00:29:14 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v2] [media] s5p-mfc: Add QP setting support for vp8 encoder
Date: Fri, 15 Nov 2013 10:59:22 +0530
Message-Id: <1384493362-29322-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds v4l2 controls to set MIN, MAX QP values and
I, P frame QP for vp8 encoder.

Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
Changes from v1:
- Removed the valid range from documentation as suggested by Hans.
  http://www.mail-archive.com/linux-media@vger.kernel.org/msg68352.html
---
 Documentation/DocBook/media/v4l/controls.xml    |   32 +++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    4 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   44 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   20 +++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c            |    4 +++
 include/uapi/linux/v4l2-controls.h              |    4 +++
 6 files changed, 108 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 7a3b49b..e4db4ac 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3161,6 +3161,38 @@ V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD as a golden frame.</entry>
 		</entrytbl>
 	      </row>
 
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_MIN_QP</constant></entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Minimum quantization parameter for VP8.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_MAX_QP</constant></entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Maximum quantization parameter for VP8.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Quantization parameter for an I frame for VP8.</entry>
+	      </row>
+
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP</constant>&nbsp;</entry>
+		<entry>integer</entry>
+	      </row>
+	      <row><entry spanname="descr">Quantization parameter for a P frame for VP8.</entry>
+	      </row>
+
           <row><entry></entry></row>
         </tbody>
       </tgroup>
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 6920b54..d91f757 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -422,6 +422,10 @@ struct s5p_mfc_vp8_enc_params {
 	enum v4l2_vp8_golden_frame_sel golden_frame_sel;
 	u8 hier_layer;
 	u8 hier_layer_qp[3];
+	u8 rc_min_qp;
+	u8 rc_max_qp;
+	u8 rc_frame_qp;
+	u8 rc_p_frame_qp;
 };
 
 /**
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4ff3b6c..33e8ae3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -618,6 +618,38 @@ static struct mfc_control controls[] = {
 		.default_value = V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV,
 		.menu_skip_mask = 0,
 	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_MAX_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 127,
+		.step = 1,
+		.default_value = 127,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_MIN_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 11,
+		.step = 1,
+		.default_value = 0,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 127,
+		.step = 1,
+		.default_value = 10,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.minimum = 0,
+		.maximum = 127,
+		.step = 1,
+		.default_value = 10,
+	},
 };
 
 #define NUM_CTRLS ARRAY_SIZE(controls)
@@ -1557,6 +1589,18 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:
 		p->codec.vp8.golden_frame_sel = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_MIN_QP:
+		p->codec.vp8.rc_min_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_MAX_QP:
+		p->codec.vp8.rc_max_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:
+		p->codec.vp8.rc_frame_qp = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:
+		p->codec.vp8.rc_p_frame_qp = ctrl->val;
+		break;
 	default:
 		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
 							ctrl->id, ctrl->val);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 461358c..b4886d6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1218,6 +1218,26 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 		WRITEL(reg, S5P_FIMV_E_RC_FRAME_RATE_V6);
 	}
 
+	/* frame QP */
+	reg &= ~(0x7F);
+	reg |= p_vp8->rc_frame_qp & 0x7F;
+	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
+
+	/* other QPs */
+	WRITEL(0x0, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	if (!p->rc_frame && !p->rc_mb) {
+		reg = 0;
+		reg |= ((p_vp8->rc_p_frame_qp & 0x7F) << 8);
+		reg |= p_vp8->rc_frame_qp & 0x7F;
+		WRITEL(reg, S5P_FIMV_E_FIXED_PICTURE_QP_V6);
+	}
+
+	/* max QP */
+	reg = ((p_vp8->rc_max_qp & 0x7F) << 8);
+	/* min QP */
+	reg |= p_vp8->rc_min_qp & 0x7F;
+	WRITEL(reg, S5P_FIMV_E_RC_QP_BOUND_V6);
+
 	/* vbv buffer size */
 	if (p->frame_skip_mode ==
 			V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT) {
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 60dcc0f..99a89ad 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -745,6 +745,10 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_FILTER_SHARPNESS:		return "VPX Deblocking Effect Control";
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD:	return "VPX Golden Frame Refresh Period";
 	case V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_SEL:		return "VPX Golden Frame Indicator";
+	case V4L2_CID_MPEG_VIDEO_VPX_MIN_QP:			return "VPX Minimum QP Value";
+	case V4L2_CID_MPEG_VIDEO_VPX_MAX_QP:			return "VPX Maximum QP Value";
+	case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:		return "VPX I-Frame QP Value";
+	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 1666aab..5b9dfc8 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -554,6 +554,10 @@ enum v4l2_vp8_golden_frame_sel {
 	V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_PREV		= 0,
 	V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_USE_REF_PERIOD	= 1,
 };
+#define V4L2_CID_MPEG_VIDEO_VPX_MIN_QP			(V4L2_CID_MPEG_BASE+507)
+#define V4L2_CID_MPEG_VIDEO_VPX_MAX_QP			(V4L2_CID_MPEG_BASE+508)
+#define V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP		(V4L2_CID_MPEG_BASE+509)
+#define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
 
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
-- 
1.7.9.5

