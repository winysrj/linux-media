Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway30.websitewelcome.com ([192.185.148.2]:35964 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932198AbeDWRiV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 13:38:21 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 03C3A18305
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:38:21 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:38:19 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 02/11] exynos4-is: mipi-csis: fix potential Spectre variant 1
Message-ID: <1d1128bd1e8fd3309ff8e615a06346724281e5b4.1524499368.git.gustavo@embeddedor.com>
References: <cover.1524499368.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1524499368.git.gustavo@embeddedor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

code->index can be controlled by user-space, hence leading to
a potential exploitation of the Spectre variant 1 vulnerability.

Smatch warning:
drivers/media/platform/exynos4-is/mipi-csis.c:549 s5pcsis_enum_mbus_code() warn: potential spectre issue 's5pcsis_formats'

Fix this by sanitizing code->index before using it to index
s5pcsis_formats.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Cc: stable@vger.kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/media/platform/exynos4-is/mipi-csis.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index cba46a6..60104c1 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -35,6 +35,8 @@
 
 #include "mipi-csis.h"
 
+#include <linux/nospec.h>
+
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-2)");
@@ -545,7 +547,8 @@ static int s5pcsis_enum_mbus_code(struct v4l2_subdev *sd,
 {
 	if (code->index >= ARRAY_SIZE(s5pcsis_formats))
 		return -EINVAL;
-
+	code->index = array_index_nospec(code->index,
+					 ARRAY_SIZE(s5pcsis_formats));
 	code->code = s5pcsis_formats[code->index].code;
 	return 0;
 }
-- 
2.7.4
