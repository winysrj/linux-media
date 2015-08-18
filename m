Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1on0132.outbound.protection.outlook.com ([157.56.110.132]:50720
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751727AbbHRNXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 09:23:32 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <mchehab@osg.samsung.com>
CC: <maxime.coquelin@st.com>, <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] [media] c8sectpfe: Use %pad to print 'dma_addr_t'
Date: Tue, 18 Aug 2015 10:23:05 -0300
Message-ID: <1439904185-21226-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use %pad to print 'dma_addr_t' in order to fix the following
build warning:

drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c:588:2: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]

Reported-by: Olof's autobuilder <build@lixom.net>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 1586a1e..486aef5 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -585,9 +585,9 @@ static int configure_memdma_and_inputblock(struct c8sectpfei *fei,
 	writel(tsin->pid_buffer_busaddr,
 		fei->io + PIDF_BASE(tsin->tsin_id));
 
-	dev_info(fei->dev, "chan=%d PIDF_BASE=0x%x pid_bus_addr=0x%x\n",
+	dev_info(fei->dev, "chan=%d PIDF_BASE=0x%x pid_bus_addr=%pad\n",
 		tsin->tsin_id, readl(fei->io + PIDF_BASE(tsin->tsin_id)),
-		tsin->pid_buffer_busaddr);
+		&tsin->pid_buffer_busaddr);
 
 	/* Configure and enable HW PID filtering */
 
-- 
1.9.1

