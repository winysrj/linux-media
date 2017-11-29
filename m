Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:47917 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753043AbdK2Kqn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 05:46:43 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 03/12] media: siano: get rid of documentation warnings
Date: Wed, 29 Nov 2017 05:46:24 -0500
Message-Id: <929b99ed9b31c6de984c6cf49763eaed6767ac2e.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
In-Reply-To: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Siano driver doesn't use kernel-doc markups. While it
would be wanderful to convert to use it, it is probably
not worth the time.

So, instead of solving all problems there, just make
sure that it won't produce dozens of warnings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/siano/smscoreapi.c | 66 ++++++++++++++++-----------------
 drivers/media/usb/siano/smsusb.c        |  4 +-
 2 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index e4ea2a0c7a24..c5c827e11b64 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -521,13 +521,13 @@ static void list_add_locked(struct list_head *new, struct list_head *head,
 	spin_unlock_irqrestore(lock, flags);
 }
 
-/**
+/*
  * register a client callback that called when device plugged in/unplugged
  * NOTE: if devices exist callback is called immediately for each device
  *
  * @param hotplug callback
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 int smscore_register_hotplug(hotplug_t hotplug)
 {
@@ -562,7 +562,7 @@ int smscore_register_hotplug(hotplug_t hotplug)
 }
 EXPORT_SYMBOL_GPL(smscore_register_hotplug);
 
-/**
+/*
  * unregister a client callback that called when device plugged in/unplugged
  *
  * @param hotplug callback
@@ -636,7 +636,7 @@ smscore_buffer_t *smscore_createbuffer(u8 *buffer, void *common_buffer,
 	return cb;
 }
 
-/**
+/*
  * creates coredev object for a device, prepares buffers,
  * creates buffer mappings, notifies registered hotplugs about new device.
  *
@@ -644,7 +644,7 @@ smscore_buffer_t *smscore_createbuffer(u8 *buffer, void *common_buffer,
  *               and handlers
  * @param coredev pointer to a value that receives created coredev object
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 int smscore_register_device(struct smsdevice_params_t *params,
 			    struct smscore_device_t **coredev,
@@ -764,10 +764,10 @@ static int smscore_sendrequest_and_wait(struct smscore_device_t *coredev,
 			0 : -ETIME;
 }
 
-/**
+/*
  * Starts & enables IR operations
  *
- * @return 0 on success, < 0 on error.
+ * return: 0 on success, < 0 on error.
  */
 static int smscore_init_ir(struct smscore_device_t *coredev)
 {
@@ -812,13 +812,13 @@ static int smscore_init_ir(struct smscore_device_t *coredev)
 	return 0;
 }
 
-/**
+/*
  * configures device features according to board configuration structure.
  *
  * @param coredev pointer to a coredev object returned by
  *                smscore_register_device
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 static int smscore_configure_board(struct smscore_device_t *coredev)
 {
@@ -861,13 +861,13 @@ static int smscore_configure_board(struct smscore_device_t *coredev)
 	return 0;
 }
 
-/**
+/*
  * sets initial device mode and notifies client hotplugs that device is ready
  *
  * @param coredev pointer to a coredev object returned by
  *		  smscore_register_device
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 int smscore_start_device(struct smscore_device_t *coredev)
 {
@@ -1087,7 +1087,7 @@ static char *smscore_fw_lkup[][DEVICE_MODE_MAX] = {
 	},
 };
 
-/**
+/*
  * get firmware file name from one of the two mechanisms : sms_boards or
  * smscore_fw_lkup.
  * @param coredev pointer to a coredev object returned by
@@ -1096,7 +1096,7 @@ static char *smscore_fw_lkup[][DEVICE_MODE_MAX] = {
  * @param lookup if 1, always get the fw filename from smscore_fw_lkup
  *	 table. if 0, try first to get from sms_boards
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
 			      int mode)
@@ -1125,7 +1125,7 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
 	return fw[mode];
 }
 
-/**
+/*
  * loads specified firmware into a buffer and calls device loadfirmware_handler
  *
  * @param coredev pointer to a coredev object returned by
@@ -1133,7 +1133,7 @@ static char *smscore_get_fw_filename(struct smscore_device_t *coredev,
  * @param filename null-terminated string specifies firmware file name
  * @param loadfirmware_handler device handler that loads firmware
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 					   int mode,
@@ -1182,14 +1182,14 @@ static int smscore_load_firmware_from_file(struct smscore_device_t *coredev,
 	return rc;
 }
 
-/**
+/*
  * notifies all clients registered with the device, notifies hotplugs,
  * frees all buffers and coredev object
  *
  * @param coredev pointer to a coredev object returned by
  *                smscore_register_device
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 void smscore_unregister_device(struct smscore_device_t *coredev)
 {
@@ -1282,14 +1282,14 @@ static int smscore_detect_mode(struct smscore_device_t *coredev)
 	return rc;
 }
 
-/**
+/*
  * send init device request and wait for response
  *
  * @param coredev pointer to a coredev object returned by
  *                smscore_register_device
  * @param mode requested mode of operation
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 static int smscore_init_device(struct smscore_device_t *coredev, int mode)
 {
@@ -1315,7 +1315,7 @@ static int smscore_init_device(struct smscore_device_t *coredev, int mode)
 	return rc;
 }
 
-/**
+/*
  * calls device handler to change mode of operation
  * NOTE: stellar/usb may disconnect when changing mode
  *
@@ -1323,7 +1323,7 @@ static int smscore_init_device(struct smscore_device_t *coredev, int mode)
  *                smscore_register_device
  * @param mode requested mode of operation
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 {
@@ -1411,13 +1411,13 @@ int smscore_set_device_mode(struct smscore_device_t *coredev, int mode)
 	return rc;
 }
 
-/**
+/*
  * calls device handler to get current mode of operation
  *
  * @param coredev pointer to a coredev object returned by
  *                smscore_register_device
  *
- * @return current mode
+ * return: current mode
  */
 int smscore_get_device_mode(struct smscore_device_t *coredev)
 {
@@ -1425,7 +1425,7 @@ int smscore_get_device_mode(struct smscore_device_t *coredev)
 }
 EXPORT_SYMBOL_GPL(smscore_get_device_mode);
 
