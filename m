Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031240AbbD1XGm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 19:06:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 12/13] zc3xx: remove dead code and uneeded gotos
Date: Tue, 28 Apr 2015 20:06:19 -0300
Message-Id: <cecc773111656fb5931319a7aeaf5248ab9fba85.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
References: <c40f617a2dc604b998f276803948c922ea1572ba.1430262315.git.mchehab@osg.samsung.com>
In-Reply-To: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
References: <7a73d61faf3046af216692dbf1473bafc645ed9f.1430262315.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/usb/gspca/zc3xx.c:5994 transfer_update() info: ignoring unreachable code.

That happens because there's a return that it is never called,
as the work queue runs an infinite loop, except when the device is
put to sleep or an error happens.

When an error happens, a break statement is enough to go out of
the loop. So, let's remove the goto, as break is the typical
instruction used to end a loop.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index 3762a045f744..c5d8ee6fa3c7 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -5942,23 +5942,23 @@ static void transfer_update(struct work_struct *work)
 	reg07 = 0;
 
 	good = 0;
-	for (;;) {
+	while (1) {
 		msleep(100);
 
 		/* To protect gspca_dev->usb_buf and gspca_dev->usb_err */
 		mutex_lock(&gspca_dev->usb_lock);
 #ifdef CONFIG_PM
 		if (gspca_dev->frozen)
-			goto err;
+			break;
 #endif
 		if (!gspca_dev->present || !gspca_dev->streaming)
-			goto err;
+			break;
 
 		/* Bit 0 of register 11 indicates FIFO overflow */
 		gspca_dev->usb_err = 0;
 		reg11 = reg_r(gspca_dev, 0x0011);
 		if (gspca_dev->usb_err)
-			goto err;
+			break;
 
 		change = reg11 & 0x01;
 		if (change) {				/* overflow */
@@ -5987,12 +5987,12 @@ static void transfer_update(struct work_struct *work)
 			gspca_dev->usb_err = 0;
 			reg_w(gspca_dev, reg07, 0x0007);
 			if (gspca_dev->usb_err)
-				goto err;
+				break;
 		}
 		mutex_unlock(&gspca_dev->usb_lock);
 	}
-	return;
-err:
+
+	/* Something went wrong. Unlock and return */
 	mutex_unlock(&gspca_dev->usb_lock);
 }
 
-- 
2.1.0

