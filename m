Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1324 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaGRIPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 04:15:30 -0400
Received: from tschai.lan (209.80-203-20.nextgentel.com [80.203.20.209] (may be forged))
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id s6I8FRHG084381
	for <linux-media@vger.kernel.org>; Fri, 18 Jul 2014 10:15:29 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id B80CF2A1FD1
	for <linux-media@vger.kernel.org>; Fri, 18 Jul 2014 10:15:26 +0200 (CEST)
Message-ID: <53C8D799.2040102@xs4all.nl>
Date: Fri, 18 Jul 2014 10:15:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [PATCH for v3.17] v4l2-ctrls: fix corner case in round-to-range code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If you have a maximum that is at the limit of what the type supports,
and the step is > 1, then you can get wrap-around errors since the
code assumes that the maximum that the type supports is
ctrl->maximum + ctrl->step / 2.

In practice this is always fine, but in artificially crafted ranges
you will hit this bug. Since this is core code it should just work.

This bug has always been there but since it doesn't cause problems in
practice it was never noticed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 8552c83..849bee0 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1295,11 +1295,19 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 	}
 }
 
-/* Round towards the closest legal value */
+/*
+ * Round towards the closest legal value. Be careful when we are
+ * close to the maximum range of the control type to prevent
+ * wrap-arounds.
+ */
 #define ROUND_TO_RANGE(val, offset_type, ctrl)			\
 ({								\
 	offset_type offset;					\
-	val += (ctrl)->step / 2;				\
+	if ((ctrl)->maximum >= 0 &&				\
+	    val >= (ctrl)->maximum - ((ctrl)->step / 2))	\
+		val = (ctrl)->maximum;				\
+	else							\
+		val += (ctrl)->step / 2;			\
 	val = clamp_t(typeof(val), val,				\
 		      (ctrl)->minimum, (ctrl)->maximum);	\
 	offset = (val) - (ctrl)->minimum;			\
@@ -1325,7 +1333,10 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		 * the u64 divide that needs special care.
 		 */
 		val = ptr.p_s64[idx];
-		val += ctrl->step / 2;
+		if (ctrl->maximum >= 0 && val >= ctrl->maximum - ctrl->step / 2)
+			val = ctrl->maximum;
+		else
+			val += ctrl->step / 2;
 		val = clamp_t(s64, val, ctrl->minimum, ctrl->maximum);
 		offset = val - ctrl->minimum;
 		do_div(offset, ctrl->step);
-- 
2.0.0

