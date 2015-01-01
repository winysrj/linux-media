Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57603 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbbAAPvo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Jan 2015 10:51:44 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] cx231xx: add media controller support for mb86a20s boards
Date: Thu,  1 Jan 2015 13:51:26 -0200
Message-Id: <7b269127039f2d7e5b01b75bbddbf7a5fe4d85d1.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1420127255.git.mchehab@osg.samsung.com>
References: <cover.1420127255.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add experimental support for the media controlers, on boards
that have mb86a20s (and use the new dvb core I2C binding).

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index e6b6da44b1e5..d772d386849f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -65,6 +65,10 @@ struct cx231xx_dvb {
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
 	struct i2c_client *i2c_client_tuner;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *media_dev;
+#endif
 };
 
 static struct s5h1432_config dvico_s5h1432_config = {
@@ -562,6 +566,7 @@ fail_adapter:
 static void unregister_dvb(struct cx231xx_dvb *dvb)
 {
 	struct i2c_client *client;
+
 	dvb_net_release(&dvb->net);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_mem);
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
@@ -573,6 +578,13 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
 	}
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (dvb->media_dev) {
+		media_device_unregister(dvb->media_dev);
+		kfree(dvb->media_dev);
+		dvb->media_dev = NULL;
+	}
+#endif
 	dvb_unregister_frontend(dvb->frontend);
 	dvb_frontend_detach(dvb->frontend);
 	dvb_unregister_adapter(&dvb->adapter);
@@ -813,16 +825,45 @@ static int dvb_init(struct cx231xx *dev)
 	}
 
 	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
-	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
+	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID: {
+#ifdef CONFIG_MEDIA_CONTROLLER
+		struct media_device *mdev;
+#endif
 
 		dev_info(dev->dev,
 			 "%s: looking for demod on i2c bus: %d\n",
 			 __func__, i2c_adapter_id(tuner_i2c));
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+		mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+		if (mdev) {
+			mdev->dev = dev->dev;
+			strlcpy(mdev->model, dev->board.name,
+				sizeof(mdev->model));
+			if (dev->udev->serial)
+				strlcpy(mdev->serial, dev->udev->serial,
+					sizeof(mdev->serial));
+			strcpy(mdev->bus_info, dev->udev->devpath);
+			mdev->hw_revision = le16_to_cpu(dev->udev->descriptor.bcdDevice);
+			mdev->driver_version = LINUX_VERSION_CODE;
+
+			result = media_device_register(mdev);
+			if (result) {
+				dev_err(dev->dev,
+					"Couln't create a media device. Error: %d\n",
+					result);
+				kfree(mdev);
+				mdev = NULL;
+			} else {
+				dvb->media_dev = mdev;
+			}
+		}
+#endif
+
 		dev->dvb->frontend = dvb_i2c_attach_fe(demod_i2c,
 						       &mb86a20s_board_info,
 						       &pv_mb86a20s_config,
-						       NULL, NULL);
+						       NULL, mdev);
 		if (dev->dvb->frontend == NULL) {
 			dev_err(dev->dev,
 				"Failed to attach mb86a20s demod\n");
@@ -837,7 +878,7 @@ static int dvb_init(struct cx231xx *dev)
 			   0x60, tuner_i2c,
 			   &pv_tda18271_config);
 		break;
-
+	}
 	default:
 		dev_err(dev->dev,
 			"%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
@@ -866,6 +907,13 @@ ret:
 	return result;
 
 out_free:
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (dvb->media_dev) {
+		media_device_unregister(dvb->media_dev);
+		kfree(dvb->media_dev);
+		dvb->media_dev = NULL;
+	}
+#endif
 	kfree(dvb);
 	dev->dvb = NULL;
 	goto ret;
-- 
2.1.0

