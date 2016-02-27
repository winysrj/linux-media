Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16600 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbcB0Kqi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 05:46:38 -0500
Date: Sat, 27 Feb 2016 13:46:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] [media] saa7134: Fix analog TV demod detection.
Message-ID: <20160227104616.GB14086@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a missing curly brace so we only look at the first item in the
list and then exit.

Fixes: ac90aa02d5b9 ('[media] saa7134: add media controller support')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 42bc417..8f3ba40 100644
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
