Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:52699 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1CINoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 08:44:54 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org,
	jonghun.han@samsung.com, Jeongtae Park <jtp.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v2 5/8] ARM: S5PV310: Add 'CONSISTENT_DMA_SIZE' definition for DMA pool allocator
Date: Wed,  9 Mar 2011 22:16:04 +0900
Message-Id: <1299676567-14194-6-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
References: <1299676567-14194-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds 'CONSISTENT_DMA_SIZE' definition for DMA pool allocator.

Reviewed-by: Peter Oh <jaeryul.oh@samsung.com>
Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/mach-s5pv310/include/mach/memory.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/include/mach/memory.h b/arch/arm/mach-s5pv310/include/mach/memory.h
index 1dffb48..f026870 100644
--- a/arch/arm/mach-s5pv310/include/mach/memory.h
+++ b/arch/arm/mach-s5pv310/include/mach/memory.h
@@ -14,6 +14,7 @@
 #define __ASM_ARCH_MEMORY_H __FILE__
 
 #define PHYS_OFFSET		UL(0x40000000)
+#define CONSISTENT_DMA_SIZE	(SZ_8M)
 
 /* Maximum of 256MiB in one bank */
 #define MAX_PHYSMEM_BITS	32
-- 
1.7.1

