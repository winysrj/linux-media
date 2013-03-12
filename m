Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3CLSkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 14:40:06 -0400
Message-ID: <513F769D.6040306@infradead.org>
Date: Tue, 12 Mar 2013 11:40:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Linux Kernel Development <linux-kernel@vger.kernel.org>,
	Janne Grunau <j@jannau.net>,
	linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] media: fix hdpvr build warning
References: <alpine.DEB.2.00.1303112254140.16847@ayla.of.borg>
In-Reply-To: <alpine.DEB.2.00.1303112254140.16847@ayla.of.borg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix build warning in hdpvr:

drivers/media/usb/hdpvr/hdpvr-video.c: warning: "CONFIG_I2C_MODULE" is not defined [-Wundef]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Janne Grunau <j@jannau.net>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-39-rc2.orig/drivers/media/usb/hdpvr/hdpvr-video.c
+++ lnx-39-rc2/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -1238,7 +1238,7 @@ static void hdpvr_device_release(struct
 	v4l2_device_unregister(&dev->v4l2_dev);
 
 	/* deregister I2C adapter */
-#if defined(CONFIG_I2C) || (CONFIG_I2C_MODULE)
+#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 	mutex_lock(&dev->i2c_mutex);
 	i2c_del_adapter(&dev->i2c_adapter);
 	mutex_unlock(&dev->i2c_mutex);
