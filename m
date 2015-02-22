Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48103 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/10] [media] siano: replace sms_debug() by pr_debug()
Date: Sun, 22 Feb 2015 13:11:37 -0300
Message-Id: <1424621501-17466-7-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no reason to use a macro here. Just replace everything,
and let those debug messages to be activated via dynamic printk.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/sms-cards.c   |  2 +-
 drivers/media/common/siano/smscoreapi.c  | 39 ++++++++++++++++----------------
 drivers/media/common/siano/smscoreapi.h  |  5 ----
 drivers/media/common/siano/smsdvb-main.c | 22 +++++++++---------
 drivers/media/usb/siano/smsusb.c         | 10 ++++----
 5 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 9c7a9452c04c..3745a2610ef9 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -342,7 +342,7 @@ int sms_board_lna_control(struct smscore_device_t *coredev, int onoff)
 	int board_id = smscore_get_board_id(coredev);
 	struct sms_board *board = sms_get_board(board_id);
 
-	sms_debug("%s: LNA %s", __func__, onoff ? "enabled" : "disabled");
+	pr_debug("%s: LNA %s\n", __func__, onoff ? "enabled" : "disabled");
 
 	switch (board_id) {
 	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 1f99698a211e..e5bde84ec0be 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -841,7 +841,7 @@ static int smscore_configure_board(struct smscore_device_t *coredev)
 
 	if (board->mtu) {
 		struct sms_msg_data mtu_msg;
-		sms_debug("set max transmit unit %d", board->mtu);
+		pr_debug("set max transmit unit %d\n", board->mtu);
 
 		mtu_msg.x_msg_header.msg_src_id = 0;
 		mtu_msg.x_msg_header.msg_dst_id = HIF_TASK;
@@ -856,7 +856,7 @@ static int smscore_configure_board(struct smscore_device_t *coredev)
 
 	if (board->crystal) {
 		struct sms_msg_data crys_msg;
-		sms_debug("set crystal value %d", board->crystal);
+		pr_debug("set crystal value %d\n", board->crystal);
 
 		SMS_INIT_MSG(&crys_msg.x_msg_header,
 				MSG_SMS_NEW_CRYSTAL_REQ,
@@ -941,7 +941,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		return -ENOMEM;
 
 	if (coredev->mode != DEVICE_MODE_NONE) {
-		sms_debug("sending reload command.");
+		pr_debug("sending reload command.\n");
 		SMS_INIT_MSG(&msg->x_msg_header, MSG_SW_RELOAD_START_REQ,
 			     sizeof(struct sms_msg_hdr));
 		rc = smscore_sendrequest_and_wait(coredev, msg,
@@ -982,7 +982,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 	if (rc < 0)
 		goto exit_fw_download;
 
-	sms_debug("sending MSG_SMS_DATA_VALIDITY_REQ expecting 0x%x",
+	pr_debug("sending MSG_SMS_DATA_VALIDITY_REQ expecting 0x%x\n",
 		calc_checksum);
 	SMS_INIT_MSG(&msg->x_msg_header, MSG_SMS_DATA_VALIDITY_REQ,
 			sizeof(msg->x_msg_header) +
@@ -1001,7 +1001,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 		struct sms_msg_data *trigger_msg =
 			(struct sms_msg_data *) msg;
 
-		sms_debug("sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ");
+		pr_debug("sending MSG_SMS_SWDOWNLOAD_TRIGGER_REQ\n");
 		SMS_INIT_MSG(&msg->x_msg_header,
 				MSG_SMS_SWDOWNLOAD_TRIGGER_REQ,
 				sizeof(struct sms_msg_hdr) +
@@ -1037,12 +1037,13 @@ exit_fw_download:
 	kfree(msg);
 
 	if (coredev->postload_handler) {
-		sms_debug("rc=%d, postload=0x%p", rc, coredev->postload_handler);
+		pr_debug("rc=%d, postload=0x%p\n",
+			 rc, coredev->postload_handler);
 		if (rc >= 0)
 			return coredev->postload_handler(coredev->context);
 	}
 
-	sms_debug("rc=%d", rc);
+	pr_debug("rc=%d\n", rc);
 	return rc;
 }
 
@@ -1121,11 +1122,11 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
 	if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX)
 		return NULL;
 
-	sms_debug("trying to get fw name from sms_boards board_id %d mode %d",
+	pr_debug("trying to get fw name from sms_boards board_id %d mode %d\n",
 		  board_id, mode);
 	fw = sms_get_board(board_id)->fw;
 	if (!fw || !fw[mode]) {
-		sms_debug("cannot find fw name in sms_boards, getting from lookup table mode %d type %d",
+		pr_debug("cannot find fw name in sms_boards, getting from lookup table mode %d type %d\n",
 			  mode, type);
 		return smscore_fw_lkup[type][mode];
 	}
@@ -1157,7 +1158,7 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 		pr_err("mode %d not supported on this device\n", mode);
 		return -ENOENT;
 	}
-	sms_debug("Firmware name: %s", fw_filename);
+	pr_debug("Firmware name: %s\n", fw_filename);
 
 	if (loadfirmware_handler == NULL && !(coredev->device_flags
 			& SMS_DEVICE_FAMILY2))
@@ -1339,7 +1340,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 {
 	int rc = 0;
 
-	sms_debug("set device mode to %d", mode);
+	pr_debug("set device mode to %d\n", mode);
 	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
 		if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX) {
 			pr_err("invalid mode specified %d\n", mode);
@@ -1416,7 +1417,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 	if (rc < 0)
 		pr_err("return error code %d.\n", rc);
 	else
-		sms_debug("Success setting device mode.");
+		pr_debug("Success setting device mode.\n");
 
 	return rc;
 }
@@ -1495,7 +1496,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		last_sample_time = time_now;
 
 	if (time_now - last_sample_time > 10000) {
-		sms_debug("data rate %d bytes/secs",
+		pr_debug("data rate %d bytes/secs\n",
 			  (int)((data_total * 1000) /
 				(time_now - last_sample_time)));
 
@@ -1539,7 +1540,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		{
 			struct sms_version_res *ver =
 				(struct sms_version_res *) phdr;
-			sms_debug("Firmware id %d prots 0x%x ver %d.%d",
+			pr_debug("Firmware id %d prots 0x%x ver %d.%d\n",
 				  ver->firmware_id, ver->supported_protocols,
 				  ver->rom_ver_major, ver->rom_ver_minor);
 
@@ -1562,7 +1563,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		{
 			struct sms_msg_data *validity = (struct sms_msg_data *) phdr;
 
-			sms_debug("MSG_SMS_DATA_VALIDITY_RES, checksum = 0x%x",
+			pr_debug("MSG_SMS_DATA_VALIDITY_RES, checksum = 0x%x\n",
 				validity->msg_data[0]);
 			complete(&coredev->data_validity_done);
 			break;
@@ -1588,7 +1589,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 		{
 			u32 *msgdata = (u32 *) phdr;
 			coredev->gpio_get_res = msgdata[1];
-			sms_debug("gpio level %d",
+			pr_debug("gpio level %d\n",
 					coredev->gpio_get_res);
 			complete(&coredev->gpio_get_level_done);
 			break;
@@ -1615,7 +1616,7 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 			break;
 
 		default:
-			sms_debug("message %s(%d) not handled.",
+			pr_debug("message %s(%d) not handled.\n",
 				  smscore_translate_msg(phdr->msg_type),
 				  phdr->msg_type);
 			break;
@@ -1746,7 +1747,7 @@ int smscore_register_client(struct smscore_device_t *coredev,
 	smscore_validate_client(coredev, newclient, params->data_type,
 				params->initial_id);
 	*client = newclient;
-	sms_debug("%p %d %d", params->context, params->data_type,
+	pr_debug("%p %d %d\n", params->context, params->data_type,
 		  params->initial_id);
 
 	return 0;
@@ -2163,7 +2164,7 @@ static void __exit smscore_module_exit(void)
 	}
 	kmutex_unlock(&g_smscore_registrylock);
 
-	sms_debug("");
+	pr_debug("\n");
 }
 
 module_init(smscore_module_init);
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index ab6506fd65c8..ef735681cb8e 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -1184,9 +1184,4 @@ int smscore_led_state(struct smscore_device_t *core, int led);
 		pr_info(fmt "\n", ##arg); \
 } while (0)
 
-#define sms_debug(fmt, arg...) do {\
-        if (sms_dbg & DBG_ADV) \
-                printk(KERN_DEBUG pr_fmt(fmt "\n"), ##arg); \
-} while (0)
-
 #endif /* __SMS_CORE_API_H__ */
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index c63fe9a889d5..7f1d497ca298 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -83,42 +83,42 @@ static void sms_board_dvb3_event(struct smsdvb_client_t *client,
 	struct smscore_device_t *coredev = client->coredev;
 	switch (event) {
 	case DVB3_EVENT_INIT:
-		sms_debug("DVB3_EVENT_INIT");
+		pr_debug("DVB3_EVENT_INIT\n");
 		sms_board_event(coredev, BOARD_EVENT_BIND);
 		break;
 	case DVB3_EVENT_SLEEP:
-		sms_debug("DVB3_EVENT_SLEEP");
+		pr_debug("DVB3_EVENT_SLEEP\n");
 		sms_board_event(coredev, BOARD_EVENT_POWER_SUSPEND);
 		break;
 	case DVB3_EVENT_HOTPLUG:
-		sms_debug("DVB3_EVENT_HOTPLUG");
+		pr_debug("DVB3_EVENT_HOTPLUG\n");
 		sms_board_event(coredev, BOARD_EVENT_POWER_INIT);
 		break;
 	case DVB3_EVENT_FE_LOCK:
 		if (client->event_fe_state != DVB3_EVENT_FE_LOCK) {
 			client->event_fe_state = DVB3_EVENT_FE_LOCK;
-			sms_debug("DVB3_EVENT_FE_LOCK");
+			pr_debug("DVB3_EVENT_FE_LOCK\n");
 			sms_board_event(coredev, BOARD_EVENT_FE_LOCK);
 		}
 		break;
 	case DVB3_EVENT_FE_UNLOCK:
 		if (client->event_fe_state != DVB3_EVENT_FE_UNLOCK) {
 			client->event_fe_state = DVB3_EVENT_FE_UNLOCK;
-			sms_debug("DVB3_EVENT_FE_UNLOCK");
+			pr_debug("DVB3_EVENT_FE_UNLOCK\n");
 			sms_board_event(coredev, BOARD_EVENT_FE_UNLOCK);
 		}
 		break;
 	case DVB3_EVENT_UNC_OK:
 		if (client->event_unc_state != DVB3_EVENT_UNC_OK) {
 			client->event_unc_state = DVB3_EVENT_UNC_OK;
-			sms_debug("DVB3_EVENT_UNC_OK");
+			pr_debug("DVB3_EVENT_UNC_OK\n");
 			sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_OK);
 		}
 		break;
 	case DVB3_EVENT_UNC_ERR:
 		if (client->event_unc_state != DVB3_EVENT_UNC_ERR) {
 			client->event_unc_state = DVB3_EVENT_UNC_ERR;
-			sms_debug("DVB3_EVENT_UNC_ERR");
+			pr_debug("DVB3_EVENT_UNC_ERR\n");
 			sms_board_event(coredev, BOARD_EVENT_MULTIPLEX_ERRORS);
 		}
 		break;
@@ -658,7 +658,7 @@ static int smsdvb_start_feed(struct dvb_demux_feed *feed)
 		container_of(feed->demux, struct smsdvb_client_t, demux);
 	struct sms_msg_data pid_msg;
 
-	sms_debug("add pid %d(%x)",
+	pr_debug("add pid %d(%x)\n",
 		  feed->pid, feed->pid);
 
 	client->feed_users++;
@@ -680,7 +680,7 @@ static int smsdvb_stop_feed(struct dvb_demux_feed *feed)
 		container_of(feed->demux, struct smsdvb_client_t, demux);
 	struct sms_msg_data pid_msg;
 
-	sms_debug("remove pid %d(%x)",
+	pr_debug("remove pid %d(%x)\n",
 		  feed->pid, feed->pid);
 
 	client->feed_users--;
@@ -850,7 +850,7 @@ static int smsdvb_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 static int smsdvb_get_tune_settings(struct dvb_frontend *fe,
 				    struct dvb_frontend_tune_settings *tune)
 {
-	sms_debug("");
+	pr_debug("\n");
 
 	tune->min_delay_ms = 400;
 	tune->step_size = 250000;
@@ -1226,7 +1226,7 @@ static int __init smsdvb_module_init(void)
 
 	rc = smscore_register_hotplug(smsdvb_hotplug);
 
-	sms_debug("");
+	pr_debug("\n");
 
 	return rc;
 }
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 172c6620c30c..454f450997a3 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -124,7 +124,7 @@ static void smsusb_onresponse(struct urb *urb)
 			} else
 				surb->cb->offset = 0;
 
-			sms_debug("received %s(%d) size: %d",
+			pr_debug("received %s(%d) size: %d\n",
 				  smscore_translate_msg(phdr->msg_type),
 				  phdr->msg_type, phdr->msg_length);
 
@@ -208,11 +208,11 @@ static int smsusb_sendrequest(void *context, void *buffer, size_t size)
 	int dummy;
 
 	if (dev->state != SMSUSB_ACTIVE) {
-		sms_debug("Device not active yet");
+		pr_debug("Device not active yet\n");
 		return -ENOENT;
 	}
 
-	sms_debug("sending %s(%d) size: %d",
+	pr_debug("sending %s(%d) size: %d\n",
 		  smscore_translate_msg(phdr->msg_type), phdr->msg_type,
 		  phdr->msg_length);
 
@@ -491,7 +491,7 @@ static int smsusb_probe(struct usb_interface *intf,
 
 	if (sms_get_board(id->driver_info)->intf_num !=
 	    intf->cur_altsetting->desc.bInterfaceNumber) {
-		sms_debug("interface %d won't be used. Expecting interface %d to popup",
+		pr_debug("interface %d won't be used. Expecting interface %d to popup\n",
 			intf->cur_altsetting->desc.bInterfaceNumber,
 			sms_get_board(id->driver_info)->intf_num);
 		return -ENODEV;
@@ -524,7 +524,7 @@ static int smsusb_probe(struct usb_interface *intf,
 	}
 	if ((udev->actconfig->desc.bNumInterfaces == 2) &&
 	    (intf->cur_altsetting->desc.bInterfaceNumber == 0)) {
-		sms_debug("rom interface 0 is not used");
+		pr_debug("rom interface 0 is not used\n");
 		return -ENODEV;
 	}
 
-- 
2.1.0

