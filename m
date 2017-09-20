Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:56640 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751506AbdITTNy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 15:13:54 -0400
Subject: [PATCH 3/3] [media] dvb-ttusb-budget: Adjust eight checks for null
 pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <1ad3c3ce-3738-fee1-2ee5-37142fa1bc70@users.sourceforge.net>
Message-ID: <cb344cfe-4e36-e8e5-0baf-b093fe954fd4@users.sourceforge.net>
Date: Wed, 20 Sep 2017 21:13:35 +0200
MIME-Version: 1.0
In-Reply-To: <1ad3c3ce-3738-fee1-2ee5-37142fa1bc70@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 20 Sep 2017 20:53:13 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written …

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
index fef3c8554e91..2e97b1e64249 100644
--- a/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c
@@ -1572,7 +1572,7 @@ static void frontend_init(struct ttusb* ttusb)
 	case 0x1003: // Hauppauge/TT Nova-USB-S budget (stv0299/ALPS BSRU6|BSBE1(tsa5059))
 		// try the stv0299 based first
 		ttusb->fe = dvb_attach(stv0299_attach, &alps_stv0299_config, &ttusb->i2c_adap);
-		if (ttusb->fe != NULL) {
+		if (ttusb->fe) {
 			ttusb->fe->ops.tuner_ops.set_params = philips_tsa5059_tuner_set_params;
 
 			if(ttusb->revision == TTUSB_REV_2_2) { // ALPS BSBE1
@@ -1586,7 +1586,7 @@ static void frontend_init(struct ttusb* ttusb)
 
 		// Grundig 29504-491
 		ttusb->fe = dvb_attach(tda8083_attach, &ttusb_novas_grundig_29504_491_config, &ttusb->i2c_adap);
-		if (ttusb->fe != NULL) {
+		if (ttusb->fe) {
 			ttusb->fe->ops.tuner_ops.set_params = ttusb_novas_grundig_29504_491_tuner_set_params;
 			ttusb->fe->ops.set_voltage = ttusb_set_voltage;
 			break;
@@ -1595,13 +1595,13 @@ static void frontend_init(struct ttusb* ttusb)
 
 	case 0x1004: // Hauppauge/TT DVB-C budget (ves1820/ALPS TDBE2(sp5659))
 		ttusb->fe = dvb_attach(ves1820_attach, &alps_tdbe2_config, &ttusb->i2c_adap, read_pwm(ttusb));
-		if (ttusb->fe != NULL) {
+		if (ttusb->fe) {
 			ttusb->fe->ops.tuner_ops.set_params = alps_tdbe2_tuner_set_params;
 			break;
 		}
 
 		ttusb->fe = dvb_attach(stv0297_attach, &dvbc_philips_tdm1316l_config, &ttusb->i2c_adap);
-		if (ttusb->fe != NULL) {
+		if (ttusb->fe) {
 			ttusb->fe->ops.tuner_ops.set_params = dvbc_philips_tdm1316l_tuner_set_params;
 			break;
 		}
@@ -1610,14 +1610,14 @@ static void frontend_init(struct ttusb* ttusb)
 	case 0x1005: // Hauppauge/TT Nova-USB-t budget (tda10046/Philips td1316(tda6651tt) OR cx22700/ALPS TDMB7(??))
 		// try the ALPS TDMB7 first
 		ttusb->fe = dvb_attach(cx22700_attach, &alps_tdmb7_config, &ttusb->i2c_adap);
-		if (ttusb->fe != NULL) {
+		if (ttusb->fe) {
 			ttusb->fe->ops.tuner_ops.set_params = alps_tdmb7_tuner_set_params;
 			break;
 		}
 
 		// Philips td1316
 		ttusb->fe = dvb_attach(tda10046_attach, &philips_tdm1316l_config, &ttusb->i2c_adap);
-		if (ttusb->fe != NULL) {
+		if (ttusb->fe) {
 			ttusb->fe->ops.tuner_ops.init = philips_tdm1316l_tuner_init;
 			ttusb->fe->ops.tuner_ops.set_params = philips_tdm1316l_tuner_set_params;
 			break;
@@ -1625,7 +1625,7 @@ static void frontend_init(struct ttusb* ttusb)
 		break;
 	}
 
-	if (ttusb->fe == NULL) {
+	if (!ttusb->fe) {
 		printk("dvb-ttusb-budget: A frontend driver was not found for device [%04x:%04x]\n",
 		       le16_to_cpu(ttusb->dev->descriptor.idVendor),
 		       le16_to_cpu(ttusb->dev->descriptor.idProduct));
@@ -1781,7 +1781,7 @@ static void ttusb_disconnect(struct usb_interface *intf)
 	dvb_net_release(&ttusb->dvbnet);
 	dvb_dmxdev_release(&ttusb->dmxdev);
 	dvb_dmx_release(&ttusb->dvb_demux);
-	if (ttusb->fe != NULL) {
+	if (ttusb->fe) {
 		dvb_unregister_frontend(ttusb->fe);
 		dvb_frontend_detach(ttusb->fe);
 	}
-- 
2.14.1
