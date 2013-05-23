Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46106 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759438Ab3EWOnK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 10:43:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/9] [media] coda: clear registers in coda_hw_init
Date: Thu, 23 May 2013 16:42:56 +0200
Message-Id: <1369320181-17933-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
References: <1369320181-17933-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 3be56b0..ef541b0 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1762,6 +1762,10 @@ static int coda_hw_init(struct coda_dev *dev)
 		}
 	}
 
+	/* Clear registers */
+	for (i = 0; i < 64; i++)
+		coda_write(dev, 0, CODA_REG_BIT_CODE_BUF_ADDR + i * 4);
+
 	/* Tell the BIT where to find everything it needs */
 	coda_write(dev, dev->workbuf.paddr,
 		      CODA_REG_BIT_WORK_BUF_ADDR);
-- 
1.8.2.rc2

