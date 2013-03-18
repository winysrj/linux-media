Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2647 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3CRMcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 12/19] solo6x10: add call to pci_dma_mapping_error.
Date: Mon, 18 Mar 2013 13:32:11 +0100
Message-Id: <1363609938-21735-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Check the result of the dma mapping.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/p2m.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/solo6x10/p2m.c b/drivers/staging/media/solo6x10/p2m.c
index 3ed4d58..2292061 100644
--- a/drivers/staging/media/solo6x10/p2m.c
+++ b/drivers/staging/media/solo6x10/p2m.c
@@ -51,6 +51,8 @@ int solo_p2m_dma(struct solo_dev *solo_dev, int wr,
 
 	dma_addr = pci_map_single(solo_dev->pdev, sys_addr, size,
 				  wr ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
+	if (pci_dma_mapping_error(solo_dev->pdev, dma_addr))
+		return -ENOMEM;
 
 	ret = solo_p2m_dma_t(solo_dev, wr, dma_addr, ext_addr, size,
 			     repeat, ext_size);
-- 
1.7.10.4

