Return-path: <linux-media-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:1249 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab3KALtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Nov 2013 07:49:10 -0400
From: Nicolin Chen <b42378@freescale.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>, <nsekhar@ti.com>,
	<khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
	<dan.j.williams@intel.com>, <vinod.koul@intel.com>,
	<m.chehab@samsung.com>, <hjk@hansjkoch.de>,
	<gregkh@linuxfoundation.org>, <perex@perex.cz>, <tiwai@suse.de>,
	<lgirdwood@gmail.com>, <broonie@kernel.org>,
	<rmk+kernel@arm.linux.org.uk>, <eric.y.miao@gmail.com>,
	<haojian.zhuang@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<dmaengine@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>
Subject: [PATCH][RESEND 7/8] ASoC: davinci: use gen_pool_dma_alloc() in davinci-pcm.c
Date: Fri, 1 Nov 2013 19:48:20 +0800
Message-ID: <8bd26b17552315f0a3ea63c166a97a938c88dcf0.1383306365.git.b42378@freescale.com>
In-Reply-To: <cover.1383306365.git.b42378@freescale.com>
References: <cover.1383306365.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 sound/soc/davinci/davinci-pcm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/davinci/davinci-pcm.c b/sound/soc/davinci/davinci-pcm.c
index 84a63c6..fa64cd8 100644
--- a/sound/soc/davinci/davinci-pcm.c
+++ b/sound/soc/davinci/davinci-pcm.c
@@ -267,10 +267,9 @@ static int allocate_sram(struct snd_pcm_substream *substream,
 		return 0;
 
 	ppcm->period_bytes_max = size;
-	iram_virt = (void *)gen_pool_alloc(sram_pool, size);
+	iram_virt = gen_pool_dma_alloc(sram_pool, size, &iram_phys);
 	if (!iram_virt)
 		goto exit1;
-	iram_phys = gen_pool_virt_to_phys(sram_pool, (unsigned)iram_virt);
 	iram_dma = kzalloc(sizeof(*iram_dma), GFP_KERNEL);
 	if (!iram_dma)
 		goto exit2;
-- 
1.8.4


