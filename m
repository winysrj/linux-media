Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:51311 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbbCSVuU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 17:50:20 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [RFC PATCH 2/6] [media] lirc: LIRC_[SG]ET_SEND_MODE should return -ENOSYS
Date: Thu, 19 Mar 2015 21:50:13 +0000
Message-Id: <f0607fde6ec1ad120f62a80c53b1d44c4d5f4d81.1426801061.git.sean@mess.org>
In-Reply-To: <cover.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
In-Reply-To: <cover.1426801061.git.sean@mess.org>
References: <cover.1426801061.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the device cannot transmit then -ENOSYS should be returned. Also clarify
that the ioctl should return modes, not features. The values happen to be
identical.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 98893a8..17fd956 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -207,12 +207,19 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	/* legacy support */
 	case LIRC_GET_SEND_MODE:
-		val = LIRC_CAN_SEND_PULSE & LIRC_CAN_SEND_MASK;
+		if (!(dev->lirc->features & LIRC_CAN_SEND_MASK))
+			return -ENOSYS;
+
+		val = LIRC_MODE_PULSE;
 		break;
 
 	case LIRC_SET_SEND_MODE:
-		if (val != (LIRC_MODE_PULSE & LIRC_CAN_SEND_MASK))
+		if (!(dev->lirc->features & LIRC_CAN_SEND_MASK))
+			return -ENOSYS;
+
+		if (val != LIRC_MODE_PULSE)
 			return -EINVAL;
+
 		return 0;
 
 	/* TX settings */
-- 
2.1.0

