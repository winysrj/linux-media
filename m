Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:55261 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763249AbdDSNCC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Apr 2017 09:02:02 -0400
From: Luis Oliveira <Luis.Oliveira@synopsys.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org,
        rvarsha016@gmail.com, alan@linux.intel.com, arnd@arndb.de,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Luis.Oliveira@synopsys.com
Subject: [PATCH] staging: media: atomisp: fix misspelled word in comment
Date: Wed, 19 Apr 2017 13:44:28 +0100
Message-Id: <b4d3c8e3b25de07e4886ad786c3cfeb9a6df4180.1492605314.git.lolivei@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fix "overrided", the correct past tense form of "override" is
"overridden".

Signed-off-by: Luis Oliveira <lolivei@synopsys.com>
---
 drivers/staging/media/atomisp/i2c/ov2680.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.c b/drivers/staging/media/atomisp/i2c/ov2680.c
index c08dd0b18fbb..566091035c64 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.c
+++ b/drivers/staging/media/atomisp/i2c/ov2680.c
@@ -1122,7 +1122,7 @@ static int ov2680_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	/*recall flip functions to avoid flip registers
-	 * were overrided by default setting
+	 * were overridden by default setting
 	 */
 	if (h_flag)
 		ov2680_h_flip(sd, h_flag);
-- 
2.11.0
