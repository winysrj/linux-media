Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbBRPaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 10:30:12 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] [media] cx231xx: fix compilation if the media controller is not defined
Date: Wed, 18 Feb 2015 13:29:56 -0200
Message-Id: <9250f0139f21e0ccfeb1441a252fe7ae904b7066.1424273378.git.mchehab@osg.samsung.com>
In-Reply-To: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
In-Reply-To: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/usb/cx231xx/cx231xx-cards.c: In function ‘cx231xx_usb_probe’:
drivers/media/usb/cx231xx/cx231xx-cards.c:1589:15: error: ‘struct v4l2_device’ has no member named ‘mdev’
  dev->v4l2_dev.mdev = dev->media_dev;
               ^
drivers/media/usb/cx231xx/cx231xx-cards.c:1589:26: error: ‘struct cx231xx’ has no member named ‘media_dev’
  dev->v4l2_dev.mdev = dev->media_dev;
                          ^
scripts/Makefile.build:257: recipe for target 'drivers/media/usb/cx231xx/cx231xx-cards.o' failed

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index dfc7010cff7f..372b70eb042c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1586,7 +1586,9 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 	cx231xx_media_device_register(dev, udev);
 
 	/* Create v4l2 device */
+#ifdef CONFIG_MEDIA_CONTROLLER
 	dev->v4l2_dev.mdev = dev->media_dev;
+#endif
 	retval = v4l2_device_register(&interface->dev, &dev->v4l2_dev);
 	if (retval) {
 		dev_err(d, "v4l2_device_register failed\n");
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index e8c054c4ac8c..44229a2c2d32 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -540,7 +540,9 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 
 	/* register network adapter */
 	dvb_net_init(&dvb->adapter, &dvb->net, &dvb->demux.dmx);
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
 	dvb_create_media_graph(dev->media_dev);
+#endif
 	return 0;
 
 fail_fe_conn:
-- 
2.1.0

