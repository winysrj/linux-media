Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33614 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbbEAPnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 May 2015 11:43:35 -0400
From: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
Subject: [PATCH] staging: media: omap4iss: Constify platform_device_id
Date: Sat,  2 May 2015 00:43:07 +0900
Message-Id: <1430494987-31013-1-git-send-email-k.kozlowski.k@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The platform_device_id is not modified by the driver and core uses it as
const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski.k@gmail.com>
---
 drivers/staging/media/omap4iss/iss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index e0ad5e520e2d..68867f286afd 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1478,7 +1478,7 @@ static int iss_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_device_id omap4iss_id_table[] = {
+static const struct platform_device_id omap4iss_id_table[] = {
 	{ "omap4iss", 0 },
 	{ },
 };
-- 
2.1.4

