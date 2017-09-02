Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:57930 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752441AbdIBNK2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Sep 2017 09:10:28 -0400
Subject: [PATCH 4/4] [media] adv7842: Improve a size determination in
 adv7842_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <0e67e095-4931-b78f-a925-7335326ab69c@users.sourceforge.net>
Message-ID: <0ffbe17f-7de1-a456-a066-227f25642fa1@users.sourceforge.net>
Date: Sat, 2 Sep 2017 15:10:13 +0200
MIME-Version: 1.0
In-Reply-To: <0e67e095-4931-b78f-a925-7335326ab69c@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Sep 2017 12:53:15 +0200

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/i2c/adv7842.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 366a294edd7b..aa8b3bcdd750 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3467,5 +3467,5 @@ static int adv7842_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	state = devm_kzalloc(&client->dev, sizeof(struct adv7842_state), GFP_KERNEL);
+	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (!state)
-- 
2.14.1
