Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:14628 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918Ab2K1KOd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 05:14:33 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ME700H3Q0G7F330@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Nov 2012 19:14:32 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0ME70056P0G1CG81@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Nov 2012 19:14:32 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] MAINTAINERS: add g2d entry.
Date: Wed, 28 Nov 2012 11:14:22 +0100
Message-id: <1354097662-25565-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b623679..c675df0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1092,6 +1092,14 @@ F:	arch/arm/mach-s5pv210/mach-goni.c
 F:	arch/arm/mach-exynos/mach-universal_c210.c
 F:	arch/arm/mach-exynos/mach-nuri.c
 
+ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
+M:	Kyungmin Park <kyungmin.park@samsung.com>
+M:	Kamil Debski <k.debski@samsung.com>
+L:	linux-arm-kernel@lists.infradead.org
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/s5p-g2d/
+
 ARM/SAMSUNG S5P SERIES FIMC SUPPORT
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
-- 
1.7.9.5

