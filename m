Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:49492 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751588AbdIOR3o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 13:29:44 -0400
Subject: [PATCH 1/2] [media] stm32-dcmi: Delete an error message for a failed
 memory allocation in two functions
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
Message-ID: <3aef408b-3e36-a777-cf78-76c98b93b63b@users.sourceforge.net>
Date: Fri, 15 Sep 2017 19:28:45 +0200
MIME-Version: 1.0
In-Reply-To: <730b535e-39a5-2c2b-f463-e76da967a723@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 18:38:25 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 35ba6f211b79..df12d10bd230 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1374,6 +1374,4 @@ static int dcmi_formats_init(struct stm32_dcmi *dcmi)
 					GFP_KERNEL);
-	if (!dcmi->sd_formats) {
-		dev_err(dcmi->dev, "Could not allocate memory\n");
+	if (!dcmi->sd_formats)
 		return -ENOMEM;
-	}
 
@@ -1410,7 +1408,5 @@ static int dcmi_framesizes_init(struct stm32_dcmi *dcmi)
 					   GFP_KERNEL);
-	if (!dcmi->sd_framesizes) {
-		dev_err(dcmi->dev, "Could not allocate memory\n");
+	if (!dcmi->sd_framesizes)
 		return -ENOMEM;
-	}
 
 	/* Fill array with sensor supported framesizes */
-- 
2.14.1
