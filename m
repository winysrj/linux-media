Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:61792
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbaLPRD5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Dec 2014 12:03:57 -0500
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <mchehab@osg.samsung.com>
CC: <hans.verkuil@cisco.com>, <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] [media] adv7180: Remove the unneeded 'err' label
Date: Tue, 16 Dec 2014 14:49:07 -0200
Message-ID: <1418748547-12308-2-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1418748547-12308-1-git-send-email-fabio.estevam@freescale.com>
References: <1418748547-12308-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to jump to the 'err' label as we can simply return the error
code directly and make the code shorter.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/i2c/adv7180.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 0c1268a..456bf2d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -616,10 +616,8 @@ static int adv7180_probe(struct i2c_client *client,
 		 client->addr, client->adapter->name);
 
 	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
-	if (state == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
+	if (state == NULL)
+		return -ENOMEM;
 
 	state->irq = client->irq;
 	mutex_init(&state->mutex);
@@ -649,7 +647,6 @@ err_free_ctrl:
 	adv7180_exit_controls(state);
 err_unreg_subdev:
 	mutex_destroy(&state->mutex);
-err:
 	return ret;
 }
 
-- 
1.9.1

