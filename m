Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:39958 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388102AbeGWMEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 08:04:46 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v3 11/35] media: camss: csid: Configure data type and decode format properly
Date: Mon, 23 Jul 2018 14:02:28 +0300
Message-Id: <1532343772-27382-12-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
References: <1532343772-27382-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSID decodes the input data stream. When the input comes from
the Test Generator the format of the stream is set on the source
media pad. When the input comes from the CSIPHY the format is the
one on the sink media pad. Use the proper format for each case.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index c0fef17..3cde07e 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -384,9 +384,6 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 		    !media_entity_remote_pad(&csid->pads[MSM_CSID_PAD_SINK]))
 			return -ENOLINK;
 
-		dt = csid_get_fmt_entry(csid->fmt[MSM_CSID_PAD_SRC].code)->
-								data_type;
-
 		if (tg->enabled) {
 			/* Config Test Generator */
 			struct v4l2_mbus_framefmt *f =
@@ -408,6 +405,9 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			writel_relaxed(val, csid->base +
 				       CAMSS_CSID_TG_DT_n_CGG_0(0));
 
+			dt = csid_get_fmt_entry(
+				csid->fmt[MSM_CSID_PAD_SRC].code)->data_type;
+
 			/* 5:0 data type */
 			val = dt;
 			writel_relaxed(val, csid->base +
@@ -417,6 +417,9 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 			val = tg->payload_mode;
 			writel_relaxed(val, csid->base +
 				       CAMSS_CSID_TG_DT_n_CGG_2(0));
+
+			df = csid_get_fmt_entry(
+				csid->fmt[MSM_CSID_PAD_SRC].code)->decode_format;
 		} else {
 			struct csid_phy_config *phy = &csid->phy;
 
@@ -431,13 +434,16 @@ static int csid_set_stream(struct v4l2_subdev *sd, int enable)
 
 			writel_relaxed(val,
 				       csid->base + CAMSS_CSID_CORE_CTRL_1);
+
+			dt = csid_get_fmt_entry(
+				csid->fmt[MSM_CSID_PAD_SINK].code)->data_type;
+			df = csid_get_fmt_entry(
+				csid->fmt[MSM_CSID_PAD_SINK].code)->decode_format;
 		}
 
 		/* Config LUT */
 
 		dt_shift = (cid % 4) * 8;
-		df = csid_get_fmt_entry(csid->fmt[MSM_CSID_PAD_SINK].code)->
-								decode_format;
 
 		val = readl_relaxed(csid->base + CAMSS_CSID_CID_LUT_VC_n(vc));
 		val &= ~(0xff << dt_shift);
-- 
2.7.4
