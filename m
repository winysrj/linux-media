Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49964 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754103AbdKCGlN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 02:41:13 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Leon Luo <leonl@leopardimaging.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: imx274: fix missing return assignment from call to imx274_mode_regs
Date: Fri,  3 Nov 2017 06:41:06 +0000
Message-Id: <20171103064106.25593-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The variable ret is being checked for failure however it is not being set
from the return status from the call to imx274_mode_regs. Currently ret is
alwayus zero and the check is redundant. Fix this by assigning it.

Detected by CoverityScan, CID#1460278 ("Logically dead code")

Fixes: 0985dd306f72 ("media: imx274: V4l2 driver for Sony imx274 CMOS sensor")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/i2c/imx274.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index ab6a5f31da74..800b9bf9cdd3 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1059,7 +1059,7 @@ static int imx274_s_stream(struct v4l2_subdev *sd, int on)
 
 	if (on) {
 		/* load mode registers */
-		imx274_mode_regs(imx274, imx274->mode_index);
+		ret = imx274_mode_regs(imx274, imx274->mode_index);
 		if (ret)
 			goto fail;
 
-- 
2.14.1
