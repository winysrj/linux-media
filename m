Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.logicpd.com ([174.46.170.145]:38051 "HELO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751641AbbCTUcv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 16:32:51 -0400
From: Tim Nordell <tim.nordell@logicpd.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <sakari.ailus@iki.fi>,
	Tim Nordell <tim.nordell@logicpd.com>
Subject: [PATCH] OMAP3 ISP: Support top and bottom fields
Date: Fri, 20 Mar 2015 15:32:20 -0500
Message-ID: <1426883540-19936-1-git-send-email-tim.nordell@logicpd.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The OMAP3ISP can selectively stream either the top or bottom
field by setting the start line vertical field to a high value
for the field that one doesn't want to stream.  The driver
can switch between these utilizing the vertical start feature
of the CCDC.

Additionally, we need to ensure that the FLDMODE bit is set
when we're doing this as we need to differentiate between
the two frames.

Signed-off-by: Tim Nordell <tim.nordell@logicpd.com>
---
 drivers/media/platform/omap3isp/ispccdc.c  | 29 +++++++++++++++++++++++++++--
 drivers/media/platform/omap3isp/ispvideo.c |  4 ++--
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 882ebde..beb8d96 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1131,6 +1131,7 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 	unsigned int sph;
 	u32 syn_mode;
 	u32 ccdc_pattern;
+	int slv0, slv1;
 
 	ccdc->bt656 = false;
 	ccdc->fields = 0;
@@ -1237,11 +1238,27 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
 		nph = crop->width - 1;
 	}
 
+	/* Default the start vertical line offset to the crop point */
+	slv0 = slv1 = crop->top;
+
+	/* When streaming just the top or bottom field, enable processing
+	 * of the field input signal so that SLV1 is processed.
+	 */
+	if (ccdc->formats[CCDC_PAD_SINK].field == V4L2_FIELD_ALTERNATE) {
+		if (format->field == V4L2_FIELD_TOP) {
+			slv1 = 0x7FFF;
+			syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+		} else if (format->field == V4L2_FIELD_BOTTOM) {
+			slv0 = 0x7FFF;
+			syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+		}
+	}
+
 	isp_reg_writel(isp, (sph << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
 		       (nph << ISPCCDC_HORZ_INFO_NPH_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
-	isp_reg_writel(isp, (crop->top << ISPCCDC_VERT_START_SLV0_SHIFT) |
-		       (crop->top << ISPCCDC_VERT_START_SLV1_SHIFT),
+	isp_reg_writel(isp, (slv0 << ISPCCDC_VERT_START_SLV0_SHIFT) |
+		       (slv1 << ISPCCDC_VERT_START_SLV1_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
 	isp_reg_writel(isp, (crop->height - 1)
 			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
@@ -2064,6 +2081,14 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 			fmt->height *= 2;
 		}
 
+		/* When input format is interlaced with alternating fields the
+		 * CCDC can pick out just the top or bottom field.
+		 */
+		 if (fmt->field == V4L2_FIELD_ALTERNATE &&
+		   (field == V4L2_FIELD_TOP ||
+		    field == V4L2_FIELD_BOTTOM))
+			fmt->field = field;
+
 		break;
 
 	case CCDC_PAD_SOURCE_VP:
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index bbbe55d..e636168 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -797,12 +797,12 @@ isp_video_set_format(struct file *file, void *fh, struct v4l2_format *format)
 		/* Fall-through */
 	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_TOP:
+	case V4L2_FIELD_BOTTOM:
 		/* Interlaced orders are only supported at the CCDC output. */
 		if (video != &video->isp->isp_ccdc.video_out)
 			format->fmt.pix.field = V4L2_FIELD_NONE;
 		break;
-	case V4L2_FIELD_TOP:
-	case V4L2_FIELD_BOTTOM:
 	case V4L2_FIELD_SEQ_TB:
 	case V4L2_FIELD_SEQ_BT:
 	default:
-- 
2.0.4

