Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:42820 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2KRPNN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 10:13:13 -0500
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 3/7] ir-rx51: Move platform data checking into probe function
Date: Sun, 18 Nov 2012 17:13:05 +0200
Message-Id: <1353251589-26143-4-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
References: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is useless without proper platform data. If data is not
available, we should not register the driver at all. Once this check
is done, the BUG_ON check during device open is no longer needed.

Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
---
 drivers/media/rc/ir-rx51.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index f22e5e4..16b3c1f 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -378,7 +378,6 @@ static long lirc_rx51_ioctl(struct file *filep,
 static int lirc_rx51_open(struct inode *inode, struct file *file)
 {
 	struct lirc_rx51 *lirc_rx51 = lirc_get_pdata(file);
-	BUG_ON(!lirc_rx51);
 
 	file->private_data = lirc_rx51;
 
@@ -458,6 +457,9 @@ static int lirc_rx51_resume(struct platform_device *dev)
 
 static int __devinit lirc_rx51_probe(struct platform_device *dev)
 {
+	if (!dev->dev.platform_data)
+		return -ENODEV;
+
 	lirc_rx51_driver.features = LIRC_RX51_DRIVER_FEATURES;
 	lirc_rx51.pdata = dev->dev.platform_data;
 	lirc_rx51.pwm_timer_num = lirc_rx51.pdata->pwm_timer;
-- 
1.8.0

