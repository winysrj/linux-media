Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay112.isp.belgacom.be ([195.238.20.139]:8183 "EHLO
        mailrelay112.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753848AbdA3S5N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 13:57:13 -0500
From: Fabian Frederick <fabf@skynet.be>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-media@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 04/14] m5mols: use atomic_dec_not_zero()
Date: Mon, 30 Jan 2017 19:54:37 +0100
Message-Id: <20170130185437.22692-1-fabf@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

instead of atomic_add_unless(value, -1, 0)

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index acb804b..3aab2ca 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -337,7 +337,7 @@ int m5mols_wait_interrupt(struct v4l2_subdev *sd, u8 irq_mask, u32 timeout)
 	struct m5mols_info *info = to_m5mols(sd);
 
 	int ret = wait_event_interruptible_timeout(info->irq_waitq,
-				atomic_add_unless(&info->irq_done, -1, 0),
+				atomic_dec_not_zero(&info->irq_done),
 				msecs_to_jiffies(timeout));
 	if (ret <= 0)
 		return ret ? ret : -ETIMEDOUT;
-- 
2.9.3

