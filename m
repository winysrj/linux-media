Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28057 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbcFHGwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2016 02:52:03 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] of: reserved_mem: restore old behavior when no region is
 defined
Date: Wed, 08 Jun 2016 08:51:53 +0200
Message-id: <1465368713-17866-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <20160607143425.GE1165@e106497-lin.cambridge.arm.com>
References: <20160607143425.GE1165@e106497-lin.cambridge.arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change return value back to -ENODEV when no region is defined for given
device. This restores old behavior of this function, as some drivers rely
on such error code.

Reported-by: Liviu Dudau <liviu.dudau@arm.com>
Fixes: 59ce4039727ef40 ("of: reserved_mem: add support for using more than
       one region for given device")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 3cf129f..06af99f 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -334,7 +334,7 @@ int of_reserved_mem_device_init_by_idx(struct device *dev,
 
 	target = of_parse_phandle(np, "memory-region", idx);
 	if (!target)
-		return -EINVAL;
+		return -ENODEV;
 
 	rmem = __find_rmem(target);
 	of_node_put(target);
-- 
1.9.2

