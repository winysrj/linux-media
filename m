Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:10272 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0HYIsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 04:48:35 -0400
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0L7P00C3P9SQSLD0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Aug 2010 17:48:26 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0L7P00KYW9SQMG@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Aug 2010 17:48:26 +0900 (KST)
Date: Wed, 25 Aug 2010 17:48:49 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 3/3] radio-si470x: Fix error handling of si470x i2c driver
In-reply-to: <1282726129-28408-1-git-send-email-jy0922.shim@samsung.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <1282726129-28408-3-git-send-email-jy0922.shim@samsung.com>
Content-transfer-encoding: 7BIT
References: <1282726129-28408-1-git-send-email-jy0922.shim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

We should go to err_video instead of err_all if this error is occured
when probed.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 67a4ec8..4ce541a 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -395,7 +395,7 @@ static int __devinit si470x_i2c_probe(struct i2c_client *client,
 	radio->registers[POWERCFG] = POWERCFG_ENABLE;
 	if (si470x_set_register(radio, POWERCFG) < 0) {
 		retval = -EIO;
-		goto err_all;
+		goto err_video;
 	}
 	msleep(110);
 
-- 
1.7.0.4

