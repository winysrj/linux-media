Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:36291 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751267AbeCIPxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:44 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/11] media: lgdt330x: print info when device gets probed
Date: Fri,  9 Mar 2018 12:53:29 -0300
Message-Id: <5197efe6d488378cba5950e47d941b9c70c4a6bb.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is useful to know if the driver load succeded. So,
add a printk info there.

While here, improve the .init debug printed message.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index a3139eb69c93..1e52831cb603 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -299,7 +299,7 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 		printk(KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
 		err = -ENODEV;
 	}
-	dprintk("entered as %s\n", chip_name);
+	dprintk("Initialized the %s chip\n", chip_name);
 	if (err < 0)
 		return err;
 	return lgdt330x_sw_reset(state);
@@ -817,6 +817,9 @@ struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
 	state->current_frequency = -1;
 	state->current_modulation = -1;
 
+	pr_info("Demod loaded for LGDT330%s chip\n",
+		config->demod_chip == LGDT3302 ? "2" : "3");
+
 	return &state->frontend;
 
 error:
-- 
2.14.3
