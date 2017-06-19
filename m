Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50071 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdFSMDZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 08:03:25 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        'Mauro Carvalho Chehab' <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-cec: update MAINTAINERS entry
Date: Mon, 19 Jun 2017 14:03:02 +0200
Message-id: <1497873782-25543-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170619120320eucas1p2a84a4472e7d2f1c148e7035ae994c5e1@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I would like to replace Kyungmin Park, who is no longer interested in
maintaining S5P-CEC driver. I have access to various Exynos boards. I also
already did some tests of this driver and helped enabling it on various
Exynos boards. The driver itself is no longer in staging, so lets fix the
path too. Also change the mailing list from ARM generic to Samsung SoC
specific to get more attention and easier review in the future.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bdd1fe5..fbfbc9866fa2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1775,11 +1775,11 @@ F:	arch/arm/plat-samsung/s5p-dev-mfc.c
 F:	drivers/media/platform/s5p-mfc/
 
 ARM/SAMSUNG S5P SERIES HDMI CEC SUBSYSTEM SUPPORT
-M:	Kyungmin Park <kyungmin.park@samsung.com>
-L:	linux-arm-kernel@lists.infradead.org
+M:	Marek Szyprowski <m.szyprowski@samsung.com>
+L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/staging/media/platform/s5p-cec/
+F:	drivers/media/platform/s5p-cec/
 
 ARM/SAMSUNG S5P SERIES JPEG CODEC SUPPORT
 M:	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
-- 
1.9.1
