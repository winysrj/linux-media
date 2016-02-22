Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35763 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbcBVOQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 09:16:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>
Subject: [PATCH 4/5] [media] saa7134: fix detection of external decoders
Date: Mon, 22 Feb 2016 11:16:22 -0300
Message-Id: <149191ee963b3e785d4e50e80656507b65d1ea9f.1456150537.git.mchehab@osg.samsung.com>
In-Reply-To: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
References: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
In-Reply-To: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
References: <72ef5fcae1ee23265c796b0cacd64ee41b9b9301.1456150537.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/saa7134/saa7134-core.c:840 saa7134_create_entities() info: ignoring unreachable code.
	drivers/media/pci/saa7134/saa7134-core.c:843 saa7134_create_entities() warn: curly braces intended?

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/saa7134/saa7134-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 42bc4172febd..8f3ba4077130 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -838,9 +838,10 @@ static void saa7134_create_entities(struct saa7134_dev *dev)
 
 	/* Check if it is using an external analog TV demod */
 	media_device_for_each_entity(entity, dev->media_dev) {
-		if (entity->function == MEDIA_ENT_F_ATV_DECODER)
+		if (entity->function == MEDIA_ENT_F_ATV_DECODER) {
 			decoder = entity;
 			break;
+		}
 	}
 
 	/*
-- 
2.5.0

