Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59954 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030446AbbD1Poh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2015 11:44:37 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 02/14] cx18: avoid going past input/audio array
Date: Tue, 28 Apr 2015 12:43:41 -0300
Message-Id: <b5e6ddaf21e8e2c8517b21bfc36ebc09d8f33a20.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
In-Reply-To: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
References: <ea067cc285e015d6ba90554d650b0a9df2670252.1430235781.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/pci/cx18/cx18-driver.c:807 cx18_init_struct2() error: buffer overflow 'cx->card->video_inputs' 6 <= 6

That happens because nof_inputs and nof_audio_inputs can be initialized
as CX18_CARD_MAX_VIDEO_INPUTS, instead of CX18_CARD_MAX_VIDEO_INPUTS - 1.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 83f5074706f9..260e462d91b4 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -786,11 +786,11 @@ static void cx18_init_struct2(struct cx18 *cx)
 {
 	int i;
 
-	for (i = 0; i < CX18_CARD_MAX_VIDEO_INPUTS; i++)
+	for (i = 0; i < CX18_CARD_MAX_VIDEO_INPUTS - 1; i++)
 		if (cx->card->video_inputs[i].video_type == 0)
 			break;
 	cx->nof_inputs = i;
-	for (i = 0; i < CX18_CARD_MAX_AUDIO_INPUTS; i++)
+	for (i = 0; i < CX18_CARD_MAX_AUDIO_INPUTS - 1; i++)
 		if (cx->card->audio_inputs[i].audio_type == 0)
 			break;
 	cx->nof_audio_inputs = i;
-- 
2.1.0

