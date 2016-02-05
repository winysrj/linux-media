Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbcBEQG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 11:06:28 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Inki Dae <inki.dae@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH 3/6] [media] saa7134: unconditionlally update TV standard at demod
Date: Fri,  5 Feb 2016 14:04:57 -0200
Message-Id: <e1c9b331d76c79a1ef4e20edf93776e5298e0839.1454688188.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1454688187.git.mchehab@osg.samsung.com>
References: <cover.1454688187.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It doesn't make any sense to only update the TV standard for TV,
as composite and S-Video inputs also need it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/saa7134/saa7134-video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index ae52ef019e43..59781755247a 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -479,8 +479,7 @@ void saa7134_set_tvnorm_hw(struct saa7134_dev *dev)
 {
 	saa7134_set_decoder(dev);
 
-	if (card_in(dev, dev->ctl_input).tv)
-		saa_call_all(dev, video, s_std, dev->tvnorm->id);
+	saa_call_all(dev, video, s_std, dev->tvnorm->id);
 	/* Set the correct norm for the saa6752hs. This function
 	   does nothing if there is no saa6752hs. */
 	saa_call_empress(dev, video, s_std, dev->tvnorm->id);
-- 
2.5.0


