Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934549Ab3DGXxs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Apr 2013 19:53:48 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r37NrmO3030487
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 7 Apr 2013 19:53:48 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC PATCH 3/5] rtl28xxu: use r820t to obtain the signal strength
Date: Sun,  7 Apr 2013 20:53:28 -0300
Message-Id: <1365378810-1637-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1365378810-1637-1-git-send-email-mchehab@redhat.com>
References: <1365351031-22079-1-git-send-email-mchehab@redhat.com>
 <1365378810-1637-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we can get the strength from r820t, use it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 0a5b3c6..8b7fe62 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -913,6 +913,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 	case TUNER_RTL2832_R820T:
 		fe = dvb_attach(r820t_attach, adap->fe[0], &d->i2c_adap,
 				&rtl2832u_r820t_config);
+
+		/* Use tuner to get the signal strength */
+		adap->fe[0]->ops.read_signal_strength =
+				adap->fe[0]->ops.tuner_ops.get_rf_strength;
 		break;
 	default:
 		fe = NULL;
-- 
1.8.1.4

