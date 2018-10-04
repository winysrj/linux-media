Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:48268 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727188AbeJDQBY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 12:01:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/5] adv7604: when the EDID is cleared, unconfigure CEC as well
Date: Thu,  4 Oct 2018 11:08:57 +0200
Message-Id: <20181004090900.32915-3-hverkuil@xs4all.nl>
In-Reply-To: <20181004090900.32915-1-hverkuil@xs4all.nl>
References: <20181004090900.32915-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When there is no EDID the CEC adapter should be unconfigured as
well. So call cec_phys_addr_invalidate() when this happens.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 668be2bca57a..3376d5cb05d5 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2284,8 +2284,10 @@ static int adv76xx_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		state->aspect_ratio.numerator = 16;
 		state->aspect_ratio.denominator = 9;
 
-		if (!state->edid.present)
+		if (!state->edid.present) {
 			state->edid.blocks = 0;
+			cec_phys_addr_invalidate(state->cec_adap);
+		}
 
 		v4l2_dbg(2, debug, sd, "%s: clear EDID pad %d, edid.present = 0x%x\n",
 				__func__, edid->pad, state->edid.present);
-- 
2.18.0
