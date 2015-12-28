Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:51076 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbbL1Om6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 09:42:58 -0500
Subject: [PATCH 2/2] [media] tuners: Refactoring for m88rs6000t_sleep()
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5680FDB3.7060305@users.sourceforge.net>
 <alpine.DEB.2.10.1512281019050.2702@hadrien>
 <56810F56.4080306@users.sourceforge.net>
 <alpine.DEB.2.10.1512281134590.2702@hadrien>
 <568148FD.7080209@users.sourceforge.net>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <56814A62.7070309@users.sourceforge.net>
Date: Mon, 28 Dec 2015 15:42:42 +0100
MIME-Version: 1.0
In-Reply-To: <568148FD.7080209@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 28 Dec 2015 15:20:45 +0100

This issue was detected by using the Coccinelle software.

1. Let us return directly if a call of the regmap_write() function failed.

2. Delete the jump label "err" then.

3. Return zero as a constant at the end.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/m88rs6000t.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
index 7e59a9f..8d10798 100644
--- a/drivers/media/tuners/m88rs6000t.c
+++ b/drivers/media/tuners/m88rs6000t.c
@@ -463,13 +463,12 @@ static int m88rs6000t_sleep(struct dvb_frontend *fe)
 	dev_dbg(&dev->client->dev, "%s:\n", __func__);
 
 	ret = regmap_write(dev->regmap, 0x07, 0x6d);
-	if (ret)
-		goto err;
-	usleep_range(5000, 10000);
-err:
-	if (ret)
+	if (ret) {
 		dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-	return ret;
+		return ret;
+	}
+	usleep_range(5000, 10000);
+	return 0;
 }
 
 static int m88rs6000t_get_frequency(struct dvb_frontend *fe, u32 *frequency)
-- 
2.6.3

