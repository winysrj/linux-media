Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:52075 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752293AbdJHSSy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 8 Oct 2017 14:18:54 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: rc: check for integer overflow
Date: Sun,  8 Oct 2017 19:18:52 +0100
Message-Id: <20171008181852.10973-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ioctl LIRC_SET_REC_TIMEOUT would set a timeout of 704ns if called
with a timeout of 4294968us.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index bd046c41a53a..8f2f37412fc5 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -298,11 +298,14 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!dev->max_timeout)
 			return -ENOTTY;
 
+		/* Check for multiply overflow */
+		if (val > U32_MAX / 1000)
+			return -EINVAL;
+
 		tmp = val * 1000;
 
-		if (tmp < dev->min_timeout ||
-		    tmp > dev->max_timeout)
-				return -EINVAL;
+		if (tmp < dev->min_timeout || tmp > dev->max_timeout)
+			return -EINVAL;
 
 		if (dev->s_timeout)
 			ret = dev->s_timeout(dev, tmp);
-- 
2.13.6
