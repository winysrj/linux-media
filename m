Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbbCBOC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 09:02:58 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH 2/2] [media] dvb: Avoid warnings when compiled without the media controller
Date: Mon,  2 Mar 2015 11:02:48 -0300
Message-Id: <30ab99acb2faa3cbb408d9e22ebc6fe2fe4ce56a.1425304947.git.mchehab@osg.samsung.com>
In-Reply-To: <b32471cf9f1ac95ae4bf181c7abfcbd6382554d7.1425304947.git.mchehab@osg.samsung.com>
References: <b32471cf9f1ac95ae4bf181c7abfcbd6382554d7.1425304947.git.mchehab@osg.samsung.com>
In-Reply-To: <b32471cf9f1ac95ae4bf181c7abfcbd6382554d7.1425304947.git.mchehab@osg.samsung.com>
References: <b32471cf9f1ac95ae4bf181c7abfcbd6382554d7.1425304947.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function ‘dvb_usbv2_adapter_dvb_exit’:
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:531:25: warning: unused variable ‘d’ [-Wunused-variable]
  struct dvb_usb_device *d = adap_to_d(adap);
                         ^
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:403:13: warning: ‘dvb_usbv2_media_device_register’ defined but not used [-Wunused-function]
 static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)

drivers/media/usb/dvb-usb/dvb-usb-dvb.c:97:13: warning: ‘dvb_usb_media_device_register’ defined but not used [-Wunused-function]
 static void dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
             ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 387db145d37e..c739725ca7ee 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -611,9 +611,9 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 
 static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
 {
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	struct smscore_device_t *coredev = client->coredev;
 
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	if (!coredev->media_dev)
 		return;
 	media_device_unregister(coredev->media_dev);
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 08a3cd1c8b44..8bd08ba4f869 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -467,9 +467,7 @@ static int dvb_usbv2_adapter_dvb_init(struct dvb_usb_adapter *adap)
 
 	adap->dvb_adap.priv = adap;
 
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	dvb_usbv2_media_device_register(adap);
-#endif
 
 	if (d->props->read_mac_address) {
 		ret = d->props->read_mac_address(adap,
@@ -528,8 +526,6 @@ err_dvb_register_adapter:
 
 static int dvb_usbv2_adapter_dvb_exit(struct dvb_usb_adapter *adap)
 {
-	struct dvb_usb_device *d = adap_to_d(adap);
-
 	dev_dbg(&adap_to_d(adap)->udev->dev, "%s: adap=%d\n", __func__,
 			adap->id);
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 6c9f5ecf949c..980d976960d9 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -153,9 +153,7 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 	}
 	adap->dvb_adap.priv = adap;
 
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	dvb_usb_media_device_register(adap);
-#endif
 
 	if (adap->dev->props.read_mac_address) {
 		if (adap->dev->props.read_mac_address(adap->dev,adap->dvb_adap.proposed_mac) == 0)
-- 
2.1.0

