Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8794 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752250AbdBUNVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 08:21:19 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] dma-buf: add support for compat ioctl
Date: Tue, 21 Feb 2017 14:21:01 +0100
Message-id: <1487683261-2655-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170221132114eucas1p2e527d5b5516494ba54aa91f48b3e227f@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add compat ioctl support to dma-buf. This lets one to use DMA_BUF_IOCTL_SYNC
ioctl from 32bit application on 64bit kernel. Data structures for both 32
and 64bit modes are same, so there is no need for additional translation
layer.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/dma-buf/dma-buf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 718f832a5c71..0007b792827b 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -325,6 +325,9 @@ static long dma_buf_ioctl(struct file *file,
 	.llseek		= dma_buf_llseek,
 	.poll		= dma_buf_poll,
 	.unlocked_ioctl	= dma_buf_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= dma_buf_ioctl,
+#endif
 };
 
 /*
-- 
1.9.1
