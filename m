Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbbKKLwJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2015 06:52:09 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andrew Meredith <andrew@anvil.org>,
	Warren Sturm <warren.sturm@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 2/2 v2] [media] ivtv: avoid going past input/audio array
Date: Wed, 11 Nov 2015 09:51:19 -0200
Message-Id: <2a0c0908ea977f172eade77dfcd9e78d260ac80c.1447242633.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by smatch:
	drivers/media/pci/ivtv/ivtv-driver.c:832 ivtv_init_struct2() error: buffer overflow 'itv->card->video_inputs' 6 <= 6

drivers/media/pci/ivtv/ivtv-driver.c:832 ivtv_init_struct2() error: buffer overflow 'itv->card->video_inputs' 6 <= 6

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

---

v2: Added a missing new line after the patch subject.

diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 21501c560610..374033a5bdaf 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -826,7 +826,7 @@ static void ivtv_init_struct2(struct ivtv *itv)
 				IVTV_CARD_INPUT_VID_TUNER)
 			break;
 	}
-	if (i == itv->nof_inputs)
+	if (i >= itv->nof_inputs)
 		i = 0;
 	itv->active_input = i;
 	itv->audio_input = itv->card->video_inputs[i].audio_index;
-- 
2.4.3


