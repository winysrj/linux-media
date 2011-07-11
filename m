Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:8000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab1GKB7i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:38 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xcct011624
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:38 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKW030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:37 -0400
Date: Sun, 10 Jul 2011 22:58:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/21] [media] drxk: Move I2C address into a config
 structure
Message-ID: <20110710225852.7f815f7a@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Currently, the only parameter to be configured is the I2C
address. However, Terratec H5 logs shows that it needs a different
setting for some things, and it has its own firmware.

So, move the addr into a config structure, in order to allow adding
the required configuration bits.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index def03d4..573d540 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -574,10 +574,12 @@ static int demod_attach_drxk(struct ddb_input *input)
 {
 	struct i2c_adapter *i2c = &input->port->i2c->adap;
 	struct dvb_frontend *fe;
+	struct drxk_config config;
 
-	fe = input->fe = dvb_attach(drxk_attach,
-				    i2c, 0x29 + (input->nr&1),
-				    &input->fe2);
+	memset(&config, 0, sizeof(config));
+	config.adr = 0x29 + (input->nr & 1);
+
+	fe = input->fe = dvb_attach(drxk_attach, &config, i2c, &input->fe2);
 	if (!input->fe) {
 		printk(KERN_ERR "No DRXK found!\n");
 		return -ENODEV;
diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index d1c133e..a7b295f 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -4,7 +4,11 @@
 #include <linux/types.h>
 #include <linux/i2c.h>
 
-extern struct dvb_frontend *drxk_attach(struct i2c_adapter *i2c,
-					u8 adr,
+struct drxk_config {
+	u8 adr;
+};
+
+extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
+					struct i2c_adapter *i2c,
 					struct dvb_frontend **fe_t);
 #endif
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 8b2e06e..d351e6a 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6341,10 +6341,12 @@ static struct dvb_frontend_ops drxk_t_ops = {
 	.read_ucblocks = drxk_read_ucblocks,
 };
 
-struct dvb_frontend *drxk_attach(struct i2c_adapter *i2c, u8 adr,
+struct dvb_frontend *drxk_attach(const struct drxk_config *config,
+				 struct i2c_adapter *i2c,
 				 struct dvb_frontend **fe_t)
 {
 	struct drxk_state *state = NULL;
+	u8 adr = config->adr;
 
 	dprintk(1, "\n");
 	state = kzalloc(sizeof(struct drxk_state), GFP_KERNEL);
diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 9f72dd8..0564192 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -213,9 +213,12 @@ static int port_has_drxk(struct i2c_adapter *i2c, int port)
 static int demod_attach_drxk(struct ngene_channel *chan,
 			     struct i2c_adapter *i2c)
 {
-	chan->fe = dvb_attach(drxk_attach,
-				   i2c, 0x29 + (chan->number^2),
-				   &chan->fe2);
+	struct drxk_config config;
+
+	memset(&config, 0, sizeof(config));
+	config.adr = 0x29 + (chan->number ^ 2);
+
+	chan->fe = dvb_attach(drxk_attach, &config, i2c, &chan->fe2);
 	if (!chan->fe) {
 		printk(KERN_ERR "No DRXK found!\n");
 		return -ENODEV;
-- 
1.7.1


