Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32929 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752111AbdDIBeq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:34:46 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/12] [media] bt8xx: use setup_timer
Date: Sun,  9 Apr 2017 09:33:59 +0800
Message-Id: <58e541f945714d8c6cb72140e60787bde0354ad2.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index fb4aefb..ed319f1 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4043,9 +4043,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
 	INIT_LIST_HEAD(&btv->capture);
 	INIT_LIST_HEAD(&btv->vcapture);
 
-	init_timer(&btv->timeout);
-	btv->timeout.function = bttv_irq_timeout;
-	btv->timeout.data     = (unsigned long)btv;
+	setup_timer(&btv->timeout, bttv_irq_timeout, (unsigned long)btv);
 
 	btv->i2c_rc = -1;
 	btv->tuner_type  = UNSET;
-- 
2.9.3
