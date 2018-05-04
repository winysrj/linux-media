Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39538 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbeEDPSS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 11:18:18 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] media: lgdt330x: don't use an uninitialized state
Date: Fri,  4 May 2018 11:18:13 -0400
Message-Id: <89eaaf2d19a6cfff0a16014405c2a65b5257b8a1.1525447090.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If state is not initialized or is freed, we can't use it:
	drivers/media/dvb-frontends/lgdt330x.c:920 lgdt330x_probe() error: potential null dereference 'state'.  (kzalloc returns null)
	drivers/media/dvb-frontends/lgdt330x.c:920 lgdt330x_probe() error: we previously assumed 'state' could be null (see line 878)
	drivers/media/dvb-frontends/lgdt330x.c:920 lgdt330x_probe() error: dereferencing freed memory 'state'

Fixes: 23ba635d45f5 ("media: lgdt330x: convert it to the new I2C binding way")
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/dvb-frontends/lgdt330x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index 927fd68e05ec..f6731738b073 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -917,7 +917,8 @@ static int lgdt330x_probe(struct i2c_client *client,
 
 error:
 	kfree(state);
-	dprintk(state, "ERROR\n");
+	if (debug)
+		dev_printk(KERN_DEBUG, &client->dev, "Error loading lgdt330x driver\n");
 	return -ENODEV;
 }
 struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *_config,
-- 
2.17.0
