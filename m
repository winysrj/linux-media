Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:37232 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab2IKLMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 07:12:05 -0400
Date: Tue, 11 Sep 2012 14:11:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
	Sean Young <sean@mess.org>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] rc-core: fix return codes in ir_lirc_ioctl()
Message-ID: <20120911111153.GB22259@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These should be -ENOSYS because not -EINVAL.

Reported-by: Sean Young <sean@mess.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 6ad4a07..c0dc1b9 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -203,13 +203,13 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	/* TX settings */
 	case LIRC_SET_TRANSMITTER_MASK:
 		if (!dev->s_tx_mask)
-			return -EINVAL;
+			return -ENOSYS;
 
 		return dev->s_tx_mask(dev, val);
 
 	case LIRC_SET_SEND_CARRIER:
 		if (!dev->s_tx_carrier)
-			return -EINVAL;
+			return -ENOSYS;
 
 		return dev->s_tx_carrier(dev, val);
 
