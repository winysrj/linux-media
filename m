Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33115 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbcEaOdZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 10:33:25 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [PATCH 1/2] MAINTAINERS: add entry for the Sync File Framework
Date: Tue, 31 May 2016 11:33:15 -0300
Message-Id: <1464705196-24369-1-git-send-email-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

Add Gustavo as maintainer for the Sync File Framework. Sumit is
co-maintainer as he maintains drivers/dma-buf/. It also uses Sumit's
tree as base.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb487d9..0891228 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3677,6 +3677,17 @@ F:	include/linux/*fence.h
 F:	Documentation/dma-buf-sharing.txt
 T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
+SYNC FILE FRAMEWORK
+M:	Sumit Semwal <sumit.semwal@linaro.org>
+R:	Gustavo Padovan <gustavo@padovan.org>
+S:	Maintained
+L:	linux-media@vger.kernel.org
+L:	dri-devel@lists.freedesktop.org
+F:	drivers/dma-buf/sync_file.c
+F:	include/linux/sync_file.h
+F:	Documentation/sync_file.txt
+T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
+
 DMA GENERIC OFFLOAD ENGINE SUBSYSTEM
 M:	Vinod Koul <vinod.koul@intel.com>
 L:	dmaengine@vger.kernel.org
-- 
2.5.5

