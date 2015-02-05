Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp66.ord1c.emailsrvr.com ([108.166.43.66]:53097 "EHLO
	smtp66.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756990AbbBEKWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2015 05:22:07 -0500
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kiran.padwal21@gmail.com,
	Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH] [media] s5k5baf: Add missing error check for devm_kzalloc
Date: Thu,  5 Feb 2015 15:39:10 +0530
Message-Id: <1423130950-3922-1-git-send-email-kiran.padwal@smartplayin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add a missing a check on the return value of devm_kzalloc,
which would cause a NULL pointer dereference in a OOM situation.

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/media/i2c/s5k5baf.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 60a74d8..156b975 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -374,6 +374,8 @@ static int s5k5baf_fw_parse(struct device *dev, struct s5k5baf_fw **fw,
 	count -= S5K5BAG_FW_TAG_LEN;
 
 	d = devm_kzalloc(dev, count * sizeof(u16), GFP_KERNEL);
+	if (!d)
+		return -ENOMEM;
 
 	for (i = 0; i < count; ++i)
 		d[i] = le16_to_cpu(data[i]);
-- 
1.7.9.5

