Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40138 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab1KFUcU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:32:20 -0500
Received: by mail-fx0-f46.google.com with SMTP id o14so4498572faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:32:19 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 04/13] staging: as102: Make the driver select CONFIG_FW_LOADER
Date: Sun,  6 Nov 2011 21:31:41 +0100
Message-Id: <1320611510-3326-5-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It doesn't seem to be of much advantage to compile in FW_LOADER
support conditionally, then make the driver always select FW_LOADER
and remove #idefs from the code.

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/Kconfig     |    1 +
 drivers/staging/media/as102/as102_drv.c |    3 ---
 drivers/staging/media/as102/as102_fw.c  |    5 +----
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/media/as102/Kconfig b/drivers/staging/media/as102/Kconfig
index 5865029..28aba00 100644
--- a/drivers/staging/media/as102/Kconfig
+++ b/drivers/staging/media/as102/Kconfig
@@ -1,6 +1,7 @@
 config DVB_AS102
 	tristate "Abilis AS102 DVB receiver"
 	depends on DVB_CORE && USB && I2C && INPUT
+	select FW_LOADER
 	help
 	  Choose Y or M here if you have a device containing an AS102
 
diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 0bcc55c..85f58b9 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -249,7 +249,6 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 	/* init start / stop stream mutex */
 	mutex_init(&as102_dev->sem);
 
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 	/*
 	 * try to load as102 firmware. If firmware upload failed, we'll be
 	 * able to upload it later.
@@ -257,8 +256,6 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 	if (fw_upload)
 		try_then_request_module(as102_fw_upload(&as102_dev->bus_adap),
 				"firmware_class");
-#endif
-
 failed:
 	LEAVE();
 	/* FIXME: free dvb_XXX */
diff --git a/drivers/staging/media/as102/as102_fw.c b/drivers/staging/media/as102/as102_fw.c
index 3aa4aad..ab7dcdb 100644
--- a/drivers/staging/media/as102/as102_fw.c
+++ b/drivers/staging/media/as102/as102_fw.c
@@ -26,7 +26,6 @@
 #include "as102_drv.h"
 #include "as102_fw.h"
 
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 char as102_st_fw1[] = "as102_data1_st.hex";
 char as102_st_fw2[] = "as102_data2_st.hex";
 char as102_dt_fw1[] = "as102_data1_dt.hex";
@@ -182,7 +181,6 @@ int as102_fw_upload(struct as102_bus_adapter_t *bus_adap)
 		fw2 = as102_st_fw2;
 	}
 
-#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
 	/* allocate buffer to store firmware upload command and data */
 	cmd_buf = kzalloc(MAX_FW_PKT_SIZE, GFP_KERNEL);
 	if (cmd_buf == NULL) {
@@ -237,8 +235,7 @@ error:
 	/* release firmware if needed */
 	if (firmware != NULL)
 		release_firmware(firmware);
-#endif
+
 	LEAVE();
 	return errno;
 }
-#endif
-- 
1.7.5.4

