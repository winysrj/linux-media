Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbbBVQLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2015 11:11:52 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 04/10] [media] siano: replace sms_err by pr_err
Date: Sun, 22 Feb 2015 13:11:35 -0300
Message-Id: <1424621501-17466-5-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
References: <1424621501-17466-1-git-send-email-mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Originally, sms_err() would be also displaying the line where
the error occurs, but the messages are clear enough. Also,
the function is always printed. So, no need for it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/common/siano/sms-cards.c      |  2 +-
 drivers/media/common/siano/smscoreapi.c     | 67 ++++++++++++++---------------
 drivers/media/common/siano/smscoreapi.h     |  1 -
 drivers/media/common/siano/smsdvb-debugfs.c |  2 +-
 drivers/media/common/siano/smsdvb-main.c    | 14 +++---
 drivers/media/common/siano/smsir.c          |  6 +--
 drivers/media/mmc/siano/smssdio.c           | 12 +++---
 drivers/media/usb/siano/smsusb.c            | 39 ++++++++---------
 8 files changed, 68 insertions(+), 75 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 82c7a1289f05..9c7a9452c04c 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -232,7 +232,7 @@ int sms_board_event(struct smscore_device_t *coredev,
 		break; /* BOARD_EVENT_MULTIPLEX_ERRORS */
 
 	default:
-		sms_err("Unknown SMS board event");
+		pr_err("Unknown SMS board event\n");
 		break;
 	}
 	return 0;
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 26dc4392c3e1..1f99698a211e 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -461,7 +461,7 @@ static struct smscore_registry_entry_t *smscore_find_registry(char *devpath)
 		strcpy(entry->devpath, devpath);
 		list_add(&entry->entry, &g_smscore_registry);
 	} else
-		sms_err("failed to create smscore_registry.");
+		pr_err("failed to create smscore_registry.\n");
 	kmutex_unlock(&g_smscore_registrylock);
 	return entry;
 }
@@ -474,7 +474,7 @@ int smscore_registry_getmode(char *devpath)
 	if (entry)
 		return entry->mode;
 	else
-		sms_err("No registry found.");
+		pr_err("No registry found.\n");
 
 	return default_mode;
 }
@@ -488,7 +488,7 @@ static enum sms_device_type_st smscore_registry_gettype(char *devpath)
 	if (entry)
 		return entry->type;
 	else
-		sms_err("No registry found.");
+		pr_err("No registry found.\n");
 
 	return -EINVAL;
 }
@@ -501,7 +501,7 @@ static void smscore_registry_setmode(char *devpath, int mode)
 	if (entry)
 		entry->mode = mode;
 	else
-		sms_err("No registry found.");
+		pr_err("No registry found.\n");
 }
 
 static void smscore_registry_settype(char *devpath,
@@ -513,7 +513,7 @@ static void smscore_registry_settype(char *devpath,
 	if (entry)
 		entry->type = type;
 	else
-		sms_err("No registry found.");
+		pr_err("No registry found.\n");
 }
 
 
@@ -791,7 +791,7 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 		rc = sms_ir_init(coredev);
 
 		if	(rc != 0)
-			sms_err("Error initialization DTV IR sub-module");
+			pr_err("Error initialization DTV IR sub-module\n");
 		else {
 			buffer = kmalloc(sizeof(struct sms_msg_data2) +
 						SMS_DMA_ALIGNMENT,
@@ -813,8 +813,7 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 
 				kfree(buffer);
 			} else
-				sms_err
-				("Sending IR initialization message failed");
+				pr_err("Sending IR initialization message failed\n");
 		}
 	} else
 		sms_info("IR port has not been detected");
@@ -836,7 +835,7 @@ static int smscore_configure_board(struct smscore_device_t *coredev)
 
 	board = sms_get_board(coredev->board_id);
 	if (!board) {
-		sms_err("no board configuration exist.");
+		pr_err("no board configuration exist.\n");
 		return -EINVAL;
 	}
 
@@ -949,7 +948,7 @@ static int smscore_load_firmware_family2(struct smscore_device_t *coredev,
 						  msg->x_msg_header.msg_length,
 						  &coredev->reload_start_done);
 		if (rc < 0) {
-			sms_err("device reload failed, rc %d", rc);
+			pr_err("device reload failed, rc %d\n", rc);
 			goto exit_fw_download;
 		}
 		mem_address = *(u32 *) &payload[20];
