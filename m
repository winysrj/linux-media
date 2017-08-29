Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:53843 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbdH2Ff1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 01:35:27 -0400
Subject: [PATCH 4/4] [media] zr364xx: Fix a typo in a comment line of the file
 header
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Message-ID: <bea45b65-dd34-73a6-cfd7-2ce22aa749fe@users.sourceforge.net>
Date: Tue, 29 Aug 2017 07:35:22 +0200
MIME-Version: 1.0
In-Reply-To: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Aug 2017 22:46:30 +0200

Fix a word in this description.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/zr364xx/zr364xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 4cc6d2a9d91f..4ccf71d8b608 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -2,7 +2,7 @@
  * Zoran 364xx based USB webcam module version 0.73
  *
  * Allows you to use your USB webcam with V4L2 applications
- * This is still in heavy developpement !
+ * This is still in heavy development!
  *
  * Copyright (C) 2004  Antoine Jacquet <royale@zerezo.com>
  * http://royale.zerezo.com/zr364xx/
-- 
2.14.1
