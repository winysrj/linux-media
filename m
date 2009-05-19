Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110812.mail.gq1.yahoo.com ([67.195.13.235]:29312 "HELO
	web110812.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752108AbZESPw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:52:57 -0400
Message-ID: <459659.47420.qm@web110812.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:52:58 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_51] Siano: smscore - bind the GPIO SMS protocol
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242748628 -10800
# Node ID 11b56bb92bc853666fdc1f7dc1fb799e227a2b41
# Parent  a93ebe0069b3d7d8d791ccb620a7797508cf724c
[09051_51] Siano: smscore - bind the GPIO SMS protocol

From: Uri Shkolnik <uris@siano-ms.com>

Bind SMS protocol commands to the GPIO commands

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r a93ebe0069b3 -r 11b56bb92bc8 linux/drivers/media/dvb/siano/smscoreapi.c
--- a/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 18:53:19 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.c	Tue May 19 18:57:08 2009 +0300
@@ -360,6 +360,9 @@ int smscore_register_device(struct smsde
 	init_completion(&dev->init_device_done);
 	init_completion(&dev->reload_start_done);
 	init_completion(&dev->resume_done);
+	init_completion(&dev->gpio_configuration_done);
+	init_completion(&dev->gpio_set_level_done);
+	init_completion(&dev->gpio_get_level_done);
 	init_completion(&dev->ir_init_done);
 
 	/* Buffer management */
@@ -1151,6 +1154,23 @@ void smscore_onresponse(struct smscore_d
 		case MSG_SMS_SLEEP_RESUME_COMP_IND:
 			complete(&coredev->resume_done);
 			break;
+		case MSG_SMS_GPIO_CONFIG_EX_RES:
+			sms_debug("MSG_SMS_GPIO_CONFIG_EX_RES");
+			complete(&coredev->gpio_configuration_done);
+			break;
+		case MSG_SMS_GPIO_SET_LEVEL_RES:
+			sms_debug("MSG_SMS_GPIO_SET_LEVEL_RES");
+			complete(&coredev->gpio_set_level_done);
+			break;
+		case MSG_SMS_GPIO_GET_LEVEL_RES:
+		{
+			u32 *msgdata = (u32 *) phdr;
+			coredev->gpio_get_res = msgdata[1];
+			sms_debug("MSG_SMS_GPIO_GET_LEVEL_RES gpio level %d",
+					coredev->gpio_get_res);
+			complete(&coredev->gpio_get_level_done);
+			break;
+		}
 		case MSG_SMS_START_IR_RES:
 			complete(&coredev->ir_init_done);
 			break;



      
