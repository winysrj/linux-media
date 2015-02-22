Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 01/10] [media] siano: add support for the media controller at USB driver
Date: Sun, 22 Feb 2015 13:11:32 -0300
Message-Id: <1424621501-17466-2-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
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
---
 drivers/media/common/siano/smscoreapi.h  |  6 ++++++
 drivers/media/common/siano/smsdvb-main.c | 20 +++++++++++++++++
 drivers/media/usb/siano/smsusb.c         | 37 ++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+)

diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 9c9063cd3208..efe4ab090aec 100644
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
+#if defined(CONFIG_MEDIA_CONTROLLER_DVB)
+	struct media_device *media_dev;
+#endif
 };
 
 /* GPIO definitions for antenna frequency domain control (SMS8021) */
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 85151efdd94c..042515915e20 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -613,6 +613,19 @@ static int smsdvb_onresponse(void *context, struct smscore_buffer_t *cb)
 	return 0;
 }
 
+static void smsdvb_media_device_unregister(struct smsdvb_client_t *client)
+{
+	struct smscore_device_t *coredev = client->coredev;
+
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	if (!coredev->media_dev)
+		return;
+	media_device_unregister(coredev->media_dev);
+	kfree(coredev->media_dev);
+	coredev->media_dev = NULL;
+#endif
+}
+
 static void smsdvb_unregister_client(struct smsdvb_client_t *client)
 {
 	/* must be called under clientslock */
@@ -624,6 +637,7 @@ static void smsdvb_unregister_client(struct smsdvb_client_t *client)
 	dvb_unregister_frontend(&client->frontend);
 	dvb_dmxdev_release(&client->dmxdev);
 	dvb_dmx_release(&client->demux);
+	smsdvb_media_device_unregister(client);
 	dvb_unregister_adapter(&client->adapter);
 	kfree(client);
 }
@@ -1096,6 +1110,9 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 		sms_err("dvb_register_adapter() failed %d", rc);
 		goto adapter_error;
 	}
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	client->adapter.mdev = coredev->media_dev;
+#endif
 
 	/* init dvb demux */
 	client->demux.dmx.capabilities = DMX_TS_FILTERING;
@@ -1175,6 +1192,8 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 	if (smsdvb_debugfs_create(client) < 0)
 		sms_info("failed to create debugfs node");
 
+	dvb_create_media_graph(coredev->media_dev);
+
 	return 0;
 
 client_error:
@@ -1187,6 +1206,7 @@ dmxdev_error:
 	dvb_dmx_release(&client->demux);
 
 dvbdmx_error:
+	smsdvb_media_device_unregister(client);
 	dvb_unregister_adapter(&client->adapter);
 
 adapter_error:
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 94e10b10b66e..4b6db7557e33 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -346,6 +346,42 @@ static void smsusb_term_device(struct usb_interface *intf)
 	usb_set_intfdata(intf, NULL);
 }
 
+static void siano_media_device_register(struct smsusb_device_t *dev)
+{
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
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

