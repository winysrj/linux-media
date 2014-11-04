Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40734 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbaKDANX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 19:13:23 -0500
Date: Tue, 4 Nov 2014 02:13:19 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Gulsah Kose <gulsah.1004@gmail.com>,
	Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
	Matina Maria Trompouki <mtrompou@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: lirc: replace dev_err by pr_err
Message-ID: <20141104001319.GA14567@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch replaces dev_err by pr_err since the value
of ir is NULL when the message is displayed.

Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 11a7cb1..ecdd71e 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1633,7 +1633,7 @@ out_put_xx:
 out_put_ir:
 	put_ir_device(ir, true);
 out_no_ir:
-	dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
+	pr_err("%s: probing IR %s on %s (i2c-%d) failed with %d\n",
 		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
 		   ret);
 	mutex_unlock(&ir_devices_lock);
-- 
1.9.3

