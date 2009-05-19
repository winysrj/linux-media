Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110806.mail.gq1.yahoo.com ([67.195.13.229]:21595 "HELO
	web110806.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755369AbZESQY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 12:24:27 -0400
Message-ID: <716575.53837.qm@web110806.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 09:24:23 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_55] Siano: smscards - merge the binding handling
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242750556 -10800
# Node ID d92f2dfcb226c5f8b8c3216f7cf96126f7571702
# Parent  0296b0c436d6deba48c710cfb510988267cea057
[09051_55] Siano: smscards - merge the binding handling.

From: Uri Shkolnik <uris@siano-ms.com>

Merge the bind handling into the events switch.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 0296b0c436d6 -r d92f2dfcb226 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 19:19:27 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 19:29:16 2009 +0300
@@ -194,7 +194,13 @@ int sms_board_event(struct smscore_devic
 
 	case BOARD_EVENT_BIND:
 		switch (board_id) {
+		case SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT:
+		case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A:
+		case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B:
+			request_module("smsdvb");
+			break;
 		case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
+			request_module("smsdvb");
 			smscore_gpio_set_level(coredev,
 				board->board_cfg.leds_power, 1);
 			smscore_gpio_set_level(coredev,
@@ -366,20 +372,3 @@ int sms_board_lna_control(struct smscore
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(sms_board_lna_control);
-
-int sms_board_load_modules(int id)
-{
-	switch (id) {
-	case SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT:
-	case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A:
-	case SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B:
-	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
-		request_module("smsdvb");
-		break;
-	default:
-		/* do nothing */
-		break;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(sms_board_load_modules);



      
