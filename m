Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:60545 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751569AbdICUdN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Sep 2017 16:33:13 -0400
Subject: [PATCH 3/7] [media] Hexium Gemini: Delete an error message for a
 failed memory allocation in hexium_attach()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <170abf7f-3b62-a37c-966a-8b574acae230@users.sourceforge.net>
Message-ID: <1c4c1193-be5a-1fc8-718e-373a45b66e2a@users.sourceforge.net>
Date: Sun, 3 Sep 2017 22:33:02 +0200
MIME-Version: 1.0
In-Reply-To: <170abf7f-3b62-a37c-966a-8b574acae230@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 3 Sep 2017 19:23:37 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/pci/saa7146/hexium_gemini.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index c889ec9f8a5a..694b70fa3baf 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -264,7 +264,6 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
-	if (NULL == hexium) {
-		pr_err("not enough kernel memory in hexium_attach()\n");
+	if (!hexium)
 		return -ENOMEM;
-	}
+
 	dev->ext_priv = hexium;
 
 	/* enable i2c-port pins */
-- 
2.14.1
