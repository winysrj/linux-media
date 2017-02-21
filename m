Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:43479 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753545AbdBUUnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:47 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 03/19] [media] lirc: return ENOTTY when device does support ioctl
Date: Tue, 21 Feb 2017 20:43:27 +0000
Message-Id: <2645cbc79fdadc2cfa0bb935b1ccf7941c0337e8.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
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
