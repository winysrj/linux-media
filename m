Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbbAHU5u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jan 2015 15:57:50 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Satoshi Nagahama <sattnag@aim.com>
Subject: [PATCH] siano: add support for the media controller at USB driver
Date: Thu,  8 Jan 2015 18:57:34 -0200
Message-Id: <e65deef3202b975a50acd594ffb1ee2df9cb10b1.1420749320.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding support for the media controller for a pure DVB device
is simple: just create a struct media_device and add it to the
dvb adapter. After creating all DVB devices, we need to call
the DVB core, for it to create the media graph.

More work is needed for pure DVB tuners, but this is hidden
at the Siano driver, just like several others non-hybrid
devices. So, this is streight forward.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 9c9063cd3208..bf467db5d0b6 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -31,6 +31,8 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include <linux/wait.h>
 #include <linux/timer.h>
 
+#include <media/media-device.h>
+
 #include <asm/page.h>
 
 #include "smsir.h"
@@ -215,6 +217,10 @@ struct smscore_device_t {
 	bool is_usb_device;
 
 	int led_state;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *media_dev;
+#endif
 };
 
 /* GPIO definitions for antenna frequency domain control (SMS8021) */
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 85151efdd94c..6872abc3c94b 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1096,6 +1096,9 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 		sms_err("dvb_register_adapter() failed %d", rc);
 		goto adapter_error;
 	}
+#ifdef CONFIG_MEDIA_CONTROLLER
+	client->adapter.mdev = coredev->media_dev;
+#endif
 
 	/* init dvb demux */
 	client->demux.dmx.capabilities = DMX_TS_FILTERING;
@@ -1175,6 +1178,8 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	if (smsdvb_debugfs_create(client) < 0)
 		sms_info("failed to create debugfs node");
 
+	dvb_create_media_graph(coredev->media_dev);
+
 	return 0;
 
 client_error:
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 94e10b10b66e..68adde1ca749 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -346,6 +346,42 @@ static void smsusb_term_device(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 }
 
+static void siano_media_device_register(struct smsusb_device_t *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER
+	struct media_device *mdev;
+	struct usb_device *udev = dev->udev;
+	int board_id = smscore_get_board_id(dev->coredev);
+	struct sms_board *board = sms_get_board(board_id);
+	int ret;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return;
+
+	mdev->dev = &udev->dev;
+	strlcpy(mdev->model, board->name, sizeof(mdev->model));
+	if (udev->serial)
+		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+	strcpy(mdev->bus_info, udev->devpath);
+	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
+	mdev->driver_version = LINUX_VERSION_CODE;
+
+	ret = media_device_register(mdev);
+	if (ret) {
+		sms_err("Couldn't create a media device. Error: %d\n",
+			ret);
+		kfree(mdev);
+		return;
+	}
+
+	dev->coredev->media_dev = mdev;
+
+	sms_info("media controller created");
+
+#endif
+}
+
 static int smsusb_init_device(struct usb_interface *intf, int board_id)
 {
 	struct smsdevice_params_t params;
@@ -439,6 +475,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	}
 
 	sms_info("device 0x%p created", dev);
+	siano_media_device_register(dev);
 
 	return rc;
 }
-- 
2.1.0

