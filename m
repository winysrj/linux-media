Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38025 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbeI2Rxt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 13:53:49 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: zoran: fix spelling mistake "queing" -> "queuing"
Date: Sat, 29 Sep 2018 12:25:39 +0100
Message-Id: <20180929112539.9667-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in kernel warning message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/media/zoran/zoran_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/zoran/zoran_driver.c b/drivers/staging/media/zoran/zoran_driver.c
index e30c3ef31a9b..27c76e2eeb41 100644
--- a/drivers/staging/media/zoran/zoran_driver.c
+++ b/drivers/staging/media/zoran/zoran_driver.c
@@ -692,7 +692,7 @@ static int zoran_jpg_queue_frame(struct zoran_fh *fh, int num,
 		case BUZ_STATE_DONE:
 			dprintk(2,
 				KERN_WARNING
-				"%s: %s - queing frame in BUZ_STATE_DONE state!?\n",
+				"%s: %s - queuing frame in BUZ_STATE_DONE state!?\n",
 				ZR_DEVNAME(zr), __func__);
 			/* fall through */
 		case BUZ_STATE_USER:
-- 
2.17.1
