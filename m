Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:27879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab1GKB7s (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:48 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xlkx018148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:47 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKc030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:46 -0400
Date: Sun, 10 Jul 2011 22:58:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/21] [media] drxk: Allow to disable I2C Bridge control
 switch
Message-ID: <20110710225859.34c874cf@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On em28xx, tda18271C2 is accessible when the i2c port
is not touched. Touching on it breaks the driver.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index dd54512..9c99f31 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -7,6 +7,7 @@
 struct drxk_config {
 	u8 adr;
 	u32 single_master : 1;
+	u32 no_i2c_bridge : 1;
 	const char *microcode_name;
 };
 
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index adb454a..5233526 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -2784,6 +2784,8 @@ static int ConfigureI2CBridge(struct drxk_state *state, bool bEnableBridge)
 	if (state->m_DrxkState == DRXK_POWERED_DOWN)
 		return -1;
 
+	if (state->no_i2c_bridge)
+		return 0;
 	do {
 		status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
 		if (status < 0)
@@ -6360,6 +6362,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->demod_address = adr;
 	state->single_master = config->single_master;
 	state->microcode_name = config->microcode_name;
+	state->no_i2c_bridge = config->no_i2c_bridge;
 
 	mutex_init(&state->mutex);
 	mutex_init(&state->ctlock);
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 8cdadce..b042755 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -330,6 +330,7 @@ struct drxk_state {
 	/* Configurable parameters at the driver */
 
 	u32 single_master : 1;		/* Use single master i2c mode */
+	u32 no_i2c_bridge : 1;		/* Tuner is not on port 1, don't use I2C bridge */
 	const char *microcode_name;
 
 };
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 93f0af5..9b2be03 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -304,6 +304,7 @@ static struct drxd_config em28xx_drxd = {
 struct drxk_config terratec_h5_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
+	.no_i2c_bridge = 1,
 	.microcode_name = "terratec_h5.fw",
 };
 
-- 
1.7.1


