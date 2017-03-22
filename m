Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46028 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933288AbdCVQcM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 12:32:12 -0400
From: Colin King <colin.king@canonical.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Shuah Khan <shuah@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] usb: au0828: remove redundant code
Date: Wed, 22 Mar 2017 16:32:01 +0000
Message-Id: <20170322163201.30886-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for ret being non-zero is false as ret is always
zero, hence we have redundant dead code that can be removed.

Detected with CoverityScan, CID#112968 ("Constant' variable guards
dead code (DEADCODE)'")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/au0828/au0828-video.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 16f9125a985a..2a255bd32bb3 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -809,16 +809,9 @@ static void au0828_analog_stream_reset(struct au0828_dev *dev)
  */
 static int au0828_stream_interrupt(struct au0828_dev *dev)
 {
-	int ret = 0;
-
 	dev->stream_state = STREAM_INTERRUPT;
 	if (test_bit(DEV_DISCONNECTED, &dev->dev_state))
 		return -ENODEV;
-	else if (ret) {
-		set_bit(DEV_MISCONFIGURED, &dev->dev_state);
-		dprintk(1, "%s device is misconfigured!\n", __func__);
-		return ret;
-	}
 	return 0;
 }
 
-- 
2.11.0
