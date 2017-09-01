Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:60324 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752400AbdIATqC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Sep 2017 15:46:02 -0400
Subject: [PATCH 4/4] [media] sp2: Adjust three null pointer checks in
 sp2_exit()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Olli Salonen <olli.salonen@iki.fi>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <6142ca34-fcda-f2b6-bc35-dbbde0d34378@users.sourceforge.net>
Message-ID: <2d2b6ac7-eb35-a439-3dab-ed4e01e3a9f8@users.sourceforge.net>
Date: Fri, 1 Sep 2017 21:45:49 +0200
MIME-Version: 1.0
In-Reply-To: <6142ca34-fcda-f2b6-bc35-dbbde0d34378@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 1 Sep 2017 21:16:06 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/sp2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/sp2.c b/drivers/media/dvb-frontends/sp2.c
index b2a7a54174ae..9bd71ba36d86 100644
--- a/drivers/media/dvb-frontends/sp2.c
+++ b/drivers/media/dvb-frontends/sp2.c
@@ -357,14 +357,14 @@ static int sp2_exit(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	if (client == NULL)
+	if (!client)
 		return 0;
 
 	s = i2c_get_clientdata(client);
-	if (s == NULL)
+	if (!s)
 		return 0;
 
-	if (s->ca.data == NULL)
+	if (!s->ca.data)
 		return 0;
 
 	dvb_ca_en50221_release(&s->ca);
-- 
2.14.1
