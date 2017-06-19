Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46542 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdFSMT4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 08:19:56 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        'Mauro Carvalho Chehab' <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] s5p-cec: update MAINTAINERS entry
Date: Mon, 19 Jun 2017 14:19:46 +0200
Message-id: <1497874786-26538-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20170619121952eucas1p2214aed0fa6e83b0bf1750944de717dd5@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I would like to replace Kyungmin Park, who is no longer interested in
maintaining S5P-CEC driver. I have access to various Exynos boards. I also
already did some tests of this driver and helped enabling it on various
Exynos boards. The driver itself is no longer in staging, so lets fix the
path too and add DT bindings file pattern match. Also change the mailing
list from ARM generic to Samsung SoC specific to get more attention and
easier review in the future.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
---
v2:
- added DT bindings file as suggested by Krzysztof Kozlowski
---
 MAINTAINERS | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 053c3bdd1fe5..52e516376139 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1775,11 +1775,12 @@ F:	arch/arm/plat-samsung/s5p-dev-mfc.c
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
+F:	Documentation/devicetree/bindings/media/s5p-cec.txt
 
 ARM/SAMSUNG S5P SERIES JPEG CODEC SUPPORT
 M:	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
-- 
1.9.1
