Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34260 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727781AbeIKSln (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 14:41:43 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 06/13] udmabuf: add MEMFD_CREATE dependency
Date: Tue, 11 Sep 2018 15:42:09 +0200
Message-Id: <20180911134216.9760-7-kraxel@redhat.com>
In-Reply-To: <20180911134216.9760-1-kraxel@redhat.com>
References: <20180911134216.9760-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

udmabuf builds without it, but if userspace can not create memfd
handles in the first place it is rather pointless to include it,
except for test builds.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/dma-buf/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index 338129eb12..2e5a0faa2c 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -34,6 +34,7 @@ config UDMABUF
 	bool "userspace dmabuf misc driver"
 	default n
 	depends on DMA_SHARED_BUFFER
+	depends on MEMFD_CREATE || COMPILE_TEST
 	help
 	  A driver to let userspace turn memfd regions into dma-bufs.
 	  Qemu can use this to create host dmabufs for guest framebuffers.
-- 
2.9.3
