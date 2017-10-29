Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59610 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdJ2MvC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 08:51:02 -0400
From: Colin King <colin.king@canonical.com>
To: Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] mxl111sf: remove redundant assignment to index
Date: Sun, 29 Oct 2017 12:50:58 +0000
Message-Id: <20171029125058.5588-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable index is set to zero and then set to zero again
a few lines later in a for loop initialization. Remove the
redundant setting of index to zero. Cleans up the clang
warning:

drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:519:3: warning: Value
stored to 'index' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
index 0eb33e043079..a221bb8a12b4 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c
@@ -516,7 +516,6 @@ static int mxl111sf_i2c_hw_xfer_msg(struct mxl111sf_state *state,
 		   data required to program */
 		block_len = (msg->len / 8);
 		left_over_len = (msg->len % 8);
-		index = 0;
 
 		mxl_i2c("block_len %d, left_over_len %d",
 			block_len, left_over_len);
-- 
2.14.1