-/**
+/*
  * find client by response id & type within the clients list.
  * return client handle or NULL.
  *
@@ -1462,7 +1462,7 @@ smscore_client_t *smscore_find_client(struct smscore_device_t *coredev,
 	return client;
 }
 
-/**
+/*
  * find client by response id/type, call clients onresponse handler
  * return buffer to pool on error
  *
@@ -1615,13 +1615,13 @@ void smscore_onresponse(struct smscore_device_t *coredev,
 }
 EXPORT_SYMBOL_GPL(smscore_onresponse);
 
-/**
+/*
  * return pointer to next free buffer descriptor from core pool
  *
  * @param coredev pointer to a coredev object returned by
  *                smscore_register_device
  *
- * @return pointer to descriptor on success, NULL on error.
+ * return: pointer to descriptor on success, NULL on error.
  */
 
 static struct smscore_buffer_t *get_entry(struct smscore_device_t *coredev)
@@ -1648,7 +1648,7 @@ struct smscore_buffer_t *smscore_getbuffer(struct smscore_device_t *coredev)
 }
 EXPORT_SYMBOL_GPL(smscore_getbuffer);
 
-/**
+/*
  * return buffer descriptor to a pool
  *
  * @param coredev pointer to a coredev object returned by
@@ -1693,7 +1693,7 @@ static int smscore_validate_client(struct smscore_device_t *coredev,
 	return 0;
 }
 
-/**
+/*
  * creates smsclient object, check that id is taken by another client
  *
  * @param coredev pointer to a coredev object from clients hotplug
@@ -1705,7 +1705,7 @@ static int smscore_validate_client(struct smscore_device_t *coredev,
  * @param context client-specific context
  * @param client pointer to a value that receives created smsclient object
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 int smscore_register_client(struct smscore_device_t *coredev,
 			    struct smsclient_params_t *params,
@@ -1740,7 +1740,7 @@ int smscore_register_client(struct smscore_device_t *coredev,
 }
 EXPORT_SYMBOL_GPL(smscore_register_client);
 
-/**
+/*
  * frees smsclient object and all subclients associated with it
  *
  * @param client pointer to smsclient object returned by
@@ -1771,7 +1771,7 @@ void smscore_unregister_client(struct smscore_client_t *client)
 }
 EXPORT_SYMBOL_GPL(smscore_unregister_client);
 
-/**
+/*
  * verifies that source id is not taken by another client,
  * calls device handler to send requests to the device
  *
@@ -1780,7 +1780,7 @@ EXPORT_SYMBOL_GPL(smscore_unregister_client);
  * @param buffer pointer to a request buffer
  * @param size size (in bytes) of request buffer
  *
- * @return 0 on success, <0 on error.
+ * return: 0 on success, <0 on error.
  */
 int smsclient_sendrequest(struct smscore_client_t *client,
 			  void *buffer, size_t size)
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 8c1f926567ec..d07349cf9489 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -74,7 +74,7 @@ struct smsusb_device_t {
 static int smsusb_submit_urb(struct smsusb_device_t *dev,
 			     struct smsusb_urb_t *surb);
 
-/**
+/*
  * Completing URB's callback handler - bottom half (proccess context)
  * submits the URB prepared on smsusb_onresponse()
  */
@@ -86,7 +86,7 @@ static void do_submit_urb(struct work_struct *work)
 	smsusb_submit_urb(dev, surb);
 }
 
-/**
+/*
  * Completing URB's callback handler - top half (interrupt context)
  * adds completing sms urb to the global surbs list and activtes the worker
  * thread the surb
-- 
2.14.3
