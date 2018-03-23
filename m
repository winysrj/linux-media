Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44888 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753996AbeCWL5Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>
Subject: [PATCH 12/30] media: solo6x10: simplify the logic at solo_p2m_dma_desc()
Date: Fri, 23 Mar 2018 07:56:58 -0400
Message-Id: <0df305eb50e5dc447ddb9eab71bc7394cb9e76e4.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic with gets a p2m_id is more complex than needed,
causing false positives with static analyzers:

	drivers/media/pci/solo6x10/solo6x10-p2m.c:81 solo_p2m_dma_desc() error: buffer overflow 'solo_dev->p2m_dev' 4 <= s32max

Make it simpler and use unsigned int.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/solo6x10/solo6x10-p2m.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-p2m.c b/drivers/media/pci/solo6x10/solo6x10-p2m.c
index 8c8484674d2f..46c30430e30b 100644
--- a/drivers/media/pci/solo6x10/solo6x10-p2m.c
+++ b/drivers/media/pci/solo6x10/solo6x10-p2m.c
@@ -69,14 +69,11 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev,
 	unsigned int timeout;
 	unsigned int config = 0;
 	int ret = 0;
-	int p2m_id = 0;
+	unsigned int p2m_id = 0;
 
 	/* Get next ID. According to Softlogic, 6110 has problems on !=0 P2M */
-	if (solo_dev->type != SOLO_DEV_6110 && multi_p2m) {
+	if (solo_dev->type != SOLO_DEV_6110 && multi_p2m)
 		p2m_id = atomic_inc_return(&solo_dev->p2m_count) % SOLO_NR_P2M;
-		if (p2m_id < 0)
-			p2m_id = -p2m_id;
-	}
 
 	p2m_dev = &solo_dev->p2m_dev[p2m_id];
 
-- 
2.14.3
