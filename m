Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2422 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaGZQDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Jul 2014 12:03:09 -0400
Message-ID: <53D3D133.7000103@xs4all.nl>
Date: Sat, 26 Jul 2014 18:02:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Subject: [PATCH for v3.17] v4l2-ctrls: fix rounding calculation
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 958c7c7e65 ("[media] v4l2-ctrls: fix corner case in round-to-range code") broke
controls that use a negative range.

The cause was a s32/u32 mixup: ctrl->step is unsigned while all others are signed. So
the result type of the expression '(ctrl)->maximum - ((ctrl)->step / 2)' became unsigned,
making 'val >= (ctrl)->maximum - ((ctrl)->step / 2)' true, since '((u32)-128) > 128'
(if val = -128, maximum = 128 and step = 1).

So carefully cast (step / 2) to s32.

There was one cast of step to s32 where it should have been u32 because both offset and
step are unsigned, so casting to signed makes no sense there. You do need a cast to u32
there, because otherwise architectures that have no 64-bit division start complaining
(step is a u64).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Frank Schäfer <fschaefer.oss@googlemail.com>

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 2d8ced8..9d0c7a1 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1347,14 +1347,14 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 ({								\
 	offset_type offset;					\
 	if ((ctrl)->maximum >= 0 &&				\
-	    val >= (ctrl)->maximum - ((ctrl)->step / 2))	\
+	    val >= (ctrl)->maximum - (s32)((ctrl)->step / 2))	\
 		val = (ctrl)->maximum;				\
 	else							\
-		val += (ctrl)->step / 2;			\
+		val += (s32)((ctrl)->step / 2);			\
 	val = clamp_t(typeof(val), val,				\
 		      (ctrl)->minimum, (ctrl)->maximum);	\
 	offset = (val) - (ctrl)->minimum;			\
-	offset = (ctrl)->step * (offset / (s32)(ctrl)->step);	\
+	offset = (ctrl)->step * (offset / (u32)(ctrl)->step);	\
 	val = (ctrl)->minimum + offset;				\
 	0;							\
 })
@@ -1376,10 +1376,10 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		 * the u64 divide that needs special care.
 		 */
 		val = ptr.p_s64[idx];
-		if (ctrl->maximum >= 0 && val >= ctrl->maximum - ctrl->step / 2)
+		if (ctrl->maximum >= 0 && val >= ctrl->maximum - (s64)(ctrl->step / 2))
 			val = ctrl->maximum;
 		else
-			val += ctrl->step / 2;
+			val += (s64)(ctrl->step / 2);
 		val = clamp_t(s64, val, ctrl->minimum, ctrl->maximum);
 		offset = val - ctrl->minimum;
 		do_div(offset, ctrl->step);
