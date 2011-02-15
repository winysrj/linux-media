Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab1BONfx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Feb 2011 08:35:53 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDZqjY028369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:35:53 -0500
Received: from pedra (vpn-239-107.phx2.redhat.com [10.3.239.107])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p1FDXmP1005481
	for <linux-media@vger.kernel.org>; Tue, 15 Feb 2011 08:35:52 -0500
Date: Tue, 15 Feb 2011 11:33:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] tuner-core: remove usage of DIGITAL_TV
Message-ID: <20110215113334.49ead2c2@pedra>
In-Reply-To: <cover.1297776328.git.mchehab@redhat.com>
References: <cover.1297776328.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

tuner-core has no business to do with digital TV. So, don't use
T_DIGITAL_TV on it, as it has no code to distinguish between
them, and nobody fills T_DIGITAL_TV right.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
index 01be89f..39fc923 100644
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -185,8 +185,7 @@ void au0828_card_setup(struct au0828_dev *dev)
 	static u8 eeprom[256];
 	struct tuner_setup tun_setup;
 	struct v4l2_subdev *sd;
-	unsigned int mode_mask = T_ANALOG_TV |
-				 T_DIGITAL_TV;
+	unsigned int mode_mask = T_ANALOG_TV;
 
 	dprintk(1, "%s()\n", __func__);
 
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 7f58756..242f0d5 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3616,7 +3616,7 @@ void __devinit bttv_init_tuner(struct bttv *btv)
 				&btv->c.i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_TV_WITH_DEMOD));
 
-		tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
+		tun_setup.mode_mask = T_ANALOG_TV;
 		tun_setup.type = btv->tuner_type;
 		tun_setup.addr = addr;
 
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 4e6ee55..8128b93 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3165,9 +3165,7 @@ static void cx88_card_setup(struct cx88_core *core)
 {
 	static u8 eeprom[256];
 	struct tuner_setup tun_setup;
-	unsigned int mode_mask = T_RADIO     |
-				 T_ANALOG_TV |
-				 T_DIGITAL_TV;
+	unsigned int mode_mask = T_RADIO | T_ANALOG_TV;
 
 	memset(&tun_setup, 0, sizeof(tun_setup));
 
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 74467c1..61c6007 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -7333,9 +7333,7 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 static void saa7134_tuner_setup(struct saa7134_dev *dev)
 {
 	struct tuner_setup tun_setup;
-	unsigned int mode_mask = T_RADIO     |
-				 T_ANALOG_TV |
-				 T_DIGITAL_TV;
+	unsigned int mode_mask = T_RADIO | T_ANALOG_TV;
 
 	memset(&tun_setup, 0, sizeof(tun_setup));
 	tun_setup.tuner_callback = saa7134_tuner_callback;
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index dcf03fa..5e1437c 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -497,7 +497,7 @@ static void tuner_lookup(struct i2c_adapter *adap,
 		   device. If other devices appear then we need to
 		   make this test more general. */
 		else if (*tv == NULL && pos->type != TUNER_TDA9887 &&
-			 (pos->mode_mask & (T_ANALOG_TV | T_DIGITAL_TV)))
+			 (pos->mode_mask & T_ANALOG_TV))
 			*tv = pos;
 	}
 }
@@ -565,8 +565,7 @@ static int tuner_probe(struct i2c_client *client,
 			} else {
 				/* Default is being tda9887 */
 				t->type = TUNER_TDA9887;
-				t->mode_mask = T_RADIO | T_ANALOG_TV |
-					       T_DIGITAL_TV;
+				t->mode_mask = T_RADIO | T_ANALOG_TV;
 				goto register_client;
 			}
 			break;
@@ -596,7 +595,7 @@ static int tuner_probe(struct i2c_client *client,
 	   first found TV tuner. */
 	tuner_lookup(t->i2c->adapter, &radio, &tv);
 	if (tv == NULL) {
-		t->mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
+		t->mode_mask = T_ANALOG_TV;
 		if (radio == NULL)
 			t->mode_mask |= T_RADIO;
 		tuner_dbg("Setting mode_mask to 0x%02x\n", t->mode_mask);
@@ -607,18 +606,15 @@ register_client:
 	/* Sets a default mode */
 	if (t->mode_mask & T_ANALOG_TV)
 		t->mode = V4L2_TUNER_ANALOG_TV;
-	else if (t->mode_mask & T_RADIO)
-		t->mode = V4L2_TUNER_RADIO;
 	else
-		t->mode = V4L2_TUNER_DIGITAL_TV;
+		t->mode = V4L2_TUNER_RADIO;
 	set_type(client, t->type, t->mode_mask, t->config, t->fe.callback);
 	list_add_tail(&t->list, &tuner_list);
 
-	tuner_info("Tuner %d found with type(s)%s%s%s.\n",
+	tuner_info("Tuner %d found with type(s)%s%s.\n",
 		   t->type,
-		   t->mode_mask & T_RADIO ? " radio" : "",
-		   t->mode_mask & T_ANALOG_TV ? " TV" : "",
-		   t->mode_mask & T_ANALOG_TV ? " DTV" : "");
+		   t->mode_mask & T_RADIO ? " Radio" : "",
+		   t->mode_mask & T_ANALOG_TV ? " TV" : "");
 	return 0;
 }
 
-- 
1.7.1


