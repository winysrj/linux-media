Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52485 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbbL3Nti (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 08:49:38 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/6] [media] dvb-usb-v2: postpone removal of media_device
Date: Wed, 30 Dec 2015 11:48:53 -0200
Message-Id: <cccfecf355eac4661feb925b076bdac3b5535ca5.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We should not remove the media_device until its last usage,
or we may have use after free troubles.

So, move the per-adapter media_device removal to happen at
the end of the adapter removal code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index e8491f73c0d9..f0565bf3673e 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -542,7 +542,6 @@ static int dvb_usbv2_adapter_dvb_exit(struct dvb_usb_adapter *adap)
 		adap->demux.dmx.close(&adap->demux.dmx);
 		dvb_dmxdev_release(&adap->dmxdev);
 		dvb_dmx_release(&adap->demux);
-		dvb_usbv2_media_device_unregister(adap);
 		dvb_unregister_adapter(&adap->dvb_adap);
 	}
 
@@ -852,6 +851,7 @@ static int dvb_usbv2_adapter_exit(struct dvb_usb_device *d)
 			dvb_usbv2_adapter_dvb_exit(&d->adapter[i]);
 			dvb_usbv2_adapter_stream_exit(&d->adapter[i]);
 			dvb_usbv2_adapter_frontend_exit(&d->adapter[i]);
+			dvb_usbv2_media_device_unregister(&d->adapter[i]);
 		}
 	}
 
-- 
2.5.0


