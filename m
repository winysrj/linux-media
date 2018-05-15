Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47921 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751104AbeEOTXW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 15:23:22 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: cec-pin-error-inj: avoid a false-positive Spectre detection
Date: Tue, 15 May 2018 15:23:16 -0400
Message-Id: <0f7f4af7c48bb59973fcfb5978eaff1454f0bfdf.1526412194.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current logic makes Smatch to false-detect a Spectre variant 1
vulnerability. The problem is that it initializes an u32 indirectly
from user space input.

After trying to write a fixup, after a while I realized that, in
practice, this shouldn't be a problem, as an u32 is initialized
from u8, but it took some time to discover it.

So, do some code cleanup to make it clearer for both humans
and machines about the valid range for "op".

Fix this warning:
	drivers/media/cec/cec-pin-error-inj.c:170 cec_pin_error_inj_parse_line() warn: potential spectre issue 'pin->error_inj_args'

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/cec/cec-pin-error-inj.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/cec/cec-pin-error-inj.c b/drivers/media/cec/cec-pin-error-inj.c
index 7132a2758bd3..c0088d3b8e3d 100644
--- a/drivers/media/cec/cec-pin-error-inj.c
+++ b/drivers/media/cec/cec-pin-error-inj.c
@@ -81,10 +81,9 @@ bool cec_pin_error_inj_parse_line(struct cec_adapter *adap, char *line)
 	u64 *error;
 	u8 *args;
 	bool has_op;
-	u32 op;
+	u8 op;
 	u8 mode;
 	u8 pos;
-	u8 v;
 
 	p = skip_spaces(p);
 	token = strsep(&p, delims);
@@ -146,12 +145,18 @@ bool cec_pin_error_inj_parse_line(struct cec_adapter *adap, char *line)
 	comma = strchr(token, ',');
 	if (comma)
 		*comma++ = '\0';
-	if (!strcmp(token, "any"))
-		op = CEC_ERROR_INJ_OP_ANY;
-	else if (!kstrtou8(token, 0, &v))
-		op = v;
-	else
+	if (!strcmp(token, "any")) {
+		has_op = false;
+		error = pin->error_inj + CEC_ERROR_INJ_OP_ANY;
+		args = pin->error_inj_args[CEC_ERROR_INJ_OP_ANY];
+	} else if (!kstrtou8(token, 0, &op)) {
+		has_op = true;
+		error = pin->error_inj + op;
+		args = pin->error_inj_args[op];
+	} else {
 		return false;
+	}
+
 	mode = CEC_ERROR_INJ_MODE_ONCE;
 	if (comma) {
 		if (!strcmp(comma, "off"))
@@ -166,10 +171,6 @@ bool cec_pin_error_inj_parse_line(struct cec_adapter *adap, char *line)
 			return false;
 	}
 
-	error = pin->error_inj + op;
-	args = pin->error_inj_args[op];
-	has_op = op <= 0xff;
-
 	token = strsep(&p, delims);
 	if (p) {
 		p = skip_spaces(p);
-- 
2.17.0
