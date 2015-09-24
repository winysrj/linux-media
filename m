Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:61498 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbbIXOBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2015 10:01:14 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 06/19] staging: media: omap4iss: fix handling platform_get_irq
 result
Date: Thu, 24 Sep 2015 16:00:14 +0200
Message-id: <1443103227-25612-7-git-send-email-a.hajda@samsung.com>
In-reply-to: <1443103227-25612-1-git-send-email-a.hajda@samsung.com>
References: <1443103227-25612-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function can return negative value.

The problem has been detected using proposed semantic patch
scripts/coccinelle/tests/assign_signed_to_unsigned.cocci [1].

[1]: http://permalink.gmane.org/gmane.linux.kernel/2046107

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
Hi,

To avoid problems with too many mail recipients I have sent whole
patchset only to LKML. Anyway patches have no dependencies.

Regards
Andrzej
---
 drivers/staging/media/omap4iss/iss.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 9bfb725..0b03cb7 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1440,12 +1440,13 @@ static int iss_probe(struct platform_device *pdev)
 		 iss_reg_read(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_REVISION));
 
 	/* Interrupt */
-	iss->irq_num = platform_get_irq(pdev, 0);
-	if (iss->irq_num <= 0) {
+	ret = platform_get_irq(pdev, 0);
+	if (ret <= 0) {
 		dev_err(iss->dev, "No IRQ resource\n");
 		ret = -ENODEV;
 		goto error_iss;
 	}
+	iss->irq_num = ret;
 
 	if (devm_request_irq(iss->dev, iss->irq_num, iss_isr, IRQF_SHARED,
 			     "OMAP4 ISS", iss)) {
-- 
1.9.1

