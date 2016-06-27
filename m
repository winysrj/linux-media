Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34007 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655AbcF0IbK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 04:31:10 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] tw686x: be explicit about the possible dma_mode options
Message-ID: <d4ce2282-1ad9-369c-fc37-92fe402a0e13@xs4all.nl>
Date: Mon, 27 Jun 2016 10:31:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Users won't know what to put in this module option if it isn't
described.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Ezequiel, this sits on top of your tw686x patch series and will be part of the pull
request.
---
 drivers/media/pci/tw686x/tw686x-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index 586bc67..71a0453 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -91,7 +91,7 @@ static int tw686x_dma_mode_set(const char *val, struct kernel_param *kp)
 }
 module_param_call(dma_mode, tw686x_dma_mode_set, tw686x_dma_mode_get,
 		  &dma_mode, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(dma_mode, "DMA operation mode");
+MODULE_PARM_DESC(dma_mode, "DMA operation mode (memcpy/contig/sg, default=memcpy)");

 void tw686x_disable_channel(struct tw686x_dev *dev, unsigned int channel)
 {
-- 
2.8.1

