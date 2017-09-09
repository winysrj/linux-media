Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:59253 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751012AbdIIUcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 16:32:18 -0400
Subject: [PATCH 2/3] [media] xc2028: Adjust two null pointer checks in
 load_all_firmwares()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c2317603-f640-b0a6-ab86-7fda8040b6ba@users.sourceforge.net>
Message-ID: <10e92128-444a-bec3-e021-61379c21bf4d@users.sourceforge.net>
Date: Sat, 9 Sep 2017 22:32:11 +0200
MIME-Version: 1.0
In-Reply-To: <c2317603-f640-b0a6-ab86-7fda8040b6ba@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Sep 2017 21:48:58 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/tuner-xc2028.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 7353f25f9e7d..90efe11aa0a8 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -335,5 +335,5 @@ static int load_all_firmwares(struct dvb_frontend *fe,
 		   priv->firm_version >> 8, priv->firm_version & 0xff);
 
 	priv->firm = kcalloc(n_array, sizeof(*priv->firm), GFP_KERNEL);
-	if (priv->firm == NULL) {
+	if (!priv->firm) {
 		rc = -ENOMEM;
@@ -384,5 +384,5 @@ static int load_all_firmwares(struct dvb_frontend *fe,
 		}
 
 		priv->firm[n].ptr = kzalloc(size, GFP_KERNEL);
-		if (priv->firm[n].ptr == NULL) {
+		if (!priv->firm[n].ptr) {
 			rc = -ENOMEM;
-- 
2.14.1
