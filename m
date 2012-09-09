Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:47570 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab2IIUcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2012 16:32:36 -0400
Date: Sun, 9 Sep 2012 23:31:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
	Sean Young <sean@mess.org>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Ben Hutchings <ben@decadent.org.uk>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] [media] rc-core: prevent divide by zero bug in
 s_tx_carrier()
Message-ID: <20120909203142.GA12296@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several of the drivers use carrier as a divisor in their s_tx_carrier()
functions.  We should do a sanity check here like we do for
LIRC_SET_REC_CARRIER.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Ben Hutchings pointed out that my first patch was not a complete
    fix.

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 6ad4a07..28dc0f0 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -211,6 +211,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		if (!dev->s_tx_carrier)
 			return -EINVAL;
 
+		if (val <= 0)
+			return -EINVAL;
+
 		return dev->s_tx_carrier(dev, val);
 
 	case LIRC_SET_SEND_DUTY_CYCLE:
