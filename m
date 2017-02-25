Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36035 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751799AbdBYLvp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 06:51:45 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 03/19] [media] lirc: return ENOTTY when device does support ioctl
Date: Sat, 25 Feb 2017 11:51:18 +0000
Message-Id: <c23056a80d503c787f3090d805ce2b7e2766af3b.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If timeouts or carrier range is not supported, return proper error.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 637b583..235d74a 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -253,6 +253,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 					       val);
 
 	case LIRC_SET_REC_CARRIER_RANGE:
+		if (!dev->s_rx_carrier_range)
+			return -ENOTTY;
+
 		if (val <= 0)
 			return -EINVAL;
 
@@ -305,6 +308,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		break;
 
 	case LIRC_SET_REC_TIMEOUT_REPORTS:
+		if (!dev->timeout)
+			return -ENOTTY;
+
 		lirc->send_timeout_reports = !!val;
 		break;
 
-- 
2.9.3
