Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96B4C6369F
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 01:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEE1D20896
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 01:41:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729922AbfATBl1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 20:41:27 -0500
Received: from mail-out-3.itc.rwth-aachen.de ([134.130.5.48]:30888 "EHLO
        mail-out-3.itc.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728596AbfATBl1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 20:41:27 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jan 2019 20:41:26 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BXAAAIz0Nc/54agoZjHAEBAQQBAQcEA?=
 =?us-ascii?q?QGBUwUBAQsBggNmgSkKg3eUAYFomCaBewwBGAsJhECCXiI2Bw0BAwEBAgEBAm0?=
 =?us-ascii?q?cDIVNBSIECwFGNQImAio1DgWDIgGCAQQLqyx8M4kVgQgFCQGBAYZ1hEGCFoERJ?=
 =?us-ascii?q?wyFfQOEaYJXAolBmF8HAoEZiWKCd4QjHoohh3IBmnYCAgICCQIUgU0MJYFWcYM?=
 =?us-ascii?q?7gicXiCSFez8yAXoMIYdPAYEeAQE?=
X-IPAS-Result: =?us-ascii?q?A2BXAAAIz0Nc/54agoZjHAEBAQQBAQcEAQGBUwUBAQsBggN?=
 =?us-ascii?q?mgSkKg3eUAYFomCaBewwBGAsJhECCXiI2Bw0BAwEBAgEBAm0cDIVNBSIECwFGN?=
 =?us-ascii?q?QImAio1DgWDIgGCAQQLqyx8M4kVgQgFCQGBAYZ1hEGCFoERJwyFfQOEaYJXAol?=
 =?us-ascii?q?BmF8HAoEZiWKCd4QjHoohh3IBmnYCAgICCQIUgU0MJYFWcYM7gicXiCSFez8yA?=
 =?us-ascii?q?XoMIYdPAYEeAQE?=
X-IronPort-AV: E=Sophos;i="5.56,497,1539640800"; 
   d="scan'208";a="29765256"
Received: from rwthex-w2-a.rwth-ad.de ([134.130.26.158])
  by mail-in-3.itc.rwth-aachen.de with ESMTP; 20 Jan 2019 02:31:38 +0100
Received: from pebbles.fritz.box (93.131.73.199) by rwthex-w2-a.rwth-ad.de
 (2a00:8a60:1:e500::26:158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1531.3; Sun, 20
 Jan 2019 02:31:37 +0100
From:   =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
To:     <linux-kernel@vger.kernel.org>
CC:     <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?q?Stefan=20Br=C3=BCns?= <stefan.bruens@rwth-aachen.de>
Subject: [PATCH] media: dvbsky: Avoid leaking dvb frontend
Date:   Sun, 20 Jan 2019 02:30:04 +0100
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [93.131.73.199]
X-ClientProxiedBy: rwthex-w2-b.rwth-ad.de (2a00:8a60:1:e500::26:159) To
 rwthex-w2-a.rwth-ad.de (2a00:8a60:1:e500::26:158)
Message-ID: <caf0c144-4704-435e-aa17-42de54ce5c2d@rwthex-w2-a.rwth-ad.de>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Commit 14f4eaeddabc ("media: dvbsky: fix driver unregister logic") fixed
a use-after-free by removing the reference to the frontend after deleting
the backing i2c device.

This has the unfortunate side effect the frontend device is never freed
in the dvb core leaving a dangling device, leading to errors when the
dvb core tries to register the frontend after e.g. a replug as reported
here: https://www.spinics.net/lists/linux-media/msg138181.html

media: dvbsky: issues with DVBSky T680CI
===
[  561.119145] sp2 8-0040: CIMaX SP2 successfully attached
[  561.119161] usb 2-3: DVB: registering adapter 0 frontend 0 (Silicon Labs
Si2168)...
[  561.119174] sysfs: cannot create duplicate filename '/class/dvb/
dvb0.frontend0'
===

The use after free happened as dvb_usbv2_disconnect calls in this order:
- dvb_usb_device::props->exit(...)
- dvb_usbv2_adapter_frontend_exit(...)
  + if (fe) dvb_unregister_frontend(fe)
  + dvb_usb_device::props->frontend_detach(...)

Moving the release of the i2c device from exit() to frontend_detach()
avoids the dangling pointer access and allows the core to unregister
the frontend.

This was originally reported for a DVBSky T680CI, but it also affects
the MyGica T230C. As all supported devices structure the registration/
unregistration identically, apply the change for all device types.

Signed-off-by: Stefan Brüns <stefan.bruens@rwth-aachen.de>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index dffcadd8c834..3ff9833597e5 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -604,16 +604,18 @@ static int dvbsky_init(struct dvb_usb_device *d)
 	return 0;
 }
 
-static void dvbsky_exit(struct dvb_usb_device *d)
+static int dvbsky_frontend_detach(struct dvb_usb_adapter *adap)
 {
+	struct dvb_usb_device *d = adap_to_d(adap);
 	struct dvbsky_state *state = d_to_priv(d);
-	struct dvb_usb_adapter *adap = &d->adapter[0];
+
+	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, adap->id);
 
 	dvb_module_release(state->i2c_client_tuner);
 	dvb_module_release(state->i2c_client_demod);
 	dvb_module_release(state->i2c_client_ci);
 
-	adap->fe[0] = NULL;
+	return 0;
 }
 
 /* DVB USB Driver stuff */
@@ -629,11 +631,11 @@ static struct dvb_usb_device_properties dvbsky_s960_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_s960_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -656,11 +658,11 @@ static struct dvb_usb_device_properties dvbsky_s960c_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_s960c_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -683,11 +685,11 @@ static struct dvb_usb_device_properties dvbsky_t680c_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_t680c_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -710,11 +712,11 @@ static struct dvb_usb_device_properties dvbsky_t330_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_t330_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 	.read_mac_address = dvbsky_read_mac_addr,
 
 	.num_adapters = 1,
@@ -737,11 +739,11 @@ static struct dvb_usb_device_properties mygica_t230c_props = {
 
 	.i2c_algo         = &dvbsky_i2c_algo,
 	.frontend_attach  = dvbsky_mygica_t230c_attach,
+	.frontend_detach  = dvbsky_frontend_detach,
 	.init             = dvbsky_init,
 	.get_rc_config    = dvbsky_get_rc_config,
 	.streaming_ctrl   = dvbsky_streaming_ctrl,
 	.identify_state	  = dvbsky_identify_state,
-	.exit             = dvbsky_exit,
 
 	.num_adapters = 1,
 	.adapter = {
-- 
2.20.1

