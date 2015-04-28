Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030443AbbD1Poe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:34 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 08/14] avoid going past input/audio array
Date: Tue, 28 Apr 2015 12:43:47 -0300
Message-Id: <f5d61bc605459af7274e70e73c60cba84f9a02b8.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/pci/ivtv/ivtv-driver.c:832 ivtv_init_struct2() error: buffer overflow 'itv->card->video_inputs' 6 <= 6

That happens because nof_inputs and nof_audio_inputs can be initialized
as IVTV_CARD_MAX_VIDEO_INPUTS, instead of IVTV_CARD_MAX_VIDEO_INPUTS - 1.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index c2e60b4f292d..8616fa8193bc 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -805,11 +805,11 @@ static void ivtv_init_struct2(struct ivtv *itv)
 {
 	int i;
 
-	for (i = 0; i < IVTV_CARD_MAX_VIDEO_INPUTS; i++)
+	for (i = 0; i < IVTV_CARD_MAX_VIDEO_INPUTS - 1; i++)
 		if (itv->card->video_inputs[i].video_type == 0)
 			break;
 	itv->nof_inputs = i;
-	for (i = 0; i < IVTV_CARD_MAX_AUDIO_INPUTS; i++)
+	for (i = 0; i < IVTV_CARD_MAX_AUDIO_INPUTS - 1; i++)
 		if (itv->card->audio_inputs[i].audio_type == 0)
 			break;
 	itv->nof_audio_inputs = i;
-- 
2.1.0

