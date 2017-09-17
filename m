Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:52943 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750995AbdIQG6I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 02:58:08 -0400
Subject: [PATCH 1/2] [media] si2157: Delete an error message for a failed
 memory allocation in si2157_probe()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <87f4a386-ac11-87f5-2d22-7bfc0593de34@users.sourceforge.net>
Message-ID: <e9510d39-2aff-ca78-5e51-1cf97555a2e3@users.sourceforge.net>
Date: Sun, 17 Sep 2017 08:57:45 +0200
MIME-Version: 1.0
In-Reply-To: <87f4a386-ac11-87f5-2d22-7bfc0593de34@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 17 Sep 2017 08:20:04 +0200

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/si2157.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index e35b1faf0ddc..aefa85718496 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -439,6 +439,5 @@ static int si2157_probe(struct i2c_client *client,
 	if (!dev) {
 		ret = -ENOMEM;
-		dev_err(&client->dev, "kzalloc() failed\n");
 		goto err;
 	}
 
-- 
2.14.1
