Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway16.websitewelcome.com ([67.18.44.28]:52979 "EHLO
	gateway16.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449AbaB1Wvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Feb 2014 17:51:38 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway16.websitewelcome.com (Postfix) with ESMTP id F25438704A7AA
	for <linux-media@vger.kernel.org>; Fri, 28 Feb 2014 16:19:57 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, kbuild@01.org, dan.carpenter@oracle.com,
	m.chehab@samsung.com, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: urgent memory leak fix.
Date: Fri, 28 Feb 2014 14:19:44 -0800
Message-Id: <1393625984-4276-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Critical bug fix.  Fixes memory leak introduced by 
commit 47d8c881c304642a68d398b87d9e8846e643c81a.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>

---
 drivers/media/usb/s2255/s2255drv.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index ef66b1b..4964194 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2175,11 +2175,6 @@ static int s2255_stop_acquire(struct s2255_vc *vc)
 
 	mutex_lock(&dev->cmdlock);
 	chn_rev = G_chnmap[vc->idx];
-	buffer = kzalloc(512, GFP_KERNEL);
-	if (buffer == NULL) {
-		dev_err(&dev->udev->dev, "out of mem\n");
-		return -ENOMEM;
-	}
 	/* send the stop command */
 	buffer[0] = IN_DATA_TOKEN;
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
-- 
1.7.9.5

