Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:58852 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbcFCWe4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 3 Jun 2016 18:34:56 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: [PATCH] [media] radio-maxiradio: fix memory leak when device is removed
Date: Sat,  4 Jun 2016 01:33:06 +0300
Message-Id: <1464993186-9329-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Memory allocated for maxiradio device is not deallocated when
the device is removed.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/radio/radio-maxiradio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 70fd8e80198a..8253f79d5d75 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -183,6 +183,7 @@ static void maxiradio_remove(struct pci_dev *pdev)
 	outb(0, dev->io);
 	v4l2_device_unregister(v4l2_dev);
 	release_region(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
+	kfree(dev);
 }
 
 static struct pci_device_id maxiradio_pci_tbl[] = {
-- 
1.9.1

