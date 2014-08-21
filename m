Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4459 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599AbaHUUTx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 16:19:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/12] dm1105: fix sparse warning
Date: Thu, 21 Aug 2014 22:19:29 +0200
Message-Id: <1408652376-39525-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
References: <1408652376-39525-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/pci/dm1105/dm1105.c:617:9: warning: incorrect type in argument 1 (different base types)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/dm1105/dm1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index e8826c5..ed11716 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -614,7 +614,7 @@ static int dm1105_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
 
 static void dm1105_set_dma_addr(struct dm1105_dev *dev)
 {
-	dm_writel(DM1105_STADR, cpu_to_le32(dev->dma_addr));
+	dm_writel(DM1105_STADR, (__force u32)cpu_to_le32(dev->dma_addr));
 }
 
 static int dm1105_dma_map(struct dm1105_dev *dev)
-- 
2.1.0.rc1

