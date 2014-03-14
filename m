Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36708 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbaCNAOt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 20:14:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/17] rtl28xxu: fix switch-case style issue
Date: Fri, 14 Mar 2014 02:14:23 +0200
Message-Id: <1394756071-22410-10-git-send-email-crope@iki.fi>
In-Reply-To: <1394756071-22410-1-git-send-email-crope@iki.fi>
References: <1394756071-22410-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use break, not return, for every case.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 61b420c..f51949e 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -907,7 +907,6 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* attach SDR */
 		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_fc0012_config, NULL);
-		return 0;
 		break;
 	case TUNER_RTL2832_FC0013:
 		fe = dvb_attach(fc0013_attach, adap->fe[0],
@@ -920,7 +919,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		/* attach SDR */
 		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
 				&rtl28xxu_rtl2832_fc0013_config, NULL);
-		return 0;
+		break;
 	case TUNER_RTL2832_E4000: {
 			struct v4l2_subdev *sd;
 			struct e4000_config e4000_config = {
-- 
1.8.5.3

