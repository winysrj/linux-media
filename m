Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:51665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab0I3U0T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 16:26:19 -0400
Message-ID: <4CA4F261.3040506@redhat.com>
Date: Thu, 30 Sep 2010 17:26:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>
CC: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 03/10] V4L/DVB: tda18271: Add some hint about what tda18217
 reg ID returned
References: <cover.1285699057.git.mchehab@redhat.com>	<20100928154655.183af4b3@pedra>	<AANLkTindJwXKPpHgT=fN8NdNGstQHqGh+=FHu6xwYG3b@mail.gmail.com>	<4CA4E1FF.8090700@redhat.com> <AANLkTikkL_wDGEEdivfrV1dWbiyUHNXC4NpHjnn3-vJv@mail.gmail.com>
In-Reply-To: <AANLkTikkL_wDGEEdivfrV1dWbiyUHNXC4NpHjnn3-vJv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 30-09-2010 16:27, Michael Krufky escreveu:
> Mauro,
> 
> I think that's a reasonable explanation.  Would you be open to
> reworking the patch such that the register contents only show up if
> the device is not recognized?  (when ret < 0) . In the case where the
> device is correctly identified (ret == 0), I'd rather preserve the
> original successful detection message, and not see the ID register
> contents.

Patch enclosed.

---

[PATCH] V4L/DVB: tda18271: Add some hint about what tda18217 reg ID returned

Instead of doing:

[   82.581639] tda18271 4-0060: creating new instance
[   82.588411] Unknown device detected @ 4-0060, device not supported.
[   82.594695] tda18271_attach: [4-0060|M] error -22 on line 1272
[   82.600530] tda18271 4-0060: destroying instance

Print:
[  468.740392] Unknown device (0) detected @ 4-0060, device not supported.

for the error message, to help detecting what's going wrong with the
device.

This helps to detect when the driver is using the wrong I2C bus (or have
the i2g gate switch pointing to the wrong place), on devices like cx231xx
that just return 0 on reads to a non-existent i2c device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
index 7955e49..3db8727 100644
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -1156,7 +1156,6 @@ static int tda18271_get_id(struct dvb_frontend *fe)
 	struct tda18271_priv *priv = fe->tuner_priv;
 	unsigned char *regs = priv->tda18271_regs;
 	char *name;
-	int ret = 0;
 
 	mutex_lock(&priv->lock);
 	tda18271_read_regs(fe);
@@ -1172,17 +1171,18 @@ static int tda18271_get_id(struct dvb_frontend *fe)
 		priv->id = TDA18271HDC2;
 		break;
 	default:
-		name = "Unknown device";
-		ret = -EINVAL;
-		break;
+		tda_info("Unknown device (%i) detected @ %d-%04x, device not supported.\n",
+			 regs[R_ID],
+			 i2c_adapter_id(priv->i2c_props.adap),
+			 priv->i2c_props.addr);
+		return -EINVAL;
 	}
 
-	tda_info("%s detected @ %d-%04x%s\n", name,
+	tda_info("%s detected @ %d-%04x\n", name,
 		 i2c_adapter_id(priv->i2c_props.adap),
-		 priv->i2c_props.addr,
-		 (0 == ret) ? "" : ", device not supported.");
+		 priv->i2c_props.addr);
 
-	return ret;
+	return 0;
 }
 
 static int tda18271_setup_configuration(struct dvb_frontend *fe,

