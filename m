Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52809 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753051AbdGCJ0n (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 05:26:43 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [media] media/i2c/saa717x: fix spelling mistake: "implementd" -> "implemented"
Date: Mon,  3 Jul 2017 10:26:39 +0100
Message-Id: <20170703092639.11068-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in v4l2_dbg debug message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/saa717x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index e1f6bc219c64..102467e00fb3 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -1069,7 +1069,7 @@ static int saa717x_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
 	struct saa717x_state *decoder = to_state(sd);
 
 	v4l2_dbg(1, debug, sd, "decoder set norm ");
-	v4l2_dbg(1, debug, sd, "(not yet implementd)\n");
+	v4l2_dbg(1, debug, sd, "(not yet implemented)\n");
 
 	decoder->radio = 0;
 	decoder->std = std;
-- 
2.11.0
