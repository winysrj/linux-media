Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbbD2XG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 19:06:27 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Luis de Bethencourt <luis@debethencourt.com>,
	James Harper <james.harper@ejbdigital.com.au>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH 27/27] dib0700: fix bad indentation
Date: Wed, 29 Apr 2015 20:06:12 -0300
Message-Id: <eef3c4fd8dfcce749fff0d810b5013f60e7f3ec1.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
In-Reply-To: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
References: <89e5bc8de1ae960f10bd5ea465e7e4f7c6b8812a.1430348725.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb/dib0700_devices.c:864 dib7770_set_param_override() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index d7d55a20e959..90cee380d3aa 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -861,22 +861,22 @@ static int dib7770_set_param_override(struct dvb_frontend *fe)
 	struct dvb_usb_adapter *adap = fe->dvb->priv;
 	struct dib0700_adapter_state *state = adap->priv;
 
-	 u16 offset;
-	 u8 band = BAND_OF_FREQUENCY(p->frequency/1000);
-	 switch (band) {
-	 case BAND_VHF:
-		  state->dib7000p_ops.set_gpio(fe, 0, 0, 1);
-		  offset = 850;
-		  break;
-	 case BAND_UHF:
-	 default:
-		  state->dib7000p_ops.set_gpio(fe, 0, 0, 0);
-		  offset = 250;
-		  break;
-	 }
-	 deb_info("WBD for DiB7000P: %d\n", offset + dib0070_wbd_offset(fe));
-	 state->dib7000p_ops.set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
-	 return state->set_param_save(fe);
+	u16 offset;
+	u8 band = BAND_OF_FREQUENCY(p->frequency/1000);
+	switch (band) {
+	case BAND_VHF:
+		state->dib7000p_ops.set_gpio(fe, 0, 0, 1);
+		offset = 850;
+		break;
+	case BAND_UHF:
+	default:
+		state->dib7000p_ops.set_gpio(fe, 0, 0, 0);
+		offset = 250;
+		break;
+	}
+	deb_info("WBD for DiB7000P: %d\n", offset + dib0070_wbd_offset(fe));
+	state->dib7000p_ops.set_wbd_ref(fe, offset + dib0070_wbd_offset(fe));
+	return state->set_param_save(fe);
 }
 
 static int dib7770p_tuner_attach(struct dvb_usb_adapter *adap)
-- 
2.1.0

