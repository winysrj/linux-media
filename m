Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46557 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933995AbeFVPeJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:34:09 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH 28/32] media: camss: csid: Different format support on source pad
Date: Fri, 22 Jun 2018 18:33:37 +0300
Message-Id: <1529681621-9682-29-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
References: <1529681621-9682-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Usually the format on the source pad is the same as on the sink pad.
However the CSID is able to do some format conversions. To support
this make the format on the source pad selectable amongst a list
of formats. This list can be different for each sink pad format.
This is still not used but will be when the format conversions
are implemented.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-csid.c | 65 ++++++++++++++++++++------
 1 file changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-csid.c b/drivers/media/platform/qcom/camss/camss-csid.c
index 18420e3..9cfef98 100644
--- a/drivers/media/platform/qcom/camss/camss-csid.c
+++ b/drivers/media/platform/qcom/camss/camss-csid.c
@@ -300,6 +300,43 @@ static const struct csid_format csid_formats_8x96[] = {
 	}
 };
 
+static u32 csid_find_code(u32 *code, unsigned int n_code,
+			  unsigned int index, u32 req_code)
+{
+	int i;
+
+	if (!req_code && (index >= n_code))
+		return 0;
+
+	for (i = 0; i < n_code; i++)
+		if (req_code) {
+			if (req_code == code[i])
+				return req_code;
+		} else {
+			if (i == index)
+				return code[i];
+		}
+
+	return code[0];
+}
+
+static u32 csid_src_pad_code(struct csid_device *csid, u32 sink_code,
+			     unsigned int index, u32 src_req_code)
+{
+	if (csid->camss->version == CAMSS_8x16)
+		return sink_code;
+	else if (csid->camss->version == CAMSS_8x96)
+		switch (sink_code) {
+		default:
+			if (index > 0)
+				return 0;
+
+			return sink_code;
+		}
+	else
+		return 0;
+}
+
 static const struct csid_format *csid_get_fmt_entry(
 					const struct csid_format *formats,
 					unsigned int nformat,
@@ -667,15 +704,15 @@ static void csid_try_format(struct csid_device *csid,
 
 	case MSM_CSID_PAD_SRC:
 		if (csid->testgen_mode->cur.val == 0) {
-			/* Test generator is disabled, keep pad formats */
-			/* in sync - set and return a format same as sink pad */
-			struct v4l2_mbus_framefmt format;
+			/* Test generator is disabled, */
+			/* keep pad formats in sync */
+			u32 code = fmt->code;
 
-			format = *__csid_get_format(csid, cfg,
-						    MSM_CSID_PAD_SINK, which);
-			*fmt = format;
+			*fmt = *__csid_get_format(csid, cfg,
+						      MSM_CSID_PAD_SINK, which);
+			fmt->code = csid_src_pad_code(csid, fmt->code, 0, code);
 		} else {
-			/* Test generator is enabled, set format on source*/
+			/* Test generator is enabled, set format on source */
 			/* pad to allow test generator usage */
 
 			for (i = 0; i < csid->nformats; i++)
@@ -709,7 +746,6 @@ static int csid_enum_mbus_code(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct csid_device *csid = v4l2_get_subdevdata(sd);
-	struct v4l2_mbus_framefmt *format;
 
 	if (code->pad == MSM_CSID_PAD_SINK) {
 		if (code->index >= csid->nformats)
@@ -718,13 +754,16 @@ static int csid_enum_mbus_code(struct v4l2_subdev *sd,
 		code->code = csid->formats[code->index].code;
 	} else {
 		if (csid->testgen_mode->cur.val == 0) {
-			if (code->index > 0)
-				return -EINVAL;
+			struct v4l2_mbus_framefmt *sink_fmt;
 
-			format = __csid_get_format(csid, cfg, MSM_CSID_PAD_SINK,
-						   code->which);
+			sink_fmt = __csid_get_format(csid, cfg,
+						     MSM_CSID_PAD_SINK,
+						     code->which);
 
-			code->code = format->code;
+			code->code = csid_src_pad_code(csid, sink_fmt->code,
+						       code->index, 0);
+			if (!code->code)
+				return -EINVAL;
 		} else {
 			if (code->index >= csid->nformats)
 				return -EINVAL;
-- 
2.7.4
