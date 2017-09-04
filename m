Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:65235 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754531AbdIDUHd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Sep 2017 16:07:33 -0400
Subject: [PATCH 2/6] [media] atmel-isc: Improve a size determination in
 isc_formats_init()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Songjun Wu <songjun.wu@microchip.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <88d0739c-fdc1-9d7d-fe53-b7c2eeed1849@users.sourceforge.net>
Message-ID: <2b909a2d-0986-fb5e-f2d9-5d9c0fd71a06@users.sourceforge.net>
Date: Mon, 4 Sep 2017 22:07:24 +0200
MIME-Version: 1.0
In-Reply-To: <88d0739c-fdc1-9d7d-fe53-b7c2eeed1849@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 4 Sep 2017 20:50:22 +0200

Replace the specification of a data type by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/atmel/atmel-isc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index f1e635edef72..f16bab0105c2 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1505,6 +1505,6 @@ static int isc_formats_init(struct isc_device *isc)
 
 	isc->num_user_formats = num_fmts;
 	isc->user_formats = devm_kcalloc(isc->dev,
-					 num_fmts, sizeof(struct isc_format *),
+					 num_fmts, sizeof(*isc->user_formats),
 					 GFP_KERNEL);
 	if (!isc->user_formats)
-- 
2.14.1
