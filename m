Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:50869 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdICUeV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 16:34:21 -0400
Subject: [PATCH 4/7] [media] Hexium Gemini: Improve a size determination in
 hexium_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <170abf7f-3b62-a37c-966a-8b574acae230@users.sourceforge.net>
Message-ID: <e9295510-08e7-341b-8117-26d1e5a664af@users.sourceforge.net>
Date: Sun, 3 Sep 2017 22:34:06 +0200
MIME-Version: 1.0
In-Reply-To: <170abf7f-3b62-a37c-966a-8b574acae230@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 3 Sep 2017 19:51:46 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/saa7146/hexium_gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index 694b70fa3baf..a0fcf8150291 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -260,5 +260,5 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 
 	DEB_EE("\n");
 
-	hexium = kzalloc(sizeof(struct hexium), GFP_KERNEL);
+	hexium = kzalloc(sizeof(*hexium), GFP_KERNEL);
 	if (!hexium)
-- 
2.14.1
