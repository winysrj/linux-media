Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:44891 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZKRGVU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 01:21:20 -0500
Received: from epmmp2 (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KTA006XTKBO99@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Nov 2009 15:21:25 +0900 (KST)
Received: from TNRNDGASPAPP1.tn.corp.samsungelectronics.net ([165.213.149.150])
 by mmp2.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KTA001NUKBO7X@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Nov 2009 15:21:24 +0900 (KST)
Date: Wed, 18 Nov 2009 15:21:25 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH 1/3] radio-si470x: fix SYSCONFIG1 register set on si470x_start()
To: linux-media@vger.kernel.org
Cc: tobias.lorenz@gmx.net, mchehab@infradead.org,
	kyungmin.park@samsung.com
Message-id: <4B039265.1020906@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should use the or operation to set value to the SYSCONFIG1 register
on si470x_start().

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index f33315f..09f631a 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -357,7 +357,7 @@ int si470x_start(struct si470x_device *radio)
 		goto done;
 
 	/* sysconfig 1 */
-	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
+	radio->registers[SYSCONFIG1] |= SYSCONFIG1_DE;
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		goto done;
-- 
1.6.0.4
