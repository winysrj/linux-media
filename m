Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50286 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3DFKVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 06:21:15 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Adam Sampson <ats@offog.org>, linux-media@vger.kernel.org,
	jdonog01@eircom.net, bugzilla-kernel@tcnnet.com
Subject: Re: Hauppauge Nova-S-Plus DVB-S works for one channel, but cannot tune in others
Date: Sat, 06 Apr 2013 12:20:41 +0200
Message-ID: <2164572.6O2J60F4uN@xrated>
In-Reply-To: <20130405131854.6512bad6@redhat.com>
References: <1463242.ms8FUp7FVg@xrated> <y2ar4ipcggy.fsf@cartman.at.offog.org> <20130405131854.6512bad6@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1528086.N1USQ6dDgn"
Content-Transfer-Encoding: 7Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart1528086.N1USQ6dDgn
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Dear Mauro,

first of all, thank you for providing a proper fix that quickly.

On Freitag, 5. April 2013 13:18:54 Mauro Carvalho Chehab wrote:
> Em Fri, 05 Apr 2013 13:25:01 +0100
> 
> Adam Sampson <ats@offog.org> escreveu:
> > Hans-Peter Jansen <hpj@urpla.net> writes:
> > > In one of my systems, I've used a
> > > Hauppauge Nova-S-Plus DVB-S card successfully, but after a system
> > > upgrade to openSUSE 12.2, it cannot tune in all but one channel.
> > 
> > [...]
> > 
> > > initial transponder 12551500 V 22000000 5
> > > 
> > >>>> tune to: 12551:v:0:22000
> > > 
> > > DVB-S IF freq is 1951500
> > > WARNING: >>> tuning failed!!!
> > 
> > I suspect you might be running into this problem:
> >   https://bugzilla.kernel.org/show_bug.cgi?id=9476
> > 
> > The bug title is misleading -- the problem is actually that the card
> > doesn't get configured properly to send the 22kHz tone for high-band
> > transponders, like the one in your error above.
> > 
> > Applying this patch makes my Nova-S-Plus work with recent kernels:
> >   https://bugzilla.kernel.org/attachment.cgi?id=21905&action=edit
> 
> Applying that patch would break support for all other devices with
> isl6421.
> 
> Could you please test the enclosed patch? It allows the bridge
> driver to tell if the set_tone should be overrided by isl6421 or
> not. The code only changes it for Hauppauge model 92001.

