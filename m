Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:53773 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932214AbdIHUxH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 16:53:07 -0400
Subject: [PATCH 2/3] [media] s5p-mfc: Improve a size determination in
 s5p_mfc_alloc_memdev()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
Message-ID: <003abb1f-4dc6-91ca-9d03-cae13dc4ff6f@users.sourceforge.net>
Date: Fri, 8 Sep 2017 22:52:30 +0200
MIME-Version: 1.0
In-Reply-To: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 8 Sep 2017 22:30:09 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 8af45d53846f..abfb70b07032 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1083,7 +1083,7 @@ static struct device *s5p_mfc_alloc_memdev(struct device *dev,
 	struct device *child;
 	int ret;
 
-	child = devm_kzalloc(dev, sizeof(struct device), GFP_KERNEL);
+	child = devm_kzalloc(dev, sizeof(*child), GFP_KERNEL);
 	if (!child)
 		return NULL;
 
-- 
2.14.1
