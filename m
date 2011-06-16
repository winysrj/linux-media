Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:25452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab1FPUdZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2011 16:33:25 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5GKXPeT003955
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 16 Jun 2011 16:33:25 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] [media] saa7134: fix raw IR timeout value
Date: Thu, 16 Jun 2011 16:33:22 -0400
Message-Id: <1308256402-14892-1-git-send-email-jarod@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The comment says "wait 15ms", but the code says jiffies_to_msecs(15)
instead of msecs_to_jiffies(15). Fix that. Tested, works fine with both
rc5 and rc6 decode, in-kernel and via lirc userspace, with an HVR-1150.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/video/saa7134/saa7134-input.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index ff6c0e9..d4ee24b 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -963,7 +963,7 @@ static int saa7134_raw_decode_irq(struct saa7134_dev *dev)
 	 * to work with other protocols.
 	 */
 	if (!ir->active) {
-		timeout = jiffies + jiffies_to_msecs(15);
+		timeout = jiffies + msecs_to_jiffies(15);
 		mod_timer(&ir->timer, timeout);
 		ir->active = true;
 	}
-- 
1.7.1

