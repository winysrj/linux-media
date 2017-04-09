Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36443 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752359AbdDIBf0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 21:35:26 -0400
From: Geliang Tang <geliangtang@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Wolfram Sang <wsa-dev@sang-engineering.com>,
        Sean Young <sean@mess.org>
Cc: Geliang Tang <geliangtang@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] [media] imon: use setup_timer
Date: Sun,  9 Apr 2017 09:34:08 +0800
Message-Id: <6083bff784d90ee208c7663c5aa34a1e8988d6e2.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
In-Reply-To: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use setup_timer() instead of init_timer() to simplify the code.

Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 drivers/media/rc/imon.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 89823d2..3489010 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2412,9 +2412,8 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 	mutex_lock(&ictx->lock);
 
 	if (ictx->display_type == IMON_DISPLAY_TYPE_VGA) {
-		init_timer(&ictx->ttimer);
-		ictx->ttimer.data = (unsigned long)ictx;
-		ictx->ttimer.function = imon_touch_display_timeout;
+		setup_timer(&ictx->ttimer, imon_touch_display_timeout,
+			    (unsigned long)ictx);
 	}
 
 	ictx->usbdev_intf1 = usb_get_dev(interface_to_usbdev(intf));
-- 
2.9.3
