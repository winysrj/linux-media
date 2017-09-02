Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:54604 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752399AbdIBNGY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 09:06:24 -0400
Subject: [PATCH 1/4] [media] adv7604: Delete an error message for a failed
 memory allocation in adv76xx_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <0e67e095-4931-b78f-a925-7335326ab69c@users.sourceforge.net>
Message-ID: <e714ab2d-4d08-8103-6d05-2eee7a58ba10@users.sourceforge.net>
Date: Sat, 2 Sep 2017 15:06:16 +0200
MIME-Version: 1.0
In-Reply-To: <0e67e095-4931-b78f-a925-7335326ab69c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 11:28:55 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/i2c/adv7604.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 660bacb8f7d9..cc693ef71f33 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3319,7 +3319,5 @@ static int adv76xx_probe(struct i2c_client *client,
-	if (!state) {
-		v4l_err(client, "Could not allocate adv76xx_state memory!\n");
+	if (!state)
 		return -ENOMEM;
-	}
 
 	state->i2c_clients[ADV76XX_PAGE_IO] = client;
 
-- 
2.14.1
