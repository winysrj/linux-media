Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E68C169C4
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 17:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B110218B0
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 17:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfBFRcn (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 12:32:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:44022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727602AbfBFRcn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Feb 2019 12:32:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8E5FFB6D6;
        Wed,  6 Feb 2019 17:32:42 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     alsa-devel@alsa-project.org
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH] media: Drop superfluous PCM preallocation error checks
Date:   Wed,  6 Feb 2019 18:32:39 +0100
Message-Id: <20190206173239.18046-1-tiwai@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

snd_pcm_lib_preallocate_pages() and co always succeed, so the error
check is simply redundant.  Drop it.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

This is a piece I overlooked in the previous patchset:
   https://www.spinics.net/lists/alsa-devel/msg87223.html

Media people, please give ACK if this is OK.  Then I'll merge it together
with other relevant patches.  Thanks!

 drivers/media/pci/solo6x10/solo6x10-g723.c | 4 +---
 drivers/media/pci/tw686x/tw686x-audio.c    | 3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-g723.c b/drivers/media/pci/solo6x10/solo6x10-g723.c
index 2cc05a9d57ac..a16242a9206f 100644
--- a/drivers/media/pci/solo6x10/solo6x10-g723.c
+++ b/drivers/media/pci/solo6x10/solo6x10-g723.c
@@ -360,13 +360,11 @@ static int solo_snd_pcm_init(struct solo_dev *solo_dev)
 	     ss; ss = ss->next, i++)
 		sprintf(ss->name, "Camera #%d Audio", i);
 
-	ret = snd_pcm_lib_preallocate_pages_for_all(pcm,
+	snd_pcm_lib_preallocate_pages_for_all(pcm,
 					SNDRV_DMA_TYPE_CONTINUOUS,
 					snd_dma_continuous_data(GFP_KERNEL),
 					G723_PERIOD_BYTES * PERIODS,
 					G723_PERIOD_BYTES * PERIODS);
-	if (ret < 0)
-		return ret;
 
 	solo_dev->snd_pcm = pcm;
 
diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/tw686x/tw686x-audio.c
index a28329698e20..fb0e7573b5ae 100644
--- a/drivers/media/pci/tw686x/tw686x-audio.c
+++ b/drivers/media/pci/tw686x/tw686x-audio.c
@@ -301,11 +301,12 @@ static int tw686x_snd_pcm_init(struct tw686x_dev *dev)
 	     ss; ss = ss->next, i++)
 		snprintf(ss->name, sizeof(ss->name), "vch%u audio", i);
 
-	return snd_pcm_lib_preallocate_pages_for_all(pcm,
+	snd_pcm_lib_preallocate_pages_for_all(pcm,
 				SNDRV_DMA_TYPE_DEV,
 				snd_dma_pci_data(dev->pci_dev),
 				TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MAX,
 				TW686X_AUDIO_PAGE_MAX * AUDIO_DMA_SIZE_MAX);
+	return 0;
 }
 
 static void tw686x_audio_dma_free(struct tw686x_dev *dev,
-- 
2.16.4