Unfortunately, it appears to be more problematic. While the fix allows to scan 
the channel list, it is not complete (in another setup at the same dish (via 
multiswitch), vdrs channel list has about 1600 channels, while scan does 
collect 1138 only.

More importantly, a single channel (arte) is received with 0 BER and a S/N 
ratio of 99%, while all other channels produce more BER, eg. "Das Erste" with 
about 320 BER (SNR 99%, a few artifacts/distortions occasionally), 
"ZDF" about 6400 BER, (SNR drops down to 75%, constant distortions, and many 
channels doesn't produce anything beyond distortions with a video stream  
below 0.3 MBit/s and about 160000 BER. (measured using vdr femon plugin v. 
1.6.7)

So, still no cigar, sorry.

I've tested both patches, just to be sure, with the same result. I had to 
relocate and refresh yours in order to apply it to 3.4, since the paths 
changed, result attached.

> If it works, please answer this email with a:
> 	Tested-by: your name <your@email>
> 
> For me to add it when merging the patch upstream.
> 
> Regards,
> Mauro.

It looks like the idea is sound, but the logic is still missing something that 
prevents it from tuning most channels properly.

Cheers,
Pete


--nextPart1528086.N1USQ6dDgn
Content-Disposition: attachment; filename="Hauppauge_Nova-S-Plus_DVB-S_tune_fix.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="Hauppauge_Nova-S-Plus_DVB-S_tune_fix.patch"

From:	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] cx88: kernel bz#9476: Fix tone setting for Nova-S+ model 92001
References: https://bugzilla.kernel.org/show_bug.cgi?id=9476
Patch-mainline: pending

Hauppauge Nova-S-Plus DVB-S model 92001 does not lock on horizontal
polarisation. According with the info provided at the BZ, model
92002 does.

The difference is that, on model 92001, the tone select is done via
isl6421, while, on other devices, this is done via cx24123 code.

This patch adds a way to override the demod's set_tone at isl6421
driver. In order to avoid regressions, the override is enabled
only for cx88 Nova S plus model 92001. For all other models and
devices, the set_tone is provided by the demod driver.

Patch originally proposed at bz@9476[1] by Michel Meyers and
John Donoghue but applying the original patch would break support
for all other devices based on isl6421.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=9476

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Tested-by: Hans-Peter Jansen <hpj@urpla.net>

---
 drivers/media/dvb/b2c2/flexcop-fe-tuner.c |    4 ++--
 drivers/media/dvb/frontends/isl6421.c     |   28 +++++++++++++++++++++++++++-
 drivers/media/dvb/frontends/isl6421.h     |    4 ++--
 drivers/media/video/cx88/cx88-cards.c     |    1 +
 drivers/media/video/cx88/cx88-dvb.c       |   16 ++++++++++++----
 drivers/media/video/cx88/cx88.h           |    1 +
 drivers/media/video/saa7134/saa7134-dvb.c |    8 +++++---
 7 files changed, 50 insertions(+), 12 deletions(-)

--- a/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/dvb/b2c2/flexcop-fe-tuner.c
@@ -325,7 +325,7 @@ static int skystar2_rev27_attach(struct
 	/* enable no_base_addr - no repeated start when reading */
 	fc->fc_i2c_adap[2].no_base_addr = 1;
 	if (!dvb_attach(isl6421_attach, fc->fe, &fc->fc_i2c_adap[2].i2c_adap,
-			0x08, 1, 1)) {
+			0x08, 1, 1, false)) {
 		err("ISL6421 could NOT be attached");
 		goto fail_isl;
 	}
@@ -391,7 +391,7 @@ static int skystar2_rev28_attach(struct
 
 	fc->fc_i2c_adap[2].no_base_addr = 1;
 	if (!dvb_attach(isl6421_attach, fc->fe, &fc->fc_i2c_adap[2].i2c_adap,
-			0x08, 0, 0)) {
+			0x08, 0, 0, false)) {
 		err("ISL6421 could NOT be attached");
 		fc->fc_i2c_adap[2].no_base_addr = 0;
 		return 0;
--- a/drivers/media/dvb/frontends/isl6421.c
+++ b/drivers/media/dvb/frontends/isl6421.c
@@ -89,6 +89,30 @@ static int isl6421_enable_high_lnb_volta
 	return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
 }
 
+static int isl6421_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
+{
+	struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
+	struct i2c_msg msg = { .addr = isl6421->i2c_addr, .flags = 0,
+			       .buf = &isl6421->config,
+			       .len = sizeof(isl6421->config) };
+
+	switch (tone) {
+	case SEC_TONE_ON:
+		isl6421->config |= ISL6421_ENT1;
+		break;
+	case SEC_TONE_OFF:
+		isl6421->config &= ~ISL6421_ENT1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	isl6421->config |= isl6421->override_or;
+	isl6421->config &= isl6421->override_and;
+
+	return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
+}
+
 static void isl6421_release(struct dvb_frontend *fe)
 {
 	/* power off */
@@ -100,7 +124,7 @@ static void isl6421_release(struct dvb_f
 }
 
 struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
-		   u8 override_set, u8 override_clear)
+		   u8 override_set, u8 override_clear, bool override_tone)
 {
 	struct isl6421 *isl6421 = kmalloc(sizeof(struct isl6421), GFP_KERNEL);
 	if (!isl6421)
@@ -131,6 +155,8 @@ struct dvb_frontend *isl6421_attach(stru
 	/* override frontend ops */
 	fe->ops.set_voltage = isl6421_set_voltage;
 	fe->ops.enable_high_lnb_voltage = isl6421_enable_high_lnb_voltage;
+	if (override_tone)
+		fe->ops.set_tone = isl6421_set_tone;
 
 	return fe;
 }
--- a/drivers/media/dvb/frontends/isl6421.h
+++ b/drivers/media/dvb/frontends/isl6421.h
@@ -42,10 +42,10 @@
 #if defined(CONFIG_DVB_ISL6421) || (defined(CONFIG_DVB_ISL6421_MODULE) && defined(MODULE))
 /* override_set and override_clear control which system register bits (above) to always set & clear */
 extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
-			  u8 override_set, u8 override_clear);
+			  u8 override_set, u8 override_clear, bool override_tone);
 #else
 static inline struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