@@ -1155,7 +1154,7 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 
 	char *fw_filename = smscore_get_fw_filename(coredev, mode);
 	if (!fw_filename) {
-		sms_err("mode %d not supported on this device", mode);
+		pr_err("mode %d not supported on this device\n", mode);
 		return -ENOENT;
 	}
 	sms_debug("Firmware name: %s", fw_filename);
@@ -1166,14 +1165,14 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 
 	rc = request_firmware(&fw, fw_filename, coredev->device);
 	if (rc < 0) {
-		sms_err("failed to open firmware file \"%s\"", fw_filename);
+		pr_err("failed to open firmware file '%s'\n", fw_filename);
 		return rc;
 	}
 	sms_info("read fw %s, buffer size=0x%zx", fw_filename, fw->size);
 	fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
 			 GFP_KERNEL | GFP_DMA);
 	if (!fw_buf) {
-		sms_err("failed to allocate firmware buffer");
+		pr_err("failed to allocate firmware buffer\n");
 		rc = -ENOMEM;
 	} else {
 		memcpy(fw_buf, fw->data, fw->size);
@@ -1272,7 +1271,7 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 	rc = smscore_sendrequest_and_wait(coredev, msg, msg->msg_length,
 					  &coredev->version_ex_done);
 	if (rc == -ETIME) {
-		sms_err("MSG_SMS_GET_VERSION_EX_REQ failed first try");
+		pr_err("MSG_SMS_GET_VERSION_EX_REQ failed first try\n");
 
 		if (wait_for_completion_timeout(&coredev->resume_done,
 						msecs_to_jiffies(5000))) {
@@ -1280,7 +1279,7 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 				coredev, msg, msg->msg_length,
 				&coredev->version_ex_done);
 			if (rc < 0)
-				sms_err("MSG_SMS_GET_VERSION_EX_REQ failed second try, rc %d",
+				pr_err("MSG_SMS_GET_VERSION_EX_REQ failed second try, rc %d\n",
 					rc);
 		} else
 			rc = -ETIME;
@@ -1309,7 +1308,7 @@ static int smscore_init_device(struct smscore_device_t *coredev, int mode)
 	buffer = kmalloc(sizeof(struct sms_msg_data) +
 			SMS_DMA_ALIGNMENT, GFP_KERNEL | GFP_DMA);
 	if (!buffer) {
-		sms_err("Could not allocate buffer for init device message.");
+		pr_err("Could not allocate buffer for init device message.\n");
 		return -ENOMEM;
 	}
 
@@ -1343,7 +1342,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 	sms_debug("set device mode to %d", mode);
 	if (coredev->device_flags & SMS_DEVICE_FAMILY2) {
 		if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX) {
-			sms_err("invalid mode specified %d", mode);
+			pr_err("invalid mode specified %d\n", mode);
 			return -EINVAL;
 		}
 
@@ -1352,7 +1351,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 		if (!(coredev->device_flags & SMS_DEVICE_NOT_READY)) {
 			rc = smscore_detect_mode(coredev);
 			if (rc < 0) {
-				sms_err("mode detect failed %d", rc);
+				pr_err("mode detect failed %d\n", rc);
 				return rc;
 			}
 		}
@@ -1374,11 +1373,11 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 		if (coredev->fw_version >= 0x800) {
 			rc = smscore_init_device(coredev, mode);
 			if (rc < 0)
-				sms_err("device init failed, rc %d.", rc);
+				pr_err("device init failed, rc %d.\n", rc);
 		}
 	} else {
 		if (mode <= DEVICE_MODE_NONE || mode >= DEVICE_MODE_MAX) {
-			sms_err("invalid mode specified %d", mode);
+			pr_err("invalid mode specified %d\n", mode);
 			return -EINVAL;
 		}
 
@@ -1415,7 +1414,7 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 	}
 
 	if (rc < 0)
-		sms_err("return error code %d.", rc);
+		pr_err("return error code %d.\n", rc);
 	else
 		sms_debug("Success setting device mode.");
 
@@ -1682,7 +1681,7 @@ static int smscore_validate_client(struct smscore_device_t *coredev,
 	struct smscore_client_t *registered_client;
 
 	if (!client) {
-		sms_err("bad parameter.");
+		pr_err("bad parameter.\n");
 		return -EINVAL;
 	}
 	registered_client = smscore_find_client(coredev, data_type, id);
@@ -1690,12 +1689,12 @@ static int smscore_validate_client(struct smscore_device_t *coredev,
 		return 0;
 
 	if (registered_client) {
-		sms_err("The msg ID already registered to another client.");
+		pr_err("The msg ID already registered to another client.\n");
 		return -EEXIST;
 	}
 	listentry = kzalloc(sizeof(struct smscore_idlist_t), GFP_KERNEL);
 	if (!listentry) {
-		sms_err("Can't allocate memory for client id.");
+		pr_err("Can't allocate memory for client id.\n");
 		return -ENOMEM;
 	}
 	listentry->id = id;
@@ -1727,13 +1726,13 @@ int smscore_register_client(struct smscore_device_t *coredev,
 	/* check that no other channel with same parameters exists */
 	if (smscore_find_client(coredev, params->data_type,
 				params->initial_id)) {
-		sms_err("Client already exist.");
+		pr_err("Client already exist.\n");
 		return -EEXIST;
 	}
 
 	newclient = kzalloc(sizeof(struct smscore_client_t), GFP_KERNEL);
 	if (!newclient) {
-		sms_err("Failed to allocate memory for client.");
+		pr_err("Failed to allocate memory for client.\n");
 		return -ENOMEM;
 	}
 
@@ -1804,7 +1803,7 @@ int smsclient_sendrequest(struct smscore_client_t *client,
 	int rc;
 
 	if (client == NULL) {
-		sms_err("Got NULL client");
+		pr_err("Got NULL client\n");
 		return -EINVAL;
 	}
 
@@ -1812,7 +1811,7 @@ int smsclient_sendrequest(struct smscore_client_t *client,
 
 	/* check that no other channel with same id exists */
 	if (coredev == NULL) {
-		sms_err("Got NULL coredev");
+		pr_err("Got NULL coredev\n");
 		return -EINVAL;
 	}
 
@@ -2017,9 +2016,9 @@ int smscore_gpio_configure(struct smscore_device_t *coredev, u8 pin_num,
 
 	if (rc != 0) {
 		if (rc == -ETIME)
-			sms_err("smscore_gpio_configure timeout");
+			pr_err("smscore_gpio_configure timeout\n");
 		else
-			sms_err("smscore_gpio_configure error");
+			pr_err("smscore_gpio_configure error\n");
 	}
 free:
 	kfree(buffer);
@@ -2066,9 +2065,9 @@ int smscore_gpio_set_level(struct smscore_device_t *coredev, u8 pin_num,
 
 	if (rc != 0) {
 		if (rc == -ETIME)
-			sms_err("smscore_gpio_set_level timeout");
+			pr_err("smscore_gpio_set_level timeout\n");
 		else
-			sms_err("smscore_gpio_set_level error");
+			pr_err("smscore_gpio_set_level error\n");
 	}
 	kfree(buffer);
 
@@ -2114,9 +2113,9 @@ int smscore_gpio_get_level(struct smscore_device_t *coredev, u8 pin_num,
 
 	if (rc != 0) {
 		if (rc == -ETIME)
-			sms_err("smscore_gpio_get_level timeout");
+			pr_err("smscore_gpio_get_level timeout\n");
 		else
-			sms_err("smscore_gpio_get_level error");
+			pr_err("smscore_gpio_get_level error\n");
 	}
 	kfree(buffer);
 
diff --git a/drivers/media/common/siano/smscoreapi.h b/drivers/media/common/siano/smscoreapi.h
index 13bd7ef7a588..9ea6a10757d5 100644
--- a/drivers/media/common/siano/smscoreapi.h
+++ b/drivers/media/common/siano/smscoreapi.h
@@ -1180,7 +1180,6 @@ int smscore_led_state(struct smscore_device_t *core, int led);
 #define DBG_ADV  2
 
 #define sms_log(fmt, arg...) pr_info(fmt "\n", ##arg)
-#define sms_err(fmt, arg...) pr_err(fmt " on line: %d\n", ##arg, __LINE__)
 #define sms_info(fmt, arg...) do {\
 	if (sms_dbg & DBG_INFO) \
 		pr_info(fmt "\n", ##arg); \
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 2408d7e9451e..53ed656329db 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -536,7 +536,7 @@ int smsdvb_debugfs_register(void)
 	 */
 	d = debugfs_create_dir("smsdvb", usb_debug_root);
 	if (IS_ERR_OR_NULL(d)) {
-		sms_err("Couldn't create sysfs node for smsdvb");
+		pr_err("Couldn't create sysfs node for smsdvb\n");
 		return PTR_ERR(d);
 	} else {
 		smsdvb_debugfs_usb_root = d;
diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index 6eb1b14092cb..c63fe9a889d5 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -124,7 +124,7 @@ static void sms_board_dvb3_event(struct smsdvb_client_t *client,
 		break;
 
 	default:
-		sms_err("Unknown dvb3 api event");
+		pr_err("Unknown dvb3 api event\n");
 		break;
 	}
 }
@@ -1098,7 +1098,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 		return 0;
 	client = kzalloc(sizeof(struct smsdvb_client_t), GFP_KERNEL);
 	if (!client) {
-		sms_err("kmalloc() failed");
+		pr_err("kmalloc() failed\n");
 		return -ENOMEM;
 	}
 
@@ -1108,7 +1108,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 					smscore_get_board_id(coredev))->name,
 				  THIS_MODULE, device, adapter_nr);
 	if (rc < 0) {
-		sms_err("dvb_register_adapter() failed %d", rc);
+		pr_err("dvb_register_adapter() failed %d\n", rc);
 		goto adapter_error;
 	}
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
@@ -1124,7 +1124,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 
 	rc = dvb_dmx_init(&client->demux);
 	if (rc < 0) {
-		sms_err("dvb_dmx_init failed %d", rc);
+		pr_err("dvb_dmx_init failed %d\n", rc);
 		goto dvbdmx_error;
 	}
 
@@ -1135,7 +1135,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 
 	rc = dvb_dmxdev_init(&client->dmxdev, &client->adapter);
 	if (rc < 0) {
-		sms_err("dvb_dmxdev_init failed %d", rc);
+		pr_err("dvb_dmxdev_init failed %d\n", rc);
 		goto dmxdev_error;
 	}
 
@@ -1156,7 +1156,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 
 	rc = dvb_register_frontend(&client->adapter, &client->frontend);
 	if (rc < 0) {
-		sms_err("frontend registration failed %d", rc);
+		pr_err("frontend registration failed %d\n", rc);
 		goto frontend_error;
 	}
 
@@ -1168,7 +1168,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 
 	rc = smscore_register_client(coredev, &params, &client->smsclient);
 	if (rc < 0) {
-		sms_err("smscore_register_client() failed %d", rc);
+		pr_err("smscore_register_client() failed %d\n", rc);
 		goto client_error;
 	}
 
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 2dcae6ace282..2e0f96ff5594 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -59,10 +59,8 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	sms_log("Allocating rc device");
 	dev = rc_allocate_device();
-	if (!dev) {
-		sms_err("Not enough memory");
+	if (!dev)
 		return -ENOMEM;
-	}
 
 	coredev->ir.controller = 0;	/* Todo: vega/nova SPI number */
 	coredev->ir.timeout = IR_DEFAULT_TIMEOUT;
@@ -97,7 +95,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 
 	err = rc_register_device(dev);
 	if (err < 0) {
-		sms_err("Failed to register device");
+		pr_err("Failed to register device\n");
 		rc_free_device(dev);
 		return err;
 	}
diff --git a/drivers/media/mmc/siano/smssdio.c b/drivers/media/mmc/siano/smssdio.c
index 912c2814c6cf..ebe2151cca0d 100644
--- a/drivers/media/mmc/siano/smssdio.c
+++ b/drivers/media/mmc/siano/smssdio.c
@@ -141,14 +141,14 @@ static void smssdio_interrupt(struct sdio_func *func)
 	 */
 	(void)sdio_readb(func, SMSSDIO_INT, &ret);
 	if (ret) {
-		sms_err("Unable to read interrupt register!\n");
+		pr_err("Unable to read interrupt register!\n");
 		return;
 	}
 
 	if (smsdev->split_cb == NULL) {
 		cb = smscore_getbuffer(smsdev->coredev);
 		if (!cb) {
-			sms_err("Unable to allocate data buffer!\n");
+			pr_err("Unable to allocate data buffer!\n");
 			return;
 		}
 
@@ -157,7 +157,7 @@ static void smssdio_interrupt(struct sdio_func *func)
 					 SMSSDIO_DATA,
 					 SMSSDIO_BLOCK_SIZE);
 		if (ret) {
-			sms_err("Error %d reading initial block!\n", ret);
+			pr_err("Error %d reading initial block!\n", ret);
 			return;
 		}
 
@@ -198,7 +198,7 @@ static void smssdio_interrupt(struct sdio_func *func)
 					 size);
 		if (ret && ret != -EINVAL) {
 			smscore_putbuffer(smsdev->coredev, cb);
-			sms_err("Error %d reading data from card!\n", ret);
+			pr_err("Error %d reading data from card!\n", ret);
 			return;
 		}
 
@@ -216,8 +216,8 @@ static void smssdio_interrupt(struct sdio_func *func)
 						  smsdev->func->cur_blksize);
 				if (ret) {
 					smscore_putbuffer(smsdev->coredev, cb);
-					sms_err("Error %d reading "
-						"data from card!\n", ret);
+					pr_err("Error %d reading data from card!\n",
+					       ret);
 					return;
 				}
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 244674599878..172c6620c30c 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -88,7 +88,7 @@ static void smsusb_onresponse(struct urb *urb)
 	struct smsusb_device_t *dev = surb->dev;
 
 	if (urb->status == -ESHUTDOWN) {
-		sms_err("error, urb status %d (-ESHUTDOWN), %d bytes",
+		pr_err("error, urb status %d (-ESHUTDOWN), %d bytes\n",
 			urb->status, urb->actual_length);
 		return;
 	}
@@ -110,9 +110,7 @@ static void smsusb_onresponse(struct urb *urb)
 				/* sanity check */
 				if (((int) phdr->msg_length +
 				     surb->cb->offset) > urb->actual_length) {
-					sms_err("invalid response "
-						"msglen %d offset %d "
-						"size %d",
+					pr_err("invalid response msglen %d offset %d size %d\n",
 						phdr->msg_length,
 						surb->cb->offset,
 						urb->actual_length);
@@ -135,12 +133,11 @@ static void smsusb_onresponse(struct urb *urb)
 			smscore_onresponse(dev->coredev, surb->cb);
 			surb->cb = NULL;
 		} else {
-			sms_err("invalid response "
-				"msglen %d actual %d",
+			pr_err("invalid response msglen %d actual %d\n",
 				phdr->msg_length, urb->actual_length);
 		}
 	} else
-		sms_err("error, urb status %d, %d bytes",
+		pr_err("error, urb status %d, %d bytes\n",
 			urb->status, urb->actual_length);
 
 
@@ -154,7 +151,7 @@ static int smsusb_submit_urb(struct smsusb_device_t *dev,
 	if (!surb->cb) {
 		surb->cb = smscore_getbuffer(dev->coredev);
 		if (!surb->cb) {
-			sms_err("smscore_getbuffer(...) returned NULL");
+			pr_err("smscore_getbuffer(...) returned NULL\n");
 			return -ENOMEM;
 		}
 	}
@@ -195,7 +192,7 @@ static int smsusb_start_streaming(struct smsusb_device_t *dev)
 	for (i = 0; i < MAX_URBS; i++) {
 		rc = smsusb_submit_urb(dev, &dev->surbs[i]);
 		if (rc < 0) {
-			sms_err("smsusb_submit_urb(...) failed");
+			pr_err("smsusb_submit_urb(...) failed\n");
 			smsusb_stop_streaming(dev);
 			break;
 		}
@@ -250,7 +247,7 @@ static int smsusb1_load_firmware(struct usb_device *udev, int id, int board_id)
 		id = sms_get_board(board_id)->default_mode;
 
 	if (id < DEVICE_MODE_DVBT || id > DEVICE_MODE_DVBT_BDA) {
-		sms_err("invalid firmware id specified %d", id);
+		pr_err("invalid firmware id specified %d\n", id);
 		return -EINVAL;
 	}
 
@@ -282,7 +279,7 @@ static int smsusb1_load_firmware(struct usb_device *udev, int id, int board_id)
 
 		kfree(fw_buffer);
 	} else {
-		sms_err("failed to allocate firmware buffer");
+		pr_err("failed to allocate firmware buffer\n");
 		rc = -ENOMEM;
 	}
 	sms_info("read FW %s, size=%zu", fw_filename, fw->size);
@@ -301,7 +298,7 @@ static void smsusb1_detectmode(void *context, int *mode)
 
 	if (!product_string) {
 		product_string = "none";
-		sms_err("product string not found");
+		pr_err("product string not found\n");
 	} else if (strstr(product_string, "DVBH"))
 		*mode = 1;
 	else if (strstr(product_string, "BDA"))
@@ -320,7 +317,7 @@ static int smsusb1_setmode(void *context, int mode)
 			     sizeof(struct sms_msg_hdr), 0 };
 
 	if (mode < DEVICE_MODE_DVBT || mode > DEVICE_MODE_DVBT_BDA) {
-		sms_err("invalid firmware id specified %d", mode);
+		pr_err("invalid firmware id specified %d\n", mode);
 		return -EINVAL;
 	}
 
@@ -370,7 +367,7 @@ static void siano_media_device_register(struct smsusb_device_t *dev)
 
 	ret = media_device_register(mdev);
 	if (ret) {
-		sms_err("Couldn't create a media device. Error: %d\n",
+		pr_err("Couldn't create a media device. Error: %d\n",
 			ret);
 		kfree(mdev);
 		return;
@@ -392,7 +389,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	/* create device object */
 	dev = kzalloc(sizeof(struct smsusb_device_t), GFP_KERNEL);
 	if (!dev) {
-		sms_err("kzalloc(sizeof(struct smsusb_device_t) failed");
+		pr_err("kzalloc(sizeof(struct smsusb_device_t) failed\n");
 		return -ENOMEM;
 	}
 
@@ -411,7 +408,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 		params.detectmode_handler = smsusb1_detectmode;
 		break;
 	case SMS_UNKNOWN_TYPE:
-		sms_err("Unspecified sms device type!");
+		pr_err("Unspecified sms device type!\n");
 		/* fall-thru */
 	default:
 		dev->buffer_size = USB2_BUFFER_SIZE;
@@ -443,7 +440,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	/* register in smscore */
 	rc = smscore_register_device(&params, &dev->coredev);
 	if (rc < 0) {
-		sms_err("smscore_register_device(...) failed, rc %d", rc);
+		pr_err("smscore_register_device(...) failed, rc %d\n", rc);
 		smsusb_term_device(intf);
 		return rc;
 	}
@@ -461,7 +458,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	sms_info("smsusb_start_streaming(...).");
 	rc = smsusb_start_streaming(dev);
 	if (rc < 0) {
-		sms_err("smsusb_start_streaming(...) failed");
+		pr_err("smsusb_start_streaming(...) failed\n");
 		smsusb_term_device(intf);
 		return rc;
 	}
@@ -470,7 +467,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 
 	rc = smscore_start_device(dev->coredev);
 	if (rc < 0) {
-		sms_err("smscore_start_device(...) failed");
+		pr_err("smscore_start_device(...) failed\n");
 		smsusb_term_device(intf);
 		return rc;
 	}
@@ -505,7 +502,7 @@ static int smsusb_probe(struct usb_interface *intf,
 				       intf->cur_altsetting->desc.bInterfaceNumber,
 				       0);
 		if (rc < 0) {
-			sms_err("usb_set_interface failed, rc %d", rc);
+			pr_err("usb_set_interface failed, rc %d\n", rc);
 			return rc;
 		}
 	}
@@ -545,7 +542,7 @@ static int smsusb_probe(struct usb_interface *intf,
 		if (!rc)
 			sms_info("stellar device now in warm state");
 		else
-			sms_err("Failed to put stellar in warm state. Error: %d", rc);
+			pr_err("Failed to put stellar in warm state. Error: %d\n", rc);
 
 		return rc;
 	} else {
-- 
2.1.0

