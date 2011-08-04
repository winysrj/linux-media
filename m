Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1HDHOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 03:14:30 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 18/21] [staging] tm6000: Plug memory leak on PCM free.
Date: Thu,  4 Aug 2011 09:14:16 +0200
Message-Id: <1312442059-23935-19-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When releasing hardware resources, the DMA buffer allocated to the PCM
device needs to be freed to prevent a memory leak.
---
 drivers/staging/tm6000/tm6000-alsa.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index 35ad1f0..2bf21600 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -308,6 +308,7 @@ static int snd_tm6000_hw_free(struct snd_pcm_substream *substream)
 		schedule_work(&core->wq_trigger);
 	}
 
+	dsp_buffer_free(substream);
 	return 0;
 }
 
-- 
1.7.6