-						  u8 override_set, u8 override_clear)
+						  u8 override_set, u8 override_clear, bool override_tone)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -2855,6 +2855,7 @@ static void hauppauge_eeprom(struct cx88
 	core->board.tuner_type = tv.tuner_type;
 	core->tuner_formats = tv.tuner_formats;
 	core->board.radio.type = tv.has_radio ? CX88_RADIO : 0;
+	core->model = tv.model;
 
 	/* Make sure we support the board model */
 	switch (tv.model)
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -1036,7 +1036,7 @@ static int dvb_register(struct cx8802_de
 			if (!dvb_attach(isl6421_attach,
 					fe0->dvb.frontend,
 					&dev->core->i2c_adap,
-					0x08, ISL6421_DCL, 0x00))
+					0x08, ISL6421_DCL, 0x00, false))
 				goto frontend_detach;
 		}
 		/* MFE frontend 2 */
@@ -1273,8 +1273,16 @@ static int dvb_register(struct cx8802_de
 					       &hauppauge_novas_config,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
+			bool override_tone;
+
+			if (core->model == 92001)
+				override_tone = true;
+			else
+				override_tone = false;
+
 			if (!dvb_attach(isl6421_attach, fe0->dvb.frontend,
-					&core->i2c_adap, 0x08, ISL6421_DCL, 0x00))
+					&core->i2c_adap, 0x08, ISL6421_DCL, 0x00,
+					override_tone))
 				goto frontend_detach;
 		}
 		break;
@@ -1397,7 +1405,7 @@ static int dvb_register(struct cx8802_de
 			if (!dvb_attach(isl6421_attach,
 					fe0->dvb.frontend,
 					&dev->core->i2c_adap,
-					0x08, ISL6421_DCL, 0x00))
+					0x08, ISL6421_DCL, 0x00, false))
 				goto frontend_detach;
 		}
 		/* MFE frontend 2 */
@@ -1425,7 +1433,7 @@ static int dvb_register(struct cx8802_de
 			if (!dvb_attach(isl6421_attach,
 					fe0->dvb.frontend,
 					&dev->core->i2c_adap,
-					0x08, ISL6421_DCL, 0x00))
+					0x08, ISL6421_DCL, 0x00, false))
 				goto frontend_detach;
 		}
 		break;
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -342,6 +342,7 @@ struct cx88_core {
 	/* board name */
 	int                        nr;
 	char                       name[32];
+	u32			   model;
 
 	/* pci stuff */
 	int                        pci_bus;
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -1374,8 +1374,9 @@ static int dvb_init(struct saa7134_dev *
 					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
 					goto dettach_frontend;
 				}
-				if (dvb_attach(isl6421_attach, fe0->dvb.frontend, &dev->i2c_adap,
-										0x08, 0, 0) == NULL) {
+				if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
+					       &dev->i2c_adap,
+					       0x08, 0, 0, false) == NULL) {
 					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
 					goto dettach_frontend;
 				}
@@ -1492,7 +1493,8 @@ static int dvb_init(struct saa7134_dev *
 				goto dettach_frontend;
 			}
 			if (dvb_attach(isl6421_attach, fe0->dvb.frontend,
-				       &dev->i2c_adap, 0x08, 0, 0) == NULL) {
+				       &dev->i2c_adap,
+				       0x08, 0, 0, false) == NULL) {
 				wprintk("%s: No ISL6421 found!\n", __func__);
 				goto dettach_frontend;
 			}

--nextPart1528086.N1USQ6dDgn--

