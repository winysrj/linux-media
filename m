Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34332 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768305AbcHROfq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 10:35:46 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 09/12] [media] vivid: Local optimization
Date: Thu, 18 Aug 2016 16:33:35 +0200
Message-Id: <1471530818-7928-10-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Avoid duplicated clamps when possible.

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 7364ced09abc..ed37ae307cac 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -916,14 +916,18 @@ static void precalculate_color(struct tpg_data *tpg, int k)
 		if (!ycbcr_valid)
 			color_to_ycbcr(tpg, r, g, b, &y, &cb, &cr);
 
+		y >>= 4;
+		cb >>= 4;
+		cr >>= 4;
 		if (tpg->real_quantization == V4L2_QUANTIZATION_LIM_RANGE) {
-			y = clamp(y, 16 << 4, 235 << 4);
-			cb = clamp(cb, 16 << 4, 240 << 4);
-			cr = clamp(cr, 16 << 4, 240 << 4);
+			y = clamp(y, 16, 235);
+			cb = clamp(cb, 16, 240);
+			cr = clamp(cr, 16, 240);
+		} else {
+			y = clamp(y, 1, 254);
+			cb = clamp(cb, 1, 254);
+			cr = clamp(cr, 1, 254);
 		}
-		y = clamp(y >> 4, 1, 254);
-		cb = clamp(cb >> 4, 1, 254);
-		cr = clamp(cr >> 4, 1, 254);
 		switch (tpg->fourcc) {
 		case V4L2_PIX_FMT_YUV444:
 			y >>= 4;
-- 
2.8.1

