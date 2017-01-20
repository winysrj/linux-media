Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:33359 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752070AbdATNIl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 08:08:41 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/4] [media] lirc: LIRC_GET_MIN_TIMEOUT should be in range
Date: Fri, 20 Jan 2017 13:08:37 +0000
Message-Id: <825547a1b0dc22cf56f9557085f93bb7791e5641.1484916689.git.sean@mess.org>
In-Reply-To: <cover.1484916689.git.sean@mess.org>
References: <cover.1484916689.git.sean@mess.org>
In-Reply-To: <cover.1484916689.git.sean@mess.org>
References: <cover.1484916689.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIRC_SET_REC_TIMEOUT can fail if the value returned by
LIRC_GET_MIN_TIMEOUT is set due to rounding errors.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index e944507..8517d51 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -279,7 +279,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	case LIRC_GET_MIN_TIMEOUT:
 		if (!dev->max_timeout)
 			return -ENOSYS;
-		val = dev->min_timeout / 1000;
+		val = DIV_ROUND_UP(dev->min_timeout, 1000);
 		break;
 
 	case LIRC_GET_MAX_TIMEOUT:
-- 
2.9.3

