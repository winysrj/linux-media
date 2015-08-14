Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40726 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbbHNLtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 07:49:07 -0400
Message-ID: <55CDD591.2000904@xs4all.nl>
Date: Fri, 14 Aug 2015 13:48:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH] c8sectpfe: fix compiler warning on x86_64
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In file included from drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:18:0:
drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c: In function 'configure_memdma_and_inputblock':
drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:587:21: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]
  dev_info(fei->dev, "chan=%d PIDF_BASE=0x%x pid_bus_addr=0x%x\n",
                     ^
include/linux/device.h:1141:51: note: in definition of macro 'dev_info'
 #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
                                                   ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 955d8da..4d36846 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -584,7 +584,7 @@ static int configure_memdma_and_inputblock(struct c8sectpfei *fei,
 	writel(tsin->pid_buffer_busaddr,
 		fei->io + PIDF_BASE(tsin->tsin_id));
 
-	dev_info(fei->dev, "chan=%d PIDF_BASE=0x%x pid_bus_addr=0x%x\n",
+	dev_info(fei->dev, "chan=%d PIDF_BASE=0x%x pid_bus_addr=%pad\n",
 		tsin->tsin_id, readl(fei->io + PIDF_BASE(tsin->tsin_id)),
 		tsin->pid_buffer_busaddr);
 
-- 
2.1.4

