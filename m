Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:61922 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbdIITO4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 15:14:56 -0400
Subject: [PATCH 2/2] [media] xc4000: Adjust two null pointer checks in
 xc4000_fwupload()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <61016489-eb01-2977-b094-343aa70686b0@users.sourceforge.net>
Message-ID: <68444473-5d87-3213-4640-6069c88db1a9@users.sourceforge.net>
Date: Sat, 9 Sep 2017 21:14:47 +0200
MIME-Version: 1.0
In-Reply-To: <61016489-eb01-2977-b094-343aa70686b0@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Sep 2017 20:55:14 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/xc4000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index bbf386127fc4..bd53e44b3cc8 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -775,5 +775,5 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 		priv->firm_version >> 8, priv->firm_version & 0xff);
 
 	priv->firm = kcalloc(n_array, sizeof(*priv->firm), GFP_KERNEL);
-	if (priv->firm == NULL) {
+	if (!priv->firm) {
 		rc = -ENOMEM;
@@ -821,5 +821,5 @@ static int xc4000_fwupload(struct dvb_frontend *fe)
 		}
 
 		priv->firm[n].ptr = kzalloc(size, GFP_KERNEL);
-		if (priv->firm[n].ptr == NULL) {
+		if (!priv->firm[n].ptr) {
 			rc = -ENOMEM;
-- 
2.14.1
