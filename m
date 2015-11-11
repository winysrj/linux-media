Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbbKKLte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 06:49:34 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Meredith <andrew@anvil.org>,
	Warren Sturm <warren.sturm@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 1/2] Revert "[media] ivtv: avoid going past input/audio array"
Date: Wed, 11 Nov 2015 09:48:37 -0200
Message-Id: <93fa669548266b15798131e0f5875bd85306caf4.1447242435.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch broke ivtv logic, as reported at
 https://bugzilla.redhat.com/show_bug.cgi?id=1278942

This reverts commit 09290cc885937cab3b2d60a6d48fe3d2d3e04061.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 3a6f668b14b8..21501c560610 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -805,11 +805,11 @@ static void ivtv_init_struct2(struct ivtv *itv)
 {
 	int i;
 
-	for (i = 0; i < IVTV_CARD_MAX_VIDEO_INPUTS - 1; i++)
+	for (i = 0; i < IVTV_CARD_MAX_VIDEO_INPUTS; i++)
 		if (itv->card->video_inputs[i].video_type == 0)
 			break;
 	itv->nof_inputs = i;
-	for (i = 0; i < IVTV_CARD_MAX_AUDIO_INPUTS - 1; i++)
+	for (i = 0; i < IVTV_CARD_MAX_AUDIO_INPUTS; i++)
 		if (itv->card->audio_inputs[i].audio_type == 0)
 			break;
 	itv->nof_audio_inputs = i;
-- 
2.4.3


