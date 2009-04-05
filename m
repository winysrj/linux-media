Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110806.mail.gq1.yahoo.com ([67.195.13.229]:26402 "HELO
	web110806.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754420AbZDEIV0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 04:21:26 -0400
Message-ID: <940586.84963.qm@web110806.mail.gq1.yahoo.com>
Date: Sun, 5 Apr 2009 01:21:23 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [0904_3] Siano: core - move and update the main core structure declaration
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1238691361 -10800
# Node ID 19925582e5dded86fccce7d8c9965285c1240836
# Parent  05cf6606192642241ff25a152e249118cb8a129b
[PATCH] [0904_3] Siano: core - move and update the main core structure declaration

From: Uri Shkolnik <uris@siano-ms.com>

smscoreapi - move the main core structure declaration
to the header, in order to enable other components
(such as IR) to use it.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 05cf66061926 -r 19925582e5dd linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Thu Apr 02 19:47:39 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Thu Apr 02 19:56:01 2009 +0300
@@ -56,42 +56,6 @@ struct smscore_client_t {
 	struct list_head 	idlist;
 	onresponse_t	onresponse_handler;
 	onremove_t		onremove_handler;
-};
-
-struct smscore_device_t {
-	struct list_head entry;
-
-	struct list_head clients;
-	struct list_head subclients;
-	spinlock_t		clientslock;
-
-	struct list_head buffers;
-	spinlock_t		bufferslock;
-	int				num_buffers;
-
-	void			*common_buffer;
-	int				common_buffer_size;
-	dma_addr_t		common_buffer_phys;
-
-	void			*context;
-	struct device	*device;
-
-	char			devpath[32];
-	unsigned long	device_flags;
-
-	setmode_t		setmode_handler;
-	detectmode_t	detectmode_handler;
-	sendrequest_t	sendrequest_handler;
-	preload_t		preload_handler;
-	postload_t		postload_handler;
-
-	int				mode, modes_supported;
-
-	struct completion version_ex_done, data_download_done, trigger_done;
-	struct completion init_device_done, reload_start_done, resume_done;
-
-	int board_id;
-	int led_state;
 };
 
 void smscore_set_board_id(struct smscore_device_t *core, int id)
diff -r 05cf66061926 -r 19925582e5dd linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 19:47:39 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Thu Apr 02 19:56:01 2009 +0300
@@ -128,6 +128,60 @@ struct smsclient_params_t {
 	onremove_t		onremove_handler;
 
 	void			*context;
+};
+
+struct smscore_device_t {
+	struct list_head entry;
+
+	struct list_head clients;
+	struct list_head subclients;
+	spinlock_t clientslock;
+
+	struct list_head buffers;
+	spinlock_t bufferslock;
+	int num_buffers;
+
+	void *common_buffer;
+	int common_buffer_size;
+	dma_addr_t common_buffer_phys;
+
+	void *context;
+	struct device *device;
+
+	char devpath[32];
+	unsigned long device_flags;
+
+	setmode_t setmode_handler;
+	detectmode_t detectmode_handler;
+	sendrequest_t sendrequest_handler;
+	preload_t preload_handler;
+	postload_t postload_handler;
+
+	int mode, modes_supported;
+
+	/* host <--> device messages */
+	struct completion version_ex_done, data_download_done, trigger_done;
+	struct completion init_device_done, reload_start_done, resume_done;
+	struct completion gpio_configuration_done, gpio_set_level_done;
+	struct completion gpio_get_level_done, ir_init_done;
+
+	/* Buffer management */
+	wait_queue_head_t buffer_mng_waitq;
+
+	/* GPIO */
+	int gpio_get_res;
+
+	/* Target hardware board */
+	int board_id;
+
+	/* Firmware */
+	u8 *fw_buf;
+	u32 fw_buf_size;
+
+	/* Infrared (IR) */
+	/* struct ir_t ir; */
+
+	int led_state;
 };
 
 /* GPIO definitions for antenna frequency domain control (SMS8021) */



      
