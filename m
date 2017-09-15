Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:63017 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751170AbdIORal (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 13:30:41 -0400
Subject: [PATCH 2/2] [media] stm32-dcmi: Improve four size determinations
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <730b535e-39a5-2c2b-f463-e76da967a723@users.sourceforge.net>
Message-ID: <f4e400ea-9660-05cd-3194-cdf2495a2376@users.sourceforge.net>
Date: Fri, 15 Sep 2017 19:29:42 +0200
MIME-Version: 1.0
In-Reply-To: <730b535e-39a5-2c2b-f463-e76da967a723@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 18:48:14 +0200

Replace the specification of data types by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index df12d10bd230..c4895cc95cc1 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1372,9 +1372,8 @@ static int dcmi_formats_init(struct stm32_dcmi *dcmi)
 	dcmi->sd_formats = devm_kcalloc(dcmi->dev,
-					num_fmts, sizeof(struct dcmi_format *),
+					num_fmts, sizeof(*dcmi->sd_formats),
 					GFP_KERNEL);
 	if (!dcmi->sd_formats)
 		return -ENOMEM;
 
-	memcpy(dcmi->sd_formats, sd_fmts,
-	       num_fmts * sizeof(struct dcmi_format *));
+	memcpy(dcmi->sd_formats, sd_fmts, num_fmts * sizeof(*dcmi->sd_formats));
 	dcmi->sd_format = dcmi->sd_formats[0];
@@ -1406,3 +1405,3 @@ static int dcmi_framesizes_init(struct stm32_dcmi *dcmi)
 	dcmi->sd_framesizes = devm_kcalloc(dcmi->dev, num_fsize,
-					   sizeof(struct dcmi_framesize),
+					   sizeof(*dcmi->sd_framesizes),
 					   GFP_KERNEL);
@@ -1570,5 +1569,5 @@ static int dcmi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dcmi = devm_kzalloc(&pdev->dev, sizeof(struct stm32_dcmi), GFP_KERNEL);
+	dcmi = devm_kzalloc(&pdev->dev, sizeof(*dcmi), GFP_KERNEL);
 	if (!dcmi)
-- 
2.14.1
