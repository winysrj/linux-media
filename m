Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110801.mail.gq1.yahoo.com ([67.195.13.224]:25214 "HELO
	web110801.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754167AbZESQPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 12:15:03 -0400
Message-ID: <489128.99706.qm@web110801.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 09:15:02 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_54] Siano: remove obsolete sms_board_setup
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242749967 -10800
# Node ID 0296b0c436d6deba48c710cfb510988267cea057
# Parent  dfcfb90798d3a27cb174019b17fffdee9ce7b2b9
[09051_54] Siano: remove obsolete sms_board_setup

From: Uri Shkolnik <uris@siano-ms.com>

Remove the target specific sms_board_setup from smsdvb. This
is handled now via smsdvb and sms-cards events.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r dfcfb90798d3 -r 0296b0c436d6 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 19:05:02 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 19:19:27 2009 +0300
@@ -303,28 +303,6 @@ static int sms_set_gpio(struct smscore_d
 	return smscore_set_gpio(coredev, gpio, lvl);
 }
 
-int sms_board_setup(struct smscore_device_t *coredev)
-{
-	int board_id = smscore_get_board_id(coredev);
-	struct sms_board *board = sms_get_board(board_id);
-
-	switch (board_id) {
-	case SMS1XXX_BOARD_HAUPPAUGE_WINDHAM:
-		/* turn off all LEDs */
-		sms_set_gpio(coredev, board->led_power, 0);
-		sms_set_gpio(coredev, board->led_hi, 0);
-		sms_set_gpio(coredev, board->led_lo, 0);
-		break;
-	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2:
-	case SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD:
-		/* turn off LNA */
-		sms_set_gpio(coredev, board->lna_ctrl, 0);
-		break;
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(sms_board_setup);
-
 int sms_board_power(struct smscore_device_t *coredev, int onoff)
 {
 	int board_id = smscore_get_board_id(coredev);
diff -r dfcfb90798d3 -r 0296b0c436d6 linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 19:05:02 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 19:19:27 2009 +0300
@@ -109,8 +109,6 @@ int sms_board_event(struct smscore_devic
 int sms_board_event(struct smscore_device_t *coredev,
 		enum SMS_BOARD_EVENTS gevent);
 
-int sms_board_setup(struct smscore_device_t *coredev);
-
 #define SMS_LED_OFF 0
 #define SMS_LED_LO  1
 #define SMS_LED_HI  2
diff -r dfcfb90798d3 -r 0296b0c436d6 linux/drivers/media/dvb/siano/smsdvb.c
--- a/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 19 19:05:02 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smsdvb.c	Tue May 19 19:19:27 2009 +0300
@@ -600,7 +600,6 @@ static int smsdvb_hotplug(struct smscore
 	sms_board_dvb3_event(client, DVB3_EVENT_HOTPLUG);
 
 	sms_info("success");
-	sms_board_setup(coredev);
 
 	return 0;
 



      
