Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28874 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab2HGQm4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Aug 2012 12:42:56 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 06/11] radio-shark2: use %*ph to print small buffers
Date: Tue,  7 Aug 2012 19:43:06 +0300
Message-Id: <1344357792-18202-6-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1344357792-18202-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/radio/radio-shark2.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index b9575de..90aecfb 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -100,12 +100,8 @@ static int shark_write_reg(struct radio_tea5777 *tea, u64 reg)
 	for (i = 0; i < 6; i++)
 		shark->transfer_buffer[i + 1] = (reg >> (40 - i * 8)) & 0xff;
 
-	v4l2_dbg(1, debug, tea->v4l2_dev,
-		 "shark2-write: %02x %02x %02x %02x %02x %02x %02x\n",
-		 shark->transfer_buffer[0], shark->transfer_buffer[1],
-		 shark->transfer_buffer[2], shark->transfer_buffer[3],
-		 shark->transfer_buffer[4], shark->transfer_buffer[5],
-		 shark->transfer_buffer[6]);
+	v4l2_dbg(1, debug, tea->v4l2_dev, "shark2-write: %*ph\n",
+		 7, shark->transfer_buffer);
 
 	res = usb_interrupt_msg(shark->usbdev,
 				usb_sndintpipe(shark->usbdev, SHARK_OUT_EP),
@@ -148,9 +144,8 @@ static int shark_read_reg(struct radio_tea5777 *tea, u32 *reg_ret)
 	for (i = 0; i < 3; i++)
 		reg |= shark->transfer_buffer[i] << (16 - i * 8);
 
-	v4l2_dbg(1, debug, tea->v4l2_dev, "shark2-read: %02x %02x %02x\n",
-		 shark->transfer_buffer[0], shark->transfer_buffer[1],
-		 shark->transfer_buffer[2]);
+	v4l2_dbg(1, debug, tea->v4l2_dev, "shark2-read: %*ph\n",
+		 3, shark->transfer_buffer);
 
 	*reg_ret = reg;
 	return 0;
-- 
1.7.10.4

