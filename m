Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110808.mail.gq1.yahoo.com ([67.195.13.231]:34970 "HELO
	web110808.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753415AbZESPOX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:14:23 -0400
Message-ID: <963141.59754.qm@web110808.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:14:24 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_45] Siano: smscards - add board (target) events
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242746343 -10800
# Node ID 757712d337876acd47621f6a2712026c732da2c4
# Parent  2b865fa7f195524bc9e8557dac472140755058dd
[09051_45] Siano: smscards - add board (target) events

From: Uri Shkolnik <uris@siano-ms.com>

Add events handling for targets. All board-specific
(target specific) should reside here.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 2b865fa7f195 -r 757712d33787 linux/drivers/media/dvb/siano/sms-cards.h
--- a/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 18:15:21 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.h	Tue May 19 18:19:03 2009 +0300
@@ -85,6 +85,30 @@ struct sms_board *sms_get_board(int id);
 
 extern struct smscore_device_t *coredev;
 
+enum SMS_BOARD_EVENTS {
+	BOARD_EVENT_POWER_INIT,
+	BOARD_EVENT_POWER_SUSPEND,
+	BOARD_EVENT_POWER_RESUME,
+	BOARD_EVENT_BIND,
+	BOARD_EVENT_SCAN_PROG,
+	BOARD_EVENT_SCAN_COMP,
+	BOARD_EVENT_EMERGENCY_WARNING_SIGNAL,
+	BOARD_EVENT_FE_LOCK,
+	BOARD_EVENT_FE_UNLOCK,
+	BOARD_EVENT_DEMOD_LOCK,
+	BOARD_EVENT_DEMOD_UNLOCK,
+	BOARD_EVENT_RECEPTION_MAX_4,
+	BOARD_EVENT_RECEPTION_3,
+	BOARD_EVENT_RECEPTION_2,
+	BOARD_EVENT_RECEPTION_1,
+	BOARD_EVENT_RECEPTION_LOST_0,
+	BOARD_EVENT_MULTIPLEX_OK,
+	BOARD_EVENT_MULTIPLEX_ERRORS
+};
+
+int sms_board_event(struct smscore_device_t *coredev,
+		enum SMS_BOARD_EVENTS gevent);
+
 int sms_board_setup(struct smscore_device_t *coredev);
 
 #define SMS_LED_OFF 0



      
