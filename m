Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oln040092064060.outbound.protection.outlook.com ([40.92.64.60]:51896
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726179AbeKZCNC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Nov 2018 21:13:02 -0500
From: Jonas Karlman <jonas@kwiboo.se>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Jonas Karlman <jonas@kwiboo.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        "Paul Kocialkowski" <paul.kocialkowski@bootlin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        "Smitha T Murthy" <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media: v4l: Fix MPEG-2 slice Intra DC Precision validation
Date: Sun, 25 Nov 2018 15:21:42 +0000
Message-ID: <AM0PR03MB46764B5CB90B17825C56DFFFACD60@AM0PR03MB4676.eurprd03.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

intra_dc_precision is a 2-bit integer [1]
allow use of all valid options, 8 - 11 bits precision

[1] ISO/IEC 13818-2 Table 6-13

Fixes: c27bb30e7b6d ("media: v4l: Add definitions for MPEG-2 slice format and metadata")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>

---

 drivers/media/v4l2-core/v4l2-ctrls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 5f2b033a7a42..129a986fa7e1 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1636,7 +1636,8 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		switch (p_mpeg2_slice_params->picture.intra_dc_precision) {
 		case 0: /* 8 bits */
 		case 1: /* 9 bits */
-		case 11: /* 11 bits */
+		case 2: /* 10 bits */
+		case 3: /* 11 bits */
 			break;
 		default:
 			return -EINVAL;
-- 
2.19.1
