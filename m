Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3KHJxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Nov 2013 04:53:16 -0500
MIME-Version: 1.0
Message-ID: <20131108095224.GJ27977@elgon.mountain>
Date: Fri, 8 Nov 2013 01:52:24 -0800 (PST)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] exynos4-is: cleanup a define
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This define is only used in s5pcsis_irq_handler():

	if ((status & S5PCSIS_INTSRC_NON_IMAGE_DATA) && pktbuf->data) {

The problem is that "status" is a 32 bit and (0xff << 28) is larger than
32 bits and that sets off a static checker warning.  I consulted with
Sylwester Nawrocki and the define should actually be (0xf << 28).

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 9fc2af6..31dfc50 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 #define S5PCSIS_INTSRC_ODD_BEFORE	(1 << 29)
 #define S5PCSIS_INTSRC_ODD_AFTER	(1 << 28)
 #define S5PCSIS_INTSRC_ODD		(0x3 << 28)
-#define S5PCSIS_INTSRC_NON_IMAGE_DATA	(0xff << 28)
+#define S5PCSIS_INTSRC_NON_IMAGE_DATA	(0xf << 28)
 #define S5PCSIS_INTSRC_FRAME_START	(1 << 27)
 #define S5PCSIS_INTSRC_FRAME_END	(1 << 26)
 #define S5PCSIS_INTSRC_ERR_SOT_HS	(0xf << 12)
