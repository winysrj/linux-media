Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726862AbeILLgV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 07:36:21 -0400
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org
Cc: laurent.pinchart@ideasonboard.com, daniel@ffwll.ch,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 3/3] udmabuf: check that flags has no unsupported bits set
Date: Wed, 12 Sep 2018 08:33:16 +0200
Message-Id: <20180912063316.21047-4-kraxel@redhat.com>
In-Reply-To: <20180912063316.21047-1-kraxel@redhat.com>
References: <20180912063316.21047-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Reported-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/dma-buf/udmabuf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 964beadd11..acd97670c5 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -128,6 +128,9 @@ static long udmabuf_create(const struct udmabuf_create_list *head,
 	int seals, ret = -EINVAL;
 	u32 i, flags;
 
+	if (head->flags & ~UDMABUF_FLAGS_CLOEXEC)
+		return -EINVAL;
+
 	ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
 	if (!ubuf)
 		return -ENOMEM;
-- 
2.9.3
