Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42774 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbaKRHVi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 02:21:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 6/6] rtl28xxu: add SDR module for devices having R828D tuner
Date: Tue, 18 Nov 2014 09:20:43 +0200
Message-Id: <1416295243-27300-6-git-send-email-crope@iki.fi>
In-Reply-To: <1416295243-27300-1-git-send-email-crope@iki.fi>
References: <1416295243-27300-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Load SDR sub-driver in order to support SDR for devices having
this tuner too.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a30ed17..896a225 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1113,6 +1113,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			adap->fe[1]->ops.read_signal_strength =
 					adap->fe[1]->ops.tuner_ops.get_rf_strength;
 		}
+
+		/* attach SDR */
+		dvb_attach_sdr(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
+				&rtl28xxu_rtl2832_r820t_config, NULL);
 		break;
 	default:
 		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
-- 
http://palosaari.fi/

