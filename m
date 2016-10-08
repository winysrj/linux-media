Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:57298 "EHLO www.osadl.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752217AbcJHNOb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Oct 2016 09:14:31 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Alejandro Torrado <aletorrado@gmail.com>,
        Nicolas Sugino <nsugino@3way.com.ar>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH RFC] [media] dib0700: remove redundant else
Date: Sat,  8 Oct 2016 14:03:19 +0200
Message-Id: <1475928199-20315-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The if and else are identical and can be consolidated here.

Fixes: commit 91be260faaf8 ("[media] dib8000: Add support for Mygica/Geniatech S2870")

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Problem found by coccinelle script

Based only on reviewing this driver it seems that the dib0090_config
is not an array and thus this is a cut&past bug - but not having access
to the driver I can not say.  Other cases that have the
conditioning on (adap->id == 0) e.g. dib7070p_dib0070 actually have
a config array (dib7070p_dib0070_config[]). So the if/else here most
likely is unnecessary.

The patch is actually a partial revert of commit 91be260faaf8 ("[media]
dib8000: Add support for Mygica/Geniatech S2870") where this if/else
was deliberately introduced but without any specific comments.

This needs a review by someone that has access to the details of the driver.

Patch was compile tested with: x86_64_defconfig + CONFIG_MEDIA_SUPPORT=m,
CONFIG_MEDIA_USB_SUPPORT=y, CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y,
CONFIG_DVB_USB=m, CONFIG_DVB_USB_V2=m, CONFIG_MEDIA_RC_SUPPORT=y,
CONFIG_DVB_USB_DIB0700=m

Patch is against 4.8.0 (localversion-next is -next-20161006)

 drivers/media/usb/dvb-usb/dib0700_devices.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 0857b56..3cd8566 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -1736,13 +1736,9 @@ static int dib809x_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dib0700_adapter_state *st = adap->priv;
 	struct i2c_adapter *tun_i2c = st->dib8000_ops.get_i2c_master(adap->fe_adap[0].fe, DIBX000_I2C_INTERFACE_TUNER, 1);
 
-	if (adap->id == 0) {
-		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
-			return -ENODEV;
-	} else {
-		if (dvb_attach(dib0090_register, adap->fe_adap[0].fe, tun_i2c, &dib809x_dib0090_config) == NULL)
-			return -ENODEV;
-	}
+	if (dvb_attach(dib0090_register, adap->fe_adap[0].fe,
+		       tun_i2c, &dib809x_dib0090_config) == NULL)
+		return -ENODEV;
 
 	st->set_param_save = adap->fe_adap[0].fe->ops.tuner_ops.set_params;
 	adap->fe_adap[0].fe->ops.tuner_ops.set_params = dib8096_set_param_override;
-- 
2.1.4

