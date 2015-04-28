Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59545 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030364AbbD1PoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:18 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 11/14] s5p_mfc: remove a dead code
Date: Tue, 28 Apr 2015 12:43:50 -0300
Message-Id: <a36e185fcb27d4e1278c295322c799b0d9d30433.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/platform/s5p-mfc/s5p_mfc.c:1340 s5p_mfc_runtime_resume() warn: this array is probably non-NULL. 'm_dev->alloc_ctx'

alloc_ctx can never be NULL, as it is embeeded inside the struct
s5p_mfc_dev.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8333fbc2fe96..1263d99d638e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1337,8 +1337,6 @@ static int s5p_mfc_runtime_resume(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct s5p_mfc_dev *m_dev = platform_get_drvdata(pdev);
 
-	if (!m_dev->alloc_ctx)
-		return 0;
 	atomic_set(&m_dev->pm.power, 1);
 	return 0;
 }
-- 
2.1.0

