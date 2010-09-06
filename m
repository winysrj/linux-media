Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22574 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab0IFGxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Sep 2010 02:53:55 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L8B00MORCHTIK@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:53 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8B009HBCHS9N@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 06 Sep 2010 07:53:53 +0100 (BST)
Date: Mon, 06 Sep 2010 08:53:50 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 8/8] v4l: radio: si470x: fix unneeded free_irq() call
In-reply-to: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	p.osciak@samsung.com, s.nawrocki@samsung.com,
	Tobias Lorenz <tobias.lorenz@gmx.net>,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Douglas Schilling Landgraf <dougsland@redhat.com>,
	Jean Delvare <khali@linux-fr.org>
Message-id: <1283756030-28634-9-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1283756030-28634-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

In case of error during probe() the driver calls free_irq() function
on not yet allocated irq. This patches fixes the call sequence in case of
the error.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
CC: Tobias Lorenz <tobias.lorenz@gmx.net>
CC: Joonyoung Shim <jy0922.shim@samsung.com>
CC: Douglas Schilling Landgraf <dougsland@redhat.com>
CC: Jean Delvare <khali@linux-fr.org>
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
1.7.2.2

