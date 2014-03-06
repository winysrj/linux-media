Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42550 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaCFGDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 01:03:49 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: [PATCH] [media] s5p-mfc: Add a control for IVF format for VP8 encoder
Date: Thu,  6 Mar 2014 11:33:39 +0530
Message-Id: <1394085820-3784-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

Add a control to enable/disable IVF output stream format for VP8 encode.
Set the IVF format output to disabled as default.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 Documentation/DocBook/media/v4l/controls.xml    |    8 ++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   11 +++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    2 ++
 drivers/media/v4l2-core/v4l2-ctrls.c            |    1 +
 include/uapi/linux/v4l2-controls.h              |    1 +
 6 files changed, 24 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 0e1770c..07fb64a 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3222,6 +3222,14 @@ V4L2_CID_MPEG_VIDEO_VPX_GOLDEN_FRAME_REF_PERIOD as a golden frame.</entry>
 Acceptable values are 0, 1, 2 and 3 corresponding to encoder profiles 0, 1, 2 and 3.</entry>
 	      </row>
 
+	      <row><entry></entry></row>
+	      <row>
+		<entry spanname="id"><constant>V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT</constant>&nbsp;</entry>
+		<entry>boolean</entry>
+	      </row>
+	      <row><entry spanname="descr">Outputs the VP8 encoded stream in IVF file format.</entry>
+	      </row>
+
           <row><entry></entry></row>
         </tbody>
       </tgroup>
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 5c28cc3..4d17df9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -418,6 +418,7 @@ struct s5p_mfc_vp8_enc_params {
 	u8 rc_frame_qp;
 	u8 rc_p_frame_qp;
 	u8 profile;
+	bool ivf;
 };
 
 /**
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index df83cd1..a67913e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -676,6 +676,14 @@ static struct mfc_control controls[] = {
 		.step = 1,
 		.default_value = 0,
 	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT,
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.minimum = 0,
+		.maximum = 1,
+		.step = 1,
+		.default_value = 0,
+	},
 };
 
 #define NUM_CTRLS ARRAY_SIZE(controls)
@@ -1636,6 +1644,9 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:
 		p->codec.vp8.profile = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT:
+		p->codec.vp8.ivf = ctrl->val;
+		break;
 	default:
 		v4l2_err(&dev->v4l2_dev, "Invalid control, id=%d, val=%d\n",
 							ctrl->id, ctrl->val);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index f64621a..90edb19 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1243,6 +1243,8 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 
 	/* VP8 specific params */
 	reg = 0;
+	/* Bit set to 1 disables IVF stream format. */
+	reg |= p_vp8->ivf ? 0 : (0x1 << 12);
 	reg |= (p_vp8->imd_4x4 & 0x1) << 10;
 	switch (p_vp8->num_partitions) {
 	case V4L2_CID_MPEG_VIDEO_VPX_1_PARTITION:
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e9e12c4..19e78df 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -752,6 +752,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:		return "VPX I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
+	case V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT:		return "VPX Output stream in IVF format";
 
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in videodev2.h! */
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index cda6fa0..b2763d6 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -565,6 +565,7 @@ enum v4l2_vp8_golden_frame_sel {
 #define V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP		(V4L2_CID_MPEG_BASE+509)
 #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
 #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
+#define V4L2_CID_MPEG_VIDEO_VPX_IVF_FORMAT		(V4L2_CID_MPEG_BASE+512)
 
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
-- 
1.7.9.5

