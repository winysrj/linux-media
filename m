Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:47411 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2HPOQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 10:16:42 -0400
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00BMHQBMXWG0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 23:16:40 +0900 (KST)
Received: from amdc248.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0M8U00M9IQBDBOA0@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 23:16:40 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	HeungJun Kim <riverful.kim@samsung.com>
Subject: [PATCH] m5mols: Add missing free_irq() on error path
Date: Thu, 16 Aug 2012 16:16:09 +0200
Message-id: <1345126570-17919-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure the interrupt is freed when the driver probing fails.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: HeungJun Kim <riverful.kim@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/m5mols/m5mols_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index ac7d28b..8bf6599 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -931,7 +931,7 @@ static int __devinit m5mols_probe(struct i2c_client *client,

 	ret = m5mols_sensor_power(info, true);
 	if (ret)
-		goto out_me;
+		goto out_irq;

 	ret = m5mols_fw_start(sd);
 	if (!ret)
@@ -940,6 +940,8 @@ static int __devinit m5mols_probe(struct i2c_client *client,
 	m5mols_sensor_power(info, false);
 	if (!ret)
 		return 0;
+out_irq:
+	free_irq(client->irq, sd);
 out_me:
 	media_entity_cleanup(&sd->entity);
 out_reg:
--
1.7.11.3

