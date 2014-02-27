Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59321 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbaB0Aal (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:30:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 11/16] rtl28xxu: fix switch-case style issue
Date: Thu, 27 Feb 2014 02:30:20 +0200
Message-Id: <1393461025-11857-12-git-send-email-crope@iki.fi>
In-Reply-To: <1393461025-11857-1-git-send-email-crope@iki.fi>
References: <1393461025-11857-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use break, not return, for every case.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 73348bf..afafe92 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -906,7 +906,6 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* attach SDR */
 		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_fc0012_config);
-		return 0;
 		break;
 	case TUNER_RTL2832_FC0013:
 		fe = dvb_attach(fc0013_attach, adap->fe[0],
@@ -919,7 +918,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* attach SDR */
 		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_fc0013_config);
-		return 0;
+		break;
 	case TUNER_RTL2832_E4000: {
 			struct e4000_config e4000_config = {
 				.fe = adap->fe[0],
-- 
1.8.5.3

