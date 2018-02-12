Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59427 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932525AbeBLPCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 10:02:13 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] media: rc: remove useless if statement
Date: Mon, 12 Feb 2018 15:02:10 +0000
Message-Id: <20180212150211.28355-4-sean@mess.org>
In-Reply-To: <20180212150211.28355-1-sean@mess.org>
References: <20180212150211.28355-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ret is always 0, so remove if statement.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 645fe9c9367f..b25dcff71791 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -568,7 +568,7 @@ static long ir_lirc_ioctl(struct file *file, unsigned int cmd,
 				ret = -EINVAL;
 			else if (dev->s_timeout)
 				ret = dev->s_timeout(dev, tmp);
-			else if (!ret)
+			else
 				dev->timeout = tmp;
 		}
 		break;
-- 
2.14.3
