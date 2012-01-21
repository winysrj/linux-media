Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab2AUQEn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:43 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4hcN023681
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 12/35] [media] drxk: Don't assume a default firmware name
Date: Sat, 21 Jan 2012 14:04:14 -0200
Message-Id: <1327161877-16784-13-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-12-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move the ngene/ddbridge firmware into their drivers.

There are two reasons for that:
	1) The firmware used there didn't work for a few devices
I tested here (Terratec H5, H6 and H7);
	2) At least Terratec H7 doesn't seem to require a firmware
for it to work.

After this change, if firmware is not specified, the driver will
use a rom-based firmware (this seems to be the case for Terratec
H7, although I need to better check the USB dumps to be sure about
that).

In any case, the firmware seems to be optional, as the DRX-K driver
don't return the firmware load error.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |    1 +
 drivers/media/dvb/dvb-usb/az6007.c         |    8 +++++---
 drivers/media/dvb/frontends/drxk_hard.c    |    4 +---
 drivers/media/dvb/ngene/ngene-cards.c      |    1 +
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index 2f31648..243dbb3 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -578,6 +578,7 @@ static int demod_attach_drxk(struct ddb_input *input)
 	struct drxk_config config;
 
 	memset(&config, 0, sizeof(config));
+	config.microcode_name = "drxk_a3.mc";
 	config.adr = 0x29 + (input->nr & 1);
 
 	fe = input->fe = dvb_attach(drxk_attach, &config, i2c);
diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index bb597c6..523972f 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -55,7 +55,8 @@ static struct drxk_config terratec_h7_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 0,
-	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
+	.max_size = 64,
+//	.microcode_name = "dvb-usb-terratec-h5-drxk.fw",
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
@@ -127,7 +128,8 @@ static int az6007_usb_out_op(struct dvb_usb_device *d, u8 req, u16 value,
 	debug_dump(b, blen, deb_xfer);
 
 	if (blen > 64) {
-		err("az6007: doesn't suport I2C transactions longer than 64 bytes\n");
+		err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\n",
+		    blen);
 		return -EOPNOTSUPP;
 	}
 
@@ -395,6 +397,7 @@ static int az6007_frontend_attach(struct dvb_usb_adapter *adap)
 	adap->fe2->tuner_priv = adap->fe->tuner_priv;
 	memcpy(&adap->fe2->ops.tuner_ops,
 	       &adap->fe->ops.tuner_ops, sizeof(adap->fe->ops.tuner_ops));
+
 	return 0;
 
 out_free:
@@ -572,7 +575,6 @@ static struct dvb_usb_device_properties az6007_properties = {
 	.num_adapters = 1,
 	.adapter = {
 		{
-			/* .caps             = DVB_USB_ADAP_RECEIVES_204_BYTE_TS, */
 			.streaming_ctrl   = az6007_streaming_ctrl,
 			.frontend_attach  = az6007_frontend_attach,
 
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 6980ed7..4b99255 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6070,9 +6070,7 @@ static int init_drxk(struct drxk_state *state)
 		if (status < 0)
 			goto error;
 
-		if (!state->microcode_name)
-			load_microcode(state, "drxk_a3.mc");
-		else
+		if (state->microcode_name)
 			load_microcode(state, state->microcode_name);
 
 		/* disable token-ring bus through OFDM block for possible ucode upload */
diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 8418c02..7539a5d 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -216,6 +216,7 @@ static int demod_attach_drxk(struct ngene_channel *chan,
 	struct drxk_config config;
 
 	memset(&config, 0, sizeof(config));
+	config.microcode_name = "drxk_a3.mc";
 	config.adr = 0x29 + (chan->number ^ 2);
 
 	chan->fe = dvb_attach(drxk_attach, &config, i2c);
-- 
1.7.8

