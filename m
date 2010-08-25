Return-path: <mchehab@pedra>
Received: from mailout4.samsung.com ([203.254.224.34]:20312 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0HYIs3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 04:48:29 -0400
Received: from epmmp1 (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0L7P00BQU9SQC2C0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Aug 2010 17:48:26 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0L7P0094Y9SQBQ@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 25 Aug 2010 17:48:26 +0900 (KST)
Date: Wed, 25 Aug 2010 17:48:47 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 1/3] radio-si470x: Fix setting of de-emphasis
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, tobias.lorenz@gmx.net,
	kyungmin.park@samsung.com
Message-id: <1282726129-28408-1-git-send-email-jy0922.shim@samsung.com>
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The de-emphasis should be setted if requested by module parameter
instead of always setting de-emphasis.

Reported-by: Tobias Lorenz <tobias.lorenz@gmx.net>
Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 9927a59..7585566 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -357,7 +357,7 @@ int si470x_start(struct si470x_device *radio)
 		goto done;
 
 	/* sysconfig 1 */
-	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
+	radio->registers[SYSCONFIG1] = (de << 11) & SYSCONFIG1_DE;	/* DE */
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		goto done;
-- 
1.7.0.4

